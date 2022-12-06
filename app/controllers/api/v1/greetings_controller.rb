# frozen_string_literal: true

class Api::V1::GreetingsController < ApplicationController
  def index
    render json: { message: "greetings" }, status: :ok
  end
end
