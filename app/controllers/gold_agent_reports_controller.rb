class GoldAgentReportsController < ApplicationController
  def today
    @servers = Server.all.map &:name
    @total_count = Account.select("server,count(*) as cc").where(:gold_agent_level => 1)
          .group("server").inject({}) do |r,e|
            r[e.server] = e.cc
            r
          end
    @today_pay_count = Account.select("server,count(*) as cc").where(:gold_agent_level => 1).where("today_pay_count > 0")
          .group("server").inject({}) do |r,e|
            r[e.server] = e.cc
            r
          end
  end
end
