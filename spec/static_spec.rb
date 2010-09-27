require 'spec_helper'

describe Lavender::Static do
  before do
    FakeFS.activate!
  end

  after do
    FakeFS.deactivate!
  end

  it "should compile raw files" do
    stub_files_and_run 'pages/index.html.yml' => <<END
---
layout: null
processor: raw
---
<audio src="girlfriendboy.wav"></audio>
END

    File.should exist 'compiled/index.html'
    File.read('compiled/index.html').should == <<END
<audio src="girlfriendboy.wav"></audio>
END
  end

  it "should ignore non-.yml files" do
    stub_files_and_run 'pages/igonreme.txt' => <<END
Ignore this!!!
END
    File.should_not exist 'compiled/ignoreme.txt'
    File.should_not exist 'compiled/ignoreme'
  end

  it "should handle layouts and processing languages" do
    stub_files_and_run(
      'pages/hamster.html.yml' => <<END,
%p Text
END
      'layouts/main.erb' => <<END)
<body>
  <%= yield %>
</body>
END
    File.should exist 'compiled/hamster.html'
    File.read('compiled/hamster.html').should == <<END
<body>
  <p>Text</p>

</body>
END
  end

  it "should handle layouts in subdirectories" do
    stub_files_and_run(
      'pages/refectory.html.yml' => <<END,
---
layout: clarissa/explains
processor: raw
---
Hello there
END
      'layouts/clarissa/explains.erb' => <<END)
<noscript>
  <%= yield %>
</noscript>
END
    File.should exist 'compiled/refectory.html'
    File.read('compiled/refectory.html').should == <<END
<noscript>
  Hello there

</noscript>
END
  end

  it "should create directories" do
    stub_files_and_run 'pages/s/ash.html.yml' => <<END
---
layout: null
processor: raw
---
Hello there
END
    File.should exist 'compiled/s/ash.html'
    File.read('compiled/s/ash.html').should == <<END
Hello there
END
  end
end
