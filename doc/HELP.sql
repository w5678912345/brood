
广东1区
浙江1区
安徽1区

select count(id) as cc, SUBSTRING_INDEX(notes.ip,'.',3) as ip_c from notes 
	where api_name = 'account_start' and date(created_at) between '2014-07-14' and  '2014-07-20' and (server= '安徽1区' or server = '广东1区' or server ='浙江1区') group by ip_c  order by cc desc;


select count(id) as cc, SUBSTRING_INDEX(notes.ip,'.',2) as ip_c from notes 
	where api_name = 'account_start' and date(created_at) between '2014-07-14' and  '2014-07-20'  group by ip_c  order by cc desc;

# 

select count(DISTINCT account) from notes where hostname not like 'FK%' and api_name ='account_start'
and created_at >= '2014-07-01 11:00:00' and created_at <= '2014-07-02 11:00:00';




select count(DISTINCT SUBSTRING_INDEX(notes.ip,'.',3)) from notes 
where hostname not like 'FK%' and api_name ='account_start'
and created_at >= '2014-06-29 11:00:00' and created_at <= '2014-06-30 11:00:00';



select count(notes.id) as cc, computers.client_count as client_count from notes inner join computers
	on notes.computer_id = computers.id where notes.api_name =  'discardforyears' and date(notes.created_at) > '2014-07-07'
	group by client_count order by cc desc;


select count(roles.id) cc, roles.level from accounts inner join roles on accounts.no = roles.account
	where accounts.status = 'discardforyears' and accounts.enabled=1 and accounts.normal_at > '2015-11-18 00:00:00' and roles.role_index = 0
	group by roles.level order by cc desc;


select ip3,count(tmp.note_id) ccc from(
select accounts.no , notes.id as note_id, SUBSTRING_INDEX(notes.ip,'.',3) as ip3 from accounts   
inner join  notes on accounts.no = notes.account
 where accounts.status = 'discardfordays' and accounts.normal_at > '2014-07-03 00:00:00'  and  notes.api_name = 'account_start' and date(notes.created_at) = '2014-07-01'
) as tmp group by ip3 order by ccc;




select SUBSTRING_INDEX(ip,'.',3) as ip3, count(DISTINCT account) as ccc
	from notes where api_name ='account_start' and date(created_at) = '2014-07-01'
	 group by ip3 order by ccc desc;




select count(no), ip3 from(
(select no from accounts where status = 'discardfordays' and normal_at > '2014-07-01 00:00:00') as a 
left join 
(select account, SUBSTRING_INDEX(ip,'.',3) as ip3 from notes 
	where api_name ='account_start' and date(created_at) = '2014-07-01') as n ) as t
group by ip3 




select ip3, count(n.id)  ccc from  
(select  id ,account , SUBSTRING_INDEX(ip,'.',3) as ip3 from notes where api_name ='account_start' and date(created_at) = '2014-07-01')  as n left join
(select no from accounts where status = 'discardfordays' and normal_at > '2014-07-01 00:00:00') as a 

on a.no = n.account group by ip3 order by ccc desc into outfile '/tmp/ip1.txt';






select ip3, count(DISTINCT _notes.account)  ccc from  
(select no from accounts where status = 'discardfordays' and normal_at > '2014-07-01 00:00:00') as _accounts left join 
(select account , SUBSTRING_INDEX(ip,'.',3) as ip3 from notes where api_name ='account_start' and date(created_at) = '2014-07-01')  as _notes
on _accounts.no = _notes.account group by ip3 order by ccc desc;



#select SUBSTRING_INDEX(ip,'.',3) as ip3, count(DISTINCT account) as cc from notes where date(created_at) = '2014-07-01' and api_name = 'discardfordays' group by ip3 order by cc desc

 into outfile  '/tmp/ip630.txt';

<<<<<<< HEAD
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

=======
select count(id), hostname from notes where computer_id = 171 group by hostname;
>>>>>>> master

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
