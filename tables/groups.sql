DROP POLICY IF EXISTS "group update" ON "public"."groups";
DROP POLICY IF EXISTS "group select" ON "public"."groups";
DROP POLICY IF EXISTS "group insert" ON "public"."groups";
DROP POLICY IF EXISTS "group delete" ON "public"."groups";
ALTER TABLE IF EXISTS ONLY "public"."groups" DROP CONSTRAINT IF EXISTS "groups_root_id_fkey";
DROP TRIGGER IF EXISTS "groups_insert_trigger" ON "public"."groups";
ALTER TABLE IF EXISTS ONLY "public"."groups" DROP CONSTRAINT IF EXISTS "group_pkey";
DROP TABLE IF EXISTS "public"."groups";

CREATE TABLE "public"."groups" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "parent_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "name" "text" NOT NULL,
    "description" "text",
    "banner" "text",
    "icon" "text",
    "info" "jsonb",
    "root_id" "uuid",
    "level" integer DEFAULT 0 NOT NULL,
    "sort_order" integer DEFAULT 0
);
ALTER TABLE "public"."groups" OWNER TO "supabase_admin";
COMMENT ON TABLE "public"."groups" IS 'organizational groups';
ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "group_pkey" PRIMARY KEY ("id");

CREATE TRIGGER "groups_insert_trigger" AFTER INSERT ON "public"."groups" FOR EACH ROW EXECUTE FUNCTION "public"."groups_insert_add_admin_trigger_function"();
ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_root_id_fkey" FOREIGN KEY ("root_id") REFERENCES "public"."groups"("id");

CREATE POLICY "group delete" ON "public"."groups" FOR DELETE USING (false);
CREATE POLICY "group insert" ON "public"."groups" FOR INSERT WITH CHECK (("auth"."role"() = 'authenticated'::"text"));
CREATE POLICY "group select" ON "public"."groups" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));
CREATE POLICY "group update" ON "public"."groups" FOR UPDATE USING ((("auth"."role"() = 'authenticated'::"text") AND ("public"."get_group_access"("id", "auth"."uid"()) = 'admin'::"text"))) WITH CHECK ((("auth"."role"() = 'authenticated'::"text") AND ("public"."get_group_access"("id", "auth"."uid"()) = 'admin'::"text")));
ALTER TABLE "public"."groups" ENABLE ROW LEVEL SECURITY;

GRANT ALL ON FUNCTION "public"."groups_delete"("target" "uuid") TO "postgres";
GRANT ALL ON FUNCTION "public"."groups_delete"("target" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."groups_delete"("target" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."groups_delete"("target" "uuid") TO "service_role";

GRANT ALL ON TABLE "public"."groups" TO "postgres";
GRANT ALL ON TABLE "public"."groups" TO "anon";
GRANT ALL ON TABLE "public"."groups" TO "authenticated";
GRANT ALL ON TABLE "public"."groups" TO "service_role";


