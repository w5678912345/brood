 SELECT DISTINCT `accounts`.no,`roles`.level FROM `accounts` 
 INNER JOIN `roles` ON `roles`.`account` = `accounts`.`no`
  WHERE (accounts.session_id = 0) 
  AND (accounts.normal_at <= '2013-11-15 16:02:41' ) 
  AND ( roles.status = 'normal' and roles.session_id = 0 and roles.online = 0 and roles.today_success = 0) 
  AND (roles.level < 65) 
  ORDER BY roles.level desc LIMIT 1;



 select no,a.password,r.id from accounts as a inner JOIN roles as r on a.no = r.account where a.status = 'locked' and r.level > 30 and date(a.created_at) = '2013-11-21' LIMIT 3;



select no,a.password,a.server,r.level from accounts as a inner JOIN roles as r on a.no = r.account where a.status = 'locked' and r.role_index = 0 into outfile '/tmp/all_locked_account.txt';


select count(DISTINCT no) from accounts as a inner JOIN roles as r on a.no = r.account where a.status = 'locked' and r.level > 40;


select no,password from accounts where server = '上海1区' and  status = 'bslocked' limit 20 into outfile '/tmp/t20.txt';


