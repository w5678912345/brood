


update accounts inner join notes on accounts.no = notes.account set accounts.normal_at ='2014-08-15 00:00:00'
	where accounts.status= 'discardforyears' and notes.api_name = 'discardforyears' and accounts.normal_at>'2015-01-01 00:00:00' and notes.msg like '游戏数据异常08月%'


select count(accounts.id) inner join notes on accounts.no = notes.account
	where accounts.status= 'discardforyears' and notes.api_name = 'discardforyears' and notes.msg like '游戏数据异常08月01日%'
