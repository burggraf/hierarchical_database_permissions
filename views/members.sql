CREATE OR REPLACE VIEW members AS select 
  groups_access.group_id,
  groups_access.access,
  profile.*
  from groups_access join profile on profile.id = groups_access.user_id;
