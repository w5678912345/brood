# 状态为locked 等级大于 40 的号
select count(a.id) from accounts as a inner join roles as r on a.no = r.account where r.level > 40 and a.status='locked';

select a.no,a.password from accounts as a inner join roles as r on a.no = r.account where r.level > 40 and a.status='locked' into outfile '/tmp/locked_gt40.txt';
