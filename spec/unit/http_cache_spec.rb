RSpec.describe Safelylaunch::HttpCache do
  let(:cache) { described_class.new }

  it 'returns data' do
    cache.put('key', { key: 'key', enable: true }, 10)
    expect(cache.get('key')).to eq(key: 'key', enable: true)
  end

  context 'when data is expired' do
    it 'does not return data' do
      cache.put('key', { key: 'key', enable: true }, -10)

      expect(cache.get('key')).to eq(nil)
      expect(cache.keys).to eq([])

      cache.put('key', { key: 'key', enable: true }, -10)
    end
  end
end
