#!/usr/bin/env rspec

require 'spec_helper'

provider_class = Puppet::Type.type(:augeasprovider).provider(:default)

describe provider_class do
  let (:subclass) { subject.class }

  context "empty provider" do
    describe "#lens" do
      it "should fail as default lens isn't set" do
        subclass.expects(:fail).with('Lens is not provided').raises
        expect { subclass.lens }.to raise_error
      end
    end

    describe "#target" do
      it "should fail if no default or resource file" do
        subclass.expects(:fail).with('No target file given').raises
        expect { subclass.target }.to raise_error
      end

      it "should return resource file if set" do
        subclass.target(:target => '/foo').should == '/foo'
      end

      it "should strip trailing / from resource file" do
        subclass.target(:target => '/foo/').should == '/foo'
      end
    end

    describe "#resource_path" do
      it "should call #target if no resource path block set" do
        resource = { :name => 'foo' }
        subclass.expects(:target).with(resource)
        subclass.resource_path(resource).should == '/foo'
      end

      it "should call #target if a resource path block is set" do
        resource = { :name => 'foo' }
        subclass.expects(:target).with(resource)
        subclass.resource_path { '/files/test' }
        subclass.resource_path(resource).should == '/files/test'
      end
    end

    describe "#readquote" do
      it "should return :double when value is double-quoted" do
        subclass.readquote('"foo"').should == :double
      end

      it "should return :single when value is single-quoted" do
        subclass.readquote("'foo'").should == :single
      end

      it "should return nil when value is not quoted" do
        subclass.readquote("foo").should be_nil
      end

      it "should return nil when value is not properly quoted" do
        subclass.readquote("'foo").should be_nil
        subclass.readquote("'foo\"").should be_nil
        subclass.readquote("\"foo").should be_nil
        subclass.readquote("\"foo'").should be_nil
      end
    end

    describe "#quoteit" do
      it "should not do anything by default for alphanum values" do
        subclass.quoteit('foo').should == 'foo'
      end

      it "should double-quote by default for values containing spaces or special characters" do
        subclass.quoteit('foo bar').should == '"foo bar"'
        subclass.quoteit('foo&bar').should == '"foo&bar"'
        subclass.quoteit('foo;bar').should == '"foo;bar"'
        subclass.quoteit('foo<bar').should == '"foo<bar"'
        subclass.quoteit('foo>bar').should == '"foo>bar"'
        subclass.quoteit('foo(bar').should == '"foo(bar"'
        subclass.quoteit('foo)bar').should == '"foo)bar"'
        subclass.quoteit('foo|bar').should == '"foo|bar"'
      end

      it "should call #readquote and use its value when oldvalue is passed" do
        subclass.quoteit('foo', nil, "'bar'").should == "'foo'"
        subclass.quoteit('foo', nil, '"bar"').should == '"foo"'
        subclass.quoteit('foo', nil, 'bar').should == 'foo'
        subclass.quoteit('foo bar', nil, "'bar'").should == "'foo bar'"
      end

      it "should double-quote special values when oldvalue is not quoted" do
        subclass.quoteit('foo bar', nil, 'bar').should == '"foo bar"'
      end

      it "should use the :quoted parameter when present" do
        resource = { }
        resource.stubs(:parameters).returns([:quoted])

        resource[:quoted] = :single
        subclass.quoteit('foo', resource).should == "'foo'"

        resource[:quoted] = :double
        subclass.quoteit('foo', resource).should == '"foo"'

        resource[:quoted] = :auto
        subclass.quoteit('foo', resource).should == 'foo'
        subclass.quoteit('foo bar', resource).should == '"foo bar"'
      end
    end

    describe "#unquoteit" do
      it "should not do anything when value is not quoted" do
        subclass.unquoteit('foo bar').should == 'foo bar'
      end

      it "should not do anything when value is badly quoted" do
        subclass.unquoteit('"foo bar').should == '"foo bar'
        subclass.unquoteit("'foo bar").should == "'foo bar"
        subclass.unquoteit("'foo bar\"").should == "'foo bar\""
      end

      it "should return unquoted value" do
        subclass.unquoteit('"foo bar"').should == 'foo bar'
        subclass.unquoteit("'foo bar'").should == 'foo bar'
      end
    end

    describe "#attr_aug_reader" do
      it "should create a class method" do
        subclass.attr_aug_reader(:foo, {})
        subclass.method_defined?('attr_aug_reader_foo').should be_true
      end
    end

    describe "#attr_aug_writer" do
      it "should create a class method" do
        subclass.attr_aug_writer(:foo, {})
        subclass.method_defined?('attr_aug_writer_foo').should be_true
      end
    end

    describe "#attr_aug_accessor" do
      it "should call #attr_aug_reader and #attr_aug_writer" do
        name = :foo
        opts = { :bar => 'baz' }
        subclass.expects(:attr_aug_reader).with(name, opts)
        subclass.expects(:attr_aug_writer).with(name, opts)
        subclass.attr_aug_accessor(name, opts)
      end
    end
  end
end
