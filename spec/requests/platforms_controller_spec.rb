require 'rails_helper'

RSpec.describe "Platforms", type: :request do
  let(:valid_family) {{ name: 'PlayStation', igdb_id: 8 }}
  let(:valid_platform) {{ name: 'PlayStation 5', igdb_id: 10, platform_family_id: 1 }}

  describe 'GET /index' do
    context 'when some Platform records exist' do
      it 'renders a successful response' do
        PlatformFamily.create!(valid_family)
        Platform.create!(valid_platform)

        get platforms_url

        expect(response).to be_successful
      end
    end

    context 'when no Platform records exist' do
      it 'renders a successful response' do
        get platforms_url

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    context 'when the Platform record exists' do
      it 'renders a successful response' do
        PlatformFamily.create!(valid_family)
        platform = Platform.create!(valid_platform)

        get platform_url(platform)

        expect(response).to be_successful
      end
    end

    context 'when the Platform record does not exist' do
      it 'renders a successful response' do  
        get platform_url(100)
  
        expect(response).to redirect_to(platforms_url)
      end
    end
  end
end
