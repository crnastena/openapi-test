# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::TestersController, type: :request do
  describe "#index" do
    it "returns hello" do
      puts api_v1_testers_path
      get api_v1_testers_path

      expect(response.status).to eq(200)
    end
  end
end
