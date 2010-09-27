require 'spec_helper'

describe Lavender::Config do
  before do
    FakeFS.activate!
    stub_files 'config.yml' => <<END
---
defaults:
  layout: main
END
  end

  after do
    FakeFS.deactivate!
  end

  it "should take values from the config file" do
    config = Lavender::Config.new
    config.defaults.layout.should == 'main'
  end

  it "should have pre-defined default values" do
    config = Lavender::Config.new
    config.defaults.processor.should == 'haml'
  end
end
