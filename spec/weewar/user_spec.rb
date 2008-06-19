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
  
  describe "attributes" do
    before :each do
      @user = Weewar::User.new(load_fixture('user'))
    end
    
    it "should have name" do
      @user.name.should == 'srmoon7'
    end
    
    it "should have id" do
      @user.id.should == 23079
    end
    
    it "should have points" do
      @user.points.should == 1681
    end
    
    it "should have profile URL" do
      @user.profile.should == 'http://weewar.com/user/srmoon7'
    end
    
    it "should have profile image URL" do
      @user.profileImage.should == 'http://weewar.com/images/profile/23079_FGpXNZ.jpg'
    end
    
    it "should have draws" do
      @user.draws.should == 6
    end
    
    it "should have victories" do
      @user.victories.should == 18
    end
    
    it "should have losses" do
      @user.losses.should == 7
    end
    
    it "should have account type" do
      @user.accountType.should == 'Pro'
    end
    
    it "should have online status" do
      @user.on.should be_true
    end
    
    it "should have ready to play status" do
      @user.readyToPlay.should be_true
    end
    
    it "should have number of games running" do
      @user.gamesRunning.should == 2
    end
    
    it "should have a last login time" do
      @user.lastLogin.should be_kind_of(Time)
      @user.lastLogin.should be_between(Time.local(2008, 6, 19), Time.local(2008, 6, 20))
    end
    
    it "should have number of bases captured" do
      @user.basesCaptured.should == 187
    end
    
    it "should have number of credits spent" do
      @user.creditsSpent.should == 346600
    end
    
    it "should have profile text" do
      @user.profileText.should == 'All your base are belong to me....'
    end
    
    it "should have a list of favorite units" do
      @user.favoriteUnits.should == %w[lightInfantry lighttank tank]
    end
  end
end