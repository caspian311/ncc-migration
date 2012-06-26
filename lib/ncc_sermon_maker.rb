require "capybara/rspec"
include Capybara::DSL

APP_HOST = "http://cpmdb1.com"
SERMON_FILE="sermons.txt"
YOUTH_SERMON_FILE="youth_sermons.txt"

Capybara.current_driver = :selenium
Capybara.app_host = APP_HOST
Capybara.run_server = false 
Capybara.default_selector = :css 

class NccSermonMaker
   def initialize(is_youth)
      @is_youth
   end

   def make_sermons
      login

      publish_sermons
   end

   def remove_sermons
      login

      remove_all_sermons
   end

   private

   def remove_all_sermons
      visit "/admin/sermons"

      while item = find("a.delete")
         item.click

         click_link "Delete"
      end
   end

   def publish_sermons
      all_sermons do |sermon|      
         visit "/admin/sermons/add"

         fill_in "title", :with => sermon.title
         select sermon.file_name, :from => "audio"
         fill_in "description", :with => sermon.description

         click_link "Sermon Details"
         fill_in "date", :with => sermon.date
         select sermon.category, :from => "category"
         select sermon.speaker, :from => "speaker"

         click_button "Publish Sermon"
      end
   end

   def all_sermons
      Dir.glob("main_mp3s/*.mp3") do |file_path|
         filename = file_path[/main_mp3s\//] = ""
         yield parse_sermon(filename)
      end
   end

   def parse_sermon(filename)
      sermon = Sermon.new

      filename =~ /^(.*) - (.*)\.mp3$/
      sermon.title = $1
      sermon.date = $2
      sermon.file_name = "#{sermon.title} - #{sermon.date}"
      sermon.category = choose_category
      sermon.speaker = "Jerry Marshall"

      sermon
   end

   def parse_references(line)
      line =~ /^([1-3]?\s?[A-Za-z\s]+)\s?([0-9]*-?[0-9]*)?:?([0-9]*-?[0-9]*)?$/
      book = $1
      chapter = $2
      verse = $3
   end

   def login
      visit "/login"

      fill_in "login", :with => "mtodd"
      fill_in "password", :with => "Matt2012Todd"
      
      find("input.login").click
   end

   def choose_category
      @is_youth ? "" : "Sunday Morning Sermons"
   end
end

class Sermon
   attr_accessor :file_name
   attr_accessor :title
   attr_accessor :description
   attr_accessor :date
   attr_accessor :speaker
   attr_accessor :category
end
