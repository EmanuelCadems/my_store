#encoding=utf-8
require 'csv'
desc "Load CSV"

task :load_csv => :environment do
  categories = Hash.new

  require "open-uri"

  url = "ftp://torcaweb@torcasistemas.no-ip.org/exportaciones/finales/Categorias.csv"
  url["ftp://torcaweb"] = "ftp://"+ENV["USER_FTP"]+":"+ENV["PASSWORD_FTP"]

  open("./tmp/categories.csv", 'wb') do |file|
    file << open(url).read
  end

  CSV.foreach("./tmp/categories.csv", :quote_char => '"', :col_sep => ";") do |taxon|
    category = Spree::Taxonomy.create!(name: taxon[1]) unless taxon[1] =='DESCRIPCION'
    if category
      categories[taxon[0]] = category.taxons.find_by_name(category.name).id
    end
  end

  sub_categories1 = Subcategory.load("ftp://torcaweb@torcasistemas.no-ip.org/exportaciones/finales/Subcategorias_1.csv", categories)
  sub_categories2 = Subcategory.load("ftp://torcaweb@torcasistemas.no-ip.org/exportaciones/finales/Subcategorias_2.csv", sub_categories1)
  sub_categories3 = Subcategory.load("ftp://torcaweb@torcasistemas.no-ip.org/exportaciones/finales/Subcategorias_3.csv", sub_categories2)
  Subcategory.load("ftp://torcaweb@torcasistemas.no-ip.org/exportaciones/finales/Subcategorias_4.csv", sub_categories3)

  CSV.foreach("./csv/product.csv", :quote_char => '"',:col_sep => ";") do |row|
    product = Spree::Product.create!(
      sku:            row[0],
      name:           row[1],
      available_on:   row[2].to_datetime,
      price:          row[3].to_d,
      on_hand:        row[4].to_i)

    taxon = nil

    row[6,6].select{|x| x}.each_with_index do |sub_category, index|
      if index == 0
        taxon = Spree::Taxonomy.find_by_name(sub_category).taxons.find_by_name(sub_category)
      else
        taxon = taxon.children.find_by_name(sub_category)
      end
    end

    product.taxons << taxon

    row[12,3].select{|x| x}.each do |ftp|
      ftp["ftp://torcaweb"] = "ftp://"+ENV["USER_FTP"]+":"+ENV["PASSWORD_FTP"]
      image = Spree::Image.new
      image.attachment = open(ftp)
      product.images << image
    end
  end

end
