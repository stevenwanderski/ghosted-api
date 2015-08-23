class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos, id: :uuid do |t|
      t.integer :repo_id, null: false
      t.text :name, null: false
      t.text :full_name, null: false
      t.boolean :favorite, default: false
      t.boolean :issues_loaded, default: false
      t.boolean :milestones_loaded, default: false

      t.timestamps null: false
    end

    add_index :repos, :repo_id, unique: true
  end
end