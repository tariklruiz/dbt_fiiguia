with source as (

    select * from {{ source('fii_guia', 'cotahist') }}

),

renamed as (

    select
        cod_neg          as ticker,
        nom_resumido     as nm_ativo,
        dt_pregao,
        preco_ultimo     as preco_fechamento_original,
        preco_ultimo_adj as preco_fechamento,
        vol_negocios,
        num_negocios
    from source

)

select * from renamed
