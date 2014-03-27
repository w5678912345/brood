四川2区
 mysqldump -u root -p tianyi_pro>tianyi_pro_new.sql



select count(id) as cc, msg from notes where api_name ='answer_verify_code' and date(created_at) = '2014-01-18'
  group by msg order by cc ;


select count(id) from accounts where server in('四川1区','四川2区','四川6区');

# 导出四川区的账号 到 brood_test
select no,password,server,status from accounts 
	where server in('四川1区','四川2区','四川6区') and no != '2841454353' into outfile '/tmp/sc1.txt' FIELDS TERMINATED BY '|';

# 

LOAD DATA INFILE '/tmp/sc2.txt' INTO TABLE accounts FIELDS TERMINATED BY '|' (no,password,server,status);




update accounts set created_at = now(),updated_at= now(),normal_at = now() where normal_at is null ;



update accounts set created_at = '2013-12-12 17:00:00' where id <= 300;



select no,password from accounts where status = 'exception' into outfile '/tmp/e.ext';

select count(DISTINCT account) from notes where api_name ='locked';


select account from 
(select account,count(id) as times from notes where api_name ='locked' and date(created_at) = '2013-12-13'
 group by account) as t1 where times > 1;


 group by account;

<<<<<<< HEAD
select count(DISTINCT account) from notes where api_name ='exception';

select count(DISTINCT account) from (
select count(notes.id) as c ,notes.account from notes inner join roles on notes.role_id = roles.id
where date(notes.created_at) = '2013-12-17' and api_name ='answer_verify_code' and roles.level >= 60
group by account having count(notes.id) >= 10) as t1;

select count(DISTINCT  account),c from (
select count(id) as c ,account from notes where date(created_at) = '2013-12-17' and api_name ='answer_verify_code' 
group by account) as t1 group by c ;


# level > 60 
# 
select count(DISTINCT role_index) t ,count(role_index) tr, min(id),account from roles 
group by account having t = 2 and tr = 3;

# 修改 错误的role_index
select count(DISTINCT role_index) t ,count(role_index) tr, min(id),account from roles where server ='华北2区' 
group by account having t = 2 and tr = 3 limit 10;


update roles inner join (
select count(DISTINCT role_index) t ,count(role_index) tr, min(id) min_id,account from roles group by account having t = 2 and tr = 3 
) as t1 on roles.id = t1.min_id set role_index = 0  where role_index = 1 ;  roles.server = '天津1区';



select msg,count(id) from notes where date(created_at)='2014-3-20' and api_code = 'disconnect' group by msg;


=======

 update roles set status ='normal' where server = '山西1区' and role_index = 2;
 
>>>>>>> master
