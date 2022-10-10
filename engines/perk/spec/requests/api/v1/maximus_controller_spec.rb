require "rails_helper"

RSpec.describe Api::V1::MaximusController, type: :request do
  describe "#index" do
    it "returns 200" do
      get api_v1_maximus_path

      expect(response.status).to eq(200)
    end
  end
end
