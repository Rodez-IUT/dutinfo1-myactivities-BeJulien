drop trigger if exists log_insert_activity on registration;
drop trigger if exists log_delete_activity on registration;

create or replace function register_user_on_activity(in_user_id bigint, in_activity_id bigint) 
returns registration as $$
    declare
        res_registration registration%rowtype;
    begin
        
        select * into res_registration from registration
        where user_id = in_user_id and activity_id = in_activity_id;
        
        if found then
            raise exception 'registration_already_exists';
        end if;
        
        insert into registration (id, user_id, activity_id)
        values(nextval('id_generator'), in_user_id, in_activity_id);
        
        select * into res_registration from registration
        where user_id = in_user_id and activity_id = in_activity_id;
        
        return res_registration;
        
    end;
$$ language plpgsql;


create or replace function log_insert_activity() returns trigger as $$
	begin
		insert into action_log (id, action_name, entity_name, entity_id, author, action_date)
	   	values  (nextval('id_generator'), 'insert', 'registration', new.id, user, now());
	    return null;
	end;
$$ language plpgsql;


create trigger log_insert_activity 
	after insert on registration for each row
	execute procedure log_insert_activity();
	

create or replace function unregister_user_on_activity(in_user_id bigint, in_activity_id bigint) 
returns void as $$
    declare
        res_registration registration%rowtype;
    begin
    
        select * into res_registration from registration
        where user_id = in_user_id and activity_id = in_activity_id;
        
        if not found then
        	raise exception 'registration_do_not_exists';
        end if;
        
        delete from registration where user_id = in_user_id and activity_id = in_activity_id;
    end;
$$ language plpgsql;


create or replace function log_delete_activity() returns trigger as $$
	begin
		insert into action_log (id, action_name, entity_name, entity_id, author, action_date)
		values (nextval('id_generator'), 'delete', 'registration', old.id, user, now());
		return null;
	end;
$$ language plpgsql;


create trigger log_delete_activity 
	after delete on registration for each row
	execute procedure log_delete_activity();