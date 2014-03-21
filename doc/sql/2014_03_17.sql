
# 绑定
select count(computers.id) from computers
	 inner join accounts on computers.id = accounts.bind_computer_id 
	 inner join roles on roles.account = accounts.no


 select CONCAT(role_id,'-', gold, '-',balance) cc,count(id) 
 	from payments where date(created_at) > '2014-02-20' group by cc having count(id)>1; 



select computers.id , count(roles.id) as roles_count from computers 
	inner join accounts on computers.id = accounts.bind_computer_id 
	inner join roles on roles.account = accounts.no
	where accounts.status ='normal' and roles.level >= 45 and computers.server ='网通三区' group by computers.id order by roles_count desc;


select avg(notes.hours) from notes
 where api_name = 'role_start' and level >= 45 and success = 1 and date(created_at) = '2014-03-16';

select sum(notes.hours) from notes
 where api_name = 'role_start' and level >= 45 and success = 1 and date(created_at) = '2014-03-16';



+-----+-------------+
| id  | roles_count |
+-----+-------------+
| 161 |          24 |
| 158 |          23 |
| 179 |          23 |
| 197 |          23 |
|  79 |          22 |
| 157 |          22 |
| 244 |          22 |
| 581 |          22 |
| 237 |          22 |
| 199 |          22 |
| 122 |          22 |
| 183 |          22 |
|  98 |          22 |
| 139 |          22 |
| 128 |          21 |
| 102 |          21 |
|  97 |          21 |
|  86 |          21 |
| 193 |          21 |
| 129 |          21 |
|  74 |          21 |
|  64 |          21 |
| 110 |          21 |
| 170 |          21 |
|  85 |          21 |
|  72 |          21 |
| 218 |          21 |
|  76 |          21 |
| 282 |          21 |
| 733 |          21 |
| 203 |          21 |
|  88 |          21 |
|  91 |          21 |
| 178 |          20 |
| 276 |          20 |
|  84 |          20 |
| 277 |          20 |
| 105 |          20 |
|  78 |          20 |
|  89 |          20 |
|  71 |          20 |
| 156 |          20 |
|  77 |          20 |
| 231 |          20 |
| 175 |          20 |
| 153 |          20 |
|  68 |          20 |
|  81 |          20 |
| 219 |          20 |
| 297 |          20 |
| 234 |          20 |
| 189 |          20 |
| 137 |          20 |
| 130 |          20 |
| 167 |          20 |
| 762 |          20 |
| 226 |          20 |
| 182 |          20 |
| 142 |          20 |
| 185 |          20 |
| 859 |          20 |
| 120 |          20 |
|  69 |          20 |
| 125 |          20 |
| 108 |          20 |
| 118 |          20 |
+-----+-------------+
