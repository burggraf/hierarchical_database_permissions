DROP FUNCTION groups_get_my_root_groups;
CREATE OR REPLACE FUNCTION groups_get_my_root_groups()
  RETURNS table (root_id uuid, name text) AS
$$
  SELECT (id, name) from groups where id in (
    SELECT distinct(root_id) 
    FROM groups_access join groups on groups.id = groups_access.group_id 
    WHERE user_id = auth.uid()
  );
$$
LANGUAGE 'sql';