source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails',              '3.2.13'
gem 'jquery-rails',       '2.2.1'
gem 'spree',              '1.3.2'
gem 'spree_gateway',      :github => 'spree/spree_gateway', :branch => '1-3-stable'
gem 'spree_auth_devise',  :github => 'spree/spree_auth_devise', :branch => '1-3-stable'
gem 'spree_fancy',        :github => 'spree/spree_fancy', :branch => '1-3-stable'
gem 'rails-i18n'
gem 'spree_i18n',         '1.0.0'
gem 'therubyracer',       '0.11.4'
gem 'rails-erd',          '~> 1.1.0'
gem 'figaro',             '0.6.4'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'sqlite3',      '1.3.7'
end

group :production do
  gem 'pg'
  gem 'thin'
  gem 'aws-sdk'
end
