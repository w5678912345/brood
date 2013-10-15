# 导出所有locked 的号
select account from roles where locked = 1 into outfile '/tmp/locked_roles.txt';