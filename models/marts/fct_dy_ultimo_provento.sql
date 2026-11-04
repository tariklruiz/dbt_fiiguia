-- RECONSTRUÍDO em 2026-11-04 a partir da estrutura da tabela no banco
-- (tabelas não guardam o SQL de origem). Validado contra o backup do original.
--
-- CRITÉRIO: o inner join com a cotahist é um filtro INTENCIONAL. Só entra o
-- último provento de fundos que estavam sendo negociados na data-base desse
-- provento (sem cotação naquele dia, não há preço para calcular o DY).

with proventos as (

    select * from {{ ref('int_proventos_agregados') }}
    where rn = 1

),

cotacoes as (

    select * from {{ ref('stg_cotahist') }}

)

select
    p.ticker,
    p.dt_base,
    p.dt_pagamento,
    c.preco_fechamento,
    p.total_proventos,
    round(p.total_proventos / nullif(c.preco_fechamento, 0) * 100, 2) as dy_pct
from proventos p
inner join cotacoes c
    on  p.ticker  = c.ticker
    and p.dt_base = c.dt_pregao
