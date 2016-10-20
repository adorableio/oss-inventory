require "strategies/printed_strategy"

RSpec.describe PrintedStrategy do
  subject { described_class.new(repo) }
  let(:repo) { double("repo", file_location: "/tmp/oss-inventory") }

  describe "#perform" do
    context "when #get_libraries and #name are not implemented" do
      it "raises an error" do
        expect { subject.perform }.to raise_error("not implemented")
      end
    end

    context "when #get_libraries and #name are implemented" do
      before do
        def subject.get_libraries; []; end
        def subject.name; :strategy_name; end
      end

      it "delegates to InventoryPrinter" do
        expect(InventoryPrinter).to receive(:new).with(repo, [], :strategy_name)
        subject.perform
      end
    end
  end

  describe "#print_libraries" do
    context "when #get_libraries and #name are implemented" do
      before do
        def subject.get_libraries; []; end
        def subject.name; :strategy_name; end
      end

      it "delegates to InventoryPrinter" do
        expect(InventoryPrinter).to receive(:new).with(repo, [], :strategy_name)
        subject.print_libraries
      end

      it "prints overridden libraries" do
        expect(InventoryPrinter).to receive(:new).with(repo, [{}], :strategy_name)
        subject.print_libraries([{}])
      end
    end
  end
end
