require 'inventory_printer'

RSpec.describe InventoryPrinter do
  describe '#new' do
    subject { described_class.new(repo, libraries, strategy_name) }

    let(:repo) do
      double(:repo, directory: repo_directory, name: 'repo')
    end
    let(:repo_directory) { '/tmp/oss-inventory' }
    let(:libraries) do
      [
        {"name" => 'bundler', "version" => '1.13.1', "license" => 'MIT'},
        {"name" => 'slop', "version" => '3.6.0', "license" => 'BSD'}
      ]
    end
    let(:strategy_name) { :bundler }
    let(:expected_inventory_file) do
      File.join(repo_directory, "repo_bundler.txt")
    end

    it "generates a file in the given repo's parent directory" do
      expect { subject }.to change { Dir["#{repo_directory}/**/*"].length }.by(1)
    end

    it 'generates a file named with the repo name and strategy' do
      expect { subject }.to change { File.exist?(expected_inventory_file) }.from(false).to(true)
    end

    it 'generates a line for each specified library' do
      subject
      line_count = `wc -l #{expected_inventory_file}`.to_i

      expect(line_count).to eq(libraries.count)
    end
  end
end
