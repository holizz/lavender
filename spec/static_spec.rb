require 'spec_helper'

describe Lavender::Static do
  before do
    setup_sample_project
  end

  it "should compile raw files" do
    FakeFS do
      c = Lavender::Static.new
      c.run
      File.should exist 'compiled/index.html'
      File.read('compiled/index.html').should == <<END.strip
<audio src="girlfriendboy.wav"></audio>
END
    end
  end
end
