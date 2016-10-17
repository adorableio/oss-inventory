require 'strategy_factory'

class Inventory
  def initialize(repo)
    @strategies = StrategyFactory.get_strategies(repo)

    @strategies.each do |strategy|
      strategy.perform
    end
  end
end
