from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.core.database import get_db
from app.models.models import DespesaAgregadaResumo
from app.schemas.estatisticas import EstatisticasResponse

router = APIRouter()

# Estatísticas (Usando a tabela de resumo para performance)
@router.get("/estatisticas")
def get_estatisticas(db: Session = Depends(get_db)):
    stats = db.query(
        func.sum(DespesaAgregadaResumo.total_despesas).label("total"),
        func.avg(DespesaAgregadaResumo.total_despesas).label("media")
    ).first()

    # Top 5 operadoras
    top_5 = db.query(
        DespesaAgregadaResumo.razao_social, 
        DespesaAgregadaResumo.total_despesas
    ).order_by(DespesaAgregadaResumo.total_despesas.desc())\
     .limit(5).all()

    return {
        "total_despesas": stats.total or 0,
        "media_geral": stats.media or 0,
        "top_5_operadoras": [{"razao_social": row[0], "total": row[1]} for row in top_5]
    }