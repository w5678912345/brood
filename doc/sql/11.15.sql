 SELECT DISTINCT `accounts`.no,`roles`.level FROM `accounts` 
 INNER JOIN `roles` ON `roles`.`account` = `accounts`.`no`
  WHERE (accounts.session_id = 0) 
  AND (accounts.normal_at <= '2013-11-15 16:02:41' ) 
  AND ( roles.status = 'normal' and roles.session_id = 0 and roles.online = 0 and roles.today_success = 0) 
  AND (roles.level < 65) 
  ORDER BY roles.level desc LIMIT 1;