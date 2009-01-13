require "rake"
require "rake/rdoctask"

desc "Generate RDoc documentation for SlideShare library"
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "doc"
  rdoc.title = "SlideShare API Ruby Library"
  rdoc.options << "--line-numbers" << "--inline-source"
  rdoc.rdoc_files.include("README")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  require 'spec'
end
begin
  require 'spec/rake/spectask'
rescue LoadError
  puts <<-EOS
   To use rspec for testing you must install rspec gem:
   gem install rspec
EOS
  exit 0
end

task :default => :spec

desc "Run the specs for SlideShare library"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ["--options", "spec/spec.opts"]
  t.spec_files = FileList["spec/**/*_spec.rb"]
end