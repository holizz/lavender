require 'spec_helper'

describe Lavender::Command do
  it "should call Static correctly" do
    m=RSpec::Mocks::Mock.new
    m.stub!(:run)
    Lavender::Static.should_receive(:new).with().and_return(m)
    Lavender::Command.run(%w[compile])
  end

  it "should have a placeholder for Server" do
    lambda { Lavender::Command.run(%w[server]) }.should raise_error
  end

  it "should bork on unrecognised commands" do
    lambda { Lavender::Command.run(%w[on the ning nang nong]) }.should raise_error
  end
end
