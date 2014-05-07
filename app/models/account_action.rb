module AccountAction
	def hello
		render :text => "hello"
	end

	def set_rms_file
		return render :json => {:code=>0} if params[:val].blank?
		normal_at = Time.now.since(1200.hours)
		@account.update_attributes(:rms_file=>params[:val].to_i)
		render :json=>{:code => 1}
	end
end