class AppSettings < Settingslogic
  source "#{Rails.root}/config/app_config.yml"
  namespace Rails.env
  def self.version
    '1.0.0'
  end 
end