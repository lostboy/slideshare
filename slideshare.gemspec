Gem::Specification.new do |s|
  s.name = "slideshare"
  s.version = "0.1.2.1"
  
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = "1.3.1"
  
  s.date = "2009-1-13"
  s.summary = "Ruby interface for SlideShare API"
  s.email = "pablo@saiku.es"
  s.homepage = "http://github.com/saiku/slideshare"
  s.description = "Ruby interface for SlideShare API"
  s.authors = ["Saiku.es", "Russell Norris"]
  s.files = %w{
    init.rb
    lib/slideshare.rb
    lib/slide_share/base.rb
    lib/slide_share/errors.rb
    lib/slide_share/slideshows.rb
    MIT-LICENSE
    Rakefile
    README.rdoc
    slideshare.gemspec
    spec/spec.opts
    spec/spec_helper.rb
    spec/fixtures/config.yml
    spec/fixtures/config_missing_api_key.yml
    spec/fixtures/config_missing_shared_secret.yml
    spec/fixtures/delete_slideshow.xml
    spec/fixtures/edit_slideshow.xml
    spec/fixtures/error_failed_auth.xml
    spec/fixtures/error_not_found.xml
    spec/fixtures/error_permissions.xml
    spec/fixtures/error_failed_auth.xml
    spec/fixtures/get_slideshow.xml
    spec/fixtures/get_slideshow_detailed.xml
    spec/fixtures/sample.txt
    spec/fixtures/upload_slideshow.xml
    spec/slide_share/base_spec.rb
    spec/slide_share/slideshows_spec.rb
  }
  s.require_paths = %w{lib}
  s.has_rdoc = true
  s.extra_rdoc_files = %w{MIT-LICENSE README.rdoc}
  s.rdoc_options = %w{--main README.rdoc --charset utf-8 --line-numbers}
  
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
   
    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency("httparty", [">= 0.2.6"])
      s.add_runtime_dependency("curb", [">= 0.1.4"])
    else
      s.add_dependency("httparty", [">= 0.2.6"])
      s.add_dependency("curb", [">= 0.1.4"])
    end
  else
    s.add_dependency("httparty", [">= 0.2.6"])
    s.add_dependency("curb", [">= 0.1.4"])
  end
end