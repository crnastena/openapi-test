require "rails_helper"

RSpec.describe Api::V1::TaxiController, type: :request do
  describe "#index" do
    it "returns 200" do
      get api_v1_taxi_index_path

      expect(response.status).to eq(200)
    end
  end
end
