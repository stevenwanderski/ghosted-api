class V1::MilestonesController < ApplicationController
  def show
    milestone = Milestone.find(params[:id])
    render json: MilestoneSerializer.serialize(milestone)
  end

  def issues
    milestone = Milestone.find(params[:id])
    render json: IssueSerializer.serialize(milestone.issues, is_collection: true)
  end
end