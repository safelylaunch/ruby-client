require 'logger'

RSpec.describe Safelylaunch::HttpConnection do
  let(:conn) { described_class.new(api_token: api_token) }
  let(:api_token) { '970144d3-fa42-42ca-93d3-b911e0282c14' }
  let(:response) { double(:response, body: {}) }

  describe '#get' do
    it { expect(conn.get('stream-toggle')).to eq(key: "stream-toggle", enable: true) }
    it { expect(conn.get('stream-toggle')).to eq(conn.get('stream-toggle')) }

    it do
      expect(conn.connection).to receive(:get).once.and_return(response)
      conn.get('stream-toggle')

      expect(conn.connection).to_not receive(:get)
      conn.get('stream-toggle')
    end
  end
end
