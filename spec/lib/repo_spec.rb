require 'repo'

RSpec.describe Repo do
  subject { described_class.new(directory, repo_options) }

  let(:directory) { '/tmp/' }
  let(:repo_options) do
    {
      url: 'git@github.com:adorableio/oss-inventory.git',
      branch: 'master'
    }
  end

  describe '#new' do
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

    it 'sets its file_location from the directory and name' do
      expect(subject.file_location).to eq('/tmp/oss-inventory')
    end
  end

  describe '#clone' do
    it 'builds an instance of a RepoCloner' do
      expect(RepoCloner).to receive(:new).with(subject)

      subject.clone
    end
  end

  describe '#build_inventory' do
    before do
      allow(subject).to receive(:clone)
    end

    it 'ensures that the repo is cloned' do
      expect(subject).to receive(:clone)

      subject.build_inventory
    end

    it 'builds an instance of an Inventory' do
      expect(Inventory).to receive(:new).with(subject)

      subject.build_inventory
    end
  end
end
