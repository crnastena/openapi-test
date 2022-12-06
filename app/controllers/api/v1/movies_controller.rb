# frozen_string_literal: true
class Api::V1::MoviesController < ApplicationController
  def index
    render json: { message: "movies" }, status: :ok
  end
end
