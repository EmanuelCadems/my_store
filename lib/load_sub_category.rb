#encoding:utf-8
class Subcategory
  def self.load(url, categories)
    url["ftp://torcaweb"] = "ftp://"+ENV["USER_FTP"]+":"+ENV["PASSWORD_FTP"]

    open("./tmp/sub_categories.csv", 'wb') do |file|
      file << open(url).read
    end

    require 'csv'

    sub_categories_1 = Hash.new

    CSV.foreach("./tmp/sub_categories.csv", {:quote_char =>'"', :col_sep =>";"}) do |sub_category_1|
      if sub_category_1[1] != 'DESCRIPCION'
        parent = Spree::Taxon.find(categories[sub_category_1[2]])

        sub_category = Spree::Taxon.create!(
          name: sub_category_1[1],
          parent_id: parent.id,
          taxonomy_id: parent.taxonomy.id
          )

        if sub_category
          sub_categories_1[sub_category_1[0]] = sub_category.id
        end
      end
    end

    sub_categories_1
  end
end
