class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones, id: :uuid do |t|
      t.uuid :repo_id, null: false
      t.integer :milestone_id, null: false
      t.integer :number, null: false
      t.string :state, null: false
      t.text :title, null: false
      t.text :body
      t.integer :weight, null: false, default: 0

      t.timestamps null: false
    end
  end
end
