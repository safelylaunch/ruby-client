require 'logger'

RSpec.describe Safelylaunch::HttpConnection do
  let(:conn) { described_class.new(api_token: api_token) }
  let(:api_token) { '970144d3-fa42-42ca-93d3-b911e0282c14' }

  describe '#get' do
    it { expect(conn.get('stream-toggle')).to eq(key: "stream-toggle", enable: true) }
  end
end
