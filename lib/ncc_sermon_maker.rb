require "capybara/rspec"
include Capybara::DSL

APP_HOST = "http://cpmdb1.com"

Capybara.current_driver = :selenium
Capybara.app_host = APP_HOST
Capybara.run_server = false 
Capybara.default_selector = :css 

class NccSermonMaker
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

      begin
         while item = find("a.delete")
            item.click

            click_link "Delete"
         end
      rescue
         puts "done"
      end
   end

   def publish_sermons
      all_sermons do |sermon|      
         visit "/admin/sermons/add"

         begin
            select sermon.file_name, :from => "audio"

            fill_in "title", :with => sermon.title
            fill_in "description", :with => sermon.description

            click_link "Sermon Details"
            if sermon.date
               fill_in "date", :with => sermon.date
            end
            select sermon.category, :from => "category"
            select sermon.speaker, :from => "speaker"

            click_button "Publish Sermon"

            puts "Successfully processed: #{sermon.file_name}"
         rescue Exception => e
            puts "****************************************************"
            puts "Error: could not find audio file: #{sermon.file_name}"
            puts e
            puts "****************************************************"
         end
      end
   end

   def all_sermons
      Dir.glob("equip_mp3s/*.mp3") do |filename|
         filename[/equip_mp3s\//] = ""
         yield parse_sermon(filename)
      end
   end

   def parse_sermon(filename)
      sermon = Sermon.new

      filename =~ /^(.*) - (.*) -- (.*)\.mp3$/
      sermon.title = $1
      if $2 != "unknown_date"
         timestamp = Date.strptime $2, "%m-%d-%Y"
         sermon.date = timestamp.strftime "%m/%d/%Y"
      end

      sermon.speaker = $3
      sermon.file_name = "#{$1} - #{$2} -- #{$3}"
      sermon.category = "Equip - Sunday Morning Educational Hour"

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
      fill_in "password", :with => "************"
      
      find("input.login").click
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
