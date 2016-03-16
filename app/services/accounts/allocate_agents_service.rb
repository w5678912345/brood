module Accounts
  class AllocateAgentsService
    def initialize server_name = 'all',depth=2
      @MAX_W = 20
      @server_name = server_name
      @depth = depth
      @level_targets = {}
    end
    def run
      if @server_name == 'all'
        Server.select(:name).map(&:name).each do |s|
          @server_name = s
          reset_agent_tree
        end
      else
        reset_agent_tree
      end
    end
    def reset_agent_tree
      reset_agent
      n = get_targets.count
      return if n == 0
      top_sell_count = TopSell.where(:server_name => @server_name).count
      n = n / top_sell_count if top_sell_count > 0
      w = calculate_w(@depth,n)
      w = 20 if w < 20
      puts "n:#{n} w:#{w}"
      set_level(@depth,w)
      set_agent(@depth,w)

    end
    def append_agents
    end
#    private
      def get_targets
        Account.where("bind_computer_id > 0").where(:status => ['normal','delaycreate','disconnect'])
          .where(server: @server_name)
      end
      def ordered_targets_info
        Role.select("roles.id,account,max(level) as level").joins(:qq_account)
          .where('bind_computer_id > 0 and accounts.server = ?',@server_name)
          .where("accounts.status in (?)",['normal','delaycreate','disconnect']).where("roles.status = 'normal'")
          .order('level desc').group(:account)
      end
      def reset_agent
        Account.where("gold_agent_name <> '收币直通车'").where(server: @server_name)
              .update_all(:gold_agent_name => '',:gold_agent_level => 0)
        Role.joins(:qq_account).where("accounts.server = ?",@server_name).update_all(:is_seller => false)
      end
      def set_level(d,w)
        #等级大的才能成为一级代理,一个角色能转出的钱为 等级^2 * 10000
        #这里在设置的时候是从根往叶子的方向,所以先设置
        top_sell_capacity = TopSell.where(:server_name => @server_name).count
        1.upto(d) do |i|
          old_agent_count = get_targets.where("gold_agent_level = ?",i).count
          current_capacity = top_sell_capacity*(w**i) - old_agent_count
          @level_targets[i] = ordered_targets_info.where("gold_agent_level = 0").first(current_capacity)
          current_accounts = @level_targets[i].map &:account
          Account.where(:no => current_accounts).update_all(:gold_agent_level => i)
        end
      end
      def set_agent(d,w)
        1.upto(d-1) do |i|
          #最后一层,可能不满,平均分布
          if(i == d-1)
            total_c = get_targets.where(:gold_agent_level => i+1,:gold_agent_name => '',:server => @server_name).count
            parent_c = get_targets.where("gold_agent_level = ?",i).count
            parent_c = 1 if parent_c == 0
            puts("this is a mark:",total_c,parent_c)
            if parent_c > 0
              w = total_c / parent_c + 1
            else
              w = total_c
            end
          end
          ordered_targets_info.where("gold_agent_level = ?",i).count
          ordered_targets_info.where("gold_agent_level = ?",i).each do |t|
            seller = Role.find_by_id(t.id)
            if seller
              seller.update_attributes(:is_seller => true)
              get_targets.where(:gold_agent_level => i+1,:gold_agent_name => '',:server => @server_name).limit(w).update_all(:gold_agent_name => seller.name)
            end
          end
        end
        get_targets.where(:gold_agent_level => 1).update_all :gold_agent_name => Api::BaseController.LAST_GOLD_AGENT_NAME
      end
      def calculate_w(d,n,e = 1)
        #牛顿迭代法找大于1的解
        #w^(d+1)-n*w+n-1=0
        #f(w)=w^(d+1)-n*w+n-1  , f'(w)=w^d-n
        #f(w1)=w1^(d+1)-n*w1+n-1 , f'(w1)=w1^d - n , (x-w1)/(y-f(w1))=f'(w1)
        #下一个迭代点为x = w1 - f(w1)*f'(w1)
        re = 100
        w = n
        while re >= e do
          wn = calc_w_imp(d,n,w)
          re = (wn - w).abs.round
          w = wn
        end
        w
      end
      def calc_w_imp(d,n,wi)
        f = wi**(d+1) - n*wi + n-1
        df = (d+1)*wi**d - n
        wi1 = wi-f/df
        #puts "wi = #{wi},f(wi) = #{f} , f'(wi) = #{df} , w(i+1) = #{wi1}"
        wi1
      end
  end
end