class Link < ActiveRecord::Migration
  def change
    add_column :posts, :post_link, :string
  end
end
