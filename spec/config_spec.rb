require 'spec_helper'

describe Lavender::Config do
  before do
    setup_sample_project
  end

  it "should take values from the config file" do
    FakeFS do
      config = Lavender::Config.new
      config.defaults.layout.should == 'main'
    end
  end

  it "should have pre-defined default values" do
    FakeFS do
      config = Lavender::Config.new
      config.defaults.processor.should == 'haml'
    end
  end
end
