

select CONCAT(role_id,'-',gold,'-',balance) as col,count(id) from payments 
	where pay_type='trade' and created_at>='2014-03-31 17:00:00' and created_at <'2014-04-01 17:00:00' group by col having count(id)>1;