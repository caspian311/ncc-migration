require "rake/clean"

Dir["./lib/*.rb"].each do |file|
   require file
end

CLEAN = FileList["./mp3s/*"].include(SERMON_FILE).include(YOUTH_SERMON_FILE)

desc "pull all data from both the main site and the you site"
task :download => ["download:main", "download:youth"] 

namespace :download do
   desc "pull all data from main site"
   task :main do
      NccScraper.new(false).scrape_site
   end

   desc "pull all data from youth site"
   task :youth do
      NccScraper.new(true).scrape_site
   end
end

task :default => [:clean, :download]
