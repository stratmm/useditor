require 'spec_helper'

require 'useditor/log'

describe Useditor::Log do

  it { expect(Useditor::Log).to respond_to(:debug) }
  it { expect(Useditor::Log).to respond_to(:error) }
  it { expect(Useditor::Log).to respond_to(:info) }
  it { expect(Useditor::Log).to respond_to(:warn) }
  it { expect(Useditor::Log).to respond_to(:fatal) }
  it { expect(Useditor::Log).to respond_to(:ok) }

  describe "return value of #format_msg" do

    let(:severity) { "ERROR" }
    let(:msg) { "This is a test message" }
    let(:time) { Time.now }

    it "should return a correctly formatted message" do
      message = Useditor::Log.format_msg(severity, msg, time)
      expected_message = "[#{time}] [#{severity}]: #{msg}\n"
      expect(message).to eq(expected_message)
    end

  end

  describe "action of #color" do

    let(:message) { "a message" }
    let(:type) { :fatal }

    it "should retrieve the correct color for a message" do
      expect(Useditor::Log).to receive(:color_fatal).with(message)
      Useditor::Log.color(message, type)
    end

    it "should correctly stylize a message" do
      expect(Useditor::Log.color(message,type)).to eq(message.underline.red)
    end

  end

end
