
# 修改notes 的账户 为对应角色的 账户
update notes set account = (select account from roles where id = role_id);

# 修改notes 的server 为对应角色的 server
update notes set server = (select server from roles where id = role_id);
