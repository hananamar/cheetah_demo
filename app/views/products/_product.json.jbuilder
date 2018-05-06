json.extract! product, :id, :name, :sku, :barcode, :photo_url, :producer, :price, :created_at, :updated_at
json.url product_url(product, format: :json)
