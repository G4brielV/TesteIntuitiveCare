CREATE TABLE despesas_agregadas_resumo (
    razao_social VARCHAR(255),
    uf CHAR(2),
    total_despesas NUMERIC(18, 2),
    std_despesas NUMERIC(18, 2),
    media_trimestre_1 NUMERIC(19, 3),
    media_trimestre_2 NUMERIC(19, 3),
    media_trimestre_3 NUMERIC(19, 3),
    PRIMARY KEY (razao_social, uf)
);