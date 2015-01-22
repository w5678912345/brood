class TicketRecordsController < ApplicationController
  # GET /ticket_records
  # GET /ticket_records.json
  def index
    @ticket_records = TicketRecord.where("1=1")
    @ticket_records = initialize_grid(@ticket_records) 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ticket_records}
    end
  end


  def report
    now = Time.now.since(1.days)
    params[:start_time] = now.ago(7.day).change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:start_time].blank?
    params[:end_time] = now.change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:end_time].blank?
      
    @records = TicketRecord.select("date(created_at) as Day,sum(gold - (gold%1000000)) as Gold, sum(points) as Points ")
    @records = @records.where("server like ?","#{params[:server]}%") unless params[:server].blank?
    @records = @records.group("Day").time_scope(params[:start_time],params[:end_time]).order("Day")

    @trade = {}
    @gold_sum = 0
    @points_sum = 0
    @records.each do |i|
      @trade[i.Day.to_s] = [i.Gold,i.Points]
      @gold_sum += i.Gold
      @points_sum += i.Points
    end

    start_time  = Date.parse(params[:start_time])
    end_time = Date.parse(params[:end_time])

    @dates = (start_time..end_time).to_a
    
  end

  # GET /ticket_records/1
  # GET /ticket_records/1.json
  def show
    @ticket_record = TicketRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ticket_record }
    end
  end

  # GET /ticket_records/new
  # GET /ticket_records/new.json
  def new
    @ticket_record = TicketRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ticket_record }
    end
  end

  # GET /ticket_records/1/edit
  def edit
    @ticket_record = TicketRecord.find(params[:id])
  end

  # POST /ticket_records
  # POST /ticket_records.json
  def create
    @ticket_record = TicketRecord.new(params[:ticket_record])

    respond_to do |format|
      if @ticket_record.save
        format.html { redirect_to @ticket_record, notice: 'Ticket record was successfully created.' }
        format.json { render json: @ticket_record, status: :created, location: @ticket_record }
      else
        format.html { render action: "new" }
        format.json { render json: @ticket_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ticket_records/1
  # PUT /ticket_records/1.json
  def update
    @ticket_record = TicketRecord.find(params[:id])

    respond_to do |format|
      if @ticket_record.update_attributes(params[:ticket_record])
        format.html { redirect_to @ticket_record, notice: 'Ticket record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ticket_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ticket_records/1
  # DELETE /ticket_records/1.json
  def destroy
    @ticket_record = TicketRecord.find(params[:id])
    @ticket_record.destroy

    respond_to do |format|
      format.html { redirect_to ticket_records_url }
      format.json { head :no_content }
    end
  end
end
