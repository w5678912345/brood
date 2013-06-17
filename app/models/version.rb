# encoding: utf-8
class Version < ActiveRecord::Base
  require 'zipruby'
  require 'fileutils'

  attr_accessible :no,:remark,:zip

  belongs_to :user, :class_name => 'User'
  belongs_to :release_user, :class_name => 'User'
 
  mount_uploader :zip, ZipUploader


  def release
  	self.released = true
  	self.released_at = Time.now
  	self.open_zip
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
  	
  end


  

  after_destroy do |version|
  	FileUtils.rm_r(File.dirname(self.zip.file.path))
  end

end
