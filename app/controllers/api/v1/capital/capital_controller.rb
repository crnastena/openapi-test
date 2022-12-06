class Api::V1::Capital::CapitalController < ApplicationController
  def index
    render json: { message: "capital controller" }, status: :ok
  end
end
