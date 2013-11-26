# encoding: utf-8
class DataNodesController < ApplicationController


	def index
		@data_nodes = DataNode.order("created_at desc").paginate(:page => params[:page], :per_page => 20)
	end


	def mark
		DataNode.mark
		redirect_to data_nodes_path
	end


	def chart
		@start_date = Date.today - 7.day 
		@end_date = Date.today + 1.day
		@start_date = Date.parse(params[:start_date]) unless params[:start_date].blank?
		@end_date = Date.parse(params[:end_date])  unless params[:end_date].blank?



		@records = DataNode.select("date(created_at) as day,accounts").date_scope(@start_date,@end_date).order("created_at asc").group("date(created_at)")
		@status= Account::STATUS.keys
		
		@d = []

		@days = @records.map(&:day)
		@status.each do |s|
			_data = []
			@records.each do |r|
				tmp = eval(r.accounts)
				_data<< (tmp[s.to_s] || 0)
			end
			@d << {:name=>s,:data =>_data}
		end

		#render :text => @d.as_json
		# :text => @d
	end

end