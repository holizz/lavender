require 'spec_helper'

describe Lavender::Converter do
  it "should render anything that isn't YAML with the default layout/processor" do
    layout = <<END
<body>
  <%= yield %>
</body>
END

    page = <<END
%p My paragraph
END

    c = Lavender::Converter.new(:page => page, :layouts => {:default => {:erb => layout}}, :defaults => {:layout => :default, :processor => :haml})
    c.render.should == <<END
<body>
  <p>My paragraph</p>

</body>
END
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

    c.render.should == <<END
<p>Document content.</p>
END
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

  it "should not try to parse HAML as YAML" do
    page = <<END
---
layout: null
---
%p
  %img{:src => "hamsterdance.gif"}
END

    c = Lavender::Converter.new(:page => page, :defaults => {:processor => :haml})

    c.render.should == <<END
<p>
  <img src='hamsterdance.gif'>
</p>
END
  end

  it "should not try to parse HAML as YAML (no preamble)" do
    page = <<END
%p
  %img{:src => "hamsterdance.gif"}
END

    c = Lavender::Converter.new(:page => page, :defaults => {:processor => :haml})

    c.render.should == <<END
<p>
  <img src='hamsterdance.gif'>
</p>
END
  end
end
