require 'minitest_helper'

feature 'product management' do

  describe 'without javascript' do
    background do
      @admin = login_admin
    end

    scenario 'Add new product' do
      visit '/backend/products'

      click_link 'Agregar producto'

      within('#new_product') do
        fill_in 'product_name', with: 'Product 1'
        fill_in 'product_description', with: 'Product description'
        fill_in 'product_price', with: '1.0'
        fill_in 'product_inventory', with: '1'
        fill_in 'product_tags', with: 'electronics, home'
      end

      click_button 'Agregar producto'

      assert page.has_content? 'Producto fue creado(a)'
    end

    scenario 'Fail to add product with errors' do
      visit '/backend/products'

      click_link 'Agregar producto'

      within('#new_product') do
        fill_in 'product_description', with: 'Product description'
        fill_in 'product_price', with: '1.0'
        fill_in 'product_inventory', with: '1'
        fill_in 'product_tags', with: 'electronics, home'
      end

      click_button 'Agregar producto'

      assert page.has_content? 'Fallo la creacion de Producto'
    end

    scenario 'Get a list of current logged admin' do
      Product.create name: 'Product 1', description: 'Some description',
        price: 1.0, inventory: 1, active: true, admin: @admin
      other_admin = Admin.create email: 'other@user.com',
        password: 'password', password_confirmation: 'password'
      Product.create name: 'Product 1', description: 'Some description',
        price: 1.0, inventory: 1, active: true, admin: other_admin

      visit '/backend/products'

      all('.product').size.must_equal 1
    end

    scenario 'Add product with an image' do
      file = Rails.root.join('test', 'fixtures', 'images', 'rails.png')

      visit '/backend/products'

      click_link 'Agregar producto'

      within('#new_product') do
        fill_in 'product_name', with: 'Product 1'
        fill_in 'product_description', with: 'Product description'
        fill_in 'product_price', with: '1.0'
        fill_in 'product_inventory', with: '1'
        fill_in 'product_tags', with: 'electronics, home'
        attach_file 'product_images_attributes_0_picture', file
      end

      click_button 'Agregar producto'

      all('.product .image').size.must_equal 1
    end
  end

  describe 'with javascript' do
    background do
      use_javascript
      login_admin
    end

    scenario 'Add product with infinite inventory' do

      visit '/backend/products'

      click_link 'Agregar producto'

      within('#new_product') do
        fill_in 'product_name', with: 'Product 1'
        fill_in 'product_description', with: 'Product description'
        fill_in 'product_price', with: '1'
        check 'product_infinite'
        fill_in 'product_tags', with: 'electronics, home'
      end

      click_button 'Agregar producto'

      assert page.has_content? 'Producto fue creado(a)'
    end
  end
end
