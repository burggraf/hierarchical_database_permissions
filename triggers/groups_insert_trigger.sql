DROP TRIGGER IF EXISTS groups_insert_trigger ON groups;
CREATE TRIGGER groups_insert_trigger
  AFTER INSERT
  ON groups
  FOR EACH ROW
  EXECUTE PROCEDURE groups_insert_add_admin_trigger_function();
