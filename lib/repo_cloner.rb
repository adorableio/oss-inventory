class RepoCloner
  attr_accessor :repo, :destination

  def initialize(repo)
    @repo = repo
    @destination = repo.file_location

    clone
    fetch
    checkout_branch
  end

  private

  def clone
    return if Dir.exist?(destination)

    Dir.chdir(repo.directory) do
      `git clone #{repo.url}`
    end
  end

  def fetch
    Dir.chdir(destination) do
      `git fetch`
    end
  end

  def checkout_branch
    Dir.chdir(destination) do
      `git checkout #{repo.branch}` 
      `git reset --hard origin/#{repo.branch}`
    end
  end
end
