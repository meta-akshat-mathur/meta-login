class CreateOneTimePasswords < ActiveRecord::Migration
  def change
    create_table :one_time_passwords do |t|
      t.string :mobile, index: true, :null => false
      t.string :otp_code, limit: 20, :null => false
      t.datetime :suspended_at
      t.integer :send_count, :default => 0, :null => false

      t.timestamps null: false
    end
  end
end
