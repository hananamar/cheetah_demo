class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku
      t.string :barcode
      t.string :photo_url
      t.string :producer
      t.integer :price

      t.timestamps null: false
    end
  end
end
