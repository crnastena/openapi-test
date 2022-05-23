# frozen_string_literal: true

class HulloController < ApplicationController
  def index
    render json: { message: "Hullo" }, status: :ok
  end
end
