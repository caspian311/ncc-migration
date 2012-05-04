require "capybara/rspec"
include Capybara::DSL

APP_HOST = "http://www.ncc-stl.org/"
SERMON_FILE="sermons.txt"
YOUTH_SERMON_FILE="youth_sermons.txt"

Capybara.current_driver = :selenium
Capybara.app_host = APP_HOST
Capybara.run_server = false 
Capybara.default_selector = :css 

class NccScraper
   @@id = 0

   def initialize(is_youth)
      @is_youth = is_youth
   end

   def scrape_site
      visit initial_page

      download_content

      all_pages.each do |link|
         visit link
         download_content
      end
   end

   def download_content
      all(:xpath, "//div[@class='audioInfo']").each do |div|
         @@id = @@id + 1
         within(div) do
            meta_data = all(:xpath, "/div").text.each_line.to_a

            title = strip_if_not_empty meta_data[0]
            author = strip_if_not_empty meta_data[1]
            verse = strip_if_not_empty meta_data[2]
            date = strip_if_not_empty meta_data[3]

            description = ""
            if not @is_youth
               find(:css, "div.audioInfo").click
               description = find(:css, "#audioDescription").text.strip
            end

            if @is_youth
               link = find(:xpath, "//div[@id='audioDownload']/a[1]")[:href]
            else
               link = find(:css, "#audioDownload a")[:href]
            end
            link.gsub!(" ", "%20")

            File.open(sermon_file, 'a') do |file|
                file.puts "#{@@id}\t#{title}\t#{author}\t#{verse}\t#{date}\t#{description}\t#{link}"
             end

            system "wget -O mp3s/#{@id}.mp3 #{link}"
         end
      end
   end

   def strip_if_not_empty(value)
      value == nil ? "" : value.strip
   end

   def sermon_file
      @is_youth ? YOUTH_SERMON_FILE : SERMON_FILE 
   end

   def initial_page
      @is_youth ? "/site/cpage.asp?cpage_id=17450&sec_id=901" : "/site/cpage.asp?sec_id=1673&cpage_id=1982"
   end

   def all_pages
      pages = []
      all("a.page").each do |page_link|
         pages = pages | [ page_link[:href] ]
      end
      pages
   end
end
