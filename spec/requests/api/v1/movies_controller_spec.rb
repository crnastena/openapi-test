# frozen_string_literal: true
require "rails_helper"

RSpec.describe Api::V1::MoviesController, type: :request do
  describe "#index" do
    it "returns 200" do
      get api_v1_movies_path

      expect(response.status).to eq(200)
    end
  end
end
