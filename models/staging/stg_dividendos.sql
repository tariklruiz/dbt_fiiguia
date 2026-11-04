with source as (

    select * from {{ source('fii_guia', 'dividendos') }}

),

renamed as (

    select
        id_documento,
        cod_negociacao as ticker,
        cnpj_fundo,
        data_base      as dt_base,
        data_pagamento as dt_pagamento,
        valor_provento
    from source

)

select * from renamed
