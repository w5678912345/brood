class RoleReportsController < ApplicationController
  def index
  end
  def show
    @cols = {"roles.profession" => "职业","roles.level"=>"等级"} 
    @col = params[:col] || "accounts.server"
    @status = ["discardfordays","discardforyear","discardforweek","disconnect"]
    params[:status] = 'disconnect' if not params[:status].present?
    @records = HistoryRoleSession.joins(:role).select("count(*) as roles_count, #{@col} as col").group(@col)
    .reorder("roles_count desc").where("history_role_sessions.created_at > ?",Time.now.beginning_of_day)
    @records = @records.where(:server => params[:server]) if params[:server].present?
    @records = @records.where("accounts.status" => params[:status]) if params[:status].present?
  end
end