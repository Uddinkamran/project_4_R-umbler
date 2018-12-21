class CreateUsers < ActiveRecord::Migration[5.0]
def up
    create_table :users do |t|
      t.string  :email
      t.string  :password
      t.string :firstName
      t.string :lastName
      t.string :phoneNum
      t.string :gender
    end
  end


def down
    drop_table :users
  end
end