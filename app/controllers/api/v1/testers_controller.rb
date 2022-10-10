# frozen_string_literal: true
class Api::V1::TestersController < ApiController
  def index
    render json: { message: "hello" }, status: :ok
  end
end
