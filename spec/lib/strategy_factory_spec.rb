require 'strategy_factory'

RSpec.describe StrategyFactory do
  describe '.get_strategies' do
    let(:found_strategies) { described_class.get_strategies(repo) }
    let(:repo) { double('repo', file_location: '/tmp') }

    context 'when no representative files are found in the repo' do
      before do
        allow(File).to receive(:exist?).and_return(false)
      end

      it 'returns an empty array' do
        expect(found_strategies).to be_empty
      end
    end

    context 'when a Gemfile exists' do
      before do
        allow(File).to receive(:exist?).with('Gemfile').and_return(true)
      end

      it 'returns an instance of the BundlerStrategy' do
        expect(found_strategies.count).to eq(1)
        expect(found_strategies.first).to be_a(BundlerStrategy)
      end
    end
  end
end
