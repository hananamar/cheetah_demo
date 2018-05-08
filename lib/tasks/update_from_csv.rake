desc 'scheduled create/update products from CSV file'
task :update_from_csv => :environment do

  Product.update_from_csv

end
