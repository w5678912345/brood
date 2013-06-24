# encoding: utf-8
# 金币产出
class OutputsController < ApplicationController
		
	def index
			@roles = Role.where("total > 0").paginate(:page => params[:page], :per_page => 15)
	end

	def home
		
	end

	def search

	end
		
	def histroy

	end

end
