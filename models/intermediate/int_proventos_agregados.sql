select
    ticker,
    dt_base,
    dt_pagamento,
    sum(coalesce(valor_provento, 0)) as total_proventos,
    row_number() over (partition by ticker order by dt_base desc) as rn
from {{ ref('stg_dividendos') }}
where 1 = 1
    and ticker is not null
    and length(ticker) = 6
group by ticker, dt_base, dt_pagamento
