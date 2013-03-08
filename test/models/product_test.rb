require "minitest_helper"

describe Product do
  let(:product) { Product.new }
  let(:params) {
    { name: 'Product 1', description: 'One product',
    price: 1.0, inventory: 1.0, active: true }
  }

  describe 'validations' do
    it 'must be valid' do
      params.merge!({ admin_id: admins('one').id })

      product = Product.new params

      product.valid?.must_equal true
    end

    it 'must be invalid with out attributes' do
      product.valid?.must_equal false

      product.errors.size.must_equal 9
      product.errors[:name].wont_be_nil
      product.errors[:price].wont_be_nil
      product.errors[:inventory].wont_be_nil
      product.errors[:description].wont_be_nil
      product.errors[:active].wont_be_nil
    end

    it 'must be invalid with invalid attributes' do
      params.merge!({ price: -1, inventory: -2, active: 'invalid',
                      admin_id: admins('one').id })

      product = Product.new params

      product.valid?.must_equal false
      product.errors.size.must_equal 3
      product.errors[:price].wont_be_nil
      product.errors[:inventory].wont_be_nil
      product.errors[:active].wont_be_nil
    end
  end

  describe 'infinite inventory' do
    it 'must have an inventory of -1 when inventory is infinite' do
      params.merge!({ inventory: 200, infinite: true })

      product = Product.new params

      product.inventory.must_equal -1
    end

    it 'must have infinity inventory when inventory is -1' do
      params.merge!({ inventory: -1 })

      product = Product.new params

      product.infinite.must_equal true
    end
  end
end
