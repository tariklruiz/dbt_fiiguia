with proventos as (
    select * from {{ ref('int_proventos_agregados') }}
    where rn = 1
),
cotacoes as (
    select a.* from {{ ref('stg_cotahist') }} a
    inner join proventos b on a.ticker = b.ticker

),
max_cot as (
    select ticker, max(dt_pregao) as ult_preco from cotacoes
    group by ticker
),
warning_analysis as (
select
    p.ticker,
    p.dt_base,
    p.dt_pagamento,
    c.preco_fechamento,
    d.ult_preco,
    p.total_proventos,
    round(p.total_proventos / nullif(c.preco_fechamento, 0) * 100, 2) as dy_pct,
    case when d.ult_preco is null then 'nao_presente_cotahist'
         when d.ult_preco < p.dt_base then 'sem_negociacao'
         when d.ult_preco > p.dt_base then 'sem_negociacao_na_database'
         else 'ok' end as motivo_perda
from proventos p
left join cotacoes c on  p.ticker  = c.ticker and p.dt_base = c.dt_pregao
left join max_cot d on  p.ticker  = d.ticker
where c.ticker is null
)
select
    motivo_perda,
    count(*) as qtd
from warning_analysis
group by motivo_perda
order by 2 desc