from pydantic import BaseModel
from typing import List
from decimal import Decimal

class TopOperadora(BaseModel):
    razao_social: str
    total: Decimal

class EstatisticasResponse(BaseModel):
    total_despesas: Decimal
    media_geral: Decimal
    top_5_operadoras: List[TopOperadora]

    class Config:
        from_attributes = True