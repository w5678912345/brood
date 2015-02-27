#!/bin/zsh
echo 当前版本
sed -n '/version:/p' config/app_config.yml
echo -n 输入新版本号\(默认不变\)：
read ver
if [ -n "$ver" ]
then
  mv config/app_config.yml config/app_config.yml.bak
  sed "s/version:.*/version: $ver/" config/app_config.yml.bak > config/app_config.yml
  echo "version is $ver"
  rm -f config/app_config.yml.bak
fi