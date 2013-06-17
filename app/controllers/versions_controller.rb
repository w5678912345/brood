# encoding: utf-8
class VersionsController < ApplicationController

	 after_filter  :set_version
  #

	def index
		@versions = Version.order("no desc").paginate(:page => params[:page], :per_page => 15)
	end

	def new
		@version = Version.new
	end

	def create
		@version = Version.new(params[:version])
		@version.user = current_user
		if @version.save
			redirect_to versions_path
		else
			render :action => "new"
		end
	end

	def release
		@version = Version.find_by_id(params[:id])
		if @version
			@version.release_user = current_user
			@version.release
		end
		
		redirect_to versions_path
	end

	def s3
		s3 = AWS::S3.new
		bucket = s3.buckets['ccnt']

		@objects = bucket.objects.with_prefix('update/tianyi/cn/')
	end

	def destroy
		@version = Version.find_by_id(params[:id])
		@version.destroy if @version
		redirect_to versions_path
	end

	def current

	end

	private 
	def set_version
		
	end

end