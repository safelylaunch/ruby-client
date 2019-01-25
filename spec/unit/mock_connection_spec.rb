# frozen_string_literal: true

RSpec.describe Safelylaunch::MockConnection do
  let(:conn) { described_class.new(api_token: api_token, toggles: toggles) }
  let(:api_token) { '123' }

  let(:toggles) do
    {
      'toggle-key' => true,
      'disable-toggle-key' => false
    }
  end

  describe '#get' do
    context 'when mock connection knows about toggle key' do
      it { expect(conn.get('toggle-key')).to eq(key: 'toggle-key', enable: true) }
      it { expect(conn.get('disable-toggle-key')).to eq(key: 'disable-toggle-key', enable: false) }
    end

    context 'when mock connection does not know about toggle key' do
      it { expect(conn.get('anything-else')).to eq(key: 'anything-else', enable: false) }
    end
  end
end
