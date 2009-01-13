require "rubygems"
gem "rspec"
require "spec"

$:.unshift(File.dirname(__FILE__) + '/../lib')
require "slideshare"

def spec_fixture(filename)
  File.expand_path(File.join(File.dirname(__FILE__), "fixtures", filename))
end

def valid_configuration(options = {})
  {
    :api_key       => "this is not a real api key",
    :shared_secret => "this is not a real shared secret"
  }.merge(options)
end

def stub_time_now
  # Returning ;)
  now = Time.now
  Time.stub!(:now).and_return(now)
  now
end

def add_required_params(base, hash)
  base.send :add_required_params, hash
end

# Adapted from HTTParty specs
def stub_http_response_with(filename)
  format = filename.split('.').last.intern
  data = File.read(spec_fixture(filename))
  http = Net::HTTP.new('localhost', 80)
  
  response = Net::HTTPOK.new("1.1", 200, "Content for you")
  response.stub!(:body).and_return(data)
  http.stub!(:request).and_return(response)
  
  http_request = HTTParty::Request.new(Net::HTTP::Get, '')
  http_request.stub!(:get_response).and_return(response)
  http_request.stub!(:format).and_return(format)
  
  HTTParty::Request.stub!(:new).and_return(http_request)
  
  case format
  when :xml
    ToHashParser.from_xml(data)
  when :json
    JSON.parse(data)
  else
    data
  end
end