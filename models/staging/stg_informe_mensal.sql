with source as (

    select * from {{ source('fii_guia', 'informe_mensal') }}

),

renamed as (

    select
        id_documento,
        nome_fundo,
        cnpj_fundo,
        publico_alvo,
        prazo_duracao,
        classificacao,
        subclassificacao,
        segmento_atuacao,
        nome_administrador,
        administrador_email,
        ativo_total,
        patrimonio_liquido,
        qtd_cotas_emitidas,
        valor_patr_cotas,
        competencia as dt_competencia,
        inserido_em as dt_insercao
    from source

)

select * from renamed
