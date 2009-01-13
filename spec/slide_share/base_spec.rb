require File.dirname(__FILE__) + "/../spec_helper"

describe SlideShare::Base do
  describe "when initializing with an options hash" do
    it "should require an api key" do
      lambda {
        SlideShare::Base.new(:api_key => "this is not a real api key")
      }.should raise_error(ArgumentError)
    end
  
    it "should require an shared secret" do
      lambda {
        SlideShare::Base.new(:shared_secret => "this is not a real shared secret")
      }.should raise_error(ArgumentError)
    end
    
    it "should raise no errors if provided api key and shared secret" do
      lambda {
        SlideShare::Base.new(
          :api_key       => "this is not a real api key",
          :shared_secret => "this is not a real shared secret"
        )
      }.should_not raise_error
    end
  end
  
  describe "when initializing with a YAML file" do
    it "should require an api key" do
      lambda {
        SlideShare::Base.new(spec_fixture("config_missing_api_key.yml"))
      }.should raise_error(ArgumentError)
    end
  
    it "should require an shared secret" do
      lambda {
        SlideShare::Base.new(spec_fixture("config_missing_shared_secret.yml"))
      }.should raise_error(ArgumentError)
    end
    
    it "should raise no errors if provided api key and shared secret" do
      lambda {
        SlideShare::Base.new(spec_fixture("config.yml"))
      }.should_not raise_error
    end
  end
  
  describe "when accessing slideshow functionality" do
    before(:each) do
      @slideshare = SlideShare::Base.new(spec_fixture("config.yml"))
    end
    
    it "should abstract access to the SlideShare::Slideshows class through SlideShare#slideshows" do
      @slideshow = mock("SlideShare::Slideshows")
      SlideShare::Slideshows.stub!(:new).and_return(@slideshow)
      @slideshare.slideshows.should == @slideshow
    end
  end
end