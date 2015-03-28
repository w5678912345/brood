class PhoneTasksController < ApplicationController
  # GET /phone_tasks
  # GET /phone_tasks.json
  def index
    @phone_tasks = initialize_grid(PhoneTask,
      :order => 'phone_tasks.id',
      :order_direction => 'desc',
    )

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @phone_tasks }
    end
  end

  # GET /phone_tasks/1
  # GET /phone_tasks/1.json
  def show
    @phone_task = PhoneTask.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @phone_task }
    end
  end

  # GET /phone_tasks/new
  # GET /phone_tasks/new.json
  def new
    @phone_task = PhoneTask.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @phone_task }
    end
  end

  # GET /phone_tasks/1/edit
  def edit
    @phone_task = PhoneTask.find(params[:id])
  end

  # POST /phone_tasks
  # POST /phone_tasks.json
  def create
    @phone_task = PhoneTask.new(params[:phone_task])

    respond_to do |format|
      if @phone_task.save
        format.html { redirect_to @phone_task, notice: 'Phone task was successfully created.' }
        format.json { render json: @phone_task, status: :created, location: @phone_task }
      else
        format.html { render action: "new" }
        format.json { render json: @phone_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /phone_tasks/1
  # PUT /phone_tasks/1.json
  def update
    @phone_task = PhoneTask.find(params[:id])

    respond_to do |format|
      if @phone_task.update_attributes(params[:phone_task])
        format.html { redirect_to @phone_task, notice: 'Phone task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @phone_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phone_tasks/1
  # DELETE /phone_tasks/1.json
  def destroy
    @phone_task = PhoneTask.find(params[:id])
    @phone_task.destroy

    respond_to do |format|
      format.html { redirect_to phone_tasks_url }
      format.json { head :no_content }
    end
  end
end
