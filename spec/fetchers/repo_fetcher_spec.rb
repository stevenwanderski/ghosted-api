require 'rails_helper'

RSpec.describe RepoFetcher do
  context "#save_repos" do
    it "saves repos that do not already exist and returns the ids" do
      repo = create(:repo, repo_id: 1)
      user = create(:user)
      repos_to_save = [
        double(id: 2, name: "repo-2", full_name: "repo/repo-2"),
        double(id: 3, name: "repo-3", full_name: "repo/repo-3"),
        double(id: repo.repo_id, name: repo.name, full_name: repo.full_name)
      ]

      ids = RepoFetcher.new(user).save_repos(repos_to_save)

      expect(Repo.count).to eq(3)
      expect(ids.count).to eq(2)
    end
  end

  context "#save_user_repos" do
    it "saves user repos for passed repo ids" do
      repo1 = create(:repo)
      repo2 = create(:repo)
      user = create(:user)

      ids = RepoFetcher.new(user).save_user_repos([repo1.id, repo2.id])

      expect(UserRepo.count).to eq(2)
      expect(ids.count).to eq(2)
    end
  end
end
