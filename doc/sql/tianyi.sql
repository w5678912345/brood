四川2区


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