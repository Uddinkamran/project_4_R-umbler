class CreatePosts < ActiveRecord::Migration[5.0]
    def up
        create_table :posts do |t|
          t.string  :text
          t.integer :user_id
        end
      end
    
    
    def down
        drop_table :post
      end
    end