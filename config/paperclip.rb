if Rails.env.development?
  Paperclip::Attachment.default_options[:storage] = :filesystem
end

if Rails.env.production?
  Paperclip::Attachment.default_options[:storage] = :s3
  Paperclip::Attachment.default_options[:s3_credentials] =  {
    access_key_id: ENV["AWS_ACCESS_KEY_ID"], 
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    bucket: ENV['AWS_BUCKET']
  }
end
