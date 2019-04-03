DROP TRIGGER IF EXISTS log_delete_activity on activity ;

-- fonction trigger
CREATE OR REPLACE FUNCTION log_delete_activity()
    RETURNS TRIGGER AS $$
BEGIN
     INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
        values  (nextval('id_generator'),'delete', 'activity', OLD.id, user, now());
     RETURN NULL; -- le résultat est ignoré car il s'agit d'un trigger AFTER
END;
$$ language plpgsql;

-- trigger
CREATE TRIGGER log_delete_activity
    AFTER DELETE ON activity
    FOR EACH ROW EXECUTE PROCEDURE log_delete_activity();