class V1::IssuesController < ApplicationController
  before_filter :verify_weights_format

  def weights
    weights_params.each do |key, value|
      Issue.where(id: value[:id]).update_all(weight: value[:weight])
    end
    render json: { success: true }
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
end