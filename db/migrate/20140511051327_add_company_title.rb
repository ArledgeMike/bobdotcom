class AddCompanyTitle < ActiveRecord::Migration
  def change
        add_column :users, :company_title, :string
  end
end
