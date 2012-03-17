
Dir["./lib/*.rb"].each do |file|
   require file
end

RSpec.configure do |config|
   config.mock_with :rspec
end
