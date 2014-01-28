1.所有role_index =0 的角色状态为 normal ，大于0 的角色状态为 disableforlevel

update roles set status = 'normal' where role_index = 0;

update roles set status = 'disableforlevel' where role_index > 0;


2.将已绑定账号全部放回账号池

update accounts set bind_computer_id = 0 where bind_computer_id > 0;

update computers set accounts_count =0 ,online_accounts_count = 0;


3. 
   bslocked | normal => bind_phone 2014-01-24 06:00:00
   normal 2014-01-24 07:00:00
   exception | disconnect 2014-01-24 08:00:00
   bslocked | lost | discardfordays  2014-01-24 09:00:00




update accounts inner join roles on accounts.no = roles.account set accounts.server = roles.server
	where accounts.server = '2014-01-24 07:00:00' and roles.role_index = 0;


select date(accounts.created_at) as d,count(accounts.id) as cc from accounts left join notes on accounts.no = notes.account
where notes.api_name= 'discardforyears' and date(notes.created_at) = '2014-01-23' group by date(accounts.created_at) order by d;



select date(accounts.created_at) as _date,count(accounts.id) as _count from accounts left join notes on accounts.no = notes.account
 where notes.api_name = 'account_start' and notes.created_at >= '2014-01-23 16:00:00' and notes.created_at <= '2014-01-23 20:00:00'
 group by date(accounts.created_at) order by _count;

 # 各个区可以调度的号

 select count(accounts.id) ac, server from accounts where status in('normal','exception','disconnect') group by server order by ac;

+---------------------------+--------------------+
| date(accounts.created_at) | count(accounts.id) |
+---------------------------+--------------------+
| 2013-11-27                |                 58 |
| 2013-12-09                |                  5 |
| 2013-12-13                |                191 |
| 2013-12-15                |                 49 |
| 2013-12-24                |                  4 |
| 2013-12-31                |                 28 |
| 2014-01-12                |                  1 |
+---------------------------+--------------------+