# encoding: utf-8

class Gold::ReportsController <Gold::AppController

  def show
    now = Time.now.since(1.days)
    params[:start_time] = now.ago(30.day).change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:start_time].blank?
    params[:end_time] = now.change(:hour => 0,:min => 0,:sec => 0).strftime("%Y-%m-%d %H:%M:%S") if params[:end_time].blank?
      
    @records = Payment.real_pay.select("date(created_at) as Day,server,sum(gold) Gold")
    @records = @records.group(["Day","server"]).time_scope(params[:start_time],params[:end_time]).order("Day")
    @servers = Payment.time_scope(params[:start_time],params[:end_time]).select("distinct(server)");
    @prices = GoldPriceRecord.select("date(created_at) as Day,servers.name as server,avg(max_price) as price").joins(:server).
      time_scope(params[:start_time],params[:end_time]).group(['Day','server'])
    @trade = {}
    @tradesum = 0
    @records.each do |i|
      @trade[i.Day.to_s] = {} if @trade[i.Day.to_s].blank?
      @trade[i.Day.to_s][i.server]=i.Gold
    end

   @daily_prices = {}
    @prices.each do |i|
      @daily_prices[i.Day.to_s] = {} if @daily_prices[i.Day.to_s].blank?
      @daily_prices[i.Day.to_s][i.server]=i.price
    end


    start_time  = Date.parse(params[:start_time])
    end_time = Date.parse(params[:end_time])

    @dates = start_time..end_time
    
  end

end
