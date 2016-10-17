task default: [:build_inventory]

desc 'Generates (or updates) an inventory of libraries used by your projects'
task :build_inventory do
  config = YAML.load('config.yml')

  config.each do |repo_options|
    repo = Repo.new(repo_options)
    repo.build_inventory
  end
end

