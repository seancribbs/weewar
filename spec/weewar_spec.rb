require File.dirname(__FILE__) + '/spec_helper'

describe Weewar do
  it "should have a version number" do
    Weewar.version.should_not be_nil
  end
end