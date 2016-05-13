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
      phone_ids = Phone.where(:iccid => params[:iccid]).map &:id
      @phone_tasks=[]
      return if phone_ids.empty?
      Phone.where(:no => phone_ids).update_all(:last_active_at => Time.now)

      phone_tasks_query = PhoneTask.where(:phone_id => phone_ids,:status => 'waiting')
      @phone_tasks = phone_tasks_query.all 
      phone_tasks_query.update_all(:status => 'sending')
  end
  def finish
    @phone_task = PhoneTask.find_by_id params[:phone_task_id]
    @phone_task.update_attributes :status => 'finished',:result => params[:result]
    render :json => {:code => 1}
  end
end
