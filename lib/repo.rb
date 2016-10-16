require 'repo_cloner'
require 'inventory'

class Repo
  attr_accessor :directory, :url, :branch, :name, :file_location

  def initialize(directory, options)
    @directory = directory
    @url = options[:url]
    @branch = options[:branch]
    @name = parse_name_from_git_url(@url)
    @file_location = File.join(@directory, @name)
  end

  def clone
    RepoCloner.new(self)
  end

  def build_inventory
    clone
    Inventory.new(self)
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
