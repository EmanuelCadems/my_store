#encoding: utf-8
class Ftp

  def self.download(url)
    require "open-uri"


    url["ftp://torcaweb"] = "ftp://"+ENV["USER_FTP"]+":"+ENV["PASSWORD_FTP"]
    name = url.split("/").last

    open("./tmp/#{name}", 'wb') do |file|
      begin
        file << open(url).read
      rescue Exception => e
        puts "Doesn't may download the csv file because have ocurred the next errors:"
        puts e.message
      end
    end

    name
  end
end
