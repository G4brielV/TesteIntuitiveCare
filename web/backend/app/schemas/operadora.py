# app/schemas/operadora.py
from pydantic import BaseModel, Field
from typing import Optional, List
from decimal import Decimal

class OperadoraLista(BaseModel):
    cnpj: str
    razao_social: str
    fantasia: Optional[str] = Field(None, alias="nome_fantasia")
    uf: str

    class Config:
        from_attributes = True 
        populate_by_name = True

# DTO para paginação 
class PaginatedOperadoras(BaseModel):
    items: List[OperadoraLista]
    total: int
    next_id: Optional[str] 

# DTO para Histórico de Despesas
class DespesaSchema(BaseModel):
    ano: int
    trimestre: int
    valor_despesa: Decimal

    class Config:
        from_attributes = True

# DTO para Estatísticas
class EstatisticasSchema(BaseModel):
    total_despesas: Decimal
    media_geral: Decimal
    top_5_operadoras: List[dict] 