# frozen_string_literal: true
class Api::V1::TaxiController < ApiController
  def index
    render json: { message: "taxi" }, status: :ok
  end
end
