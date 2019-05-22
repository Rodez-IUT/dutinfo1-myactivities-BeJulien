--
-- add an activity
--
CREATE OR REPLACE FUNCTION add_activity(in_title varchar(500),in_description text, in_owner_id bigint default null) RETURNS activity AS $$
    DECLARE
        default_owner "user"%rowtype;
        activity_id bigint;
        activity_res activity%rowtype;
    BEGIN
        if in_owner_id is null then
            default_owner := get_default_owner();
            in_owner_id := default_owner.id;
        end if;
        activity_id := nextval('id_generator');
        insert into activity (id, title, description,creation_date, modification_date, owner_id)
            values(activity_id, in_title, in_description,now(), now(), in_owner_id);
        select * into activity_res
            from activity
            where id = activity_id;
        return activity_res;
    END;
$$ language plpgsql;

--
-- find all activities (version param OUT)
--
CREATE OR REPLACE FUNCTION find_all_activities(OUT activities_curs refcursor) AS $$
    begin
     open activities_curs FOR
            select act.id as id, title, description, creation_date, modification_date, owner_id, username
                from activity act left join "user" owner
                on act.owner_id = owner.id
                order by title, username;
    END;
$$ language plpgsql;