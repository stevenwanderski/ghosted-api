class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues, id: :uuid do |t|
      t.uuid :repo_id, null: false
      t.text :title, null: false
      t.text :body
      t.string :state, null: false
      t.integer :number, null: false
      t.integer :issue_id, null: false
      t.integer :weight, null: false, default: 0

      t.timestamps null: false
    end
  end
end
