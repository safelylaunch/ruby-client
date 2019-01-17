require 'logger'

RSpec.describe Safelylaunch::HttpConnection do
  let(:conn) { described_class.new(api_token: api_token, logger: logger, cache_time: cache_time) }
  let(:logger) { Logger.new(StringIO.new) }
  let(:api_token) { '970144d3-fa42-42ca-93d3-b911e0282c14' }
  let(:response) { double(:response, body: {}) }
  let(:cache_time) { nil }

  describe '#get' do
    context 'when toggle exist', vcr: { cassette_name: 'toggle-exist' } do
      subject { conn.get('stream-toggle') }

      it { expect(subject).to eq(key: "stream-toggle", enable: true) }
      it { expect(subject[:error]).to eq(nil) }

      context 'and cache secconds time setuped' do
        let(:cache_time) { 10 }

        before do
          expect(conn.connection).to receive(:get).once.and_return(response)
          conn.get('stream-toggle')
        end

        it 'cahes result for next calls' do
          expect(conn.connection).to_not receive(:get)
          subject
        end
      end

      context 'and cache secconds time not setuped' do
        let(:cache_time) { nil }

        before do
          expect(conn.connection).to receive(:get).once.and_return(response)
          conn.get('stream-toggle')
        end

        it 'cahes result for next calls' do
          expect(conn.connection).to receive(:get).once.and_return(response)
          subject
        end
      end
    end

    context 'when toggle exist', vcr: { cassette_name: 'toggle-not-exist' } do
      subject { conn.get('invalid-stream-toggle') }

      it { expect(subject[:enable]).to eq(false) }
      it { expect(subject[:error]).to be_a(Hash) }
    end
  end
end
