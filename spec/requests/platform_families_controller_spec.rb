require 'rails_helper'

RSpec.describe "PlatformFamilies", type: :request do
  let(:valid_family) {{ name: 'PlayStation', igdb_id: 8 }}

  describe 'GET /index' do
    context 'when some PlatformFamily records exist' do
      it 'renders a successful response' do
        PlatformFamily.create!(valid_family)

        get platform_families_url

        expect(response).to be_successful
      end
    end

    context 'when no PlatformFamily records exist' do
      it 'renders a successful response' do
        get platform_families_url

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    context 'when the PlatformFamily record exists' do
      it 'renders a successful response' do
        family = PlatformFamily.create!(valid_family)

        get platform_family_url(family)

        expect(response).to be_successful
      end
    end

    context 'when the PlatformFamily record does not exist' do
      it 'renders a successful response' do  
        get platform_family_url(100)
  
        expect(response).to redirect_to(platform_families_url)
      end
    end
  end
end
