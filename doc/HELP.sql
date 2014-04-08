select count(id) as cc, SUBSTRING_INDEX(msg,'/',1)  as ss from notes 
	where api_name = 'disconnect' and date(created_at) = '2014-04-05' group by ss order by cc;


select count(t1.account) as cc,SUBSTRING_INDEX(t2.msg,'/',1) as map from

(select id,account,created_at from notes where api_name ='discardfordays' and date(created_at)='2014-04-07') as t1

left join (select id,account, msg,created_at from notes where api_name ='disconnect' and date(created_at) = '2014-04-07')  as t2

on t1.account = t2.account where TIMESTAMPDIFF(Second,t2.created_at,t1.created_at) < 90

group by map order by cc;



select t1.account from 

(select id,account from notes where api_name ='discardfordays' and date(created_at)='2014-04-06') as t1

left join (select id,account, msg from notes where api_name ='disconnect' and date(created_at) = '2014-04-06')  as t2

on t1.account = t2.account where SUBSTRING_INDEX(t2.msg,'/',1) = '补给线阻断'


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
