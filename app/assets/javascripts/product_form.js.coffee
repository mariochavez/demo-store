class ProductForm
  constructor: ->
    ($ '#product_price').inputmask 'decimal'
    ($ '#product_inventory').inputmask 'decimal'
    ($ '#product_infinite').click @clickInfinite
    @clickInfinite(target: '#product_infinite')

  clickInfinite: (e)->
    if ($ e.target).is ':checked'
      ($ '#product_inventory').val '-1'
      ($ '#product_inventory').prop 'readonly', 'true'
    else
      ($ '#product_inventory').removeAttr 'readonly'


App.Form.ProductForm = ProductForm
