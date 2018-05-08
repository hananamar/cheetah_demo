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

    transaction do
      csv.each do |row|
        product_hash = row_to_product_hash(row)
        find_or_create_product(product_hash) unless product_hash[:sku].nil?
      end
    end
  end

  def self.row_to_product_hash(row)
    # create a hash that can be sent to update_attributes method
    ATTRS_TO_HEADERS.each_with_object({}){|(k,v), h| h[k] = row.to_hash[v] || '' }
  end

  def self.find_or_create_product(hash)
    # find or create, then update attributes
    # (seemed better to make ~10k queries than to eager-load to memory ~10k product models)
    find_or_create_by(sku: hash[:sku]).update_attributes!(hash)
  end
end
