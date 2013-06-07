#encoding=utf-8
require 'csv'
desc "Load CSV"

task :load_csv => :environment do
  CSV.foreach("./public/taxon.csv", :quote_char => ",") do |taxon|
    if taxon[1] == 'NIL'
      taxonomy = Spree::Taxonomy.create!(
        name: taxon[0]
      )
    else
      subcategory_into_subcategory = Spree::Taxon.find_by_name(taxon[1])

      if subcategory_into_subcategory
        if taxon[1] == subcategory_into_subcategory.name
          Spree::Taxon.create!(
            name: taxon[0],
            parent_id: subcategory_into_subcategory.id,
            taxonomy_id: subcategory_into_subcategory.taxonomy.id)
        end
      end
    end
  end

  CSV.foreach("./public/file.csv", :quote_char => ",") do |row|
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
