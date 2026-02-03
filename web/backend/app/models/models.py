from sqlalchemy import Column, String, Integer, Numeric, ForeignKey, CHAR, TIMESTAMP, DATE, CheckConstraint, func
from app.core.database import Base

class Operadora(Base):
    __tablename__ = "operadoras"
    cnpj = Column(String(14), primary_key=True, index=True)
    registro_ans = Column(String(20))
    razao_social = Column(String(255), nullable=False)
    nome_fantasia = Column(String(255))
    modalidade = Column(String(100), index=True)
    logradouro = Column(String(255))
    numero = Column(String(20))
    complemento = Column(String(100))
    bairro = Column(String(100))
    cidade = Column(String(100))
    uf = Column(CHAR(2), index=True)
    cep = Column(String(8))
    ddd = Column(String(2))
    telefone = Column(String(15))
    fax = Column(String(15))
    email = Column(String(150))
    representante = Column(String(150))
    cargo_representante = Column(String(100))
    regiao_comercializacao = Column(Integer)
    data_registro_ans = Column(DATE)

class DespesaConsolidada(Base):
    __tablename__ = "despesas_consolidadas"

    id = Column(Integer, primary_key=True, autoincrement=True)
    cnpj = Column(String(14), ForeignKey("operadoras.cnpj"), index=True)
    valor_despesa = Column(Numeric(19, 2), nullable=False)
    ano = Column(Integer, nullable=False)
    trimestre = Column(Integer, nullable=False)
    data_carga = Column(TIMESTAMP, server_default=func.now())

    __table_args__ = (
        CheckConstraint('trimestre BETWEEN 1 AND 4', name='check_trimestre'),
    )

class DespesaAgregadaResumo(Base):
    __tablename__ = "despesas_agregadas_resumo"

    razao_social = Column(String(255), primary_key=True)
    uf = Column(CHAR(2), primary_key=True)
    total_despesas = Column(Numeric(18, 2))
    std_despesas = Column(Numeric(18, 2))
    media_trimestre_1 = Column(Numeric(19, 3))
    media_trimestre_2 = Column(Numeric(19, 3))
    media_trimestre_3 = Column(Numeric(19, 3))