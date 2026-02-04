SELECT 
    o.uf,
    SUM(d.valor_despesa) as despesa_total,
    COUNT(DISTINCT o.cnpj) as total_operadoras,
    ROUND(SUM(d.valor_despesa) / COUNT(DISTINCT o.cnpj), 2) as media_por_operadora
FROM despesas_consolidadas d
JOIN operadoras o ON d.cnpj = o.cnpj
GROUP BY o.uf
ORDER BY despesa_total DESC
LIMIT 5;