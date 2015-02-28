#!/bin/zsh
echo 当前版本
sed -n '/version:/p' config/version.yml
echo -n 输入新版本号\(默认不变\)：
read ver
if [ -n "$ver" ]
then
  mv config/version.yml config/version.yml.bak
  sed "s/version:.*/version: $ver/" config/version.yml.bak > config/version.yml
  echo "version is $ver"
  rm -f config/version.yml.bak
fi