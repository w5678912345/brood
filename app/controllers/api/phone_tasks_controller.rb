# encoding: utf-8
class Api::PhoneTasksController < Api::BaseController
  def create
    @phone_task = PhoneTask.create params[:phone_task]
    if @phone_task.nil?
      @code = CODES[:errors]
    else
      @code = CODES[:success]
    end
    render 'show.json'
  end
  def show
    @phone_task = PhoneTask.find_by_id params[:id]
    if @phone_task.nil?
      @code = CODES[:errors]
    else
      @code = CODES[:success]
    end
  end
  def get_by_iccid
    phone = Phone.find_by_iccid params[:iccid]
    @phone_tasks = []
    if phone
      phone_tasks_query = phone.phone_tasks.where(:status => 'waiting')
      @phone_tasks = phone_tasks_query.all 
      phone_tasks_query.update_all(:status => 'sending')
    end
  end
  def finish
    @phone_task = PhoneTask.find_by_id params[:phone_task_id]
    @phone_task.update_attributes :status => 'finished',:result => params[:result]
    render :json => {:code => 1}
  end
end
