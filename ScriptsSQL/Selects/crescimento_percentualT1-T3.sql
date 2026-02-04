WITH despesas_t1 AS (
    SELECT cnpj, SUM(valor_despesa) as total_t1
    FROM despesas_consolidadas
    WHERE trimestre = 1 AND ano = 2025
    GROUP BY cnpj
),
despesas_t3 AS (
    SELECT cnpj, SUM(valor_despesa) as total_t3
    FROM despesas_consolidadas
    WHERE trimestre = 3 AND ano = 2025
    GROUP BY cnpj
)
SELECT 
    o.razao_social,
    t1.total_t1,
    t3.total_t3,
    ROUND(((t3.total_t3 - t1.total_t1) / NULLIF(t1.total_t1, 0)) * 100, 2) as crescimento_pct
FROM despesas_t1 t1
JOIN despesas_t3 t3 ON t1.cnpj = t3.cnpj
JOIN operadoras o ON t1.cnpj = o.cnpj
ORDER BY crescimento_pct DESC
LIMIT 5;