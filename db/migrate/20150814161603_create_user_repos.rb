class CreateUserRepos < ActiveRecord::Migration
  def change
    create_table :user_repos, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :repo_id, null: false

      t.timestamps null: false
    end
  end
end
