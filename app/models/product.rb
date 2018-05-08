class Product < ActiveRecord::Base
  CSV_FILE_PATH = "#{Rails.root}/lib/catalog.csv".freeze
  TEST_CSV_FILE_PATH = "#{Rails.root}/lib/catalog_test.csv".freeze

  ATTRS_TO_HEADERS = { # map attribute names in DB to cloumn names in CSV file
    name: 'product_name',
    sku: 'sku (unique_id)',
    barcode: 'barcode',
    photo_url: 'photo_url',
    producer: 'producer',
    price: 'price_cents',
  }.freeze

  self.per_page = 30

  # Class methods
  def self.update_from_csv(path: CSV_FILE_PATH)
    require 'csv'
    csv_text = File.read(path)
    csv = CSV.parse(csv_text, :headers => true)
    sku_hash = csv.each_with_object({}){|row, h| h[row[ATTRS_TO_HEADERS[:sku]]] = row_to_product_hash(row)}

    transaction do
      existing_products = Product.where(sku: sku_hash.keys).all
      existing_products.each do |product|
        product.update_attributes!(sku_hash.delete(product.sku)) # update attributes and remove from sku_hash
      end

      sku_hash.each do |sku, product_hash|
        create!(product_hash) unless sku.nil?
      end
    end
  end

  def self.row_to_product_hash(row)
    # create a hash that can be sent to update_attributes method
    ATTRS_TO_HEADERS.each_with_object({}){|(k,v), h| h[k] = row.to_hash[v] || '' }
  end

## decided this was too much
  # def self.find_or_create_product(hash)
  #   # find or create, then update attributes
  #   find_or_create_by(sku: hash[:sku]).update_attributes!(hash)
  # end
end
