BEGIN;

-- Criando tabelas de Stage (todos os campos como TEXT para evitar erro de cast no import)
CREATE TEMP TABLE stage_despesas (
    valor_despesa TEXT, 
	ano TEXT, 
	trimestre TEXT, 
	cnpj TEXT, 
	razao_social TEXT
);

CREATE TEMP TABLE stage_cadop (
    registro_ans TEXT, 
	cnpj TEXT, 
	razao_social TEXT, 
	nome_fantasia TEXT, 
	modalidade TEXT,
    logradouro TEXT, 
	numero TEXT, 
	complemento TEXT, 
	bairro TEXT, 
	cidade TEXT, 
	uf TEXT,
    cep TEXT, 
	ddd TEXT, 
	telefone TEXT, 
	fax TEXT, 
	email TEXT,
	representante TEXT,
    cargo_representante TEXT, 
	regiao_comercializacao TEXT, 
	data_registro_ans TEXT
);


CREATE TEMP TABLE stage_agregados (
	razao_social TEXT,
    uf TEXT,
    total_despesas TEXT,
    std_despesas TEXT,
    media_trimestre_1 TEXT,
    media_trimestre_2 TEXT,
    media_trimestre_3 TEXT
);


-- Comandos de Importação (Encoding UTF-8)
\copy stage_despesas FROM 'C:/Users/eu/Documents/IntuitiveCare/downloads/2025/extraido/consolidado/consolidado_despesas.csv' WITH (FORMAT CSV, HEADER, ENCODING 'UTF8');
\copy stage_cadop FROM 'C:/Users/eu/Documents/IntuitiveCare/Relatorio_cadop.csv' WITH (FORMAT CSV, HEADER, DELIMITER ';', QUOTE '"', ENCODING 'UTF8');
\copy stage_agregados FROM 'C:/Users/eu/Documents/IntuitiveCare/despesas_agregadas.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'UTF8');

SELECT COUNT(*) AS temp_total_despesas FROM stage_despesas;
SELECT COUNT(*) AS temp_total_cadop FROM stage_cadop;
SELECT COUNT(*) AS temp_stage_agregados FROM stage_agregados;

INSERT INTO operadoras (
    registro_ans, cnpj, razao_social, nome_fantasia, modalidade, 
    logradouro, numero, complemento, bairro, cidade, uf, 
    cep, ddd, telefone, fax, email, representante, 
    cargo_representante, regiao_comercializacao, data_registro_ans
)
SELECT 
    registro_ans, 
    cnpj, 
    COALESCE(razao_social, 'RAZAO SOCIAL NAO INFORMADA'), 
    nome_fantasia, 
    modalidade,
    logradouro, 
    numero, 
    complemento, 
    bairro, 
    cidade, 
    LEFT(uf, 2), -- Garante 2 caracteres
    cep, 
    ddd, 
    telefone, 
    fax, 
    email, 
    representante,
    cargo_representante, 
    NULLIF(TRIM(regiao_comercializacao), '')::INT,
    CASE 
        WHEN data_registro_ans ~ '^\d{4}-\d{2}-\d{2}$' THEN CAST(data_registro_ans AS DATE)
        ELSE NULL 
    END
FROM stage_cadop;

INSERT INTO despesas_consolidadas (cnpj, valor_despesa, ano, trimestre)
SELECT 
    NULLIF(TRIM(cnpj), ''), 
    -- Tenta converter para numérico; se falhar ou for string inválida, assume 0.00
    COALESCE(NULLIF(REPLACE(regexp_replace(valor_despesa, '[^0-9,\.]', '', 'g'),',','.'),'')::NUMERIC,0.00),
    CAST(ano AS INT),
    CAST(trimestre AS INT)
FROM stage_despesas
WHERE cnpj IS NOT NULL AND cnpj != ''; -- Rejeita se não houver identificador (CNPJ)

INSERT INTO despesas_agregadas_resumo (
    razao_social, 
    uf, 
    total_despesas, 
    std_despesas, 
    media_trimestre_1, 
    media_trimestre_2, 
    media_trimestre_3
)
SELECT 
    TRIM(razao_social),
    UPPER(LEFT(TRIM(uf), 2)), -- Garante que UF tenha apenas 2 caracteres em maiúsculas
    -- Tratamento de números: remove possíveis espaços e garante o cast para NUMERIC
    CAST(NULLIF(TRIM(total_despesas), '') AS NUMERIC),
    CAST(NULLIF(TRIM(std_despesas), '') AS NUMERIC),
    CAST(NULLIF(TRIM(media_trimestre_1), '') AS NUMERIC),
    CAST(NULLIF(TRIM(media_trimestre_2), '') AS NUMERIC),
    CAST(NULLIF(TRIM(media_trimestre_3), '') AS NUMERIC)
FROM stage_agregados
ON CONFLICT (razao_social, uf) DO UPDATE SET
    total_despesas = EXCLUDED.total_despesas;

SELECT COUNT(*) AS total_despesas FROM despesas_consolidadas;
SELECT COUNT(*) AS total_cadop FROM operadoras;
SELECT COUNT(*) AS stage_agregados FROM despesas_agregadas_resumo;

COMMIT;