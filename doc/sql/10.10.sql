TRUNCATE TABLE accounts;

# 修改notes 的账户 为对应角色的 账户
update notes set account = (select account from roles where id = role_id);

# 修改notes 的server 为对应角色的 server
update notes set server = (select server from roles where id = role_id);

# 修改notes 的 api_name
# select count(id),api_name from notes group by api_name;
update notes set api_name = 'role_start' where api_name = 'role_online' or api_name = 'online';
update notes set api_name = 'role_stop' where api_name = 'role_offline' or api_name = 'offline';
update notes set api_name = 'restart_game' where api_name = 'RestartGame';

update notes set api_name = 'account_start' where api_name = 'account_online';
update notes set api_name = 'account_stop' where api_name = 'account_offline';
update notes set api_name = 'role_success' where api_name = 'success';
update notes set api_name = 'answer_verify_code' where api_name = 'AnswerVerifyCode';
#
update notes set api_name = 'computer_start' where api_name = 'computer_online' or api_name = 'start_computer';
update notes set api_name = 'computer_stop' where api_name = 'computer_offline' or api_name = 'stop_computer';



# 修改notes 的hostname 为对应computer的 hostname

update notes set hostname = (select hostname from computers where id = computer_id);

# 修改角色状态
update roles set status = 'normal' where status = '1';
# 修改角色状态
update roles set status = 'disable' where status = '0';


# select count(DISTINCT role_id) from notes where api_name = 'NoRmsFile';

# 导出测试服 NoRmsFile 的角色

select DISTINCT r.account,r.password from roles as r inner join notes as n on r.id = n.role_id where r.level < 40 and n.api_name = 'NoRmsFile' into outfile '/tmp/noRmsFile.txt';
