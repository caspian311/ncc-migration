require "spec_helper"

describe NccScraper do
   describe "scrape_site" do
      it "should pull in stuff" do
         NccScraper.new.scrape_site
      end
   end
end
