class Product < ActiveRecord::Base
  belongs_to :admin
  has_many :images

  validates :name, :description, :price, :inventory, :admin_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :inventory, numericality: { integer_only: true, greater_than_or_equal_to: -1 }
  validates :active, inclusion: { in: [true, false] }

  accepts_nested_attributes_for :images, allow_destroy: true

  scope :find_products, ->(admin) { where(admin_id: admin.id) }

  class << self
    def find_product(id, admin)
      where(id: id, admin_id: admin.id).first
    end
  end

  def infinite=(value)
    self.inventory = -1 if value == true
    @infinite == value
  end

  def infinite
    @infinite = self.inventory == -1
  end
end
