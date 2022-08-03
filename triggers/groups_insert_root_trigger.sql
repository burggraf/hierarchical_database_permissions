DROP TRIGGER IF EXISTS groups_insert_root_trigger ON groups;
CREATE TRIGGER groups_insert_root_trigger
  BEFORE INSERT
  ON groups
  FOR EACH ROW
  EXECUTE PROCEDURE groups_update_root_id();
