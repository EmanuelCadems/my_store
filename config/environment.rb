# Load the rails application
require File.expand_path('../application', __FILE__)
require "#{Rails.root}/lib/load_sub_category.rb"
# Initialize the rails application
MyStore::Application.initialize!

ActiveRecord::Base.include_root_in_json = true
