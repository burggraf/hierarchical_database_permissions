CREATE OR REPLACE FUNCTION groups_get_root_groups_for_user(target_user_id uuid)
RETURNS TABLE (
    id uuid,
    parent_id uuid,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name text,
    description text,
    banner text,
    icon text,
    info jsonb,
    root_id uuid,
    level integer,
    access text
) as
$$

SELECT g.id,parent_id,g.created_at,g.updated_at,g.name,g.description,g.banner,g.icon,g.info,g.root_id,g.level,a.access from groups as g
join groups_access as a on g.id = a.group_id WHERE a.user_id = target_user_id and g.parent_id is null order by g.name;

$$
LANGUAGE sql;