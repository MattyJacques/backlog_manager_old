require 'rails_helper'

RSpec.describe "Imports", type: :request do
  describe "GET /igdb" do
    it "returns http success" do
      get "/import/igdb"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /psn" do
    it "returns http success" do
      get "/import/psn"
      expect(response).to have_http_status(:success)
    end
  end

end
