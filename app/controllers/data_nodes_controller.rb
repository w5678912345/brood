# encoding: utf-8
class DataNodesController < ApplicationController


	def index
		@data_nodes = DataNode.order("created_at desc").paginate(:page => params[:page], :per_page => 20)
	end


	def mark
		DataNode.mark
		redirect_to data_nodes_path
	end

	def add_array(a,b)
  		a.zip(b).map{|pair| pair.reduce(&:+) }
	end

	def chart
		@start_date = Date.today - 7.day
		@end_date = Date.today + 1.day
		@start_date = Date.parse(params[:start_date]) unless params[:start_date].blank?
		@end_date = Date.parse(params[:end_date])  unless params[:end_date].blank?

		#开始时间向前推1天用于计算差值
		@start_date -= 1.day 

		@records = DataNode.select("date(created_at) as day,accounts").date_scope(@start_date,@end_date).order("created_at asc").group("date(created_at)")
		@status= Account::STATUS.keys
		@key_status = ["bslocked","locked","discardforyears"]
		@d = []

		@days = @records.map(&:day)

		all_data = {}
		@status.each do |s|
			_data = []
			all_data[s.to_s] = []

			@records.each do |r|
				tmp = eval(r.accounts)
				all_data[s.to_s] << (tmp[s.to_s] || 0)
			end
		end

		type = 'column'
		yAxis = 1
		@key_status.each do |s|
			@d << {:type => type,:yAxis => yAxis,:name=>s.to_s,:stack=>'bad_delta',:data =>all_data[s.to_s].each_cons(2).map { |a,b| b-a }}
		end

		other_data=nil
		@status.each do |s|
			if @key_status.include?(s.to_s) != true and s.to_s != 'normal'
				other_data = (other_data || all_data[s.to_s])
				other_data = add_array(other_data,all_data[s.to_s]) if other_data
			end
		end

		@d << {:type => type,:yAxis => yAxis,:name=>"other",:stack=>'bad_delta',:data =>other_data.each_cons(2).map { |a,b| b-a }}
		yAxis = 0
		type = 'line' 
		all_data["normal"].shift
		@d << {:type => type,:yAxis => yAxis,:name=>"normal",:color=>'#89A54E',:stack=>'good',:data =>all_data["normal"]}


		#去掉用作差值的第一个元素
		@days.shift
	end

end