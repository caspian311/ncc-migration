require "rake/clean"

CLEAN = FileList["./mp3s/*"].include("sermons.txt")

Dir["./lib/*.rb"].each do |file|
   require file
end

desc "pull all data from main site"
task :download => ["download:main", "download:youth"] 

namespace :download do
   desc "pull all data from main site"
   task :main do
      NccScraper.new.scrape_site "/site/cpage.asp?sec_id=1673&cpage_id=1982"
   end

   desc "pull all data from youth site"
   task :youth do
      NccScraper.new.scrape_site "/site/cpage.asp?cpage_id=17450&sec_id=901"
   end
end

task :default => [:clean, :download]
