# encoding: utf-8
class VersionsController < ApplicationController
	
	 load_and_authorize_resource :class => "Version"
	 after_filter  :set_version
  #

	def index
		@versions = Version.order("id desc").paginate(:page => params[:page], :per_page => 15)
	end

	def new
		@version = Version.new
	end

	def create
		@version = Version.new(params[:version])
		@version.user = current_user
		if @version.valid? 
			@version.upload
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

		@objects = bucket.objects #.with_prefix('update/tianyi/cn/')
		@objects = @objects.with_prefix(params[:prefix]) unless params[:prefix].blank?
		#@tree = @objects.as_tree
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
