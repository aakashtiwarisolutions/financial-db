--
-- PostgreSQL database dump
--

\restrict sKAFxwuCItesgrn6uMgX9BnwZl1L2Hhi19os5K4kgtCtoyGcposZw6V4AAxBQ6n

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2025-10-21 22:57:07

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4863 (class 1262 OID 16411)
-- Name: fintrack; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE fintrack WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


ALTER DATABASE fintrack OWNER TO postgres;

\unrestrict sKAFxwuCItesgrn6uMgX9BnwZl1L2Hhi19os5K4kgtCtoyGcposZw6V4AAxBQ6n
\connect fintrack
\restrict sKAFxwuCItesgrn6uMgX9BnwZl1L2Hhi19os5K4kgtCtoyGcposZw6V4AAxBQ6n

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 16412)
-- Name: Financial; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "Financial";


ALTER SCHEMA "Financial" OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 16446)
-- Name: ingest_user_params(text, text, integer, text, timestamp without time zone); Type: FUNCTION; Schema: Financial; Owner: postgres
--

CREATE FUNCTION "Financial".ingest_user_params(p_name text, p_email text, p_id integer DEFAULT NULL::integer, p_phone text DEFAULT NULL::text, p_created_at timestamp without time zone DEFAULT NULL::timestamp without time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_id integer;
BEGIN
  IF p_name IS NULL OR p_email IS NULL THEN
    RAISE EXCEPTION 'Name and Email are required';
  END IF;

  IF p_id IS NULL THEN
    -- let the table generate ID
    INSERT INTO "Financial"."Users" ("Name","Email","Phone","Created At")
    VALUES (p_name, p_email, p_phone, COALESCE(p_created_at, now()))
    ON CONFLICT ("Email") DO UPDATE
       SET "Name" = EXCLUDED."Name",
           "Phone" = EXCLUDED."Phone",
           "Created At" = COALESCE(EXCLUDED."Created At", "Financial"."Users"."Created At")
    RETURNING "ID" INTO v_id;
  ELSE
    -- use provided ID
    INSERT INTO "Financial"."Users" ("ID","Name","Email","Phone","Created At")
    VALUES (p_id, p_name, p_email, p_phone, COALESCE(p_created_at, now()))
    ON CONFLICT ("Email") DO UPDATE
       SET "Name" = EXCLUDED."Name",
           "Phone" = EXCLUDED."Phone",
           "Created At" = COALESCE(EXCLUDED."Created At", "Financial"."Users"."Created At")
    RETURNING "ID" INTO v_id;
  END IF;

  RETURN v_id;
END;
$$;


ALTER FUNCTION "Financial".ingest_user_params(p_name text, p_email text, p_id integer, p_phone text, p_created_at timestamp without time zone) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16414)
-- Name: Financial Notes; Type: TABLE; Schema: Financial; Owner: postgres
--

CREATE TABLE "Financial"."Financial Notes" (
    "ID" integer NOT NULL,
    "Expense" text[] NOT NULL,
    "Spend" text[] NOT NULL,
    "Source" text[] NOT NULL,
    "Balance Due" integer,
    notes text[],
    "User ID" integer
);


ALTER TABLE "Financial"."Financial Notes" OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16413)
-- Name: Financial Notes_ID_seq; Type: SEQUENCE; Schema: Financial; Owner: postgres
--

CREATE SEQUENCE "Financial"."Financial Notes_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Financial"."Financial Notes_ID_seq" OWNER TO postgres;

--
-- TOC entry 4864 (class 0 OID 0)
-- Dependencies: 218
-- Name: Financial Notes_ID_seq; Type: SEQUENCE OWNED BY; Schema: Financial; Owner: postgres
--

ALTER SEQUENCE "Financial"."Financial Notes_ID_seq" OWNED BY "Financial"."Financial Notes"."ID";


--
-- TOC entry 221 (class 1259 OID 16429)
-- Name: Users; Type: TABLE; Schema: Financial; Owner: postgres
--

CREATE TABLE "Financial"."Users" (
    "ID" integer NOT NULL,
    "Name" text NOT NULL,
    "Email" text,
    "Phone" text,
    "Created At" timestamp without time zone DEFAULT now()
);


ALTER TABLE "Financial"."Users" OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16428)
-- Name: Users_ID_seq; Type: SEQUENCE; Schema: Financial; Owner: postgres
--

CREATE SEQUENCE "Financial"."Users_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "Financial"."Users_ID_seq" OWNER TO postgres;

--
-- TOC entry 4865 (class 0 OID 0)
-- Dependencies: 220
-- Name: Users_ID_seq; Type: SEQUENCE OWNED BY; Schema: Financial; Owner: postgres
--

ALTER SEQUENCE "Financial"."Users_ID_seq" OWNED BY "Financial"."Users"."ID";


--
-- TOC entry 4702 (class 2604 OID 16417)
-- Name: Financial Notes ID; Type: DEFAULT; Schema: Financial; Owner: postgres
--

ALTER TABLE ONLY "Financial"."Financial Notes" ALTER COLUMN "ID" SET DEFAULT nextval('"Financial"."Financial Notes_ID_seq"'::regclass);


--
-- TOC entry 4703 (class 2604 OID 16432)
-- Name: Users ID; Type: DEFAULT; Schema: Financial; Owner: postgres
--

ALTER TABLE ONLY "Financial"."Users" ALTER COLUMN "ID" SET DEFAULT nextval('"Financial"."Users_ID_seq"'::regclass);


--
-- TOC entry 4706 (class 2606 OID 16421)
-- Name: Financial Notes Financial Notes_pkey; Type: CONSTRAINT; Schema: Financial; Owner: postgres
--

ALTER TABLE ONLY "Financial"."Financial Notes"
    ADD CONSTRAINT "Financial Notes_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 4709 (class 2606 OID 16439)
-- Name: Users Users_Email_key; Type: CONSTRAINT; Schema: Financial; Owner: postgres
--

ALTER TABLE ONLY "Financial"."Users"
    ADD CONSTRAINT "Users_Email_key" UNIQUE ("Email");


--
-- TOC entry 4711 (class 2606 OID 16437)
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: Financial; Owner: postgres
--

ALTER TABLE ONLY "Financial"."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 4707 (class 1259 OID 16445)
-- Name: idx_fin_notes_user; Type: INDEX; Schema: Financial; Owner: postgres
--

CREATE INDEX idx_fin_notes_user ON "Financial"."Financial Notes" USING btree ("User ID");


--
-- TOC entry 4712 (class 2606 OID 16440)
-- Name: Financial Notes fk_fin_notes_user; Type: FK CONSTRAINT; Schema: Financial; Owner: postgres
--

ALTER TABLE ONLY "Financial"."Financial Notes"
    ADD CONSTRAINT fk_fin_notes_user FOREIGN KEY ("User ID") REFERENCES "Financial"."Users"("ID") ON UPDATE CASCADE ON DELETE SET NULL;


-- Completed on 2025-10-21 22:57:08

--
-- PostgreSQL database dump complete
--

\unrestrict sKAFxwuCItesgrn6uMgX9BnwZl1L2Hhi19os5K4kgtCtoyGcposZw6V4AAxBQ6n

