require 'inventory'

RSpec.describe Inventory do
  let(:repo) do
    double('repo')
  end

  describe '#new' do
    let(:strategy) do
      double('strategy', perform: true)
    end

    before do
      allow(StrategyFactory).to receive(:get_strategies).and_return([strategy, strategy])
    end

    it 'gets strategies from the StrategyFactory' do
      expect(StrategyFactory).to receive(:get_strategies).with(repo).and_return([strategy, strategy])
      described_class.new(repo)
    end

    it 'performs the determined strategies' do
      expect(strategy).to receive(:perform).twice

      described_class.new(repo)
    end
  end
end
