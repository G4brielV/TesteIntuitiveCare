WITH media_geral AS (
    -- Calcula a média global de despesas por trimestre/operadora
    SELECT AVG(valor_despesa) as media_global 
    FROM despesas_consolidadas
),
comparativo_por_trimestre AS (
    SELECT 
        cnpj,
        -- Atribui 1 se o trimestre superou a média, 0 caso contrário
        CASE WHEN SUM(valor_despesa) > (SELECT media_global FROM media_geral) THEN 1 ELSE 0 END as superou_t1,
        CASE WHEN SUM(valor_despesa) FILTER (WHERE trimestre = 2) > (SELECT media_global FROM media_geral) THEN 1 ELSE 0 END as superou_t2,
        CASE WHEN SUM(valor_despesa) FILTER (WHERE trimestre = 3) > (SELECT media_global FROM media_geral) THEN 1 ELSE 0 END as superou_t3
    FROM despesas_consolidadas
    GROUP BY cnpj
)
SELECT COUNT(*) as total_operadoras_acima_media
FROM comparativo_por_trimestre
WHERE (superou_t1 + superou_t2 + superou_t3) >= 2;