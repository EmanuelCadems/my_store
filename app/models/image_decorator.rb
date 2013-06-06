require "open-uri"
Spree::Image.class_eval do
  has_attached_file :attachment,
                    :styles => { :mini => '48x48>', :small => '100x100>', :product => '240x240>', :large => '600x600>' },
                    :default_style => :product,
                    :url => '/spree/products/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/spree/products/:id/:style/:basename.:extension',
                    :convert_options => { :all => '-strip -auto-orient' }

  def attachment_from_url(url)
    url["ftp://torcaweb"] = "ftp://"+ENV["USER_FTP"]+":"+ENV["PASSWORD_FTP"]
    self.attachment = open(url)
  end
end
