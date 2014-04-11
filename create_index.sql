create index index_payments_pay_type on payments(pay_type);
create index index_payments_created_at on payments(created_at);

create index index_notes_role_id on notes(role_id);

create index index_notes_computer_id on notes(computer_id);
#create index index_notes_session_id on notes(session_id);
create index index_notes_api_name on notes(api_name);
create index index_notes_success on notes(success);
create index index_notes_created_at on notes(created_at);

create index index_computers_auth_key on computers(auth_key);

create index index_accounts_bind_computer_id on accounts(bind_computer_id);
create index index_accounts_normal_at on accounts(normal_at);
create index index_notes_created_at on notes(created_at);

create index index_history_role_sessions_on_created_at on history_role_sessions(created_at);
create index index_history_role_sessions_on_begin_at on history_role_sessions(begin_at);
create index index_history_role_sessions_on_result on history_role_sessions(result);
create index index_history_role_sessions_on_version on history_role_sessions(version);
create index index_history_role_sessions_on_server on history_role_sessions(server);
