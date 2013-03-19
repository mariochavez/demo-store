class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false, limit: 150
      t.text :description, null: false
      t.decimal :price, precision: 5, scale: 2, default: 0.0
      t.integer :inventory, default: 0
      t.boolean :active, null: false
      t.string :tags
      t.references :admin, index: true

      t.timestamps
    end
  end
end
