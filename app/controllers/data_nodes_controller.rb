# encoding: utf-8
class DataNodesController < ApplicationController


	def index
		@data_nodes = DataNode.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
	end


	def mark
		DataNode.mark
		redirect_to data_nodes_path
	end

end