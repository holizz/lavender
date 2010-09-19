require 'spec_helper'

describe Lavender::Converter do
  before do
  end

  it "should render anything that isn't YAML as-is" do
    page = "<p>My paragraph</p>"
    c = Lavender::Converter.new(:page => page)
    c.render.should == "<p>My paragraph</p>"
  end

  it "should render pages with the given template processor" do
    page = <<END
---
processor: erb
layout: null
text: content
---
<p>Document <%= text %>.</p>
END

    c = Lavender::Converter.new(:page => page)

    c.render.should == "<p>Document content.</p>"
  end

  it "should render pages with a layout" do
    page = <<END
---
processor: haml
layout: default
title: your face
---
%p Document content.
END
    layout = <<END
%html
  %head
    %title= title
  %body
    = yield
END

    c = Lavender::Converter.new(:page => page, :layouts => {:default => {:haml => layout}})

    c.render.should == <<END
<html>
  <head>
    <title>your face</title>
  </head>
  <body>
    <p>Document content.</p>
  </body>
</html>
END
  end

  it "should allow mixing templating languages" do
    page = <<END
---
processor: haml
layout: page
title: your face
---
%p Document content.
END
    layout = <<END
<html>
  <head>
    <title><%= title %></title>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
END

    c = Lavender::Converter.new(:page => page, :layouts => {:page => {:erb => layout}})

    c.render.should == <<END
<html>
  <head>
    <title>your face</title>
  </head>
  <body>
    <p>Document content.</p>

  </body>
</html>
END
  end

  it "should use a default processor and layout" do
    page = <<END
---
title: your face
---
%p Document content.
END
    layout = <<END
<html>
  <head>
    <title><%= title %></title>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
END

    c = Lavender::Converter.new(:page => page, :layouts => {:default => {:erb => layout}}, :defaults => {:layout => :default, :processor => :haml})

    c.render.should == <<END
<html>
  <head>
    <title>your face</title>
  </head>
  <body>
    <p>Document content.</p>

  </body>
</html>
END
  end
end
