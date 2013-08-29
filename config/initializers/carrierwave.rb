# encoding: utf-8
CarrierWave.configure do |config|
  config.storage = :aliyun
  config.aliyun_access_id = "QuBc7LxHY0Ov7xL6"
  config.aliyun_access_key = "i57W4W7v6di74ObX4LZSa8NbejTF2d"
  # 你需要在 Aliyum OSS 上面提前创建一个 Bucket
  config.aliyun_bucket = "1chi"
  # 是否使用内部连接，true - 使用 Aliyun 局域网的方式访问  false - 外部网络访问
  config.aliyun_internal = true
  # 使用自定义域名，设定此项，carrierwave 返回的 URL 将会用自定义域名
  # 自定于域名请 CNAME 到 you_bucket_name.oss.aliyuncs.com (you_bucket_name 是你的 bucket 的名称)
  #config.aliyun_host = "1chi.oss.aliyuncs.com"
end
