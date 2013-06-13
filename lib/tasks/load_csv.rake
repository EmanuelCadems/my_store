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
      available_on:   row[2],
      price:          row[3],
      on_hand:        row[4],
      cost_price:     row[5],
      cost_currency:  row[6])

    index = 12

    while row[index].nil? || index == 6 do
      index -= 1
    end

    taxon = Spree::Taxon.find_by_name(row[index])
    candidate_taxon = taxon

    if taxon
      ok = true

      while taxon.parent != nil and taxon.name == row[index] do
        if taxon.name != row[index]
          ok = false
        end

        taxon = taxon.parent
        index -=1
      end

      if ok
        product.taxons << candidate_taxon
      end
    end

    index = 15

    while row[index].nil? || index == 12 do
      index -= 1
    end

    while index > 12 do
      image = Spree::Image.new
      image.attachment_from_url(row[index])
      image.save

      product.images << image
      index -= 1
    end
  end

end
