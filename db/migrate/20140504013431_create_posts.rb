class CreatePosts < ActiveRecord::Migration

  def self.up
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.timestamps
    end
    
    create_table :users do |u|
      u.string :username
      u.string :first_name
      u.string :last_name
      u.string :user_type
      u.string :password_salt
      u.string :password_hash
      u.timestamps
    end
  
  end

  def self.down
    drop_table :posts
    drop_table :users
  end

end
