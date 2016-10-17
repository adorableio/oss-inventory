class InventoryPrinter
  attr_reader :repo, :libraries, :file_name

  def initialize(repo, libraries, strategy_name)
    @repo = repo
    @libraries = libraries
    @file_name = "#{repo.name}_#{strategy_name}.txt"

    generate_inventory_file
  end

  private

  def generate_inventory_file
    Dir.chdir(repo.directory) do
      File.open(file_name, 'w') do |writer|
        libraries.each do |library|
          writer.write("#{library['name']} #{library['version']} #{library['license']}\n")
        end
      end
    end
  end
end
