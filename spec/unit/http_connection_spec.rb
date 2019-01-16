require 'logger'

RSpec.describe Safelylaunch::HttpConnection do
  let(:conn) { described_class.new(api_token: api_token) }
  let(:api_token) { '123' }

  describe '#call' do
    it { expect(conn.call).to be_a(Faraday::Connection) }
  end
end
