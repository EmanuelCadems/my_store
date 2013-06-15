class AddCrossedOutPriceToSpreeVariants < ActiveRecord::Migration
  def change
    add_column :spree_variants, :crossed_out_price, :decimal, :precision => 8, :scale => 2
  end
end
