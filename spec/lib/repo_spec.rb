require 'repo'

RSpec.describe Repo do
  subject { described_class.new(directory, repo_options) }
  let(:directory) { '/tmp/' }

  describe '#new' do
    let(:repo_options) do
      {
        url: 'git@github.com:adorableio/oss-inventory.git',
        branch: 'master'
      }
    end

    it 'sets its directory from arguments' do
      expect(subject.directory).to eq(directory)
    end

    it 'sets its url from the specified options' do
      expect(subject.url).to eq(repo_options[:url])
    end

    it 'sets its branch from the specified options' do
      expect(subject.branch).to eq(repo_options[:branch])
    end

    it 'sets its name from the url' do
      expect(subject.name).to eq('oss-inventory')
    end
  end
end
