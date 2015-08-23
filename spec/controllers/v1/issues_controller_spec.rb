require 'rails_helper'

RSpec.describe V1::IssuesController, type: :controller do
  before(:each) do
    @user = create(:user)
    request.headers['HTTP_USER_ID'] = @user.id
    request.headers['HTTP_ACCESS_TOKEN'] = @user.access_token
  end

  context "before_filters" do
    context "#assign_repo" do
      it "returns 422 if the `repo_id` param is not supplied" do
        get :index

        expect(response.response_code).to eq(422)
      end
    end

    context "#check_for_loaded_issues" do
      it "calls `populate_issues` on the repo if issues have not been populated" do
        repo = create(:repo, issues_loaded: false, milestones_loaded: true)
        issue_fetcher = IssueFetcher.new(repo, @user.access_token)
        allow_any_instance_of(IssueFetcher).to receive(:issues).and_return([])

        expect_any_instance_of(IssueFetcher).to receive(:fetch)

        get :index, repo_id: repo.id
      end
    end
  end
end
