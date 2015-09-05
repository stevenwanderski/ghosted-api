class V1::IssuesController < ApplicationController
  before_filter :assign_milestone, only: [:create]
  before_filter :assign_repo, only: [:create]
  before_filter :convert_jsonapi_params, only: [:create, :update]
  before_filter :verify_weights_format, only: [:weights]

  def weights
    weights_params.each do |key, value|
      Issue.where(id: value[:id]).update_all(weight: value[:weight])
    end
    render json: { success: true }
  end

  def update
    issue = Issue.find(params[:id])
    result = client.update_issue(issue.repo.full_name, issue.number, issue_params)
    issue.update!(
      issue_id: result.id,
      title: result.title,
      number: result.number,
      state: result.state
    )
    render json: IssueSerializer.serialize(issue)
  end

  def show
    issue = Issue.find(params[:id])
    render json: IssueSerializer.serialize(issue)
  end

  private

  def weights_params
    params.require(:weights)
  end

  def verify_weights_format
    weights_params.each do |key, value|
      if value[:id].nil? || value[:weight].nil?
        return render json: { errors: "The `weight` param must contain an array objects in the following format: { id: [string], weight: [integer] }"}
      end
    end
  end

  def convert_jsonapi_params
    params[:issue] = params[:data][:attributes]
  end

  def issue_params
    params.require(:issue).permit(:title, :state)
  end

  def assign_milestone
    @milestone = Milestone.find(params[:milestone_id])
  end

  def assign_repo
    @repo = Repo.find(params[:repo_id])
  end

  def client
    Octokit::Client.new(access_token: @user.access_token)
  end
end