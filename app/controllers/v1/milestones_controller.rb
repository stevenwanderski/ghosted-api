class V1::MilestonesController < ApplicationController
  before_filter :assign_repo, only: [:index, :create]
  before_filter :assign_milestone, only: [:create_issue]
  before_filter :convert_jsonapi_params, only: [:create]
  before_filter :convert_jsonapi_issue_params, only: [:create_issue]

  def show
    milestone = Milestone.find(params[:id])
    render json: MilestoneSerializer.serialize(milestone)
  end

  def create
    client = Octokit::Client.new(access_token: @user.access_token)
    result = client.create_milestone(@repo.full_name, milestone_params[:title])
    milestone = Milestone.new(
      repo_id: @repo.id,
      milestone_id: result.id,
      title: result.title,
      state: result.state,
      number: result.number,
      weight: 0
    )
    if milestone.save
      render json: MilestoneSerializer.serialize(milestone)
    else
      render json: { errors: milestone.errors }, status: :unprocessable_entity
    end
  end

  def issues
    milestone = Milestone.find(params[:id])
    render json: IssueSerializer.serialize(milestone.issues.order(:weight), is_collection: true)
  end

  def create_issue
    client = Octokit::Client.new(access_token: @user.access_token)
    result = client.create_issue(@milestone.repo.full_name, issue_params[:title], nil, milestone: @milestone.number)
    issue = Issue.new(
      repo_id: @milestone.repo.id,
      issue_id: result.id,
      milestone_id: @milestone.id,
      title: result.title,
      state: result.state,
      number: result.number,
      weight: 0
    )
    if issue.save
      render json: IssueSerializer.serialize(issue)
    else
      render json: { errors: issue.errors }, status: :unprocessable_entity
    end
  end

  private

  def convert_jsonapi_params
    params[:milestone] = params[:data][:attributes]
  end

  def convert_jsonapi_issue_params
    params[:issue] = params[:data][:attributes]
  end

  def milestone_params
    params.require(:milestone).permit(:title)
  end

  def issue_params
    params.require(:issue).permit(:title, :state)
  end

  def assign_repo
    @repo = Repo.find(params[:repo_id])
  end

  def assign_milestone
    @milestone = Milestone.find(params[:id])
  end
end