require "spec_helper"
require "ncc_scraper"

describe "NccScraper" do
   describe "scrape_site" do
      it "should pull in stuff" do
         NccScraper.new.scrape_site
      end
   end
end
