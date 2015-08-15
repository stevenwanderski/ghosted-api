class V1::ReposController < ApplicationController
  def index
    render json: @user.repos.order("LOWER(name) ASC")
  end
end