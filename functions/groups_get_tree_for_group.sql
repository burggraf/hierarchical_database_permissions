CREATE OR REPLACE FUNCTION groups_get_tree_for_group(target_group_id uuid)
RETURNS TABLE (id uuid,parent_id uuid,name text,description text,level numeric) as
$$
WITH RECURSIVE tree AS (
    SELECT
        groups.id as id,
        groups.parent_id as parent_id,
        COALESCE(groups.name, '') as name, 
        COALESCE(groups.description, '') as description, 
        0 as level,
        TO_CHAR(COALESCE(groups.sort_order, 0), 'fm000000') || COALESCE(groups.name, '') || groups.id::text as path 
    FROM
        groups join groups_access on groups_access.group_id = groups.id
    WHERE
        groups.id = target_group_id
    UNION ALL
    SELECT
        groups.id as id,
        groups.parent_id as parent_id,
        COALESCE(groups.name, '') as name, 
        COALESCE(groups.description, '') as description, 
        tree.level + 1 as level,
        tree.path || '~' || TO_CHAR(COALESCE(groups.sort_order, 0), 'fm000000') || COALESCE(groups.name, '') || groups.id::text as path 
    FROM
        tree
        JOIN groups ON groups.parent_id = tree.id
)

SELECT DISTINCT ON (path) id,parent_id,name,description,level FROM tree ORDER BY path;

$$
LANGUAGE sql;