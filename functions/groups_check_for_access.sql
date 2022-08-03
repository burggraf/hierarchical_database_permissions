DROP FUNCTION IF EXISTS groups_check_for_access;

/* go up the heirarchy to see if this user is an admin at this level or any higher level */
CREATE OR REPLACE FUNCTION groups_check_for_access(target uuid, uid uuid, access_level TEXT)
RETURNS boolean as
$$
WITH RECURSIVE hierarchy( id, parent_id ) 
AS (
  -- get child
  SELECT id, parent_id, name
  FROM groups
  WHERE id = target

  UNION ALL

  -- get parents
  SELECT t.id, t.parent_id, t.name
  FROM hierarchy p
  JOIN groups t
  ON t.id = p.parent_id
)
select (select count(*) FROM hierarchy as h 
  LEFT OUTER JOIN groups_access as g
  ON g.group_id = h.id AND g.user_id = uid
  WHERE g.access = access_level) > 0;
$$
LANGUAGE sql;
