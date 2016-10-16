require 'strategies/bundler_strategy'

class StrategyFactory
  FILES_FOR_STRATEGIES = {
    'Gemfile' => BundlerStrategy
  }

  def self.get_strategies(repo)
    Dir.chdir(repo.file_location) do
      FILES_FOR_STRATEGIES.map do |representative_file, strategy_class|
        strategy_class.new(repo) if File.exist?(representative_file)
      end.compact
    end
  end
end
