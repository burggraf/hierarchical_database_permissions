CREATE OR REPLACE FUNCTION get_group_access(group_id_var uuid, user_id_var uuid)
  RETURNS text AS
$$
DECLARE retval text;
BEGIN

  SELECT access FROM groups_access WHERE group_id = group_id_var AND user_id = user_id_var INTO retval;

    RETURN COALESCE(retval, '');
END;
$$
LANGUAGE 'plpgsql';
