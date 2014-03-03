du -s /home/* | sort -nr

df -h 

du -h -s /* | sort -nr


# 因为那些文件都还在打开的状态被你删除了，虽然你在硬盘上删除了文件，但是系统还认为这些文件还存在，你可以
# 看看，应该有很多你之前删除，但是还被系统打开的文件，找到相应的id，kill之。

lsof |grep delete


# 000CEF8B000FAEC7

gem install nokogiri -v 1.5.9 --with-xml2-include=/usr/local/Cellar/libxml2/2.9.1/include/libxml2 --with-xml2-lib=/usr/local/Cellar/libxml2/2.9.1/lib --with-xslt-dir=/usr/local/Cellar/libxslt/1.1.28



gem install nokogiri -v 1.5.9 -- --with-xml2-include=/usr/local/Cellar/libxml2/2.9.1/include/libxml2 --with-xml2-lib=/usr/local/Cellar/libxml2/2.9.1/lib --with-xslt-dir=/usr/local/Cellar/libxslt/1.1.28
