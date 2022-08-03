CREATE OR REPLACE FUNCTION groups_insert_add_admin_trigger_function()
  RETURNS trigger AS
$$
BEGIN
   
         INSERT INTO groups_access(group_id,user_id,access)
         VALUES(NEW.id,auth.uid(),'admin');
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' SECURITY DEFINER;
