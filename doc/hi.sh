du -s /home/* | sort -nr

df -h 

du -h -s /* | sort -nr


# 因为那些文件都还在打开的状态被你删除了，虽然你在硬盘上删除了文件，但是系统还认为这些文件还存在，你可以
# 看看，应该有很多你之前删除，但是还被系统打开的文件，找到相应的id，kill之。

lsof |grep delete