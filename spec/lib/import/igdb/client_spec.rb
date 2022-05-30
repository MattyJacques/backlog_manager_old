require 'rails_helper'

RSpec.describe Import::IGDB::Client do
  describe '.post', :vcr do
    context 'when the access token does not exist' do
      it 'retrives the token and posts the request' do
        params = { fields: 'name', where: 'id = 1009' }
        result = described_class.post('games', params).first

        expect(result.name).to eq('The Last of Us')
        expect(result.id).to eq(1009)
      end
    end
    
    context 'when access token has expired' do
      it 'refreshes the access token and retries' do
        Rails.cache.write('igdb_token', 'fake_expired_token')

        params = { fields: 'name', where: 'id = 1009' }
        result = described_class.post('games', params).first

        expect(result.name).to eq('The Last of Us')
        expect(result.id).to eq(1009)
      end
    end
  end
end