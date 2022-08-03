--DROP FUNCTION invitations_accept;

CREATE OR REPLACE FUNCTION invitations_accept (target uuid)
RETURNS TEXT as
$$
BEGIN
   IF (SELECT count(*) from invitations where id = target) < 1 THEN
      RAISE EXCEPTION 'invitation id not found'; 
   END IF;
   IF (SELECT LOWER(email) from invitations where id = target) <> LOWER(auth.email()) THEN
      RAISE EXCEPTION 'unauthorized email'; 
   END IF;
   INSERT INTO groups_access (group_id, user_id, access)
      SELECT group_id, auth.uid(), access from invitations where id = target;
   UPDATE invitations set user_id = auth.uid(), result = 'ACCEPTED', closed_at = NOW() where id = target;
   RETURN 'OK';
END
$$
LANGUAGE PLPGSQL SECURITY DEFINER;

ALTER FUNCTION "public"."invitations_accept"("target" "uuid") OWNER TO "supabase_admin";
GRANT ALL ON FUNCTION "public"."invitations_accept"("target" "uuid") TO "postgres";
GRANT ALL ON FUNCTION "public"."invitations_accept"("target" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."invitations_accept"("target" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."invitations_accept"("target" "uuid") TO "service_role";
