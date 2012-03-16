
Dir["lib/*.rb"].each do |file|
   import file
end

desc "test app"
task :test do
   
end

desc "pull all data from all pages"
task :download do
   NccScraper.scrape_site
end

desc "upload all data to new site"
task :upload do
   NccPublisher.push_data
end

desc "run all tests"
task :default => :test
