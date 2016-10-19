require "inventory_printer"

class PrintedStrategy
  attr_reader :libraries, :repo

  def initialize(repo)
    @repo = repo
  end

  def perform
    @libraries = get_libraries
    print_libraries
  end

  def get_libraries
    raise "not implemented"
  end

  def print_libraries(libraries=[])
    if libraries.nil? || libraries.empty?
      libraries = self.libraries || []
    end

    InventoryPrinter.new(repo, libraries, name)
  end

  protected

  def name
    raise "not implemented"
  end
end
