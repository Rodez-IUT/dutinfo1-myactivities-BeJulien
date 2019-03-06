CREATE OR REPLACE FUNCTION find_all_activities_for_owner(owner VARCHAR(500)) RETURNS SETOF activity AS $$
	SELECT A.*
	FROM activity A
	JOIN "user" U
	ON owner_id = U.id
	WHERE owner = U.username
$$ LANGUAGE SQL