# frozen_string_literal: true

RSpec.describe Safelylaunch::Client do
  let(:client) { described_class.new(conn) }
  let(:conn) { Safelylaunch::MockConnection.new(api_token: '123') }

  describe '#enable?' do
    subject { client.enable?('some-key') }

    it { expect(subject).to eq false }
  end
end
