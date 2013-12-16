# mysqldump -u root -p brood_production>brood.sql

#
# mysql -u root -p brood_hello<~/brood_new.sql
TRUNCATE TABLE accounts;

# 修改notes 的账户 为对应角色的 账户
update notes set account = (select account from roles where id = role_id);
# 修改notes 的server 为对应角色的 server
update notes set server = (select server from roles where id = role_id);
# 修改notes 的hostname 为对应computer的 hostname
update notes set hostname = (select hostname from computers where id = computer_id);

# 修改角色状态
update roles set status = 'normal'; #where status = '1';
# 修改角色状态
#update roles set status = 'disable' where status = '0';

#STATUS = ['normal','bslocked','bslocked_again','bs_unlock_fail','disconnect','exception','locked','lost','discard','no_rms_file','no_qq_token']

# 修改notes 的 api_name
# select count(id),api_name from notes group by api_name;
# select count(id),date(created_at),api_name from notes group by date(created_at),api_name;


update notes set api_name = 'computer_reg' where api_name = 'reg';

#
update notes set api_name = 'role_start' where api_name = 'role_online' or api_name = 'online';
update notes set api_name = 'role_stop' where api_name = 'role_offline' or api_name = 'offline';
update notes set api_name = 'restart_game' where api_name = 'RestartGame';
update notes set api_name = 'weak' where api_name = 'StopReason';

update notes set api_name = 'account_start' where api_name = 'account_online';
update notes set api_name = 'account_stop' where api_name = 'account_offline';
update notes set api_name = 'role_success' where api_name = 'success';
update notes set api_name = 'answer_verify_code' where api_name = 'AnswerVerifyCode';
#
update notes set api_name = 'computer_start' where api_name = 'computer_online' or api_name = 'start_computer';
update notes set api_name = 'computer_stop' where api_name = 'computer_offline' or api_name = 'stop_computer';
# 修改 api_name
update notes set api_name = 'no_qq_token', api_code = 'no_qq_token' where api_name = 'NoQQToken';
update notes set api_name = 'no_rms_file', api_code = 'no_rms_file' where api_name = 'NoRmsFile';
update notes set api_name = 'locked', api_code = 'locked' where api_name = 'lock';
update notes set api_name = 'lost', api_code = 'lost' where api_name = 'lose';

# 角色
update notes set api_name = 'disable', api_code = 'disable' where api_name= 'role_disable';

#update notes set api_name = 'role_online' where api_name = 'role_dispatch';
	


delete from notes where api_name = 'auto_pay';


#TRUNCATE
+-----------+-------------------+
| count(id) | api_name          |
+-----------+-------------------+
|      1168 |                   |
|    845465 | AnswerVerifyCode  |
|        47 | auto_pay          |
|    120688 | bs_unlock_fail    |
|     44229 | bs_unlock_success |
|     63991 | bslock            |
|    127527 | close             |
|       134 | default           |
|     12878 | lock              |
|     16673 | lose              |
|      2000 | NoQQToken         |
|      3108 | NoRmsFile         |
|    759286 | offline           |
|    759963 | online            |
|      1436 | reg               |
|    128068 | reopen            |
|       104 | reset_ip          |
|       104 | reset_role        |
|    185676 | RestartGame       |
|      3757 | role_disable      |
|       189 | StopReason        |
|    358698 | success           |
+-----------+-------------------+

# 迁移测试服 
update notes set api_name = api_code where api_code in ('normal','bslocked','bslocked_again','bs_unlock_fail','disconnect','exception','locked','lost','discard','no_rms_file','no_qq_token','disable')


select id,status,no,updated_at from accounts where status in('disconnect', 'exception', 'lost', 'bslocked', 'bs_unlock_fail') and normal_at is null;

update accounts set normal_at = updated_at where status in('disconnect', 'exception', 'lost', 'bslocked', 'bs_unlock_fail') and normal_at is null;
	

select count(id) from notes where date(created_at) < '2013-11-18';

delete from notes where api_name = 'answer_verify_code' and date(created_at) < '2013-12-01';



select count(id) delete from notes where api_name not in('computer_start','account_start','role_start','role_online') and date(created_at) < '2013-11-30';

delete from notes where api_name not in('computer_start','account_start','role_start','role_online') and date(created_at) < '2013-12-05';




# select count(DISTINCT role_id) from notes where api_name = 'NoRmsFile';

# 导出测试服 NoRmsFile 的角色

select DISTINCT r.account,r.password from roles as r inner join notes as n on r.id = n.role_id where r.level < 40 and n.api_name = 'NoRmsFile' into outfile '/tmp/noRmsFile.txt';
