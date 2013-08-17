# encoding: utf-8
# @suxu
# 
class Api::TasksController < Api::BaseController


	def pull
		@computer = Computer.find_by_auth_key(params[:ckey])
		return @code = CODES[:not_find_computer] unless @computer
		@task = Task.where(:pushed=>false).where(:computer_id => @computer.id).where(:pushed=>false).first
		return @code = CODES[:not_find_task] unless @task
		@code = 1 if @task.update_attributes(:pushed=>true,:pushed_at=>Time.now)
		
	end

	def call
		@task = Task.find_by_id(params[:id])
		return @code = CODES[:not_find_task] unless @task
		success = params[:result].to_i
		@code = 1  if @task.update_attributes(:callback=>true,:success => success,:callback_at=>Time.now)
	end

end