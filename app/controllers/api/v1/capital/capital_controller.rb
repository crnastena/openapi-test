# frozen_string_literal: true

class Api::V1::Capital::CapitalController < ApplicationController
  def index
    render json: { message: "capital" }, status: :ok
  end
end
