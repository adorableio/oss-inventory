require 'strategies/bundler_strategy'

RSpec.xdescribe BundlerStrategy do
  subject { described_class.new }

  describe "#perform" do
    context "with a non-bundler project" do
      it "returns an empty array" do
        expect(subject.perform).to be_empty
      end
    end

    context "with a bundler project" do
      it "returns an item for each gem"
      it "has a name for each gem"
      it "has a license for each gem"
    end
  end
end
