# encoding: utf-8
class DataNodesController < ApplicationController


	def index
		@data_nodes = DataNode.order("created_at desc")
	end


	def mark
		DataNode.mark
		redirect_to data_nodes_path
	end

	def add_array(a,b)
  		a.zip(b).map{|pair| pair.reduce(&:+) }
	end
	def chart_data(records)
		@status= Account::STATUS.keys

		all_data = {}
		@status.each do |s|
			_data = []
			all_data[s.to_s] = []

			records.each do |r|
				tmp = eval(r.data)
				all_data[s.to_s] << (tmp[s.to_s] || 0)
			end
		end
		all_data
	end
	def chart
		@start_date = Date.today - 7.day
		@end_date = Date.today + 1.day
		@start_date = Date.parse(params[:start_date]) unless params[:start_date].blank?
		@end_date = Date.parse(params[:end_date])  unless params[:end_date].blank?

		#开始时间向前推1天用于计算差值
		@start_date -= 1.day 

		@records = DataNode.where(:source=>"accounts").select("date(marked_at) as day,accounts").date_scope(@start_date,@end_date).order("marked_at asc").group("date(marked_at)")
		@days = @records.map(&:day)
		all_data = chart_data(@records)

		@key_status = ["bslocked","locked","discardforyears","lost","exception","disconnect","discardbysailia"]
		@d = []

		type = 'column'
		yAxis = 1

		@key_status.each do |s|
			if all_data[s.to_s]
				@d << {:type => type,:yAxis => yAxis,:name=>s.to_s,:stack=>'bad_delta',:data =>all_data[s.to_s].each_cons(2).map { |a,b| b-a }}
			end
		end

		other_data=nil

		@status= Account::STATUS.keys
		@status.each do |s|
			if @key_status.include?(s.to_s) != true and s.to_s != 'normal' and all_data[s.to_s]
				other_data = (other_data || all_data[s.to_s])
				other_data = add_array(other_data,all_data[s.to_s]) if other_data
			end
		end
		#binding.pry
		if other_data
			@d << {:type => type,:yAxis => yAxis,:name=>"other",:stack=>'bad_delta',:data =>other_data.each_cons(2).map { |a,b| b-a }}
		end
		yAxis = 0
		type = 'line' 
		if all_data["normal"]
			all_data["normal"].shift
			@d << {:type => type,:yAxis => yAxis,:name=>"normal",:color=>'#89A54E',:stack=>'good',:data =>all_data["normal"]}
		end

		#去掉用作差值的第一个元素
		@days.shift
		@start_date += 1.day 
	end

	def old_chart
		@start_date = Date.today - 7.day
        @end_date = Date.today + 1.day
        @start_date = Date.parse(params[:start_date]) unless params[:start_date].blank?
        @end_date = Date.parse(params[:end_date])  unless params[:end_date].blank?



        @records = DataNode.where(:source=>"accounts").select("date(marked_at) as day,accounts").date_scope(@start_date,@end_date).order("created_at asc").group("date(created_at)")
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

	end


end