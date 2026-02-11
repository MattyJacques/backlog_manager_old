# frozen_string_literal: true

RSpec.describe IGDB::Client::Base do
  describe '.post' do
    let(:response_body) { [{ 'name' => 'The Last of Us', 'id' => 1009 }] }

    context 'when the access token does not exist' do
      before do
        stub_igdb_post('games', response_body)
      end

      it 'retrives the token and posts the request' do
        params = { fields: 'name', where: 'id = 1009' }
        result = described_class.post('games', params).first

        expect(result['name']).to eq('The Last of Us')
        expect(result['id']).to eq(1009)
      end
    end

    context 'when access token has expired' do
      before do
        Rails.cache.write('igdb_token', 'fake_expired_token')
        stub_igdb_401_then_success('games', response_body)
      end

      it 'refreshes the access token and retries' do
        params = { fields: 'name', where: 'id = 1009' }
        result = described_class.post('games', params).first

        expect(result['name']).to eq('The Last of Us')
        expect(result['id']).to eq(1009)
      end
    end
  end
end
