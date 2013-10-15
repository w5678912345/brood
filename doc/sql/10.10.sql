TRUNCATE TABLE accounts;

# 修改notes 的账户 为对应角色的 账户
update notes set account = (select account from roles where id = role_id);

# 修改notes 的server 为对应角色的 server
update notes set server = (select server from roles where id = role_id);


# 修改notes 的hostname 为对应computer的 hostname

update notes set hostname = (select hostname from computers where id = computer_id);

# 修改角色状态
update roles set status = 'normal' where status = '1';
# 修改角色状态
update roles set status = 'disable' where status = '0';