with orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select order_id,
    sum(case when payment_status = 'success' then payment_amount end) as payment_amount
     from {{ ref('stg_payments') }}
     group by order_id
),


final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(payments.payment_amount,0) as payment_amount


    from orders

    left join payments using (order_id)

)

select * from final