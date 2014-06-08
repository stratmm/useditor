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
        expect(Useditor::Log).to receive(:ok).exactly(4).times
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

  context "manipulating an image" do
    subject { Useditor::Workspace.new.create }
    it "can draw vertical line" do
      subject.draw_vertical(col: 2, start_row: 2, end_row: 10, color: "P")
      expect(subject.image).to eql [
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "P", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "P", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "P", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "P", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "P", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "P", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "P", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "P", "B", "B", "B", "B", "B", "B", "B"]
      ]
    end

    it "draw vertical can cope with stupid values" do
      expect {subject.draw_vertical(col: 20, start_row: 20, end_row: 40, color: "P")}.not_to raise_error(Exception)
    end

    it "can draw horizontal line" do
      subject.draw_horizontal(row: 2, start_col: 2, end_col: 8, color: "P")
      expect(subject.image).to eql [
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "P", "P", "P", "P", "P", "P", "P", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
      ]
    end

    it "draw horizontal can cope with stupid values" do
      expect {subject.draw_horizontal(row: 20, start_col: 20, end_col: 40, color: "P")}.not_to raise_error(Exception)
    end

    it "can set a single pixel" do
      subject.set_pixel(row: 5, col: 5, color: "P")
      expect(subject.image).to eql [
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "P", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
      ]
    end
  end

  context "Manipulating Regions" do
    subject { Useditor::Workspace.new.create }
    before :each do
      subject.draw_horizontal(row: 4, start_col: 0, end_col: 9, color: "X")
      subject.draw_vertical(col: 4, start_row: 0, end_row: 9, color: "X")
    end

    it "have got the cross" do
      expect(subject.image).to eql [
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["X", "X", "X", "X", "X", "X", "X", "X", "X", "X"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"]
      ]
    end

    context "#get_pixel" do
      before :each do
        subject.set_pixel(row: 5, col: 8, color: "Q")
      end

      it "will get color" do
        expect(subject.image).to eql [
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["X", "X", "X", "X", "X", "X", "X", "X", "X", "X"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "Q", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
        ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"]
        ]
        expect(subject.get_pixel(row: 5, col: 8)).to eql "Q"
      end

      it "errors on invalid row" do
        expect { subject.get_pixel(row: 500, col: 8) }.to raise_error(Useditor::Workspace::PixelLocationError)
        expect { subject.get_pixel(row: -500, col: 8) }.to raise_error(Useditor::Workspace::PixelLocationError)
      end

      it "errors on invalid col" do
        expect { subject.get_pixel(row: 5, col: 800) }.to raise_error(Useditor::Workspace::PixelLocationError)
        expect { subject.get_pixel(row: 5, col: -800) }.to raise_error(Useditor::Workspace::PixelLocationError)
      end
    end

    context "#get_mates" do
      it "will handle top left" do
        expect(subject.get_mates(row: 0, col: 0)).to eql([
          {row: 0, col: 1},
          {row: 1, col: 0},
          {row: 1, col: 1}
        ])
        expect(subject.get_mates(row: 0, col: 0).count).to eql 3
      end

      it "will handle bottom right" do
        expect(subject.get_mates(row: 9, col: 9)).to eql([
          {row: 8, col: 8},
          {row: 8, col: 9},
          {row: 9, col: 8}
        ])
        #expect(subject.get_mates(row: 9, col: 9).count).to eql 3
      end

      it "will handle in the middle" do
        expect(subject.get_mates(row: 1, col: 1)).to eql([
          {row: 0, col: 0},
          {row: 0, col: 1},
          {row: 0, col: 2},
          {row: 1, col: 0},
          {row: 1, col: 2},
          {row: 2, col: 0},
          {row: 2, col: 1},
          {row: 2, col: 2}
        ])
        expect(subject.get_mates(row: 1, col: 1).count).to eql 8
      end

      it "will handle different color" do
        expect(subject.get_mates(row: 3, col: 1)).to eql([
          {row: 2, col: 0},
          {row: 2, col: 1},
          {row: 2, col: 2},
          {row: 3, col: 0},
          {row: 3, col: 2}
        ])
        expect(subject.get_mates(row: 3, col: 1).count).to eql 5
      end
    end

    context "#get_region" do
      it "gets correct region" do
        expect(subject.get_region(row: 1, col: 1)).to eql([
        {:row=>1, :col=>1},
        {:row=>0, :col=>0},
        {:row=>0, :col=>1},
        {:row=>0, :col=>2},
        {:row=>0, :col=>3},
        {:row=>1, :col=>2},
        {:row=>1, :col=>3},
        {:row=>2, :col=>2},
        {:row=>2, :col=>1},
        {:row=>1, :col=>0},
        {:row=>2, :col=>0},
        {:row=>3, :col=>0},
        {:row=>3, :col=>1},
        {:row=>3, :col=>2},
        {:row=>2, :col=>3},
        {:row=>3, :col=>3}
        ])
      end
    end

    context "#set_region" do
      it "sets the colors of a region" do
        subject.set_region(row: 1, col: 1, color: "U")
        expect(subject.image).to eql [
          ["U", "U", "U", "U", "X", "B", "B", "B", "B", "B"],
          ["U", "U", "U", "U", "X", "B", "B", "B", "B", "B"],
          ["U", "U", "U", "U", "X", "B", "B", "B", "B", "B"],
          ["U", "U", "U", "U", "X", "B", "B", "B", "B", "B"],
          ["X", "X", "X", "X", "X", "X", "X", "X", "X", "X"],
          ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"],
          ["B", "B", "B", "B", "X", "B", "B", "B", "B", "B"]
        ]
      end
      it "errors on invalid row" do
        expect { subject.set_region(row: -100, col: 1, color: "U") }.to raise_error(Useditor::Workspace::PixelLocationError)
        expect { subject.set_region(row: 100, col: 1, color: "U") }.to raise_error(Useditor::Workspace::PixelLocationError)
      end

      it "errors on invalid col" do
        expect { subject.set_region(row: 1, col: -100, color: "U") }.to raise_error(Useditor::Workspace::PixelLocationError)
        expect { subject.set_region(row: 1, col: 100, color: "U") }.to raise_error(Useditor::Workspace::PixelLocationError)
      end

    end
  end
end
