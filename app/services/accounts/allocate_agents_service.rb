module Accounts
  class AllocateAgentsService
    def initialize server_name = 'all',depth=2
      @server_name = server_name
      @depth = depth
    end
    def run
      clear_agent
      n = get_targets.count
      w = calculate_w(@depth,n)
      puts "n:#{n} w:#{w}"
      set_level(@depth,w)
      set_agent(@depth,w)
    end

#    private
      def get_targets
        if @server_name == 'all'
          Account
        else
          Account.where(server: @server_name)
        end
      end
      def clear_agent
        get_targets.update_all(:gold_agent_name => '',:gold_agent_level => 0)
      end
      def set_level(d,w)
        1.upto(d) do |i|
          get_targets.where(:gold_agent_level => 0).limit(w**i).update_all(:gold_agent_level => i)
        end
      end
      def set_agent(d,w)
        1.upto(d-1) do |i|
          get_targets.where(:gold_agent_level => i).each do |parent|
            get_targets.where(:gold_agent_level => i+1,:gold_agent_name => '').limit(w).update_all(:gold_agent_name => parent.roles.first.name)
          end
        end
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