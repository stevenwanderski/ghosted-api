require 'rails_helper'

RSpec.describe Repo, type: :model do
  context "#save_issues" do
    it "saves all fetched issues" do
      repo = create(:repo, repo_id: 1)
      issues_to_save = [
        double(id: 1, title: "Title1", body: "Body1", number: 1, state: "open"),
        double(id: 2, title: "Title2", body: "Body2", number: 2, state: "open"),
        double(id: 3, title: "Title3", body: "Body3", number: 3, state: "open"),
      ]

      repo.save_issues(issues_to_save)

      expect(Issue.count).to eq(3)
    end
  end

  context "#populate_issues" do
    it "updates `issues_loaded` as true" do
      allow_any_instance_of(Repo).to receive(:fetch_issues).and_return([])
      repo = create(:repo, issues_loaded: false)

      repo.populate_issues('some-token')

      expect(repo.reload.issues_loaded).to eq(true)
    end
  end
end
