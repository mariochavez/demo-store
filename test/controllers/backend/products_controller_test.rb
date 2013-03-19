require "minitest_helper"

describe Backend::ProductsController do
  before do
    stub_current_admin
  end

  describe 'not logged user' do
    it 'redirects to login' do
      warden.logout(:admin)

      get :index

      assert_redirected_to backend_sign_in_path
    end
  end

  describe 'index' do
    it 'render products list' do
      get :index

      assert_response :success
      assert_template :index
      assigns[:products].wont_be_nil
    end
  end

  describe 'new' do
    it 'renders new product form' do
      get :new

      assert_response :success
      assert_template :new
      assigns[:product].wont_be_nil
    end
  end

  describe 'create' do
    let(:params) {
      { product: { name: 'Product 1', description: 'Product description', price: 1.0, inventory: 1, active: true } }
    }

    it 'create product and redirect to products index' do
      post :create, params

      assert_redirected_to backend_products_path
      flash[:notice].wont_be_nil
    end

    it 'fails to create product and render new form' do
      params[:product].delete(:name)

      post :create, params

      assert_response :success
      assert_template :new
      flash.now[:alert].wont_be_nil
    end
  end

  describe 'edit' do
    it 'render edit product form' do
      get :edit, id: 100

      assert_response :success
      assert_template :edit
      assigns[:product].wont_be_nil
    end

    it 'redirect to products when product not found' do
      get :edit, id: 300

      assert_redirected_to backend_products_path
      flash[:alert].wont_be_nil
    end

    it 'redirect to products when product does not belong to admin' do
      get :edit, id: 200

      assert_redirected_to backend_products_path
      flash[:alert].wont_be_nil
    end
  end

  describe 'update' do
    let(:product) {
      { description: 'Updated description', price: 99.99 }
    }

    it 'updates a product and redirect to products' do
      put :update, id: 100, product: product

      assert_redirected_to backend_products_path
      flash[:notice].wont_be_nil
    end
  end
end
