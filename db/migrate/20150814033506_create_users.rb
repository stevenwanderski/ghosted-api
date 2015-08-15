class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.integer :github_id, null: false
      t.string :username, null: false
      t.string :avatar, null: false
      t.string :encrypted_access_token, null: false
      t.jsonb :meta, default: {}

      t.timestamps null: false
    end
  end
end
