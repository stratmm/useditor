require 'spec_helper'
require 'useditor/workspace'

describe Useditor::Workspace do
  let(:state_file) { "./workspace.json" }
  let(:state_content) do
    {
      image: ['1', '2'],
      cols: 2,
      rows: 1
    }
  end

  context "The base class" do
    subject {described_class}

    it { respond_to :image }
    it { respond_to :rows }
    it { respond_to :cols }
    it { respond_to :state_file }
  end

  context "Creating an instance" do
    subject { Useditor::Workspace.new }

    before :each do
      File.unlink(state_file) if File.exists?(state_file)
    end

    context "When no state file" do

      it "sets empty values" do
        expect(subject.rows).to eql 0
        expect(subject.cols).to eql 0
        expect(subject.image).to eql []
        expect(subject.state_file).to eql state_file
      end
    end

    context "When a state file exists" do
      before :each do
        File.write(state_file, JSON.dump(state_content))
      end

      it "sets the values from the state_file" do
        expect(subject.rows).to eql 1
        expect(subject.cols).to eql 2
        expect(subject.image).to eql ['1', '2']
      end
    end
  end

  context "Creating an image" do
    context "with no parameters" do
      subject { Useditor::Workspace.new.create }
      it "sets empty values" do
        expect(subject.rows).to eql 10
        expect(subject.cols).to eql 10
        expect(subject.image).to eql [
          ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
        ]
      end
    end

    context "with some parameters" do
      subject { Useditor::Workspace.new.create(rows: 4, cols: 4, color: "W") }
      it "Sets the correct values" do
        expect(subject.rows).to eql 4
        expect(subject.cols).to eql 4
        expect(subject.image).to eql [
          ["W", "W", "W", "W"],
          ["W", "W", "W", "W"],
          ["W", "W", "W", "W"],
          ["W", "W", "W", "W"]
        ]
      end

      it "can be logged out" do
        Useditor::Log.should_receive(:ok).exactly(4).times
        subject.log_out
      end

    end

    context "An all black image" do
      subject { Useditor::Workspace.new.create(rows: 4, cols: 4, color: "B") }
      it "can be cleared to white" do
        subject.clear
        expect(subject.image).to eql [
          ["W", "W", "W", "W"],
          ["W", "W", "W", "W"],
          ["W", "W", "W", "W"],
          ["W", "W", "W", "W"]
        ]
      end

    end
  end
end
