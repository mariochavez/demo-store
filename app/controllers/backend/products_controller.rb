class Backend::ProductsController < ApplicationController
  before_action :authenticate!

  def index
    @products = Product.find_products current_admin
  end

  def new
    @product = Product.new price: 0.0, inventory: 0, active: true, infinite: false
    (5 - @product.images.count).times { @product.images.build }
  end

  def edit
    @product = Product.find_product params[:id], current_admin

    if @product
      (5 - @product.images.count).times { @product.images.build }
      render :edit
    else
      redirect_to backend_products_path, alert: t('not_found', resource: Product.model_name.human)
    end
  end

  def create
    @product = Product.new product_params
    @product.admin = current_admin

    redirect_to backend_products_path, notice: t('flash.action.notice.create', resource: @product.class.model_name.human) and return if @product.save

    flash.now[:alert] = t('flash.action.alert.create', resource: @product.class.model_name.human)
    render :new
  end

  def update
    @product = Product.find_product params[:id], current_admin

    if @product
      redirect_to backend_products_path, notice: t('flash.action.notice.update', resource: @product.class.model_name.human) and return if @product.update_attributes(product_params)
    end
  end

protected
  def product_params
    params.require(:product).permit(:name, :description, :price, :inventory, :active, :tags, :infinite, images_attributes: [:picture])
  end
end
