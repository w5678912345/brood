class AliyunHelper
	# -*- encoding : utf-8 -*-
	require 'aliyun/oss'
	include Aliyun::OSS

	#连接信息
	Aliyun::OSS::Base.establish_connection!(
	  :server => 'oss.aliyuncs.com', #可不填,默认为此项
	  :access_key_id     => 'QuBc7LxHY0Ov7xL6', 
	  :secret_access_key => 'i57W4W7v6di74ObX4LZSa8NbejTF2d'
	)


	def self.hi
		#p Service.buckets #罗列Bucket

		
		#return bucket.objects
		#bucket.objects 
		#Bucket.list
		
	end

	def self.get_objects prefix
		bucket = Bucket.find("ccnt-hz")
		bucket.objects(:prefix => prefix)
	end

end

