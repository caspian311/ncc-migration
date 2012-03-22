require "spec_helper"

describe NccScraper do
   describe "scrape_site" do
      it "should pull in stuff" do
         NccScraper.new.scrape_site "/site/cpage.asp?sec_id=1673&cpage_id=1982"
      end
   end
end
