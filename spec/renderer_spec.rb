require 'spec_helper'

describe Lavender::Renderer do
  before do
  end

  it "should render raw stuff as-is" do
    page = '<p>My paragraph</p>'
    r = Lavender::Renderer.new(:raw, page)
    r.render.should == page
  end

  it "should render ERB" do
    page = '<p>Document <%= "content" %>.</p>'
    r = Lavender::Renderer.new(:erb, page)
    r.render.should == '<p>Document content.</p>'
  end

  it "should render HAML" do
    page = '%p Document content.'
    r = Lavender::Renderer.new(:haml, page)
    r.render.should == "<p>Document content.</p>\n"
  end

  it "should set variables" do
    # ERB
    page = '<p>Document <%= text %>.</p>'
    r = Lavender::Renderer.new(:erb, page)
    r.render({:text => 'content'}).should == '<p>Document content.</p>'

    # HAML
    page = '%p= "Document #{text}."'
    r = Lavender::Renderer.new(:haml, page)
    r.render({:text => 'content'}).should == "<p>Document content.</p>\n"
  end

  it "should yield" do
    # ERB
    page = '<p>Document <%= yield %>.</p>'
    r = Lavender::Renderer.new(:erb, page)
    r.render{ 'content' }.should == '<p>Document content.</p>'

    # HAML
    page = '%p= "Document #{yield}."'
    r = Lavender::Renderer.new(:haml, page) { 'content' }
    r.render{ 'content' }.should == "<p>Document content.</p>\n"
  end
end
