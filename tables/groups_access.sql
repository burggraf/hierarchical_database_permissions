ALTER TABLE IF EXISTS ONLY "public"."groups_access" DROP CONSTRAINT IF EXISTS "group_access_user_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."groups_access" DROP CONSTRAINT IF EXISTS "group_access_group_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."groups_access" DROP CONSTRAINT IF EXISTS "group_access_pkey";
DROP TABLE IF EXISTS "public"."groups_access";
CREATE TABLE "public"."groups_access" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "group_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "access" "text" NOT NULL
);

ALTER TABLE "public"."groups_access" OWNER TO "supabase_admin";
ALTER TABLE ONLY "public"."groups_access"
    ADD CONSTRAINT "group_access_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."groups_access"
    ADD CONSTRAINT "group_access_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id");
ALTER TABLE ONLY "public"."groups_access"
    ADD CONSTRAINT "group_access_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id");
GRANT ALL ON TABLE "public"."groups_access" TO "postgres";
GRANT ALL ON TABLE "public"."groups_access" TO "anon";
GRANT ALL ON TABLE "public"."groups_access" TO "authenticated";
GRANT ALL ON TABLE "public"."groups_access" TO "service_role";
