require 'csv'
require 'rails_helper'

TEST_HASH_1 = {
  name: 'James Farm Cream Cheese Loaf 3#',
  sku: '65908',
  barcode: '76069500000',
  photo_url: 'https://web.fulcrumapp.com/photos/view?photos=fd66840a-3d55-4b6c-ab3d-02469a24bab5',
  producer: 'JAMES FARM',
  price: '4724'
}
TEST_HASH_2 = {
  name: 'Cont Rec Blk 28z (120 CT)',
  sku: '760535',
  barcode: '4035005012',
  photo_url: '',
  producer: 'Cube Plastics',
  price: '3070'
}

describe Product, '.row_to_product_hash' do
  it 'creates product hash object' do
    csv_text = File.read(Product::TEST_CSV_FILE_PATH)
    csv = CSV.parse(csv_text, :headers => true)
    row = csv[1]
    result = Product.row_to_product_hash(row)
    expect(result).to eq TEST_HASH_1

    row = csv[2]
    result = Product.row_to_product_hash(row)
    expect(result).to eq TEST_HASH_2
  end
end

# describe Product, '.find_or_create_product' do
#   it 'finds existing product or creates it, based on sku' do
#     expect(Product.count).to eq 0 # start with no products
#
#     Product.find_or_create_product(TEST_HASH_1) # create test product 1
#     expect(Product.count).to eq 1
#     expect(Product.first.try(:barcode)).to eq '76069500000'
#
#     Product.find_or_create_product(TEST_HASH_1.dup.tap{|h| h[:barcode] = '111'}) # update test product 1
#     expect(Product.count).to eq 1
#     expect(Product.first.try(:barcode)).to eq '111'
#
#     Product.find_or_create_product(TEST_HASH_1.dup.tap{|h| h[:sku] = '222'}) # create test product 1 (altered)
#     expect(Product.count).to eq 2
#
#     Product.find_or_create_product(TEST_HASH_1.dup.tap{|h| h[:barcode] = '333'}) # update test product 1 again
#     expect(Product.count).to eq 2
#     expect(Product.first.try(:barcode)).to eq '333'
#   end
# end

describe Product, '.update_from_csv' do
  it 'updates database according to csv file' do
    expect(Product.count).to eq 0 # start with no products

    Product.update_from_csv(path: Product::TEST_CSV_FILE_PATH) # create 9 products
    expect(Product.count).to eq 9

    Product.update_from_csv(path: Product::TEST_CSV_FILE_PATH) # update existing products (create 0)
    expect(Product.count).to eq 9

    # NOTE: Many more tests can be performed here to examine that create/update is done correctly. This would require more CSV test files and more hard coded data, but I think this should suffice.
  end
end
