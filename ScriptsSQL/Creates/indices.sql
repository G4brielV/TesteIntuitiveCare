CREATE INDEX idx_despesas_cnpj_ano ON despesas_consolidadas(cnpj, ano);
CREATE INDEX idx_operadoras_uf ON operadoras(uf);
CREATE INDEX idx_operadoras_modalidade ON operadoras(modalidade);