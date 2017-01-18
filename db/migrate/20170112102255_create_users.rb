class CreateUsers < ActiveRecord::Migration
  def change
      create_table :users do |t|
          t.string :first_name
          t.string :last_name
          t.string :email, index: true, unique: true
          t.date :dob
          t.string :mobile, index: true, unique: true
          t.datetime :mobile_confirmed_at, index: true
          t.string :gender
          t.string :image # for later purposes

          t.string :address
          t.references :state, index: true
          t.references :district, index: true
          t.references :city, index: true
          t.string :pincode, limit: 6

          t.boolean :is_permanent_address_same_as_current
          t.string :permanent_address
          t.references :permanent_state, index: true
          t.references :permanent_district, index: true
          t.references :permanent_city, index: true
          t.string :permanent_pincode, limit: 6

          t.boolean :is_email_valid
          t.datetime :skip_suspended_at, index: true
          t.text :permission_token
          t.string :status, :default => "active"

          t.references :resource, polymorphic: true, index: true
          t.timestamps null: false
    end
  end
end
