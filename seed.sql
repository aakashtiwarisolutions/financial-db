--
-- PostgreSQL database dump
--

\restrict wUWJng7WWBzsfMIc2VOhgpvgbw66CYFw4a4chVburiIczm7z9eLBhA4zU7kvVYT

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2025-09-24 04:23:31

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
-- TOC entry 4846 (class 0 OID 16388)
-- Dependencies: 218
-- Data for Name: Financial Notes; Type: TABLE DATA; Schema: Financial; Owner: postgres
--

COPY "Financial"."Financial Notes" ("ID", "Expense", "Spend", "Source", "Balance Due", notes) FROM stdin;
\.


--
-- TOC entry 4847 (class 0 OID 16395)
-- Dependencies: 219
-- Data for Name: incoming_sources; Type: TABLE DATA; Schema: Financial; Owner: postgres
--

COPY "Financial".incoming_sources  FROM stdin;
\.


-- Completed on 2025-09-24 04:23:31

--
-- PostgreSQL database dump complete
--

\unrestrict wUWJng7WWBzsfMIc2VOhgpvgbw66CYFw4a4chVburiIczm7z9eLBhA4zU7kvVYT

