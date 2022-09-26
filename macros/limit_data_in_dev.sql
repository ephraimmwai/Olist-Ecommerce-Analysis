{% macro limit_data_in_dev(column_name,days=30) %}

    {% if target.dev=='dev' %}
        where {{ column_name }} >= date_sub(current_date, interval {{ days }} day)
    {%endif%}

{% endmacro %}
