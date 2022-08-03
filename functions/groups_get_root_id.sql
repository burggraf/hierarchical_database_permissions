CREATE OR REPLACE FUNCTION groups_get_root_id(target uuid)
RETURNS uuid as
$$
WITH RECURSIVE hierarchy( id, parent_id ) 
AS (
  -- get child
  SELECT id, parent_id
  FROM groups
  WHERE id = target

  UNION ALL

  -- get parents
  SELECT t.id, t.parent_id
  FROM hierarchy p
  JOIN groups t
  ON t.id = p.parent_id
)
SELECT id AS root_id
FROM hierarchy
WHERE parent_id IS NULL;
$$
LANGUAGE sql;
