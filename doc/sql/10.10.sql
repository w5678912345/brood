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


# select count(DISTINCT role_id) from notes where api_name = 'NoRmsFile';

# 导出测试服 NoRmsFile 的角色

select DISTINCT r.account,r.password from roles as r inner join notes as n on r.id = n.role_id where r.level < 40 and n.api_name = 'NoRmsFile' into outfile '/tmp/noRmsFile.txt';
