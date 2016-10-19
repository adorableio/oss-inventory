require 'strategies/npm_strategy'

RSpec.describe NpmStrategy do
  subject { described_class.new(repo) }

  let(:repo) { double('repo', file_location: '/tmp/oss-inventory') }
  let(:packages) do
    [
      {"name" => 'run-command', "version" => '0.0.1', "license" => 'MIT'},
      {"name" => 'custom-logger', "version" => '1.8.3', "license" => 'BSD'}
    ]
  end
  let(:npm_list_message) do
    '
    /tmp/oss-inventory/node_modules/run-command
    /tmp/oss-inventory/node_modules/run-command/node_modules/custom-logger
    '
  end

  before do
    allow(subject).to receive(:`).with(/npm install/)
    allow(subject).to receive(:`).with('npm list --parseable').and_return(npm_list_message)
  end

  describe '#perform' do
    context 'with bad package.json' do
      let(:npm_list_message) { "" }

      it 'returns an empty array' do
        expect(subject.send(:get_packages)).to be_empty
      end
    end

    context 'with packages' do
      let(:run_command_info_message) do
        '{
           "name": "run-command",
           "description": "daisy chain running shell commands",
           "dist-tags": {
             "latest": "0.0.1"
           },
           "versions": [
             "0.0.1"
           ],
           "maintainers": "itg <kevin@itsthatguy.com>",
           "time": {
             "modified": "2015-03-13T04:19:06.375Z",
             "created": "2014-07-16T21:49:16.216Z",
             "0.0.1": "2014-07-16T21:49:16.216Z"
           },
           "license": "MIT",
           "readmeFilename": "README.md",
           "homepage": "http://github.com/isthatguy/run-command",
           "repository": {
             "type": "git",
             "url": "http://github.com/itsthatguy/run-command"
           },
           "author": "Kevin Altman <kevin@itsthatguy.com> (@itg)",
           "bugs": {
             "url": "https://github.com/itsthatguy/run-command/issues"
           },
           "version": "0.0.1",
           "main": "index.js",
           "scripts": {
             "test": "echo \"Error: no test specified\" && exit 1"
           },
           "issues": {
             "bugs": "http://github.com/itsthatguy/run-command/issues"
           },
           "dependencies": {
             "custom-logger": "^0.2.1",
             "win-spawn": "^2.0.0"
           },
           "gitHead": "453c45ae2ba45382fcf7d828a9ac14170988cdca",
           "dist": {
             "shasum": "08c84d3fcd53af76ded74b6a15e2b115b25621e8",
             "tarball": "http://registry.npmjs.org/run-command/-/run-command-1.0.2.tgz"
           },
           "directories": {}
         }'
      end
      let(:custom_logger_info_message) do
        '{
           "name": "custom-logger",
           "version": "1.8.3",
           "licenses": {
             "type": "BSD",
             "url": "http://www.opensource.org/licenses/BSD"
           }
         }'
      end

      before do
        allow(subject).to receive(:`).with('npm info run-command --json').and_return(run_command_info_message)
        allow(subject).to receive(:`).with('npm info custom-logger --json').and_return(custom_logger_info_message)
      end

      it "returns an object for each package" do
        expect(subject.send(:get_packages)).to eq(packages)
      end
    end
  end

  describe "#perform" do
    it 'passes the retrieved library objects to InventoryPrinter' do
      allow(subject).to receive(:get_packages).and_return(packages)
      expect(InventoryPrinter).to receive(:new).with(repo, packages, :npm)
      subject.perform
    end
  end
end
