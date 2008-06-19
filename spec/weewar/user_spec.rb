require File.expand_path(File.join(File.dirname(__FILE__), %w[.. spec_helper]))

describe Weewar::User do
  include XmlFixtures
  
  it "should have a Base URL for all calls" do
    Weewar::User.base_url.should == 'http://weewar.com/api1/user'
  end
  
  describe "finding" do
    before :each do
      @user = mock(Weewar::User)
      @xml = "<user></user>"
      Weewar::User.stub!(:open).and_return(@xml)
      @user.stub!(:load)
    end
    
    it "should download the data from the Weewar site" do
      Weewar::User.should_receive(:open).with(Weewar::User.base_url + '/1').and_return(@xml)
      Weewar::User.find(1)
    end
    
    it "should create a new object" do
      Weewar::User.should_receive(:new).with(@xml).and_return(@user)
      Weewar::User.find(1)
    end
        
    it "should raise an error if the download fails" do
      Weewar::User.stub!(:open).and_raise('404')
      lambda { Weewar::User.find(1) }.should raise_error
    end
  end
  
  describe "with data loaded" do
    before :each do
      @user = Weewar::User.new(load_fixture('user'))
    end
    
    it "should have name" do
      @user.name.should == 'seancribbs'
    end
    
    it "should have id" do
      @user.id.should == 5658
    end
    
    it "should have points" do
      @user.points.should == 1493
    end
  end
end