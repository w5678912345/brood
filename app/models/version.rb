# encoding: utf-8
class Version < ActiveRecord::Base
  require 'zipruby'
  require 'fileutils'
  require 'nokogiri'

  attr_accessible :no,:remark,:zip

  belongs_to :user, :class_name => 'User'
  belongs_to :release_user, :class_name => 'User'

  validates_uniqueness_of :no
 
  mount_uploader :zip, ZipUploader

  def update_config_xml_path
     xml_path =  File.dirname(self.zip.file.path)+"/UpdateConfig.xml"
     return xml_path
  end


  def upload
    self.save
    self.open_zip
    xml_path = self.update_config_xml_path
    if File.exists?(xml_path)
      doc = Nokogiri::XML(File.open(xml_path))
      self.update_attributes(:no => doc.xpath('//UpdateVersion').text)
    else

    end
  end


  def release
    self.push_to_s3
  	self.released = true
  	self.released_at = Time.now
    self.push_to_s3
  	self.save
  end

  def open_zip
  	filename = self.zip.file.path
  	path =  File.dirname(self.zip.file.path)+"/"
  	#
	  Zip::Archive.open(filename) do |ar|
	  ar.each do |zf|
	    if zf.directory?
	      FileUtils.mkdir_p(path+zf.name)
	    else
	      dirname = File.dirname(path+zf.name)
	      FileUtils.mkdir_p(dirname) unless File.exist?(dirname)
	      open(path+zf.name, 'wb') do |f|
	        f << zf.read
	      end
	    end
	  end
	 end
  end

  def push_to_s3
    s3 = AWS::S3.new
    bucket = s3.buckets['ccnt']
    dir = bucket.objects['update/tianyi/cn/test']
    xml = bucket.objects.create("update/tianyi/cn/test/UpdateConfig.xml","")
    xml.write(:file => self.update_config_xml_path,:acl=>:public_read)
    #
    version_path = File.dirname(self.zip.file.path) + "/#{self.no}"
    
    Dir[(version_path+'/*.*')].each do |file| 
      file_name = file[/[^\/]+$/]
      obj = bucket.objects.create("update/tianyi/cn/test/#{self.no}/#{file_name}","")
      obj.write(:file => file,:acl=>:public_read)
    end

  end

  after_destroy do |version|
    path = File.dirname(self.zip.file.path)
  	FileUtils.rm_r(path) if File.exists?(path) 
  end

end
