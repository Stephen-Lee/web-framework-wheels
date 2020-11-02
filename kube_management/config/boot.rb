File.expand_path('./Gemfile', __dir__)

# handle dependence
require 'bundler/setup'
Bundler.require(:default)

# load files
Dir[File.dirname(__FILE__) + "/../controllers/*.rb"].each { |file| require file }