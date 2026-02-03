from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models.models import Operadora
from app.schemas.operadora import PaginatedOperadoras
from app.models.models import Operadora, DespesaConsolidada
from app.schemas.operadora import PaginatedOperadoras, DespesaSchema
from typing import List
from sqlalchemy import func

router = APIRouter()

# 1. Listar todas as operadoras (Paginação Offset para facilitar o seu Vue.js)
@router.get("/", response_model=PaginatedOperadoras)
def list_operadoras(
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db)
):
    offset = (page - 1) * limit
    total = db.query(Operadora).count()
    items = db.query(Operadora).offset(offset).limit(limit).all()
    
    return {
        "items": items,
        "total": total,
        "next_id": str(page + 1) if (offset + limit) < total else None
    }

# 2. Detalhes de uma operadora específica
@router.get("/{cnpj}")
def get_operadora(cnpj: str, db: Session = Depends(get_db)):
    operadora = db.query(Operadora).filter(Operadora.cnpj == cnpj).first()
    if not operadora:
        raise HTTPException(status_code=404, detail="Operadora não encontrada")
    return operadora

# 3. Histórico de Despesas
@router.get("/{cnpj}/despesas", response_model=List[DespesaSchema])
def get_despesas(cnpj: str, db: Session = Depends(get_db)):
    despesas = db.query(DespesaConsolidada)\
        .filter(DespesaConsolidada.cnpj == cnpj)\
        .order_by(DespesaConsolidada.ano.desc(), DespesaConsolidada.trimestre.desc())\
        .all()
    return despesas
