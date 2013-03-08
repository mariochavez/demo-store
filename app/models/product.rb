class Product < ActiveRecord::Base
  belongs_to :admin

  validates :name, :description, :price, :inventory, :active, :admin_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :inventory, numericality: { integer_only: true, greater_than_or_equal_to: -1 }
  validates :active, inclusion: { in: [true, false] }

  def infinite=(value)
    self.inventory = -1 if value == true
    @infinite == value
  end

  def infinite
    @infinite = self.inventory == -1
  end
end
