module AccountReportHelper
  def account_status_cn s
    case s
      when "normal"
        "正常"
      when "bslocked"
        "交易锁定"
      when "discardforyears"
        "封停"
      when "discardbysailia"
        "赛利亚"
      else
        raw('<span class="badge badge-warning">其他</span>')
    end
  end

  def account_status_select_all
    {'正常' => 'normal','交易锁定' => 'bslocked',"封停" => 'discardforyears',"赛利亚" => 'discardbysailia'}
  end
end
