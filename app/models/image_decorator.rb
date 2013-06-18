#encoding:utf-8
Spree::Image.class_eval do
  has_attached_file :attachment,
                    :styles => { :mini => '48x48>', :small => '100x100>', :product => '240x240>', :large => '600x600>' },
                    :default_style => :product,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml",
                    :bucket => ENV['AWS_BUCKET'],
                    :convert_options => { :all => '-strip -auto-orient' }

end
