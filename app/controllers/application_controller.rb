class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_filter :authorize_user

  private

  def authorize_user
    user_id = request.headers['HTTP_USER_ID']
    access_token = request.headers['HTTP_ACCESS_TOKEN']

    @user = User.find(user_id)

    if @user.access_token != access_token
      render_unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    render_unauthorized
  end

  def render_unauthorized
    render json: { errors: "Unauthorized user" }, status: :unauthorized
  end
end
