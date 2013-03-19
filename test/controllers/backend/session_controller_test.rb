require "minitest_helper"

describe Backend::SessionController do
  describe 'new' do
    it 'success' do

      get :new

      assert_response :success
      assert_template :new
      assigns[:admin].wont_be_nil
    end
  end

  describe 'destroy' do
    it 'destroy user"s session' do
      delete :destroy

      assert_redirected_to backend_sign_in_path
    end
  end

  describe 'create' do
    it 'success with valid credentials' do
      params = { email: 'user@store.com', password: '123pass', password_confirmation: '123pass' }

      Admin.create params

      post :create, admin: params

      assert_redirected_to backend_root_path
      flash.now[:alert].must_be_nil
    end

    it 'fail with invalid credentials' do
      lambda {
        post :create, admin: { email: '', password: '' }
      }.must_raise(ArgumentError)
    end
  end
end
