require "capybara/rspec"
APP_HOST = "http://www.ncc-stl.org/"
include Capybara::DSL

Capybara.current_driver = :selenium
Capybara.app_host = APP_HOST
Capybara.run_server = false 
Capybara.default_selector = :css 

class NccScraper
   def initialize
      @id = 0
   end

   def scrape_site(initial_page)
      visit initial_page

      download_content

      all_pages.each do |link|
         visit link
         download_content
      end
   end

   def download_content
      all(:xpath, "//div[contains(@id, 'audioRecordaudio')]").each do |div|
         @id = @id + 1
         within(div) do
            meta_data = all(:xpath, "/div/div/div").text.each_line.to_a

            title = meta_data[0].strip
            author = meta_data[1].strip
            verse = meta_data[2].strip
            date = meta_data[3].strip
            description = "something"
            link = find(:css, "#audioDownload a")[:href]

            File.open('sermons.txt', 'a') do |file|
               file.puts "#{@id}\t#{title}\t#{author}\t#{verse}\t#{date}\t#{description}\t#{link}"
            end
            system "wget -O mp3s/#{@id}.mp3 #{link}"
         end
      end
   end

   def all_pages
      pages = []
      all("a.page").each do |page_link|
         pages = pages | [ page_link[:href] ]
      end
      pages
   end
end
