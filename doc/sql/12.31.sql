

select count(account), vc from (
select count(id) as vc, account from notes 
 where server = '上海1区' and api_name = 'answer_verify_code'
 and date(created_at) > '2013-12-25' group by account having count(id) > 35;
 ) as t1 group by vc



select count(account), vc from (
select count(id) as vc, account from notes 
 where server = '上海1区' and api_name = 'exception'
 and date(created_at) > '2013-12-25' group by account having count(id) > 20;
 ) as t1 group by vc;



select count(account), vc from (
select count(id) as vc, account from notes 
 where server = '浙江1区' and api_name = 'answer_verify_code'
 and date(created_at) > '2013-12-25' group by account having count(id) > 35
 ) as t1 group by vc;


update accounts inner join (
select count(id) as vc, account from notes  
	 where server = '浙江1区' and api_name = 'answer_verify_code'  
	 	and date(created_at) > '2013-12-25' group by account order by vc desc limit 500
 ) as t1 on accounts.no = t1.account set accounts.status = 'na500' where accounts.server="浙江1区";


select count(account), vc from 
( select count(id) as vc, account from notes  
	 where server = '浙江1区' and api_name = 'answer_verify_code'  
	 	and date(created_at) > '2013-12-25' group by account having count(id) > 10  ) as t1 
group by vc;



select count(id) as vc, account from notes  
	 where server = '浙江1区' and api_name = 'answer_verify_code'  
	 	and date(created_at) > '2013-12-25' group by account order by vc desc limit 500;



