class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :full_name 
      t.string :mobile_no 
      t.string :email_id 
      t.string :password_digest 
      t.boolean :terms_of_conditions
      t.timestamps
    end
  end
end
