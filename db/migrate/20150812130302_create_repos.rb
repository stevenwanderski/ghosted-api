class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos, id: :uuid do |t|
      t.integer :repo_id, null: false
      t.string :name, null: false
      t.jsonb :meta, default: {}

      t.timestamps null: false
    end

    add_index :repos, :repo_id, unique: true
  end
end