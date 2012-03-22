require "rake/clean"

CLEAN = FileList["./mp3s/*"].include("sermons.txt")

Dir["./lib/*.rb"].each do |file|
   require file
end

desc "pull all data from all pages"
task :download do
   NccScraper.new.scrape_site
end

desc "upload all data to new site"
task :upload do
   NccPublisher.push_data
end

desc "run all tests"
task :test do
   sh "rspec spec/*_spec.rb"
end

task :default => [:clean, :download]
