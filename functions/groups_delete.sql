--DROP FUNCTION groups_delete;
CREATE OR REPLACE FUNCTION groups_delete (target uuid)
RETURNS TEXT as
$$
BEGIN
   IF (SELECT count(*) from groups where parent_id = target) > 0 THEN
      RAISE EXCEPTION 'children exist, cannot delete'; 
   END IF;
   IF NOT groups_check_for_access(target,auth.uid(),'admin') THEN
      RAISE EXCEPTION 'admin access required to delete'; 
   END IF;
   DELETE FROM groups_access WHERE group_id = target;
   DELETE FROM groups WHERE id = target;
   RETURN 'OK';
END
$$
LANGUAGE PLPGSQL SECURITY DEFINER;
