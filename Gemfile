source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails',        '3.2.13'
gem 'jquery-rails', '2.2.1'
gem 'spree',        '1.3.2'
gem 'spree_gateway', :github => 'spree/spree_gateway', :branch => '1-3-stable'
gem 'spree_auth_devise', :github => 'spree/spree_auth_devise', :branch => '1-3-stable'
gem 'spree_i18n', :git => 'git://github.com/spree/spree_i18n.git'


group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier',     '>= 1.0.3'
end

group :development, :test do
  gem 'sqlite3',      '1.3.7'
end

group :production do
  gem 'pg'
  gem 'thin'
end
