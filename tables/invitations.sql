DROP POLICY IF EXISTS "invitations update" ON "public"."invitations";
DROP POLICY IF EXISTS "invitations select" ON "public"."invitations";
DROP POLICY IF EXISTS "invitations insert - must be group admin" ON "public"."invitations";
DROP POLICY IF EXISTS "invitations delete" ON "public"."invitations";
ALTER TABLE IF EXISTS ONLY "public"."invitations" DROP CONSTRAINT IF EXISTS "invitations_user_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."invitations" DROP CONSTRAINT IF EXISTS "invitations_invited_by_fkey";
ALTER TABLE IF EXISTS ONLY "public"."invitations" DROP CONSTRAINT IF EXISTS "invitations_group_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."invitations" DROP CONSTRAINT IF EXISTS "invitations_pkey";
DROP TABLE IF EXISTS "public"."invitations";
-- Name: invitations; Type: TABLE; Schema: public; Owner: supabase_admin
CREATE TABLE "public"."invitations" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "group_id" "uuid" NOT NULL,
    "invited_by" "uuid",
    "result" "text",
    "closed_at" timestamp with time zone,
    "email" "text" NOT NULL,
    "user_id" "uuid",
    "access" "text" DEFAULT 'user'::"text" NOT NULL
);
ALTER TABLE "public"."invitations" OWNER TO "supabase_admin";
-- Name: TABLE "invitations"; Type: COMMENT; Schema: public; Owner: supabase_admin
COMMENT ON TABLE "public"."invitations" IS 'invitations to join a group';
-- Name: COLUMN "invitations"."access"; Type: COMMENT; Schema: public; Owner: supabase_admin
COMMENT ON COLUMN "public"."invitations"."access" IS 'access level';
-- Name: invitations invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
ALTER TABLE ONLY "public"."invitations"
    ADD CONSTRAINT "invitations_pkey" PRIMARY KEY ("id");
-- Name: invitations invitations_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
ALTER TABLE ONLY "public"."invitations"
    ADD CONSTRAINT "invitations_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id");
-- Name: invitations invitations_invited_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
ALTER TABLE ONLY "public"."invitations"
    ADD CONSTRAINT "invitations_invited_by_fkey" FOREIGN KEY ("invited_by") REFERENCES "auth"."users"("id");
-- Name: invitations invitations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: supabase_admin
ALTER TABLE ONLY "public"."invitations"
    ADD CONSTRAINT "invitations_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id");
-- Name: invitations; Type: ROW SECURITY; Schema: public; Owner: supabase_admin
ALTER TABLE "public"."invitations" ENABLE ROW LEVEL SECURITY;
-- Name: invitations invitations delete; Type: POLICY; Schema: public; Owner: supabase_admin
CREATE POLICY "invitations delete" ON "public"."invitations" FOR DELETE USING (false);
-- Name: invitations invitations insert - must be group admin; Type: POLICY; Schema: public; Owner: supabase_admin
CREATE POLICY "invitations insert - must be group admin" ON "public"."invitations" FOR INSERT WITH CHECK ((("auth"."role"() = 'authenticated'::"text") AND ("public"."get_group_access"("group_id", "auth"."uid"()) = 'admin'::"text")));
-- Name: invitations invitations select; Type: POLICY; Schema: public; Owner: supabase_admin
CREATE POLICY "invitations select" ON "public"."invitations" FOR SELECT USING ((("auth"."role"() = 'authenticated'::"text") AND (("invited_by" = "auth"."uid"()) OR ("email" = "auth"."email"()))));
-- Name: invitations invitations update; Type: POLICY; Schema: public; Owner: supabase_admin
CREATE POLICY "invitations update" ON "public"."invitations" FOR UPDATE USING (false) WITH CHECK (false);

-- Name: TABLE "invitations"; Type: ACL; Schema: public; Owner: supabase_admin
GRANT ALL ON TABLE "public"."invitations" TO "postgres";
GRANT ALL ON TABLE "public"."invitations" TO "anon";
GRANT ALL ON TABLE "public"."invitations" TO "authenticated";
GRANT ALL ON TABLE "public"."invitations" TO "service_role";