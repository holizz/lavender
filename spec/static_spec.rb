require 'spec_helper'

describe Lavender::Static do
  before do
    setup_sample_project
    FakeFS.activate!
  end

  after do
    FakeFS.deactivate!
  end

  it "should compile raw files" do
    c = Lavender::Static.new
    c.run
    File.should exist 'compiled/index.html'
    File.read('compiled/index.html').should == <<END.strip
<audio src="girlfriendboy.wav"></audio>
END
  end

  it "should ignore " do
    c = Lavender::Static.new
    c.run
    File.should_not exist 'compiled/ignoreme.txt'
    File.should_not exist 'compiled/ignoreme'
  end
end
