create of replace function add_activity(in_title varchar(200), in_description text, in_owner_id bigint) 
returns activity as $$
	
	
	
$$ language plpgsql;


create of replace function find_all_activities(activities_cursor refcursor) 
returns "refcursor" as $$
	
	
	
$$ language plpgsql;