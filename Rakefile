lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'yaml'
require 'repo'

task default: [:build_inventory]

desc 'Generates (or updates) an inventory of libraries used by your projects'
task :build_inventory do
  config = YAML.load_file('config.yml')
  inventory_directory = config['inventory_directory']
  repositories_attributes = config['repositories']

  Dir.mkdir(inventory_directory) unless File.exists?(inventory_directory)

  repositories_attributes.each do |repository_attributes|
    repo = Repo.new(inventory_directory, repository_attributes)
    repo.build_inventory
  end
end
