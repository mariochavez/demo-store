require "minitest_helper"

describe Image do
  let(:image) { Image.new }

  it 'must be valid' do
    image = Image.new picture: File.new(Rails.root + 'test/fixtures/images/rails.png')

    image.valid?.must_equal true
  end

  it 'must be invalid without image' do
    image.valid?.must_equal false
    image.errors.size.must_equal 1
    image.errors[:image].wont_be_nil
  end
end