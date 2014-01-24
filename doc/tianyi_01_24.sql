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