with orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payment as (
    select * from {{ ref('stg_stripe__payments') }}
),

order_payments as (
    select
        order_id,
        sum(amount) as total_amount
    from payment
    where status = 'success'
    group by 1
),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.total_amount, 0) as amount

    from orders
    left join order_payments using (order_id)

)

select * from final