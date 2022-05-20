Resolving dependencies...
class HulloController < ApplicationController
  def index
    render json: { message: "Hullo" }, status: :ok
  end
end
