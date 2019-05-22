--
-- Function to register a given user on an a given activity
--
create or replace function register_user_on_activity(in_user_id bigint, in_activity_id bigint)
    returns registration as
$$
declare
    res_registration registration%rowtype;
begin
    -- check existence
    select * into res_registration
    from registration
    where user_id = in_user_id
      and activity_id = in_activity_id;
    if FOUND then
        raise exception 'registration_already_exists';
    end if;
    -- insert
    insert into registration (id, user_id, activity_id)
    values (nextval('id_generator'), in_user_id, in_activity_id);
    -- returns result
    select * into res_registration
    from registration
    where user_id = in_user_id
      and activity_id = in_activity_id;
    return res_registration;
end;
$$ language plpgsql;

--
-- Trigger to log in action_log table registration instertions
--

DROP TRIGGER IF EXISTS log_insert_registration on registration;

CREATE OR REPLACE FUNCTION log_insert_registration() RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
    values (nextval('id_generator'), 'insert', 'registration', NEW.id, user, now());
    RETURN NULL; -- le résultat est ignoré
END;
$$ language plpgsql;

CREATE TRIGGER log_insert_registration
    AFTER INSERT
    ON registration
    FOR EACH ROW
EXECUTE PROCEDURE log_insert_registration();


--
-- Function to unregister a given user from a given activity
--
create or replace function unregister_user_on_activity(in_user_id bigint, in_activity_id bigint)
    returns void as
$$
declare
    res_registration registration%rowtype;
begin
    -- check existence
    select * into res_registration
    from registration
    where user_id = in_user_id
      and activity_id = in_activity_id;
    if NOT FOUND then
        raise exception 'registration_not_found';
    end if;
    -- delete
    delete
    from registration
    where user_id = in_user_id
      and activity_id = in_activity_id;
end;
$$ language plpgsql;

--
--  Trigger to log unregistration in action_log table
--

DROP TRIGGER IF EXISTS log_delete_registration on registration;

CREATE OR REPLACE FUNCTION log_delete_registration() RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
    values (nextval('id_generator'), 'delete', 'registration', OLD.id, user, now());
    RETURN NULL; -- le résultat est ignoré
END;
$$ language plpgsql;

CREATE TRIGGER log_delete_registration
    AFTER DELETE
    ON registration
    FOR EACH ROW
EXECUTE PROCEDURE log_delete_registration();
