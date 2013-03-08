class ProductForm
  constructor: ->
    ($ '#product_price').inputmask('decimal')
    ($ '#product_inventory').inputmask('decimal')
    ($ '#product_infinite').click(->
      if ($ this).is(':checked')
        ($ '#product_inventory').val '-1'
        ($ '#product_inventory').prop 'readonly', 'true'
      else
        ($ '#product_inventory').prop 'readonly', 'false'
    )

App.Form.ProductForm = ProductForm
