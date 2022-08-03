CREATE OR REPLACE FUNCTION groups_update_root_id()
  RETURNS trigger AS
$$
BEGIN
    NEW.root_id = COALESCE(groups_get_root_id(COALESCE(NEW.parent_id, NEW.id)), NEW.id);
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';
