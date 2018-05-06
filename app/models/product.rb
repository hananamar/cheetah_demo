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

  def self.update_from_csv
    require 'csv'
    # csv_text = File.read(CSV_FILE_PATH)
    csv_text = File.read(TEST_CSV_FILE_PATH)
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      my_create_or_update(row.to_hash)
    end
  end

  def self.my_create_or_update(csv_row_hash)
    # create a hash that can be sent to update_attributes method
    product_hash = ATTRS_TO_HEADERS.each_with_object({}){|(k,v),h| h[k] = csv_row_hash[v] }

    # find or create, then update attrs
    unless product_hash[:sku].nil?
      product = find_or_create_by(sku: product_hash[:sku])
      product.update_attributes!(product_hash)
    end
  end
end
