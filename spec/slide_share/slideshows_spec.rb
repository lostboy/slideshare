require File.dirname(__FILE__) + "/../spec_helper"

describe SlideShare::Slideshows do
  before(:all) do
    @slideshare = SlideShare::Base.new(spec_fixture("config.yml"))
    @now = Time.now
    Time.stub!(:now).and_return(@now)
  end
  
  describe "when creating a slideshow" do
    before(:each) do
      @upload = spec_fixture("sample.txt")
      @curl = mock("Curl::Easy instance")
      Curl::Easy.stub!(:new).and_return(@curl)
      @curl.stub!(:http_post)
      @curl.stub!(:body_str).and_return(File.read(spec_fixture("upload_slideshow.xml")))
    end
    
    # it "should generate the proper API call" do
    #   @slideshare.slideshows.create "A Title", @upload, "user", "pass"
    # end
    
    it "should return the uploaded slideshow's id when successful" do
      @slideshare.slideshows.create("A Title", @upload, "user", "pass").should == 815
    end
    
    it "should raise SlideShare::FailedUserAuthentication if given bad credentials" do
      @curl.stub!(:body_str).and_return(File.read(spec_fixture("error_failed_auth.xml")))
      lambda {
        @slideshare.slideshows.create "A Title", @upload, "wronguser", "wrongpass"
      }.should raise_error(SlideShare::FailedUserAuthentication)
    end
  end
  
  describe "when retrieving a slideshow" do
    before(:each) do
      @response = stub_http_response_with("get_slideshow.xml")
    end
    
    it "should generate the proper API call" do
      SlideShare::Base.should_receive(:get).with("/get_slideshow",
        :query => add_required_params(@slideshare, :slideshow_id => 815)).and_return(@response)
      @slideshare.slideshows.find(815)
    end
    
    it "should convert boolean argument for detailed slideshow into numeric values" do
      SlideShare::Base.should_receive(:get).with("/get_slideshow",
        :query => add_required_params(@slideshare, :slideshow_id => 815, :detailed => 1)).and_return(@response)
      @slideshare.slideshows.find(815, :detailed => true)
    end
    
    # I kinda think this sucks but I don't want to make it too brittle.
    # Also, if this fails it's because of an outdated HTTParty gem.
    it "should convert the response into a Hash when successful" do
      @slideshare.slideshows.find(815).is_a?(Hash).should be_true
    end
    
    it "should raise SlideShare::SlideshowNotFound if no slideshow matches id" do
      stub_http_response_with("error_not_found.xml")
      lambda {
        @slideshare.slideshows.find 4815162342
      }.should raise_error(SlideShare::SlideshowNotFound)
    end
    
    it "should raise SlideShare::FailedUserAuthentication if given bad credentials" do
      stub_http_response_with("error_failed_auth.xml")
      lambda {
        @slideshare.slideshows.find 815, :username => "wrong_user", :password => "wrong_pass"
      }.should raise_error(SlideShare::FailedUserAuthentication)
    end
    
    it "should raise SlideShare::InsufficientPermission if username and password are needed but not supplied" do
      stub_http_response_with("error_permissions.xml")
      lambda {
        @slideshare.slideshows.find 815
      }.should raise_error(SlideShare::InsufficientPermission)
    end
  end
  
  describe "when updating a slideshow" do
    before(:each) do
      @response = stub_http_response_with("edit_slideshow.xml")
    end
    
    it "should generate the proper API call" do
      SlideShare::Base.should_receive(:post).with("/edit_slideshow",
        :query => add_required_params(@slideshare, :slideshow_id => 815, 
          :username => "user", :password => "pass")).and_return(@response)
      @slideshare.slideshows.update(815, "user", "pass")
    end
    
    it "should convert optional argument for :make_slideshow_private" do
      SlideShare::Base.should_receive(:post).with("/edit_slideshow",
        :query => add_required_params(@slideshare, :slideshow_id => 815, 
          :username => "user", :password => "pass",
          :make_slideshow_private => "Y")).and_return(@response)
      @slideshare.slideshows.update(815, "user", "pass", :make_slideshow_private => true)
    end
    
    it "should return true if successful" do
      @slideshare.slideshows.update(815, "user", "pass",
        :slideshow_title => "Something New").should be_true
    end
    
    it "should raise SlideShare::SlideshowNotFound if no slideshow matches id" do
      stub_http_response_with("error_not_found.xml")
      lambda {
        @slideshare.slideshows.update 4815162342, "user", "pass"
      }.should raise_error(SlideShare::SlideshowNotFound)
    end
    
    it "should raise SlideShare::FailedUserAuthentication if given bad credentials" do
      stub_http_response_with("error_failed_auth.xml")
      lambda {
        @slideshare.slideshows.update 815, "wrong_user", "wrong_pass"
      }.should raise_error(SlideShare::FailedUserAuthentication)
    end
  end
  
  describe "when deleting a slideshow" do
    before(:each) do
      @response = stub_http_response_with("delete_slideshow.xml")
    end
    
    it "should generate the proper API call" do
      SlideShare::Base.should_receive(:post).with("/delete_slideshow",
        :query => add_required_params(@slideshare, :slideshow_id => 815, 
          :username => "user", :password => "pass")).and_return(@response)
      @slideshare.slideshows.delete(815, "user", "pass")
    end
    
    it "should return true if successful" do
      @slideshare.slideshows.delete(815, "user", "pass").should be_true
    end
    
    it "should raise SlideShare::SlideshowNotFound if no slideshow matches id" do
      stub_http_response_with("error_not_found.xml")
      lambda {
        @slideshare.slideshows.delete 4815162342, "user", "pass"
      }.should raise_error(SlideShare::SlideshowNotFound)
    end
    
    it "should raise SlideShare::FailedUserAuthentication if given bad credentials" do
      stub_http_response_with("error_failed_auth.xml")
      lambda {
        @slideshare.slideshows.delete 815, "wrong_user", "wrong_pass"
      }.should raise_error(SlideShare::FailedUserAuthentication)
    end
  end
end