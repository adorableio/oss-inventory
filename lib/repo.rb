require 'repo_cloner'

class Repo
  attr_accessor :directory, :url, :branch, :name

  def initialize(directory, options)
    @directory = directory
    @url = options[:url]
    @branch = options[:branch]
    @name = parse_name_from_git_url(@url)
  end

  def clone
    RepoCloner.new(self)
  end

  private

  def parse_name_from_git_url(url)
    url
      .split(':').last
      .gsub(/.git/, '')
      .split('/')
      .slice(1..-1).join
  end
end
