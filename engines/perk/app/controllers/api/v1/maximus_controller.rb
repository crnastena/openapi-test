class Api::V1::MaximusController < ApiController
  def index
    render json: { message: "maximus" }, status: :ok
  end
end
