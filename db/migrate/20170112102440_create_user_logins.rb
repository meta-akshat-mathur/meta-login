class CreateUserLogins < ActiveRecord::Migration
  def change
    create_table :user_logins do |t|
      t.string :provider
      t.string :uid, :default => ""
      t.references :user, index: true, null: false
      t.string :token
      t.string :secret

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps
    end
    add_index :user_logins, [:uid, :provider], :unique => true
  end
end
