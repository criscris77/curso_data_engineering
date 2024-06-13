{% macro obtener_tipo_evento() %}
{{ return(["checkout", "package_shipped", "add_to_cart","page_view"]) }}
{% endmacro %}