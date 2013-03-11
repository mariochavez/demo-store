class Backend::ProductsController < ApplicationController
  before_action :authenticate!

  def index
    @products = Product.my_products current_admin
  end

  def new
    @product = Product.new price: 0.0, inventory: 0, active: true, infinite: false
    (5 - @product.images.count).times { @product.images.build }
  end

  def create
    @product = Product.new product_params
    @product.admin = current_admin

    redirect_to backend_products_path, notice: t('flash.action.notice.create', resource: @product.class.model_name.human) and return if @product.save

    flash.now[:alert] = t('flash.action.alert.create', resource: @product.class.model_name.human)
    render :new
  end

protected
  def product_params
    params.require(:product).permit(:name, :description, :price, :inventory, :active, :tags, :infinite, images_attributes: [:picture])
  end
end
