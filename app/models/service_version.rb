class ServiceVersion < Settingslogic
  source "#{Rails.root}/config/version.yml"
  namespace Rails.env
end