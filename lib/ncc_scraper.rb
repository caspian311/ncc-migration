require "capybara/rspec"

include Capybara::DSL

Capybara.current_driver = :selenium 
Capybara.app_host = "http://www.ncc-stl.org/"
Capybara.run_server = false 
Capybara.default_selector = :css 

class NccScraper
   def scrape_site
      visit "/site/cpage.asp?sec_id=1673&cpage_id=1982"

      all("a.page").each do |page_link|
         puts page_link[:href]
      end
   end
end
