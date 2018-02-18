class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.integer :contact_id
      t.string :number

      t.timestamps null: false
    end
  end
end
