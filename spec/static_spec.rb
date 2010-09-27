require 'spec_helper'

describe Lavender::Static do
  before do
    setup_sample_project
    FakeFS.activate!
    c = Lavender::Static.new
    c.run
  end

  after do
    FakeFS.deactivate!
  end

  it "should compile raw files" do
    File.should exist 'compiled/index.html'
    File.read('compiled/index.html').should == <<END
<audio src="girlfriendboy.wav"></audio>
END
  end

  it "should ignore non-.yml files" do
    File.should_not exist 'compiled/ignoreme.txt'
    File.should_not exist 'compiled/ignoreme'
  end

  it "should handle layouts and processing languages" do
    File.should exist 'compiled/hamster.html'
    File.read('compiled/hamster.html').should == <<END
<body>
  <p>Text</p>

</body>
END
  end

  it "should handle layouts in subdirectories" do
    File.should exist 'compiled/refectory.html'
    File.read('compiled/refectory.html').should == <<END
<noscript>
  Hello there

</noscript>
END
  end
end
