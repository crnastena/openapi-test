# frozen_string_literal: true

class Api::V1::MovieController < ApplicationController
  def index
    render json: { message: "movie" }, status: :ok
  end
end
