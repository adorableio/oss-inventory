require 'strategies/bundler_strategy'

RSpec.describe BundlerStrategy do
  subject { described_class.new(repo) }

  let(:repo) { double('repo', file_location: '/tmp/oss-inventory') }
  let(:libraries) do
    [
      {name: 'bundler', version: '1.13.1', license: 'MIT'},
      {name: 'slop', version: '3.6.0', license: 'BSD'}
    ]
  end

  describe '#get_libraries' do
    context 'with no gems' do
      let(:no_gems_message) { "Could not locate Gemfile or .bundle/ directory\n" }

      before do
        allow(subject).to receive(:`).with('bundle show').and_return(no_gems_message)
      end

      it 'returns an empty array' do
        expect(subject.send(:get_libraries)).to be_empty
      end
    end

    context 'with gems' do
      let(:bundle_show_message) do
        <<GEMS
Gems included by the bundle:
  * bundler (1.13.1)
  * slop (3.6.0)
GEMS
      end
      let(:bundler_details) do
        <<BUNDLER
bundler (1.13.1)
    Authors: André Arko, Samuel Giddins
    Homepage: http://bundler.io
    License: MIT
    Installed at: /Users/ryland/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0

    The best way to manage your application's dependencies

bundler-audit (0.5.0)
    Author: Postmodern
    Homepage: https://github.com/rubysec/bundler-audit#readme
    License: GPLv3
    Installed at: /Users/ryland/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0

    Patch-level verification for Bundler
BUNDLER
      end
      let(:slop_details) do
        <<SLOP
slop (3.6.0)
    Author: Lee Jarvis
    Homepage: http://github.com/leejarvis/slop
    License: BSD
    Installed at: /Users/ryland/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0

    Simple Lightweight Option Parsing
SLOP
      end

      before do
        allow(subject).to receive(:`).with('bundle show').and_return(bundle_show_message)
        allow(subject).to receive(:`).with('gem list bundler --details').and_return(bundler_details)
        allow(subject).to receive(:`).with('gem list slop --details').and_return(slop_details)
      end

      it "returns an object for each gem" do
        expect(subject.send(:get_libraries)).to eq(libraries)
      end
    end
  end

  describe "#perform" do
    it 'passes the retrieved library objects to InventoryPrinter' do
      allow(subject).to receive(:get_libraries).and_return(libraries)
      expect(InventoryPrinter).to receive(:new).with(repo, libraries, :bundler)
      subject.perform
    end
  end
end
