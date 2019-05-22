
CREATE OR REPLACE FUNCTION find_all_activities_for_owner(ownername varchar(500))
RETURNS SETOF activity AS $$
  select act.*
  FROM activity act
  JOIN "user" owner on owner_id=owner.id
  WHERE owner.username = ownername;
$$ LANGUAGE SQL;