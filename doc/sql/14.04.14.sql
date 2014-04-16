

select count(DISTINCT accounts.no) from roles inner join accounts on roles.account = accounts.no
 where (SUBSTRING_INDEX(roles.server,'|',1) <> accounts.server) and accounts.server in('网通一区','网通二区','网通三区','网通五区') 
 and roles.server is not null and roles.server != ''



 select roles.id,roles.account from roles inner join accounts on roles.account = accounts.no
 where (SUBSTRING_INDEX(roles.server,'|',1) <> accounts.server) and accounts.server in('网通一区','网通二区','网通三区','网通五区') limit 10;


 select count(id) from accounts where normal_at = '2014-04-14 00:00:00' and bind_computer_id > 0;


 select accounts.no from accounts where normal_at = '2014-04-14 00:00:00' and bind_computer_id > 0 limit 20;




update roles inner join accounts on roles.account = accounts.no
 set roles.level = 0 ,roles.server = null,roles.is_agent=0 
 where accounts.normal_at = '2014-04-14 00:00:00';
