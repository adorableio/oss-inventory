require 'inventory_printer'

class BundlerStrategy
  attr_reader :repo, :strategy_name

  def initialize(repo)
    @strategy_name = :bundler
    @repo = repo
  end

  def perform
    libraries = get_libraries
    InventoryPrinter.new(repo, libraries, strategy_name)
  end

  private

  def get_libraries
    Dir.chdir(repo.file_location) do
      `bundle show`
        .split("\n")
        .select { |line| line.strip.start_with?('*') }
        .map do |line|
          _, gem_name, version = line.split
          version = version.gsub(/[()]/, '')
          license = get_license(gem_name, version)

          {
            "name" => gem_name,
            "version" => version,
            "license" => license
          }
        end
    end
  end

  def get_license(gem_name, version)
    `gem list #{gem_name} --details`
      .split("\n")
      .map(&:strip)
      .grep(/license/i)
      .first
      .gsub(/licenses?:/i, '')
      .strip
  end
end
