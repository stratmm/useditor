require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'coveralls'
Coveralls.wear!

require 'pp'
require 'fakefs/spec_helpers'
require 'factory_girl'
require 'useditor'
require 'pry'

Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.tty = true
  config.color = true
end
