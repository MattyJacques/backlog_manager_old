require 'rails_helper'

RSpec.describe "API::V1::IGDBs", type: :request do
  describe "GET /search" do
    it "returns http success" do
      get "/api/v1/igdb/search"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /import" do
    it "returns http success" do
      get "/api/v1/igdb/import"
      expect(response).to have_http_status(:success)
    end
  end

end
