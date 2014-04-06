select count(id) as cc,msg from notes 
	where api_name = 'disconnect' and date(created_at) = '2014-04-06' group by msg order by cc;

SELECT id, reopen_at,created_at,updated_at FROM `roles` WHERE `roles`.`close` = 1 
ORDER BY online desc, close asc, level desc, vit_power desc, updated_at DESC;

select count(id) as cc, msg from notes where api_name = 'dis'




SELECT api_name,count(id) as ecount FROM `notes` WHERE `notes`.`role_id` IN
 (SELECT DISTINCT role_id FROM `notes`  WHERE `notes`.`api_name` = 'online' AND (`notes`.`created_at` BETWEEN '2013-08-09 06:00:00' AND '2013-08-10 06:00:00') ORDER BY id DESC) AND (`notes`.`created_at` BETWEEN '2013-08-09 06:00:00' AND '2013-08-10 06:00:00')
GROUP BY api_name ORDER BY api_name asc



SELECT api_name,count(id) as ecount FROM `notes` 
 WHERE `notes`.`role_id` IN (SELECT DISTINCT role_id FROM `notes` 
  WHERE `notes`.`api_name` = 'online' 
  AND (`notes`.`created_at` BETWEEN '2013-08-09 06:00:00' AND '2013-08-10 06:00:00') ORDER BY id DESC) 
	AND (`notes`.`created_at` BETWEEN '2013-08-09 06:00:00' AND '2013-08-10 06:00:00') 
GROUP BY api_name ORDER BY api_name asc

#IP段统计
 select count(value),SUBSTRING_INDEX(value,'.',2) as id_range from ips where value <> 'localhost' group by id_range;


#

select count(value) as ccc,SUBSTRING_INDEX(value,'.',2) as id_range from ips where value <> 'localhost' group by id_range order by ccc desc;




select count(id) as ccc,ip_range from roles where server = '浙江1区' group by ip_range order by ccc;

+--------------+--------------+----------------+
| online_count | bslock_count | ip_range_count |
+--------------+--------------+----------------+
|         3145 |         7480 |              1 |
|         8878 |          297 |              2 |
|         4628 |            6 |              3 |
|         1031 |            1 |              4 |
|            3 |            1 |              5 |
+--------------+--------------+----------------+

TRUNCATE TABLE accounts;

update notes set account = (select account from role where id = role_id);
update notes set account = (select account from roles where id = role_id);





+-------------------+
| api_name          |
+-------------------+
| RestartGame       |
| reopen            |
| offline           |
| online            |
| AnswerVerifyCode  |
| success           |
| bslock            |
| bs_unlock_success |
| role_disable      |
| close             |
| bs_unlock_fail    |
| NoRmsFile         |
| NoQQToken         |
| lock              |
| lose              |
| reset_role        |
| reset_ip          |
| reg               |
| closed            |
| exception         |
| bslocked          |
| bslocked_again    |
| role_online       |
+-------------------+
