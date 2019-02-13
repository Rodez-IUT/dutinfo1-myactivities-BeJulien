CREATE OR REPLACE FUNCTION delete_activities_older_than(old_date date) RETURNS int AS $$
   DELETE FROM activity WHERE modification_date < old_date;
   SELECT 1;
$$ LANGUAGE SQL;