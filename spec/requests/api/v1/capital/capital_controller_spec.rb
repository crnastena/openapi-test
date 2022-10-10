require "rails_helper"

RSpec.describe Api::V1::Capital::CapitalController, type: :request do
  describe "#index" do
    it "returns 200" do
      get api_v1_capital_capital_index_path

      expect(response.status).to eq(200)
    end
  end
end
