{{config(materialized='table', enabled=true)}}

{% for payment_method in ["bank_transfer", "credit_card", "gift_card"] %}

select
  order_id,

  sum(
    case when payment_method = {{ payment_method }} then amount else 0 end
  ) as {{ payment_method }}_amount,

  sum(amount) as total_amount

from app_data.payments

group by 1

{% endfor %}
