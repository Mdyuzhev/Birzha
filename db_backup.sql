--
-- PostgreSQL database dump
--

\restrict XH6VOSVqPIxJd2G2CMZVbiBSNCt8vFxDEcFjBESl2oGPfvGf2VFEyPrR7EjKuNq

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_created_by_fkey;
ALTER TABLE IF EXISTS ONLY public.user_sessions DROP CONSTRAINT IF EXISTS user_sessions_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.saved_filters DROP CONSTRAINT IF EXISTS saved_filters_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.record_locks DROP CONSTRAINT IF EXISTS record_locks_locked_by_fkey;
ALTER TABLE IF EXISTS ONLY public.nine_box_assessments DROP CONSTRAINT IF EXISTS nine_box_assessments_employee_id_fkey;
ALTER TABLE IF EXISTS ONLY public.nine_box_assessments DROP CONSTRAINT IF EXISTS nine_box_assessments_assessed_by_fkey;
ALTER TABLE IF EXISTS ONLY public.employee_history DROP CONSTRAINT IF EXISTS employee_history_employee_id_fkey;
ALTER TABLE IF EXISTS ONLY public.employee_history DROP CONSTRAINT IF EXISTS employee_history_changed_by_fkey;
ALTER TABLE IF EXISTS ONLY public.column_presets DROP CONSTRAINT IF EXISTS column_presets_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.column_definitions DROP CONSTRAINT IF EXISTS column_definitions_dictionary_id_fkey;
DROP INDEX IF EXISTS public.idx_users_username;
DROP INDEX IF EXISTS public.idx_user_sessions_user;
DROP INDEX IF EXISTS public.idx_user_sessions_token;
DROP INDEX IF EXISTS public.idx_saved_filters_user;
DROP INDEX IF EXISTS public.idx_saved_filters_global;
DROP INDEX IF EXISTS public.idx_record_locks_expires;
DROP INDEX IF EXISTS public.idx_record_locks_entity;
DROP INDEX IF EXISTS public.idx_nine_box_employee;
DROP INDEX IF EXISTS public.idx_nine_box_box_position;
DROP INDEX IF EXISTS public.idx_nine_box_assessed_at;
DROP INDEX IF EXISTS public.idx_employees_full_name;
DROP INDEX IF EXISTS public.idx_employees_custom_fields;
DROP INDEX IF EXISTS public.idx_employee_history_employee;
DROP INDEX IF EXISTS public.idx_employee_history_changed_at;
DROP INDEX IF EXISTS public.idx_column_presets_user;
DROP INDEX IF EXISTS public.idx_column_presets_global;
DROP INDEX IF EXISTS public.flyway_schema_history_s_idx;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_username_key;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.user_sessions DROP CONSTRAINT IF EXISTS user_sessions_user_id_key;
ALTER TABLE IF EXISTS ONLY public.user_sessions DROP CONSTRAINT IF EXISTS user_sessions_pkey;
ALTER TABLE IF EXISTS ONLY public.saved_filters DROP CONSTRAINT IF EXISTS uk_saved_filters_user_name;
ALTER TABLE IF EXISTS ONLY public.record_locks DROP CONSTRAINT IF EXISTS uk_record_lock;
ALTER TABLE IF EXISTS ONLY public.column_presets DROP CONSTRAINT IF EXISTS uk_column_presets_user_name;
ALTER TABLE IF EXISTS ONLY public.saved_filters DROP CONSTRAINT IF EXISTS saved_filters_pkey;
ALTER TABLE IF EXISTS ONLY public.record_locks DROP CONSTRAINT IF EXISTS record_locks_pkey;
ALTER TABLE IF EXISTS ONLY public.nine_box_assessments DROP CONSTRAINT IF EXISTS nine_box_assessments_pkey;
ALTER TABLE IF EXISTS ONLY public.nine_box_assessments DROP CONSTRAINT IF EXISTS nine_box_assessments_employee_id_key;
ALTER TABLE IF EXISTS ONLY public.flyway_schema_history DROP CONSTRAINT IF EXISTS flyway_schema_history_pk;
ALTER TABLE IF EXISTS ONLY public.employees DROP CONSTRAINT IF EXISTS employees_pkey;
ALTER TABLE IF EXISTS ONLY public.employee_history DROP CONSTRAINT IF EXISTS employee_history_pkey;
ALTER TABLE IF EXISTS ONLY public.dictionaries DROP CONSTRAINT IF EXISTS dictionaries_pkey;
ALTER TABLE IF EXISTS ONLY public.dictionaries DROP CONSTRAINT IF EXISTS dictionaries_name_key;
ALTER TABLE IF EXISTS ONLY public.column_presets DROP CONSTRAINT IF EXISTS column_presets_pkey;
ALTER TABLE IF EXISTS ONLY public.column_definitions DROP CONSTRAINT IF EXISTS column_definitions_pkey;
ALTER TABLE IF EXISTS ONLY public.column_definitions DROP CONSTRAINT IF EXISTS column_definitions_name_key;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.user_sessions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.saved_filters ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.record_locks ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.nine_box_assessments ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.employees ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.employee_history ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.dictionaries ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.column_presets ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.column_definitions ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.user_sessions_id_seq;
DROP TABLE IF EXISTS public.user_sessions;
DROP SEQUENCE IF EXISTS public.saved_filters_id_seq;
DROP TABLE IF EXISTS public.saved_filters;
DROP SEQUENCE IF EXISTS public.record_locks_id_seq;
DROP TABLE IF EXISTS public.record_locks;
DROP SEQUENCE IF EXISTS public.nine_box_assessments_id_seq;
DROP TABLE IF EXISTS public.nine_box_assessments;
DROP TABLE IF EXISTS public.flyway_schema_history;
DROP SEQUENCE IF EXISTS public.employees_id_seq;
DROP TABLE IF EXISTS public.employees;
DROP SEQUENCE IF EXISTS public.employee_history_id_seq;
DROP TABLE IF EXISTS public.employee_history;
DROP SEQUENCE IF EXISTS public.dictionaries_id_seq;
DROP TABLE IF EXISTS public.dictionaries;
DROP SEQUENCE IF EXISTS public.column_presets_id_seq;
DROP TABLE IF EXISTS public.column_presets;
DROP SEQUENCE IF EXISTS public.column_definitions_id_seq;
DROP TABLE IF EXISTS public.column_definitions;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: column_definitions; Type: TABLE; Schema: public; Owner: resourceuser
--

CREATE TABLE public.column_definitions (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    display_name character varying(100) NOT NULL,
    field_type character varying(20) NOT NULL,
    dictionary_id bigint,
    sort_order integer DEFAULT 0,
    is_required boolean DEFAULT false,
    CONSTRAINT column_definitions_field_type_check CHECK (((field_type)::text = ANY ((ARRAY['TEXT'::character varying, 'SELECT'::character varying, 'DATE'::character varying, 'NUMBER'::character varying])::text[])))
);


ALTER TABLE public.column_definitions OWNER TO resourceuser;

--
-- Name: column_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: resourceuser
--

CREATE SEQUENCE public.column_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.column_definitions_id_seq OWNER TO resourceuser;

--
-- Name: column_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resourceuser
--

ALTER SEQUENCE public.column_definitions_id_seq OWNED BY public.column_definitions.id;


--
-- Name: column_presets; Type: TABLE; Schema: public; Owner: resourceuser
--

CREATE TABLE public.column_presets (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    column_config jsonb DEFAULT '[]'::jsonb NOT NULL,
    is_default boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_global boolean DEFAULT false
);


ALTER TABLE public.column_presets OWNER TO resourceuser;

--
-- Name: TABLE column_presets; Type: COMMENT; Schema: public; Owner: resourceuser
--

COMMENT ON TABLE public.column_presets IS 'Сохранённые пресеты настроек колонок пользователей';


--
-- Name: COLUMN column_presets.column_config; Type: COMMENT; Schema: public; Owner: resourceuser
--

COMMENT ON COLUMN public.column_presets.column_config IS 'JSON массив с настройками: [{prop, visible}]';


--
-- Name: column_presets_id_seq; Type: SEQUENCE; Schema: public; Owner: resourceuser
--

CREATE SEQUENCE public.column_presets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.column_presets_id_seq OWNER TO resourceuser;

--
-- Name: column_presets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resourceuser
--

ALTER SEQUENCE public.column_presets_id_seq OWNED BY public.column_presets.id;


--
-- Name: dictionaries; Type: TABLE; Schema: public; Owner: resourceuser
--

CREATE TABLE public.dictionaries (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    display_name character varying(100) NOT NULL,
    "values" jsonb DEFAULT '[]'::jsonb NOT NULL
);


ALTER TABLE public.dictionaries OWNER TO resourceuser;

--
-- Name: dictionaries_id_seq; Type: SEQUENCE; Schema: public; Owner: resourceuser
--

CREATE SEQUENCE public.dictionaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dictionaries_id_seq OWNER TO resourceuser;

--
-- Name: dictionaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resourceuser
--

ALTER SEQUENCE public.dictionaries_id_seq OWNED BY public.dictionaries.id;


--
-- Name: employee_history; Type: TABLE; Schema: public; Owner: resourceuser
--

CREATE TABLE public.employee_history (
    id bigint NOT NULL,
    employee_id bigint NOT NULL,
    changed_by bigint NOT NULL,
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    field_name character varying(100) NOT NULL,
    old_value text,
    new_value text
);


ALTER TABLE public.employee_history OWNER TO resourceuser;

--
-- Name: employee_history_id_seq; Type: SEQUENCE; Schema: public; Owner: resourceuser
--

CREATE SEQUENCE public.employee_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_history_id_seq OWNER TO resourceuser;

--
-- Name: employee_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resourceuser
--

ALTER SEQUENCE public.employee_history_id_seq OWNED BY public.employee_history.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: resourceuser
--

CREATE TABLE public.employees (
    id bigint NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(255),
    custom_fields jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employees OWNER TO resourceuser;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: resourceuser
--

CREATE SEQUENCE public.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_id_seq OWNER TO resourceuser;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resourceuser
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: resourceuser
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO resourceuser;

--
-- Name: nine_box_assessments; Type: TABLE; Schema: public; Owner: resourceuser
--

CREATE TABLE public.nine_box_assessments (
    id bigint NOT NULL,
    employee_id bigint NOT NULL,
    assessed_by bigint NOT NULL,
    assessed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    q1_results integer NOT NULL,
    q2_goals integer NOT NULL,
    q3_quality integer NOT NULL,
    q4_growth integer NOT NULL,
    q5_leadership integer NOT NULL,
    performance_score numeric(3,2) NOT NULL,
    potential_score numeric(3,2) NOT NULL,
    box_position integer NOT NULL,
    comment text,
    CONSTRAINT nine_box_assessments_box_position_check CHECK (((box_position >= 1) AND (box_position <= 9))),
    CONSTRAINT nine_box_assessments_q1_results_check CHECK (((q1_results >= 1) AND (q1_results <= 5))),
    CONSTRAINT nine_box_assessments_q2_goals_check CHECK (((q2_goals >= 1) AND (q2_goals <= 5))),
    CONSTRAINT nine_box_assessments_q3_quality_check CHECK (((q3_quality >= 1) AND (q3_quality <= 5))),
    CONSTRAINT nine_box_assessments_q4_growth_check CHECK (((q4_growth >= 1) AND (q4_growth <= 5))),
    CONSTRAINT nine_box_assessments_q5_leadership_check CHECK (((q5_leadership >= 1) AND (q5_leadership <= 5)))
);


ALTER TABLE public.nine_box_assessments OWNER TO resourceuser;

--
-- Name: nine_box_assessments_id_seq; Type: SEQUENCE; Schema: public; Owner: resourceuser
--

CREATE SEQUENCE public.nine_box_assessments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nine_box_assessments_id_seq OWNER TO resourceuser;

--
-- Name: nine_box_assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resourceuser
--

ALTER SEQUENCE public.nine_box_assessments_id_seq OWNED BY public.nine_box_assessments.id;


--
-- Name: record_locks; Type: TABLE; Schema: public; Owner: resourceuser
--

CREATE TABLE public.record_locks (
    id bigint NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id bigint NOT NULL,
    locked_by bigint NOT NULL,
    locked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires_at timestamp without time zone NOT NULL
);


ALTER TABLE public.record_locks OWNER TO resourceuser;

--
-- Name: record_locks_id_seq; Type: SEQUENCE; Schema: public; Owner: resourceuser
--

CREATE SEQUENCE public.record_locks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.record_locks_id_seq OWNER TO resourceuser;

--
-- Name: record_locks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resourceuser
--

ALTER SEQUENCE public.record_locks_id_seq OWNED BY public.record_locks.id;


--
-- Name: saved_filters; Type: TABLE; Schema: public; Owner: resourceuser
--

CREATE TABLE public.saved_filters (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    name character varying(100) NOT NULL,
    filter_config jsonb DEFAULT '{}'::jsonb NOT NULL,
    is_global boolean DEFAULT false,
    is_default boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.saved_filters OWNER TO resourceuser;

--
-- Name: saved_filters_id_seq; Type: SEQUENCE; Schema: public; Owner: resourceuser
--

CREATE SEQUENCE public.saved_filters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.saved_filters_id_seq OWNER TO resourceuser;

--
-- Name: saved_filters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resourceuser
--

ALTER SEQUENCE public.saved_filters_id_seq OWNED BY public.saved_filters.id;


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: resourceuser
--

CREATE TABLE public.user_sessions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    session_token character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_activity timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_sessions OWNER TO resourceuser;

--
-- Name: user_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: resourceuser
--

CREATE SEQUENCE public.user_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_sessions_id_seq OWNER TO resourceuser;

--
-- Name: user_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resourceuser
--

ALTER SEQUENCE public.user_sessions_id_seq OWNED BY public.user_sessions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: resourceuser
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by bigint,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['ADMIN'::character varying, 'USER'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO resourceuser;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: resourceuser
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO resourceuser;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: resourceuser
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: column_definitions id; Type: DEFAULT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.column_definitions ALTER COLUMN id SET DEFAULT nextval('public.column_definitions_id_seq'::regclass);


--
-- Name: column_presets id; Type: DEFAULT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.column_presets ALTER COLUMN id SET DEFAULT nextval('public.column_presets_id_seq'::regclass);


--
-- Name: dictionaries id; Type: DEFAULT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.dictionaries ALTER COLUMN id SET DEFAULT nextval('public.dictionaries_id_seq'::regclass);


--
-- Name: employee_history id; Type: DEFAULT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.employee_history ALTER COLUMN id SET DEFAULT nextval('public.employee_history_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: nine_box_assessments id; Type: DEFAULT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.nine_box_assessments ALTER COLUMN id SET DEFAULT nextval('public.nine_box_assessments_id_seq'::regclass);


--
-- Name: record_locks id; Type: DEFAULT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.record_locks ALTER COLUMN id SET DEFAULT nextval('public.record_locks_id_seq'::regclass);


--
-- Name: saved_filters id; Type: DEFAULT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.saved_filters ALTER COLUMN id SET DEFAULT nextval('public.saved_filters_id_seq'::regclass);


--
-- Name: user_sessions id; Type: DEFAULT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.user_sessions ALTER COLUMN id SET DEFAULT nextval('public.user_sessions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: column_definitions; Type: TABLE DATA; Schema: public; Owner: resourceuser
--

COPY public.column_definitions (id, name, display_name, field_type, dictionary_id, sort_order, is_required) FROM stdin;
9	position	Должность	SELECT	3	1	t
10	department	Отдел	SELECT	10	2	t
11	grade	Грейд	SELECT	1	3	t
12	status	Статус	SELECT	2	4	t
13	location	Локация	SELECT	4	5	f
14	hire_date	Дата найма	DATE	\N	6	f
15	project	Текущий проект	TEXT	\N	7	f
16	skills	Ключевые навыки	TEXT	\N	8	f
17	salary	Ставка (руб/час)	NUMBER	\N	9	f
18	mentor	Наставник	TEXT	\N	10	f
19	entry_date	Дата внесения кандидата	DATE	\N	11	f
20	current_manager	Текущий руководитель	TEXT	\N	12	f
21	it_block	ИТ Блок	SELECT	12	13	f
22	ck_department	ЦК/Департамент	TEXT	\N	14	f
23	placement_type	Тип пристройства	SELECT	13	15	f
24	ready_for_vacancy	Готов к рассмотрению	SELECT	14	16	f
25	resume_link	Резюме	TEXT	\N	17	f
26	manager_feedback	ОС от текущего руководителя	TEXT	\N	18	f
27	contacts	Контакты (телефон, тг, почта)	TEXT	\N	19	f
28	funding_end_date	Дата окончания финансирования	DATE	\N	20	f
29	candidate_status	Статус кандидата	SELECT	15	21	f
30	target_projects	Проекты, куда рассматривается	TEXT	\N	22	f
31	transfer_date	Дата перевода/увольнения	DATE	\N	23	f
32	recruiter	Рекрутер	TEXT	\N	24	f
33	hr_bp	HR BP отдающей стороны	TEXT	\N	25	f
34	comments	Доп.комментарий	TEXT	\N	26	f
\.


--
-- Data for Name: column_presets; Type: TABLE DATA; Schema: public; Owner: resourceuser
--

COPY public.column_presets (id, user_id, name, column_config, is_default, created_at, updated_at, is_global) FROM stdin;
1	1	Test Board	[{"prop": "fullName", "visible": true}, {"prop": "email", "visible": false}]	f	2026-01-16 12:41:18.9011	2026-01-16 12:41:18.901137	f
2	1	Дюжев	[{"prop": "fullName", "visible": true}, {"prop": "email", "visible": false}, {"prop": "customFields.position", "visible": true}, {"prop": "customFields.department", "visible": false}, {"prop": "customFields.grade", "visible": false}, {"prop": "customFields.status", "visible": false}, {"prop": "customFields.location", "visible": false}, {"prop": "customFields.hire_date", "visible": false}, {"prop": "customFields.project", "visible": false}, {"prop": "customFields.skills", "visible": false}, {"prop": "customFields.salary", "visible": false}, {"prop": "customFields.mentor", "visible": false}, {"prop": "customFields.entry_date", "visible": false}, {"prop": "customFields.current_manager", "visible": false}, {"prop": "customFields.it_block", "visible": false}, {"prop": "customFields.ck_department", "visible": false}, {"prop": "customFields.placement_type", "visible": false}, {"prop": "customFields.ready_for_vacancy", "visible": false}, {"prop": "customFields.resume_link", "visible": true}, {"prop": "customFields.manager_feedback", "visible": true}, {"prop": "customFields.contacts", "visible": false}, {"prop": "customFields.funding_end_date", "visible": false}, {"prop": "customFields.candidate_status", "visible": false}, {"prop": "customFields.target_projects", "visible": false}, {"prop": "customFields.transfer_date", "visible": false}, {"prop": "customFields.recruiter", "visible": false}, {"prop": "customFields.hr_bp", "visible": false}, {"prop": "customFields.comments", "visible": false}]	f	2026-01-16 12:42:35.885603	2026-01-16 12:42:35.885624	f
\.


--
-- Data for Name: dictionaries; Type: TABLE DATA; Schema: public; Owner: resourceuser
--

COPY public.dictionaries (id, name, display_name, "values") FROM stdin;
1	grades	Грейд	["Junior", "Middle", "Senior", "Lead", "Principal"]
4	locations	Локация	["Москва", "Санкт-Петербург", "Удалённо", "Гибрид"]
3	positions	Должность	["Junior Developer", "Middle Developer", "Senior Developer", "Team Lead", "Tech Lead", "Project Manager", "DevOps Engineer", "QA Engineer", "Designer", "Analyst"]
10	departments	Отдел	["Backend", "Frontend", "Mobile", "DevOps", "QA", "Design", "Analytics", "Management"]
2	statuses	Статус	["На проекте", "На бенче", "В отпуске", "Болеет"]
12	it_blocks	ИТ Блок	["Диджитал", "НУК", "Развитие", "Эксплуатация", "B2O", "Прочее"]
13	placement_types	Тип пристройства	["перевод", "аутстафф", "любой"]
14	ready_for_vacancy	Готов к рассмотрению	["Да", "Нет"]
15	candidate_statuses	Статус кандидата	["Свободен", "В работе", "Забронирован", "Увольнение по СЖ", "Увольнение по СС", "Переведен"]
\.


--
-- Data for Name: employee_history; Type: TABLE DATA; Schema: public; Owner: resourceuser
--

COPY public.employee_history (id, employee_id, changed_by, changed_at, field_name, old_value, new_value) FROM stdin;
1	6	1	2026-01-15 20:28:08.48377	status	На проекте	На бенче
2	6	1	2026-01-15 20:28:08.49897	skills	Java, Spring Boot, PostgreSQL	Java, Spring Boot
3	7	1	2026-01-15 20:28:08.649801	grade	Middle	Senior
4	7	1	2026-01-15 20:28:08.651497	position	Middle Developer	Senior Developer
5	218	1	2026-01-15 20:28:08.675768	location	Москва	Санкт-Петербург
6	6	1	2026-01-15 20:28:08.700741	email	ivanov@company.ru	a.ivanov@company.ru
7	7	1	2026-01-15 23:59:04.955967	position	Senior Developer	Tech Lead
8	218	1	2026-01-16 00:40:11.388627	position	Senior Developer	DevOps Engineer
9	6	1	2026-01-16 12:05:20.831798	entry_date	\N	2025-12-19
10	6	1	2026-01-16 12:05:20.839164	current_manager	\N	Петров С.М.
11	6	1	2026-01-16 12:05:20.841116	it_block	\N	Развитие
12	6	1	2026-01-16 12:05:20.84286	ck_department	\N	Департамент цифровых продуктов
13	6	1	2026-01-16 12:05:20.844104	placement_type	\N	любой
14	6	1	2026-01-16 12:05:20.845364	ready_for_vacancy	\N	Да
15	6	1	2026-01-16 12:05:20.846908	resume_link	\N	https://drive.google.com/file/64868
16	6	1	2026-01-16 12:05:20.848164	manager_feedback	\N	
17	6	1	2026-01-16 12:05:20.849174	contacts	\N	+7 (986) 977-47-74, @иваалек96, a.ivanov@company.ru
18	6	1	2026-01-16 12:05:20.850854	funding_end_date	\N	2025-08-12
19	6	1	2026-01-16 12:05:20.852279	candidate_status	\N	Забронирован
20	6	1	2026-01-16 12:05:20.853463	target_projects	\N	ML Pipeline, Data Platform, E-commerce Platform
21	6	1	2026-01-16 12:05:20.854548	transfer_date	\N	
22	6	1	2026-01-16 12:05:20.855876	recruiter	\N	Орлов М.С.
23	6	1	2026-01-16 12:05:20.856901	hr_bp	\N	Морозов К.А.
24	6	1	2026-01-16 12:05:20.858264	comments	\N	Срочно нужен проект
25	20	1	2026-01-16 12:05:20.914902	entry_date	\N	2024-09-18
26	20	1	2026-01-16 12:05:20.916622	current_manager	\N	Козлов Д.В.
27	20	1	2026-01-16 12:05:20.918056	it_block	\N	Эксплуатация
28	20	1	2026-01-16 12:05:20.91981	ck_department	\N	Департамент данных
29	20	1	2026-01-16 12:05:20.921167	placement_type	\N	перевод
30	20	1	2026-01-16 12:05:20.922525	ready_for_vacancy	\N	Нет
31	20	1	2026-01-16 12:05:20.9238	resume_link	\N	https://drive.google.com/file/62035
32	20	1	2026-01-16 12:05:20.925278	manager_feedback	\N	
33	20	1	2026-01-16 12:05:20.926869	contacts	\N	+7 (958) 659-56-44, @яконики80, nikita.yakovlev4@company.ru
34	20	1	2026-01-16 12:05:20.928502	funding_end_date	\N	2026-01-20
35	20	1	2026-01-16 12:05:20.929865	candidate_status	\N	В работе
36	20	1	2026-01-16 12:05:20.93136	target_projects	\N	DevOps Platform, Infrastructure, E-commerce Platform
37	20	1	2026-01-16 12:05:20.932734	transfer_date	\N	
38	20	1	2026-01-16 12:05:20.933699	recruiter	\N	Смирнова А.А.
39	20	1	2026-01-16 12:05:20.935115	hr_bp	\N	Волкова Н.В.
40	20	1	2026-01-16 12:05:20.936237	comments	\N	В процессе согласования
41	9	1	2026-01-16 12:05:20.981779	entry_date	\N	2025-09-06
42	9	1	2026-01-16 12:05:20.983158	current_manager	\N	Михайлова О.Н.
43	9	1	2026-01-16 12:05:20.984615	it_block	\N	Развитие
44	9	1	2026-01-16 12:05:20.986006	ck_department	\N	Департамент данных
45	9	1	2026-01-16 12:05:20.987217	placement_type	\N	аутстафф
46	9	1	2026-01-16 12:05:20.988355	ready_for_vacancy	\N	Нет
47	9	1	2026-01-16 12:05:20.98997	resume_link	\N	https://drive.google.com/file/82499
48	9	1	2026-01-16 12:05:20.991105	manager_feedback	\N	Хороший специалист
49	9	1	2026-01-16 12:05:20.992688	contacts	\N	+7 (930) 336-63-61, @козанна1, kozlova@company.ru
50	9	1	2026-01-16 12:05:20.994173	funding_end_date	\N	2026-07-27
51	9	1	2026-01-16 12:05:20.995443	candidate_status	\N	Переведен
52	9	1	2026-01-16 12:05:20.996557	target_projects	\N	Infrastructure, Data Platform, Banking App
53	9	1	2026-01-16 12:05:20.997956	transfer_date	\N	2026-07-22
54	9	1	2026-01-16 12:05:20.999187	recruiter	\N	Смирнова А.А.
55	9	1	2026-01-16 12:05:21.000626	hr_bp	\N	Лебедева Т.М.
56	9	1	2026-01-16 12:05:21.002067	comments	\N	В процессе согласования
57	10	1	2026-01-16 12:05:21.04576	entry_date	\N	2024-11-29
58	10	1	2026-01-16 12:05:21.047118	current_manager	\N	Петров С.М.
59	10	1	2026-01-16 12:05:21.04885	it_block	\N	B2O
60	10	1	2026-01-16 12:05:21.050159	ck_department	\N	Департамент цифровых продуктов
61	10	1	2026-01-16 12:05:21.051443	placement_type	\N	любой
62	10	1	2026-01-16 12:05:21.052626	ready_for_vacancy	\N	Нет
63	10	1	2026-01-16 12:05:21.054117	resume_link	\N	https://drive.google.com/file/27666
64	10	1	2026-01-16 12:05:21.055294	manager_feedback	\N	Отличные результаты
65	10	1	2026-01-16 12:05:21.0565	contacts	\N	+7 (949) 245-24-35, @никартё80, nikolaev@company.ru
66	10	1	2026-01-16 12:05:21.058298	funding_end_date	\N	2025-06-25
67	10	1	2026-01-16 12:05:21.060189	candidate_status	\N	Увольнение по СЖ
68	10	1	2026-01-16 12:05:21.061457	target_projects	\N	DevOps Platform, Infrastructure, Госуслуги 2.0
69	10	1	2026-01-16 12:05:21.06325	transfer_date	\N	2025-02-15
70	10	1	2026-01-16 12:05:21.064322	recruiter	\N	Новикова Е.П.
71	10	1	2026-01-16 12:05:21.065215	hr_bp	\N	Морозов К.А.
72	10	1	2026-01-16 12:05:21.066305	comments	\N	
73	213	1	2026-01-16 12:05:21.109269	entry_date	\N	2025-09-03
74	213	1	2026-01-16 12:05:21.110854	current_manager	\N	Козлов Д.В.
75	213	1	2026-01-16 12:05:21.111875	it_block	\N	Развитие
76	213	1	2026-01-16 12:05:21.112664	ck_department	\N	ЦК Инфраструктуры
77	213	1	2026-01-16 12:05:21.113788	placement_type	\N	аутстафф
78	213	1	2026-01-16 12:05:21.114822	ready_for_vacancy	\N	Нет
79	213	1	2026-01-16 12:05:21.115862	resume_link	\N	https://drive.google.com/file/56213
80	213	1	2026-01-16 12:05:21.116635	manager_feedback	\N	Нужно развитие
81	213	1	2026-01-16 12:05:21.117415	contacts	\N	+7 (992) 140-75-43, @попартё1, timur.romanov197@company.ru
82	213	1	2026-01-16 12:05:21.120864	funding_end_date	\N	2026-01-01
83	213	1	2026-01-16 12:05:21.122245	candidate_status	\N	Увольнение по СЖ
84	213	1	2026-01-16 12:05:21.123325	target_projects	\N	Mobile App, Banking App
85	213	1	2026-01-16 12:05:21.124245	transfer_date	\N	2026-11-18
86	213	1	2026-01-16 12:05:21.124964	recruiter	\N	Белова И.Д.
87	213	1	2026-01-16 12:05:21.126413	hr_bp	\N	Волкова Н.В.
88	213	1	2026-01-16 12:05:21.127461	comments	\N	
89	12	1	2026-01-16 12:05:21.16425	entry_date	\N	2025-10-31
90	12	1	2026-01-16 12:05:21.165384	current_manager	\N	Михайлова О.Н.
91	12	1	2026-01-16 12:05:21.166342	it_block	\N	Диджитал
92	12	1	2026-01-16 12:05:21.16746	ck_department	\N	Департамент цифровых продуктов
93	12	1	2026-01-16 12:05:21.169406	placement_type	\N	перевод
94	12	1	2026-01-16 12:05:21.170697	ready_for_vacancy	\N	Да
95	12	1	2026-01-16 12:05:21.172101	resume_link	\N	https://drive.google.com/file/84629
96	12	1	2026-01-16 12:05:21.173053	manager_feedback	\N	Хороший специалист
97	12	1	2026-01-16 12:05:21.174569	contacts	\N	+7 (920) 847-86-32, @мормакс39, morozov@company.ru
98	12	1	2026-01-16 12:05:21.175924	funding_end_date	\N	2026-10-25
99	12	1	2026-01-16 12:05:21.176947	candidate_status	\N	В работе
100	12	1	2026-01-16 12:05:21.178264	target_projects	\N	Mobile App, Infrastructure, E-commerce Platform
101	12	1	2026-01-16 12:05:21.179728	transfer_date	\N	
102	12	1	2026-01-16 12:05:21.180939	recruiter	\N	Белова И.Д.
103	12	1	2026-01-16 12:05:21.182596	hr_bp	\N	Лебедева Т.М.
104	12	1	2026-01-16 12:05:21.183792	comments	\N	Срочно нужен проект
105	128	1	2026-01-16 12:05:21.222786	entry_date	\N	2025-09-24
106	128	1	2026-01-16 12:05:21.224329	current_manager	\N	Петров С.М.
107	128	1	2026-01-16 12:05:21.225507	it_block	\N	Диджитал
108	128	1	2026-01-16 12:05:21.226502	ck_department	\N	Департамент цифровых продуктов
109	128	1	2026-01-16 12:05:21.228608	placement_type	\N	аутстафф
110	128	1	2026-01-16 12:05:21.229626	ready_for_vacancy	\N	Нет
111	128	1	2026-01-16 12:05:21.230814	resume_link	\N	https://drive.google.com/file/51048
112	128	1	2026-01-16 12:05:21.231586	manager_feedback	\N	Нужно развитие
113	128	1	2026-01-16 12:05:21.232614	contacts	\N	+7 (987) 253-11-67, @новрома14, mark.fedorov112@company.ru
114	128	1	2026-01-16 12:05:21.233755	funding_end_date	\N	2026-11-07
115	128	1	2026-01-16 12:05:21.234786	candidate_status	\N	Переведен
116	128	1	2026-01-16 12:05:21.23697	target_projects	\N	Infrastructure, Mobile App
117	128	1	2026-01-16 12:05:21.238162	transfer_date	\N	2025-07-19
118	128	1	2026-01-16 12:05:21.239491	recruiter	\N	Орлов М.С.
119	128	1	2026-01-16 12:05:21.240564	hr_bp	\N	Лебедева Т.М.
120	128	1	2026-01-16 12:05:21.241608	comments	\N	Срочно нужен проект
121	14	1	2026-01-16 12:05:21.277634	entry_date	\N	2024-04-13
122	14	1	2026-01-16 12:05:21.278807	current_manager	\N	Михайлова О.Н.
123	14	1	2026-01-16 12:05:21.28054	it_block	\N	Эксплуатация
124	14	1	2026-01-16 12:05:21.281737	ck_department	\N	ЦК Аналитики
125	14	1	2026-01-16 12:05:21.282821	placement_type	\N	любой
126	14	1	2026-01-16 12:05:21.284039	ready_for_vacancy	\N	Нет
127	14	1	2026-01-16 12:05:21.285461	resume_link	\N	https://drive.google.com/file/66403
128	14	1	2026-01-16 12:05:21.286364	manager_feedback	\N	Рекомендую
129	14	1	2026-01-16 12:05:21.287535	contacts	\N	+7 (969) 333-74-29, @сокигор80, sokolov@company.ru
130	14	1	2026-01-16 12:05:21.288488	funding_end_date	\N	2026-07-12
131	14	1	2026-01-16 12:05:21.28926	candidate_status	\N	В работе
132	14	1	2026-01-16 12:05:21.289946	target_projects	\N	E-commerce Platform
133	14	1	2026-01-16 12:05:21.29071	transfer_date	\N	
134	14	1	2026-01-16 12:05:21.291863	recruiter	\N	Орлов М.С.
135	14	1	2026-01-16 12:05:21.293411	hr_bp	\N	Лебедева Т.М.
136	14	1	2026-01-16 12:05:21.295166	comments	\N	
137	217	1	2026-01-16 12:05:21.33442	entry_date	\N	2025-06-25
138	217	1	2026-01-16 12:05:21.33584	current_manager	\N	Иванов А.П.
139	217	1	2026-01-16 12:05:21.336834	it_block	\N	B2O
140	217	1	2026-01-16 12:05:21.337887	ck_department	\N	ЦК Разработки
141	217	1	2026-01-16 12:05:21.338727	placement_type	\N	аутстафф
142	217	1	2026-01-16 12:05:21.339555	ready_for_vacancy	\N	Да
143	217	1	2026-01-16 12:05:21.340281	resume_link	\N	https://drive.google.com/file/23287
144	217	1	2026-01-16 12:05:21.340952	manager_feedback	\N	Хороший специалист
145	217	1	2026-01-16 12:05:21.341933	contacts	\N	+7 (927) 603-67-97, @михандр65, valid@test.ru
146	217	1	2026-01-16 12:05:21.342911	funding_end_date	\N	2026-12-13
147	217	1	2026-01-16 12:05:21.343652	candidate_status	\N	Свободен
148	217	1	2026-01-16 12:05:21.344336	target_projects	\N	Banking App, Data Platform, ML Pipeline
149	217	1	2026-01-16 12:05:21.345004	transfer_date	\N	
150	217	1	2026-01-16 12:05:21.34709	recruiter	\N	Новикова Е.П.
151	217	1	2026-01-16 12:05:21.348269	hr_bp	\N	Морозов К.А.
152	217	1	2026-01-16 12:05:21.34915	comments	\N	Срочно нужен проект
153	8	1	2026-01-16 12:05:21.386586	entry_date	\N	2024-02-14
154	8	1	2026-01-16 12:05:21.387616	current_manager	\N	Сидорова Е.К.
155	8	1	2026-01-16 12:05:21.388381	it_block	\N	B2O
156	8	1	2026-01-16 12:05:21.389065	ck_department	\N	Департамент данных
157	8	1	2026-01-16 12:05:21.390255	placement_type	\N	аутстафф
158	8	1	2026-01-16 12:05:21.391029	ready_for_vacancy	\N	Да
159	8	1	2026-01-16 12:05:21.392024	resume_link	\N	https://drive.google.com/file/48728
160	8	1	2026-01-16 12:05:21.392865	manager_feedback	\N	Отличные результаты
161	8	1	2026-01-16 12:05:21.39372	contacts	\N	+7 (968) 589-75-15, @сиддмит17, sidorov@company.ru
162	8	1	2026-01-16 12:05:21.394425	funding_end_date	\N	2025-03-09
163	8	1	2026-01-16 12:05:21.395413	candidate_status	\N	В работе
164	8	1	2026-01-16 12:05:21.39637	target_projects	\N	Data Platform
165	8	1	2026-01-16 12:05:21.397335	transfer_date	\N	
166	8	1	2026-01-16 12:05:21.39831	recruiter	\N	Смирнова А.А.
167	8	1	2026-01-16 12:05:21.399035	hr_bp	\N	Лебедева Т.М.
168	8	1	2026-01-16 12:05:21.399698	comments	\N	
169	13	1	2026-01-16 12:05:21.437604	entry_date	\N	2024-12-22
170	13	1	2026-01-16 12:05:21.439214	current_manager	\N	Козлов Д.В.
171	13	1	2026-01-16 12:05:21.440293	it_block	\N	Прочее
172	13	1	2026-01-16 12:05:21.441417	ck_department	\N	ЦК Разработки
173	13	1	2026-01-16 12:05:21.442562	placement_type	\N	аутстафф
174	13	1	2026-01-16 12:05:21.443576	ready_for_vacancy	\N	Да
175	13	1	2026-01-16 12:05:21.44471	resume_link	\N	https://drive.google.com/file/45257
176	13	1	2026-01-16 12:05:21.445829	manager_feedback	\N	Нужно развитие
177	13	1	2026-01-16 12:05:21.446805	contacts	\N	+7 (987) 430-45-51, @волольг21, volkova@company.ru
178	13	1	2026-01-16 12:05:21.448079	funding_end_date	\N	2026-03-19
179	13	1	2026-01-16 12:05:21.449218	candidate_status	\N	Свободен
180	13	1	2026-01-16 12:05:21.450457	target_projects	\N	Banking App, Mobile App, Data Platform
181	13	1	2026-01-16 12:05:21.451445	transfer_date	\N	
182	13	1	2026-01-16 12:05:21.45258	recruiter	\N	Белова И.Д.
183	13	1	2026-01-16 12:05:21.453828	hr_bp	\N	Морозов К.А.
184	13	1	2026-01-16 12:05:21.455093	comments	\N	
185	11	1	2026-01-16 12:05:21.488452	entry_date	\N	2025-10-18
186	11	1	2026-01-16 12:05:21.490289	current_manager	\N	Иванов А.П.
187	11	1	2026-01-16 12:05:21.491622	it_block	\N	НУК
188	11	1	2026-01-16 12:05:21.492965	ck_department	\N	ЦК Разработки
189	11	1	2026-01-16 12:05:21.494146	placement_type	\N	перевод
190	11	1	2026-01-16 12:05:21.495158	ready_for_vacancy	\N	Да
191	11	1	2026-01-16 12:05:21.497134	resume_link	\N	https://drive.google.com/file/70756
192	11	1	2026-01-16 12:05:21.498831	manager_feedback	\N	Нужно развитие
193	11	1	2026-01-16 12:05:21.50005	contacts	\N	+7 (980) 626-36-58, @феделен70, fedorova@company.ru
194	11	1	2026-01-16 12:05:21.501177	funding_end_date	\N	2026-08-15
195	11	1	2026-01-16 12:05:21.502234	candidate_status	\N	Забронирован
196	11	1	2026-01-16 12:05:21.503245	target_projects	\N	E-commerce Platform, Data Platform
197	11	1	2026-01-16 12:05:21.504484	transfer_date	\N	
198	11	1	2026-01-16 12:05:21.505701	recruiter	\N	Новикова Е.П.
199	11	1	2026-01-16 12:05:21.506659	hr_bp	\N	Морозов К.А.
200	11	1	2026-01-16 12:05:21.507377	comments	\N	
201	394	1	2026-01-16 12:05:21.547402	entry_date	\N	2024-01-01
202	394	1	2026-01-16 12:05:21.548612	current_manager	\N	Петров С.М.
203	394	1	2026-01-16 12:05:21.549517	it_block	\N	НУК
204	394	1	2026-01-16 12:05:21.550619	ck_department	\N	ЦК Аналитики
205	394	1	2026-01-16 12:05:21.551649	placement_type	\N	любой
206	394	1	2026-01-16 12:05:21.552539	ready_for_vacancy	\N	Да
207	394	1	2026-01-16 12:05:21.553439	resume_link	\N	https://drive.google.com/file/68664
208	394	1	2026-01-16 12:05:21.554179	manager_feedback	\N	Нужно развитие
209	394	1	2026-01-16 12:05:21.554941	contacts	\N	+7 (950) 119-77-86, @сокмари92, m.sokolova@rt.ru
210	394	1	2026-01-16 12:05:21.555887	funding_end_date	\N	2026-02-18
211	394	1	2026-01-16 12:05:21.55682	candidate_status	\N	В работе
212	394	1	2026-01-16 12:05:21.557909	target_projects	\N	ML Pipeline
213	394	1	2026-01-16 12:05:21.558828	transfer_date	\N	
214	394	1	2026-01-16 12:05:21.559625	recruiter	\N	Смирнова А.А.
215	394	1	2026-01-16 12:05:21.560254	hr_bp	\N	Лебедева Т.М.
216	394	1	2026-01-16 12:05:21.560899	comments	\N	Срочно нужен проект
217	395	1	2026-01-16 12:05:21.591788	entry_date	\N	2025-02-13
218	395	1	2026-01-16 12:05:21.593078	current_manager	\N	Михайлова О.Н.
219	395	1	2026-01-16 12:05:21.594135	it_block	\N	Эксплуатация
220	395	1	2026-01-16 12:05:21.595003	ck_department	\N	ЦК Аналитики
221	395	1	2026-01-16 12:05:21.595858	placement_type	\N	перевод
222	395	1	2026-01-16 12:05:21.596768	ready_for_vacancy	\N	Нет
223	395	1	2026-01-16 12:05:21.59786	resume_link	\N	https://drive.google.com/file/24475
224	395	1	2026-01-16 12:05:21.598902	manager_feedback	\N	Отличные результаты
225	395	1	2026-01-16 12:05:21.599914	contacts	\N	+7 (964) 105-74-67, @меданто49, a.medvedev@rt.ru
226	395	1	2026-01-16 12:05:21.60081	funding_end_date	\N	2025-08-28
227	395	1	2026-01-16 12:05:21.601957	candidate_status	\N	Переведен
228	395	1	2026-01-16 12:05:21.603314	target_projects	\N	Mobile App, E-commerce Platform
229	395	1	2026-01-16 12:05:21.605007	transfer_date	\N	2025-05-24
230	395	1	2026-01-16 12:05:21.606212	recruiter	\N	Новикова Е.П.
231	395	1	2026-01-16 12:05:21.607926	hr_bp	\N	Лебедева Т.М.
232	395	1	2026-01-16 12:05:21.609021	comments	\N	
233	396	1	2026-01-16 12:05:21.647796	entry_date	\N	2025-05-05
234	396	1	2026-01-16 12:05:21.649074	current_manager	\N	Иванов А.П.
235	396	1	2026-01-16 12:05:21.649882	it_block	\N	B2O
236	396	1	2026-01-16 12:05:21.651318	ck_department	\N	ЦК Инфраструктуры
237	396	1	2026-01-16 12:05:21.654278	placement_type	\N	перевод
238	396	1	2026-01-16 12:05:21.655955	ready_for_vacancy	\N	Нет
239	396	1	2026-01-16 12:05:21.657185	resume_link	\N	https://drive.google.com/file/53618
240	396	1	2026-01-16 12:05:21.658128	manager_feedback	\N	Рекомендую
241	396	1	2026-01-16 12:05:21.658836	contacts	\N	+7 (970) 341-61-23, @новевге84, e.novikov@rt.ru
242	396	1	2026-01-16 12:05:21.659618	funding_end_date	\N	2025-07-15
243	396	1	2026-01-16 12:05:21.660983	candidate_status	\N	В работе
244	396	1	2026-01-16 12:05:21.662123	target_projects	\N	Banking App, E-commerce Platform
245	396	1	2026-01-16 12:05:21.663115	transfer_date	\N	
246	396	1	2026-01-16 12:05:21.663954	recruiter	\N	Белова И.Д.
247	396	1	2026-01-16 12:05:21.665368	hr_bp	\N	Волкова Н.В.
248	396	1	2026-01-16 12:05:21.666359	comments	\N	Ожидает оффер
249	7	1	2026-01-16 12:05:21.707697	entry_date	\N	2025-07-17
250	7	1	2026-01-16 12:05:21.70886	current_manager	\N	Петров С.М.
251	7	1	2026-01-16 12:05:21.710017	it_block	\N	Прочее
252	7	1	2026-01-16 12:05:21.710926	ck_department	\N	Департамент данных
253	7	1	2026-01-16 12:05:21.712019	placement_type	\N	аутстафф
254	7	1	2026-01-16 12:05:21.712928	ready_for_vacancy	\N	Нет
255	7	1	2026-01-16 12:05:21.713868	resume_link	\N	https://drive.google.com/file/48396
256	7	1	2026-01-16 12:05:21.714749	manager_feedback	\N	Отличные результаты
257	7	1	2026-01-16 12:05:21.715571	contacts	\N	+7 (965) 866-79-73, @петмари88, petrova@company.ru
258	7	1	2026-01-16 12:05:21.716423	funding_end_date	\N	2026-07-27
259	7	1	2026-01-16 12:05:21.717412	candidate_status	\N	Переведен
260	7	1	2026-01-16 12:05:21.718388	target_projects	\N	ML Pipeline, Госуслуги 2.0
261	7	1	2026-01-16 12:05:21.719516	transfer_date	\N	2026-03-07
262	7	1	2026-01-16 12:05:21.720678	recruiter	\N	Белова И.Д.
263	7	1	2026-01-16 12:05:21.721555	hr_bp	\N	Морозов К.А.
264	7	1	2026-01-16 12:05:21.723034	comments	\N	
265	218	1	2026-01-16 12:05:21.779748	entry_date	\N	2024-05-18
266	218	1	2026-01-16 12:05:21.780757	current_manager	\N	Иванов А.П.
267	218	1	2026-01-16 12:05:21.78187	it_block	\N	B2O
268	218	1	2026-01-16 12:05:21.782803	ck_department	\N	ЦК Разработки
269	218	1	2026-01-16 12:05:21.783663	placement_type	\N	аутстафф
270	218	1	2026-01-16 12:05:21.784803	ready_for_vacancy	\N	Нет
271	218	1	2026-01-16 12:05:21.785962	resume_link	\N	https://drive.google.com/file/21803
272	218	1	2026-01-16 12:05:21.786847	manager_feedback	\N	Хороший специалист
273	218	1	2026-01-16 12:05:21.787757	contacts	\N	+7 (916) 423-48-78, @тестест96, testov@test.ru
274	218	1	2026-01-16 12:05:21.788604	funding_end_date	\N	2026-11-18
275	218	1	2026-01-16 12:05:21.789732	candidate_status	\N	Свободен
276	218	1	2026-01-16 12:05:21.790775	target_projects	\N	ML Pipeline, Infrastructure
277	218	1	2026-01-16 12:05:21.791694	transfer_date	\N	
278	218	1	2026-01-16 12:05:21.792578	recruiter	\N	Белова И.Д.
279	218	1	2026-01-16 12:05:21.793721	hr_bp	\N	Морозов К.А.
280	218	1	2026-01-16 12:05:21.795003	comments	\N	Срочно нужен проект
281	219	1	2026-01-16 12:05:21.831578	entry_date	\N	2025-05-26
282	219	1	2026-01-16 12:05:21.832546	current_manager	\N	Иванов А.П.
283	219	1	2026-01-16 12:05:21.833393	it_block	\N	B2O
284	219	1	2026-01-16 12:05:21.834272	ck_department	\N	Департамент цифровых продуктов
285	219	1	2026-01-16 12:05:21.83498	placement_type	\N	перевод
286	219	1	2026-01-16 12:05:21.835616	ready_for_vacancy	\N	Да
287	219	1	2026-01-16 12:05:21.836628	resume_link	\N	https://drive.google.com/file/71209
288	219	1	2026-01-16 12:05:21.837602	manager_feedback	\N	Рекомендую
289	219	1	2026-01-16 12:05:21.838291	contacts	\N	+7 (960) 613-96-79, @лебилья29, i.lebedev@rt.ru
290	219	1	2026-01-16 12:05:21.838882	funding_end_date	\N	2025-01-20
291	219	1	2026-01-16 12:05:21.83978	candidate_status	\N	Свободен
292	219	1	2026-01-16 12:05:21.84079	target_projects	\N	Data Platform, Mobile App
293	219	1	2026-01-16 12:05:21.841707	transfer_date	\N	
294	219	1	2026-01-16 12:05:21.842558	recruiter	\N	Новикова Е.П.
295	219	1	2026-01-16 12:05:21.843425	hr_bp	\N	Волкова Н.В.
296	219	1	2026-01-16 12:05:21.844274	comments	\N	Срочно нужен проект
297	220	1	2026-01-16 12:05:21.98829	entry_date	\N	2024-08-09
298	220	1	2026-01-16 12:05:21.989537	current_manager	\N	Сидорова Е.К.
299	220	1	2026-01-16 12:05:21.99039	it_block	\N	Эксплуатация
300	220	1	2026-01-16 12:05:21.991145	ck_department	\N	Департамент цифровых продуктов
301	220	1	2026-01-16 12:05:21.992051	placement_type	\N	любой
302	220	1	2026-01-16 12:05:21.993024	ready_for_vacancy	\N	Нет
303	220	1	2026-01-16 12:05:21.994008	resume_link	\N	https://drive.google.com/file/12944
304	220	1	2026-01-16 12:05:21.994974	manager_feedback	\N	Хороший специалист
305	220	1	2026-01-16 12:05:21.995843	contacts	\N	+7 (955) 693-68-44, @гусвади75, v.gusev@rt.ru
306	220	1	2026-01-16 12:05:21.997551	funding_end_date	\N	2026-09-22
307	220	1	2026-01-16 12:05:21.998682	candidate_status	\N	Забронирован
308	220	1	2026-01-16 12:05:21.999847	target_projects	\N	Banking App, Infrastructure
309	220	1	2026-01-16 12:05:22.001015	transfer_date	\N	
310	220	1	2026-01-16 12:05:22.002153	recruiter	\N	Смирнова А.А.
311	220	1	2026-01-16 12:05:22.003189	hr_bp	\N	Морозов К.А.
312	220	1	2026-01-16 12:05:22.004494	comments	\N	Срочно нужен проект
313	221	1	2026-01-16 12:05:22.036423	entry_date	\N	2025-06-22
314	221	1	2026-01-16 12:05:22.037664	current_manager	\N	Петров С.М.
315	221	1	2026-01-16 12:05:22.038749	it_block	\N	Диджитал
316	221	1	2026-01-16 12:05:22.039664	ck_department	\N	ЦК Разработки
317	221	1	2026-01-16 12:05:22.040592	placement_type	\N	перевод
318	221	1	2026-01-16 12:05:22.041356	ready_for_vacancy	\N	Нет
319	221	1	2026-01-16 12:05:22.042175	resume_link	\N	https://drive.google.com/file/48413
320	221	1	2026-01-16 12:05:22.042968	manager_feedback	\N	Нужно развитие
321	221	1	2026-01-16 12:05:22.043611	contacts	\N	+7 (945) 894-87-74, @гусксен4, k.guseva@rt.ru
322	221	1	2026-01-16 12:05:22.044283	funding_end_date	\N	2025-03-13
323	221	1	2026-01-16 12:05:22.044913	candidate_status	\N	Увольнение по СС
324	221	1	2026-01-16 12:05:22.045702	target_projects	\N	E-commerce Platform
325	221	1	2026-01-16 12:05:22.04656	transfer_date	\N	2025-09-29
326	221	1	2026-01-16 12:05:22.047412	recruiter	\N	Новикова Е.П.
327	221	1	2026-01-16 12:05:22.04827	hr_bp	\N	Волкова Н.В.
328	221	1	2026-01-16 12:05:22.049132	comments	\N	
329	222	1	2026-01-16 12:05:22.086529	entry_date	\N	2025-07-10
330	222	1	2026-01-16 12:05:22.087773	current_manager	\N	Михайлова О.Н.
331	222	1	2026-01-16 12:05:22.088799	it_block	\N	Эксплуатация
332	222	1	2026-01-16 12:05:22.090155	ck_department	\N	ЦК Разработки
333	222	1	2026-01-16 12:05:22.091177	placement_type	\N	перевод
334	222	1	2026-01-16 12:05:22.091875	ready_for_vacancy	\N	Нет
335	222	1	2026-01-16 12:05:22.092507	resume_link	\N	https://drive.google.com/file/13343
336	222	1	2026-01-16 12:05:22.093084	manager_feedback	\N	Нужно развитие
337	222	1	2026-01-16 12:05:22.093847	contacts	\N	+7 (982) 274-76-50, @солники26, n.solovev@rt.ru
338	222	1	2026-01-16 12:05:22.094397	funding_end_date	\N	2026-08-08
339	222	1	2026-01-16 12:05:22.094922	candidate_status	\N	Переведен
340	222	1	2026-01-16 12:05:22.095509	target_projects	\N	E-commerce Platform, DevOps Platform, Data Platform
341	222	1	2026-01-16 12:05:22.096057	transfer_date	\N	2025-06-09
342	222	1	2026-01-16 12:05:22.096623	recruiter	\N	Смирнова А.А.
343	222	1	2026-01-16 12:05:22.09715	hr_bp	\N	Морозов К.А.
344	222	1	2026-01-16 12:05:22.097886	comments	\N	Ожидает оффер
345	223	1	2026-01-16 12:05:22.132103	entry_date	\N	2024-03-14
346	223	1	2026-01-16 12:05:22.133022	current_manager	\N	Козлов Д.В.
347	223	1	2026-01-16 12:05:22.134052	it_block	\N	Диджитал
348	223	1	2026-01-16 12:05:22.135004	ck_department	\N	ЦК Инфраструктуры
349	223	1	2026-01-16 12:05:22.135913	placement_type	\N	аутстафф
350	223	1	2026-01-16 12:05:22.140265	ready_for_vacancy	\N	Нет
351	223	1	2026-01-16 12:05:22.141984	resume_link	\N	https://drive.google.com/file/37540
352	223	1	2026-01-16 12:05:22.143115	manager_feedback	\N	Хороший специалист
353	223	1	2026-01-16 12:05:22.143965	contacts	\N	+7 (940) 556-72-30, @гривале63, v.grigoreva@rt.ru
354	223	1	2026-01-16 12:05:22.144682	funding_end_date	\N	2026-05-14
355	223	1	2026-01-16 12:05:22.145372	candidate_status	\N	В работе
356	223	1	2026-01-16 12:05:22.145912	target_projects	\N	Mobile App, E-commerce Platform
357	223	1	2026-01-16 12:05:22.14639	transfer_date	\N	
358	223	1	2026-01-16 12:05:22.146865	recruiter	\N	Орлов М.С.
359	223	1	2026-01-16 12:05:22.147575	hr_bp	\N	Лебедева Т.М.
360	223	1	2026-01-16 12:05:22.148414	comments	\N	
361	224	1	2026-01-16 12:05:22.18502	entry_date	\N	2025-10-17
362	224	1	2026-01-16 12:05:22.185998	current_manager	\N	Козлов Д.В.
363	224	1	2026-01-16 12:05:22.186687	it_block	\N	Эксплуатация
364	224	1	2026-01-16 12:05:22.187291	ck_department	\N	Департамент цифровых продуктов
365	224	1	2026-01-16 12:05:22.188018	placement_type	\N	перевод
366	224	1	2026-01-16 12:05:22.18857	ready_for_vacancy	\N	Да
367	224	1	2026-01-16 12:05:22.189106	resume_link	\N	https://drive.google.com/file/57519
368	224	1	2026-01-16 12:05:22.189704	manager_feedback	\N	Хороший специалист
369	224	1	2026-01-16 12:05:22.190217	contacts	\N	+7 (934) 858-33-47, @никвади24, v.nikolaev@rt.ru
370	224	1	2026-01-16 12:05:22.191003	funding_end_date	\N	2025-02-23
371	224	1	2026-01-16 12:05:22.192114	candidate_status	\N	В работе
372	224	1	2026-01-16 12:05:22.195329	target_projects	\N	ML Pipeline, Mobile App
373	224	1	2026-01-16 12:05:22.196445	transfer_date	\N	
374	224	1	2026-01-16 12:05:22.197652	recruiter	\N	Смирнова А.А.
375	224	1	2026-01-16 12:05:22.198583	hr_bp	\N	Волкова Н.В.
376	224	1	2026-01-16 12:05:22.199342	comments	\N	В процессе согласования
377	225	1	2026-01-16 12:05:22.235891	entry_date	\N	2024-03-01
378	225	1	2026-01-16 12:05:22.236903	current_manager	\N	Михайлова О.Н.
379	225	1	2026-01-16 12:05:22.238241	it_block	\N	B2O
380	225	1	2026-01-16 12:05:22.238977	ck_department	\N	Департамент данных
381	225	1	2026-01-16 12:05:22.239569	placement_type	\N	любой
382	225	1	2026-01-16 12:05:22.24011	ready_for_vacancy	\N	Нет
383	225	1	2026-01-16 12:05:22.24078	resume_link	\N	https://drive.google.com/file/21731
384	225	1	2026-01-16 12:05:22.241513	manager_feedback	\N	Нужно развитие
385	225	1	2026-01-16 12:05:22.242365	contacts	\N	+7 (987) 156-15-39, @семтать63, t.semenova@rt.ru
386	225	1	2026-01-16 12:05:22.243033	funding_end_date	\N	2026-03-09
387	225	1	2026-01-16 12:05:22.243538	candidate_status	\N	В работе
388	225	1	2026-01-16 12:05:22.244145	target_projects	\N	DevOps Platform
389	225	1	2026-01-16 12:05:22.244733	transfer_date	\N	
390	225	1	2026-01-16 12:05:22.245216	recruiter	\N	Новикова Е.П.
391	225	1	2026-01-16 12:05:22.245981	hr_bp	\N	Волкова Н.В.
392	225	1	2026-01-16 12:05:22.24672	comments	\N	Срочно нужен проект
393	226	1	2026-01-16 12:05:22.283152	entry_date	\N	2024-03-23
394	226	1	2026-01-16 12:05:22.284586	current_manager	\N	Михайлова О.Н.
395	226	1	2026-01-16 12:05:22.285436	it_block	\N	B2O
396	226	1	2026-01-16 12:05:22.286218	ck_department	\N	ЦК Аналитики
397	226	1	2026-01-16 12:05:22.286911	placement_type	\N	аутстафф
398	226	1	2026-01-16 12:05:22.287636	ready_for_vacancy	\N	Да
399	226	1	2026-01-16 12:05:22.288296	resume_link	\N	https://drive.google.com/file/94369
400	226	1	2026-01-16 12:05:22.288919	manager_feedback	\N	Хороший специалист
401	226	1	2026-01-16 12:05:22.28965	contacts	\N	+7 (908) 734-55-54, @стестеп75, s.stepanov@rt.ru
402	226	1	2026-01-16 12:05:22.29031	funding_end_date	\N	2025-11-12
403	226	1	2026-01-16 12:05:22.290925	candidate_status	\N	Увольнение по СЖ
404	226	1	2026-01-16 12:05:22.291511	target_projects	\N	ML Pipeline, Data Platform
405	226	1	2026-01-16 12:05:22.292348	transfer_date	\N	2025-04-18
406	226	1	2026-01-16 12:05:22.293025	recruiter	\N	Смирнова А.А.
407	226	1	2026-01-16 12:05:22.293949	hr_bp	\N	Волкова Н.В.
408	226	1	2026-01-16 12:05:22.294608	comments	\N	
409	227	1	2026-01-16 12:05:22.370008	entry_date	\N	2025-04-29
410	227	1	2026-01-16 12:05:22.372001	current_manager	\N	Михайлова О.Н.
411	227	1	2026-01-16 12:05:22.373976	it_block	\N	Развитие
412	227	1	2026-01-16 12:05:22.37579	ck_department	\N	ЦК Инфраструктуры
413	227	1	2026-01-16 12:05:22.37752	placement_type	\N	аутстафф
414	227	1	2026-01-16 12:05:22.379209	ready_for_vacancy	\N	Нет
415	227	1	2026-01-16 12:05:22.381012	resume_link	\N	https://drive.google.com/file/72260
416	227	1	2026-01-16 12:05:22.382984	manager_feedback	\N	
417	227	1	2026-01-16 12:05:22.384983	contacts	\N	+7 (900) 591-96-17, @фрокири5, k.frolov@rt.ru
418	227	1	2026-01-16 12:05:22.386573	funding_end_date	\N	2026-07-02
419	227	1	2026-01-16 12:05:22.387867	candidate_status	\N	Увольнение по СЖ
420	227	1	2026-01-16 12:05:22.389123	target_projects	\N	Banking App, Mobile App
421	227	1	2026-01-16 12:05:22.390472	transfer_date	\N	2025-03-02
422	227	1	2026-01-16 12:05:22.391557	recruiter	\N	Новикова Е.П.
423	227	1	2026-01-16 12:05:22.393058	hr_bp	\N	Волкова Н.В.
424	227	1	2026-01-16 12:05:22.3945	comments	\N	Ожидает оффер
425	228	1	2026-01-16 12:05:22.432574	entry_date	\N	2024-10-11
426	228	1	2026-01-16 12:05:22.433664	current_manager	\N	Козлов Д.В.
427	228	1	2026-01-16 12:05:22.434497	it_block	\N	НУК
428	228	1	2026-01-16 12:05:22.435483	ck_department	\N	ЦК Разработки
429	228	1	2026-01-16 12:05:22.436419	placement_type	\N	любой
430	228	1	2026-01-16 12:05:22.437418	ready_for_vacancy	\N	Да
431	228	1	2026-01-16 12:05:22.438285	resume_link	\N	https://drive.google.com/file/96371
432	228	1	2026-01-16 12:05:22.439276	manager_feedback	\N	Рекомендую
433	228	1	2026-01-16 12:05:22.440044	contacts	\N	+7 (970) 901-75-45, @егоанна14, a.egorova@rt.ru
434	228	1	2026-01-16 12:05:22.440803	funding_end_date	\N	2025-10-28
435	228	1	2026-01-16 12:05:22.441614	candidate_status	\N	Забронирован
436	228	1	2026-01-16 12:05:22.442399	target_projects	\N	ML Pipeline, Infrastructure, Mobile App
437	228	1	2026-01-16 12:05:22.443191	transfer_date	\N	
438	228	1	2026-01-16 12:05:22.443947	recruiter	\N	Новикова Е.П.
439	228	1	2026-01-16 12:05:22.44473	hr_bp	\N	Волкова Н.В.
440	228	1	2026-01-16 12:05:22.445626	comments	\N	В процессе согласования
441	229	1	2026-01-16 12:05:22.478864	entry_date	\N	2024-12-30
442	229	1	2026-01-16 12:05:22.479669	current_manager	\N	Петров С.М.
443	229	1	2026-01-16 12:05:22.480743	it_block	\N	Эксплуатация
444	229	1	2026-01-16 12:05:22.481548	ck_department	\N	ЦК Разработки
445	229	1	2026-01-16 12:05:22.482376	placement_type	\N	перевод
446	229	1	2026-01-16 12:05:22.482916	ready_for_vacancy	\N	Да
447	229	1	2026-01-16 12:05:22.483405	resume_link	\N	https://drive.google.com/file/17346
448	229	1	2026-01-16 12:05:22.484216	manager_feedback	\N	
449	229	1	2026-01-16 12:05:22.485148	contacts	\N	+7 (927) 779-40-89, @смивади75, v.smirnov@rt.ru
450	229	1	2026-01-16 12:05:22.486019	funding_end_date	\N	2026-01-29
451	229	1	2026-01-16 12:05:22.486833	candidate_status	\N	Забронирован
452	229	1	2026-01-16 12:05:22.487478	target_projects	\N	DevOps Platform, Infrastructure, Banking App
453	229	1	2026-01-16 12:05:22.488382	transfer_date	\N	
454	229	1	2026-01-16 12:05:22.489463	recruiter	\N	Новикова Е.П.
455	229	1	2026-01-16 12:05:22.490317	hr_bp	\N	Морозов К.А.
456	229	1	2026-01-16 12:05:22.491343	comments	\N	
457	17	1	2026-01-16 12:05:22.528267	entry_date	\N	2024-12-24
458	17	1	2026-01-16 12:05:22.529127	current_manager	\N	Иванов А.П.
459	17	1	2026-01-16 12:05:22.529943	it_block	\N	Развитие
460	17	1	2026-01-16 12:05:22.530538	ck_department	\N	ЦК Инфраструктуры
461	17	1	2026-01-16 12:05:22.53119	placement_type	\N	аутстафф
462	17	1	2026-01-16 12:05:22.531693	ready_for_vacancy	\N	Да
463	17	1	2026-01-16 12:05:22.532254	resume_link	\N	https://drive.google.com/file/93508
464	17	1	2026-01-16 12:05:22.532986	manager_feedback	\N	
465	17	1	2026-01-16 12:05:22.534515	contacts	\N	+7 (902) 801-53-10, @куздени58, timofey.romanov1@company.ru
466	17	1	2026-01-16 12:05:22.535355	funding_end_date	\N	2025-02-09
467	17	1	2026-01-16 12:05:22.536041	candidate_status	\N	Увольнение по СС
468	17	1	2026-01-16 12:05:22.536871	target_projects	\N	Infrastructure, Data Platform, ML Pipeline
469	17	1	2026-01-16 12:05:22.537623	transfer_date	\N	2026-10-24
470	17	1	2026-01-16 12:05:22.538435	recruiter	\N	Орлов М.С.
471	17	1	2026-01-16 12:05:22.539139	hr_bp	\N	Морозов К.А.
472	17	1	2026-01-16 12:05:22.539811	comments	\N	В процессе согласования
473	19	1	2026-01-16 12:05:22.572333	entry_date	\N	2024-07-25
474	19	1	2026-01-16 12:05:22.573176	current_manager	\N	Михайлова О.Н.
475	19	1	2026-01-16 12:05:22.573893	it_block	\N	НУК
476	19	1	2026-01-16 12:05:22.574453	ck_department	\N	ЦК Аналитики
477	19	1	2026-01-16 12:05:22.574934	placement_type	\N	перевод
478	19	1	2026-01-16 12:05:22.575498	ready_for_vacancy	\N	Да
479	19	1	2026-01-16 12:05:22.575966	resume_link	\N	https://drive.google.com/file/85068
480	19	1	2026-01-16 12:05:22.576435	manager_feedback	\N	Нужно развитие
481	19	1	2026-01-16 12:05:22.576873	contacts	\N	+7 (969) 883-79-27, @васиван79, nikolay.romanov3@company.ru
482	19	1	2026-01-16 12:05:22.577363	funding_end_date	\N	2025-08-28
483	19	1	2026-01-16 12:05:22.577827	candidate_status	\N	Свободен
484	19	1	2026-01-16 12:05:22.57832	target_projects	\N	DevOps Platform
485	19	1	2026-01-16 12:05:22.578789	transfer_date	\N	
486	19	1	2026-01-16 12:05:22.579285	recruiter	\N	Новикова Е.П.
487	19	1	2026-01-16 12:05:22.579878	hr_bp	\N	Морозов К.А.
488	19	1	2026-01-16 12:05:22.580644	comments	\N	
489	22	1	2026-01-16 12:05:22.612842	entry_date	\N	2025-10-06
490	22	1	2026-01-16 12:05:22.613844	current_manager	\N	Михайлова О.Н.
491	22	1	2026-01-16 12:05:22.614653	it_block	\N	Развитие
492	22	1	2026-01-16 12:05:22.615176	ck_department	\N	Департамент цифровых продуктов
493	22	1	2026-01-16 12:05:22.615644	placement_type	\N	любой
494	22	1	2026-01-16 12:05:22.616154	ready_for_vacancy	\N	Да
495	22	1	2026-01-16 12:05:22.616619	resume_link	\N	https://drive.google.com/file/49944
496	22	1	2026-01-16 12:05:22.617053	manager_feedback	\N	
497	22	1	2026-01-16 12:05:22.618007	contacts	\N	+7 (950) 554-65-81, @михандр69, maxim.grigoriev6@company.ru
498	22	1	2026-01-16 12:05:22.61858	funding_end_date	\N	2025-06-23
499	22	1	2026-01-16 12:05:22.619126	candidate_status	\N	Свободен
500	22	1	2026-01-16 12:05:22.620971	target_projects	\N	Data Platform
501	22	1	2026-01-16 12:05:22.622013	transfer_date	\N	
502	22	1	2026-01-16 12:05:22.622854	recruiter	\N	Белова И.Д.
503	22	1	2026-01-16 12:05:22.623638	hr_bp	\N	Лебедева Т.М.
504	22	1	2026-01-16 12:05:22.624511	comments	\N	Ожидает оффер
505	16	1	2026-01-16 12:05:22.658213	entry_date	\N	2024-03-31
506	16	1	2026-01-16 12:05:22.658985	current_manager	\N	Иванов А.П.
507	16	1	2026-01-16 12:05:22.659847	it_block	\N	Прочее
508	16	1	2026-01-16 12:05:22.660412	ck_department	\N	Департамент цифровых продуктов
509	16	1	2026-01-16 12:05:22.661134	placement_type	\N	аутстафф
510	16	1	2026-01-16 12:05:22.661876	ready_for_vacancy	\N	Нет
511	16	1	2026-01-16 12:05:22.662643	resume_link	\N	https://drive.google.com/file/29686
512	16	1	2026-01-16 12:05:22.663338	manager_feedback	\N	Хороший специалист
513	16	1	2026-01-16 12:05:22.664282	contacts	\N	+7 (957) 709-94-50, @смиилья77, ivan.ivanov@company.ru
514	16	1	2026-01-16 12:05:22.665003	funding_end_date	\N	2026-09-28
515	16	1	2026-01-16 12:05:22.665905	candidate_status	\N	В работе
516	16	1	2026-01-16 12:05:22.666675	target_projects	\N	Banking App, Госуслуги 2.0
517	16	1	2026-01-16 12:05:22.667546	transfer_date	\N	
518	16	1	2026-01-16 12:05:22.66851	recruiter	\N	Орлов М.С.
519	16	1	2026-01-16 12:05:22.669406	hr_bp	\N	Морозов К.А.
520	16	1	2026-01-16 12:05:22.670503	comments	\N	Срочно нужен проект
521	230	1	2026-01-16 12:05:22.704224	entry_date	\N	2024-06-06
522	230	1	2026-01-16 12:05:22.705033	current_manager	\N	Козлов Д.В.
523	230	1	2026-01-16 12:05:22.705982	it_block	\N	НУК
524	230	1	2026-01-16 12:05:22.706758	ck_department	\N	ЦК Инфраструктуры
525	230	1	2026-01-16 12:05:22.707515	placement_type	\N	любой
526	230	1	2026-01-16 12:05:22.708245	ready_for_vacancy	\N	Нет
527	230	1	2026-01-16 12:05:22.709004	resume_link	\N	https://drive.google.com/file/65001
528	230	1	2026-01-16 12:05:22.710057	manager_feedback	\N	Отличные результаты
529	230	1	2026-01-16 12:05:22.710799	contacts	\N	+7 (951) 167-32-74, @вордани38, d.vorobev@rt.ru
530	230	1	2026-01-16 12:05:22.711505	funding_end_date	\N	2026-02-26
531	230	1	2026-01-16 12:05:22.712211	candidate_status	\N	Увольнение по СЖ
532	230	1	2026-01-16 12:05:22.713351	target_projects	\N	Banking App, Госуслуги 2.0, Data Platform
533	230	1	2026-01-16 12:05:22.714136	transfer_date	\N	2026-06-26
534	230	1	2026-01-16 12:05:22.714754	recruiter	\N	Орлов М.С.
535	230	1	2026-01-16 12:05:22.715471	hr_bp	\N	Волкова Н.В.
536	230	1	2026-01-16 12:05:22.716179	comments	\N	Ожидает оффер
537	231	1	2026-01-16 12:05:22.749827	entry_date	\N	2024-12-28
538	231	1	2026-01-16 12:05:22.750748	current_manager	\N	Петров С.М.
539	231	1	2026-01-16 12:05:22.75162	it_block	\N	Прочее
540	231	1	2026-01-16 12:05:22.752407	ck_department	\N	ЦК Разработки
541	231	1	2026-01-16 12:05:22.753133	placement_type	\N	перевод
542	231	1	2026-01-16 12:05:22.753861	ready_for_vacancy	\N	Да
543	231	1	2026-01-16 12:05:22.754801	resume_link	\N	https://drive.google.com/file/18511
544	231	1	2026-01-16 12:05:22.755713	manager_feedback	\N	Отличные результаты
545	231	1	2026-01-16 12:05:22.756544	contacts	\N	+7 (939) 105-78-21, @сокматв65, m.sokolov@rt.ru
546	231	1	2026-01-16 12:05:22.757414	funding_end_date	\N	2025-10-14
547	231	1	2026-01-16 12:05:22.758148	candidate_status	\N	В работе
548	231	1	2026-01-16 12:05:22.758866	target_projects	\N	Госуслуги 2.0, Mobile App
549	231	1	2026-01-16 12:05:22.759582	transfer_date	\N	
550	231	1	2026-01-16 12:05:22.760525	recruiter	\N	Белова И.Д.
551	231	1	2026-01-16 12:05:22.761523	hr_bp	\N	Морозов К.А.
552	231	1	2026-01-16 12:05:22.762186	comments	\N	
553	232	1	2026-01-16 12:05:22.796593	entry_date	\N	2024-08-29
554	232	1	2026-01-16 12:05:22.797467	current_manager	\N	Михайлова О.Н.
555	232	1	2026-01-16 12:05:22.798324	it_block	\N	Прочее
556	232	1	2026-01-16 12:05:22.799154	ck_department	\N	Департамент цифровых продуктов
557	232	1	2026-01-16 12:05:22.800034	placement_type	\N	любой
558	232	1	2026-01-16 12:05:22.800994	ready_for_vacancy	\N	Да
559	232	1	2026-01-16 12:05:22.801731	resume_link	\N	https://drive.google.com/file/42912
560	232	1	2026-01-16 12:05:22.802481	manager_feedback	\N	Отличные результаты
561	232	1	2026-01-16 12:05:22.803226	contacts	\N	+7 (956) 489-38-70, @ивадмит9, d.ivanov@rt.ru
562	232	1	2026-01-16 12:05:22.803986	funding_end_date	\N	2025-09-15
563	232	1	2026-01-16 12:05:22.805169	candidate_status	\N	Свободен
564	232	1	2026-01-16 12:05:22.805872	target_projects	\N	Infrastructure, Data Platform
565	232	1	2026-01-16 12:05:22.806351	transfer_date	\N	
566	232	1	2026-01-16 12:05:22.806777	recruiter	\N	Смирнова А.А.
567	232	1	2026-01-16 12:05:22.807182	hr_bp	\N	Морозов К.А.
568	232	1	2026-01-16 12:05:22.807701	comments	\N	В процессе согласования
569	233	1	2026-01-16 12:05:22.841495	entry_date	\N	2025-10-21
570	233	1	2026-01-16 12:05:22.842156	current_manager	\N	Петров С.М.
571	233	1	2026-01-16 12:05:22.842778	it_block	\N	НУК
572	233	1	2026-01-16 12:05:22.843509	ck_department	\N	ЦК Аналитики
573	233	1	2026-01-16 12:05:22.844221	placement_type	\N	аутстафф
574	233	1	2026-01-16 12:05:22.844927	ready_for_vacancy	\N	Да
575	233	1	2026-01-16 12:05:22.845582	resume_link	\N	https://drive.google.com/file/19842
576	233	1	2026-01-16 12:05:22.846337	manager_feedback	\N	Хороший специалист
577	233	1	2026-01-16 12:05:22.847064	contacts	\N	+7 (913) 457-12-51, @гриалек42, a.grigorev@rt.ru
578	233	1	2026-01-16 12:05:22.847639	funding_end_date	\N	2025-11-27
579	233	1	2026-01-16 12:05:22.84823	candidate_status	\N	Переведен
580	233	1	2026-01-16 12:05:22.848835	target_projects	\N	E-commerce Platform, Mobile App
581	233	1	2026-01-16 12:05:22.849543	transfer_date	\N	2026-07-02
582	233	1	2026-01-16 12:05:22.850236	recruiter	\N	Смирнова А.А.
583	233	1	2026-01-16 12:05:22.851184	hr_bp	\N	Волкова Н.В.
584	233	1	2026-01-16 12:05:22.852181	comments	\N	Ожидает оффер
585	234	1	2026-01-16 12:05:22.884967	entry_date	\N	2025-07-10
586	234	1	2026-01-16 12:05:22.885985	current_manager	\N	Петров С.М.
587	234	1	2026-01-16 12:05:22.886765	it_block	\N	B2O
588	234	1	2026-01-16 12:05:22.887521	ck_department	\N	ЦК Разработки
589	234	1	2026-01-16 12:05:22.888344	placement_type	\N	аутстафф
590	234	1	2026-01-16 12:05:22.88939	ready_for_vacancy	\N	Да
591	234	1	2026-01-16 12:05:22.890283	resume_link	\N	https://drive.google.com/file/68595
592	234	1	2026-01-16 12:05:22.891352	manager_feedback	\N	Нужно развитие
593	234	1	2026-01-16 12:05:22.892224	contacts	\N	+7 (964) 735-32-31, @антанна37, a.antonova@rt.ru
594	234	1	2026-01-16 12:05:22.893297	funding_end_date	\N	2025-04-25
595	234	1	2026-01-16 12:05:22.894186	candidate_status	\N	Переведен
596	234	1	2026-01-16 12:05:22.895067	target_projects	\N	ML Pipeline
597	234	1	2026-01-16 12:05:22.895966	transfer_date	\N	2026-01-27
598	234	1	2026-01-16 12:05:22.896875	recruiter	\N	Орлов М.С.
599	234	1	2026-01-16 12:05:22.897695	hr_bp	\N	Морозов К.А.
600	234	1	2026-01-16 12:05:22.898295	comments	\N	Ожидает оффер
601	235	1	2026-01-16 12:05:22.931061	entry_date	\N	2024-01-19
602	235	1	2026-01-16 12:05:22.931929	current_manager	\N	Иванов А.П.
603	235	1	2026-01-16 12:05:22.932776	it_block	\N	Прочее
604	235	1	2026-01-16 12:05:22.933281	ck_department	\N	ЦК Инфраструктуры
605	235	1	2026-01-16 12:05:22.934069	placement_type	\N	аутстафф
606	235	1	2026-01-16 12:05:22.935219	ready_for_vacancy	\N	Да
607	235	1	2026-01-16 12:05:22.935991	resume_link	\N	https://drive.google.com/file/83401
608	235	1	2026-01-16 12:05:22.936618	manager_feedback	\N	Рекомендую
609	235	1	2026-01-16 12:05:22.93714	contacts	\N	+7 (968) 530-48-15, @петмари33, m.petrova@rt.ru
610	235	1	2026-01-16 12:05:22.937733	funding_end_date	\N	2025-06-24
611	235	1	2026-01-16 12:05:22.93819	candidate_status	\N	Забронирован
612	235	1	2026-01-16 12:05:22.938593	target_projects	\N	Mobile App, Data Platform, Infrastructure
613	235	1	2026-01-16 12:05:22.93903	transfer_date	\N	
614	235	1	2026-01-16 12:05:22.939447	recruiter	\N	Белова И.Д.
615	235	1	2026-01-16 12:05:22.939843	hr_bp	\N	Морозов К.А.
616	235	1	2026-01-16 12:05:22.940239	comments	\N	Ожидает оффер
617	236	1	2026-01-16 12:05:22.972002	entry_date	\N	2024-11-20
618	236	1	2026-01-16 12:05:22.972975	current_manager	\N	Козлов Д.В.
619	236	1	2026-01-16 12:05:22.974045	it_block	\N	B2O
620	236	1	2026-01-16 12:05:22.974882	ck_department	\N	ЦК Разработки
621	236	1	2026-01-16 12:05:22.975597	placement_type	\N	аутстафф
622	236	1	2026-01-16 12:05:22.976198	ready_for_vacancy	\N	Да
623	236	1	2026-01-16 12:05:22.9768	resume_link	\N	https://drive.google.com/file/33643
624	236	1	2026-01-16 12:05:22.977844	manager_feedback	\N	
625	236	1	2026-01-16 12:05:22.978644	contacts	\N	+7 (910) 963-95-99, @семдани93, d.semenov@rt.ru
626	236	1	2026-01-16 12:05:22.979228	funding_end_date	\N	2025-06-21
627	236	1	2026-01-16 12:05:22.979988	candidate_status	\N	Переведен
628	236	1	2026-01-16 12:05:22.981033	target_projects	\N	DevOps Platform, ML Pipeline
629	236	1	2026-01-16 12:05:22.98169	transfer_date	\N	2025-07-29
630	236	1	2026-01-16 12:05:22.982359	recruiter	\N	Орлов М.С.
631	236	1	2026-01-16 12:05:22.983018	hr_bp	\N	Лебедева Т.М.
632	236	1	2026-01-16 12:05:22.983479	comments	\N	Ожидает оффер
633	237	1	2026-01-16 12:05:23.018608	entry_date	\N	2025-03-29
634	237	1	2026-01-16 12:05:23.019552	current_manager	\N	Иванов А.П.
635	237	1	2026-01-16 12:05:23.020289	it_block	\N	Эксплуатация
636	237	1	2026-01-16 12:05:23.021192	ck_department	\N	Департамент данных
637	237	1	2026-01-16 12:05:23.021985	placement_type	\N	любой
638	237	1	2026-01-16 12:05:23.022739	ready_for_vacancy	\N	Нет
639	237	1	2026-01-16 12:05:23.023513	resume_link	\N	https://drive.google.com/file/74350
640	237	1	2026-01-16 12:05:23.024302	manager_feedback	\N	
641	237	1	2026-01-16 12:05:23.025348	contacts	\N	+7 (946) 532-49-93, @винмари10, m.vinogradova@rt.ru
642	237	1	2026-01-16 12:05:23.026137	funding_end_date	\N	2026-05-02
643	237	1	2026-01-16 12:05:23.026913	candidate_status	\N	Забронирован
644	237	1	2026-01-16 12:05:23.027637	target_projects	\N	Data Platform, Banking App, DevOps Platform
645	237	1	2026-01-16 12:05:23.028527	transfer_date	\N	
646	237	1	2026-01-16 12:05:23.029414	recruiter	\N	Белова И.Д.
647	237	1	2026-01-16 12:05:23.030199	hr_bp	\N	Лебедева Т.М.
648	237	1	2026-01-16 12:05:23.031044	comments	\N	
649	238	1	2026-01-16 12:05:23.062711	entry_date	\N	2024-10-14
650	238	1	2026-01-16 12:05:23.063641	current_manager	\N	Сидорова Е.К.
651	238	1	2026-01-16 12:05:23.064204	it_block	\N	Эксплуатация
652	238	1	2026-01-16 12:05:23.064652	ck_department	\N	Департамент цифровых продуктов
653	238	1	2026-01-16 12:05:23.065433	placement_type	\N	любой
654	238	1	2026-01-16 12:05:23.066137	ready_for_vacancy	\N	Нет
655	238	1	2026-01-16 12:05:23.066758	resume_link	\N	https://drive.google.com/file/41364
656	238	1	2026-01-16 12:05:23.067355	manager_feedback	\N	
739	23	1	2026-01-16 12:05:23.266505	candidate_status	\N	Переведен
657	238	1	2026-01-16 12:05:23.067956	contacts	\N	+7 (909) 988-59-16, @алевлад62, v.alekseev@rt.ru
658	238	1	2026-01-16 12:05:23.06864	funding_end_date	\N	2025-08-08
659	238	1	2026-01-16 12:05:23.069556	candidate_status	\N	Увольнение по СС
660	238	1	2026-01-16 12:05:23.070276	target_projects	\N	Infrastructure, Data Platform, DevOps Platform
661	238	1	2026-01-16 12:05:23.071051	transfer_date	\N	2025-12-16
662	238	1	2026-01-16 12:05:23.071532	recruiter	\N	Белова И.Д.
663	238	1	2026-01-16 12:05:23.072253	hr_bp	\N	Лебедева Т.М.
664	238	1	2026-01-16 12:05:23.072696	comments	\N	
665	239	1	2026-01-16 12:05:23.099673	entry_date	\N	2025-08-26
666	239	1	2026-01-16 12:05:23.100976	current_manager	\N	Козлов Д.В.
667	239	1	2026-01-16 12:05:23.102006	it_block	\N	НУК
668	239	1	2026-01-16 12:05:23.10273	ck_department	\N	ЦК Инфраструктуры
669	239	1	2026-01-16 12:05:23.103452	placement_type	\N	аутстафф
670	239	1	2026-01-16 12:05:23.104209	ready_for_vacancy	\N	Нет
671	239	1	2026-01-16 12:05:23.104969	resume_link	\N	https://drive.google.com/file/40717
672	239	1	2026-01-16 12:05:23.105889	manager_feedback	\N	
673	239	1	2026-01-16 12:05:23.106695	contacts	\N	+7 (995) 281-48-46, @ковмари32, m.kovaleva@rt.ru
674	239	1	2026-01-16 12:05:23.107492	funding_end_date	\N	2026-08-26
675	239	1	2026-01-16 12:05:23.10823	candidate_status	\N	Увольнение по СЖ
676	239	1	2026-01-16 12:05:23.108938	target_projects	\N	Госуслуги 2.0, Banking App
677	239	1	2026-01-16 12:05:23.109639	transfer_date	\N	2026-10-30
678	239	1	2026-01-16 12:05:23.110116	recruiter	\N	Орлов М.С.
679	239	1	2026-01-16 12:05:23.110542	hr_bp	\N	Волкова Н.В.
680	239	1	2026-01-16 12:05:23.110965	comments	\N	Ожидает оффер
681	240	1	2026-01-16 12:05:23.142294	entry_date	\N	2024-04-09
682	240	1	2026-01-16 12:05:23.142991	current_manager	\N	Михайлова О.Н.
683	240	1	2026-01-16 12:05:23.14364	it_block	\N	Прочее
684	240	1	2026-01-16 12:05:23.144326	ck_department	\N	Департамент цифровых продуктов
685	240	1	2026-01-16 12:05:23.145166	placement_type	\N	любой
686	240	1	2026-01-16 12:05:23.145938	ready_for_vacancy	\N	Нет
687	240	1	2026-01-16 12:05:23.146681	resume_link	\N	https://drive.google.com/file/96989
688	240	1	2026-01-16 12:05:23.147565	manager_feedback	\N	
689	240	1	2026-01-16 12:05:23.148276	contacts	\N	+7 (982) 471-59-18, @антанас88, a.antonova@rt.ru
690	240	1	2026-01-16 12:05:23.148902	funding_end_date	\N	2025-07-09
691	240	1	2026-01-16 12:05:23.149626	candidate_status	\N	Свободен
692	240	1	2026-01-16 12:05:23.150256	target_projects	\N	Infrastructure
693	240	1	2026-01-16 12:05:23.15147	transfer_date	\N	
694	240	1	2026-01-16 12:05:23.152569	recruiter	\N	Орлов М.С.
695	240	1	2026-01-16 12:05:23.153352	hr_bp	\N	Морозов К.А.
696	240	1	2026-01-16 12:05:23.154184	comments	\N	
697	241	1	2026-01-16 12:05:23.181649	entry_date	\N	2024-10-12
698	241	1	2026-01-16 12:05:23.182483	current_manager	\N	Михайлова О.Н.
699	241	1	2026-01-16 12:05:23.183138	it_block	\N	Диджитал
700	241	1	2026-01-16 12:05:23.184208	ck_department	\N	Департамент данных
701	241	1	2026-01-16 12:05:23.184958	placement_type	\N	аутстафф
702	241	1	2026-01-16 12:05:23.185574	ready_for_vacancy	\N	Да
703	241	1	2026-01-16 12:05:23.187076	resume_link	\N	https://drive.google.com/file/52352
704	241	1	2026-01-16 12:05:23.187849	manager_feedback	\N	Отличные результаты
705	241	1	2026-01-16 12:05:23.188542	contacts	\N	+7 (980) 645-49-68, @зайкрис7, k.zaytseva@rt.ru
706	241	1	2026-01-16 12:05:23.189615	funding_end_date	\N	2025-05-14
707	241	1	2026-01-16 12:05:23.190543	candidate_status	\N	Забронирован
708	241	1	2026-01-16 12:05:23.191134	target_projects	\N	Data Platform, Banking App, Госуслуги 2.0
709	241	1	2026-01-16 12:05:23.191729	transfer_date	\N	
710	241	1	2026-01-16 12:05:23.192357	recruiter	\N	Орлов М.С.
711	241	1	2026-01-16 12:05:23.192933	hr_bp	\N	Морозов К.А.
712	241	1	2026-01-16 12:05:23.193461	comments	\N	В процессе согласования
713	242	1	2026-01-16 12:05:23.22236	entry_date	\N	2025-11-05
714	242	1	2026-01-16 12:05:23.223277	current_manager	\N	Михайлова О.Н.
715	242	1	2026-01-16 12:05:23.224041	it_block	\N	НУК
716	242	1	2026-01-16 12:05:23.225077	ck_department	\N	ЦК Аналитики
717	242	1	2026-01-16 12:05:23.226033	placement_type	\N	любой
718	242	1	2026-01-16 12:05:23.226796	ready_for_vacancy	\N	Да
719	242	1	2026-01-16 12:05:23.227585	resume_link	\N	https://drive.google.com/file/31026
720	242	1	2026-01-16 12:05:23.228338	manager_feedback	\N	Хороший специалист
721	242	1	2026-01-16 12:05:23.22904	contacts	\N	+7 (975) 637-86-88, @таригор19, i.tarasov@rt.ru
722	242	1	2026-01-16 12:05:23.229879	funding_end_date	\N	2025-10-15
723	242	1	2026-01-16 12:05:23.230542	candidate_status	\N	Увольнение по СС
724	242	1	2026-01-16 12:05:23.231085	target_projects	\N	DevOps Platform, Госуслуги 2.0
725	242	1	2026-01-16 12:05:23.231697	transfer_date	\N	2025-05-30
726	242	1	2026-01-16 12:05:23.232135	recruiter	\N	Смирнова А.А.
727	242	1	2026-01-16 12:05:23.232569	hr_bp	\N	Волкова Н.В.
728	242	1	2026-01-16 12:05:23.233491	comments	\N	
729	23	1	2026-01-16 12:05:23.258266	entry_date	\N	2025-11-15
730	23	1	2026-01-16 12:05:23.259709	current_manager	\N	Петров С.М.
731	23	1	2026-01-16 12:05:23.260633	it_block	\N	НУК
732	23	1	2026-01-16 12:05:23.26143	ck_department	\N	ЦК Аналитики
733	23	1	2026-01-16 12:05:23.262237	placement_type	\N	аутстафф
734	23	1	2026-01-16 12:05:23.262842	ready_for_vacancy	\N	Да
735	23	1	2026-01-16 12:05:23.263792	resume_link	\N	https://drive.google.com/file/37126
736	23	1	2026-01-16 12:05:23.264419	manager_feedback	\N	Нужно развитие
737	23	1	2026-01-16 12:05:23.265163	contacts	\N	+7 (986) 428-20-44, @новрома5, denis.fedorov7@company.ru
738	23	1	2026-01-16 12:05:23.265849	funding_end_date	\N	2026-11-15
740	23	1	2026-01-16 12:05:23.267396	target_projects	\N	Banking App
741	23	1	2026-01-16 12:05:23.26802	transfer_date	\N	2026-10-25
742	23	1	2026-01-16 12:05:23.268808	recruiter	\N	Новикова Е.П.
743	23	1	2026-01-16 12:05:23.26941	hr_bp	\N	Лебедева Т.М.
744	23	1	2026-01-16 12:05:23.26998	comments	\N	
745	144	1	2026-01-16 12:05:23.31202	entry_date	\N	2025-09-12
746	144	1	2026-01-16 12:05:23.312678	current_manager	\N	Козлов Д.В.
747	144	1	2026-01-16 12:05:23.313262	it_block	\N	Развитие
748	144	1	2026-01-16 12:05:23.313784	ck_department	\N	ЦК Аналитики
749	144	1	2026-01-16 12:05:23.314279	placement_type	\N	аутстафф
750	144	1	2026-01-16 12:05:23.314684	ready_for_vacancy	\N	Нет
751	144	1	2026-01-16 12:05:23.315095	resume_link	\N	https://drive.google.com/file/51239
752	144	1	2026-01-16 12:05:23.315486	manager_feedback	\N	Рекомендую
753	144	1	2026-01-16 12:05:23.315876	contacts	\N	+7 (937) 428-59-57, @фёдсерг50, arseny.smirnov128@company.ru
754	144	1	2026-01-16 12:05:23.316268	funding_end_date	\N	2026-08-12
755	144	1	2026-01-16 12:05:23.31666	candidate_status	\N	Переведен
756	144	1	2026-01-16 12:05:23.317056	target_projects	\N	Mobile App
757	144	1	2026-01-16 12:05:23.317614	transfer_date	\N	2026-03-17
758	144	1	2026-01-16 12:05:23.318077	recruiter	\N	Белова И.Д.
759	144	1	2026-01-16 12:05:23.318471	hr_bp	\N	Морозов К.А.
760	144	1	2026-01-16 12:05:23.318862	comments	\N	Срочно нужен проект
761	63	1	2026-01-16 12:05:23.367913	entry_date	\N	2024-09-14
762	63	1	2026-01-16 12:05:23.369703	current_manager	\N	Петров С.М.
763	63	1	2026-01-16 12:05:23.370277	it_block	\N	B2O
764	63	1	2026-01-16 12:05:23.370776	ck_department	\N	ЦК Разработки
765	63	1	2026-01-16 12:05:23.371256	placement_type	\N	любой
766	63	1	2026-01-16 12:05:23.371662	ready_for_vacancy	\N	Нет
767	63	1	2026-01-16 12:05:23.372084	resume_link	\N	https://drive.google.com/file/99148
768	63	1	2026-01-16 12:05:23.372473	manager_feedback	\N	Отличные результаты
769	63	1	2026-01-16 12:05:23.373695	contacts	\N	+7 (970) 214-69-96, @попартё67, arseny.morozov47@company.ru
770	63	1	2026-01-16 12:05:23.374947	funding_end_date	\N	2026-07-11
771	63	1	2026-01-16 12:05:23.376211	candidate_status	\N	Переведен
772	63	1	2026-01-16 12:05:23.377554	target_projects	\N	Banking App
773	63	1	2026-01-16 12:05:23.378522	transfer_date	\N	2025-03-28
774	63	1	2026-01-16 12:05:23.37951	recruiter	\N	Орлов М.С.
775	63	1	2026-01-16 12:05:23.380933	hr_bp	\N	Лебедева Т.М.
776	63	1	2026-01-16 12:05:23.381886	comments	\N	
777	67	1	2026-01-16 12:05:23.419934	entry_date	\N	2024-01-03
778	67	1	2026-01-16 12:05:23.42095	current_manager	\N	Козлов Д.В.
779	67	1	2026-01-16 12:05:23.421984	it_block	\N	Эксплуатация
780	67	1	2026-01-16 12:05:23.42281	ck_department	\N	Департамент данных
781	67	1	2026-01-16 12:05:23.423344	placement_type	\N	перевод
782	67	1	2026-01-16 12:05:23.423821	ready_for_vacancy	\N	Да
783	67	1	2026-01-16 12:05:23.424682	resume_link	\N	https://drive.google.com/file/17091
784	67	1	2026-01-16 12:05:23.425305	manager_feedback	\N	Хороший специалист
785	67	1	2026-01-16 12:05:23.426001	contacts	\N	+7 (918) 346-95-33, @михандр57, evgeny.dmitriev51@company.ru
786	67	1	2026-01-16 12:05:23.426579	funding_end_date	\N	2026-03-01
787	67	1	2026-01-16 12:05:23.427074	candidate_status	\N	Переведен
788	67	1	2026-01-16 12:05:23.427537	target_projects	\N	Data Platform
789	67	1	2026-01-16 12:05:23.427979	transfer_date	\N	2026-02-12
790	67	1	2026-01-16 12:05:23.42874	recruiter	\N	Орлов М.С.
791	67	1	2026-01-16 12:05:23.429304	hr_bp	\N	Морозов К.А.
792	67	1	2026-01-16 12:05:23.430086	comments	\N	
793	180	1	2026-01-16 12:05:23.458953	entry_date	\N	2024-02-18
794	180	1	2026-01-16 12:05:23.460002	current_manager	\N	Петров С.М.
795	180	1	2026-01-16 12:05:23.460796	it_block	\N	НУК
796	180	1	2026-01-16 12:05:23.461608	ck_department	\N	ЦК Инфраструктуры
797	180	1	2026-01-16 12:05:23.462171	placement_type	\N	любой
798	180	1	2026-01-16 12:05:23.462606	ready_for_vacancy	\N	Да
799	180	1	2026-01-16 12:05:23.463058	resume_link	\N	https://drive.google.com/file/15648
800	180	1	2026-01-16 12:05:23.46377	manager_feedback	\N	
801	180	1	2026-01-16 12:05:23.464539	contacts	\N	+7 (959) 128-82-16, @иваалек68, vladimir.borisov164@company.ru
802	180	1	2026-01-16 12:05:23.465315	funding_end_date	\N	2025-07-21
803	180	1	2026-01-16 12:05:23.465921	candidate_status	\N	Увольнение по СЖ
804	180	1	2026-01-16 12:05:23.466504	target_projects	\N	Госуслуги 2.0, DevOps Platform
805	180	1	2026-01-16 12:05:23.467474	transfer_date	\N	2026-08-30
806	180	1	2026-01-16 12:05:23.468232	recruiter	\N	Белова И.Д.
807	180	1	2026-01-16 12:05:23.468872	hr_bp	\N	Морозов К.А.
808	180	1	2026-01-16 12:05:23.469685	comments	\N	Ожидает оффер
809	260	1	2026-01-16 12:05:23.526641	entry_date	\N	2024-06-14
810	260	1	2026-01-16 12:05:23.527565	current_manager	\N	Петров С.М.
811	260	1	2026-01-16 12:05:23.528376	it_block	\N	Эксплуатация
812	260	1	2026-01-16 12:05:23.52896	ck_department	\N	ЦК Инфраструктуры
813	260	1	2026-01-16 12:05:23.529548	placement_type	\N	перевод
814	260	1	2026-01-16 12:05:23.529994	ready_for_vacancy	\N	Да
815	260	1	2026-01-16 12:05:23.530419	resume_link	\N	https://drive.google.com/file/97935
816	260	1	2026-01-16 12:05:23.530807	manager_feedback	\N	Хороший специалист
817	260	1	2026-01-16 12:05:23.531193	contacts	\N	+7 (923) 297-76-10, @козглеб96, g.kozlov@rt.ru
818	260	1	2026-01-16 12:05:23.531687	funding_end_date	\N	2025-02-18
819	260	1	2026-01-16 12:05:23.532376	candidate_status	\N	Забронирован
820	260	1	2026-01-16 12:05:23.533058	target_projects	\N	Banking App, ML Pipeline, Госуслуги 2.0
821	260	1	2026-01-16 12:05:23.533692	transfer_date	\N	
822	260	1	2026-01-16 12:05:23.534442	recruiter	\N	Смирнова А.А.
823	260	1	2026-01-16 12:05:23.535255	hr_bp	\N	Волкова Н.В.
824	260	1	2026-01-16 12:05:23.53623	comments	\N	Ожидает оффер
825	261	1	2026-01-16 12:05:23.564811	entry_date	\N	2025-04-03
826	261	1	2026-01-16 12:05:23.565608	current_manager	\N	Иванов А.П.
827	261	1	2026-01-16 12:05:23.566088	it_block	\N	Диджитал
828	261	1	2026-01-16 12:05:23.566522	ck_department	\N	Департамент цифровых продуктов
829	261	1	2026-01-16 12:05:23.566932	placement_type	\N	аутстафф
830	261	1	2026-01-16 12:05:23.567391	ready_for_vacancy	\N	Нет
831	261	1	2026-01-16 12:05:23.568093	resume_link	\N	https://drive.google.com/file/53895
832	261	1	2026-01-16 12:05:23.56888	manager_feedback	\N	Отличные результаты
833	261	1	2026-01-16 12:05:23.56962	contacts	\N	+7 (975) 551-53-35, @семдени82, d.semenov@rt.ru
834	261	1	2026-01-16 12:05:23.570212	funding_end_date	\N	2026-05-02
835	261	1	2026-01-16 12:05:23.571051	candidate_status	\N	Увольнение по СЖ
836	261	1	2026-01-16 12:05:23.571913	target_projects	\N	Mobile App, Infrastructure
837	261	1	2026-01-16 12:05:23.572413	transfer_date	\N	2025-07-06
838	261	1	2026-01-16 12:05:23.572871	recruiter	\N	Смирнова А.А.
839	261	1	2026-01-16 12:05:23.573462	hr_bp	\N	Морозов К.А.
840	261	1	2026-01-16 12:05:23.574294	comments	\N	В процессе согласования
841	262	1	2026-01-16 12:05:23.605759	entry_date	\N	2025-08-19
842	262	1	2026-01-16 12:05:23.606454	current_manager	\N	Михайлова О.Н.
843	262	1	2026-01-16 12:05:23.607063	it_block	\N	B2O
844	262	1	2026-01-16 12:05:23.608007	ck_department	\N	Департамент цифровых продуктов
845	262	1	2026-01-16 12:05:23.608581	placement_type	\N	перевод
846	262	1	2026-01-16 12:05:23.609016	ready_for_vacancy	\N	Нет
847	262	1	2026-01-16 12:05:23.609738	resume_link	\N	https://drive.google.com/file/84134
848	262	1	2026-01-16 12:05:23.610245	manager_feedback	\N	Нужно развитие
849	262	1	2026-01-16 12:05:23.610752	contacts	\N	+7 (915) 789-65-24, @фросаве87, s.frolov@rt.ru
850	262	1	2026-01-16 12:05:23.611283	funding_end_date	\N	2026-03-12
851	262	1	2026-01-16 12:05:23.611707	candidate_status	\N	В работе
852	262	1	2026-01-16 12:05:23.612224	target_projects	\N	Mobile App
853	262	1	2026-01-16 12:05:23.612616	transfer_date	\N	
854	262	1	2026-01-16 12:05:23.612998	recruiter	\N	Смирнова А.А.
855	262	1	2026-01-16 12:05:23.61356	hr_bp	\N	Волкова Н.В.
856	262	1	2026-01-16 12:05:23.614127	comments	\N	
857	263	1	2026-01-16 12:05:23.638604	entry_date	\N	2024-06-07
858	263	1	2026-01-16 12:05:23.639554	current_manager	\N	Козлов Д.В.
859	263	1	2026-01-16 12:05:23.640136	it_block	\N	Диджитал
860	263	1	2026-01-16 12:05:23.640762	ck_department	\N	ЦК Инфраструктуры
861	263	1	2026-01-16 12:05:23.641171	placement_type	\N	любой
862	263	1	2026-01-16 12:05:23.641946	ready_for_vacancy	\N	Да
863	263	1	2026-01-16 12:05:23.642631	resume_link	\N	https://drive.google.com/file/31631
864	263	1	2026-01-16 12:05:23.643424	manager_feedback	\N	Нужно развитие
865	263	1	2026-01-16 12:05:23.64413	contacts	\N	+7 (982) 472-77-73, @козпаве80, p.kozlov@rt.ru
866	263	1	2026-01-16 12:05:23.644637	funding_end_date	\N	2025-07-19
867	263	1	2026-01-16 12:05:23.645039	candidate_status	\N	Увольнение по СЖ
868	263	1	2026-01-16 12:05:23.645497	target_projects	\N	ML Pipeline
869	263	1	2026-01-16 12:05:23.645893	transfer_date	\N	2025-07-30
870	263	1	2026-01-16 12:05:23.646264	recruiter	\N	Орлов М.С.
871	263	1	2026-01-16 12:05:23.646639	hr_bp	\N	Морозов К.А.
872	263	1	2026-01-16 12:05:23.647178	comments	\N	В процессе согласования
873	264	1	2026-01-16 12:05:23.677841	entry_date	\N	2024-09-19
874	264	1	2026-01-16 12:05:23.678887	current_manager	\N	Михайлова О.Н.
875	264	1	2026-01-16 12:05:23.679496	it_block	\N	B2O
876	264	1	2026-01-16 12:05:23.680188	ck_department	\N	Департамент данных
877	264	1	2026-01-16 12:05:23.680919	placement_type	\N	любой
878	264	1	2026-01-16 12:05:23.681541	ready_for_vacancy	\N	Да
879	264	1	2026-01-16 12:05:23.682085	resume_link	\N	https://drive.google.com/file/72812
880	264	1	2026-01-16 12:05:23.68286	manager_feedback	\N	Хороший специалист
881	264	1	2026-01-16 12:05:23.68347	contacts	\N	+7 (947) 829-66-73, @меданна44, a.medvedeva@rt.ru
882	264	1	2026-01-16 12:05:23.684377	funding_end_date	\N	2026-06-13
883	264	1	2026-01-16 12:05:23.685415	candidate_status	\N	Свободен
884	264	1	2026-01-16 12:05:23.686133	target_projects	\N	Mobile App
885	264	1	2026-01-16 12:05:23.686866	transfer_date	\N	
886	264	1	2026-01-16 12:05:23.687337	recruiter	\N	Смирнова А.А.
887	264	1	2026-01-16 12:05:23.688169	hr_bp	\N	Волкова Н.В.
888	264	1	2026-01-16 12:05:23.688922	comments	\N	
889	265	1	2026-01-16 12:05:23.713557	entry_date	\N	2025-06-24
890	265	1	2026-01-16 12:05:23.714576	current_manager	\N	Михайлова О.Н.
891	265	1	2026-01-16 12:05:23.715096	it_block	\N	Диджитал
892	265	1	2026-01-16 12:05:23.715511	ck_department	\N	Департамент цифровых продуктов
893	265	1	2026-01-16 12:05:23.715907	placement_type	\N	аутстафф
894	265	1	2026-01-16 12:05:23.716291	ready_for_vacancy	\N	Да
895	265	1	2026-01-16 12:05:23.716667	resume_link	\N	https://drive.google.com/file/41003
896	265	1	2026-01-16 12:05:23.717038	manager_feedback	\N	Нужно развитие
897	265	1	2026-01-16 12:05:23.717508	contacts	\N	+7 (968) 738-59-75, @семгали73, g.semenova@rt.ru
898	265	1	2026-01-16 12:05:23.717937	funding_end_date	\N	2025-03-14
899	265	1	2026-01-16 12:05:23.718444	candidate_status	\N	Переведен
900	265	1	2026-01-16 12:05:23.718903	target_projects	\N	DevOps Platform, E-commerce Platform, Infrastructure
901	265	1	2026-01-16 12:05:23.719319	transfer_date	\N	2026-01-23
902	265	1	2026-01-16 12:05:23.719868	recruiter	\N	Смирнова А.А.
903	265	1	2026-01-16 12:05:23.72051	hr_bp	\N	Морозов К.А.
904	265	1	2026-01-16 12:05:23.721449	comments	\N	Ожидает оффер
905	24	1	2026-01-16 12:05:23.743634	entry_date	\N	2024-11-06
906	24	1	2026-01-16 12:05:23.744283	current_manager	\N	Петров С.М.
907	24	1	2026-01-16 12:05:23.7448	it_block	\N	Эксплуатация
908	24	1	2026-01-16 12:05:23.745553	ck_department	\N	ЦК Аналитики
909	24	1	2026-01-16 12:05:23.746007	placement_type	\N	перевод
910	24	1	2026-01-16 12:05:23.746427	ready_for_vacancy	\N	Да
911	24	1	2026-01-16 12:05:23.746835	resume_link	\N	https://drive.google.com/file/11546
912	24	1	2026-01-16 12:05:23.747213	manager_feedback	\N	Нужно развитие
913	24	1	2026-01-16 12:05:23.747585	contacts	\N	+7 (909) 118-19-94, @фёдсерг18, alexander.borisov8@company.ru
914	24	1	2026-01-16 12:05:23.747955	funding_end_date	\N	2026-11-30
915	24	1	2026-01-16 12:05:23.748323	candidate_status	\N	Переведен
916	24	1	2026-01-16 12:05:23.748689	target_projects	\N	ML Pipeline, Data Platform
917	24	1	2026-01-16 12:05:23.749059	transfer_date	\N	2026-03-01
918	24	1	2026-01-16 12:05:23.749534	recruiter	\N	Новикова Е.П.
919	24	1	2026-01-16 12:05:23.749926	hr_bp	\N	Морозов К.А.
920	24	1	2026-01-16 12:05:23.750554	comments	\N	
921	48	1	2026-01-16 12:05:23.780691	entry_date	\N	2025-02-15
922	48	1	2026-01-16 12:05:23.781329	current_manager	\N	Сидорова Е.К.
923	48	1	2026-01-16 12:05:23.782049	it_block	\N	B2O
924	48	1	2026-01-16 12:05:23.78274	ck_department	\N	ЦК Разработки
925	48	1	2026-01-16 12:05:23.783282	placement_type	\N	любой
926	48	1	2026-01-16 12:05:23.783946	ready_for_vacancy	\N	Да
927	48	1	2026-01-16 12:05:23.784895	resume_link	\N	https://drive.google.com/file/46972
928	48	1	2026-01-16 12:05:23.78593	manager_feedback	\N	Хороший специалист
929	48	1	2026-01-16 12:05:23.786693	contacts	\N	+7 (941) 764-79-30, @попартё25, arthur.borisov32@company.ru
930	48	1	2026-01-16 12:05:23.787359	funding_end_date	\N	2025-10-29
931	48	1	2026-01-16 12:05:23.78807	candidate_status	\N	В работе
932	48	1	2026-01-16 12:05:23.788912	target_projects	\N	DevOps Platform, Data Platform, Infrastructure
933	48	1	2026-01-16 12:05:23.789825	transfer_date	\N	
934	48	1	2026-01-16 12:05:23.790386	recruiter	\N	Орлов М.С.
935	48	1	2026-01-16 12:05:23.790811	hr_bp	\N	Морозов К.А.
936	48	1	2026-01-16 12:05:23.791206	comments	\N	Ожидает оффер
937	50	1	2026-01-16 12:05:23.827155	entry_date	\N	2025-05-19
938	50	1	2026-01-16 12:05:23.828427	current_manager	\N	Козлов Д.В.
939	50	1	2026-01-16 12:05:23.82958	it_block	\N	Прочее
940	50	1	2026-01-16 12:05:23.830398	ck_department	\N	Департамент данных
941	50	1	2026-01-16 12:05:23.831213	placement_type	\N	аутстафф
942	50	1	2026-01-16 12:05:23.831938	ready_for_vacancy	\N	Да
943	50	1	2026-01-16 12:05:23.832644	resume_link	\N	https://drive.google.com/file/43013
944	50	1	2026-01-16 12:05:23.833148	manager_feedback	\N	Хороший специалист
945	50	1	2026-01-16 12:05:23.834127	contacts	\N	+7 (958) 370-32-29, @петалек10, andrey.kuznetsov34@company.ru
946	50	1	2026-01-16 12:05:23.834877	funding_end_date	\N	2026-09-30
947	50	1	2026-01-16 12:05:23.835596	candidate_status	\N	Увольнение по СС
948	50	1	2026-01-16 12:05:23.836648	target_projects	\N	Mobile App, Госуслуги 2.0, E-commerce Platform
949	50	1	2026-01-16 12:05:23.837475	transfer_date	\N	2025-12-05
950	50	1	2026-01-16 12:05:23.838198	recruiter	\N	Орлов М.С.
951	50	1	2026-01-16 12:05:23.838958	hr_bp	\N	Волкова Н.В.
952	50	1	2026-01-16 12:05:23.840005	comments	\N	Срочно нужен проект
953	85	1	2026-01-16 12:05:23.872352	entry_date	\N	2024-01-18
954	85	1	2026-01-16 12:05:23.873048	current_manager	\N	Иванов А.П.
955	85	1	2026-01-16 12:05:23.873835	it_block	\N	Прочее
956	85	1	2026-01-16 12:05:23.874622	ck_department	\N	Департамент цифровых продуктов
957	85	1	2026-01-16 12:05:23.87541	placement_type	\N	перевод
958	85	1	2026-01-16 12:05:23.87626	ready_for_vacancy	\N	Нет
959	85	1	2026-01-16 12:05:23.877113	resume_link	\N	https://drive.google.com/file/21642
960	85	1	2026-01-16 12:05:23.878018	manager_feedback	\N	Рекомендую
961	85	1	2026-01-16 12:05:23.878578	contacts	\N	+7 (933) 348-94-68, @морники64, julia.grigoriev69@company.ru
962	85	1	2026-01-16 12:05:23.879015	funding_end_date	\N	2025-08-28
963	85	1	2026-01-16 12:05:23.87942	candidate_status	\N	Переведен
964	85	1	2026-01-16 12:05:23.879836	target_projects	\N	Госуслуги 2.0, Infrastructure
965	85	1	2026-01-16 12:05:23.880246	transfer_date	\N	2025-04-27
966	85	1	2026-01-16 12:05:23.88064	recruiter	\N	Новикова Е.П.
967	85	1	2026-01-16 12:05:23.881037	hr_bp	\N	Волкова Н.В.
968	85	1	2026-01-16 12:05:23.881508	comments	\N	
969	49	1	2026-01-16 12:05:23.923002	entry_date	\N	2024-02-24
970	49	1	2026-01-16 12:05:23.924062	current_manager	\N	Иванов А.П.
971	49	1	2026-01-16 12:05:23.924926	it_block	\N	Развитие
972	49	1	2026-01-16 12:05:23.925752	ck_department	\N	ЦК Инфраструктуры
973	49	1	2026-01-16 12:05:23.926851	placement_type	\N	любой
974	49	1	2026-01-16 12:05:23.927794	ready_for_vacancy	\N	Да
975	49	1	2026-01-16 12:05:23.928569	resume_link	\N	https://drive.google.com/file/95253
976	49	1	2026-01-16 12:05:23.929374	manager_feedback	\N	Отличные результаты
977	49	1	2026-01-16 12:05:23.930206	contacts	\N	+7 (976) 980-46-22, @васиван66, anna.novikov33@company.ru
978	49	1	2026-01-16 12:05:23.931252	funding_end_date	\N	2026-04-24
979	49	1	2026-01-16 12:05:23.932417	candidate_status	\N	Свободен
980	49	1	2026-01-16 12:05:23.933339	target_projects	\N	Data Platform, Banking App
981	49	1	2026-01-16 12:05:23.934114	transfer_date	\N	
982	49	1	2026-01-16 12:05:23.934796	recruiter	\N	Новикова Е.П.
983	49	1	2026-01-16 12:05:23.935278	hr_bp	\N	Лебедева Т.М.
984	49	1	2026-01-16 12:05:23.936255	comments	\N	Срочно нужен проект
985	55	1	2026-01-16 12:05:23.967096	entry_date	\N	2024-04-24
986	55	1	2026-01-16 12:05:23.968209	current_manager	\N	Козлов Д.В.
987	55	1	2026-01-16 12:05:23.968885	it_block	\N	Эксплуатация
988	55	1	2026-01-16 12:05:23.969671	ck_department	\N	Департамент цифровых продуктов
989	55	1	2026-01-16 12:05:23.970255	placement_type	\N	перевод
990	55	1	2026-01-16 12:05:23.970878	ready_for_vacancy	\N	Да
991	55	1	2026-01-16 12:05:23.971346	resume_link	\N	https://drive.google.com/file/29064
992	55	1	2026-01-16 12:05:23.971945	manager_feedback	\N	Хороший специалист
993	55	1	2026-01-16 12:05:23.972544	contacts	\N	+7 (942) 218-16-62, @морники83, igor.sokolov39@company.ru
994	55	1	2026-01-16 12:05:23.973366	funding_end_date	\N	2026-12-02
995	55	1	2026-01-16 12:05:23.973859	candidate_status	\N	Переведен
996	55	1	2026-01-16 12:05:23.974628	target_projects	\N	Infrastructure, E-commerce Platform
997	55	1	2026-01-16 12:05:23.97507	transfer_date	\N	2025-01-08
998	55	1	2026-01-16 12:05:23.975476	recruiter	\N	Смирнова А.А.
999	55	1	2026-01-16 12:05:23.975858	hr_bp	\N	Волкова Н.В.
1000	55	1	2026-01-16 12:05:23.976237	comments	\N	
1001	46	1	2026-01-16 12:05:24.002469	entry_date	\N	2024-09-14
1002	46	1	2026-01-16 12:05:24.003333	current_manager	\N	Козлов Д.В.
1003	46	1	2026-01-16 12:05:24.00403	it_block	\N	Эксплуатация
1004	46	1	2026-01-16 12:05:24.004483	ck_department	\N	ЦК Аналитики
1005	46	1	2026-01-16 12:05:24.005095	placement_type	\N	аутстафф
1006	46	1	2026-01-16 12:05:24.005696	ready_for_vacancy	\N	Да
1007	46	1	2026-01-16 12:05:24.006178	resume_link	\N	https://drive.google.com/file/18670
1008	46	1	2026-01-16 12:05:24.006611	manager_feedback	\N	Отличные результаты
1009	46	1	2026-01-16 12:05:24.007084	contacts	\N	+7 (979) 798-42-14, @смиилья68, oleg.morozov30@company.ru
1010	46	1	2026-01-16 12:05:24.007667	funding_end_date	\N	2026-07-17
1011	46	1	2026-01-16 12:05:24.008158	candidate_status	\N	Свободен
1012	46	1	2026-01-16 12:05:24.008604	target_projects	\N	E-commerce Platform
1013	46	1	2026-01-16 12:05:24.009008	transfer_date	\N	
1014	46	1	2026-01-16 12:05:24.009556	recruiter	\N	Новикова Е.П.
1015	46	1	2026-01-16 12:05:24.010114	hr_bp	\N	Волкова Н.В.
1016	46	1	2026-01-16 12:05:24.010741	comments	\N	
1017	266	1	2026-01-16 12:05:24.047563	entry_date	\N	2024-04-10
1018	266	1	2026-01-16 12:05:24.048187	current_manager	\N	Михайлова О.Н.
1019	266	1	2026-01-16 12:05:24.04866	it_block	\N	Развитие
1020	266	1	2026-01-16 12:05:24.049088	ck_department	\N	ЦК Разработки
1021	266	1	2026-01-16 12:05:24.04964	placement_type	\N	любой
1022	266	1	2026-01-16 12:05:24.050179	ready_for_vacancy	\N	Нет
1023	266	1	2026-01-16 12:05:24.050604	resume_link	\N	https://drive.google.com/file/65811
1024	266	1	2026-01-16 12:05:24.051013	manager_feedback	\N	Хороший специалист
1025	266	1	2026-01-16 12:05:24.051423	contacts	\N	+7 (900) 137-37-29, @кисвлад38, v.kiselev@rt.ru
1026	266	1	2026-01-16 12:05:24.051979	funding_end_date	\N	2026-10-10
1027	266	1	2026-01-16 12:05:24.052409	candidate_status	\N	Забронирован
1028	266	1	2026-01-16 12:05:24.053007	target_projects	\N	Infrastructure, Госуслуги 2.0, E-commerce Platform
1029	266	1	2026-01-16 12:05:24.053513	transfer_date	\N	
1030	266	1	2026-01-16 12:05:24.053956	recruiter	\N	Орлов М.С.
1031	266	1	2026-01-16 12:05:24.054378	hr_bp	\N	Лебедева Т.М.
1032	266	1	2026-01-16 12:05:24.054784	comments	\N	В процессе согласования
1033	267	1	2026-01-16 12:05:24.093685	entry_date	\N	2025-07-01
1034	267	1	2026-01-16 12:05:24.094872	current_manager	\N	Михайлова О.Н.
1035	267	1	2026-01-16 12:05:24.095898	it_block	\N	Эксплуатация
1036	267	1	2026-01-16 12:05:24.09689	ck_department	\N	Департамент цифровых продуктов
1037	267	1	2026-01-16 12:05:24.097976	placement_type	\N	любой
1038	267	1	2026-01-16 12:05:24.098759	ready_for_vacancy	\N	Нет
1039	267	1	2026-01-16 12:05:24.099482	resume_link	\N	https://drive.google.com/file/47970
1040	267	1	2026-01-16 12:05:24.100263	manager_feedback	\N	Нужно развитие
1041	267	1	2026-01-16 12:05:24.101303	contacts	\N	+7 (914) 663-50-55, @сокарсе88, a.sokolov@rt.ru
1042	267	1	2026-01-16 12:05:24.102304	funding_end_date	\N	2025-11-22
1043	267	1	2026-01-16 12:05:24.103118	candidate_status	\N	Переведен
1044	267	1	2026-01-16 12:05:24.104094	target_projects	\N	Data Platform
1045	267	1	2026-01-16 12:05:24.105221	transfer_date	\N	2026-02-28
1046	267	1	2026-01-16 12:05:24.106055	recruiter	\N	Новикова Е.П.
1047	267	1	2026-01-16 12:05:24.106992	hr_bp	\N	Морозов К.А.
1048	267	1	2026-01-16 12:05:24.107981	comments	\N	
1049	268	1	2026-01-16 12:05:24.140204	entry_date	\N	2024-03-29
1050	268	1	2026-01-16 12:05:24.141101	current_manager	\N	Михайлова О.Н.
1051	268	1	2026-01-16 12:05:24.141903	it_block	\N	Диджитал
1052	268	1	2026-01-16 12:05:24.142614	ck_department	\N	ЦК Инфраструктуры
1053	268	1	2026-01-16 12:05:24.143307	placement_type	\N	перевод
1054	268	1	2026-01-16 12:05:24.143975	ready_for_vacancy	\N	Да
1055	268	1	2026-01-16 12:05:24.14464	resume_link	\N	https://drive.google.com/file/66196
1056	268	1	2026-01-16 12:05:24.145208	manager_feedback	\N	Рекомендую
1057	268	1	2026-01-16 12:05:24.146046	contacts	\N	+7 (962) 609-82-32, @лебнаде53, n.lebedeva@rt.ru
1058	268	1	2026-01-16 12:05:24.146987	funding_end_date	\N	2025-05-26
1059	268	1	2026-01-16 12:05:24.147698	candidate_status	\N	В работе
1060	268	1	2026-01-16 12:05:24.148467	target_projects	\N	DevOps Platform
1061	268	1	2026-01-16 12:05:24.149386	transfer_date	\N	
1062	268	1	2026-01-16 12:05:24.150197	recruiter	\N	Белова И.Д.
1063	268	1	2026-01-16 12:05:24.151037	hr_bp	\N	Морозов К.А.
1064	268	1	2026-01-16 12:05:24.151804	comments	\N	
1065	269	1	2026-01-16 12:05:24.184617	entry_date	\N	2025-01-05
1066	269	1	2026-01-16 12:05:24.185787	current_manager	\N	Козлов Д.В.
1067	269	1	2026-01-16 12:05:24.186912	it_block	\N	Прочее
1068	269	1	2026-01-16 12:05:24.18773	ck_department	\N	Департамент данных
1069	269	1	2026-01-16 12:05:24.188518	placement_type	\N	перевод
1070	269	1	2026-01-16 12:05:24.189191	ready_for_vacancy	\N	Нет
1071	269	1	2026-01-16 12:05:24.189966	resume_link	\N	https://drive.google.com/file/59461
1072	269	1	2026-01-16 12:05:24.190618	manager_feedback	\N	
1073	269	1	2026-01-16 12:05:24.191278	contacts	\N	+7 (996) 382-32-11, @петкрис20, k.petrova@rt.ru
1074	269	1	2026-01-16 12:05:24.191944	funding_end_date	\N	2026-05-24
1075	269	1	2026-01-16 12:05:24.192606	candidate_status	\N	Переведен
1076	269	1	2026-01-16 12:05:24.193294	target_projects	\N	Mobile App
1077	269	1	2026-01-16 12:05:24.19378	transfer_date	\N	2026-06-09
1078	269	1	2026-01-16 12:05:24.194491	recruiter	\N	Смирнова А.А.
1079	269	1	2026-01-16 12:05:24.195448	hr_bp	\N	Морозов К.А.
1080	269	1	2026-01-16 12:05:24.196213	comments	\N	
1081	270	1	2026-01-16 12:05:24.225444	entry_date	\N	2024-11-22
1082	270	1	2026-01-16 12:05:24.226012	current_manager	\N	Иванов А.П.
1083	270	1	2026-01-16 12:05:24.226444	it_block	\N	Эксплуатация
1084	270	1	2026-01-16 12:05:24.226833	ck_department	\N	ЦК Аналитики
1085	270	1	2026-01-16 12:05:24.227209	placement_type	\N	перевод
1086	270	1	2026-01-16 12:05:24.227605	ready_for_vacancy	\N	Да
1087	270	1	2026-01-16 12:05:24.228107	resume_link	\N	https://drive.google.com/file/27320
1088	270	1	2026-01-16 12:05:24.228859	manager_feedback	\N	
1089	270	1	2026-01-16 12:05:24.229501	contacts	\N	+7 (971) 683-68-53, @грикрис81, k.grigoreva@rt.ru
1090	270	1	2026-01-16 12:05:24.230319	funding_end_date	\N	2025-12-13
1091	270	1	2026-01-16 12:05:24.231285	candidate_status	\N	Переведен
1092	270	1	2026-01-16 12:05:24.232218	target_projects	\N	Infrastructure
1093	270	1	2026-01-16 12:05:24.233035	transfer_date	\N	2025-10-12
1094	270	1	2026-01-16 12:05:24.233924	recruiter	\N	Смирнова А.А.
1095	270	1	2026-01-16 12:05:24.234677	hr_bp	\N	Морозов К.А.
1096	270	1	2026-01-16 12:05:24.235251	comments	\N	В процессе согласования
1097	271	1	2026-01-16 12:05:24.263319	entry_date	\N	2025-10-24
1098	271	1	2026-01-16 12:05:24.264195	current_manager	\N	Козлов Д.В.
1099	271	1	2026-01-16 12:05:24.264929	it_block	\N	Эксплуатация
1100	271	1	2026-01-16 12:05:24.265683	ck_department	\N	ЦК Аналитики
1101	271	1	2026-01-16 12:05:24.26617	placement_type	\N	любой
1102	271	1	2026-01-16 12:05:24.266586	ready_for_vacancy	\N	Нет
1103	271	1	2026-01-16 12:05:24.266981	resume_link	\N	https://drive.google.com/file/71490
1104	271	1	2026-01-16 12:05:24.267812	manager_feedback	\N	Отличные результаты
1105	271	1	2026-01-16 12:05:24.268406	contacts	\N	+7 (967) 374-22-72, @ворвале50, v.vorobeva@rt.ru
1106	271	1	2026-01-16 12:05:24.268848	funding_end_date	\N	2025-12-18
1107	271	1	2026-01-16 12:05:24.269321	candidate_status	\N	В работе
1108	271	1	2026-01-16 12:05:24.269815	target_projects	\N	Mobile App
1109	271	1	2026-01-16 12:05:24.2702	transfer_date	\N	
1110	271	1	2026-01-16 12:05:24.270576	recruiter	\N	Новикова Е.П.
1111	271	1	2026-01-16 12:05:24.270939	hr_bp	\N	Волкова Н.В.
1112	271	1	2026-01-16 12:05:24.2713	comments	\N	
1113	272	1	2026-01-16 12:05:24.307414	entry_date	\N	2025-05-07
1114	272	1	2026-01-16 12:05:24.308398	current_manager	\N	Сидорова Е.К.
1115	272	1	2026-01-16 12:05:24.309144	it_block	\N	Эксплуатация
1116	272	1	2026-01-16 12:05:24.309883	ck_department	\N	Департамент данных
1117	272	1	2026-01-16 12:05:24.310521	placement_type	\N	любой
1118	272	1	2026-01-16 12:05:24.311156	ready_for_vacancy	\N	Да
1119	272	1	2026-01-16 12:05:24.312118	resume_link	\N	https://drive.google.com/file/84312
1120	272	1	2026-01-16 12:05:24.313311	manager_feedback	\N	
1121	272	1	2026-01-16 12:05:24.314457	contacts	\N	+7 (933) 173-53-38, @солмакс36, m.solovev@rt.ru
1122	272	1	2026-01-16 12:05:24.315318	funding_end_date	\N	2025-12-09
1123	272	1	2026-01-16 12:05:24.316029	candidate_status	\N	Забронирован
1124	272	1	2026-01-16 12:05:24.316687	target_projects	\N	Data Platform, ML Pipeline, Mobile App
1125	272	1	2026-01-16 12:05:24.317417	transfer_date	\N	
1126	272	1	2026-01-16 12:05:24.318247	recruiter	\N	Смирнова А.А.
1127	272	1	2026-01-16 12:05:24.318843	hr_bp	\N	Лебедева Т.М.
1128	272	1	2026-01-16 12:05:24.319638	comments	\N	Срочно нужен проект
1129	273	1	2026-01-16 12:05:24.361076	entry_date	\N	2024-08-28
1130	273	1	2026-01-16 12:05:24.362018	current_manager	\N	Иванов А.П.
1131	273	1	2026-01-16 12:05:24.362928	it_block	\N	Развитие
1132	273	1	2026-01-16 12:05:24.363647	ck_department	\N	ЦК Разработки
1133	273	1	2026-01-16 12:05:24.364311	placement_type	\N	аутстафф
1134	273	1	2026-01-16 12:05:24.364847	ready_for_vacancy	\N	Нет
1135	273	1	2026-01-16 12:05:24.365664	resume_link	\N	https://drive.google.com/file/38400
1136	273	1	2026-01-16 12:05:24.366229	manager_feedback	\N	Отличные результаты
1137	273	1	2026-01-16 12:05:24.366641	contacts	\N	+7 (926) 372-52-79, @кисилья81, i.kiselev@rt.ru
1138	273	1	2026-01-16 12:05:24.367026	funding_end_date	\N	2025-04-26
1139	273	1	2026-01-16 12:05:24.367866	candidate_status	\N	В работе
1140	273	1	2026-01-16 12:05:24.368492	target_projects	\N	Data Platform, DevOps Platform, ML Pipeline
1141	273	1	2026-01-16 12:05:24.369207	transfer_date	\N	
1142	273	1	2026-01-16 12:05:24.369773	recruiter	\N	Орлов М.С.
1143	273	1	2026-01-16 12:05:24.370169	hr_bp	\N	Лебедева Т.М.
1144	273	1	2026-01-16 12:05:24.370542	comments	\N	
1145	274	1	2026-01-16 12:05:24.401217	entry_date	\N	2025-09-15
1146	274	1	2026-01-16 12:05:24.402158	current_manager	\N	Михайлова О.Н.
1147	274	1	2026-01-16 12:05:24.402836	it_block	\N	Эксплуатация
1148	274	1	2026-01-16 12:05:24.403579	ck_department	\N	Департамент цифровых продуктов
1149	274	1	2026-01-16 12:05:24.404364	placement_type	\N	любой
1150	274	1	2026-01-16 12:05:24.40506	ready_for_vacancy	\N	Да
1151	274	1	2026-01-16 12:05:24.405651	resume_link	\N	https://drive.google.com/file/20851
1152	274	1	2026-01-16 12:05:24.406348	manager_feedback	\N	Рекомендую
1153	274	1	2026-01-16 12:05:24.407147	contacts	\N	+7 (907) 437-76-60, @захарсе61, a.zakharov@rt.ru
1154	274	1	2026-01-16 12:05:24.407591	funding_end_date	\N	2026-05-05
1155	274	1	2026-01-16 12:05:24.407979	candidate_status	\N	Увольнение по СЖ
1156	274	1	2026-01-16 12:05:24.40844	target_projects	\N	Banking App, Госуслуги 2.0, ML Pipeline
1157	274	1	2026-01-16 12:05:24.408858	transfer_date	\N	2026-10-13
1158	274	1	2026-01-16 12:05:24.409311	recruiter	\N	Орлов М.С.
1159	274	1	2026-01-16 12:05:24.409723	hr_bp	\N	Морозов К.А.
1160	274	1	2026-01-16 12:05:24.410103	comments	\N	
1161	275	1	2026-01-16 12:05:24.439529	entry_date	\N	2025-02-28
1162	275	1	2026-01-16 12:05:24.440272	current_manager	\N	Иванов А.П.
1163	275	1	2026-01-16 12:05:24.440838	it_block	\N	Прочее
1164	275	1	2026-01-16 12:05:24.441505	ck_department	\N	ЦК Инфраструктуры
1165	275	1	2026-01-16 12:05:24.442078	placement_type	\N	любой
1166	275	1	2026-01-16 12:05:24.442649	ready_for_vacancy	\N	Да
1167	275	1	2026-01-16 12:05:24.443389	resume_link	\N	https://drive.google.com/file/61797
1168	275	1	2026-01-16 12:05:24.443946	manager_feedback	\N	Рекомендую
1169	275	1	2026-01-16 12:05:24.444936	contacts	\N	+7 (946) 595-41-50, @дмимиха86, m.dmitriev@rt.ru
1170	275	1	2026-01-16 12:05:24.445974	funding_end_date	\N	2025-08-24
1171	275	1	2026-01-16 12:05:24.446819	candidate_status	\N	Увольнение по СС
1172	275	1	2026-01-16 12:05:24.447396	target_projects	\N	Mobile App
1173	275	1	2026-01-16 12:05:24.448064	transfer_date	\N	2025-08-22
1174	275	1	2026-01-16 12:05:24.448685	recruiter	\N	Новикова Е.П.
1175	275	1	2026-01-16 12:05:24.449571	hr_bp	\N	Волкова Н.В.
1176	275	1	2026-01-16 12:05:24.450257	comments	\N	В процессе согласования
1177	15	1	2026-01-16 12:05:24.479567	entry_date	\N	2025-03-27
1178	15	1	2026-01-16 12:05:24.48075	current_manager	\N	Петров С.М.
1179	15	1	2026-01-16 12:05:24.481466	it_block	\N	Прочее
1180	15	1	2026-01-16 12:05:24.482094	ck_department	\N	Департамент цифровых продуктов
1181	15	1	2026-01-16 12:05:24.482862	placement_type	\N	любой
1182	15	1	2026-01-16 12:05:24.483556	ready_for_vacancy	\N	Да
1183	15	1	2026-01-16 12:05:24.484328	resume_link	\N	https://drive.google.com/file/54234
1184	15	1	2026-01-16 12:05:24.484992	manager_feedback	\N	Отличные результаты
1185	15	1	2026-01-16 12:05:24.485999	contacts	\N	+7 (906) 510-51-38, @лебната80, lebedeva@company.ru
1186	15	1	2026-01-16 12:05:24.48674	funding_end_date	\N	2025-09-30
1187	15	1	2026-01-16 12:05:24.487493	candidate_status	\N	Переведен
1188	15	1	2026-01-16 12:05:24.488418	target_projects	\N	E-commerce Platform, DevOps Platform, Mobile App
1189	15	1	2026-01-16 12:05:24.489138	transfer_date	\N	2025-07-28
1190	15	1	2026-01-16 12:05:24.489911	recruiter	\N	Белова И.Д.
1191	15	1	2026-01-16 12:05:24.49057	hr_bp	\N	Волкова Н.В.
1192	15	1	2026-01-16 12:05:24.491256	comments	\N	Ожидает оффер
1193	71	1	2026-01-16 12:05:24.519781	entry_date	\N	2025-09-10
1194	71	1	2026-01-16 12:05:24.521153	current_manager	\N	Михайлова О.Н.
1195	71	1	2026-01-16 12:05:24.522258	it_block	\N	Развитие
1196	71	1	2026-01-16 12:05:24.523405	ck_department	\N	ЦК Аналитики
1197	71	1	2026-01-16 12:05:24.524265	placement_type	\N	перевод
1198	71	1	2026-01-16 12:05:24.524863	ready_for_vacancy	\N	Нет
1199	71	1	2026-01-16 12:05:24.525707	resume_link	\N	https://drive.google.com/file/83058
1200	71	1	2026-01-16 12:05:24.526413	manager_feedback	\N	
1201	71	1	2026-01-16 12:05:24.52692	contacts	\N	+7 (900) 520-66-22, @волмакс29, nikita.solovyov55@company.ru
1202	71	1	2026-01-16 12:05:24.527337	funding_end_date	\N	2025-05-16
1203	71	1	2026-01-16 12:05:24.527748	candidate_status	\N	Увольнение по СС
1204	71	1	2026-01-16 12:05:24.52854	target_projects	\N	Госуслуги 2.0, Banking App, Data Platform
1205	71	1	2026-01-16 12:05:24.529455	transfer_date	\N	2026-08-01
1206	71	1	2026-01-16 12:05:24.530181	recruiter	\N	Белова И.Д.
1207	71	1	2026-01-16 12:05:24.530862	hr_bp	\N	Морозов К.А.
1208	71	1	2026-01-16 12:05:24.531597	comments	\N	В процессе согласования
1209	69	1	2026-01-16 12:05:24.55783	entry_date	\N	2024-05-06
1210	69	1	2026-01-16 12:05:24.558491	current_manager	\N	Петров С.М.
1211	69	1	2026-01-16 12:05:24.559104	it_block	\N	Прочее
1212	69	1	2026-01-16 12:05:24.55951	ck_department	\N	Департамент данных
1213	69	1	2026-01-16 12:05:24.559887	placement_type	\N	перевод
1214	69	1	2026-01-16 12:05:24.560256	ready_for_vacancy	\N	Да
1215	69	1	2026-01-16 12:05:24.560628	resume_link	\N	https://drive.google.com/file/64974
1216	69	1	2026-01-16 12:05:24.560994	manager_feedback	\N	Рекомендую
1217	69	1	2026-01-16 12:05:24.56143	contacts	\N	+7 (901) 926-88-14, @фёдсерг44, dmitry.alexandrov53@company.ru
1218	69	1	2026-01-16 12:05:24.561806	funding_end_date	\N	2025-11-11
1219	69	1	2026-01-16 12:05:24.562172	candidate_status	\N	В работе
1220	69	1	2026-01-16 12:05:24.56253	target_projects	\N	Infrastructure, Banking App
1221	69	1	2026-01-16 12:05:24.562902	transfer_date	\N	
1222	69	1	2026-01-16 12:05:24.563261	recruiter	\N	Новикова Е.П.
1223	69	1	2026-01-16 12:05:24.563619	hr_bp	\N	Лебедева Т.М.
1224	69	1	2026-01-16 12:05:24.563974	comments	\N	Срочно нужен проект
1225	74	1	2026-01-16 12:05:24.590548	entry_date	\N	2024-01-06
1226	74	1	2026-01-16 12:05:24.591337	current_manager	\N	Сидорова Е.К.
1227	74	1	2026-01-16 12:05:24.592153	it_block	\N	B2O
1228	74	1	2026-01-16 12:05:24.592883	ck_department	\N	ЦК Аналитики
1229	74	1	2026-01-16 12:05:24.593715	placement_type	\N	перевод
1230	74	1	2026-01-16 12:05:24.594281	ready_for_vacancy	\N	Да
1231	74	1	2026-01-16 12:05:24.594745	resume_link	\N	https://drive.google.com/file/91668
1232	74	1	2026-01-16 12:05:24.595246	manager_feedback	\N	Рекомендую
1233	74	1	2026-01-16 12:05:24.595718	contacts	\N	+7 (951) 803-63-93, @семкири78, anton.alexeev58@company.ru
1234	74	1	2026-01-16 12:05:24.596259	funding_end_date	\N	2025-09-22
1235	74	1	2026-01-16 12:05:24.597874	candidate_status	\N	Свободен
1236	74	1	2026-01-16 12:05:24.599015	target_projects	\N	Infrastructure
1237	74	1	2026-01-16 12:05:24.599728	transfer_date	\N	
1238	74	1	2026-01-16 12:05:24.600226	recruiter	\N	Новикова Е.П.
1239	74	1	2026-01-16 12:05:24.600962	hr_bp	\N	Волкова Н.В.
1240	74	1	2026-01-16 12:05:24.601728	comments	\N	
1241	89	1	2026-01-16 12:05:24.624245	entry_date	\N	2024-01-16
1242	89	1	2026-01-16 12:05:24.62507	current_manager	\N	Михайлова О.Н.
1243	89	1	2026-01-16 12:05:24.625786	it_block	\N	Прочее
1244	89	1	2026-01-16 12:05:24.626562	ck_department	\N	ЦК Инфраструктуры
1245	89	1	2026-01-16 12:05:24.627402	placement_type	\N	аутстафф
1246	89	1	2026-01-16 12:05:24.628481	ready_for_vacancy	\N	Да
1247	89	1	2026-01-16 12:05:24.629214	resume_link	\N	https://drive.google.com/file/35105
1248	89	1	2026-01-16 12:05:24.630244	manager_feedback	\N	Рекомендую
1249	89	1	2026-01-16 12:05:24.631204	contacts	\N	+7 (984) 466-82-75, @семкири23, vladislav.popov73@company.ru
1250	89	1	2026-01-16 12:05:24.631979	funding_end_date	\N	2025-02-02
1251	89	1	2026-01-16 12:05:24.632526	candidate_status	\N	Забронирован
1252	89	1	2026-01-16 12:05:24.633042	target_projects	\N	ML Pipeline
1253	89	1	2026-01-16 12:05:24.634675	transfer_date	\N	
1254	89	1	2026-01-16 12:05:24.635552	recruiter	\N	Смирнова А.А.
1255	89	1	2026-01-16 12:05:24.636524	hr_bp	\N	Волкова Н.В.
1256	89	1	2026-01-16 12:05:24.637406	comments	\N	
1257	78	1	2026-01-16 12:05:24.668838	entry_date	\N	2024-10-30
1258	78	1	2026-01-16 12:05:24.669715	current_manager	\N	Иванов А.П.
1259	78	1	2026-01-16 12:05:24.670439	it_block	\N	Развитие
1260	78	1	2026-01-16 12:05:24.671167	ck_department	\N	ЦК Аналитики
1261	78	1	2026-01-16 12:05:24.671862	placement_type	\N	перевод
1262	78	1	2026-01-16 12:05:24.672777	ready_for_vacancy	\N	Да
1263	78	1	2026-01-16 12:05:24.67364	resume_link	\N	https://drive.google.com/file/57383
1264	78	1	2026-01-16 12:05:24.674229	manager_feedback	\N	Рекомендую
1265	78	1	2026-01-16 12:05:24.674705	contacts	\N	+7 (950) 519-82-26, @попартё77, vladislav.fedorov62@company.ru
1266	78	1	2026-01-16 12:05:24.675312	funding_end_date	\N	2025-01-08
1267	78	1	2026-01-16 12:05:24.676031	candidate_status	\N	Забронирован
1268	78	1	2026-01-16 12:05:24.676711	target_projects	\N	ML Pipeline
1269	78	1	2026-01-16 12:05:24.677775	transfer_date	\N	
1270	78	1	2026-01-16 12:05:24.678327	recruiter	\N	Смирнова А.А.
1271	78	1	2026-01-16 12:05:24.679042	hr_bp	\N	Волкова Н.В.
1272	78	1	2026-01-16 12:05:24.67964	comments	\N	
1273	88	1	2026-01-16 12:05:24.706354	entry_date	\N	2024-06-02
1274	88	1	2026-01-16 12:05:24.706985	current_manager	\N	Михайлова О.Н.
1275	88	1	2026-01-16 12:05:24.707433	it_block	\N	Развитие
1276	88	1	2026-01-16 12:05:24.707974	ck_department	\N	ЦК Разработки
1277	88	1	2026-01-16 12:05:24.708387	placement_type	\N	перевод
1278	88	1	2026-01-16 12:05:24.708822	ready_for_vacancy	\N	Нет
1279	88	1	2026-01-16 12:05:24.709308	resume_link	\N	https://drive.google.com/file/92544
1280	88	1	2026-01-16 12:05:24.709887	manager_feedback	\N	
1281	88	1	2026-01-16 12:05:24.710342	contacts	\N	+7 (916) 235-66-13, @лебдмит48, vladimir.lebedev72@company.ru
1282	88	1	2026-01-16 12:05:24.710733	funding_end_date	\N	2026-12-15
1283	88	1	2026-01-16 12:05:24.711111	candidate_status	\N	Увольнение по СС
1284	88	1	2026-01-16 12:05:24.711476	target_projects	\N	Infrastructure
1285	88	1	2026-01-16 12:05:24.711838	transfer_date	\N	2026-05-30
1286	88	1	2026-01-16 12:05:24.712289	recruiter	\N	Новикова Е.П.
1287	88	1	2026-01-16 12:05:24.712853	hr_bp	\N	Лебедева Т.М.
1288	88	1	2026-01-16 12:05:24.713451	comments	\N	
1289	77	1	2026-01-16 12:05:24.739869	entry_date	\N	2025-01-08
1290	77	1	2026-01-16 12:05:24.740491	current_manager	\N	Петров С.М.
1291	77	1	2026-01-16 12:05:24.741186	it_block	\N	Развитие
1292	77	1	2026-01-16 12:05:24.741912	ck_department	\N	ЦК Аналитики
1293	77	1	2026-01-16 12:05:24.742395	placement_type	\N	перевод
1294	77	1	2026-01-16 12:05:24.74283	ready_for_vacancy	\N	Нет
1295	77	1	2026-01-16 12:05:24.743336	resume_link	\N	https://drive.google.com/file/91309
1296	77	1	2026-01-16 12:05:24.743837	manager_feedback	\N	
1297	77	1	2026-01-16 12:05:24.744314	contacts	\N	+7 (921) 812-73-86, @куздени61, maxim.alexeev61@company.ru
1298	77	1	2026-01-16 12:05:24.744881	funding_end_date	\N	2026-02-10
1299	77	1	2026-01-16 12:05:24.745404	candidate_status	\N	Свободен
1300	77	1	2026-01-16 12:05:24.745984	target_projects	\N	Data Platform, Mobile App, Госуслуги 2.0
1301	77	1	2026-01-16 12:05:24.746475	transfer_date	\N	
1302	77	1	2026-01-16 12:05:24.746874	recruiter	\N	Новикова Е.П.
1303	77	1	2026-01-16 12:05:24.747396	hr_bp	\N	Морозов К.А.
1304	77	1	2026-01-16 12:05:24.747939	comments	\N	
1305	84	1	2026-01-16 12:05:24.770314	entry_date	\N	2025-07-17
1306	84	1	2026-01-16 12:05:24.77133	current_manager	\N	Козлов Д.В.
1307	84	1	2026-01-16 12:05:24.772171	it_block	\N	Прочее
1308	84	1	2026-01-16 12:05:24.772881	ck_department	\N	Департамент цифровых продуктов
1309	84	1	2026-01-16 12:05:24.773524	placement_type	\N	перевод
1310	84	1	2026-01-16 12:05:24.774233	ready_for_vacancy	\N	Да
1311	84	1	2026-01-16 12:05:24.774931	resume_link	\N	https://drive.google.com/file/27436
1312	84	1	2026-01-16 12:05:24.775621	manager_feedback	\N	Рекомендую
1313	84	1	2026-01-16 12:05:24.776341	contacts	\N	+7 (963) 628-78-57, @фёдсерг22, tatiana.vorobyov68@company.ru
1314	84	1	2026-01-16 12:05:24.77716	funding_end_date	\N	2025-05-21
1315	84	1	2026-01-16 12:05:24.777874	candidate_status	\N	Увольнение по СС
1316	84	1	2026-01-16 12:05:24.77853	target_projects	\N	Госуслуги 2.0, Infrastructure
1317	84	1	2026-01-16 12:05:24.779192	transfer_date	\N	2026-07-10
1318	84	1	2026-01-16 12:05:24.779897	recruiter	\N	Новикова Е.П.
1319	84	1	2026-01-16 12:05:24.780549	hr_bp	\N	Волкова Н.В.
1320	84	1	2026-01-16 12:05:24.781221	comments	\N	
1321	72	1	2026-01-16 12:05:24.809546	entry_date	\N	2025-04-18
1322	72	1	2026-01-16 12:05:24.810426	current_manager	\N	Козлов Д.В.
1323	72	1	2026-01-16 12:05:24.811188	it_block	\N	Развитие
1324	72	1	2026-01-16 12:05:24.811882	ck_department	\N	Департамент цифровых продуктов
1325	72	1	2026-01-16 12:05:24.812587	placement_type	\N	перевод
1326	72	1	2026-01-16 12:05:24.813357	ready_for_vacancy	\N	Нет
1327	72	1	2026-01-16 12:05:24.814058	resume_link	\N	https://drive.google.com/file/93265
1328	72	1	2026-01-16 12:05:24.814611	manager_feedback	\N	Рекомендую
1329	72	1	2026-01-16 12:05:24.815162	contacts	\N	+7 (924) 800-60-74, @алемиха4, vladimir.korolev56@company.ru
1330	72	1	2026-01-16 12:05:24.815818	funding_end_date	\N	2026-04-23
1331	72	1	2026-01-16 12:05:24.816532	candidate_status	\N	Увольнение по СЖ
1332	72	1	2026-01-16 12:05:24.817279	target_projects	\N	Infrastructure
1333	72	1	2026-01-16 12:05:24.817982	transfer_date	\N	2026-09-27
1334	72	1	2026-01-16 12:05:24.818684	recruiter	\N	Смирнова А.А.
1335	72	1	2026-01-16 12:05:24.81938	hr_bp	\N	Морозов К.А.
1336	72	1	2026-01-16 12:05:24.820131	comments	\N	
1337	276	1	2026-01-16 12:05:24.8435	entry_date	\N	2025-01-30
1338	276	1	2026-01-16 12:05:24.844234	current_manager	\N	Петров С.М.
1339	276	1	2026-01-16 12:05:24.844688	it_block	\N	B2O
1340	276	1	2026-01-16 12:05:24.845069	ck_department	\N	Департамент данных
1341	276	1	2026-01-16 12:05:24.845497	placement_type	\N	любой
1342	276	1	2026-01-16 12:05:24.845873	ready_for_vacancy	\N	Да
1343	276	1	2026-01-16 12:05:24.846242	resume_link	\N	https://drive.google.com/file/27294
1344	276	1	2026-01-16 12:05:24.846599	manager_feedback	\N	Нужно развитие
1345	276	1	2026-01-16 12:05:24.846955	contacts	\N	+7 (908) 429-99-35, @никната53, n.nikolaeva@rt.ru
1346	276	1	2026-01-16 12:05:24.847314	funding_end_date	\N	2026-05-26
1347	276	1	2026-01-16 12:05:24.847694	candidate_status	\N	Свободен
1348	276	1	2026-01-16 12:05:24.848116	target_projects	\N	E-commerce Platform, Mobile App
1349	276	1	2026-01-16 12:05:24.848927	transfer_date	\N	
1350	276	1	2026-01-16 12:05:24.849433	recruiter	\N	Смирнова А.А.
1351	276	1	2026-01-16 12:05:24.849914	hr_bp	\N	Морозов К.А.
1352	276	1	2026-01-16 12:05:24.850362	comments	\N	
1353	277	1	2026-01-16 12:05:24.877811	entry_date	\N	2024-05-02
1354	277	1	2026-01-16 12:05:24.878435	current_manager	\N	Иванов А.П.
1355	277	1	2026-01-16 12:05:24.878866	it_block	\N	Диджитал
1356	277	1	2026-01-16 12:05:24.879432	ck_department	\N	Департамент цифровых продуктов
1357	277	1	2026-01-16 12:05:24.879822	placement_type	\N	любой
1358	277	1	2026-01-16 12:05:24.880193	ready_for_vacancy	\N	Нет
1359	277	1	2026-01-16 12:05:24.880563	resume_link	\N	https://drive.google.com/file/45776
1360	277	1	2026-01-16 12:05:24.880925	manager_feedback	\N	Нужно развитие
1361	277	1	2026-01-16 12:05:24.881305	contacts	\N	+7 (921) 703-59-72, @попвлад6, v.popov@rt.ru
1362	277	1	2026-01-16 12:05:24.881754	funding_end_date	\N	2025-10-13
1363	277	1	2026-01-16 12:05:24.882168	candidate_status	\N	Свободен
1364	277	1	2026-01-16 12:05:24.882541	target_projects	\N	Госуслуги 2.0, Mobile App, Data Platform
1365	277	1	2026-01-16 12:05:24.8829	transfer_date	\N	
1366	277	1	2026-01-16 12:05:24.883259	recruiter	\N	Орлов М.С.
1367	277	1	2026-01-16 12:05:24.883612	hr_bp	\N	Волкова Н.В.
1368	277	1	2026-01-16 12:05:24.88397	comments	\N	
1369	278	1	2026-01-16 12:05:24.905919	entry_date	\N	2024-06-04
1370	278	1	2026-01-16 12:05:24.906573	current_manager	\N	Сидорова Е.К.
1371	278	1	2026-01-16 12:05:24.90721	it_block	\N	Диджитал
1372	278	1	2026-01-16 12:05:24.907928	ck_department	\N	Департамент данных
1373	278	1	2026-01-16 12:05:24.908442	placement_type	\N	любой
1374	278	1	2026-01-16 12:05:24.908915	ready_for_vacancy	\N	Да
1375	278	1	2026-01-16 12:05:24.909444	resume_link	\N	https://drive.google.com/file/43642
1376	278	1	2026-01-16 12:05:24.909896	manager_feedback	\N	Хороший специалист
1377	278	1	2026-01-16 12:05:24.910323	contacts	\N	+7 (985) 859-46-88, @гриелен26, e.grigoreva@rt.ru
1378	278	1	2026-01-16 12:05:24.910831	funding_end_date	\N	2025-05-23
1379	278	1	2026-01-16 12:05:24.911667	candidate_status	\N	В работе
1380	278	1	2026-01-16 12:05:24.912261	target_projects	\N	Banking App, Infrastructure
1381	278	1	2026-01-16 12:05:24.912722	transfer_date	\N	
1382	278	1	2026-01-16 12:05:24.913291	recruiter	\N	Смирнова А.А.
1383	278	1	2026-01-16 12:05:24.913904	hr_bp	\N	Лебедева Т.М.
1384	278	1	2026-01-16 12:05:24.914365	comments	\N	Срочно нужен проект
1385	279	1	2026-01-16 12:05:24.946479	entry_date	\N	2024-04-08
1386	279	1	2026-01-16 12:05:24.947335	current_manager	\N	Сидорова Е.К.
1387	279	1	2026-01-16 12:05:24.948028	it_block	\N	B2O
1388	279	1	2026-01-16 12:05:24.948756	ck_department	\N	ЦК Аналитики
1389	279	1	2026-01-16 12:05:24.949597	placement_type	\N	любой
1390	279	1	2026-01-16 12:05:24.950474	ready_for_vacancy	\N	Да
1391	279	1	2026-01-16 12:05:24.952201	resume_link	\N	https://drive.google.com/file/59894
1392	279	1	2026-01-16 12:05:24.952921	manager_feedback	\N	Нужно развитие
1393	279	1	2026-01-16 12:05:24.953687	contacts	\N	+7 (955) 109-47-10, @иваалин93, a.ivanova@rt.ru
1394	279	1	2026-01-16 12:05:24.954357	funding_end_date	\N	2025-02-07
1395	279	1	2026-01-16 12:05:24.955035	candidate_status	\N	В работе
1396	279	1	2026-01-16 12:05:24.955719	target_projects	\N	Госуслуги 2.0, ML Pipeline
1397	279	1	2026-01-16 12:05:24.956793	transfer_date	\N	
1398	279	1	2026-01-16 12:05:24.957614	recruiter	\N	Смирнова А.А.
1399	279	1	2026-01-16 12:05:24.958736	hr_bp	\N	Лебедева Т.М.
1400	279	1	2026-01-16 12:05:24.959764	comments	\N	
1401	280	1	2026-01-16 12:05:24.991443	entry_date	\N	2024-11-26
1402	280	1	2026-01-16 12:05:24.992459	current_manager	\N	Козлов Д.В.
1403	280	1	2026-01-16 12:05:24.993296	it_block	\N	Развитие
1404	280	1	2026-01-16 12:05:24.994015	ck_department	\N	Департамент цифровых продуктов
1405	280	1	2026-01-16 12:05:24.994675	placement_type	\N	перевод
1406	280	1	2026-01-16 12:05:24.995343	ready_for_vacancy	\N	Нет
1407	280	1	2026-01-16 12:05:24.995999	resume_link	\N	https://drive.google.com/file/14988
1408	280	1	2026-01-16 12:05:24.996757	manager_feedback	\N	Хороший специалист
1409	280	1	2026-01-16 12:05:24.997433	contacts	\N	+7 (990) 950-27-61, @ильлюбо93, l.ilina@rt.ru
1410	280	1	2026-01-16 12:05:24.997975	funding_end_date	\N	2025-03-12
1411	280	1	2026-01-16 12:05:24.998387	candidate_status	\N	Забронирован
1412	280	1	2026-01-16 12:05:24.999026	target_projects	\N	ML Pipeline
1413	280	1	2026-01-16 12:05:24.999753	transfer_date	\N	
1414	280	1	2026-01-16 12:05:25.000251	recruiter	\N	Орлов М.С.
1415	280	1	2026-01-16 12:05:25.000903	hr_bp	\N	Морозов К.А.
1416	280	1	2026-01-16 12:05:25.001529	comments	\N	Ожидает оффер
1417	281	1	2026-01-16 12:05:25.035043	entry_date	\N	2024-11-15
1418	281	1	2026-01-16 12:05:25.035785	current_manager	\N	Сидорова Е.К.
1419	281	1	2026-01-16 12:05:25.036345	it_block	\N	НУК
1420	281	1	2026-01-16 12:05:25.036853	ck_department	\N	ЦК Инфраструктуры
1421	281	1	2026-01-16 12:05:25.037966	placement_type	\N	перевод
1422	281	1	2026-01-16 12:05:25.03896	ready_for_vacancy	\N	Нет
1423	281	1	2026-01-16 12:05:25.039977	resume_link	\N	https://drive.google.com/file/41763
1424	281	1	2026-01-16 12:05:25.040898	manager_feedback	\N	Нужно развитие
1425	281	1	2026-01-16 12:05:25.041692	contacts	\N	+7 (983) 378-36-34, @корюлия56, yu.koroleva@rt.ru
1426	281	1	2026-01-16 12:05:25.042673	funding_end_date	\N	2026-10-04
1427	281	1	2026-01-16 12:05:25.04357	candidate_status	\N	Забронирован
1428	281	1	2026-01-16 12:05:25.044547	target_projects	\N	E-commerce Platform, ML Pipeline, Infrastructure
1429	281	1	2026-01-16 12:05:25.045672	transfer_date	\N	
1430	281	1	2026-01-16 12:05:25.046607	recruiter	\N	Смирнова А.А.
1431	281	1	2026-01-16 12:05:25.048208	hr_bp	\N	Волкова Н.В.
1432	281	1	2026-01-16 12:05:25.049	comments	\N	Срочно нужен проект
1433	282	1	2026-01-16 12:05:25.077822	entry_date	\N	2025-01-12
1434	282	1	2026-01-16 12:05:25.078711	current_manager	\N	Козлов Д.В.
1435	282	1	2026-01-16 12:05:25.079452	it_block	\N	Диджитал
1436	282	1	2026-01-16 12:05:25.080162	ck_department	\N	ЦК Разработки
1437	282	1	2026-01-16 12:05:25.08084	placement_type	\N	любой
1438	282	1	2026-01-16 12:05:25.081307	ready_for_vacancy	\N	Да
1439	282	1	2026-01-16 12:05:25.081813	resume_link	\N	https://drive.google.com/file/29503
1440	282	1	2026-01-16 12:05:25.08224	manager_feedback	\N	
1441	282	1	2026-01-16 12:05:25.082627	contacts	\N	+7 (972) 548-63-55, @егоартё88, a.egorov@rt.ru
1442	282	1	2026-01-16 12:05:25.082993	funding_end_date	\N	2026-05-06
1443	282	1	2026-01-16 12:05:25.083542	candidate_status	\N	Забронирован
1444	282	1	2026-01-16 12:05:25.087839	target_projects	\N	ML Pipeline, E-commerce Platform
1445	282	1	2026-01-16 12:05:25.088542	transfer_date	\N	
1446	282	1	2026-01-16 12:05:25.08915	recruiter	\N	Новикова Е.П.
1447	282	1	2026-01-16 12:05:25.089794	hr_bp	\N	Лебедева Т.М.
1448	282	1	2026-01-16 12:05:25.090259	comments	\N	
1449	283	1	2026-01-16 12:05:25.120267	entry_date	\N	2024-02-22
1450	283	1	2026-01-16 12:05:25.120923	current_manager	\N	Михайлова О.Н.
1451	283	1	2026-01-16 12:05:25.121423	it_block	\N	НУК
1452	283	1	2026-01-16 12:05:25.121839	ck_department	\N	ЦК Аналитики
1453	283	1	2026-01-16 12:05:25.122291	placement_type	\N	аутстафф
1454	283	1	2026-01-16 12:05:25.122808	ready_for_vacancy	\N	Нет
1455	283	1	2026-01-16 12:05:25.123487	resume_link	\N	https://drive.google.com/file/45954
1456	283	1	2026-01-16 12:05:25.124321	manager_feedback	\N	
1457	283	1	2026-01-16 12:05:25.125036	contacts	\N	+7 (962) 894-11-75, @орлегор78, e.orlov@rt.ru
1458	283	1	2026-01-16 12:05:25.125721	funding_end_date	\N	2026-12-20
1459	283	1	2026-01-16 12:05:25.126466	candidate_status	\N	Увольнение по СЖ
1460	283	1	2026-01-16 12:05:25.127188	target_projects	\N	Infrastructure, E-commerce Platform
1461	283	1	2026-01-16 12:05:25.127916	transfer_date	\N	2026-07-01
1462	283	1	2026-01-16 12:05:25.128598	recruiter	\N	Смирнова А.А.
1463	283	1	2026-01-16 12:05:25.129328	hr_bp	\N	Лебедева Т.М.
1464	283	1	2026-01-16 12:05:25.129887	comments	\N	
1465	284	1	2026-01-16 12:05:25.153725	entry_date	\N	2025-05-26
1466	284	1	2026-01-16 12:05:25.154548	current_manager	\N	Козлов Д.В.
1467	284	1	2026-01-16 12:05:25.155169	it_block	\N	Прочее
1468	284	1	2026-01-16 12:05:25.155618	ck_department	\N	ЦК Аналитики
1469	284	1	2026-01-16 12:05:25.156012	placement_type	\N	аутстафф
1470	284	1	2026-01-16 12:05:25.156392	ready_for_vacancy	\N	Нет
1471	284	1	2026-01-16 12:05:25.156769	resume_link	\N	https://drive.google.com/file/39163
1472	284	1	2026-01-16 12:05:25.157136	manager_feedback	\N	
1473	284	1	2026-01-16 12:05:25.157736	contacts	\N	+7 (907) 730-30-17, @алеарсе5, a.alekseev@rt.ru
1474	284	1	2026-01-16 12:05:25.158126	funding_end_date	\N	2025-09-23
1475	284	1	2026-01-16 12:05:25.158521	candidate_status	\N	Увольнение по СЖ
1476	284	1	2026-01-16 12:05:25.158892	target_projects	\N	Infrastructure, DevOps Platform
1477	284	1	2026-01-16 12:05:25.15926	transfer_date	\N	2025-06-30
1478	284	1	2026-01-16 12:05:25.159626	recruiter	\N	Смирнова А.А.
1479	284	1	2026-01-16 12:05:25.160168	hr_bp	\N	Морозов К.А.
1480	284	1	2026-01-16 12:05:25.160927	comments	\N	
1481	285	1	2026-01-16 12:05:25.187025	entry_date	\N	2024-12-12
1482	285	1	2026-01-16 12:05:25.187956	current_manager	\N	Сидорова Е.К.
1483	285	1	2026-01-16 12:05:25.188693	it_block	\N	НУК
1484	285	1	2026-01-16 12:05:25.189467	ck_department	\N	Департамент данных
1485	285	1	2026-01-16 12:05:25.190204	placement_type	\N	любой
1486	285	1	2026-01-16 12:05:25.190933	ready_for_vacancy	\N	Нет
1487	285	1	2026-01-16 12:05:25.191538	resume_link	\N	https://drive.google.com/file/48262
1488	285	1	2026-01-16 12:05:25.192204	manager_feedback	\N	Нужно развитие
1489	285	1	2026-01-16 12:05:25.192847	contacts	\N	+7 (966) 588-54-70, @козалек70, a.kozlov@rt.ru
1490	285	1	2026-01-16 12:05:25.193549	funding_end_date	\N	2025-04-25
1491	285	1	2026-01-16 12:05:25.194226	candidate_status	\N	Переведен
1492	285	1	2026-01-16 12:05:25.194865	target_projects	\N	DevOps Platform
1493	285	1	2026-01-16 12:05:25.195352	transfer_date	\N	2026-01-12
1494	285	1	2026-01-16 12:05:25.195758	recruiter	\N	Смирнова А.А.
1495	285	1	2026-01-16 12:05:25.196122	hr_bp	\N	Волкова Н.В.
1496	285	1	2026-01-16 12:05:25.196549	comments	\N	
1497	286	1	2026-01-16 12:05:25.220908	entry_date	\N	2025-12-19
1498	286	1	2026-01-16 12:05:25.22156	current_manager	\N	Иванов А.П.
1499	286	1	2026-01-16 12:05:25.222204	it_block	\N	Развитие
1500	286	1	2026-01-16 12:05:25.222894	ck_department	\N	Департамент цифровых продуктов
1501	286	1	2026-01-16 12:05:25.223352	placement_type	\N	аутстафф
1502	286	1	2026-01-16 12:05:25.223762	ready_for_vacancy	\N	Нет
1503	286	1	2026-01-16 12:05:25.224148	resume_link	\N	https://drive.google.com/file/18030
1504	286	1	2026-01-16 12:05:25.224508	manager_feedback	\N	Отличные результаты
1505	286	1	2026-01-16 12:05:25.224862	contacts	\N	+7 (908) 439-73-95, @попсвет95, s.popova@rt.ru
1506	286	1	2026-01-16 12:05:25.22539	funding_end_date	\N	2026-09-28
1507	286	1	2026-01-16 12:05:25.226135	candidate_status	\N	Переведен
1508	286	1	2026-01-16 12:05:25.226582	target_projects	\N	Infrastructure, E-commerce Platform
1509	286	1	2026-01-16 12:05:25.226969	transfer_date	\N	2025-05-06
1510	286	1	2026-01-16 12:05:25.227342	recruiter	\N	Орлов М.С.
1511	286	1	2026-01-16 12:05:25.227719	hr_bp	\N	Морозов К.А.
1512	286	1	2026-01-16 12:05:25.228142	comments	\N	В процессе согласования
1513	287	1	2026-01-16 12:05:25.257409	entry_date	\N	2024-11-05
1514	287	1	2026-01-16 12:05:25.258042	current_manager	\N	Иванов А.П.
1515	287	1	2026-01-16 12:05:25.258506	it_block	\N	Прочее
1516	287	1	2026-01-16 12:05:25.258906	ck_department	\N	ЦК Разработки
1517	287	1	2026-01-16 12:05:25.259294	placement_type	\N	любой
1518	287	1	2026-01-16 12:05:25.259665	ready_for_vacancy	\N	Нет
1519	287	1	2026-01-16 12:05:25.260154	resume_link	\N	https://drive.google.com/file/48767
1520	287	1	2026-01-16 12:05:25.26054	manager_feedback	\N	Хороший специалист
1521	287	1	2026-01-16 12:05:25.260912	contacts	\N	+7 (957) 905-88-98, @захконс29, k.zakharov@rt.ru
1522	287	1	2026-01-16 12:05:25.26129	funding_end_date	\N	2025-02-01
1523	287	1	2026-01-16 12:05:25.261681	candidate_status	\N	Забронирован
1524	287	1	2026-01-16 12:05:25.26205	target_projects	\N	Data Platform, Госуслуги 2.0
1525	287	1	2026-01-16 12:05:25.262406	transfer_date	\N	
1526	287	1	2026-01-16 12:05:25.262756	recruiter	\N	Белова И.Д.
1527	287	1	2026-01-16 12:05:25.263106	hr_bp	\N	Морозов К.А.
1528	287	1	2026-01-16 12:05:25.263782	comments	\N	
1529	288	1	2026-01-16 12:05:25.286107	entry_date	\N	2025-08-25
1530	288	1	2026-01-16 12:05:25.286745	current_manager	\N	Козлов Д.В.
1531	288	1	2026-01-16 12:05:25.287205	it_block	\N	Диджитал
1532	288	1	2026-01-16 12:05:25.287594	ck_department	\N	ЦК Инфраструктуры
1533	288	1	2026-01-16 12:05:25.287973	placement_type	\N	перевод
1534	288	1	2026-01-16 12:05:25.288339	ready_for_vacancy	\N	Да
1535	288	1	2026-01-16 12:05:25.288704	resume_link	\N	https://drive.google.com/file/77441
1536	288	1	2026-01-16 12:05:25.289057	manager_feedback	\N	Хороший специалист
1537	288	1	2026-01-16 12:05:25.289686	contacts	\N	+7 (979) 352-24-47, @морвлад76, v.morozov@rt.ru
1538	288	1	2026-01-16 12:05:25.290439	funding_end_date	\N	2025-01-10
1539	288	1	2026-01-16 12:05:25.291087	candidate_status	\N	Увольнение по СЖ
1540	288	1	2026-01-16 12:05:25.291731	target_projects	\N	E-commerce Platform, Banking App
1541	288	1	2026-01-16 12:05:25.292381	transfer_date	\N	2026-09-13
1542	288	1	2026-01-16 12:05:25.293022	recruiter	\N	Смирнова А.А.
1543	288	1	2026-01-16 12:05:25.293608	hr_bp	\N	Лебедева Т.М.
1544	288	1	2026-01-16 12:05:25.294032	comments	\N	Срочно нужен проект
1545	289	1	2026-01-16 12:05:25.321804	entry_date	\N	2024-06-16
1546	289	1	2026-01-16 12:05:25.322443	current_manager	\N	Иванов А.П.
1547	289	1	2026-01-16 12:05:25.322874	it_block	\N	B2O
1548	289	1	2026-01-16 12:05:25.32327	ck_department	\N	Департамент цифровых продуктов
1549	289	1	2026-01-16 12:05:25.323638	placement_type	\N	любой
1550	289	1	2026-01-16 12:05:25.323995	ready_for_vacancy	\N	Да
1551	289	1	2026-01-16 12:05:25.32435	resume_link	\N	https://drive.google.com/file/72602
1552	289	1	2026-01-16 12:05:25.324701	manager_feedback	\N	Нужно развитие
1553	289	1	2026-01-16 12:05:25.325046	contacts	\N	+7 (901) 994-18-72, @грирусл36, r.grigorev@rt.ru
1554	289	1	2026-01-16 12:05:25.325517	funding_end_date	\N	2025-06-20
1555	289	1	2026-01-16 12:05:25.326083	candidate_status	\N	Переведен
1556	289	1	2026-01-16 12:05:25.326509	target_projects	\N	Data Platform, Госуслуги 2.0
1557	289	1	2026-01-16 12:05:25.326901	transfer_date	\N	2026-12-18
1558	289	1	2026-01-16 12:05:25.327272	recruiter	\N	Орлов М.С.
1559	289	1	2026-01-16 12:05:25.327649	hr_bp	\N	Волкова Н.В.
1560	289	1	2026-01-16 12:05:25.328012	comments	\N	
1561	79	1	2026-01-16 12:05:25.349211	entry_date	\N	2024-02-02
1562	79	1	2026-01-16 12:05:25.349912	current_manager	\N	Иванов А.П.
1563	79	1	2026-01-16 12:05:25.350335	it_block	\N	Эксплуатация
1564	79	1	2026-01-16 12:05:25.350933	ck_department	\N	Департамент цифровых продуктов
1565	79	1	2026-01-16 12:05:25.351528	placement_type	\N	перевод
1566	79	1	2026-01-16 12:05:25.351922	ready_for_vacancy	\N	Нет
1567	79	1	2026-01-16 12:05:25.352487	resume_link	\N	https://drive.google.com/file/93796
1568	79	1	2026-01-16 12:05:25.352949	manager_feedback	\N	Хороший специалист
1569	79	1	2026-01-16 12:05:25.353404	contacts	\N	+7 (996) 834-24-85, @васиван13, andrey.romanov63@company.ru
1570	79	1	2026-01-16 12:05:25.35379	funding_end_date	\N	2026-11-17
1571	79	1	2026-01-16 12:05:25.354149	candidate_status	\N	Свободен
1572	79	1	2026-01-16 12:05:25.3545	target_projects	\N	Banking App, Infrastructure, DevOps Platform
1573	79	1	2026-01-16 12:05:25.354851	transfer_date	\N	
1574	79	1	2026-01-16 12:05:25.355199	recruiter	\N	Орлов М.С.
1575	79	1	2026-01-16 12:05:25.355552	hr_bp	\N	Лебедева Т.М.
1576	79	1	2026-01-16 12:05:25.355963	comments	\N	В процессе согласования
1577	83	1	2026-01-16 12:05:25.379315	entry_date	\N	2025-10-27
1578	83	1	2026-01-16 12:05:25.38017	current_manager	\N	Сидорова Е.К.
1579	83	1	2026-01-16 12:05:25.381106	it_block	\N	Эксплуатация
1580	83	1	2026-01-16 12:05:25.38229	ck_department	\N	ЦК Аналитики
1581	83	1	2026-01-16 12:05:25.38297	placement_type	\N	перевод
1582	83	1	2026-01-16 12:05:25.38351	ready_for_vacancy	\N	Да
1583	83	1	2026-01-16 12:05:25.38432	resume_link	\N	https://drive.google.com/file/37614
1584	83	1	2026-01-16 12:05:25.38515	manager_feedback	\N	Отличные результаты
1585	83	1	2026-01-16 12:05:25.385844	contacts	\N	+7 (959) 555-53-34, @новрома71, elena.semenov67@company.ru
1586	83	1	2026-01-16 12:05:25.386361	funding_end_date	\N	2025-05-15
1587	83	1	2026-01-16 12:05:25.386786	candidate_status	\N	Переведен
1588	83	1	2026-01-16 12:05:25.387194	target_projects	\N	Госуслуги 2.0
1589	83	1	2026-01-16 12:05:25.38771	transfer_date	\N	2025-02-13
1590	83	1	2026-01-16 12:05:25.388163	recruiter	\N	Смирнова А.А.
1591	83	1	2026-01-16 12:05:25.388525	hr_bp	\N	Лебедева Т.М.
1592	83	1	2026-01-16 12:05:25.38895	comments	\N	Срочно нужен проект
1593	70	1	2026-01-16 12:05:25.422958	entry_date	\N	2025-01-28
1594	70	1	2026-01-16 12:05:25.423893	current_manager	\N	Сидорова Е.К.
1595	70	1	2026-01-16 12:05:25.424974	it_block	\N	Прочее
1596	70	1	2026-01-16 12:05:25.426056	ck_department	\N	Департамент цифровых продуктов
1597	70	1	2026-01-16 12:05:25.426966	placement_type	\N	аутстафф
1598	70	1	2026-01-16 12:05:25.427662	ready_for_vacancy	\N	Нет
1599	70	1	2026-01-16 12:05:25.428124	resume_link	\N	https://drive.google.com/file/28177
1600	70	1	2026-01-16 12:05:25.428525	manager_feedback	\N	Хороший специалист
1601	70	1	2026-01-16 12:05:25.428901	contacts	\N	+7 (922) 938-83-59, @морники35, konstantin.lebedev54@company.ru
1602	70	1	2026-01-16 12:05:25.429307	funding_end_date	\N	2026-08-13
1603	70	1	2026-01-16 12:05:25.430159	candidate_status	\N	Переведен
1604	70	1	2026-01-16 12:05:25.431058	target_projects	\N	Mobile App
1605	70	1	2026-01-16 12:05:25.432048	transfer_date	\N	2026-11-16
1606	70	1	2026-01-16 12:05:25.43296	recruiter	\N	Орлов М.С.
1607	70	1	2026-01-16 12:05:25.43391	hr_bp	\N	Волкова Н.В.
1608	70	1	2026-01-16 12:05:25.434646	comments	\N	
1609	103	1	2026-01-16 12:05:25.483671	entry_date	\N	2025-05-03
1610	103	1	2026-01-16 12:05:25.485105	current_manager	\N	Михайлова О.Н.
1611	103	1	2026-01-16 12:05:25.485753	it_block	\N	B2O
1612	103	1	2026-01-16 12:05:25.486447	ck_department	\N	Департамент цифровых продуктов
1613	103	1	2026-01-16 12:05:25.4872	placement_type	\N	любой
1614	103	1	2026-01-16 12:05:25.487897	ready_for_vacancy	\N	Да
1615	103	1	2026-01-16 12:05:25.488826	resume_link	\N	https://drive.google.com/file/50906
1616	103	1	2026-01-16 12:05:25.489556	manager_feedback	\N	Рекомендую
1617	103	1	2026-01-16 12:05:25.489994	contacts	\N	+7 (961) 645-58-74, @лебдмит39, daniil.makarov87@company.ru
1618	103	1	2026-01-16 12:05:25.490372	funding_end_date	\N	2025-11-18
1619	103	1	2026-01-16 12:05:25.490725	candidate_status	\N	Свободен
1620	103	1	2026-01-16 12:05:25.491069	target_projects	\N	DevOps Platform, Госуслуги 2.0, ML Pipeline
1621	103	1	2026-01-16 12:05:25.491424	transfer_date	\N	
1622	103	1	2026-01-16 12:05:25.491765	recruiter	\N	Смирнова А.А.
1623	103	1	2026-01-16 12:05:25.492166	hr_bp	\N	Морозов К.А.
1624	103	1	2026-01-16 12:05:25.492514	comments	\N	Срочно нужен проект
1625	94	1	2026-01-16 12:05:25.513626	entry_date	\N	2025-05-21
1626	94	1	2026-01-16 12:05:25.514554	current_manager	\N	Михайлова О.Н.
1627	94	1	2026-01-16 12:05:25.515013	it_block	\N	B2O
1628	94	1	2026-01-16 12:05:25.515397	ck_department	\N	ЦК Разработки
1629	94	1	2026-01-16 12:05:25.515767	placement_type	\N	любой
1630	94	1	2026-01-16 12:05:25.51615	ready_for_vacancy	\N	Нет
1631	94	1	2026-01-16 12:05:25.516507	resume_link	\N	https://drive.google.com/file/78594
1632	94	1	2026-01-16 12:05:25.51698	manager_feedback	\N	Нужно развитие
1633	94	1	2026-01-16 12:05:25.517904	contacts	\N	+7 (970) 956-85-20, @васиван14, julia.alexandrov78@company.ru
1634	94	1	2026-01-16 12:05:25.518441	funding_end_date	\N	2026-07-10
1635	94	1	2026-01-16 12:05:25.5189	candidate_status	\N	Увольнение по СЖ
1636	94	1	2026-01-16 12:05:25.519775	target_projects	\N	Data Platform, Banking App, Госуслуги 2.0
1637	94	1	2026-01-16 12:05:25.520513	transfer_date	\N	2026-09-18
1638	94	1	2026-01-16 12:05:25.521113	recruiter	\N	Новикова Е.П.
1639	94	1	2026-01-16 12:05:25.52172	hr_bp	\N	Лебедева Т.М.
1640	94	1	2026-01-16 12:05:25.522366	comments	\N	Срочно нужен проект
1641	113	1	2026-01-16 12:05:25.556839	entry_date	\N	2025-06-26
1642	113	1	2026-01-16 12:05:25.557682	current_manager	\N	Сидорова Е.К.
1643	113	1	2026-01-16 12:05:25.55843	it_block	\N	Эксплуатация
1644	113	1	2026-01-16 12:05:25.559104	ck_department	\N	ЦК Разработки
1645	113	1	2026-01-16 12:05:25.559763	placement_type	\N	аутстафф
1646	113	1	2026-01-16 12:05:25.560295	ready_for_vacancy	\N	Да
1647	113	1	2026-01-16 12:05:25.560687	resume_link	\N	https://drive.google.com/file/65428
1648	113	1	2026-01-16 12:05:25.561124	manager_feedback	\N	Отличные результаты
1649	113	1	2026-01-16 12:05:25.561843	contacts	\N	+7 (900) 532-83-33, @новрома13, igor.dmitriev97@company.ru
1650	113	1	2026-01-16 12:05:25.562476	funding_end_date	\N	2026-08-30
1651	113	1	2026-01-16 12:05:25.563219	candidate_status	\N	Увольнение по СЖ
1652	113	1	2026-01-16 12:05:25.563673	target_projects	\N	DevOps Platform, Mobile App
1653	113	1	2026-01-16 12:05:25.564186	transfer_date	\N	2026-01-02
1654	113	1	2026-01-16 12:05:25.56489	recruiter	\N	Орлов М.С.
1655	113	1	2026-01-16 12:05:25.565657	hr_bp	\N	Морозов К.А.
1656	113	1	2026-01-16 12:05:25.566102	comments	\N	Срочно нужен проект
1657	118	1	2026-01-16 12:05:25.596521	entry_date	\N	2024-05-03
1658	118	1	2026-01-16 12:05:25.597373	current_manager	\N	Михайлова О.Н.
1659	118	1	2026-01-16 12:05:25.597864	it_block	\N	Эксплуатация
1660	118	1	2026-01-16 12:05:25.59827	ck_department	\N	Департамент данных
1661	118	1	2026-01-16 12:05:25.598641	placement_type	\N	аутстафф
1662	118	1	2026-01-16 12:05:25.598994	ready_for_vacancy	\N	Нет
1663	118	1	2026-01-16 12:05:25.599349	resume_link	\N	https://drive.google.com/file/41445
1664	118	1	2026-01-16 12:05:25.599697	manager_feedback	\N	
1665	118	1	2026-01-16 12:05:25.600057	contacts	\N	+7 (901) 846-87-47, @лебдмит77, arthur.makarov102@company.ru
1666	118	1	2026-01-16 12:05:25.600401	funding_end_date	\N	2025-04-29
1667	118	1	2026-01-16 12:05:25.601026	candidate_status	\N	Переведен
1668	118	1	2026-01-16 12:05:25.601753	target_projects	\N	ML Pipeline, Госуслуги 2.0
1669	118	1	2026-01-16 12:05:25.602291	transfer_date	\N	2025-09-27
1670	118	1	2026-01-16 12:05:25.602919	recruiter	\N	Смирнова А.А.
1671	118	1	2026-01-16 12:05:25.603315	hr_bp	\N	Морозов К.А.
1672	118	1	2026-01-16 12:05:25.603679	comments	\N	В процессе согласования
1673	126	1	2026-01-16 12:05:25.633443	entry_date	\N	2025-09-20
1674	126	1	2026-01-16 12:05:25.634206	current_manager	\N	Иванов А.П.
1675	126	1	2026-01-16 12:05:25.634901	it_block	\N	Прочее
1676	126	1	2026-01-16 12:05:25.635548	ck_department	\N	ЦК Аналитики
1677	126	1	2026-01-16 12:05:25.636221	placement_type	\N	любой
1678	126	1	2026-01-16 12:05:25.636645	ready_for_vacancy	\N	Да
1679	126	1	2026-01-16 12:05:25.637026	resume_link	\N	https://drive.google.com/file/45416
1680	126	1	2026-01-16 12:05:25.637419	manager_feedback	\N	Рекомендую
1681	126	1	2026-01-16 12:05:25.638326	contacts	\N	+7 (950) 508-94-43, @сокегор68, petr.frolov110@company.ru
1682	126	1	2026-01-16 12:05:25.639042	funding_end_date	\N	2026-05-20
1683	126	1	2026-01-16 12:05:25.639686	candidate_status	\N	Увольнение по СЖ
1684	126	1	2026-01-16 12:05:25.640357	target_projects	\N	Госуслуги 2.0, Infrastructure, E-commerce Platform
1685	126	1	2026-01-16 12:05:25.640929	transfer_date	\N	2025-07-18
1686	126	1	2026-01-16 12:05:25.641662	recruiter	\N	Орлов М.С.
1687	126	1	2026-01-16 12:05:25.642307	hr_bp	\N	Волкова Н.В.
1688	126	1	2026-01-16 12:05:25.642948	comments	\N	
1689	121	1	2026-01-16 12:05:25.669436	entry_date	\N	2024-11-12
1690	121	1	2026-01-16 12:05:25.670981	current_manager	\N	Иванов А.П.
1691	121	1	2026-01-16 12:05:25.671682	it_block	\N	Развитие
1692	121	1	2026-01-16 12:05:25.672214	ck_department	\N	ЦК Аналитики
1693	121	1	2026-01-16 12:05:25.672943	placement_type	\N	аутстафф
1694	121	1	2026-01-16 12:05:25.673707	ready_for_vacancy	\N	Нет
1695	121	1	2026-01-16 12:05:25.674297	resume_link	\N	https://drive.google.com/file/87095
1696	121	1	2026-01-16 12:05:25.674957	manager_feedback	\N	Нужно развитие
1697	121	1	2026-01-16 12:05:25.675599	contacts	\N	+7 (934) 507-47-18, @смиилья55, timur.petrov105@company.ru
1698	121	1	2026-01-16 12:05:25.676255	funding_end_date	\N	2025-03-12
1699	121	1	2026-01-16 12:05:25.676904	candidate_status	\N	Увольнение по СЖ
1700	121	1	2026-01-16 12:05:25.67787	target_projects	\N	Banking App, ML Pipeline, Data Platform
1701	121	1	2026-01-16 12:05:25.67859	transfer_date	\N	2025-02-03
1702	121	1	2026-01-16 12:05:25.679321	recruiter	\N	Новикова Е.П.
1703	121	1	2026-01-16 12:05:25.679868	hr_bp	\N	Волкова Н.В.
1704	121	1	2026-01-16 12:05:25.680272	comments	\N	Ожидает оффер
1705	312	1	2026-01-16 12:05:25.702793	entry_date	\N	2025-11-12
1706	312	1	2026-01-16 12:05:25.703676	current_manager	\N	Михайлова О.Н.
1707	312	1	2026-01-16 12:05:25.704441	it_block	\N	Диджитал
1708	312	1	2026-01-16 12:05:25.705136	ck_department	\N	Департамент данных
1709	312	1	2026-01-16 12:05:25.705957	placement_type	\N	аутстафф
1710	312	1	2026-01-16 12:05:25.706657	ready_for_vacancy	\N	Да
1711	312	1	2026-01-16 12:05:25.707347	resume_link	\N	https://drive.google.com/file/75205
1712	312	1	2026-01-16 12:05:25.707914	manager_feedback	\N	Хороший специалист
1713	312	1	2026-01-16 12:05:25.70846	contacts	\N	+7 (963) 220-95-41, @киссвет21, s.kiseleva@rt.ru
1714	312	1	2026-01-16 12:05:25.709003	funding_end_date	\N	2025-12-21
1715	312	1	2026-01-16 12:05:25.709623	candidate_status	\N	Свободен
1716	312	1	2026-01-16 12:05:25.710165	target_projects	\N	Госуслуги 2.0, Mobile App, Infrastructure
1717	312	1	2026-01-16 12:05:25.710715	transfer_date	\N	
1718	312	1	2026-01-16 12:05:25.711102	recruiter	\N	Смирнова А.А.
1719	312	1	2026-01-16 12:05:25.713491	hr_bp	\N	Лебедева Т.М.
1720	312	1	2026-01-16 12:05:25.714216	comments	\N	Срочно нужен проект
1721	313	1	2026-01-16 12:05:25.735575	entry_date	\N	2025-07-27
1722	313	1	2026-01-16 12:05:25.736629	current_manager	\N	Иванов А.П.
1723	313	1	2026-01-16 12:05:25.737195	it_block	\N	НУК
1724	313	1	2026-01-16 12:05:25.737771	ck_department	\N	Департамент данных
1725	313	1	2026-01-16 12:05:25.738175	placement_type	\N	любой
1726	313	1	2026-01-16 12:05:25.738565	ready_for_vacancy	\N	Нет
1727	313	1	2026-01-16 12:05:25.738946	resume_link	\N	https://drive.google.com/file/31357
1728	313	1	2026-01-16 12:05:25.739312	manager_feedback	\N	Отличные результаты
1729	313	1	2026-01-16 12:05:25.739676	contacts	\N	+7 (902) 479-18-58, @полольг86, o.polyakova@rt.ru
1730	313	1	2026-01-16 12:05:25.740047	funding_end_date	\N	2025-09-12
1731	313	1	2026-01-16 12:05:25.740407	candidate_status	\N	Увольнение по СЖ
1732	313	1	2026-01-16 12:05:25.740764	target_projects	\N	Госуслуги 2.0, Data Platform
1733	313	1	2026-01-16 12:05:25.741145	transfer_date	\N	2025-07-10
1734	313	1	2026-01-16 12:05:25.741867	recruiter	\N	Новикова Е.П.
1735	313	1	2026-01-16 12:05:25.742641	hr_bp	\N	Лебедева Т.М.
1736	313	1	2026-01-16 12:05:25.743285	comments	\N	В процессе согласования
1737	314	1	2026-01-16 12:05:25.765738	entry_date	\N	2024-05-22
1738	314	1	2026-01-16 12:05:25.766621	current_manager	\N	Петров С.М.
1739	314	1	2026-01-16 12:05:25.767856	it_block	\N	НУК
1740	314	1	2026-01-16 12:05:25.768502	ck_department	\N	ЦК Инфраструктуры
1741	314	1	2026-01-16 12:05:25.769397	placement_type	\N	перевод
1742	314	1	2026-01-16 12:05:25.770096	ready_for_vacancy	\N	Нет
1743	314	1	2026-01-16 12:05:25.770561	resume_link	\N	https://drive.google.com/file/95942
1744	314	1	2026-01-16 12:05:25.77095	manager_feedback	\N	
1745	314	1	2026-01-16 12:05:25.771311	contacts	\N	+7 (979) 332-54-35, @лебанас45, a.lebedeva@rt.ru
1746	314	1	2026-01-16 12:05:25.771977	funding_end_date	\N	2025-04-11
1747	314	1	2026-01-16 12:05:25.772509	candidate_status	\N	В работе
1748	314	1	2026-01-16 12:05:25.773045	target_projects	\N	DevOps Platform, Data Platform
1749	314	1	2026-01-16 12:05:25.773693	transfer_date	\N	
1750	314	1	2026-01-16 12:05:25.774145	recruiter	\N	Орлов М.С.
1751	314	1	2026-01-16 12:05:25.774541	hr_bp	\N	Лебедева Т.М.
1752	314	1	2026-01-16 12:05:25.77491	comments	\N	Срочно нужен проект
1753	315	1	2026-01-16 12:05:25.799546	entry_date	\N	2025-02-22
1754	315	1	2026-01-16 12:05:25.800405	current_manager	\N	Козлов Д.В.
1755	315	1	2026-01-16 12:05:25.802303	it_block	\N	Диджитал
1756	315	1	2026-01-16 12:05:25.803022	ck_department	\N	Департамент данных
1757	315	1	2026-01-16 12:05:25.803607	placement_type	\N	перевод
1758	315	1	2026-01-16 12:05:25.804052	ready_for_vacancy	\N	Да
1759	315	1	2026-01-16 12:05:25.804568	resume_link	\N	https://drive.google.com/file/69188
1760	315	1	2026-01-16 12:05:25.805108	manager_feedback	\N	Хороший специалист
1761	315	1	2026-01-16 12:05:25.805657	contacts	\N	+7 (933) 231-72-84, @винюлия14, yu.vinogradova@rt.ru
1762	315	1	2026-01-16 12:05:25.806047	funding_end_date	\N	2025-06-19
1763	315	1	2026-01-16 12:05:25.80642	candidate_status	\N	Свободен
1764	315	1	2026-01-16 12:05:25.806829	target_projects	\N	DevOps Platform, Mobile App
1765	315	1	2026-01-16 12:05:25.807249	transfer_date	\N	
1766	315	1	2026-01-16 12:05:25.807676	recruiter	\N	Орлов М.С.
1767	315	1	2026-01-16 12:05:25.808297	hr_bp	\N	Лебедева Т.М.
1768	315	1	2026-01-16 12:05:25.809071	comments	\N	
1769	316	1	2026-01-16 12:05:25.83256	entry_date	\N	2025-02-07
1770	316	1	2026-01-16 12:05:25.833174	current_manager	\N	Козлов Д.В.
1771	316	1	2026-01-16 12:05:25.833795	it_block	\N	НУК
1772	316	1	2026-01-16 12:05:25.834789	ck_department	\N	ЦК Разработки
1773	316	1	2026-01-16 12:05:25.835655	placement_type	\N	аутстафф
1774	316	1	2026-01-16 12:05:25.83622	ready_for_vacancy	\N	Нет
1775	316	1	2026-01-16 12:05:25.837145	resume_link	\N	https://drive.google.com/file/20560
1776	316	1	2026-01-16 12:05:25.838009	manager_feedback	\N	Хороший специалист
1777	316	1	2026-01-16 12:05:25.838434	contacts	\N	+7 (968) 891-47-99, @яковикт66, v.yakovleva@rt.ru
1778	316	1	2026-01-16 12:05:25.838811	funding_end_date	\N	2025-07-09
1779	316	1	2026-01-16 12:05:25.839172	candidate_status	\N	Забронирован
1780	316	1	2026-01-16 12:05:25.839527	target_projects	\N	ML Pipeline
1781	316	1	2026-01-16 12:05:25.839882	transfer_date	\N	
1782	316	1	2026-01-16 12:05:25.84023	recruiter	\N	Орлов М.С.
1783	316	1	2026-01-16 12:05:25.840579	hr_bp	\N	Морозов К.А.
1784	316	1	2026-01-16 12:05:25.840927	comments	\N	
1785	317	1	2026-01-16 12:05:25.862244	entry_date	\N	2025-12-02
1786	317	1	2026-01-16 12:05:25.863361	current_manager	\N	Иванов А.П.
1787	317	1	2026-01-16 12:05:25.86436	it_block	\N	Развитие
1788	317	1	2026-01-16 12:05:25.864929	ck_department	\N	Департамент данных
1789	317	1	2026-01-16 12:05:25.865773	placement_type	\N	перевод
1790	317	1	2026-01-16 12:05:25.866314	ready_for_vacancy	\N	Да
1791	317	1	2026-01-16 12:05:25.866737	resume_link	\N	https://drive.google.com/file/97086
1792	317	1	2026-01-16 12:05:25.867203	manager_feedback	\N	Рекомендую
1793	317	1	2026-01-16 12:05:25.867898	contacts	\N	+7 (949) 394-57-32, @белюрий20, yu.belov@rt.ru
1794	317	1	2026-01-16 12:05:25.868543	funding_end_date	\N	2025-01-04
1795	317	1	2026-01-16 12:05:25.869026	candidate_status	\N	В работе
1796	317	1	2026-01-16 12:05:25.869513	target_projects	\N	ML Pipeline, Banking App, Data Platform
1797	317	1	2026-01-16 12:05:25.869918	transfer_date	\N	
1798	317	1	2026-01-16 12:05:25.870302	recruiter	\N	Смирнова А.А.
1799	317	1	2026-01-16 12:05:25.870665	hr_bp	\N	Лебедева Т.М.
1800	317	1	2026-01-16 12:05:25.871023	comments	\N	Ожидает оффер
1801	318	1	2026-01-16 12:05:25.899096	entry_date	\N	2025-09-16
1802	318	1	2026-01-16 12:05:25.900046	current_manager	\N	Михайлова О.Н.
1803	318	1	2026-01-16 12:05:25.901429	it_block	\N	Диджитал
1804	318	1	2026-01-16 12:05:25.902254	ck_department	\N	ЦК Аналитики
1805	318	1	2026-01-16 12:05:25.902915	placement_type	\N	перевод
1806	318	1	2026-01-16 12:05:25.903597	ready_for_vacancy	\N	Нет
1807	318	1	2026-01-16 12:05:25.904066	resume_link	\N	https://drive.google.com/file/91742
1808	318	1	2026-01-16 12:05:25.904471	manager_feedback	\N	Отличные результаты
1809	318	1	2026-01-16 12:05:25.905011	contacts	\N	+7 (960) 110-52-59, @гриматв10, m.grigorev@rt.ru
1810	318	1	2026-01-16 12:05:25.905784	funding_end_date	\N	2026-08-17
1811	318	1	2026-01-16 12:05:25.906464	candidate_status	\N	В работе
1812	318	1	2026-01-16 12:05:25.907135	target_projects	\N	Infrastructure, Госуслуги 2.0, Mobile App
1813	318	1	2026-01-16 12:05:25.907813	transfer_date	\N	
1814	318	1	2026-01-16 12:05:25.908417	recruiter	\N	Орлов М.С.
1815	318	1	2026-01-16 12:05:25.908867	hr_bp	\N	Морозов К.А.
1816	318	1	2026-01-16 12:05:25.909301	comments	\N	В процессе согласования
1817	319	1	2026-01-16 12:05:25.931933	entry_date	\N	2025-10-04
1818	319	1	2026-01-16 12:05:25.932791	current_manager	\N	Сидорова Е.К.
1819	319	1	2026-01-16 12:05:25.933586	it_block	\N	НУК
1820	319	1	2026-01-16 12:05:25.934396	ck_department	\N	ЦК Аналитики
1821	319	1	2026-01-16 12:05:25.935036	placement_type	\N	любой
1822	319	1	2026-01-16 12:05:25.935751	ready_for_vacancy	\N	Нет
1823	319	1	2026-01-16 12:05:25.936293	resume_link	\N	https://drive.google.com/file/98149
1824	319	1	2026-01-16 12:05:25.936702	manager_feedback	\N	Рекомендую
1825	319	1	2026-01-16 12:05:25.937081	contacts	\N	+7 (933) 178-50-56, @андкири95, k.andreev@rt.ru
1826	319	1	2026-01-16 12:05:25.937517	funding_end_date	\N	2026-12-30
1827	319	1	2026-01-16 12:05:25.937897	candidate_status	\N	В работе
1828	319	1	2026-01-16 12:05:25.938255	target_projects	\N	ML Pipeline, Banking App
1829	319	1	2026-01-16 12:05:25.93861	transfer_date	\N	
1830	319	1	2026-01-16 12:05:25.938961	recruiter	\N	Новикова Е.П.
1831	319	1	2026-01-16 12:05:25.939313	hr_bp	\N	Лебедева Т.М.
1832	319	1	2026-01-16 12:05:25.939663	comments	\N	Срочно нужен проект
1833	320	1	2026-01-16 12:05:25.960528	entry_date	\N	2025-06-07
1834	320	1	2026-01-16 12:05:25.961552	current_manager	\N	Сидорова Е.К.
1835	320	1	2026-01-16 12:05:25.962236	it_block	\N	НУК
1836	320	1	2026-01-16 12:05:25.962875	ck_department	\N	Департамент цифровых продуктов
1837	320	1	2026-01-16 12:05:25.963303	placement_type	\N	аутстафф
1838	320	1	2026-01-16 12:05:25.963717	ready_for_vacancy	\N	Нет
1839	320	1	2026-01-16 12:05:25.964105	resume_link	\N	https://drive.google.com/file/53573
1840	320	1	2026-01-16 12:05:25.964476	manager_feedback	\N	Отличные результаты
1841	320	1	2026-01-16 12:05:25.964892	contacts	\N	+7 (987) 923-72-23, @поплюбо42, l.popova@rt.ru
1842	320	1	2026-01-16 12:05:25.965496	funding_end_date	\N	2025-05-24
1843	320	1	2026-01-16 12:05:25.965994	candidate_status	\N	В работе
1844	320	1	2026-01-16 12:05:25.966386	target_projects	\N	Госуслуги 2.0
1845	320	1	2026-01-16 12:05:25.966749	transfer_date	\N	
1846	320	1	2026-01-16 12:05:25.967102	recruiter	\N	Новикова Е.П.
1847	320	1	2026-01-16 12:05:25.967802	hr_bp	\N	Волкова Н.В.
1848	320	1	2026-01-16 12:05:25.968347	comments	\N	В процессе согласования
1849	321	1	2026-01-16 12:05:25.989888	entry_date	\N	2024-04-16
1850	321	1	2026-01-16 12:05:25.990539	current_manager	\N	Михайлова О.Н.
1851	321	1	2026-01-16 12:05:25.990999	it_block	\N	Эксплуатация
1852	321	1	2026-01-16 12:05:25.991417	ck_department	\N	ЦК Инфраструктуры
1853	321	1	2026-01-16 12:05:25.991818	placement_type	\N	перевод
1854	321	1	2026-01-16 12:05:25.992211	ready_for_vacancy	\N	Нет
1855	321	1	2026-01-16 12:05:25.992882	resume_link	\N	https://drive.google.com/file/27949
1856	321	1	2026-01-16 12:05:25.993659	manager_feedback	\N	Отличные результаты
1857	321	1	2026-01-16 12:05:25.994339	contacts	\N	+7 (994) 234-74-53, @никвикт37, v.nikitina@rt.ru
1858	321	1	2026-01-16 12:05:25.995012	funding_end_date	\N	2025-10-02
1859	321	1	2026-01-16 12:05:25.995673	candidate_status	\N	Забронирован
1860	321	1	2026-01-16 12:05:25.996156	target_projects	\N	Infrastructure, DevOps Platform, Госуслуги 2.0
1861	321	1	2026-01-16 12:05:25.996589	transfer_date	\N	
1862	321	1	2026-01-16 12:05:25.997004	recruiter	\N	Орлов М.С.
1863	321	1	2026-01-16 12:05:25.997502	hr_bp	\N	Лебедева Т.М.
1864	321	1	2026-01-16 12:05:25.997925	comments	\N	
1865	322	1	2026-01-16 12:05:26.027958	entry_date	\N	2024-01-06
1866	322	1	2026-01-16 12:05:26.029061	current_manager	\N	Петров С.М.
1867	322	1	2026-01-16 12:05:26.030294	it_block	\N	НУК
1868	322	1	2026-01-16 12:05:26.031147	ck_department	\N	ЦК Инфраструктуры
1869	322	1	2026-01-16 12:05:26.032284	placement_type	\N	перевод
1870	322	1	2026-01-16 12:05:26.033216	ready_for_vacancy	\N	Да
1871	322	1	2026-01-16 12:05:26.033975	resume_link	\N	https://drive.google.com/file/10102
1872	322	1	2026-01-16 12:05:26.035028	manager_feedback	\N	Рекомендую
1873	322	1	2026-01-16 12:05:26.035982	contacts	\N	+7 (906) 578-82-54, @андирин13, i.andreeva@rt.ru
1874	322	1	2026-01-16 12:05:26.036707	funding_end_date	\N	2026-08-23
1875	322	1	2026-01-16 12:05:26.037443	candidate_status	\N	Увольнение по СС
1876	322	1	2026-01-16 12:05:26.038199	target_projects	\N	ML Pipeline, Banking App
1877	322	1	2026-01-16 12:05:26.038885	transfer_date	\N	2025-05-09
1878	322	1	2026-01-16 12:05:26.039539	recruiter	\N	Новикова Е.П.
1879	322	1	2026-01-16 12:05:26.040179	hr_bp	\N	Морозов К.А.
1880	322	1	2026-01-16 12:05:26.040818	comments	\N	
1881	323	1	2026-01-16 12:05:26.071135	entry_date	\N	2025-10-18
1882	323	1	2026-01-16 12:05:26.071966	current_manager	\N	Михайлова О.Н.
1883	323	1	2026-01-16 12:05:26.072498	it_block	\N	НУК
1884	323	1	2026-01-16 12:05:26.072956	ck_department	\N	ЦК Аналитики
1885	323	1	2026-01-16 12:05:26.073464	placement_type	\N	аутстафф
1886	323	1	2026-01-16 12:05:26.073942	ready_for_vacancy	\N	Нет
1887	323	1	2026-01-16 12:05:26.074406	resume_link	\N	https://drive.google.com/file/10524
1888	323	1	2026-01-16 12:05:26.074915	manager_feedback	\N	Отличные результаты
1889	323	1	2026-01-16 12:05:26.075564	contacts	\N	+7 (944) 797-31-21, @серольг67, o.sergeeva@rt.ru
1890	323	1	2026-01-16 12:05:26.076211	funding_end_date	\N	2025-02-03
1891	323	1	2026-01-16 12:05:26.07667	candidate_status	\N	Свободен
1892	323	1	2026-01-16 12:05:26.077206	target_projects	\N	Data Platform
1893	323	1	2026-01-16 12:05:26.07826	transfer_date	\N	
1894	323	1	2026-01-16 12:05:26.079108	recruiter	\N	Смирнова А.А.
1895	323	1	2026-01-16 12:05:26.079991	hr_bp	\N	Волкова Н.В.
1896	323	1	2026-01-16 12:05:26.080925	comments	\N	
1897	324	1	2026-01-16 12:05:26.118752	entry_date	\N	2024-02-02
1898	324	1	2026-01-16 12:05:26.119636	current_manager	\N	Иванов А.П.
1899	324	1	2026-01-16 12:05:26.120257	it_block	\N	Прочее
1900	324	1	2026-01-16 12:05:26.120777	ck_department	\N	ЦК Аналитики
1901	324	1	2026-01-16 12:05:26.121315	placement_type	\N	аутстафф
1902	324	1	2026-01-16 12:05:26.121874	ready_for_vacancy	\N	Да
1903	324	1	2026-01-16 12:05:26.12294	resume_link	\N	https://drive.google.com/file/44356
1904	324	1	2026-01-16 12:05:26.123852	manager_feedback	\N	Отличные результаты
1905	324	1	2026-01-16 12:05:26.124743	contacts	\N	+7 (962) 867-80-17, @кисевге75, e.kiselev@rt.ru
1906	324	1	2026-01-16 12:05:26.12555	funding_end_date	\N	2025-03-29
1907	324	1	2026-01-16 12:05:26.126409	candidate_status	\N	Увольнение по СС
1908	324	1	2026-01-16 12:05:26.127251	target_projects	\N	DevOps Platform, Banking App, Mobile App
1909	324	1	2026-01-16 12:05:26.128479	transfer_date	\N	2026-06-03
1910	324	1	2026-01-16 12:05:26.129544	recruiter	\N	Белова И.Д.
1911	324	1	2026-01-16 12:05:26.130557	hr_bp	\N	Морозов К.А.
1912	324	1	2026-01-16 12:05:26.131258	comments	\N	Срочно нужен проект
1913	325	1	2026-01-16 12:05:26.168441	entry_date	\N	2024-01-22
1914	325	1	2026-01-16 12:05:26.169843	current_manager	\N	Иванов А.П.
1915	325	1	2026-01-16 12:05:26.171	it_block	\N	Диджитал
1916	325	1	2026-01-16 12:05:26.171866	ck_department	\N	Департамент цифровых продуктов
1917	325	1	2026-01-16 12:05:26.172589	placement_type	\N	аутстафф
1918	325	1	2026-01-16 12:05:26.173271	ready_for_vacancy	\N	Нет
1919	325	1	2026-01-16 12:05:26.17426	resume_link	\N	https://drive.google.com/file/52527
1920	325	1	2026-01-16 12:05:26.17503	manager_feedback	\N	Хороший специалист
1921	325	1	2026-01-16 12:05:26.175663	contacts	\N	+7 (952) 256-32-65, @зайтать23, t.zaytseva@rt.ru
1922	325	1	2026-01-16 12:05:26.176258	funding_end_date	\N	2026-06-23
1923	325	1	2026-01-16 12:05:26.176831	candidate_status	\N	Забронирован
1924	325	1	2026-01-16 12:05:26.17746	target_projects	\N	E-commerce Platform, Mobile App, DevOps Platform
1925	325	1	2026-01-16 12:05:26.178054	transfer_date	\N	
1926	325	1	2026-01-16 12:05:26.17863	recruiter	\N	Орлов М.С.
1927	325	1	2026-01-16 12:05:26.179195	hr_bp	\N	Морозов К.А.
1928	325	1	2026-01-16 12:05:26.179758	comments	\N	
1929	119	1	2026-01-16 12:05:26.217525	entry_date	\N	2025-06-05
1930	119	1	2026-01-16 12:05:26.218585	current_manager	\N	Михайлова О.Н.
1931	119	1	2026-01-16 12:05:26.219459	it_block	\N	Эксплуатация
1932	119	1	2026-01-16 12:05:26.220443	ck_department	\N	ЦК Разработки
1933	119	1	2026-01-16 12:05:26.221138	placement_type	\N	любой
1934	119	1	2026-01-16 12:05:26.221999	ready_for_vacancy	\N	Да
1935	119	1	2026-01-16 12:05:26.222751	resume_link	\N	https://drive.google.com/file/42991
1936	119	1	2026-01-16 12:05:26.223362	manager_feedback	\N	Хороший специалист
1937	119	1	2026-01-16 12:05:26.223975	contacts	\N	+7 (972) 935-11-69, @семкири58, petr.korolev103@company.ru
1938	119	1	2026-01-16 12:05:26.224578	funding_end_date	\N	2026-11-10
1939	119	1	2026-01-16 12:05:26.225152	candidate_status	\N	Увольнение по СЖ
1940	119	1	2026-01-16 12:05:26.226232	target_projects	\N	ML Pipeline, DevOps Platform, Banking App
1941	119	1	2026-01-16 12:05:26.226962	transfer_date	\N	2026-06-26
1942	119	1	2026-01-16 12:05:26.227577	recruiter	\N	Новикова Е.П.
1943	119	1	2026-01-16 12:05:26.228168	hr_bp	\N	Волкова Н.В.
1944	119	1	2026-01-16 12:05:26.228754	comments	\N	Ожидает оффер
1945	136	1	2026-01-16 12:05:26.265482	entry_date	\N	2024-06-04
1946	136	1	2026-01-16 12:05:26.266286	current_manager	\N	Петров С.М.
1947	136	1	2026-01-16 12:05:26.266868	it_block	\N	Прочее
1948	136	1	2026-01-16 12:05:26.267499	ck_department	\N	Департамент цифровых продуктов
1949	136	1	2026-01-16 12:05:26.26858	placement_type	\N	перевод
1950	136	1	2026-01-16 12:05:26.269799	ready_for_vacancy	\N	Нет
1951	136	1	2026-01-16 12:05:26.270435	resume_link	\N	https://drive.google.com/file/64988
1952	136	1	2026-01-16 12:05:26.27093	manager_feedback	\N	
1953	136	1	2026-01-16 12:05:26.271392	contacts	\N	+7 (954) 743-43-94, @смиилья15, denis.sokolov120@company.ru
1954	136	1	2026-01-16 12:05:26.272481	funding_end_date	\N	2026-11-19
1955	136	1	2026-01-16 12:05:26.273464	candidate_status	\N	Свободен
1956	136	1	2026-01-16 12:05:26.274194	target_projects	\N	DevOps Platform, Infrastructure
1957	136	1	2026-01-16 12:05:26.275082	transfer_date	\N	
1958	136	1	2026-01-16 12:05:26.275677	recruiter	\N	Орлов М.С.
1959	136	1	2026-01-16 12:05:26.276122	hr_bp	\N	Лебедева Т.М.
1960	136	1	2026-01-16 12:05:26.276524	comments	\N	
1961	123	1	2026-01-16 12:05:26.300793	entry_date	\N	2025-05-19
1962	123	1	2026-01-16 12:05:26.301735	current_manager	\N	Козлов Д.В.
1963	123	1	2026-01-16 12:05:26.302538	it_block	\N	Эксплуатация
1964	123	1	2026-01-16 12:05:26.303399	ck_department	\N	Департамент цифровых продуктов
1965	123	1	2026-01-16 12:05:26.304093	placement_type	\N	любой
1966	123	1	2026-01-16 12:05:26.304712	ready_for_vacancy	\N	Нет
1967	123	1	2026-01-16 12:05:26.30514	resume_link	\N	https://drive.google.com/file/51024
1968	123	1	2026-01-16 12:05:26.305686	manager_feedback	\N	Хороший специалист
1969	123	1	2026-01-16 12:05:26.306252	contacts	\N	+7 (965) 975-28-21, @попартё80, mikhail.mikhailov107@company.ru
1970	123	1	2026-01-16 12:05:26.30663	funding_end_date	\N	2026-07-02
1971	123	1	2026-01-16 12:05:26.306976	candidate_status	\N	Свободен
1972	123	1	2026-01-16 12:05:26.307336	target_projects	\N	Infrastructure, Banking App, Data Platform
1973	123	1	2026-01-16 12:05:26.307688	transfer_date	\N	
1974	123	1	2026-01-16 12:05:26.308025	recruiter	\N	Смирнова А.А.
1975	123	1	2026-01-16 12:05:26.308358	hr_bp	\N	Лебедева Т.М.
1976	123	1	2026-01-16 12:05:26.308689	comments	\N	В процессе согласования
1977	129	1	2026-01-16 12:05:26.331119	entry_date	\N	2024-07-02
1978	129	1	2026-01-16 12:05:26.332011	current_manager	\N	Козлов Д.В.
1979	129	1	2026-01-16 12:05:26.332756	it_block	\N	Развитие
1980	129	1	2026-01-16 12:05:26.333534	ck_department	\N	Департамент данных
1981	129	1	2026-01-16 12:05:26.334137	placement_type	\N	перевод
1982	129	1	2026-01-16 12:05:26.334775	ready_for_vacancy	\N	Да
1983	129	1	2026-01-16 12:05:26.335343	resume_link	\N	https://drive.google.com/file/16736
1984	129	1	2026-01-16 12:05:26.335909	manager_feedback	\N	Отличные результаты
1985	129	1	2026-01-16 12:05:26.336527	contacts	\N	+7 (982) 857-94-70, @фёдсерг17, anna.alexeev113@company.ru
1986	129	1	2026-01-16 12:05:26.337128	funding_end_date	\N	2025-12-30
1987	129	1	2026-01-16 12:05:26.337895	candidate_status	\N	Переведен
1988	129	1	2026-01-16 12:05:26.338411	target_projects	\N	Banking App, Госуслуги 2.0
1989	129	1	2026-01-16 12:05:26.338954	transfer_date	\N	2025-11-12
1990	129	1	2026-01-16 12:05:26.339608	recruiter	\N	Смирнова А.А.
1991	129	1	2026-01-16 12:05:26.340186	hr_bp	\N	Лебедева Т.М.
1992	129	1	2026-01-16 12:05:26.3407	comments	\N	
1993	134	1	2026-01-16 12:05:26.362053	entry_date	\N	2025-02-28
1994	134	1	2026-01-16 12:05:26.362684	current_manager	\N	Сидорова Е.К.
1995	134	1	2026-01-16 12:05:26.363113	it_block	\N	B2O
1996	134	1	2026-01-16 12:05:26.363491	ck_department	\N	Департамент цифровых продуктов
1997	134	1	2026-01-16 12:05:26.363855	placement_type	\N	перевод
1998	134	1	2026-01-16 12:05:26.364361	ready_for_vacancy	\N	Да
1999	134	1	2026-01-16 12:05:26.364728	resume_link	\N	https://drive.google.com/file/41153
2000	134	1	2026-01-16 12:05:26.365383	manager_feedback	\N	Отличные результаты
2001	134	1	2026-01-16 12:05:26.366024	contacts	\N	+7 (999) 171-26-96, @семкири19, vadim.zakharov118@company.ru
2002	134	1	2026-01-16 12:05:26.366513	funding_end_date	\N	2026-08-01
2003	134	1	2026-01-16 12:05:26.366889	candidate_status	\N	Увольнение по СС
2004	134	1	2026-01-16 12:05:26.367569	target_projects	\N	Banking App, ML Pipeline, E-commerce Platform
2005	134	1	2026-01-16 12:05:26.368241	transfer_date	\N	2025-10-01
2006	134	1	2026-01-16 12:05:26.368815	recruiter	\N	Смирнова А.А.
2007	134	1	2026-01-16 12:05:26.369394	hr_bp	\N	Лебедева Т.М.
2008	134	1	2026-01-16 12:05:26.369839	comments	\N	В процессе согласования
2009	326	1	2026-01-16 12:05:26.398652	entry_date	\N	2025-07-26
2010	326	1	2026-01-16 12:05:26.399578	current_manager	\N	Сидорова Е.К.
2011	326	1	2026-01-16 12:05:26.400558	it_block	\N	Прочее
2012	326	1	2026-01-16 12:05:26.401422	ck_department	\N	ЦК Аналитики
2013	326	1	2026-01-16 12:05:26.402147	placement_type	\N	перевод
2014	326	1	2026-01-16 12:05:26.403134	ready_for_vacancy	\N	Да
2015	326	1	2026-01-16 12:05:26.404104	resume_link	\N	https://drive.google.com/file/42968
2016	326	1	2026-01-16 12:05:26.404739	manager_feedback	\N	Отличные результаты
2017	326	1	2026-01-16 12:05:26.405298	contacts	\N	+7 (985) 694-29-67, @белвлад89, v.belov@rt.ru
2018	326	1	2026-01-16 12:05:26.405895	funding_end_date	\N	2026-08-18
2019	326	1	2026-01-16 12:05:26.406365	candidate_status	\N	В работе
2020	326	1	2026-01-16 12:05:26.406817	target_projects	\N	Data Platform
2021	326	1	2026-01-16 12:05:26.407265	transfer_date	\N	
2022	326	1	2026-01-16 12:05:26.407715	recruiter	\N	Новикова Е.П.
2023	326	1	2026-01-16 12:05:26.408163	hr_bp	\N	Морозов К.А.
2024	326	1	2026-01-16 12:05:26.408605	comments	\N	Ожидает оффер
2025	327	1	2026-01-16 12:05:26.442475	entry_date	\N	2025-07-07
2026	327	1	2026-01-16 12:05:26.443416	current_manager	\N	Петров С.М.
2027	327	1	2026-01-16 12:05:26.444065	it_block	\N	НУК
2028	327	1	2026-01-16 12:05:26.444638	ck_department	\N	ЦК Аналитики
2029	327	1	2026-01-16 12:05:26.44517	placement_type	\N	перевод
2030	327	1	2026-01-16 12:05:26.446058	ready_for_vacancy	\N	Да
2031	327	1	2026-01-16 12:05:26.446714	resume_link	\N	https://drive.google.com/file/92122
2032	327	1	2026-01-16 12:05:26.447262	manager_feedback	\N	Хороший специалист
2033	327	1	2026-01-16 12:05:26.447777	contacts	\N	+7 (968) 479-57-93, @белелен83, e.belova@rt.ru
2034	327	1	2026-01-16 12:05:26.448283	funding_end_date	\N	2025-01-03
2035	327	1	2026-01-16 12:05:26.448992	candidate_status	\N	Забронирован
2036	327	1	2026-01-16 12:05:26.449721	target_projects	\N	Mobile App, Infrastructure, Data Platform
2037	327	1	2026-01-16 12:05:26.450749	transfer_date	\N	
2038	327	1	2026-01-16 12:05:26.451853	recruiter	\N	Белова И.Д.
2039	327	1	2026-01-16 12:05:26.45285	hr_bp	\N	Волкова Н.В.
2040	327	1	2026-01-16 12:05:26.453605	comments	\N	
2041	328	1	2026-01-16 12:05:26.493534	entry_date	\N	2024-12-11
2042	328	1	2026-01-16 12:05:26.494548	current_manager	\N	Иванов А.П.
2043	328	1	2026-01-16 12:05:26.495326	it_block	\N	Развитие
2044	328	1	2026-01-16 12:05:26.495937	ck_department	\N	ЦК Разработки
2045	328	1	2026-01-16 12:05:26.496714	placement_type	\N	перевод
2046	328	1	2026-01-16 12:05:26.497348	ready_for_vacancy	\N	Да
2047	328	1	2026-01-16 12:05:26.497914	resume_link	\N	https://drive.google.com/file/94034
2048	328	1	2026-01-16 12:05:26.498404	manager_feedback	\N	
2213	332	1	2026-01-16 12:05:26.88619	transfer_date	\N	2025-02-27
2049	328	1	2026-01-16 12:05:26.498798	contacts	\N	+7 (987) 726-54-15, @захбогд55, b.zakharov@rt.ru
2050	328	1	2026-01-16 12:05:26.499228	funding_end_date	\N	2026-03-28
2051	328	1	2026-01-16 12:05:26.499593	candidate_status	\N	Увольнение по СЖ
2052	328	1	2026-01-16 12:05:26.499949	target_projects	\N	ML Pipeline, Infrastructure
2053	328	1	2026-01-16 12:05:26.500303	transfer_date	\N	2026-10-16
2054	328	1	2026-01-16 12:05:26.501059	recruiter	\N	Смирнова А.А.
2055	328	1	2026-01-16 12:05:26.501729	hr_bp	\N	Лебедева Т.М.
2056	328	1	2026-01-16 12:05:26.502342	comments	\N	В процессе согласования
2057	114	1	2026-01-16 12:05:26.534691	entry_date	\N	2025-06-22
2058	114	1	2026-01-16 12:05:26.5362	current_manager	\N	Михайлова О.Н.
2059	114	1	2026-01-16 12:05:26.537199	it_block	\N	Развитие
2060	114	1	2026-01-16 12:05:26.537915	ck_department	\N	ЦК Аналитики
2061	114	1	2026-01-16 12:05:26.538549	placement_type	\N	перевод
2062	114	1	2026-01-16 12:05:26.53905	ready_for_vacancy	\N	Да
2063	114	1	2026-01-16 12:05:26.539568	resume_link	\N	https://drive.google.com/file/83136
2064	114	1	2026-01-16 12:05:26.54011	manager_feedback	\N	Нужно развитие
2065	114	1	2026-01-16 12:05:26.540802	contacts	\N	+7 (968) 475-29-75, @фёдсерг17, yaroslav.pavlov98@company.ru
2066	114	1	2026-01-16 12:05:26.54153	funding_end_date	\N	2025-01-01
2067	114	1	2026-01-16 12:05:26.542194	candidate_status	\N	Свободен
2068	114	1	2026-01-16 12:05:26.542886	target_projects	\N	Mobile App, E-commerce Platform
2069	114	1	2026-01-16 12:05:26.543523	transfer_date	\N	
2070	114	1	2026-01-16 12:05:26.544201	recruiter	\N	Новикова Е.П.
2071	114	1	2026-01-16 12:05:26.544763	hr_bp	\N	Морозов К.А.
2072	114	1	2026-01-16 12:05:26.54528	comments	\N	Срочно нужен проект
2073	116	1	2026-01-16 12:05:26.572791	entry_date	\N	2025-03-29
2074	116	1	2026-01-16 12:05:26.573642	current_manager	\N	Иванов А.П.
2075	116	1	2026-01-16 12:05:26.574335	it_block	\N	Эксплуатация
2076	116	1	2026-01-16 12:05:26.574984	ck_department	\N	ЦК Аналитики
2077	116	1	2026-01-16 12:05:26.575621	placement_type	\N	аутстафф
2078	116	1	2026-01-16 12:05:26.576261	ready_for_vacancy	\N	Да
2079	116	1	2026-01-16 12:05:26.576894	resume_link	\N	https://drive.google.com/file/83025
2080	116	1	2026-01-16 12:05:26.577554	manager_feedback	\N	Нужно развитие
2081	116	1	2026-01-16 12:05:26.577966	contacts	\N	+7 (969) 336-41-75, @волмакс8, ruslan.zakharov100@company.ru
2082	116	1	2026-01-16 12:05:26.578706	funding_end_date	\N	2026-06-21
2083	116	1	2026-01-16 12:05:26.579345	candidate_status	\N	Увольнение по СС
2084	116	1	2026-01-16 12:05:26.579893	target_projects	\N	ML Pipeline
2085	116	1	2026-01-16 12:05:26.580542	transfer_date	\N	2026-09-27
2086	116	1	2026-01-16 12:05:26.581204	recruiter	\N	Орлов М.С.
2087	116	1	2026-01-16 12:05:26.582058	hr_bp	\N	Лебедева Т.М.
2088	116	1	2026-01-16 12:05:26.582924	comments	\N	Ожидает оффер
2089	115	1	2026-01-16 12:05:26.614073	entry_date	\N	2025-01-17
2090	115	1	2026-01-16 12:05:26.614768	current_manager	\N	Иванов А.П.
2091	115	1	2026-01-16 12:05:26.615306	it_block	\N	B2O
2092	115	1	2026-01-16 12:05:26.615734	ck_department	\N	ЦК Аналитики
2093	115	1	2026-01-16 12:05:26.616163	placement_type	\N	любой
2094	115	1	2026-01-16 12:05:26.616569	ready_for_vacancy	\N	Нет
2095	115	1	2026-01-16 12:05:26.616948	resume_link	\N	https://drive.google.com/file/73823
2096	115	1	2026-01-16 12:05:26.617479	manager_feedback	\N	
2097	115	1	2026-01-16 12:05:26.617937	contacts	\N	+7 (929) 841-10-78, @морники61, egor.fedorov99@company.ru
2098	115	1	2026-01-16 12:05:26.618459	funding_end_date	\N	2026-04-13
2099	115	1	2026-01-16 12:05:26.618929	candidate_status	\N	Свободен
2100	115	1	2026-01-16 12:05:26.619359	target_projects	\N	E-commerce Platform
2101	115	1	2026-01-16 12:05:26.619733	transfer_date	\N	
2102	115	1	2026-01-16 12:05:26.620083	recruiter	\N	Смирнова А.А.
2103	115	1	2026-01-16 12:05:26.620406	hr_bp	\N	Волкова Н.В.
2104	115	1	2026-01-16 12:05:26.620736	comments	\N	
2105	329	1	2026-01-16 12:05:26.653376	entry_date	\N	2024-01-19
2106	329	1	2026-01-16 12:05:26.654159	current_manager	\N	Иванов А.П.
2107	329	1	2026-01-16 12:05:26.655006	it_block	\N	Диджитал
2108	329	1	2026-01-16 12:05:26.655647	ck_department	\N	ЦК Инфраструктуры
2109	329	1	2026-01-16 12:05:26.656205	placement_type	\N	аутстафф
2110	329	1	2026-01-16 12:05:26.656934	ready_for_vacancy	\N	Да
2111	329	1	2026-01-16 12:05:26.657676	resume_link	\N	https://drive.google.com/file/49912
2112	329	1	2026-01-16 12:05:26.658167	manager_feedback	\N	
2113	329	1	2026-01-16 12:05:26.658579	contacts	\N	+7 (977) 687-76-27, @вормарк29, m.vorobev@rt.ru
2114	329	1	2026-01-16 12:05:26.658941	funding_end_date	\N	2026-09-11
2115	329	1	2026-01-16 12:05:26.65928	candidate_status	\N	Забронирован
2116	329	1	2026-01-16 12:05:26.659616	target_projects	\N	ML Pipeline
2117	329	1	2026-01-16 12:05:26.659949	transfer_date	\N	
2118	329	1	2026-01-16 12:05:26.660278	recruiter	\N	Смирнова А.А.
2119	329	1	2026-01-16 12:05:26.660607	hr_bp	\N	Морозов К.А.
2120	329	1	2026-01-16 12:05:26.661144	comments	\N	Срочно нужен проект
2121	137	1	2026-01-16 12:05:26.683434	entry_date	\N	2024-10-07
2122	137	1	2026-01-16 12:05:26.684247	current_manager	\N	Петров С.М.
2123	137	1	2026-01-16 12:05:26.685054	it_block	\N	Эксплуатация
2124	137	1	2026-01-16 12:05:26.685902	ck_department	\N	Департамент цифровых продуктов
2125	137	1	2026-01-16 12:05:26.686673	placement_type	\N	любой
2126	137	1	2026-01-16 12:05:26.687632	ready_for_vacancy	\N	Да
2127	137	1	2026-01-16 12:05:26.688326	resume_link	\N	https://drive.google.com/file/24186
2128	137	1	2026-01-16 12:05:26.688875	manager_feedback	\N	Хороший специалист
2129	137	1	2026-01-16 12:05:26.68953	contacts	\N	+7 (944) 598-52-97, @куздени4, ilya.ivanov121@company.ru
2130	137	1	2026-01-16 12:05:26.690266	funding_end_date	\N	2025-07-23
2131	137	1	2026-01-16 12:05:26.690916	candidate_status	\N	Забронирован
2132	137	1	2026-01-16 12:05:26.691481	target_projects	\N	ML Pipeline, Data Platform
2133	137	1	2026-01-16 12:05:26.692038	transfer_date	\N	
2134	137	1	2026-01-16 12:05:26.692566	recruiter	\N	Белова И.Д.
2135	137	1	2026-01-16 12:05:26.692949	hr_bp	\N	Волкова Н.В.
2136	137	1	2026-01-16 12:05:26.693378	comments	\N	
2137	138	1	2026-01-16 12:05:26.721414	entry_date	\N	2024-11-20
2138	138	1	2026-01-16 12:05:26.72217	current_manager	\N	Михайлова О.Н.
2139	138	1	2026-01-16 12:05:26.72292	it_block	\N	Прочее
2140	138	1	2026-01-16 12:05:26.723624	ck_department	\N	ЦК Аналитики
2141	138	1	2026-01-16 12:05:26.724399	placement_type	\N	аутстафф
2142	138	1	2026-01-16 12:05:26.725217	ready_for_vacancy	\N	Да
2143	138	1	2026-01-16 12:05:26.726	resume_link	\N	https://drive.google.com/file/68098
2144	138	1	2026-01-16 12:05:26.726617	manager_feedback	\N	Рекомендую
2145	138	1	2026-01-16 12:05:26.727213	contacts	\N	+7 (981) 183-39-29, @попартё13, artem.vorobyov122@company.ru
2146	138	1	2026-01-16 12:05:26.727634	funding_end_date	\N	2025-02-13
2147	138	1	2026-01-16 12:05:26.728042	candidate_status	\N	Переведен
2148	138	1	2026-01-16 12:05:26.72875	target_projects	\N	Госуслуги 2.0, DevOps Platform
2149	138	1	2026-01-16 12:05:26.72935	transfer_date	\N	2025-08-27
2150	138	1	2026-01-16 12:05:26.729981	recruiter	\N	Смирнова А.А.
2151	138	1	2026-01-16 12:05:26.730501	hr_bp	\N	Морозов К.А.
2152	138	1	2026-01-16 12:05:26.731169	comments	\N	Ожидает оффер
2153	147	1	2026-01-16 12:05:26.75421	entry_date	\N	2025-03-18
2154	147	1	2026-01-16 12:05:26.755079	current_manager	\N	Сидорова Е.К.
2155	147	1	2026-01-16 12:05:26.75587	it_block	\N	НУК
2156	147	1	2026-01-16 12:05:26.756869	ck_department	\N	Департамент данных
2157	147	1	2026-01-16 12:05:26.75764	placement_type	\N	аутстафф
2158	147	1	2026-01-16 12:05:26.758422	ready_for_vacancy	\N	Нет
2159	147	1	2026-01-16 12:05:26.75933	resume_link	\N	https://drive.google.com/file/98151
2160	147	1	2026-01-16 12:05:26.760122	manager_feedback	\N	Хороший специалист
2161	147	1	2026-01-16 12:05:26.760894	contacts	\N	+7 (946) 455-70-36, @алемиха17, mikhail.grigoriev131@company.ru
2162	147	1	2026-01-16 12:05:26.761756	funding_end_date	\N	2026-08-30
2163	147	1	2026-01-16 12:05:26.76243	candidate_status	\N	Увольнение по СЖ
2164	147	1	2026-01-16 12:05:26.763183	target_projects	\N	DevOps Platform, ML Pipeline
2165	147	1	2026-01-16 12:05:26.763913	transfer_date	\N	2025-01-19
2166	147	1	2026-01-16 12:05:26.764525	recruiter	\N	Белова И.Д.
2167	147	1	2026-01-16 12:05:26.765107	hr_bp	\N	Лебедева Т.М.
2168	147	1	2026-01-16 12:05:26.765788	comments	\N	
2169	330	1	2026-01-16 12:05:26.79304	entry_date	\N	2024-09-23
2170	330	1	2026-01-16 12:05:26.793764	current_manager	\N	Иванов А.П.
2171	330	1	2026-01-16 12:05:26.794218	it_block	\N	Эксплуатация
2172	330	1	2026-01-16 12:05:26.794771	ck_department	\N	Департамент цифровых продуктов
2173	330	1	2026-01-16 12:05:26.79543	placement_type	\N	перевод
2174	330	1	2026-01-16 12:05:26.796445	ready_for_vacancy	\N	Нет
2175	330	1	2026-01-16 12:05:26.797445	resume_link	\N	https://drive.google.com/file/72730
2176	330	1	2026-01-16 12:05:26.798068	manager_feedback	\N	Рекомендую
2177	330	1	2026-01-16 12:05:26.798707	contacts	\N	+7 (999) 724-52-90, @зайалек81, a.zaytsev@rt.ru
2178	330	1	2026-01-16 12:05:26.799577	funding_end_date	\N	2025-07-31
2179	330	1	2026-01-16 12:05:26.80035	candidate_status	\N	Переведен
2180	330	1	2026-01-16 12:05:26.801494	target_projects	\N	Госуслуги 2.0, Infrastructure, ML Pipeline
2181	330	1	2026-01-16 12:05:26.802076	transfer_date	\N	2025-10-20
2182	330	1	2026-01-16 12:05:26.80287	recruiter	\N	Новикова Е.П.
2183	330	1	2026-01-16 12:05:26.803734	hr_bp	\N	Лебедева Т.М.
2184	330	1	2026-01-16 12:05:26.804175	comments	\N	В процессе согласования
2185	331	1	2026-01-16 12:05:26.831955	entry_date	\N	2024-02-19
2186	331	1	2026-01-16 12:05:26.832773	current_manager	\N	Петров С.М.
2187	331	1	2026-01-16 12:05:26.833465	it_block	\N	Развитие
2188	331	1	2026-01-16 12:05:26.833875	ck_department	\N	ЦК Аналитики
2189	331	1	2026-01-16 12:05:26.834379	placement_type	\N	перевод
2190	331	1	2026-01-16 12:05:26.834889	ready_for_vacancy	\N	Нет
2191	331	1	2026-01-16 12:05:26.835697	resume_link	\N	https://drive.google.com/file/65294
2192	331	1	2026-01-16 12:05:26.836831	manager_feedback	\N	Нужно развитие
2193	331	1	2026-01-16 12:05:26.837574	contacts	\N	+7 (958) 860-61-98, @сокарсе12, a.sokolov@rt.ru
2194	331	1	2026-01-16 12:05:26.838329	funding_end_date	\N	2025-11-01
2195	331	1	2026-01-16 12:05:26.838955	candidate_status	\N	Увольнение по СС
2196	331	1	2026-01-16 12:05:26.83984	target_projects	\N	Mobile App
2197	331	1	2026-01-16 12:05:26.840456	transfer_date	\N	2026-06-21
2198	331	1	2026-01-16 12:05:26.841142	recruiter	\N	Смирнова А.А.
2199	331	1	2026-01-16 12:05:26.841885	hr_bp	\N	Морозов К.А.
2200	331	1	2026-01-16 12:05:26.842549	comments	\N	
2201	332	1	2026-01-16 12:05:26.877627	entry_date	\N	2024-06-05
2202	332	1	2026-01-16 12:05:26.878701	current_manager	\N	Сидорова Е.К.
2203	332	1	2026-01-16 12:05:26.879321	it_block	\N	Эксплуатация
2204	332	1	2026-01-16 12:05:26.879967	ck_department	\N	ЦК Инфраструктуры
2205	332	1	2026-01-16 12:05:26.880786	placement_type	\N	перевод
2206	332	1	2026-01-16 12:05:26.881567	ready_for_vacancy	\N	Да
2207	332	1	2026-01-16 12:05:26.882369	resume_link	\N	https://drive.google.com/file/48921
2208	332	1	2026-01-16 12:05:26.882941	manager_feedback	\N	Хороший специалист
2209	332	1	2026-01-16 12:05:26.883705	contacts	\N	+7 (930) 399-59-55, @смиалин12, a.smirnova@rt.ru
2210	332	1	2026-01-16 12:05:26.884353	funding_end_date	\N	2025-05-18
2211	332	1	2026-01-16 12:05:26.885168	candidate_status	\N	Увольнение по СС
2212	332	1	2026-01-16 12:05:26.885762	target_projects	\N	Mobile App
2214	332	1	2026-01-16 12:05:26.886787	recruiter	\N	Смирнова А.А.
2215	332	1	2026-01-16 12:05:26.887526	hr_bp	\N	Волкова Н.В.
2216	332	1	2026-01-16 12:05:26.888186	comments	\N	Срочно нужен проект
2217	333	1	2026-01-16 12:05:26.915871	entry_date	\N	2025-12-10
2218	333	1	2026-01-16 12:05:26.916489	current_manager	\N	Иванов А.П.
2219	333	1	2026-01-16 12:05:26.916895	it_block	\N	НУК
2220	333	1	2026-01-16 12:05:26.918213	ck_department	\N	ЦК Аналитики
2221	333	1	2026-01-16 12:05:26.918776	placement_type	\N	аутстафф
2222	333	1	2026-01-16 12:05:26.919394	ready_for_vacancy	\N	Да
2223	333	1	2026-01-16 12:05:26.92014	resume_link	\N	https://drive.google.com/file/71472
2224	333	1	2026-01-16 12:05:26.92066	manager_feedback	\N	
2225	333	1	2026-01-16 12:05:26.92133	contacts	\N	+7 (988) 537-61-56, @алемари56, m.alekseeva@rt.ru
2226	333	1	2026-01-16 12:05:26.921981	funding_end_date	\N	2025-03-10
2227	333	1	2026-01-16 12:05:26.922585	candidate_status	\N	Свободен
2228	333	1	2026-01-16 12:05:26.923484	target_projects	\N	E-commerce Platform, Mobile App
2229	333	1	2026-01-16 12:05:26.924357	transfer_date	\N	
2230	333	1	2026-01-16 12:05:26.925022	recruiter	\N	Белова И.Д.
2231	333	1	2026-01-16 12:05:26.925697	hr_bp	\N	Лебедева Т.М.
2232	333	1	2026-01-16 12:05:26.926342	comments	\N	Ожидает оффер
2233	334	1	2026-01-16 12:05:26.947615	entry_date	\N	2024-06-03
2234	334	1	2026-01-16 12:05:26.948278	current_manager	\N	Козлов Д.В.
2235	334	1	2026-01-16 12:05:26.948726	it_block	\N	Диджитал
2236	334	1	2026-01-16 12:05:26.949086	ck_department	\N	ЦК Разработки
2237	334	1	2026-01-16 12:05:26.949533	placement_type	\N	аутстафф
2238	334	1	2026-01-16 12:05:26.949946	ready_for_vacancy	\N	Да
2239	334	1	2026-01-16 12:05:26.950535	resume_link	\N	https://drive.google.com/file/83521
2240	334	1	2026-01-16 12:05:26.951054	manager_feedback	\N	Нужно развитие
2241	334	1	2026-01-16 12:05:26.951635	contacts	\N	+7 (958) 539-60-14, @захалек65, a.zakharov@rt.ru
2242	334	1	2026-01-16 12:05:26.95213	funding_end_date	\N	2026-11-10
2243	334	1	2026-01-16 12:05:26.952534	candidate_status	\N	Переведен
2244	334	1	2026-01-16 12:05:26.953004	target_projects	\N	E-commerce Platform, DevOps Platform, Mobile App
2245	334	1	2026-01-16 12:05:26.953436	transfer_date	\N	2026-05-09
2246	334	1	2026-01-16 12:05:26.953806	recruiter	\N	Орлов М.С.
2247	334	1	2026-01-16 12:05:26.954145	hr_bp	\N	Морозов К.А.
2248	334	1	2026-01-16 12:05:26.954552	comments	\N	
2249	335	1	2026-01-16 12:05:26.974602	entry_date	\N	2025-12-11
2250	335	1	2026-01-16 12:05:26.97518	current_manager	\N	Козлов Д.В.
2251	335	1	2026-01-16 12:05:26.975638	it_block	\N	Прочее
2252	335	1	2026-01-16 12:05:26.97603	ck_department	\N	ЦК Разработки
2253	335	1	2026-01-16 12:05:26.976375	placement_type	\N	аутстафф
2254	335	1	2026-01-16 12:05:26.976952	ready_for_vacancy	\N	Да
2255	335	1	2026-01-16 12:05:26.977511	resume_link	\N	https://drive.google.com/file/28594
2256	335	1	2026-01-16 12:05:26.97791	manager_feedback	\N	
2257	335	1	2026-01-16 12:05:26.978269	contacts	\N	+7 (994) 989-93-76, @феддани36, d.fedorov@rt.ru
2258	335	1	2026-01-16 12:05:26.978608	funding_end_date	\N	2025-04-14
2259	335	1	2026-01-16 12:05:26.978966	candidate_status	\N	В работе
2260	335	1	2026-01-16 12:05:26.979311	target_projects	\N	Banking App, Госуслуги 2.0, Infrastructure
2261	335	1	2026-01-16 12:05:26.979648	transfer_date	\N	
2262	335	1	2026-01-16 12:05:26.979993	recruiter	\N	Белова И.Д.
2263	335	1	2026-01-16 12:05:26.980315	hr_bp	\N	Морозов К.А.
2264	335	1	2026-01-16 12:05:26.980643	comments	\N	Ожидает оффер
2265	336	1	2026-01-16 12:05:27.007717	entry_date	\N	2025-07-15
2266	336	1	2026-01-16 12:05:27.008321	current_manager	\N	Петров С.М.
2267	336	1	2026-01-16 12:05:27.008752	it_block	\N	Эксплуатация
2268	336	1	2026-01-16 12:05:27.009126	ck_department	\N	Департамент данных
2269	336	1	2026-01-16 12:05:27.009688	placement_type	\N	любой
2270	336	1	2026-01-16 12:05:27.010057	ready_for_vacancy	\N	Нет
2271	336	1	2026-01-16 12:05:27.010781	resume_link	\N	https://drive.google.com/file/34014
2272	336	1	2026-01-16 12:05:27.011247	manager_feedback	\N	Нужно развитие
2273	336	1	2026-01-16 12:05:27.01162	contacts	\N	+7 (955) 180-12-95, @тарксен91, k.tarasova@rt.ru
2274	336	1	2026-01-16 12:05:27.011974	funding_end_date	\N	2025-01-17
2275	336	1	2026-01-16 12:05:27.012321	candidate_status	\N	Забронирован
2276	336	1	2026-01-16 12:05:27.012668	target_projects	\N	Data Platform
2277	336	1	2026-01-16 12:05:27.013025	transfer_date	\N	
2278	336	1	2026-01-16 12:05:27.013483	recruiter	\N	Орлов М.С.
2279	336	1	2026-01-16 12:05:27.014044	hr_bp	\N	Волкова Н.В.
2280	336	1	2026-01-16 12:05:27.0147	comments	\N	Ожидает оффер
2281	337	1	2026-01-16 12:05:27.036568	entry_date	\N	2025-08-28
2282	337	1	2026-01-16 12:05:27.0372	current_manager	\N	Сидорова Е.К.
2283	337	1	2026-01-16 12:05:27.037976	it_block	\N	Прочее
2284	337	1	2026-01-16 12:05:27.03871	ck_department	\N	ЦК Аналитики
2285	337	1	2026-01-16 12:05:27.039284	placement_type	\N	аутстафф
2286	337	1	2026-01-16 12:05:27.039846	ready_for_vacancy	\N	Нет
2287	337	1	2026-01-16 12:05:27.040341	resume_link	\N	https://drive.google.com/file/42964
2288	337	1	2026-01-16 12:05:27.0411	manager_feedback	\N	Рекомендую
2289	337	1	2026-01-16 12:05:27.041824	contacts	\N	+7 (954) 898-89-11, @меданто84, a.medvedev@rt.ru
2290	337	1	2026-01-16 12:05:27.042347	funding_end_date	\N	2025-04-09
2291	337	1	2026-01-16 12:05:27.042756	candidate_status	\N	Увольнение по СЖ
2292	337	1	2026-01-16 12:05:27.043118	target_projects	\N	E-commerce Platform, Госуслуги 2.0
2293	337	1	2026-01-16 12:05:27.043466	transfer_date	\N	2025-09-09
2294	337	1	2026-01-16 12:05:27.043809	recruiter	\N	Орлов М.С.
2295	337	1	2026-01-16 12:05:27.044147	hr_bp	\N	Лебедева Т.М.
2296	337	1	2026-01-16 12:05:27.044477	comments	\N	
2297	338	1	2026-01-16 12:05:27.064711	entry_date	\N	2024-06-22
2298	338	1	2026-01-16 12:05:27.065682	current_manager	\N	Сидорова Е.К.
2299	338	1	2026-01-16 12:05:27.066241	it_block	\N	НУК
2300	338	1	2026-01-16 12:05:27.067143	ck_department	\N	Департамент цифровых продуктов
2301	338	1	2026-01-16 12:05:27.067846	placement_type	\N	аутстафф
2302	338	1	2026-01-16 12:05:27.068588	ready_for_vacancy	\N	Нет
2303	338	1	2026-01-16 12:05:27.069108	resume_link	\N	https://drive.google.com/file/83024
2304	338	1	2026-01-16 12:05:27.069842	manager_feedback	\N	Отличные результаты
2305	338	1	2026-01-16 12:05:27.07037	contacts	\N	+7 (946) 540-22-53, @михалек74, a.mikhaylova@rt.ru
2306	338	1	2026-01-16 12:05:27.070752	funding_end_date	\N	2025-08-03
2307	338	1	2026-01-16 12:05:27.07111	candidate_status	\N	Увольнение по СС
2308	338	1	2026-01-16 12:05:27.071469	target_projects	\N	ML Pipeline, E-commerce Platform
2309	338	1	2026-01-16 12:05:27.071838	transfer_date	\N	2026-10-17
2310	338	1	2026-01-16 12:05:27.072509	recruiter	\N	Новикова Е.П.
2311	338	1	2026-01-16 12:05:27.073027	hr_bp	\N	Волкова Н.В.
2312	338	1	2026-01-16 12:05:27.073757	comments	\N	
2313	339	1	2026-01-16 12:05:27.096531	entry_date	\N	2025-01-27
2314	339	1	2026-01-16 12:05:27.097316	current_manager	\N	Иванов А.П.
2315	339	1	2026-01-16 12:05:27.098078	it_block	\N	Развитие
2316	339	1	2026-01-16 12:05:27.09862	ck_department	\N	Департамент данных
2317	339	1	2026-01-16 12:05:27.099128	placement_type	\N	аутстафф
2318	339	1	2026-01-16 12:05:27.099642	ready_for_vacancy	\N	Нет
2319	339	1	2026-01-16 12:05:27.100147	resume_link	\N	https://drive.google.com/file/17968
2320	339	1	2026-01-16 12:05:27.100671	manager_feedback	\N	
2321	339	1	2026-01-16 12:05:27.101523	contacts	\N	+7 (999) 240-10-43, @антстеп81, s.antonov@rt.ru
2322	339	1	2026-01-16 12:05:27.102165	funding_end_date	\N	2025-01-13
2323	339	1	2026-01-16 12:05:27.102803	candidate_status	\N	Увольнение по СС
2324	339	1	2026-01-16 12:05:27.103886	target_projects	\N	Mobile App, DevOps Platform, E-commerce Platform
2325	339	1	2026-01-16 12:05:27.104634	transfer_date	\N	2025-09-30
2326	339	1	2026-01-16 12:05:27.105217	recruiter	\N	Белова И.Д.
2327	339	1	2026-01-16 12:05:27.105858	hr_bp	\N	Морозов К.А.
2328	339	1	2026-01-16 12:05:27.10641	comments	\N	
2329	340	1	2026-01-16 12:05:27.142656	entry_date	\N	2025-03-17
2330	340	1	2026-01-16 12:05:27.143999	current_manager	\N	Михайлова О.Н.
2331	340	1	2026-01-16 12:05:27.145405	it_block	\N	НУК
2332	340	1	2026-01-16 12:05:27.146125	ck_department	\N	Департамент цифровых продуктов
2333	340	1	2026-01-16 12:05:27.146703	placement_type	\N	аутстафф
2334	340	1	2026-01-16 12:05:27.14731	ready_for_vacancy	\N	Да
2335	340	1	2026-01-16 12:05:27.148132	resume_link	\N	https://drive.google.com/file/37582
2336	340	1	2026-01-16 12:05:27.149198	manager_feedback	\N	
2337	340	1	2026-01-16 12:05:27.150178	contacts	\N	+7 (993) 461-91-88, @моранас51, a.morozova@rt.ru
2338	340	1	2026-01-16 12:05:27.151058	funding_end_date	\N	2025-08-09
2339	340	1	2026-01-16 12:05:27.152198	candidate_status	\N	Увольнение по СЖ
2340	340	1	2026-01-16 12:05:27.153176	target_projects	\N	Mobile App, Infrastructure
2341	340	1	2026-01-16 12:05:27.154123	transfer_date	\N	2026-01-07
2342	340	1	2026-01-16 12:05:27.154984	recruiter	\N	Смирнова А.А.
2343	340	1	2026-01-16 12:05:27.155856	hr_bp	\N	Морозов К.А.
2344	340	1	2026-01-16 12:05:27.156663	comments	\N	
2345	341	1	2026-01-16 12:05:27.192242	entry_date	\N	2024-12-11
2346	341	1	2026-01-16 12:05:27.193201	current_manager	\N	Михайлова О.Н.
2347	341	1	2026-01-16 12:05:27.194176	it_block	\N	B2O
2348	341	1	2026-01-16 12:05:27.194899	ck_department	\N	ЦК Инфраструктуры
2349	341	1	2026-01-16 12:05:27.195509	placement_type	\N	аутстафф
2350	341	1	2026-01-16 12:05:27.196084	ready_for_vacancy	\N	Да
2351	341	1	2026-01-16 12:05:27.196647	resume_link	\N	https://drive.google.com/file/48365
2352	341	1	2026-01-16 12:05:27.197185	manager_feedback	\N	Отличные результаты
2353	341	1	2026-01-16 12:05:27.197883	contacts	\N	+7 (997) 460-94-12, @зайксен84, k.zaytseva@rt.ru
2354	341	1	2026-01-16 12:05:27.198416	funding_end_date	\N	2026-06-24
2355	341	1	2026-01-16 12:05:27.198928	candidate_status	\N	Увольнение по СС
2356	341	1	2026-01-16 12:05:27.199835	target_projects	\N	Mobile App, Infrastructure
2357	341	1	2026-01-16 12:05:27.200369	transfer_date	\N	2025-08-15
2358	341	1	2026-01-16 12:05:27.201101	recruiter	\N	Белова И.Д.
2359	341	1	2026-01-16 12:05:27.202236	hr_bp	\N	Лебедева Т.М.
2360	341	1	2026-01-16 12:05:27.203557	comments	\N	
2361	342	1	2026-01-16 12:05:27.233461	entry_date	\N	2025-05-21
2362	342	1	2026-01-16 12:05:27.234229	current_manager	\N	Михайлова О.Н.
2363	342	1	2026-01-16 12:05:27.234802	it_block	\N	B2O
2364	342	1	2026-01-16 12:05:27.235322	ck_department	\N	ЦК Инфраструктуры
2365	342	1	2026-01-16 12:05:27.235964	placement_type	\N	перевод
2366	342	1	2026-01-16 12:05:27.236651	ready_for_vacancy	\N	Нет
2367	342	1	2026-01-16 12:05:27.237263	resume_link	\N	https://drive.google.com/file/75144
2368	342	1	2026-01-16 12:05:27.237941	manager_feedback	\N	
2369	342	1	2026-01-16 12:05:27.238434	contacts	\N	+7 (929) 891-53-52, @винмари2, m.vinogradova@rt.ru
2370	342	1	2026-01-16 12:05:27.239207	funding_end_date	\N	2026-11-05
2371	342	1	2026-01-16 12:05:27.239879	candidate_status	\N	Свободен
2372	342	1	2026-01-16 12:05:27.24029	target_projects	\N	Mobile App, ML Pipeline, Data Platform
2373	342	1	2026-01-16 12:05:27.240641	transfer_date	\N	
2374	342	1	2026-01-16 12:05:27.241088	recruiter	\N	Орлов М.С.
2375	342	1	2026-01-16 12:05:27.241733	hr_bp	\N	Волкова Н.В.
2376	342	1	2026-01-16 12:05:27.242373	comments	\N	Срочно нужен проект
2377	343	1	2026-01-16 12:05:27.261723	entry_date	\N	2025-11-10
2378	343	1	2026-01-16 12:05:27.262325	current_manager	\N	Михайлова О.Н.
2379	343	1	2026-01-16 12:05:27.262752	it_block	\N	B2O
2380	343	1	2026-01-16 12:05:27.263305	ck_department	\N	ЦК Разработки
2381	343	1	2026-01-16 12:05:27.263919	placement_type	\N	перевод
2382	343	1	2026-01-16 12:05:27.264304	ready_for_vacancy	\N	Да
2383	343	1	2026-01-16 12:05:27.264653	resume_link	\N	https://drive.google.com/file/33158
2384	343	1	2026-01-16 12:05:27.264987	manager_feedback	\N	Нужно развитие
2385	343	1	2026-01-16 12:05:27.265617	contacts	\N	+7 (962) 986-74-57, @никанто20, a.nikolaev@rt.ru
2386	343	1	2026-01-16 12:05:27.266423	funding_end_date	\N	2025-10-04
2387	343	1	2026-01-16 12:05:27.267096	candidate_status	\N	Забронирован
2388	343	1	2026-01-16 12:05:27.26791	target_projects	\N	Banking App, E-commerce Platform, Госуслуги 2.0
2389	343	1	2026-01-16 12:05:27.268437	transfer_date	\N	
2390	343	1	2026-01-16 12:05:27.269093	recruiter	\N	Орлов М.С.
2391	343	1	2026-01-16 12:05:27.269749	hr_bp	\N	Морозов К.А.
2392	343	1	2026-01-16 12:05:27.270331	comments	\N	
2393	344	1	2026-01-16 12:05:27.30944	entry_date	\N	2024-08-13
2394	344	1	2026-01-16 12:05:27.310347	current_manager	\N	Петров С.М.
2395	344	1	2026-01-16 12:05:27.311018	it_block	\N	Развитие
2396	344	1	2026-01-16 12:05:27.311566	ck_department	\N	Департамент цифровых продуктов
2397	344	1	2026-01-16 12:05:27.312089	placement_type	\N	перевод
2398	344	1	2026-01-16 12:05:27.31261	ready_for_vacancy	\N	Да
2399	344	1	2026-01-16 12:05:27.313117	resume_link	\N	https://drive.google.com/file/95795
2400	344	1	2026-01-16 12:05:27.313844	manager_feedback	\N	
2401	344	1	2026-01-16 12:05:27.314465	contacts	\N	+7 (987) 604-30-30, @анттать67, t.antonova@rt.ru
2402	344	1	2026-01-16 12:05:27.314997	funding_end_date	\N	2026-10-21
2403	344	1	2026-01-16 12:05:27.315495	candidate_status	\N	Забронирован
2404	344	1	2026-01-16 12:05:27.315983	target_projects	\N	Госуслуги 2.0, E-commerce Platform, Mobile App
2405	344	1	2026-01-16 12:05:27.316604	transfer_date	\N	
2406	344	1	2026-01-16 12:05:27.317678	recruiter	\N	Орлов М.С.
2407	344	1	2026-01-16 12:05:27.318304	hr_bp	\N	Лебедева Т.М.
2408	344	1	2026-01-16 12:05:27.31884	comments	\N	Срочно нужен проект
2409	363	1	2026-01-16 12:05:27.36529	entry_date	\N	2024-09-04
2410	363	1	2026-01-16 12:05:27.366166	current_manager	\N	Иванов А.П.
2411	363	1	2026-01-16 12:05:27.366617	it_block	\N	Эксплуатация
2412	363	1	2026-01-16 12:05:27.366998	ck_department	\N	ЦК Разработки
2413	363	1	2026-01-16 12:05:27.36767	placement_type	\N	аутстафф
2414	363	1	2026-01-16 12:05:27.368301	ready_for_vacancy	\N	Да
2415	363	1	2026-01-16 12:05:27.368725	resume_link	\N	https://drive.google.com/file/62423
2416	363	1	2026-01-16 12:05:27.369082	manager_feedback	\N	
2417	363	1	2026-01-16 12:05:27.369489	contacts	\N	+7 (998) 939-65-63, @лебанна45, a.lebedeva@rt.ru
2418	363	1	2026-01-16 12:05:27.369856	funding_end_date	\N	2025-06-25
2419	363	1	2026-01-16 12:05:27.370377	candidate_status	\N	Увольнение по СС
2420	363	1	2026-01-16 12:05:27.370903	target_projects	\N	ML Pipeline, Data Platform, Infrastructure
2421	363	1	2026-01-16 12:05:27.37134	transfer_date	\N	2025-06-30
2422	363	1	2026-01-16 12:05:27.371726	recruiter	\N	Смирнова А.А.
2423	363	1	2026-01-16 12:05:27.372122	hr_bp	\N	Морозов К.А.
2424	363	1	2026-01-16 12:05:27.372493	comments	\N	
2425	364	1	2026-01-16 12:05:27.406078	entry_date	\N	2025-05-15
2426	364	1	2026-01-16 12:05:27.406951	current_manager	\N	Козлов Д.В.
2427	364	1	2026-01-16 12:05:27.407722	it_block	\N	Прочее
2428	364	1	2026-01-16 12:05:27.408423	ck_department	\N	ЦК Аналитики
2429	364	1	2026-01-16 12:05:27.409143	placement_type	\N	любой
2430	364	1	2026-01-16 12:05:27.409752	ready_for_vacancy	\N	Нет
2431	364	1	2026-01-16 12:05:27.410157	resume_link	\N	https://drive.google.com/file/50010
2432	364	1	2026-01-16 12:05:27.410515	manager_feedback	\N	
2433	364	1	2026-01-16 12:05:27.410857	contacts	\N	+7 (994) 735-58-44, @борвале91, v.borisova@rt.ru
2434	364	1	2026-01-16 12:05:27.411197	funding_end_date	\N	2025-09-10
2435	364	1	2026-01-16 12:05:27.412077	candidate_status	\N	Переведен
2436	364	1	2026-01-16 12:05:27.412972	target_projects	\N	DevOps Platform, Mobile App
2437	364	1	2026-01-16 12:05:27.413742	transfer_date	\N	2025-10-16
2438	364	1	2026-01-16 12:05:27.414752	recruiter	\N	Орлов М.С.
2439	364	1	2026-01-16 12:05:27.415497	hr_bp	\N	Морозов К.А.
2440	364	1	2026-01-16 12:05:27.416394	comments	\N	В процессе согласования
2441	172	1	2026-01-16 12:05:27.445969	entry_date	\N	2024-11-12
2442	172	1	2026-01-16 12:05:27.446738	current_manager	\N	Сидорова Е.К.
2443	172	1	2026-01-16 12:05:27.447239	it_block	\N	Диджитал
2444	172	1	2026-01-16 12:05:27.447715	ck_department	\N	ЦК Разработки
2445	172	1	2026-01-16 12:05:27.44813	placement_type	\N	любой
2446	172	1	2026-01-16 12:05:27.448554	ready_for_vacancy	\N	Нет
2447	172	1	2026-01-16 12:05:27.448975	resume_link	\N	https://drive.google.com/file/32723
2448	172	1	2026-01-16 12:05:27.449485	manager_feedback	\N	Нужно развитие
2449	172	1	2026-01-16 12:05:27.450494	contacts	\N	+7 (932) 198-84-29, @михандр58, tatiana.sergeev156@company.ru
2450	172	1	2026-01-16 12:05:27.451312	funding_end_date	\N	2025-08-03
2451	172	1	2026-01-16 12:05:27.452359	candidate_status	\N	В работе
2452	172	1	2026-01-16 12:05:27.45351	target_projects	\N	DevOps Platform, E-commerce Platform
2453	172	1	2026-01-16 12:05:27.454456	transfer_date	\N	
2454	172	1	2026-01-16 12:05:27.455338	recruiter	\N	Новикова Е.П.
2455	172	1	2026-01-16 12:05:27.455894	hr_bp	\N	Лебедева Т.М.
2456	172	1	2026-01-16 12:05:27.456385	comments	\N	
2457	176	1	2026-01-16 12:05:27.480017	entry_date	\N	2024-08-06
2458	176	1	2026-01-16 12:05:27.480992	current_manager	\N	Петров С.М.
2459	176	1	2026-01-16 12:05:27.481638	it_block	\N	НУК
2460	176	1	2026-01-16 12:05:27.482097	ck_department	\N	ЦК Разработки
2461	176	1	2026-01-16 12:05:27.482584	placement_type	\N	перевод
2462	176	1	2026-01-16 12:05:27.483239	ready_for_vacancy	\N	Нет
2463	176	1	2026-01-16 12:05:27.483823	resume_link	\N	https://drive.google.com/file/54075
2464	176	1	2026-01-16 12:05:27.484657	manager_feedback	\N	
2465	176	1	2026-01-16 12:05:27.485408	contacts	\N	+7 (901) 572-69-12, @волмакс54, nikita.frolov160@company.ru
2466	176	1	2026-01-16 12:05:27.485962	funding_end_date	\N	2026-04-20
2467	176	1	2026-01-16 12:05:27.486324	candidate_status	\N	Увольнение по СЖ
2468	176	1	2026-01-16 12:05:27.486671	target_projects	\N	DevOps Platform, Mobile App, E-commerce Platform
2469	176	1	2026-01-16 12:05:27.487017	transfer_date	\N	2025-03-01
2470	176	1	2026-01-16 12:05:27.48736	recruiter	\N	Смирнова А.А.
2471	176	1	2026-01-16 12:05:27.487693	hr_bp	\N	Лебедева Т.М.
2472	176	1	2026-01-16 12:05:27.488202	comments	\N	Ожидает оффер
2473	365	1	2026-01-16 12:05:27.511103	entry_date	\N	2025-05-06
2474	365	1	2026-01-16 12:05:27.511728	current_manager	\N	Петров С.М.
2475	365	1	2026-01-16 12:05:27.512285	it_block	\N	Диджитал
2476	365	1	2026-01-16 12:05:27.513121	ck_department	\N	ЦК Инфраструктуры
2477	365	1	2026-01-16 12:05:27.513872	placement_type	\N	любой
2478	365	1	2026-01-16 12:05:27.514487	ready_for_vacancy	\N	Да
2479	365	1	2026-01-16 12:05:27.514949	resume_link	\N	https://drive.google.com/file/62104
2480	365	1	2026-01-16 12:05:27.515807	manager_feedback	\N	Хороший специалист
2481	365	1	2026-01-16 12:05:27.516498	contacts	\N	+7 (939) 145-78-72, @алеекат51, e.alekseeva@rt.ru
2482	365	1	2026-01-16 12:05:27.517214	funding_end_date	\N	2025-01-17
2483	365	1	2026-01-16 12:05:27.517919	candidate_status	\N	Забронирован
2484	365	1	2026-01-16 12:05:27.518562	target_projects	\N	ML Pipeline
2485	365	1	2026-01-16 12:05:27.51903	transfer_date	\N	
2486	365	1	2026-01-16 12:05:27.519393	recruiter	\N	Белова И.Д.
2487	365	1	2026-01-16 12:05:27.519732	hr_bp	\N	Морозов К.А.
2488	365	1	2026-01-16 12:05:27.520133	comments	\N	В процессе согласования
2489	366	1	2026-01-16 12:05:27.552787	entry_date	\N	2025-01-17
2490	366	1	2026-01-16 12:05:27.554027	current_manager	\N	Иванов А.П.
2491	366	1	2026-01-16 12:05:27.555324	it_block	\N	B2O
2492	366	1	2026-01-16 12:05:27.556513	ck_department	\N	ЦК Разработки
2493	366	1	2026-01-16 12:05:27.557372	placement_type	\N	аутстафф
2494	366	1	2026-01-16 12:05:27.558295	ready_for_vacancy	\N	Да
2495	366	1	2026-01-16 12:05:27.559043	resume_link	\N	https://drive.google.com/file/82333
2496	366	1	2026-01-16 12:05:27.560013	manager_feedback	\N	Хороший специалист
2497	366	1	2026-01-16 12:05:27.56095	contacts	\N	+7 (918) 665-35-18, @соксерг94, s.sokolov@rt.ru
2498	366	1	2026-01-16 12:05:27.562169	funding_end_date	\N	2025-09-27
2499	366	1	2026-01-16 12:05:27.563084	candidate_status	\N	Свободен
2500	366	1	2026-01-16 12:05:27.563996	target_projects	\N	E-commerce Platform, Banking App
2501	366	1	2026-01-16 12:05:27.564975	transfer_date	\N	
2502	366	1	2026-01-16 12:05:27.565943	recruiter	\N	Орлов М.С.
2503	366	1	2026-01-16 12:05:27.56692	hr_bp	\N	Волкова Н.В.
2504	366	1	2026-01-16 12:05:27.567851	comments	\N	Ожидает оффер
2505	367	1	2026-01-16 12:05:27.599373	entry_date	\N	2024-04-05
2506	367	1	2026-01-16 12:05:27.600193	current_manager	\N	Петров С.М.
2507	367	1	2026-01-16 12:05:27.601161	it_block	\N	Развитие
2508	367	1	2026-01-16 12:05:27.602265	ck_department	\N	ЦК Аналитики
2509	367	1	2026-01-16 12:05:27.603132	placement_type	\N	перевод
2510	367	1	2026-01-16 12:05:27.604565	ready_for_vacancy	\N	Да
2511	367	1	2026-01-16 12:05:27.605318	resume_link	\N	https://drive.google.com/file/37630
2512	367	1	2026-01-16 12:05:27.605996	manager_feedback	\N	Нужно развитие
2513	367	1	2026-01-16 12:05:27.606492	contacts	\N	+7 (935) 404-12-57, @михдарь59, d.mikhaylova@rt.ru
2514	367	1	2026-01-16 12:05:27.60687	funding_end_date	\N	2025-12-28
2515	367	1	2026-01-16 12:05:27.607219	candidate_status	\N	Увольнение по СС
2516	367	1	2026-01-16 12:05:27.607559	target_projects	\N	Госуслуги 2.0
2517	367	1	2026-01-16 12:05:27.607889	transfer_date	\N	2025-02-15
2518	367	1	2026-01-16 12:05:27.608216	recruiter	\N	Орлов М.С.
2519	367	1	2026-01-16 12:05:27.608604	hr_bp	\N	Морозов К.А.
2520	367	1	2026-01-16 12:05:27.608934	comments	\N	
2521	368	1	2026-01-16 12:05:27.639281	entry_date	\N	2025-06-26
2522	368	1	2026-01-16 12:05:27.639875	current_manager	\N	Козлов Д.В.
2523	368	1	2026-01-16 12:05:27.640284	it_block	\N	B2O
2524	368	1	2026-01-16 12:05:27.640654	ck_department	\N	ЦК Инфраструктуры
2525	368	1	2026-01-16 12:05:27.641009	placement_type	\N	любой
2526	368	1	2026-01-16 12:05:27.641486	ready_for_vacancy	\N	Да
2527	368	1	2026-01-16 12:05:27.642005	resume_link	\N	https://drive.google.com/file/93793
2528	368	1	2026-01-16 12:05:27.642413	manager_feedback	\N	Рекомендую
2529	368	1	2026-01-16 12:05:27.642776	contacts	\N	+7 (977) 520-40-49, @киссерг74, s.kiselev@rt.ru
2530	368	1	2026-01-16 12:05:27.643142	funding_end_date	\N	2025-06-16
2531	368	1	2026-01-16 12:05:27.643492	candidate_status	\N	В работе
2532	368	1	2026-01-16 12:05:27.643842	target_projects	\N	Mobile App, ML Pipeline
2533	368	1	2026-01-16 12:05:27.644202	transfer_date	\N	
2534	368	1	2026-01-16 12:05:27.644579	recruiter	\N	Новикова Е.П.
2535	368	1	2026-01-16 12:05:27.645009	hr_bp	\N	Волкова Н.В.
2536	368	1	2026-01-16 12:05:27.645529	comments	\N	
2537	369	1	2026-01-16 12:05:27.666674	entry_date	\N	2024-04-27
2538	369	1	2026-01-16 12:05:27.667394	current_manager	\N	Петров С.М.
2539	369	1	2026-01-16 12:05:27.668048	it_block	\N	Прочее
2540	369	1	2026-01-16 12:05:27.668561	ck_department	\N	ЦК Разработки
2541	369	1	2026-01-16 12:05:27.668955	placement_type	\N	перевод
2542	369	1	2026-01-16 12:05:27.669421	ready_for_vacancy	\N	Да
2543	369	1	2026-01-16 12:05:27.669898	resume_link	\N	https://drive.google.com/file/30972
2544	369	1	2026-01-16 12:05:27.670284	manager_feedback	\N	
2545	369	1	2026-01-16 12:05:27.670681	contacts	\N	+7 (936) 531-99-92, @ворартё90, a.vorobev@rt.ru
2546	369	1	2026-01-16 12:05:27.671438	funding_end_date	\N	2026-10-08
2547	369	1	2026-01-16 12:05:27.67215	candidate_status	\N	Увольнение по СЖ
2548	369	1	2026-01-16 12:05:27.672773	target_projects	\N	Banking App
2549	369	1	2026-01-16 12:05:27.673177	transfer_date	\N	2026-12-19
2550	369	1	2026-01-16 12:05:27.673724	recruiter	\N	Смирнова А.А.
2551	369	1	2026-01-16 12:05:27.674149	hr_bp	\N	Морозов К.А.
2552	369	1	2026-01-16 12:05:27.674497	comments	\N	Срочно нужен проект
2553	370	1	2026-01-16 12:05:27.708533	entry_date	\N	2024-03-29
2554	370	1	2026-01-16 12:05:27.709535	current_manager	\N	Козлов Д.В.
2555	370	1	2026-01-16 12:05:27.710574	it_block	\N	Развитие
2556	370	1	2026-01-16 12:05:27.711354	ck_department	\N	Департамент цифровых продуктов
2557	370	1	2026-01-16 12:05:27.712002	placement_type	\N	любой
2558	370	1	2026-01-16 12:05:27.712577	ready_for_vacancy	\N	Да
2559	370	1	2026-01-16 12:05:27.713143	resume_link	\N	https://drive.google.com/file/28811
2560	370	1	2026-01-16 12:05:27.713886	manager_feedback	\N	Нужно развитие
2561	370	1	2026-01-16 12:05:27.714935	contacts	\N	+7 (998) 738-68-46, @соркири92, k.sorokin@rt.ru
2562	370	1	2026-01-16 12:05:27.715899	funding_end_date	\N	2025-09-14
2563	370	1	2026-01-16 12:05:27.716836	candidate_status	\N	Увольнение по СЖ
2564	370	1	2026-01-16 12:05:27.717857	target_projects	\N	DevOps Platform
2565	370	1	2026-01-16 12:05:27.718975	transfer_date	\N	2025-11-21
2566	370	1	2026-01-16 12:05:27.719927	recruiter	\N	Орлов М.С.
2567	370	1	2026-01-16 12:05:27.721118	hr_bp	\N	Лебедева Т.М.
2568	370	1	2026-01-16 12:05:27.722375	comments	\N	
2569	371	1	2026-01-16 12:05:27.762318	entry_date	\N	2025-07-29
2570	371	1	2026-01-16 12:05:27.763436	current_manager	\N	Петров С.М.
2571	371	1	2026-01-16 12:05:27.764671	it_block	\N	НУК
2572	371	1	2026-01-16 12:05:27.765851	ck_department	\N	Департамент данных
2573	371	1	2026-01-16 12:05:27.766594	placement_type	\N	любой
2574	371	1	2026-01-16 12:05:27.767939	ready_for_vacancy	\N	Нет
2575	371	1	2026-01-16 12:05:27.768646	resume_link	\N	https://drive.google.com/file/99950
2576	371	1	2026-01-16 12:05:27.769283	manager_feedback	\N	Отличные результаты
2577	371	1	2026-01-16 12:05:27.769921	contacts	\N	+7 (912) 564-62-88, @коранна4, a.koroleva@rt.ru
2578	371	1	2026-01-16 12:05:27.770621	funding_end_date	\N	2025-01-14
2579	371	1	2026-01-16 12:05:27.771315	candidate_status	\N	Увольнение по СС
2580	371	1	2026-01-16 12:05:27.771994	target_projects	\N	ML Pipeline
2581	371	1	2026-01-16 12:05:27.772676	transfer_date	\N	2025-03-17
2582	371	1	2026-01-16 12:05:27.773508	recruiter	\N	Белова И.Д.
2583	371	1	2026-01-16 12:05:27.774057	hr_bp	\N	Лебедева Т.М.
2584	371	1	2026-01-16 12:05:27.774477	comments	\N	Ожидает оффер
2585	372	1	2026-01-16 12:05:27.807229	entry_date	\N	2024-05-04
2586	372	1	2026-01-16 12:05:27.808253	current_manager	\N	Петров С.М.
2587	372	1	2026-01-16 12:05:27.809067	it_block	\N	B2O
2588	372	1	2026-01-16 12:05:27.809932	ck_department	\N	Департамент цифровых продуктов
2589	372	1	2026-01-16 12:05:27.810607	placement_type	\N	любой
2590	372	1	2026-01-16 12:05:27.811262	ready_for_vacancy	\N	Нет
2591	372	1	2026-01-16 12:05:27.811781	resume_link	\N	https://drive.google.com/file/67039
2592	372	1	2026-01-16 12:05:27.812572	manager_feedback	\N	Хороший специалист
2593	372	1	2026-01-16 12:05:27.813398	contacts	\N	+7 (937) 883-77-21, @никсаве14, s.nikolaev@rt.ru
2594	372	1	2026-01-16 12:05:27.814289	funding_end_date	\N	2026-01-23
2595	372	1	2026-01-16 12:05:27.814867	candidate_status	\N	Забронирован
2596	372	1	2026-01-16 12:05:27.81577	target_projects	\N	Mobile App, DevOps Platform
2597	372	1	2026-01-16 12:05:27.8163	transfer_date	\N	
2598	372	1	2026-01-16 12:05:27.816756	recruiter	\N	Новикова Е.П.
2599	372	1	2026-01-16 12:05:27.817132	hr_bp	\N	Волкова Н.В.
2600	372	1	2026-01-16 12:05:27.81778	comments	\N	
2601	373	1	2026-01-16 12:05:27.844811	entry_date	\N	2024-08-28
2602	373	1	2026-01-16 12:05:27.845556	current_manager	\N	Михайлова О.Н.
2603	373	1	2026-01-16 12:05:27.845964	it_block	\N	B2O
2604	373	1	2026-01-16 12:05:27.846311	ck_department	\N	Департамент цифровых продуктов
2605	373	1	2026-01-16 12:05:27.846851	placement_type	\N	аутстафф
2606	373	1	2026-01-16 12:05:27.84719	ready_for_vacancy	\N	Нет
2607	373	1	2026-01-16 12:05:27.847996	resume_link	\N	https://drive.google.com/file/87813
2608	373	1	2026-01-16 12:05:27.848704	manager_feedback	\N	Нужно развитие
2609	373	1	2026-01-16 12:05:27.849476	contacts	\N	+7 (939) 461-48-49, @никмарк66, m.nikitin@rt.ru
2610	373	1	2026-01-16 12:05:27.850643	funding_end_date	\N	2026-02-21
2611	373	1	2026-01-16 12:05:27.851341	candidate_status	\N	Увольнение по СЖ
2612	373	1	2026-01-16 12:05:27.852055	target_projects	\N	E-commerce Platform, Госуслуги 2.0, Banking App
2613	373	1	2026-01-16 12:05:27.852781	transfer_date	\N	2025-03-15
2614	373	1	2026-01-16 12:05:27.853619	recruiter	\N	Смирнова А.А.
2615	373	1	2026-01-16 12:05:27.854214	hr_bp	\N	Волкова Н.В.
2616	373	1	2026-01-16 12:05:27.854689	comments	\N	Ожидает оффер
2617	374	1	2026-01-16 12:05:27.888066	entry_date	\N	2025-04-08
2618	374	1	2026-01-16 12:05:27.888801	current_manager	\N	Петров С.М.
2619	374	1	2026-01-16 12:05:27.889573	it_block	\N	Диджитал
2620	374	1	2026-01-16 12:05:27.890326	ck_department	\N	ЦК Аналитики
2621	374	1	2026-01-16 12:05:27.891017	placement_type	\N	аутстафф
2622	374	1	2026-01-16 12:05:27.891698	ready_for_vacancy	\N	Да
2623	374	1	2026-01-16 12:05:27.892457	resume_link	\N	https://drive.google.com/file/89656
2624	374	1	2026-01-16 12:05:27.893073	manager_feedback	\N	Нужно развитие
2625	374	1	2026-01-16 12:05:27.893896	contacts	\N	+7 (981) 665-39-18, @волдиан71, d.volkova@rt.ru
2626	374	1	2026-01-16 12:05:27.894786	funding_end_date	\N	2025-04-25
2709	379	1	2026-01-16 12:05:28.094204	transfer_date	\N	2026-04-07
2627	374	1	2026-01-16 12:05:27.895663	candidate_status	\N	Увольнение по СЖ
2628	374	1	2026-01-16 12:05:27.896628	target_projects	\N	Госуслуги 2.0, Mobile App
2629	374	1	2026-01-16 12:05:27.897577	transfer_date	\N	2025-01-21
2630	374	1	2026-01-16 12:05:27.898361	recruiter	\N	Новикова Е.П.
2631	374	1	2026-01-16 12:05:27.899152	hr_bp	\N	Лебедева Т.М.
2632	374	1	2026-01-16 12:05:27.899981	comments	\N	Срочно нужен проект
2633	375	1	2026-01-16 12:05:27.940033	entry_date	\N	2024-09-15
2634	375	1	2026-01-16 12:05:27.940886	current_manager	\N	Петров С.М.
2635	375	1	2026-01-16 12:05:27.94178	it_block	\N	Прочее
2636	375	1	2026-01-16 12:05:27.942446	ck_department	\N	Департамент цифровых продуктов
2637	375	1	2026-01-16 12:05:27.943091	placement_type	\N	перевод
2638	375	1	2026-01-16 12:05:27.943638	ready_for_vacancy	\N	Нет
2639	375	1	2026-01-16 12:05:27.944306	resume_link	\N	https://drive.google.com/file/80911
2640	375	1	2026-01-16 12:05:27.944974	manager_feedback	\N	Хороший специалист
2641	375	1	2026-01-16 12:05:27.945907	contacts	\N	+7 (991) 648-88-12, @волольг98, o.volkova@rt.ru
2642	375	1	2026-01-16 12:05:27.946887	funding_end_date	\N	2025-11-17
2643	375	1	2026-01-16 12:05:27.947889	candidate_status	\N	В работе
2644	375	1	2026-01-16 12:05:27.948799	target_projects	\N	Infrastructure, DevOps Platform
2645	375	1	2026-01-16 12:05:27.949649	transfer_date	\N	
2646	375	1	2026-01-16 12:05:27.95033	recruiter	\N	Орлов М.С.
2647	375	1	2026-01-16 12:05:27.951082	hr_bp	\N	Морозов К.А.
2648	375	1	2026-01-16 12:05:27.951788	comments	\N	
2649	376	1	2026-01-16 12:05:27.981917	entry_date	\N	2024-06-06
2650	376	1	2026-01-16 12:05:27.982837	current_manager	\N	Петров С.М.
2651	376	1	2026-01-16 12:05:27.983607	it_block	\N	Развитие
2652	376	1	2026-01-16 12:05:27.984238	ck_department	\N	Департамент цифровых продуктов
2653	376	1	2026-01-16 12:05:27.984781	placement_type	\N	перевод
2654	376	1	2026-01-16 12:05:27.985165	ready_for_vacancy	\N	Нет
2655	376	1	2026-01-16 12:05:27.985977	resume_link	\N	https://drive.google.com/file/63207
2656	376	1	2026-01-16 12:05:27.986796	manager_feedback	\N	Хороший специалист
2657	376	1	2026-01-16 12:05:27.987373	contacts	\N	+7 (936) 520-21-52, @кузюрий80, yu.kuznetsov@rt.ru
2658	376	1	2026-01-16 12:05:27.988129	funding_end_date	\N	2026-05-06
2659	376	1	2026-01-16 12:05:27.988786	candidate_status	\N	Забронирован
2660	376	1	2026-01-16 12:05:27.989458	target_projects	\N	ML Pipeline
2661	376	1	2026-01-16 12:05:27.990279	transfer_date	\N	
2662	376	1	2026-01-16 12:05:27.990961	recruiter	\N	Смирнова А.А.
2663	376	1	2026-01-16 12:05:27.991618	hr_bp	\N	Морозов К.А.
2664	376	1	2026-01-16 12:05:27.992438	comments	\N	
2665	377	1	2026-01-16 12:05:28.020499	entry_date	\N	2025-07-18
2666	377	1	2026-01-16 12:05:28.02121	current_manager	\N	Сидорова Е.К.
2667	377	1	2026-01-16 12:05:28.021823	it_block	\N	Развитие
2668	377	1	2026-01-16 12:05:28.02223	ck_department	\N	Департамент данных
2669	377	1	2026-01-16 12:05:28.022609	placement_type	\N	аутстафф
2670	377	1	2026-01-16 12:05:28.023164	ready_for_vacancy	\N	Да
2671	377	1	2026-01-16 12:05:28.023864	resume_link	\N	https://drive.google.com/file/19371
2672	377	1	2026-01-16 12:05:28.024622	manager_feedback	\N	
2673	377	1	2026-01-16 12:05:28.025372	contacts	\N	+7 (923) 726-95-86, @фровади45, v.frolov@rt.ru
2674	377	1	2026-01-16 12:05:28.026069	funding_end_date	\N	2025-06-03
2675	377	1	2026-01-16 12:05:28.02652	candidate_status	\N	Увольнение по СС
2676	377	1	2026-01-16 12:05:28.02723	target_projects	\N	Infrastructure
2677	377	1	2026-01-16 12:05:28.027842	transfer_date	\N	2026-04-09
2678	377	1	2026-01-16 12:05:28.028373	recruiter	\N	Орлов М.С.
2679	377	1	2026-01-16 12:05:28.028893	hr_bp	\N	Лебедева Т.М.
2680	377	1	2026-01-16 12:05:28.029484	comments	\N	Срочно нужен проект
2681	378	1	2026-01-16 12:05:28.056237	entry_date	\N	2024-09-05
2682	378	1	2026-01-16 12:05:28.057127	current_manager	\N	Козлов Д.В.
2683	378	1	2026-01-16 12:05:28.057752	it_block	\N	Эксплуатация
2684	378	1	2026-01-16 12:05:28.058146	ck_department	\N	ЦК Инфраструктуры
2685	378	1	2026-01-16 12:05:28.058495	placement_type	\N	любой
2686	378	1	2026-01-16 12:05:28.058826	ready_for_vacancy	\N	Нет
2687	378	1	2026-01-16 12:05:28.059434	resume_link	\N	https://drive.google.com/file/91828
2688	378	1	2026-01-16 12:05:28.059791	manager_feedback	\N	Отличные результаты
2689	378	1	2026-01-16 12:05:28.060353	contacts	\N	+7 (988) 418-92-36, @кузксен54, k.kuzmina@rt.ru
2690	378	1	2026-01-16 12:05:28.061051	funding_end_date	\N	2025-07-23
2691	378	1	2026-01-16 12:05:28.061657	candidate_status	\N	Увольнение по СС
2692	378	1	2026-01-16 12:05:28.062052	target_projects	\N	Infrastructure
2693	378	1	2026-01-16 12:05:28.062641	transfer_date	\N	2025-01-25
2694	378	1	2026-01-16 12:05:28.063027	recruiter	\N	Смирнова А.А.
2695	378	1	2026-01-16 12:05:28.06347	hr_bp	\N	Морозов К.А.
2696	378	1	2026-01-16 12:05:28.063831	comments	\N	
2697	379	1	2026-01-16 12:05:28.088885	entry_date	\N	2024-11-01
2698	379	1	2026-01-16 12:05:28.089566	current_manager	\N	Михайлова О.Н.
2699	379	1	2026-01-16 12:05:28.090016	it_block	\N	Развитие
2700	379	1	2026-01-16 12:05:28.09038	ck_department	\N	ЦК Разработки
2701	379	1	2026-01-16 12:05:28.090719	placement_type	\N	аутстафф
2702	379	1	2026-01-16 12:05:28.091056	ready_for_vacancy	\N	Да
2703	379	1	2026-01-16 12:05:28.091713	resume_link	\N	https://drive.google.com/file/20294
2704	379	1	2026-01-16 12:05:28.09212	manager_feedback	\N	Хороший специалист
2705	379	1	2026-01-16 12:05:28.092493	contacts	\N	+7 (987) 975-94-86, @михарсе66, a.mikhaylov@rt.ru
2706	379	1	2026-01-16 12:05:28.092843	funding_end_date	\N	2026-09-28
2707	379	1	2026-01-16 12:05:28.093176	candidate_status	\N	Увольнение по СС
2708	379	1	2026-01-16 12:05:28.093816	target_projects	\N	ML Pipeline, Госуслуги 2.0, Data Platform
2710	379	1	2026-01-16 12:05:28.094553	recruiter	\N	Новикова Е.П.
2711	379	1	2026-01-16 12:05:28.094948	hr_bp	\N	Морозов К.А.
2712	379	1	2026-01-16 12:05:28.095292	comments	\N	В процессе согласования
2713	380	1	2026-01-16 12:05:28.116106	entry_date	\N	2025-09-12
2714	380	1	2026-01-16 12:05:28.117186	current_manager	\N	Михайлова О.Н.
2715	380	1	2026-01-16 12:05:28.118326	it_block	\N	B2O
2716	380	1	2026-01-16 12:05:28.119029	ck_department	\N	ЦК Инфраструктуры
2717	380	1	2026-01-16 12:05:28.119532	placement_type	\N	перевод
2718	380	1	2026-01-16 12:05:28.12003	ready_for_vacancy	\N	Да
2719	380	1	2026-01-16 12:05:28.120428	resume_link	\N	https://drive.google.com/file/80658
2720	380	1	2026-01-16 12:05:28.121007	manager_feedback	\N	Хороший специалист
2721	380	1	2026-01-16 12:05:28.121617	contacts	\N	+7 (936) 248-61-68, @волдени46, d.volkov@rt.ru
2722	380	1	2026-01-16 12:05:28.121973	funding_end_date	\N	2026-03-26
2723	380	1	2026-01-16 12:05:28.122295	candidate_status	\N	Увольнение по СЖ
2724	380	1	2026-01-16 12:05:28.122611	target_projects	\N	Data Platform, Госуслуги 2.0
2725	380	1	2026-01-16 12:05:28.122927	transfer_date	\N	2025-07-17
2726	380	1	2026-01-16 12:05:28.123237	recruiter	\N	Смирнова А.А.
2727	380	1	2026-01-16 12:05:28.123546	hr_bp	\N	Волкова Н.В.
2728	380	1	2026-01-16 12:05:28.124397	comments	\N	
2729	381	1	2026-01-16 12:05:28.151855	entry_date	\N	2025-03-24
2730	381	1	2026-01-16 12:05:28.152651	current_manager	\N	Петров С.М.
2731	381	1	2026-01-16 12:05:28.153437	it_block	\N	Диджитал
2732	381	1	2026-01-16 12:05:28.154127	ck_department	\N	ЦК Аналитики
2733	381	1	2026-01-16 12:05:28.154725	placement_type	\N	аутстафф
2734	381	1	2026-01-16 12:05:28.155247	ready_for_vacancy	\N	Да
2735	381	1	2026-01-16 12:05:28.155766	resume_link	\N	https://drive.google.com/file/30838
2736	381	1	2026-01-16 12:05:28.156523	manager_feedback	\N	Рекомендую
2737	381	1	2026-01-16 12:05:28.157109	contacts	\N	+7 (986) 997-63-69, @кузтимо28, t.kuzmin@rt.ru
2738	381	1	2026-01-16 12:05:28.157819	funding_end_date	\N	2026-04-24
2739	381	1	2026-01-16 12:05:28.158347	candidate_status	\N	Переведен
2740	381	1	2026-01-16 12:05:28.158958	target_projects	\N	Госуслуги 2.0
2741	381	1	2026-01-16 12:05:28.159458	transfer_date	\N	2025-12-11
2742	381	1	2026-01-16 12:05:28.159995	recruiter	\N	Новикова Е.П.
2743	381	1	2026-01-16 12:05:28.160527	hr_bp	\N	Волкова Н.В.
2744	381	1	2026-01-16 12:05:28.161029	comments	\N	
2745	382	1	2026-01-16 12:05:28.180717	entry_date	\N	2024-08-02
2746	382	1	2026-01-16 12:05:28.181289	current_manager	\N	Сидорова Е.К.
2747	382	1	2026-01-16 12:05:28.181839	it_block	\N	Развитие
2748	382	1	2026-01-16 12:05:28.182209	ck_department	\N	ЦК Аналитики
2749	382	1	2026-01-16 12:05:28.182549	placement_type	\N	перевод
2750	382	1	2026-01-16 12:05:28.18288	ready_for_vacancy	\N	Нет
2751	382	1	2026-01-16 12:05:28.183213	resume_link	\N	https://drive.google.com/file/23015
2752	382	1	2026-01-16 12:05:28.183536	manager_feedback	\N	Отличные результаты
2753	382	1	2026-01-16 12:05:28.183861	contacts	\N	+7 (936) 473-83-47, @коряна84, ya.koroleva@rt.ru
2754	382	1	2026-01-16 12:05:28.184619	funding_end_date	\N	2025-04-11
2755	382	1	2026-01-16 12:05:28.185099	candidate_status	\N	Забронирован
2756	382	1	2026-01-16 12:05:28.185719	target_projects	\N	Mobile App, Госуслуги 2.0
2757	382	1	2026-01-16 12:05:28.186194	transfer_date	\N	
2758	382	1	2026-01-16 12:05:28.186547	recruiter	\N	Белова И.Д.
2759	382	1	2026-01-16 12:05:28.187096	hr_bp	\N	Волкова Н.В.
2760	382	1	2026-01-16 12:05:28.187445	comments	\N	Ожидает оффер
2761	383	1	2026-01-16 12:05:28.218932	entry_date	\N	2024-03-27
2762	383	1	2026-01-16 12:05:28.21956	current_manager	\N	Петров С.М.
2763	383	1	2026-01-16 12:05:28.21996	it_block	\N	Развитие
2764	383	1	2026-01-16 12:05:28.220307	ck_department	\N	ЦК Разработки
2765	383	1	2026-01-16 12:05:28.220656	placement_type	\N	аутстафф
2766	383	1	2026-01-16 12:05:28.221034	ready_for_vacancy	\N	Нет
2767	383	1	2026-01-16 12:05:28.221498	resume_link	\N	https://drive.google.com/file/26696
2768	383	1	2026-01-16 12:05:28.222049	manager_feedback	\N	Хороший специалист
2769	383	1	2026-01-16 12:05:28.222624	contacts	\N	+7 (978) 247-46-97, @фроксен15, k.frolova@rt.ru
2770	383	1	2026-01-16 12:05:28.223022	funding_end_date	\N	2025-04-08
2771	383	1	2026-01-16 12:05:28.22337	candidate_status	\N	Увольнение по СЖ
2772	383	1	2026-01-16 12:05:28.2237	target_projects	\N	Infrastructure
2773	383	1	2026-01-16 12:05:28.224027	transfer_date	\N	2026-07-17
2774	383	1	2026-01-16 12:05:28.224346	recruiter	\N	Орлов М.С.
2775	383	1	2026-01-16 12:05:28.224662	hr_bp	\N	Морозов К.А.
2776	383	1	2026-01-16 12:05:28.22498	comments	\N	В процессе согласования
2777	384	1	2026-01-16 12:05:28.25229	entry_date	\N	2025-09-20
2778	384	1	2026-01-16 12:05:28.253118	current_manager	\N	Иванов А.П.
2779	384	1	2026-01-16 12:05:28.253868	it_block	\N	НУК
2780	384	1	2026-01-16 12:05:28.254289	ck_department	\N	ЦК Аналитики
2781	384	1	2026-01-16 12:05:28.254661	placement_type	\N	перевод
2782	384	1	2026-01-16 12:05:28.255168	ready_for_vacancy	\N	Да
2783	384	1	2026-01-16 12:05:28.255726	resume_link	\N	https://drive.google.com/file/93801
2784	384	1	2026-01-16 12:05:28.256306	manager_feedback	\N	Отличные результаты
2785	384	1	2026-01-16 12:05:28.256765	contacts	\N	+7 (972) 186-75-27, @зайгали55, g.zaytseva@rt.ru
2786	384	1	2026-01-16 12:05:28.257135	funding_end_date	\N	2025-06-24
2787	384	1	2026-01-16 12:05:28.257667	candidate_status	\N	Переведен
2788	384	1	2026-01-16 12:05:28.258059	target_projects	\N	DevOps Platform, Data Platform, Госуслуги 2.0
2789	384	1	2026-01-16 12:05:28.25843	transfer_date	\N	2026-05-12
2790	384	1	2026-01-16 12:05:28.258793	recruiter	\N	Белова И.Д.
2791	384	1	2026-01-16 12:05:28.259153	hr_bp	\N	Волкова Н.В.
2792	384	1	2026-01-16 12:05:28.259509	comments	\N	Срочно нужен проект
2793	385	1	2026-01-16 12:05:28.286644	entry_date	\N	2025-05-15
2794	385	1	2026-01-16 12:05:28.287391	current_manager	\N	Петров С.М.
2795	385	1	2026-01-16 12:05:28.290675	it_block	\N	Диджитал
2796	385	1	2026-01-16 12:05:28.291839	ck_department	\N	Департамент данных
2797	385	1	2026-01-16 12:05:28.292585	placement_type	\N	любой
2798	385	1	2026-01-16 12:05:28.293275	ready_for_vacancy	\N	Нет
2799	385	1	2026-01-16 12:05:28.293991	resume_link	\N	https://drive.google.com/file/76272
2800	385	1	2026-01-16 12:05:28.29453	manager_feedback	\N	
2801	385	1	2026-01-16 12:05:28.295059	contacts	\N	+7 (925) 841-93-85, @захсвет53, s.zakharova@rt.ru
2802	385	1	2026-01-16 12:05:28.295573	funding_end_date	\N	2025-12-02
2803	385	1	2026-01-16 12:05:28.296077	candidate_status	\N	Увольнение по СС
2804	385	1	2026-01-16 12:05:28.296581	target_projects	\N	Госуслуги 2.0, E-commerce Platform
2805	385	1	2026-01-16 12:05:28.297084	transfer_date	\N	2025-06-24
2806	385	1	2026-01-16 12:05:28.297664	recruiter	\N	Смирнова А.А.
2807	385	1	2026-01-16 12:05:28.298185	hr_bp	\N	Морозов К.А.
2808	385	1	2026-01-16 12:05:28.298693	comments	\N	Ожидает оффер
2809	386	1	2026-01-16 12:05:28.321439	entry_date	\N	2024-09-06
2810	386	1	2026-01-16 12:05:28.322046	current_manager	\N	Козлов Д.В.
2811	386	1	2026-01-16 12:05:28.322447	it_block	\N	B2O
2812	386	1	2026-01-16 12:05:28.32297	ck_department	\N	ЦК Аналитики
2813	386	1	2026-01-16 12:05:28.323607	placement_type	\N	любой
2814	386	1	2026-01-16 12:05:28.324089	ready_for_vacancy	\N	Нет
2815	386	1	2026-01-16 12:05:28.324754	resume_link	\N	https://drive.google.com/file/95013
2816	386	1	2026-01-16 12:05:28.32541	manager_feedback	\N	Отличные результаты
2817	386	1	2026-01-16 12:05:28.32639	contacts	\N	+7 (917) 782-10-65, @смидани16, d.smirnov@rt.ru
2818	386	1	2026-01-16 12:05:28.327082	funding_end_date	\N	2025-11-27
2819	386	1	2026-01-16 12:05:28.327581	candidate_status	\N	Переведен
2820	386	1	2026-01-16 12:05:28.328109	target_projects	\N	Infrastructure, Mobile App, Banking App
2821	386	1	2026-01-16 12:05:28.328476	transfer_date	\N	2025-07-02
2822	386	1	2026-01-16 12:05:28.328812	recruiter	\N	Белова И.Д.
2823	386	1	2026-01-16 12:05:28.329134	hr_bp	\N	Лебедева Т.М.
2824	386	1	2026-01-16 12:05:28.329488	comments	\N	Ожидает оффер
2825	387	1	2026-01-16 12:05:28.350339	entry_date	\N	2024-09-11
2826	387	1	2026-01-16 12:05:28.3513	current_manager	\N	Козлов Д.В.
2827	387	1	2026-01-16 12:05:28.352189	it_block	\N	НУК
2828	387	1	2026-01-16 12:05:28.353098	ck_department	\N	Департамент данных
2829	387	1	2026-01-16 12:05:28.353862	placement_type	\N	аутстафф
2830	387	1	2026-01-16 12:05:28.354291	ready_for_vacancy	\N	Да
2831	387	1	2026-01-16 12:05:28.354651	resume_link	\N	https://drive.google.com/file/17515
2832	387	1	2026-01-16 12:05:28.354979	manager_feedback	\N	Отличные результаты
2833	387	1	2026-01-16 12:05:28.355296	contacts	\N	+7 (949) 351-69-42, @никлюдм31, l.nikitina@rt.ru
2834	387	1	2026-01-16 12:05:28.356557	funding_end_date	\N	2026-06-11
2835	387	1	2026-01-16 12:05:28.357078	candidate_status	\N	Свободен
2836	387	1	2026-01-16 12:05:28.35775	target_projects	\N	ML Pipeline, DevOps Platform, E-commerce Platform
2837	387	1	2026-01-16 12:05:28.358236	transfer_date	\N	
2838	387	1	2026-01-16 12:05:28.358955	recruiter	\N	Новикова Е.П.
2839	387	1	2026-01-16 12:05:28.359468	hr_bp	\N	Волкова Н.В.
2840	387	1	2026-01-16 12:05:28.359932	comments	\N	Срочно нужен проект
2841	388	1	2026-01-16 12:05:28.391985	entry_date	\N	2025-02-05
2842	388	1	2026-01-16 12:05:28.392728	current_manager	\N	Сидорова Е.К.
2843	388	1	2026-01-16 12:05:28.393144	it_block	\N	НУК
2844	388	1	2026-01-16 12:05:28.393707	ck_department	\N	Департамент данных
2845	388	1	2026-01-16 12:05:28.394117	placement_type	\N	аутстафф
2846	388	1	2026-01-16 12:05:28.394464	ready_for_vacancy	\N	Нет
2847	388	1	2026-01-16 12:05:28.394798	resume_link	\N	https://drive.google.com/file/93872
2848	388	1	2026-01-16 12:05:28.395163	manager_feedback	\N	Отличные результаты
2849	388	1	2026-01-16 12:05:28.39552	contacts	\N	+7 (976) 411-20-46, @коввлад85, v.kovalev@rt.ru
2850	388	1	2026-01-16 12:05:28.396207	funding_end_date	\N	2025-05-29
2851	388	1	2026-01-16 12:05:28.397007	candidate_status	\N	Переведен
2852	388	1	2026-01-16 12:05:28.397643	target_projects	\N	Mobile App, DevOps Platform
2853	388	1	2026-01-16 12:05:28.398122	transfer_date	\N	2025-10-13
2854	388	1	2026-01-16 12:05:28.398547	recruiter	\N	Смирнова А.А.
2855	388	1	2026-01-16 12:05:28.399031	hr_bp	\N	Волкова Н.В.
2856	388	1	2026-01-16 12:05:28.39957	comments	\N	
2857	389	1	2026-01-16 12:05:28.427115	entry_date	\N	2025-01-05
2858	389	1	2026-01-16 12:05:28.427972	current_manager	\N	Сидорова Е.К.
2859	389	1	2026-01-16 12:05:28.428679	it_block	\N	Эксплуатация
2860	389	1	2026-01-16 12:05:28.429429	ck_department	\N	ЦК Инфраструктуры
2861	389	1	2026-01-16 12:05:28.429974	placement_type	\N	перевод
2862	389	1	2026-01-16 12:05:28.431002	ready_for_vacancy	\N	Нет
2863	389	1	2026-01-16 12:05:28.431928	resume_link	\N	https://drive.google.com/file/57778
2864	389	1	2026-01-16 12:05:28.432821	manager_feedback	\N	Рекомендую
2865	389	1	2026-01-16 12:05:28.433647	contacts	\N	+7 (926) 252-46-94, @попилья56, i.popov@rt.ru
2866	389	1	2026-01-16 12:05:28.434534	funding_end_date	\N	2025-10-13
2867	389	1	2026-01-16 12:05:28.435445	candidate_status	\N	Увольнение по СС
2868	389	1	2026-01-16 12:05:28.436083	target_projects	\N	Banking App, ML Pipeline
2869	389	1	2026-01-16 12:05:28.436875	transfer_date	\N	2026-09-15
2870	389	1	2026-01-16 12:05:28.437601	recruiter	\N	Орлов М.С.
2871	389	1	2026-01-16 12:05:28.438385	hr_bp	\N	Волкова Н.В.
2872	389	1	2026-01-16 12:05:28.438958	comments	\N	
2873	390	1	2026-01-16 12:05:28.466319	entry_date	\N	2024-12-29
2874	390	1	2026-01-16 12:05:28.467052	current_manager	\N	Сидорова Е.К.
2875	390	1	2026-01-16 12:05:28.467972	it_block	\N	Эксплуатация
2876	390	1	2026-01-16 12:05:28.468675	ck_department	\N	ЦК Разработки
2877	390	1	2026-01-16 12:05:28.469538	placement_type	\N	аутстафф
2878	390	1	2026-01-16 12:05:28.470382	ready_for_vacancy	\N	Да
2879	390	1	2026-01-16 12:05:28.471104	resume_link	\N	https://drive.google.com/file/28859
2880	390	1	2026-01-16 12:05:28.47177	manager_feedback	\N	Рекомендую
2881	390	1	2026-01-16 12:05:28.472596	contacts	\N	+7 (930) 757-11-98, @антматв50, m.antonov@rt.ru
2882	390	1	2026-01-16 12:05:28.474098	funding_end_date	\N	2025-10-31
2883	390	1	2026-01-16 12:05:28.474984	candidate_status	\N	Увольнение по СЖ
2884	390	1	2026-01-16 12:05:28.475888	target_projects	\N	Banking App
2885	390	1	2026-01-16 12:05:28.476795	transfer_date	\N	2026-06-25
2886	390	1	2026-01-16 12:05:28.477517	recruiter	\N	Смирнова А.А.
2887	390	1	2026-01-16 12:05:28.47819	hr_bp	\N	Морозов К.А.
2888	390	1	2026-01-16 12:05:28.478833	comments	\N	Срочно нужен проект
2889	391	1	2026-01-16 12:05:28.504203	entry_date	\N	2024-02-25
2890	391	1	2026-01-16 12:05:28.505588	current_manager	\N	Иванов А.П.
2891	391	1	2026-01-16 12:05:28.506301	it_block	\N	Диджитал
2892	391	1	2026-01-16 12:05:28.507129	ck_department	\N	Департамент цифровых продуктов
2893	391	1	2026-01-16 12:05:28.507827	placement_type	\N	аутстафф
2894	391	1	2026-01-16 12:05:28.508381	ready_for_vacancy	\N	Нет
2895	391	1	2026-01-16 12:05:28.508916	resume_link	\N	https://drive.google.com/file/60536
2896	391	1	2026-01-16 12:05:28.509504	manager_feedback	\N	Отличные результаты
2897	391	1	2026-01-16 12:05:28.510147	contacts	\N	+7 (967) 230-44-17, @кисанас95, a.kiseleva@rt.ru
2898	391	1	2026-01-16 12:05:28.510719	funding_end_date	\N	2026-12-31
2899	391	1	2026-01-16 12:05:28.511182	candidate_status	\N	В работе
2900	391	1	2026-01-16 12:05:28.511768	target_projects	\N	Mobile App, Infrastructure
2901	391	1	2026-01-16 12:05:28.51253	transfer_date	\N	
2902	391	1	2026-01-16 12:05:28.513392	recruiter	\N	Орлов М.С.
2903	391	1	2026-01-16 12:05:28.513977	hr_bp	\N	Лебедева Т.М.
2904	391	1	2026-01-16 12:05:28.514577	comments	\N	
2905	392	1	2026-01-16 12:05:28.542989	entry_date	\N	2024-10-01
2906	392	1	2026-01-16 12:05:28.543563	current_manager	\N	Козлов Д.В.
2907	392	1	2026-01-16 12:05:28.543949	it_block	\N	B2O
2908	392	1	2026-01-16 12:05:28.544286	ck_department	\N	Департамент данных
2909	392	1	2026-01-16 12:05:28.544612	placement_type	\N	аутстафф
2910	392	1	2026-01-16 12:05:28.545311	ready_for_vacancy	\N	Да
2911	392	1	2026-01-16 12:05:28.546052	resume_link	\N	https://drive.google.com/file/81350
2912	392	1	2026-01-16 12:05:28.546843	manager_feedback	\N	
2913	392	1	2026-01-16 12:05:28.547564	contacts	\N	+7 (913) 783-79-29, @федмарк67, m.fedorov@rt.ru
2914	392	1	2026-01-16 12:05:28.548217	funding_end_date	\N	2026-01-31
2915	392	1	2026-01-16 12:05:28.548861	candidate_status	\N	Увольнение по СЖ
2916	392	1	2026-01-16 12:05:28.549544	target_projects	\N	Infrastructure
2917	392	1	2026-01-16 12:05:28.550444	transfer_date	\N	2025-06-29
2918	392	1	2026-01-16 12:05:28.551014	recruiter	\N	Белова И.Д.
2919	392	1	2026-01-16 12:05:28.551721	hr_bp	\N	Лебедева Т.М.
2920	392	1	2026-01-16 12:05:28.552461	comments	\N	
2921	166	1	2026-01-16 12:05:28.58254	entry_date	\N	2024-03-30
2922	166	1	2026-01-16 12:05:28.58316	current_manager	\N	Козлов Д.В.
2923	166	1	2026-01-16 12:05:28.583641	it_block	\N	B2O
2924	166	1	2026-01-16 12:05:28.58409	ck_department	\N	Департамент цифровых продуктов
2925	166	1	2026-01-16 12:05:28.584711	placement_type	\N	аутстафф
2926	166	1	2026-01-16 12:05:28.585426	ready_for_vacancy	\N	Да
2927	166	1	2026-01-16 12:05:28.58592	resume_link	\N	https://drive.google.com/file/10636
2928	166	1	2026-01-16 12:05:28.586563	manager_feedback	\N	Нужно развитие
2929	166	1	2026-01-16 12:05:28.586981	contacts	\N	+7 (919) 110-80-36, @смиилья87, sergey.smirnov150@company.ru
2930	166	1	2026-01-16 12:05:28.58733	funding_end_date	\N	2026-03-22
2931	166	1	2026-01-16 12:05:28.587666	candidate_status	\N	Свободен
2932	166	1	2026-01-16 12:05:28.587989	target_projects	\N	DevOps Platform
2933	166	1	2026-01-16 12:05:28.588307	transfer_date	\N	
2934	166	1	2026-01-16 12:05:28.588621	recruiter	\N	Новикова Е.П.
2935	166	1	2026-01-16 12:05:28.588931	hr_bp	\N	Морозов К.А.
2936	166	1	2026-01-16 12:05:28.589268	comments	\N	
2937	173	1	2026-01-16 12:05:28.617297	entry_date	\N	2024-07-30
2938	173	1	2026-01-16 12:05:28.618998	current_manager	\N	Михайлова О.Н.
2939	173	1	2026-01-16 12:05:28.620024	it_block	\N	Развитие
2940	173	1	2026-01-16 12:05:28.620829	ck_department	\N	Департамент данных
2941	173	1	2026-01-16 12:05:28.621463	placement_type	\N	аутстафф
2942	173	1	2026-01-16 12:05:28.622009	ready_for_vacancy	\N	Нет
2943	173	1	2026-01-16 12:05:28.62264	resume_link	\N	https://drive.google.com/file/96648
2944	173	1	2026-01-16 12:05:28.623279	manager_feedback	\N	Нужно развитие
2945	173	1	2026-01-16 12:05:28.623801	contacts	\N	+7 (980) 779-84-95, @новрома88, yaroslav.dmitriev157@company.ru
2946	173	1	2026-01-16 12:05:28.624425	funding_end_date	\N	2025-09-08
2947	173	1	2026-01-16 12:05:28.62494	candidate_status	\N	В работе
2948	173	1	2026-01-16 12:05:28.625543	target_projects	\N	DevOps Platform, Banking App, E-commerce Platform
2949	173	1	2026-01-16 12:05:28.626262	transfer_date	\N	
2950	173	1	2026-01-16 12:05:28.626833	recruiter	\N	Белова И.Д.
2951	173	1	2026-01-16 12:05:28.627209	hr_bp	\N	Лебедева Т.М.
2952	173	1	2026-01-16 12:05:28.627547	comments	\N	
2953	165	1	2026-01-16 12:05:28.647519	entry_date	\N	2025-05-28
2954	165	1	2026-01-16 12:05:28.648086	current_manager	\N	Михайлова О.Н.
2955	165	1	2026-01-16 12:05:28.648517	it_block	\N	Эксплуатация
2956	165	1	2026-01-16 12:05:28.649008	ck_department	\N	ЦК Аналитики
2957	165	1	2026-01-16 12:05:28.649504	placement_type	\N	аутстафф
2958	165	1	2026-01-16 12:05:28.650196	ready_for_vacancy	\N	Да
2959	165	1	2026-01-16 12:05:28.650587	resume_link	\N	https://drive.google.com/file/39024
2960	165	1	2026-01-16 12:05:28.651285	manager_feedback	\N	Рекомендую
2961	165	1	2026-01-16 12:05:28.651732	contacts	\N	+7 (967) 481-71-34, @иваалек1, svetlana.kuznetsov149@company.ru
2962	165	1	2026-01-16 12:05:28.652115	funding_end_date	\N	2026-10-11
2963	165	1	2026-01-16 12:05:28.652433	candidate_status	\N	Увольнение по СС
2964	165	1	2026-01-16 12:05:28.652942	target_projects	\N	ML Pipeline, Госуслуги 2.0, Infrastructure
2965	165	1	2026-01-16 12:05:28.653459	transfer_date	\N	2025-11-27
2966	165	1	2026-01-16 12:05:28.653801	recruiter	\N	Смирнова А.А.
2967	165	1	2026-01-16 12:05:28.65411	hr_bp	\N	Морозов К.А.
2968	165	1	2026-01-16 12:05:28.654425	comments	\N	
2969	175	1	2026-01-16 12:05:28.675978	entry_date	\N	2024-09-04
2970	175	1	2026-01-16 12:05:28.676738	current_manager	\N	Иванов А.П.
2971	175	1	2026-01-16 12:05:28.677734	it_block	\N	Диджитал
2972	175	1	2026-01-16 12:05:28.678386	ck_department	\N	ЦК Инфраструктуры
2973	175	1	2026-01-16 12:05:28.678879	placement_type	\N	перевод
2974	175	1	2026-01-16 12:05:28.679367	ready_for_vacancy	\N	Нет
2975	175	1	2026-01-16 12:05:28.680522	resume_link	\N	https://drive.google.com/file/33792
2976	175	1	2026-01-16 12:05:28.681342	manager_feedback	\N	Отличные результаты
2977	175	1	2026-01-16 12:05:28.681938	contacts	\N	+7 (966) 272-68-90, @морники27, anna.egorov159@company.ru
2978	175	1	2026-01-16 12:05:28.682635	funding_end_date	\N	2026-09-26
2979	175	1	2026-01-16 12:05:28.683376	candidate_status	\N	Переведен
2980	175	1	2026-01-16 12:05:28.684294	target_projects	\N	Data Platform
2981	175	1	2026-01-16 12:05:28.684988	transfer_date	\N	2025-08-14
2982	175	1	2026-01-16 12:05:28.685581	recruiter	\N	Орлов М.С.
2983	175	1	2026-01-16 12:05:28.68627	hr_bp	\N	Морозов К.А.
2984	175	1	2026-01-16 12:05:28.686853	comments	\N	
2985	161	1	2026-01-16 12:05:28.707231	entry_date	\N	2024-08-29
2986	161	1	2026-01-16 12:05:28.708119	current_manager	\N	Петров С.М.
2987	161	1	2026-01-16 12:05:28.708791	it_block	\N	B2O
2988	161	1	2026-01-16 12:05:28.709358	ck_department	\N	ЦК Аналитики
2989	161	1	2026-01-16 12:05:28.710084	placement_type	\N	аутстафф
2990	161	1	2026-01-16 12:05:28.710603	ready_for_vacancy	\N	Нет
2991	161	1	2026-01-16 12:05:28.711056	resume_link	\N	https://drive.google.com/file/55019
2992	161	1	2026-01-16 12:05:28.71154	manager_feedback	\N	Нужно развитие
2993	161	1	2026-01-16 12:05:28.7119	contacts	\N	+7 (938) 896-11-82, @волмакс95, arthur.kozlov145@company.ru
2994	161	1	2026-01-16 12:05:28.712237	funding_end_date	\N	2025-12-15
2995	161	1	2026-01-16 12:05:28.712759	candidate_status	\N	Увольнение по СС
2996	161	1	2026-01-16 12:05:28.713098	target_projects	\N	Госуслуги 2.0, E-commerce Platform
2997	161	1	2026-01-16 12:05:28.713582	transfer_date	\N	2025-01-14
2998	161	1	2026-01-16 12:05:28.714007	recruiter	\N	Смирнова А.А.
2999	161	1	2026-01-16 12:05:28.714351	hr_bp	\N	Лебедева Т.М.
3000	161	1	2026-01-16 12:05:28.714739	comments	\N	Ожидает оффер
3001	164	1	2026-01-16 12:05:28.743099	entry_date	\N	2024-12-09
3002	164	1	2026-01-16 12:05:28.743951	current_manager	\N	Петров С.М.
3003	164	1	2026-01-16 12:05:28.744615	it_block	\N	Диджитал
3004	164	1	2026-01-16 12:05:28.745403	ck_department	\N	ЦК Инфраструктуры
3005	164	1	2026-01-16 12:05:28.746024	placement_type	\N	любой
3006	164	1	2026-01-16 12:05:28.74654	ready_for_vacancy	\N	Да
3007	164	1	2026-01-16 12:05:28.747172	resume_link	\N	https://drive.google.com/file/62754
3008	164	1	2026-01-16 12:05:28.747913	manager_feedback	\N	Нужно развитие
3009	164	1	2026-01-16 12:05:28.748485	contacts	\N	+7 (996) 203-36-58, @семкири48, oleg.kiselev148@company.ru
3010	164	1	2026-01-16 12:05:28.748856	funding_end_date	\N	2025-12-17
3011	164	1	2026-01-16 12:05:28.749189	candidate_status	\N	Забронирован
3012	164	1	2026-01-16 12:05:28.74972	target_projects	\N	Госуслуги 2.0, Data Platform, DevOps Platform
3013	164	1	2026-01-16 12:05:28.750262	transfer_date	\N	
3014	164	1	2026-01-16 12:05:28.751084	recruiter	\N	Белова И.Д.
3015	164	1	2026-01-16 12:05:28.751935	hr_bp	\N	Волкова Н.В.
3016	164	1	2026-01-16 12:05:28.752661	comments	\N	Срочно нужен проект
3017	170	1	2026-01-16 12:05:28.77886	entry_date	\N	2024-03-14
3018	170	1	2026-01-16 12:05:28.779482	current_manager	\N	Михайлова О.Н.
3019	170	1	2026-01-16 12:05:28.779979	it_block	\N	B2O
3020	170	1	2026-01-16 12:05:28.780354	ck_department	\N	Департамент цифровых продуктов
3021	170	1	2026-01-16 12:05:28.78068	placement_type	\N	перевод
3022	170	1	2026-01-16 12:05:28.781008	ready_for_vacancy	\N	Нет
3023	170	1	2026-01-16 12:05:28.781563	resume_link	\N	https://drive.google.com/file/41625
3024	170	1	2026-01-16 12:05:28.78208	manager_feedback	\N	
3025	170	1	2026-01-16 12:05:28.782466	contacts	\N	+7 (922) 758-51-42, @петалек73, ekaterina.yakovlev154@company.ru
3026	170	1	2026-01-16 12:05:28.782805	funding_end_date	\N	2026-02-01
3027	170	1	2026-01-16 12:05:28.783245	candidate_status	\N	В работе
3028	170	1	2026-01-16 12:05:28.783906	target_projects	\N	E-commerce Platform
3029	170	1	2026-01-16 12:05:28.784562	transfer_date	\N	
3030	170	1	2026-01-16 12:05:28.784998	recruiter	\N	Белова И.Д.
3031	170	1	2026-01-16 12:05:28.785998	hr_bp	\N	Лебедева Т.М.
3032	170	1	2026-01-16 12:05:28.78663	comments	\N	В процессе согласования
3033	186	1	2026-01-16 12:05:28.808129	entry_date	\N	2025-04-26
3034	186	1	2026-01-16 12:05:28.808662	current_manager	\N	Иванов А.П.
3035	186	1	2026-01-16 12:05:28.809096	it_block	\N	Диджитал
3036	186	1	2026-01-16 12:05:28.809512	ck_department	\N	ЦК Аналитики
3037	186	1	2026-01-16 12:05:28.80989	placement_type	\N	любой
3038	186	1	2026-01-16 12:05:28.810477	ready_for_vacancy	\N	Нет
3039	186	1	2026-01-16 12:05:28.810911	resume_link	\N	https://drive.google.com/file/65954
3040	186	1	2026-01-16 12:05:28.811361	manager_feedback	\N	Хороший специалист
3041	186	1	2026-01-16 12:05:28.811678	contacts	\N	+7 (972) 220-76-85, @сокегор74, gleb.lebedev170@company.ru
3042	186	1	2026-01-16 12:05:28.811981	funding_end_date	\N	2025-02-13
3043	186	1	2026-01-16 12:05:28.812283	candidate_status	\N	Переведен
3044	186	1	2026-01-16 12:05:28.812581	target_projects	\N	Госуслуги 2.0
3045	186	1	2026-01-16 12:05:28.812978	transfer_date	\N	2025-06-20
3046	186	1	2026-01-16 12:05:28.813667	recruiter	\N	Орлов М.С.
3047	186	1	2026-01-16 12:05:28.814494	hr_bp	\N	Волкова Н.В.
3048	186	1	2026-01-16 12:05:28.815089	comments	\N	
3049	187	1	2026-01-16 12:05:28.838754	entry_date	\N	2024-02-13
3050	187	1	2026-01-16 12:05:28.839915	current_manager	\N	Иванов А.П.
3051	187	1	2026-01-16 12:05:28.840494	it_block	\N	Диджитал
3052	187	1	2026-01-16 12:05:28.840972	ck_department	\N	ЦК Инфраструктуры
3053	187	1	2026-01-16 12:05:28.841589	placement_type	\N	перевод
3054	187	1	2026-01-16 12:05:28.842093	ready_for_vacancy	\N	Нет
3055	187	1	2026-01-16 12:05:28.842559	resume_link	\N	https://drive.google.com/file/44590
3056	187	1	2026-01-16 12:05:28.842981	manager_feedback	\N	
3057	187	1	2026-01-16 12:05:28.843416	contacts	\N	+7 (959) 386-82-90, @михандр18, arseny.morozov171@company.ru
3058	187	1	2026-01-16 12:05:28.843827	funding_end_date	\N	2026-07-13
3059	187	1	2026-01-16 12:05:28.844273	candidate_status	\N	Переведен
3060	187	1	2026-01-16 12:05:28.844945	target_projects	\N	Госуслуги 2.0, Mobile App, Infrastructure
3061	187	1	2026-01-16 12:05:28.845601	transfer_date	\N	2026-11-02
3062	187	1	2026-01-16 12:05:28.846113	recruiter	\N	Смирнова А.А.
3063	187	1	2026-01-16 12:05:28.846946	hr_bp	\N	Лебедева Т.М.
3064	187	1	2026-01-16 12:05:28.847387	comments	\N	Ожидает оффер
3065	191	1	2026-01-16 12:05:28.874976	entry_date	\N	2025-02-20
3066	191	1	2026-01-16 12:05:28.877443	current_manager	\N	Михайлова О.Н.
3067	191	1	2026-01-16 12:05:28.878232	it_block	\N	Развитие
3068	191	1	2026-01-16 12:05:28.87893	ck_department	\N	ЦК Инфраструктуры
3069	191	1	2026-01-16 12:05:28.879608	placement_type	\N	перевод
3070	191	1	2026-01-16 12:05:28.88012	ready_for_vacancy	\N	Да
3071	191	1	2026-01-16 12:05:28.88057	resume_link	\N	https://drive.google.com/file/81809
3072	191	1	2026-01-16 12:05:28.880985	manager_feedback	\N	Рекомендую
3073	191	1	2026-01-16 12:05:28.881608	contacts	\N	+7 (962) 965-58-63, @волмакс56, igor.nikitin175@company.ru
3074	191	1	2026-01-16 12:05:28.882394	funding_end_date	\N	2026-09-18
3075	191	1	2026-01-16 12:05:28.883048	candidate_status	\N	Увольнение по СЖ
3076	191	1	2026-01-16 12:05:28.88368	target_projects	\N	ML Pipeline
3077	191	1	2026-01-16 12:05:28.884152	transfer_date	\N	2026-12-05
3078	191	1	2026-01-16 12:05:28.884811	recruiter	\N	Новикова Е.П.
3079	191	1	2026-01-16 12:05:28.885298	hr_bp	\N	Лебедева Т.М.
3080	191	1	2026-01-16 12:05:28.885986	comments	\N	В процессе согласования
3081	197	1	2026-01-16 12:05:28.9059	entry_date	\N	2024-02-27
3082	197	1	2026-01-16 12:05:28.906428	current_manager	\N	Михайлова О.Н.
3083	197	1	2026-01-16 12:05:28.906809	it_block	\N	НУК
3084	197	1	2026-01-16 12:05:28.907146	ck_department	\N	ЦК Инфраструктуры
3085	197	1	2026-01-16 12:05:28.907604	placement_type	\N	любой
3086	197	1	2026-01-16 12:05:28.908011	ready_for_vacancy	\N	Нет
3087	197	1	2026-01-16 12:05:28.908598	resume_link	\N	https://drive.google.com/file/16991
3088	197	1	2026-01-16 12:05:28.909179	manager_feedback	\N	
3089	197	1	2026-01-16 12:05:28.909931	contacts	\N	+7 (975) 709-76-38, @куздени76, igor.pavlov181@company.ru
3090	197	1	2026-01-16 12:05:28.910517	funding_end_date	\N	2025-06-14
3091	197	1	2026-01-16 12:05:28.91107	candidate_status	\N	В работе
3092	197	1	2026-01-16 12:05:28.911465	target_projects	\N	E-commerce Platform, Mobile App, Data Platform
3093	197	1	2026-01-16 12:05:28.911798	transfer_date	\N	
3094	197	1	2026-01-16 12:05:28.912116	recruiter	\N	Новикова Е.П.
3095	197	1	2026-01-16 12:05:28.912758	hr_bp	\N	Волкова Н.В.
3096	197	1	2026-01-16 12:05:28.913329	comments	\N	Срочно нужен проект
3097	185	1	2026-01-16 12:05:28.937319	entry_date	\N	2024-04-25
3098	185	1	2026-01-16 12:05:28.938041	current_manager	\N	Козлов Д.В.
3099	185	1	2026-01-16 12:05:28.938703	it_block	\N	Эксплуатация
3100	185	1	2026-01-16 12:05:28.939239	ck_department	\N	ЦК Аналитики
3101	185	1	2026-01-16 12:05:28.939791	placement_type	\N	любой
3102	185	1	2026-01-16 12:05:28.940346	ready_for_vacancy	\N	Да
3103	185	1	2026-01-16 12:05:28.941116	resume_link	\N	https://drive.google.com/file/16759
3104	185	1	2026-01-16 12:05:28.941672	manager_feedback	\N	
3105	185	1	2026-01-16 12:05:28.942073	contacts	\N	+7 (986) 500-85-23, @петалек4, sergey.kiselev169@company.ru
3106	185	1	2026-01-16 12:05:28.942417	funding_end_date	\N	2026-08-16
3107	185	1	2026-01-16 12:05:28.943014	candidate_status	\N	В работе
3108	185	1	2026-01-16 12:05:28.943703	target_projects	\N	Banking App, DevOps Platform
3109	185	1	2026-01-16 12:05:28.944181	transfer_date	\N	
3110	185	1	2026-01-16 12:05:28.944592	recruiter	\N	Орлов М.С.
3111	185	1	2026-01-16 12:05:28.944948	hr_bp	\N	Лебедева Т.М.
3112	185	1	2026-01-16 12:05:28.945564	comments	\N	
3113	196	1	2026-01-16 12:05:28.970943	entry_date	\N	2024-08-27
3114	196	1	2026-01-16 12:05:28.971767	current_manager	\N	Михайлова О.Н.
3115	196	1	2026-01-16 12:05:28.972306	it_block	\N	Диджитал
3116	196	1	2026-01-16 12:05:28.972729	ck_department	\N	ЦК Инфраструктуры
3117	196	1	2026-01-16 12:05:28.973302	placement_type	\N	любой
3118	196	1	2026-01-16 12:05:28.973848	ready_for_vacancy	\N	Да
3119	196	1	2026-01-16 12:05:28.974321	resume_link	\N	https://drive.google.com/file/69107
3120	196	1	2026-01-16 12:05:28.974702	manager_feedback	\N	Рекомендую
3121	196	1	2026-01-16 12:05:28.975219	contacts	\N	+7 (907) 357-97-74, @смиилья24, roman.zakharov180@company.ru
3122	196	1	2026-01-16 12:05:28.975661	funding_end_date	\N	2025-06-28
3123	196	1	2026-01-16 12:05:28.976136	candidate_status	\N	Забронирован
3124	196	1	2026-01-16 12:05:28.976575	target_projects	\N	Banking App, E-commerce Platform, Госуслуги 2.0
3125	196	1	2026-01-16 12:05:28.976972	transfer_date	\N	
3126	196	1	2026-01-16 12:05:28.977541	recruiter	\N	Новикова Е.П.
3127	196	1	2026-01-16 12:05:28.978253	hr_bp	\N	Морозов К.А.
3128	196	1	2026-01-16 12:05:28.978857	comments	\N	
3129	199	1	2026-01-16 12:05:29.007607	entry_date	\N	2024-12-14
3130	199	1	2026-01-16 12:05:29.008383	current_manager	\N	Сидорова Е.К.
3131	199	1	2026-01-16 12:05:29.008867	it_block	\N	Развитие
3132	199	1	2026-01-16 12:05:29.009294	ck_department	\N	ЦК Аналитики
3133	199	1	2026-01-16 12:05:29.009784	placement_type	\N	аутстафф
3134	199	1	2026-01-16 12:05:29.010298	ready_for_vacancy	\N	Да
3135	199	1	2026-01-16 12:05:29.010678	resume_link	\N	https://drive.google.com/file/95748
3136	199	1	2026-01-16 12:05:29.011163	manager_feedback	\N	Отличные результаты
3137	199	1	2026-01-16 12:05:29.011911	contacts	\N	+7 (919) 605-86-25, @васиван16, roman.smirnov183@company.ru
3138	199	1	2026-01-16 12:05:29.012449	funding_end_date	\N	2026-08-15
3139	199	1	2026-01-16 12:05:29.0129	candidate_status	\N	Увольнение по СС
3140	199	1	2026-01-16 12:05:29.013277	target_projects	\N	Infrastructure
3141	199	1	2026-01-16 12:05:29.01395	transfer_date	\N	2025-12-23
3142	199	1	2026-01-16 12:05:29.01437	recruiter	\N	Белова И.Д.
3143	199	1	2026-01-16 12:05:29.014739	hr_bp	\N	Морозов К.А.
3144	199	1	2026-01-16 12:05:29.015098	comments	\N	
3145	189	1	2026-01-16 12:05:29.048857	entry_date	\N	2024-08-09
3146	189	1	2026-01-16 12:05:29.049759	current_manager	\N	Иванов А.П.
3147	189	1	2026-01-16 12:05:29.050533	it_block	\N	НУК
3148	189	1	2026-01-16 12:05:29.051505	ck_department	\N	Департамент данных
3149	189	1	2026-01-16 12:05:29.052444	placement_type	\N	перевод
3150	189	1	2026-01-16 12:05:29.053107	ready_for_vacancy	\N	Нет
3151	189	1	2026-01-16 12:05:29.05402	resume_link	\N	https://drive.google.com/file/84872
3152	189	1	2026-01-16 12:05:29.054636	manager_feedback	\N	Отличные результаты
3153	189	1	2026-01-16 12:05:29.055188	contacts	\N	+7 (976) 864-71-20, @фёдсерг82, viktor.alexandrov173@company.ru
3154	189	1	2026-01-16 12:05:29.056223	funding_end_date	\N	2025-12-12
3155	189	1	2026-01-16 12:05:29.057176	candidate_status	\N	Свободен
3156	189	1	2026-01-16 12:05:29.058287	target_projects	\N	Mobile App, ML Pipeline
3157	189	1	2026-01-16 12:05:29.058888	transfer_date	\N	
3158	189	1	2026-01-16 12:05:29.059374	recruiter	\N	Смирнова А.А.
3159	189	1	2026-01-16 12:05:29.059833	hr_bp	\N	Лебедева Т.М.
3160	189	1	2026-01-16 12:05:29.060281	comments	\N	Срочно нужен проект
3161	183	1	2026-01-16 12:05:29.107547	entry_date	\N	2024-01-30
3162	183	1	2026-01-16 12:05:29.108111	current_manager	\N	Иванов А.П.
3163	183	1	2026-01-16 12:05:29.108771	it_block	\N	Прочее
3164	183	1	2026-01-16 12:05:29.109921	ck_department	\N	ЦК Разработки
3165	183	1	2026-01-16 12:05:29.110824	placement_type	\N	перевод
3166	183	1	2026-01-16 12:05:29.111495	ready_for_vacancy	\N	Нет
3167	183	1	2026-01-16 12:05:29.112147	resume_link	\N	https://drive.google.com/file/20661
3168	183	1	2026-01-16 12:05:29.112739	manager_feedback	\N	
3169	183	1	2026-01-16 12:05:29.113612	contacts	\N	+7 (953) 584-31-57, @попартё77, maxim.makarov167@company.ru
3170	183	1	2026-01-16 12:05:29.114275	funding_end_date	\N	2026-10-01
3171	183	1	2026-01-16 12:05:29.11485	candidate_status	\N	Увольнение по СЖ
3172	183	1	2026-01-16 12:05:29.11542	target_projects	\N	DevOps Platform, Banking App, ML Pipeline
3173	183	1	2026-01-16 12:05:29.115987	transfer_date	\N	2026-03-23
3174	183	1	2026-01-16 12:05:29.117346	recruiter	\N	Орлов М.С.
3175	183	1	2026-01-16 12:05:29.118328	hr_bp	\N	Лебедева Т.М.
3176	183	1	2026-01-16 12:05:29.118985	comments	\N	Срочно нужен проект
3177	204	1	2026-01-16 12:05:29.150886	entry_date	\N	2025-03-15
3178	204	1	2026-01-16 12:05:29.151713	current_manager	\N	Иванов А.П.
3179	204	1	2026-01-16 12:05:29.152228	it_block	\N	Эксплуатация
3180	204	1	2026-01-16 12:05:29.152696	ck_department	\N	ЦК Инфраструктуры
3181	204	1	2026-01-16 12:05:29.153142	placement_type	\N	перевод
3182	204	1	2026-01-16 12:05:29.15373	ready_for_vacancy	\N	Нет
3183	204	1	2026-01-16 12:05:29.154285	resume_link	\N	https://drive.google.com/file/17526
3184	204	1	2026-01-16 12:05:29.154827	manager_feedback	\N	Хороший специалист
3185	204	1	2026-01-16 12:05:29.155564	contacts	\N	+7 (979) 899-43-33, @фёдсерг49, elena.vorobyov188@company.ru
3186	204	1	2026-01-16 12:05:29.156143	funding_end_date	\N	2026-11-20
3187	204	1	2026-01-16 12:05:29.156902	candidate_status	\N	Свободен
3188	204	1	2026-01-16 12:05:29.157627	target_projects	\N	Data Platform
3189	204	1	2026-01-16 12:05:29.158353	transfer_date	\N	
3190	204	1	2026-01-16 12:05:29.159106	recruiter	\N	Белова И.Д.
3191	204	1	2026-01-16 12:05:29.160019	hr_bp	\N	Волкова Н.В.
3192	204	1	2026-01-16 12:05:29.160738	comments	\N	
3193	190	1	2026-01-16 12:05:29.205802	entry_date	\N	2025-05-20
3194	190	1	2026-01-16 12:05:29.206566	current_manager	\N	Иванов А.П.
3195	190	1	2026-01-16 12:05:29.207218	it_block	\N	Развитие
3196	190	1	2026-01-16 12:05:29.207718	ck_department	\N	Департамент данных
3197	190	1	2026-01-16 12:05:29.208207	placement_type	\N	любой
3198	190	1	2026-01-16 12:05:29.209035	ready_for_vacancy	\N	Да
3199	190	1	2026-01-16 12:05:29.210012	resume_link	\N	https://drive.google.com/file/34043
3200	190	1	2026-01-16 12:05:29.210925	manager_feedback	\N	Отличные результаты
3201	190	1	2026-01-16 12:05:29.211806	contacts	\N	+7 (910) 163-56-91, @морники9, artem.kozlov174@company.ru
3202	190	1	2026-01-16 12:05:29.212719	funding_end_date	\N	2025-04-21
3203	190	1	2026-01-16 12:05:29.213626	candidate_status	\N	Переведен
3204	190	1	2026-01-16 12:05:29.214624	target_projects	\N	DevOps Platform, E-commerce Platform, ML Pipeline
3205	190	1	2026-01-16 12:05:29.215497	transfer_date	\N	2025-06-23
3206	190	1	2026-01-16 12:05:29.216366	recruiter	\N	Белова И.Д.
3207	190	1	2026-01-16 12:05:29.217411	hr_bp	\N	Лебедева Т.М.
3208	190	1	2026-01-16 12:05:29.218297	comments	\N	Ожидает оффер
3209	152	1	2026-01-16 12:05:29.283302	entry_date	\N	2024-12-15
3210	152	1	2026-01-16 12:05:29.284147	current_manager	\N	Петров С.М.
3211	152	1	2026-01-16 12:05:29.285069	it_block	\N	Развитие
3212	152	1	2026-01-16 12:05:29.285711	ck_department	\N	Департамент цифровых продуктов
3213	152	1	2026-01-16 12:05:29.286405	placement_type	\N	перевод
3214	152	1	2026-01-16 12:05:29.287534	ready_for_vacancy	\N	Да
3215	152	1	2026-01-16 12:05:29.288394	resume_link	\N	https://drive.google.com/file/18862
3216	152	1	2026-01-16 12:05:29.289326	manager_feedback	\N	Рекомендую
3217	152	1	2026-01-16 12:05:29.290179	contacts	\N	+7 (962) 211-57-41, @куздени96, egor.vasilev136@company.ru
3218	152	1	2026-01-16 12:05:29.291023	funding_end_date	\N	2025-08-21
3219	152	1	2026-01-16 12:05:29.291938	candidate_status	\N	Свободен
3220	152	1	2026-01-16 12:05:29.292776	target_projects	\N	Infrastructure, Banking App
3221	152	1	2026-01-16 12:05:29.29369	transfer_date	\N	
3222	152	1	2026-01-16 12:05:29.294696	recruiter	\N	Смирнова А.А.
3223	152	1	2026-01-16 12:05:29.295586	hr_bp	\N	Морозов К.А.
3224	152	1	2026-01-16 12:05:29.296509	comments	\N	
3225	184	1	2026-01-16 12:05:29.414336	entry_date	\N	2025-03-23
3226	184	1	2026-01-16 12:05:29.415656	current_manager	\N	Козлов Д.В.
3227	184	1	2026-01-16 12:05:29.416948	it_block	\N	B2O
3228	184	1	2026-01-16 12:05:29.41878	ck_department	\N	ЦК Разработки
3229	184	1	2026-01-16 12:05:29.419774	placement_type	\N	любой
3230	184	1	2026-01-16 12:05:29.420629	ready_for_vacancy	\N	Нет
3231	184	1	2026-01-16 12:05:29.421777	resume_link	\N	https://drive.google.com/file/85794
3232	184	1	2026-01-16 12:05:29.42296	manager_feedback	\N	
3233	184	1	2026-01-16 12:05:29.424156	contacts	\N	+7 (981) 134-59-47, @васиван94, julia.kuznetsov168@company.ru
3234	184	1	2026-01-16 12:05:29.425372	funding_end_date	\N	2026-08-20
3235	184	1	2026-01-16 12:05:29.426558	candidate_status	\N	Забронирован
3236	184	1	2026-01-16 12:05:29.427761	target_projects	\N	ML Pipeline, Mobile App, Data Platform
3237	184	1	2026-01-16 12:05:29.429038	transfer_date	\N	
3238	184	1	2026-01-16 12:05:29.430312	recruiter	\N	Орлов М.С.
3239	184	1	2026-01-16 12:05:29.431638	hr_bp	\N	Лебедева Т.М.
3240	184	1	2026-01-16 12:05:29.432954	comments	\N	
3241	192	1	2026-01-16 12:05:29.476284	entry_date	\N	2025-08-10
3242	192	1	2026-01-16 12:05:29.477465	current_manager	\N	Петров С.М.
3243	192	1	2026-01-16 12:05:29.478303	it_block	\N	Эксплуатация
3244	192	1	2026-01-16 12:05:29.478962	ck_department	\N	ЦК Аналитики
3245	192	1	2026-01-16 12:05:29.479618	placement_type	\N	перевод
3246	192	1	2026-01-16 12:05:29.48028	ready_for_vacancy	\N	Да
3247	192	1	2026-01-16 12:05:29.480948	resume_link	\N	https://drive.google.com/file/41682
3248	192	1	2026-01-16 12:05:29.482035	manager_feedback	\N	Рекомендую
3249	192	1	2026-01-16 12:05:29.483004	contacts	\N	+7 (923) 523-62-73, @алемиха94, vladimir.sergeev176@company.ru
3250	192	1	2026-01-16 12:05:29.48383	funding_end_date	\N	2026-08-06
3251	192	1	2026-01-16 12:05:29.484558	candidate_status	\N	Увольнение по СЖ
3252	192	1	2026-01-16 12:05:29.485388	target_projects	\N	Banking App
3253	192	1	2026-01-16 12:05:29.486068	transfer_date	\N	2025-09-15
3254	192	1	2026-01-16 12:05:29.486549	recruiter	\N	Смирнова А.А.
3255	192	1	2026-01-16 12:05:29.487203	hr_bp	\N	Волкова Н.В.
3256	192	1	2026-01-16 12:05:29.487759	comments	\N	Срочно нужен проект
3257	215	1	2026-01-16 12:05:29.524272	entry_date	\N	2024-12-13
3258	215	1	2026-01-16 12:05:29.525066	current_manager	\N	Сидорова Е.К.
3259	215	1	2026-01-16 12:05:29.525797	it_block	\N	B2O
3260	215	1	2026-01-16 12:05:29.526457	ck_department	\N	ЦК Аналитики
3261	215	1	2026-01-16 12:05:29.527077	placement_type	\N	аутстафф
3262	215	1	2026-01-16 12:05:29.527644	ready_for_vacancy	\N	Нет
3263	215	1	2026-01-16 12:05:29.528327	resume_link	\N	https://drive.google.com/file/32906
3264	215	1	2026-01-16 12:05:29.529047	manager_feedback	\N	Отличные результаты
3265	215	1	2026-01-16 12:05:29.529681	contacts	\N	+7 (992) 179-59-69, @петалек5, artem.zakharov199@company.ru
3266	215	1	2026-01-16 12:05:29.53015	funding_end_date	\N	2025-06-22
3267	215	1	2026-01-16 12:05:29.530706	candidate_status	\N	Переведен
3268	215	1	2026-01-16 12:05:29.531201	target_projects	\N	Госуслуги 2.0, E-commerce Platform
3269	215	1	2026-01-16 12:05:29.531627	transfer_date	\N	2025-11-15
3270	215	1	2026-01-16 12:05:29.532017	recruiter	\N	Смирнова А.А.
3271	215	1	2026-01-16 12:05:29.532488	hr_bp	\N	Волкова Н.В.
3272	215	1	2026-01-16 12:05:29.532842	comments	\N	
3273	75	1	2026-01-16 12:05:29.566574	entry_date	\N	2024-08-14
3274	75	1	2026-01-16 12:05:29.567389	current_manager	\N	Козлов Д.В.
3275	75	1	2026-01-16 12:05:29.568193	it_block	\N	Эксплуатация
3276	75	1	2026-01-16 12:05:29.568838	ck_department	\N	ЦК Инфраструктуры
3277	75	1	2026-01-16 12:05:29.569665	placement_type	\N	аутстафф
3278	75	1	2026-01-16 12:05:29.570533	ready_for_vacancy	\N	Нет
3279	75	1	2026-01-16 12:05:29.571424	resume_link	\N	https://drive.google.com/file/70809
3280	75	1	2026-01-16 12:05:29.572242	manager_feedback	\N	Нужно развитие
3281	75	1	2026-01-16 12:05:29.572954	contacts	\N	+7 (966) 736-95-53, @иваалек96, timofey.orlov59@company.ru
3282	75	1	2026-01-16 12:05:29.573575	funding_end_date	\N	2026-06-16
3283	75	1	2026-01-16 12:05:29.574186	candidate_status	\N	Забронирован
3284	75	1	2026-01-16 12:05:29.574898	target_projects	\N	Госуслуги 2.0, Data Platform
3285	75	1	2026-01-16 12:05:29.575605	transfer_date	\N	
3286	75	1	2026-01-16 12:05:29.576146	recruiter	\N	Смирнова А.А.
3287	75	1	2026-01-16 12:05:29.576527	hr_bp	\N	Лебедева Т.М.
3288	75	1	2026-01-16 12:05:29.576881	comments	\N	Срочно нужен проект
3289	174	1	2026-01-16 12:05:29.605917	entry_date	\N	2024-09-16
3290	174	1	2026-01-16 12:05:29.606903	current_manager	\N	Михайлова О.Н.
3291	174	1	2026-01-16 12:05:29.607926	it_block	\N	Прочее
3292	174	1	2026-01-16 12:05:29.608885	ck_department	\N	ЦК Инфраструктуры
3293	174	1	2026-01-16 12:05:29.609706	placement_type	\N	аутстафф
3294	174	1	2026-01-16 12:05:29.610308	ready_for_vacancy	\N	Нет
3295	174	1	2026-01-16 12:05:29.610832	resume_link	\N	https://drive.google.com/file/99519
3296	174	1	2026-01-16 12:05:29.61137	manager_feedback	\N	Рекомендую
3297	174	1	2026-01-16 12:05:29.611856	contacts	\N	+7 (982) 264-36-61, @фёдсерг63, roman.kiselev158@company.ru
3298	174	1	2026-01-16 12:05:29.612556	funding_end_date	\N	2026-09-17
3299	174	1	2026-01-16 12:05:29.613429	candidate_status	\N	Переведен
3300	174	1	2026-01-16 12:05:29.614027	target_projects	\N	Infrastructure, Mobile App
3301	174	1	2026-01-16 12:05:29.61462	transfer_date	\N	2026-05-25
3302	174	1	2026-01-16 12:05:29.614998	recruiter	\N	Орлов М.С.
3303	174	1	2026-01-16 12:05:29.615524	hr_bp	\N	Волкова Н.В.
3304	174	1	2026-01-16 12:05:29.616087	comments	\N	Ожидает оффер
3305	198	1	2026-01-16 12:05:29.64907	entry_date	\N	2024-03-31
3306	198	1	2026-01-16 12:05:29.649773	current_manager	\N	Петров С.М.
3307	198	1	2026-01-16 12:05:29.650424	it_block	\N	B2O
3308	198	1	2026-01-16 12:05:29.651028	ck_department	\N	Департамент данных
3309	198	1	2026-01-16 12:05:29.651689	placement_type	\N	перевод
3310	198	1	2026-01-16 12:05:29.652217	ready_for_vacancy	\N	Да
3311	198	1	2026-01-16 12:05:29.652831	resume_link	\N	https://drive.google.com/file/34774
3312	198	1	2026-01-16 12:05:29.653505	manager_feedback	\N	
3313	198	1	2026-01-16 12:05:29.654009	contacts	\N	+7 (932) 522-92-64, @попартё49, irina.andreev182@company.ru
3314	198	1	2026-01-16 12:05:29.654701	funding_end_date	\N	2026-08-09
3315	198	1	2026-01-16 12:05:29.655254	candidate_status	\N	Свободен
3316	198	1	2026-01-16 12:05:29.655885	target_projects	\N	E-commerce Platform
3317	198	1	2026-01-16 12:05:29.656459	transfer_date	\N	
3318	198	1	2026-01-16 12:05:29.656949	recruiter	\N	Белова И.Д.
3319	198	1	2026-01-16 12:05:29.65756	hr_bp	\N	Лебедева Т.М.
3320	198	1	2026-01-16 12:05:29.658117	comments	\N	Ожидает оффер
3321	90	1	2026-01-16 12:05:29.692024	entry_date	\N	2025-10-13
3322	90	1	2026-01-16 12:05:29.69288	current_manager	\N	Сидорова Е.К.
3323	90	1	2026-01-16 12:05:29.693541	it_block	\N	НУК
3324	90	1	2026-01-16 12:05:29.694236	ck_department	\N	Департамент данных
3325	90	1	2026-01-16 12:05:29.694776	placement_type	\N	перевод
3326	90	1	2026-01-16 12:05:29.695343	ready_for_vacancy	\N	Да
3327	90	1	2026-01-16 12:05:29.695919	resume_link	\N	https://drive.google.com/file/50261
3328	90	1	2026-01-16 12:05:29.696488	manager_feedback	\N	
3329	90	1	2026-01-16 12:05:29.697046	contacts	\N	+7 (930) 311-61-96, @иваалек39, anna.popov74@company.ru
3330	90	1	2026-01-16 12:05:29.697664	funding_end_date	\N	2025-10-20
3331	90	1	2026-01-16 12:05:29.698098	candidate_status	\N	Переведен
3332	90	1	2026-01-16 12:05:29.698689	target_projects	\N	DevOps Platform, Banking App
3333	90	1	2026-01-16 12:05:29.699365	transfer_date	\N	2026-10-07
3334	90	1	2026-01-16 12:05:29.699881	recruiter	\N	Новикова Е.П.
3335	90	1	2026-01-16 12:05:29.700516	hr_bp	\N	Волкова Н.В.
3336	90	1	2026-01-16 12:05:29.701123	comments	\N	В процессе согласования
3337	182	1	2026-01-16 12:05:29.730525	entry_date	\N	2025-11-06
3338	182	1	2026-01-16 12:05:29.731332	current_manager	\N	Иванов А.П.
3339	182	1	2026-01-16 12:05:29.731903	it_block	\N	Эксплуатация
3340	182	1	2026-01-16 12:05:29.732635	ck_department	\N	ЦК Инфраструктуры
3341	182	1	2026-01-16 12:05:29.733252	placement_type	\N	любой
3342	182	1	2026-01-16 12:05:29.733773	ready_for_vacancy	\N	Да
3343	182	1	2026-01-16 12:05:29.73441	resume_link	\N	https://drive.google.com/file/32225
3344	182	1	2026-01-16 12:05:29.734945	manager_feedback	\N	Нужно развитие
3345	182	1	2026-01-16 12:05:29.735526	contacts	\N	+7 (964) 807-47-14, @куздени53, timofey.kiselev166@company.ru
3346	182	1	2026-01-16 12:05:29.736088	funding_end_date	\N	2026-07-13
3347	182	1	2026-01-16 12:05:29.736648	candidate_status	\N	Увольнение по СЖ
3348	182	1	2026-01-16 12:05:29.737304	target_projects	\N	Госуслуги 2.0, Mobile App
3349	182	1	2026-01-16 12:05:29.737869	transfer_date	\N	2025-06-16
3350	182	1	2026-01-16 12:05:29.738504	recruiter	\N	Смирнова А.А.
3351	182	1	2026-01-16 12:05:29.739097	hr_bp	\N	Лебедева Т.М.
3352	182	1	2026-01-16 12:05:29.739715	comments	\N	Ожидает оффер
3353	195	1	2026-01-16 12:05:29.768161	entry_date	\N	2025-02-03
3354	195	1	2026-01-16 12:05:29.768666	current_manager	\N	Сидорова Е.К.
3355	195	1	2026-01-16 12:05:29.769027	it_block	\N	B2O
3356	195	1	2026-01-16 12:05:29.769472	ck_department	\N	Департамент цифровых продуктов
3357	195	1	2026-01-16 12:05:29.769923	placement_type	\N	перевод
3358	195	1	2026-01-16 12:05:29.770382	ready_for_vacancy	\N	Да
3359	195	1	2026-01-16 12:05:29.770941	resume_link	\N	https://drive.google.com/file/28156
3360	195	1	2026-01-16 12:05:29.771458	manager_feedback	\N	Отличные результаты
3361	195	1	2026-01-16 12:05:29.771964	contacts	\N	+7 (957) 188-91-11, @иваалек17, igor.fedorov179@company.ru
3362	195	1	2026-01-16 12:05:29.772325	funding_end_date	\N	2026-01-24
3363	195	1	2026-01-16 12:05:29.772637	candidate_status	\N	В работе
3364	195	1	2026-01-16 12:05:29.772933	target_projects	\N	Infrastructure, Banking App
3365	195	1	2026-01-16 12:05:29.773294	transfer_date	\N	
3366	195	1	2026-01-16 12:05:29.773618	recruiter	\N	Смирнова А.А.
3367	195	1	2026-01-16 12:05:29.773918	hr_bp	\N	Волкова Н.В.
3368	195	1	2026-01-16 12:05:29.774439	comments	\N	В процессе согласования
3369	61	1	2026-01-16 12:05:29.793988	entry_date	\N	2024-10-14
3370	61	1	2026-01-16 12:05:29.794504	current_manager	\N	Козлов Д.В.
3371	61	1	2026-01-16 12:05:29.794872	it_block	\N	НУК
3372	61	1	2026-01-16 12:05:29.795194	ck_department	\N	ЦК Разработки
3373	61	1	2026-01-16 12:05:29.795498	placement_type	\N	аутстафф
3374	61	1	2026-01-16 12:05:29.795829	ready_for_vacancy	\N	Да
3375	61	1	2026-01-16 12:05:29.796145	resume_link	\N	https://drive.google.com/file/88027
3376	61	1	2026-01-16 12:05:29.796652	manager_feedback	\N	Отличные результаты
3377	61	1	2026-01-16 12:05:29.797135	contacts	\N	+7 (912) 512-63-37, @смиилья34, alexey.lebedev45@company.ru
3378	61	1	2026-01-16 12:05:29.797609	funding_end_date	\N	2025-05-25
3379	61	1	2026-01-16 12:05:29.798111	candidate_status	\N	Увольнение по СС
3380	61	1	2026-01-16 12:05:29.798511	target_projects	\N	E-commerce Platform
3381	61	1	2026-01-16 12:05:29.799189	transfer_date	\N	2026-01-15
3382	61	1	2026-01-16 12:05:29.799842	recruiter	\N	Смирнова А.А.
3383	61	1	2026-01-16 12:05:29.80026	hr_bp	\N	Волкова Н.В.
3384	61	1	2026-01-16 12:05:29.800591	comments	\N	В процессе согласования
3385	76	1	2026-01-16 12:05:29.825461	entry_date	\N	2025-12-30
3386	76	1	2026-01-16 12:05:29.826234	current_manager	\N	Михайлова О.Н.
3387	76	1	2026-01-16 12:05:29.826989	it_block	\N	Прочее
3388	76	1	2026-01-16 12:05:29.827628	ck_department	\N	ЦК Разработки
3389	76	1	2026-01-16 12:05:29.828108	placement_type	\N	любой
3390	76	1	2026-01-16 12:05:29.828591	ready_for_vacancy	\N	Да
3391	76	1	2026-01-16 12:05:29.829064	resume_link	\N	https://drive.google.com/file/89745
3392	76	1	2026-01-16 12:05:29.829574	manager_feedback	\N	Отличные результаты
3393	76	1	2026-01-16 12:05:29.830145	contacts	\N	+7 (907) 247-33-39, @смиилья44, alexander.smirnov60@company.ru
3394	76	1	2026-01-16 12:05:29.830648	funding_end_date	\N	2025-09-22
3395	76	1	2026-01-16 12:05:29.831134	candidate_status	\N	В работе
3396	76	1	2026-01-16 12:05:29.83162	target_projects	\N	Banking App, Госуслуги 2.0, DevOps Platform
3397	76	1	2026-01-16 12:05:29.832267	transfer_date	\N	
3398	76	1	2026-01-16 12:05:29.832869	recruiter	\N	Орлов М.С.
3399	76	1	2026-01-16 12:05:29.833457	hr_bp	\N	Лебедева Т.М.
3400	76	1	2026-01-16 12:05:29.833986	comments	\N	
3401	104	1	2026-01-16 12:05:29.869348	entry_date	\N	2025-08-14
3402	104	1	2026-01-16 12:05:29.869952	current_manager	\N	Михайлова О.Н.
3403	104	1	2026-01-16 12:05:29.870393	it_block	\N	Эксплуатация
3404	104	1	2026-01-16 12:05:29.870791	ck_department	\N	Департамент данных
3405	104	1	2026-01-16 12:05:29.871199	placement_type	\N	любой
3406	104	1	2026-01-16 12:05:29.871575	ready_for_vacancy	\N	Нет
3407	104	1	2026-01-16 12:05:29.871947	resume_link	\N	https://drive.google.com/file/70837
3408	104	1	2026-01-16 12:05:29.872307	manager_feedback	\N	
3409	104	1	2026-01-16 12:05:29.872734	contacts	\N	+7 (905) 537-25-69, @семкири46, ilya.andreev88@company.ru
3410	104	1	2026-01-16 12:05:29.873098	funding_end_date	\N	2025-02-16
3411	104	1	2026-01-16 12:05:29.873667	candidate_status	\N	В работе
3412	104	1	2026-01-16 12:05:29.874095	target_projects	\N	E-commerce Platform, Banking App
3413	104	1	2026-01-16 12:05:29.874487	transfer_date	\N	
3414	104	1	2026-01-16 12:05:29.87488	recruiter	\N	Новикова Е.П.
3415	104	1	2026-01-16 12:05:29.875258	hr_bp	\N	Морозов К.А.
3416	104	1	2026-01-16 12:05:29.875653	comments	\N	Ожидает оффер
3417	105	1	2026-01-16 12:05:29.906926	entry_date	\N	2024-12-11
3418	105	1	2026-01-16 12:05:29.907739	current_manager	\N	Михайлова О.Н.
3419	105	1	2026-01-16 12:05:29.90832	it_block	\N	Прочее
3420	105	1	2026-01-16 12:05:29.909221	ck_department	\N	Департамент цифровых продуктов
3421	105	1	2026-01-16 12:05:29.909951	placement_type	\N	аутстафф
3422	105	1	2026-01-16 12:05:29.910463	ready_for_vacancy	\N	Да
3423	105	1	2026-01-16 12:05:29.911162	resume_link	\N	https://drive.google.com/file/94825
3424	105	1	2026-01-16 12:05:29.911728	manager_feedback	\N	Хороший специалист
3425	105	1	2026-01-16 12:05:29.912233	contacts	\N	+7 (970) 301-48-37, @иваалек58, grigory.egorov89@company.ru
3426	105	1	2026-01-16 12:05:29.912908	funding_end_date	\N	2026-06-22
3427	105	1	2026-01-16 12:05:29.913476	candidate_status	\N	Переведен
3428	105	1	2026-01-16 12:05:29.914158	target_projects	\N	Data Platform
3429	105	1	2026-01-16 12:05:29.914859	transfer_date	\N	2025-07-20
3430	105	1	2026-01-16 12:05:29.915375	recruiter	\N	Новикова Е.П.
3431	105	1	2026-01-16 12:05:29.915874	hr_bp	\N	Лебедева Т.М.
3432	105	1	2026-01-16 12:05:29.916358	comments	\N	Ожидает оффер
3433	133	1	2026-01-16 12:05:29.945833	entry_date	\N	2025-08-15
3434	133	1	2026-01-16 12:05:29.94654	current_manager	\N	Михайлова О.Н.
3435	133	1	2026-01-16 12:05:29.94722	it_block	\N	Диджитал
3436	133	1	2026-01-16 12:05:29.947894	ck_department	\N	ЦК Инфраструктуры
3437	133	1	2026-01-16 12:05:29.94852	placement_type	\N	перевод
3438	133	1	2026-01-16 12:05:29.949054	ready_for_vacancy	\N	Нет
3439	133	1	2026-01-16 12:05:29.949666	resume_link	\N	https://drive.google.com/file/16375
3440	133	1	2026-01-16 12:05:29.950466	manager_feedback	\N	
3441	133	1	2026-01-16 12:05:29.951235	contacts	\N	+7 (931) 725-14-52, @лебдмит54, ruslan.kozlov117@company.ru
3442	133	1	2026-01-16 12:05:29.951843	funding_end_date	\N	2026-12-16
3443	133	1	2026-01-16 12:05:29.952433	candidate_status	\N	Увольнение по СС
3444	133	1	2026-01-16 12:05:29.952921	target_projects	\N	Data Platform
3445	133	1	2026-01-16 12:05:29.953451	transfer_date	\N	2025-02-19
3446	133	1	2026-01-16 12:05:29.954068	recruiter	\N	Смирнова А.А.
3447	133	1	2026-01-16 12:05:29.954805	hr_bp	\N	Морозов К.А.
3448	133	1	2026-01-16 12:05:29.955457	comments	\N	Ожидает оффер
3449	211	1	2026-01-16 12:05:29.983107	entry_date	\N	2024-06-10
3450	211	1	2026-01-16 12:05:29.983941	current_manager	\N	Сидорова Е.К.
3451	211	1	2026-01-16 12:05:29.984551	it_block	\N	B2O
3452	211	1	2026-01-16 12:05:29.985077	ck_department	\N	Департамент цифровых продуктов
3453	211	1	2026-01-16 12:05:29.985679	placement_type	\N	перевод
3454	211	1	2026-01-16 12:05:29.986129	ready_for_vacancy	\N	Нет
3455	211	1	2026-01-16 12:05:29.986503	resume_link	\N	https://drive.google.com/file/96831
3456	211	1	2026-01-16 12:05:29.989921	manager_feedback	\N	
3457	211	1	2026-01-16 12:05:29.994648	contacts	\N	+7 (900) 546-91-19, @смиилья40, irina.sokolov195@company.ru
3458	211	1	2026-01-16 12:05:29.995245	funding_end_date	\N	2025-09-25
3459	211	1	2026-01-16 12:05:29.995707	candidate_status	\N	Увольнение по СС
3460	211	1	2026-01-16 12:05:29.996118	target_projects	\N	DevOps Platform, Banking App, E-commerce Platform
3461	211	1	2026-01-16 12:05:29.996674	transfer_date	\N	2026-12-13
3462	211	1	2026-01-16 12:05:29.997446	recruiter	\N	Новикова Е.П.
3463	211	1	2026-01-16 12:05:29.997957	hr_bp	\N	Лебедева Т.М.
3464	211	1	2026-01-16 12:05:29.998335	comments	\N	Срочно нужен проект
3465	54	1	2026-01-16 12:05:30.026235	entry_date	\N	2024-08-19
3466	54	1	2026-01-16 12:05:30.027057	current_manager	\N	Петров С.М.
3467	54	1	2026-01-16 12:05:30.027944	it_block	\N	B2O
3468	54	1	2026-01-16 12:05:30.028634	ck_department	\N	ЦК Аналитики
3469	54	1	2026-01-16 12:05:30.029199	placement_type	\N	перевод
3470	54	1	2026-01-16 12:05:30.029914	ready_for_vacancy	\N	Нет
3471	54	1	2026-01-16 12:05:30.030496	resume_link	\N	https://drive.google.com/file/54770
3472	54	1	2026-01-16 12:05:30.031016	manager_feedback	\N	Хороший специалист
3473	54	1	2026-01-16 12:05:30.031529	contacts	\N	+7 (933) 890-58-69, @фёдсерг89, arseny.nikitin38@company.ru
3474	54	1	2026-01-16 12:05:30.032033	funding_end_date	\N	2025-02-28
3475	54	1	2026-01-16 12:05:30.032522	candidate_status	\N	В работе
3476	54	1	2026-01-16 12:05:30.033005	target_projects	\N	DevOps Platform, Infrastructure
3477	54	1	2026-01-16 12:05:30.033632	transfer_date	\N	
3478	54	1	2026-01-16 12:05:30.034078	recruiter	\N	Смирнова А.А.
3479	54	1	2026-01-16 12:05:30.034744	hr_bp	\N	Лебедева Т.М.
3480	54	1	2026-01-16 12:05:30.035461	comments	\N	Ожидает оффер
3481	57	1	2026-01-16 12:05:30.069307	entry_date	\N	2025-03-16
3482	57	1	2026-01-16 12:05:30.070262	current_manager	\N	Иванов А.П.
3483	57	1	2026-01-16 12:05:30.071036	it_block	\N	Диджитал
3484	57	1	2026-01-16 12:05:30.071678	ck_department	\N	Департамент данных
3485	57	1	2026-01-16 12:05:30.072195	placement_type	\N	перевод
3486	57	1	2026-01-16 12:05:30.072702	ready_for_vacancy	\N	Нет
3487	57	1	2026-01-16 12:05:30.073214	resume_link	\N	https://drive.google.com/file/55835
3488	57	1	2026-01-16 12:05:30.073722	manager_feedback	\N	Нужно развитие
3489	57	1	2026-01-16 12:05:30.074103	contacts	\N	+7 (916) 180-89-53, @алемиха57, alexey.stepanov41@company.ru
3490	57	1	2026-01-16 12:05:30.074437	funding_end_date	\N	2026-12-01
3491	57	1	2026-01-16 12:05:30.074755	candidate_status	\N	В работе
3492	57	1	2026-01-16 12:05:30.07506	target_projects	\N	Госуслуги 2.0
3493	57	1	2026-01-16 12:05:30.075365	transfer_date	\N	
3494	57	1	2026-01-16 12:05:30.075668	recruiter	\N	Новикова Е.П.
3495	57	1	2026-01-16 12:05:30.075966	hr_bp	\N	Лебедева Т.М.
3496	57	1	2026-01-16 12:05:30.076268	comments	\N	
3497	112	1	2026-01-16 12:05:30.103747	entry_date	\N	2024-05-21
3498	112	1	2026-01-16 12:05:30.104753	current_manager	\N	Сидорова Е.К.
3499	112	1	2026-01-16 12:05:30.105611	it_block	\N	НУК
3500	112	1	2026-01-16 12:05:30.106335	ck_department	\N	Департамент данных
3501	112	1	2026-01-16 12:05:30.107003	placement_type	\N	перевод
3502	112	1	2026-01-16 12:05:30.107524	ready_for_vacancy	\N	Да
3503	112	1	2026-01-16 12:05:30.108387	resume_link	\N	https://drive.google.com/file/73379
3504	112	1	2026-01-16 12:05:30.10903	manager_feedback	\N	Хороший специалист
3505	112	1	2026-01-16 12:05:30.109711	contacts	\N	+7 (998) 975-51-86, @михандр65, alexey.solovyov96@company.ru
3506	112	1	2026-01-16 12:05:30.110499	funding_end_date	\N	2026-04-23
3507	112	1	2026-01-16 12:05:30.111628	candidate_status	\N	Увольнение по СС
3508	112	1	2026-01-16 12:05:30.112228	target_projects	\N	Banking App, DevOps Platform
3509	112	1	2026-01-16 12:05:30.112966	transfer_date	\N	2025-06-26
3510	112	1	2026-01-16 12:05:30.113604	recruiter	\N	Орлов М.С.
3511	112	1	2026-01-16 12:05:30.114339	hr_bp	\N	Волкова Н.В.
3512	112	1	2026-01-16 12:05:30.115229	comments	\N	
3513	203	1	2026-01-16 12:05:30.140974	entry_date	\N	2024-11-12
3514	203	1	2026-01-16 12:05:30.141886	current_manager	\N	Козлов Д.В.
3515	203	1	2026-01-16 12:05:30.142558	it_block	\N	Диджитал
3516	203	1	2026-01-16 12:05:30.143234	ck_department	\N	ЦК Разработки
3517	203	1	2026-01-16 12:05:30.143861	placement_type	\N	перевод
3518	203	1	2026-01-16 12:05:30.144411	ready_for_vacancy	\N	Нет
3519	203	1	2026-01-16 12:05:30.144907	resume_link	\N	https://drive.google.com/file/40593
3520	203	1	2026-01-16 12:05:30.145737	manager_feedback	\N	Хороший специалист
3521	203	1	2026-01-16 12:05:30.146255	contacts	\N	+7 (917) 747-68-75, @новрома55, yuri.nikolaev187@company.ru
3522	203	1	2026-01-16 12:05:30.146749	funding_end_date	\N	2025-02-20
3523	203	1	2026-01-16 12:05:30.147378	candidate_status	\N	Свободен
3524	203	1	2026-01-16 12:05:30.149096	target_projects	\N	Госуслуги 2.0
3525	203	1	2026-01-16 12:05:30.14973	transfer_date	\N	
3526	203	1	2026-01-16 12:05:30.150172	recruiter	\N	Смирнова А.А.
3527	203	1	2026-01-16 12:05:30.151289	hr_bp	\N	Морозов К.А.
3528	203	1	2026-01-16 12:05:30.1526	comments	\N	Ожидает оффер
3529	125	1	2026-01-16 12:05:30.182122	entry_date	\N	2025-07-16
3530	125	1	2026-01-16 12:05:30.183103	current_manager	\N	Петров С.М.
3531	125	1	2026-01-16 12:05:30.183675	it_block	\N	Диджитал
3532	125	1	2026-01-16 12:05:30.184159	ck_department	\N	ЦК Разработки
3533	125	1	2026-01-16 12:05:30.184722	placement_type	\N	любой
3534	125	1	2026-01-16 12:05:30.185289	ready_for_vacancy	\N	Нет
3535	125	1	2026-01-16 12:05:30.185769	resume_link	\N	https://drive.google.com/file/42310
3536	125	1	2026-01-16 12:05:30.186382	manager_feedback	\N	Рекомендую
3537	125	1	2026-01-16 12:05:30.187021	contacts	\N	+7 (956) 989-19-88, @петалек5, andrey.mikhailov109@company.ru
3538	125	1	2026-01-16 12:05:30.187521	funding_end_date	\N	2025-04-23
3539	125	1	2026-01-16 12:05:30.187998	candidate_status	\N	Переведен
3540	125	1	2026-01-16 12:05:30.188466	target_projects	\N	ML Pipeline
3541	125	1	2026-01-16 12:05:30.188955	transfer_date	\N	2025-04-30
3542	125	1	2026-01-16 12:05:30.189422	recruiter	\N	Белова И.Д.
3543	125	1	2026-01-16 12:05:30.190105	hr_bp	\N	Морозов К.А.
3544	125	1	2026-01-16 12:05:30.190663	comments	\N	
3545	131	1	2026-01-16 12:05:30.209813	entry_date	\N	2025-08-12
3546	131	1	2026-01-16 12:05:30.210362	current_manager	\N	Иванов А.П.
3547	131	1	2026-01-16 12:05:30.210739	it_block	\N	Прочее
3548	131	1	2026-01-16 12:05:30.211063	ck_department	\N	ЦК Инфраструктуры
3549	131	1	2026-01-16 12:05:30.212816	placement_type	\N	перевод
3550	131	1	2026-01-16 12:05:30.214055	ready_for_vacancy	\N	Да
3551	131	1	2026-01-16 12:05:30.214586	resume_link	\N	https://drive.google.com/file/71523
3552	131	1	2026-01-16 12:05:30.215118	manager_feedback	\N	Нужно развитие
3553	131	1	2026-01-16 12:05:30.215483	contacts	\N	+7 (978) 462-33-86, @волмакс3, vladislav.alexeev115@company.ru
3554	131	1	2026-01-16 12:05:30.215805	funding_end_date	\N	2025-09-12
3555	131	1	2026-01-16 12:05:30.216118	candidate_status	\N	В работе
3556	131	1	2026-01-16 12:05:30.216419	target_projects	\N	Data Platform, Mobile App, Banking App
3557	131	1	2026-01-16 12:05:30.216721	transfer_date	\N	
3558	131	1	2026-01-16 12:05:30.217022	recruiter	\N	Новикова Е.П.
3559	131	1	2026-01-16 12:05:30.21738	hr_bp	\N	Морозов К.А.
3560	131	1	2026-01-16 12:05:30.218599	comments	\N	
3561	159	1	2026-01-16 12:05:30.255314	entry_date	\N	2024-09-09
3562	159	1	2026-01-16 12:05:30.256146	current_manager	\N	Сидорова Е.К.
3563	159	1	2026-01-16 12:05:30.257021	it_block	\N	B2O
3564	159	1	2026-01-16 12:05:30.257646	ck_department	\N	Департамент цифровых продуктов
3565	159	1	2026-01-16 12:05:30.258203	placement_type	\N	перевод
3566	159	1	2026-01-16 12:05:30.258707	ready_for_vacancy	\N	Нет
3567	159	1	2026-01-16 12:05:30.259087	resume_link	\N	https://drive.google.com/file/72845
3568	159	1	2026-01-16 12:05:30.259542	manager_feedback	\N	Рекомендую
3569	159	1	2026-01-16 12:05:30.260325	contacts	\N	+7 (970) 341-13-63, @фёдсерг8, timofey.yakovlev143@company.ru
3570	159	1	2026-01-16 12:05:30.261111	funding_end_date	\N	2025-12-01
3571	159	1	2026-01-16 12:05:30.261749	candidate_status	\N	Увольнение по СЖ
3572	159	1	2026-01-16 12:05:30.262124	target_projects	\N	Mobile App, Data Platform, Госуслуги 2.0
3573	159	1	2026-01-16 12:05:30.262611	transfer_date	\N	2025-05-29
3574	159	1	2026-01-16 12:05:30.263303	recruiter	\N	Новикова Е.П.
3575	159	1	2026-01-16 12:05:30.263962	hr_bp	\N	Морозов К.А.
3576	159	1	2026-01-16 12:05:30.264518	comments	\N	
3577	178	1	2026-01-16 12:05:30.290704	entry_date	\N	2025-01-14
3578	178	1	2026-01-16 12:05:30.291226	current_manager	\N	Иванов А.П.
3579	178	1	2026-01-16 12:05:30.291585	it_block	\N	Прочее
3580	178	1	2026-01-16 12:05:30.291902	ck_department	\N	Департамент цифровых продуктов
3581	178	1	2026-01-16 12:05:30.29221	placement_type	\N	аутстафф
3582	178	1	2026-01-16 12:05:30.292515	ready_for_vacancy	\N	Нет
3583	178	1	2026-01-16 12:05:30.292817	resume_link	\N	https://drive.google.com/file/66556
3584	178	1	2026-01-16 12:05:30.293123	manager_feedback	\N	Отличные результаты
3585	178	1	2026-01-16 12:05:30.293626	contacts	\N	+7 (922) 773-43-51, @лебдмит5, viktor.alexandrov162@company.ru
3586	178	1	2026-01-16 12:05:30.294005	funding_end_date	\N	2025-11-26
3587	178	1	2026-01-16 12:05:30.294324	candidate_status	\N	Увольнение по СС
3588	178	1	2026-01-16 12:05:30.294636	target_projects	\N	Banking App, Госуслуги 2.0, Mobile App
3589	178	1	2026-01-16 12:05:30.294935	transfer_date	\N	2025-03-16
3590	178	1	2026-01-16 12:05:30.295356	recruiter	\N	Белова И.Д.
3591	178	1	2026-01-16 12:05:30.295689	hr_bp	\N	Лебедева Т.М.
3592	178	1	2026-01-16 12:05:30.296001	comments	\N	Срочно нужен проект
3593	205	1	2026-01-16 12:05:30.339896	entry_date	\N	2025-09-15
3594	205	1	2026-01-16 12:05:30.340758	current_manager	\N	Сидорова Е.К.
3595	205	1	2026-01-16 12:05:30.341407	it_block	\N	Эксплуатация
3596	205	1	2026-01-16 12:05:30.341964	ck_department	\N	ЦК Разработки
3597	205	1	2026-01-16 12:05:30.342462	placement_type	\N	аутстафф
3598	205	1	2026-01-16 12:05:30.342956	ready_for_vacancy	\N	Да
3599	205	1	2026-01-16 12:05:30.34346	resume_link	\N	https://drive.google.com/file/64890
3600	205	1	2026-01-16 12:05:30.343942	manager_feedback	\N	Рекомендую
3601	205	1	2026-01-16 12:05:30.344424	contacts	\N	+7 (950) 545-53-87, @морники35, maxim.vasilev189@company.ru
3602	205	1	2026-01-16 12:05:30.345096	funding_end_date	\N	2025-01-23
3603	205	1	2026-01-16 12:05:30.345829	candidate_status	\N	Забронирован
3604	205	1	2026-01-16 12:05:30.346413	target_projects	\N	E-commerce Platform, DevOps Platform
3605	205	1	2026-01-16 12:05:30.346788	transfer_date	\N	
3606	205	1	2026-01-16 12:05:30.347117	recruiter	\N	Смирнова А.А.
3607	205	1	2026-01-16 12:05:30.347421	hr_bp	\N	Лебедева Т.М.
3608	205	1	2026-01-16 12:05:30.347721	comments	\N	
3609	214	1	2026-01-16 12:05:30.373125	entry_date	\N	2025-09-02
3610	214	1	2026-01-16 12:05:30.373802	current_manager	\N	Козлов Д.В.
3611	214	1	2026-01-16 12:05:30.374191	it_block	\N	Развитие
3612	214	1	2026-01-16 12:05:30.374512	ck_department	\N	ЦК Аналитики
3613	214	1	2026-01-16 12:05:30.37488	placement_type	\N	любой
3614	214	1	2026-01-16 12:05:30.37519	ready_for_vacancy	\N	Нет
3615	214	1	2026-01-16 12:05:30.375499	resume_link	\N	https://drive.google.com/file/35796
3616	214	1	2026-01-16 12:05:30.375792	manager_feedback	\N	Хороший специалист
3617	214	1	2026-01-16 12:05:30.376081	contacts	\N	+7 (944) 992-80-20, @васиван44, grigory.kuzmin198@company.ru
3618	214	1	2026-01-16 12:05:30.37637	funding_end_date	\N	2026-12-26
3619	214	1	2026-01-16 12:05:30.37666	candidate_status	\N	Переведен
3620	214	1	2026-01-16 12:05:30.376949	target_projects	\N	Госуслуги 2.0, Banking App, E-commerce Platform
3621	214	1	2026-01-16 12:05:30.377241	transfer_date	\N	2026-10-01
3622	214	1	2026-01-16 12:05:30.37782	recruiter	\N	Белова И.Д.
3623	214	1	2026-01-16 12:05:30.378215	hr_bp	\N	Волкова Н.В.
3624	214	1	2026-01-16 12:05:30.378534	comments	\N	Срочно нужен проект
3625	33	1	2026-01-16 12:05:30.402351	entry_date	\N	2025-03-15
3626	33	1	2026-01-16 12:05:30.40303	current_manager	\N	Петров С.М.
3627	33	1	2026-01-16 12:05:30.403605	it_block	\N	НУК
3628	33	1	2026-01-16 12:05:30.404124	ck_department	\N	ЦК Разработки
3629	33	1	2026-01-16 12:05:30.404506	placement_type	\N	любой
3630	33	1	2026-01-16 12:05:30.404841	ready_for_vacancy	\N	Да
3631	33	1	2026-01-16 12:05:30.405157	resume_link	\N	https://drive.google.com/file/90351
3632	33	1	2026-01-16 12:05:30.405556	manager_feedback	\N	Хороший специалист
3633	33	1	2026-01-16 12:05:30.405879	contacts	\N	+7 (948) 138-71-53, @попартё8, olga.lebedev17@company.ru
3634	33	1	2026-01-16 12:05:30.406182	funding_end_date	\N	2026-06-15
3635	33	1	2026-01-16 12:05:30.40648	candidate_status	\N	Увольнение по СС
3636	33	1	2026-01-16 12:05:30.406779	target_projects	\N	Infrastructure, Госуслуги 2.0, E-commerce Platform
3637	33	1	2026-01-16 12:05:30.407084	transfer_date	\N	2026-04-21
3638	33	1	2026-01-16 12:05:30.407383	recruiter	\N	Новикова Е.П.
3639	33	1	2026-01-16 12:05:30.407679	hr_bp	\N	Волкова Н.В.
3640	33	1	2026-01-16 12:05:30.407975	comments	\N	
3641	41	1	2026-01-16 12:05:30.426589	entry_date	\N	2024-11-21
3642	41	1	2026-01-16 12:05:30.427388	current_manager	\N	Михайлова О.Н.
3643	41	1	2026-01-16 12:05:30.427945	it_block	\N	Развитие
3644	41	1	2026-01-16 12:05:30.428319	ck_department	\N	ЦК Инфраструктуры
3645	41	1	2026-01-16 12:05:30.428817	placement_type	\N	аутстафф
3646	41	1	2026-01-16 12:05:30.429173	ready_for_vacancy	\N	Нет
3647	41	1	2026-01-16 12:05:30.429585	resume_link	\N	https://drive.google.com/file/15646
3648	41	1	2026-01-16 12:05:30.429908	manager_feedback	\N	
3649	41	1	2026-01-16 12:05:30.430221	contacts	\N	+7 (966) 643-93-44, @волмакс12, tatiana.petrov25@company.ru
3650	41	1	2026-01-16 12:05:30.430519	funding_end_date	\N	2026-06-01
3651	41	1	2026-01-16 12:05:30.431046	candidate_status	\N	Увольнение по СС
3652	41	1	2026-01-16 12:05:30.431517	target_projects	\N	Infrastructure, ML Pipeline, Mobile App
3653	41	1	2026-01-16 12:05:30.431977	transfer_date	\N	2026-07-05
3654	41	1	2026-01-16 12:05:30.43245	recruiter	\N	Новикова Е.П.
3655	41	1	2026-01-16 12:05:30.432919	hr_bp	\N	Волкова Н.В.
3656	41	1	2026-01-16 12:05:30.433421	comments	\N	
3657	99	1	2026-01-16 12:05:30.455027	entry_date	\N	2024-06-04
3658	99	1	2026-01-16 12:05:30.455613	current_manager	\N	Иванов А.П.
3659	99	1	2026-01-16 12:05:30.456002	it_block	\N	Диджитал
3660	99	1	2026-01-16 12:05:30.456338	ck_department	\N	ЦК Инфраструктуры
3661	99	1	2026-01-16 12:05:30.456658	placement_type	\N	перевод
3662	99	1	2026-01-16 12:05:30.456967	ready_for_vacancy	\N	Да
3663	99	1	2026-01-16 12:05:30.457301	resume_link	\N	https://drive.google.com/file/97800
3664	99	1	2026-01-16 12:05:30.457622	manager_feedback	\N	Хороший специалист
3665	99	1	2026-01-16 12:05:30.457918	contacts	\N	+7 (973) 841-54-34, @фёдсерг22, anton.nikitin83@company.ru
3666	99	1	2026-01-16 12:05:30.458214	funding_end_date	\N	2025-04-18
3667	99	1	2026-01-16 12:05:30.458506	candidate_status	\N	Свободен
3668	99	1	2026-01-16 12:05:30.458792	target_projects	\N	Data Platform, Banking App, Госуслуги 2.0
3669	99	1	2026-01-16 12:05:30.45908	transfer_date	\N	
3670	99	1	2026-01-16 12:05:30.45937	recruiter	\N	Смирнова А.А.
3671	99	1	2026-01-16 12:05:30.459658	hr_bp	\N	Волкова Н.В.
3672	99	1	2026-01-16 12:05:30.459942	comments	\N	
3673	117	1	2026-01-16 12:05:30.482476	entry_date	\N	2025-02-12
3674	117	1	2026-01-16 12:05:30.48318	current_manager	\N	Михайлова О.Н.
3675	117	1	2026-01-16 12:05:30.483996	it_block	\N	Развитие
3676	117	1	2026-01-16 12:05:30.484834	ck_department	\N	ЦК Аналитики
3677	117	1	2026-01-16 12:05:30.485535	placement_type	\N	перевод
3678	117	1	2026-01-16 12:05:30.486191	ready_for_vacancy	\N	Да
3679	117	1	2026-01-16 12:05:30.486757	resume_link	\N	https://drive.google.com/file/80565
3680	117	1	2026-01-16 12:05:30.487296	manager_feedback	\N	Хороший специалист
3681	117	1	2026-01-16 12:05:30.488012	contacts	\N	+7 (957) 145-92-47, @алемиха74, ekaterina.alexeev101@company.ru
3682	117	1	2026-01-16 12:05:30.488497	funding_end_date	\N	2026-11-28
3683	117	1	2026-01-16 12:05:30.488969	candidate_status	\N	В работе
3684	117	1	2026-01-16 12:05:30.489627	target_projects	\N	Госуслуги 2.0, Mobile App, Data Platform
3685	117	1	2026-01-16 12:05:30.490113	transfer_date	\N	
3686	117	1	2026-01-16 12:05:30.49057	recruiter	\N	Новикова Е.П.
3687	117	1	2026-01-16 12:05:30.491026	hr_bp	\N	Волкова Н.В.
3688	117	1	2026-01-16 12:05:30.491485	comments	\N	
3689	135	1	2026-01-16 12:05:30.511303	entry_date	\N	2024-10-27
3690	135	1	2026-01-16 12:05:30.512037	current_manager	\N	Козлов Д.В.
3691	135	1	2026-01-16 12:05:30.512836	it_block	\N	Развитие
3692	135	1	2026-01-16 12:05:30.513506	ck_department	\N	ЦК Аналитики
3693	135	1	2026-01-16 12:05:30.514011	placement_type	\N	перевод
3694	135	1	2026-01-16 12:05:30.514551	ready_for_vacancy	\N	Да
3695	135	1	2026-01-16 12:05:30.515029	resume_link	\N	https://drive.google.com/file/98697
3696	135	1	2026-01-16 12:05:30.515519	manager_feedback	\N	
3697	135	1	2026-01-16 12:05:30.51598	contacts	\N	+7 (958) 214-92-39, @иваалек99, yaroslav.petrov119@company.ru
3698	135	1	2026-01-16 12:05:30.516447	funding_end_date	\N	2025-02-07
3699	135	1	2026-01-16 12:05:30.516909	candidate_status	\N	Увольнение по СС
3700	135	1	2026-01-16 12:05:30.51733	target_projects	\N	E-commerce Platform, Mobile App
3701	135	1	2026-01-16 12:05:30.517903	transfer_date	\N	2025-06-16
3702	135	1	2026-01-16 12:05:30.518668	recruiter	\N	Смирнова А.А.
3703	135	1	2026-01-16 12:05:30.519607	hr_bp	\N	Волкова Н.В.
3704	135	1	2026-01-16 12:05:30.52015	comments	\N	Срочно нужен проект
3705	143	1	2026-01-16 12:05:30.540927	entry_date	\N	2024-06-25
3706	143	1	2026-01-16 12:05:30.541479	current_manager	\N	Михайлова О.Н.
3707	143	1	2026-01-16 12:05:30.541854	it_block	\N	НУК
3708	143	1	2026-01-16 12:05:30.542177	ck_department	\N	ЦК Разработки
3709	143	1	2026-01-16 12:05:30.542476	placement_type	\N	аутстафф
3710	143	1	2026-01-16 12:05:30.542772	ready_for_vacancy	\N	Да
3711	143	1	2026-01-16 12:05:30.543069	resume_link	\N	https://drive.google.com/file/91743
3712	143	1	2026-01-16 12:05:30.543358	manager_feedback	\N	Нужно развитие
3713	143	1	2026-01-16 12:05:30.543644	contacts	\N	+7 (934) 877-84-68, @новрома30, evgeny.nikolaev127@company.ru
3714	143	1	2026-01-16 12:05:30.543931	funding_end_date	\N	2025-03-27
3715	143	1	2026-01-16 12:05:30.544215	candidate_status	\N	Забронирован
3716	143	1	2026-01-16 12:05:30.544503	target_projects	\N	Banking App, Data Platform
3717	143	1	2026-01-16 12:05:30.54479	transfer_date	\N	
3718	143	1	2026-01-16 12:05:30.545074	recruiter	\N	Белова И.Д.
3719	143	1	2026-01-16 12:05:30.545379	hr_bp	\N	Лебедева Т.М.
3720	143	1	2026-01-16 12:05:30.545693	comments	\N	Срочно нужен проект
3721	149	1	2026-01-16 12:05:30.567838	entry_date	\N	2024-09-18
3722	149	1	2026-01-16 12:05:30.568934	current_manager	\N	Иванов А.П.
3723	149	1	2026-01-16 12:05:30.569683	it_block	\N	Развитие
3724	149	1	2026-01-16 12:05:30.570385	ck_department	\N	Департамент данных
3725	149	1	2026-01-16 12:05:30.57094	placement_type	\N	любой
3726	149	1	2026-01-16 12:05:30.571545	ready_for_vacancy	\N	Нет
3727	149	1	2026-01-16 12:05:30.57199	resume_link	\N	https://drive.google.com/file/59261
3728	149	1	2026-01-16 12:05:30.572317	manager_feedback	\N	Нужно развитие
3729	149	1	2026-01-16 12:05:30.572626	contacts	\N	+7 (905) 405-50-44, @семкири84, olga.sergeev133@company.ru
3730	149	1	2026-01-16 12:05:30.572929	funding_end_date	\N	2026-05-31
3731	149	1	2026-01-16 12:05:30.573266	candidate_status	\N	Забронирован
3732	149	1	2026-01-16 12:05:30.573765	target_projects	\N	Data Platform, ML Pipeline
3733	149	1	2026-01-16 12:05:30.574086	transfer_date	\N	
3734	149	1	2026-01-16 12:05:30.574389	recruiter	\N	Смирнова А.А.
3735	149	1	2026-01-16 12:05:30.574697	hr_bp	\N	Волкова Н.В.
3736	149	1	2026-01-16 12:05:30.574995	comments	\N	
3737	160	1	2026-01-16 12:05:30.593479	entry_date	\N	2024-01-31
3738	160	1	2026-01-16 12:05:30.594089	current_manager	\N	Сидорова Е.К.
3739	160	1	2026-01-16 12:05:30.594563	it_block	\N	Развитие
3740	160	1	2026-01-16 12:05:30.594906	ck_department	\N	ЦК Аналитики
3741	160	1	2026-01-16 12:05:30.595231	placement_type	\N	перевод
3742	160	1	2026-01-16 12:05:30.595537	ready_for_vacancy	\N	Нет
3743	160	1	2026-01-16 12:05:30.595844	resume_link	\N	https://drive.google.com/file/39815
3744	160	1	2026-01-16 12:05:30.596148	manager_feedback	\N	Отличные результаты
3745	160	1	2026-01-16 12:05:30.596455	contacts	\N	+7 (947) 613-43-46, @морники46, nikolay.borisov144@company.ru
3746	160	1	2026-01-16 12:05:30.597015	funding_end_date	\N	2026-03-21
3747	160	1	2026-01-16 12:05:30.59735	candidate_status	\N	В работе
3748	160	1	2026-01-16 12:05:30.597676	target_projects	\N	E-commerce Platform, DevOps Platform, Data Platform
3749	160	1	2026-01-16 12:05:30.598058	transfer_date	\N	
3750	160	1	2026-01-16 12:05:30.598451	recruiter	\N	Белова И.Д.
3751	160	1	2026-01-16 12:05:30.598757	hr_bp	\N	Лебедева Т.М.
3752	160	1	2026-01-16 12:05:30.59905	comments	\N	
3753	163	1	2026-01-16 12:05:30.623139	entry_date	\N	2024-03-15
3754	163	1	2026-01-16 12:05:30.624056	current_manager	\N	Михайлова О.Н.
3755	163	1	2026-01-16 12:05:30.624746	it_block	\N	B2O
3756	163	1	2026-01-16 12:05:30.625296	ck_department	\N	ЦК Разработки
3757	163	1	2026-01-16 12:05:30.625708	placement_type	\N	аутстафф
3758	163	1	2026-01-16 12:05:30.626029	ready_for_vacancy	\N	Нет
3759	163	1	2026-01-16 12:05:30.626507	resume_link	\N	https://drive.google.com/file/21850
3760	163	1	2026-01-16 12:05:30.626904	manager_feedback	\N	Рекомендую
3761	163	1	2026-01-16 12:05:30.627292	contacts	\N	+7 (997) 221-58-80, @лебдмит26, svetlana.korolev147@company.ru
3762	163	1	2026-01-16 12:05:30.627963	funding_end_date	\N	2025-04-11
3763	163	1	2026-01-16 12:05:30.628677	candidate_status	\N	В работе
3764	163	1	2026-01-16 12:05:30.629301	target_projects	\N	Banking App, ML Pipeline, Infrastructure
3765	163	1	2026-01-16 12:05:30.629979	transfer_date	\N	
3766	163	1	2026-01-16 12:05:30.630654	recruiter	\N	Смирнова А.А.
3767	163	1	2026-01-16 12:05:30.631493	hr_bp	\N	Лебедева Т.М.
3768	163	1	2026-01-16 12:05:30.632193	comments	\N	
3769	167	1	2026-01-16 12:05:30.656351	entry_date	\N	2025-05-30
3770	167	1	2026-01-16 12:05:30.657064	current_manager	\N	Михайлова О.Н.
3771	167	1	2026-01-16 12:05:30.657789	it_block	\N	Эксплуатация
3772	167	1	2026-01-16 12:05:30.658252	ck_department	\N	ЦК Разработки
3773	167	1	2026-01-16 12:05:30.659051	placement_type	\N	аутстафф
3774	167	1	2026-01-16 12:05:30.659997	ready_for_vacancy	\N	Да
3775	167	1	2026-01-16 12:05:30.660738	resume_link	\N	https://drive.google.com/file/90860
3776	167	1	2026-01-16 12:05:30.66144	manager_feedback	\N	Хороший специалист
3777	167	1	2026-01-16 12:05:30.662236	contacts	\N	+7 (970) 280-97-18, @куздени18, matvey.kuznetsov151@company.ru
3778	167	1	2026-01-16 12:05:30.662882	funding_end_date	\N	2025-11-28
3779	167	1	2026-01-16 12:05:30.663505	candidate_status	\N	Свободен
3780	167	1	2026-01-16 12:05:30.664622	target_projects	\N	ML Pipeline, DevOps Platform
3781	167	1	2026-01-16 12:05:30.665706	transfer_date	\N	
3782	167	1	2026-01-16 12:05:30.666496	recruiter	\N	Орлов М.С.
3783	167	1	2026-01-16 12:05:30.667288	hr_bp	\N	Лебедева Т.М.
3784	167	1	2026-01-16 12:05:30.66789	comments	\N	
3785	168	1	2026-01-16 12:05:30.694368	entry_date	\N	2024-06-06
3786	168	1	2026-01-16 12:05:30.695007	current_manager	\N	Сидорова Е.К.
3787	168	1	2026-01-16 12:05:30.695664	it_block	\N	НУК
3788	168	1	2026-01-16 12:05:30.696651	ck_department	\N	Департамент цифровых продуктов
3789	168	1	2026-01-16 12:05:30.697467	placement_type	\N	любой
3790	168	1	2026-01-16 12:05:30.698012	ready_for_vacancy	\N	Нет
3791	168	1	2026-01-16 12:05:30.698399	resume_link	\N	https://drive.google.com/file/11010
3792	168	1	2026-01-16 12:05:30.698727	manager_feedback	\N	
3793	168	1	2026-01-16 12:05:30.699032	contacts	\N	+7 (980) 539-92-50, @попартё32, artem.kuznetsov152@company.ru
3794	168	1	2026-01-16 12:05:30.699333	funding_end_date	\N	2025-01-19
3795	168	1	2026-01-16 12:05:30.699649	candidate_status	\N	В работе
3796	168	1	2026-01-16 12:05:30.699956	target_projects	\N	DevOps Platform, Data Platform, Mobile App
3797	168	1	2026-01-16 12:05:30.700262	transfer_date	\N	
3798	168	1	2026-01-16 12:05:30.700563	recruiter	\N	Новикова Е.П.
3799	168	1	2026-01-16 12:05:30.700934	hr_bp	\N	Волкова Н.В.
3800	168	1	2026-01-16 12:05:30.701602	comments	\N	Срочно нужен проект
3801	177	1	2026-01-16 12:05:30.730506	entry_date	\N	2024-11-20
3802	177	1	2026-01-16 12:05:30.732004	current_manager	\N	Петров С.М.
3803	177	1	2026-01-16 12:05:30.733177	it_block	\N	Прочее
3804	177	1	2026-01-16 12:05:30.733918	ck_department	\N	ЦК Аналитики
3805	177	1	2026-01-16 12:05:30.735386	placement_type	\N	любой
3806	177	1	2026-01-16 12:05:30.736067	ready_for_vacancy	\N	Да
3807	177	1	2026-01-16 12:05:30.7367	resume_link	\N	https://drive.google.com/file/23094
3808	177	1	2026-01-16 12:05:30.737388	manager_feedback	\N	
3809	177	1	2026-01-16 12:05:30.738232	contacts	\N	+7 (911) 956-39-17, @алемиха33, ekaterina.novikov161@company.ru
3810	177	1	2026-01-16 12:05:30.738727	funding_end_date	\N	2025-07-03
3811	177	1	2026-01-16 12:05:30.739197	candidate_status	\N	Переведен
3812	177	1	2026-01-16 12:05:30.739652	target_projects	\N	Infrastructure, DevOps Platform, Data Platform
3813	177	1	2026-01-16 12:05:30.740009	transfer_date	\N	2025-04-11
3814	177	1	2026-01-16 12:05:30.740313	recruiter	\N	Белова И.Д.
3815	177	1	2026-01-16 12:05:30.740605	hr_bp	\N	Морозов К.А.
3816	177	1	2026-01-16 12:05:30.740891	comments	\N	
3817	188	1	2026-01-16 12:05:30.772728	entry_date	\N	2024-04-24
3818	188	1	2026-01-16 12:05:30.773742	current_manager	\N	Козлов Д.В.
3819	188	1	2026-01-16 12:05:30.774584	it_block	\N	Эксплуатация
3820	188	1	2026-01-16 12:05:30.775073	ck_department	\N	ЦК Аналитики
3821	188	1	2026-01-16 12:05:30.775421	placement_type	\N	любой
3822	188	1	2026-01-16 12:05:30.775738	ready_for_vacancy	\N	Нет
3823	188	1	2026-01-16 12:05:30.776049	resume_link	\N	https://drive.google.com/file/80308
3824	188	1	2026-01-16 12:05:30.776346	manager_feedback	\N	Рекомендую
3825	188	1	2026-01-16 12:05:30.77664	contacts	\N	+7 (904) 359-60-29, @новрома40, sergey.novikov172@company.ru
3826	188	1	2026-01-16 12:05:30.776934	funding_end_date	\N	2026-09-14
3827	188	1	2026-01-16 12:05:30.777445	candidate_status	\N	Свободен
3828	188	1	2026-01-16 12:05:30.778584	target_projects	\N	Mobile App, ML Pipeline, Infrastructure
3829	188	1	2026-01-16 12:05:30.779155	transfer_date	\N	
3830	188	1	2026-01-16 12:05:30.779589	recruiter	\N	Новикова Е.П.
3831	188	1	2026-01-16 12:05:30.782064	hr_bp	\N	Волкова Н.В.
3832	188	1	2026-01-16 12:05:30.782683	comments	\N	Ожидает оффер
3833	206	1	2026-01-16 12:05:30.811143	entry_date	\N	2025-04-25
3834	206	1	2026-01-16 12:05:30.811743	current_manager	\N	Михайлова О.Н.
3835	206	1	2026-01-16 12:05:30.812136	it_block	\N	Диджитал
3836	206	1	2026-01-16 12:05:30.81247	ck_department	\N	ЦК Инфраструктуры
3837	206	1	2026-01-16 12:05:30.812796	placement_type	\N	перевод
3838	206	1	2026-01-16 12:05:30.813105	ready_for_vacancy	\N	Да
3839	206	1	2026-01-16 12:05:30.813651	resume_link	\N	https://drive.google.com/file/80303
3840	206	1	2026-01-16 12:05:30.814045	manager_feedback	\N	Рекомендую
3841	206	1	2026-01-16 12:05:30.814546	contacts	\N	+7 (994) 968-86-12, @волмакс78, maxim.popov190@company.ru
3842	206	1	2026-01-16 12:05:30.814957	funding_end_date	\N	2025-01-17
3843	206	1	2026-01-16 12:05:30.815384	candidate_status	\N	В работе
3844	206	1	2026-01-16 12:05:30.815717	target_projects	\N	Banking App, Infrastructure
3845	206	1	2026-01-16 12:05:30.816028	transfer_date	\N	
3846	206	1	2026-01-16 12:05:30.816333	recruiter	\N	Орлов М.С.
3847	206	1	2026-01-16 12:05:30.816636	hr_bp	\N	Лебедева Т.М.
3848	206	1	2026-01-16 12:05:30.816943	comments	\N	
3849	60	1	2026-01-16 12:05:30.857045	entry_date	\N	2024-03-31
3850	60	1	2026-01-16 12:05:30.857786	current_manager	\N	Иванов А.П.
3851	60	1	2026-01-16 12:05:30.85818	it_block	\N	B2O
3852	60	1	2026-01-16 12:05:30.858519	ck_department	\N	Департамент данных
3853	60	1	2026-01-16 12:05:30.858848	placement_type	\N	аутстафф
3854	60	1	2026-01-16 12:05:30.859302	ready_for_vacancy	\N	Нет
3855	60	1	2026-01-16 12:05:30.859879	resume_link	\N	https://drive.google.com/file/52142
3856	60	1	2026-01-16 12:05:30.860438	manager_feedback	\N	Нужно развитие
3857	60	1	2026-01-16 12:05:30.860991	contacts	\N	+7 (949) 337-33-45, @иваалек95, anton.sergeev44@company.ru
3858	60	1	2026-01-16 12:05:30.861941	funding_end_date	\N	2026-08-22
3859	60	1	2026-01-16 12:05:30.863115	candidate_status	\N	Переведен
3860	60	1	2026-01-16 12:05:30.864123	target_projects	\N	Госуслуги 2.0, E-commerce Platform
3861	60	1	2026-01-16 12:05:30.865052	transfer_date	\N	2025-07-29
3862	60	1	2026-01-16 12:05:30.866226	recruiter	\N	Смирнова А.А.
3863	60	1	2026-01-16 12:05:30.867146	hr_bp	\N	Лебедева Т.М.
3864	60	1	2026-01-16 12:05:30.868035	comments	\N	
3865	66	1	2026-01-16 12:05:30.907847	entry_date	\N	2024-03-11
3866	66	1	2026-01-16 12:05:30.908911	current_manager	\N	Петров С.М.
3867	66	1	2026-01-16 12:05:30.91003	it_block	\N	Прочее
3868	66	1	2026-01-16 12:05:30.911037	ck_department	\N	Департамент данных
3869	66	1	2026-01-16 12:05:30.912134	placement_type	\N	перевод
3870	66	1	2026-01-16 12:05:30.913093	ready_for_vacancy	\N	Да
3871	66	1	2026-01-16 12:05:30.913788	resume_link	\N	https://drive.google.com/file/80169
3872	66	1	2026-01-16 12:05:30.91429	manager_feedback	\N	Нужно развитие
3873	66	1	2026-01-16 12:05:30.914777	contacts	\N	+7 (903) 605-64-61, @сокегор46, natalia.orlov50@company.ru
3874	66	1	2026-01-16 12:05:30.915274	funding_end_date	\N	2026-05-08
3875	66	1	2026-01-16 12:05:30.91576	candidate_status	\N	Свободен
3876	66	1	2026-01-16 12:05:30.916238	target_projects	\N	Data Platform, Госуслуги 2.0
3877	66	1	2026-01-16 12:05:30.916867	transfer_date	\N	
3878	66	1	2026-01-16 12:05:30.917777	recruiter	\N	Новикова Е.П.
3879	66	1	2026-01-16 12:05:30.918192	hr_bp	\N	Морозов К.А.
3880	66	1	2026-01-16 12:05:30.918745	comments	\N	
3881	181	1	2026-01-16 12:05:30.94826	entry_date	\N	2024-05-27
3882	181	1	2026-01-16 12:05:30.948868	current_manager	\N	Иванов А.П.
3883	181	1	2026-01-16 12:05:30.949501	it_block	\N	Диджитал
3884	181	1	2026-01-16 12:05:30.950296	ck_department	\N	ЦК Разработки
3885	181	1	2026-01-16 12:05:30.951025	placement_type	\N	перевод
3886	181	1	2026-01-16 12:05:30.951688	ready_for_vacancy	\N	Да
3887	181	1	2026-01-16 12:05:30.952564	resume_link	\N	https://drive.google.com/file/69092
3888	181	1	2026-01-16 12:05:30.953326	manager_feedback	\N	Отличные результаты
3889	181	1	2026-01-16 12:05:30.953849	contacts	\N	+7 (927) 174-20-97, @смиилья76, mark.novikov165@company.ru
3890	181	1	2026-01-16 12:05:30.954595	funding_end_date	\N	2025-10-20
3891	181	1	2026-01-16 12:05:30.955123	candidate_status	\N	Увольнение по СС
3892	181	1	2026-01-16 12:05:30.955631	target_projects	\N	Госуслуги 2.0, Infrastructure, Data Platform
3893	181	1	2026-01-16 12:05:30.956097	transfer_date	\N	2026-11-24
3894	181	1	2026-01-16 12:05:30.956547	recruiter	\N	Орлов М.С.
3895	181	1	2026-01-16 12:05:30.956884	hr_bp	\N	Волкова Н.В.
3896	181	1	2026-01-16 12:05:30.957428	comments	\N	
3897	64	1	2026-01-16 12:05:30.983914	entry_date	\N	2024-05-04
3898	64	1	2026-01-16 12:05:30.984537	current_manager	\N	Петров С.М.
3899	64	1	2026-01-16 12:05:30.985325	it_block	\N	Диджитал
3900	64	1	2026-01-16 12:05:30.985995	ck_department	\N	ЦК Аналитики
3901	64	1	2026-01-16 12:05:30.986547	placement_type	\N	аутстафф
3902	64	1	2026-01-16 12:05:30.987051	ready_for_vacancy	\N	Нет
3903	64	1	2026-01-16 12:05:30.987541	resume_link	\N	https://drive.google.com/file/73361
3904	64	1	2026-01-16 12:05:30.988023	manager_feedback	\N	
3905	64	1	2026-01-16 12:05:30.988498	contacts	\N	+7 (995) 821-81-72, @васиван49, yuri.romanov48@company.ru
3906	64	1	2026-01-16 12:05:30.988963	funding_end_date	\N	2026-01-10
3907	64	1	2026-01-16 12:05:30.989514	candidate_status	\N	Свободен
3908	64	1	2026-01-16 12:05:30.990062	target_projects	\N	E-commerce Platform
3909	64	1	2026-01-16 12:05:30.990457	transfer_date	\N	
3910	64	1	2026-01-16 12:05:30.9908	recruiter	\N	Белова И.Д.
3911	64	1	2026-01-16 12:05:30.991114	hr_bp	\N	Волкова Н.В.
3912	64	1	2026-01-16 12:05:30.991417	comments	\N	Ожидает оффер
3913	68	1	2026-01-16 12:05:31.01009	entry_date	\N	2025-02-24
3914	68	1	2026-01-16 12:05:31.010679	current_manager	\N	Сидорова Е.К.
3915	68	1	2026-01-16 12:05:31.011081	it_block	\N	НУК
3916	68	1	2026-01-16 12:05:31.011431	ck_department	\N	ЦК Инфраструктуры
3917	68	1	2026-01-16 12:05:31.011803	placement_type	\N	перевод
3918	68	1	2026-01-16 12:05:31.012458	ready_for_vacancy	\N	Да
3919	68	1	2026-01-16 12:05:31.012966	resume_link	\N	https://drive.google.com/file/46937
3920	68	1	2026-01-16 12:05:31.013368	manager_feedback	\N	Нужно развитие
3921	68	1	2026-01-16 12:05:31.013753	contacts	\N	+7 (951) 545-57-85, @новрома21, mark.novikov52@company.ru
3922	68	1	2026-01-16 12:05:31.014178	funding_end_date	\N	2025-02-05
3923	68	1	2026-01-16 12:05:31.014608	candidate_status	\N	Увольнение по СС
3924	68	1	2026-01-16 12:05:31.014933	target_projects	\N	Infrastructure, E-commerce Platform
3925	68	1	2026-01-16 12:05:31.015241	transfer_date	\N	2026-07-12
3926	68	1	2026-01-16 12:05:31.015541	recruiter	\N	Смирнова А.А.
3927	68	1	2026-01-16 12:05:31.015837	hr_bp	\N	Волкова Н.В.
3928	68	1	2026-01-16 12:05:31.016132	comments	\N	
3929	56	1	2026-01-16 12:05:31.034211	entry_date	\N	2025-11-14
3930	56	1	2026-01-16 12:05:31.034926	current_manager	\N	Иванов А.П.
3931	56	1	2026-01-16 12:05:31.035624	it_block	\N	НУК
3932	56	1	2026-01-16 12:05:31.036093	ck_department	\N	ЦК Инфраструктуры
3933	56	1	2026-01-16 12:05:31.03661	placement_type	\N	любой
3934	56	1	2026-01-16 12:05:31.037021	ready_for_vacancy	\N	Да
3935	56	1	2026-01-16 12:05:31.03746	resume_link	\N	https://drive.google.com/file/30291
3936	56	1	2026-01-16 12:05:31.038015	manager_feedback	\N	Хороший специалист
3937	56	1	2026-01-16 12:05:31.038577	contacts	\N	+7 (971) 424-74-90, @волмакс39, gleb.ivanov40@company.ru
3938	56	1	2026-01-16 12:05:31.039038	funding_end_date	\N	2025-01-31
3939	56	1	2026-01-16 12:05:31.039397	candidate_status	\N	В работе
3940	56	1	2026-01-16 12:05:31.039794	target_projects	\N	DevOps Platform, Banking App
3941	56	1	2026-01-16 12:05:31.040112	transfer_date	\N	
3942	56	1	2026-01-16 12:05:31.040417	recruiter	\N	Новикова Е.П.
3943	56	1	2026-01-16 12:05:31.040714	hr_bp	\N	Волкова Н.В.
3944	56	1	2026-01-16 12:05:31.041013	comments	\N	
3945	80	1	2026-01-16 12:05:31.061373	entry_date	\N	2024-06-28
3946	80	1	2026-01-16 12:05:31.062321	current_manager	\N	Михайлова О.Н.
3947	80	1	2026-01-16 12:05:31.062827	it_block	\N	Диджитал
3948	80	1	2026-01-16 12:05:31.063432	ck_department	\N	ЦК Разработки
3949	80	1	2026-01-16 12:05:31.063961	placement_type	\N	аутстафф
3950	80	1	2026-01-16 12:05:31.064444	ready_for_vacancy	\N	Да
3951	80	1	2026-01-16 12:05:31.065102	resume_link	\N	https://drive.google.com/file/42311
3952	80	1	2026-01-16 12:05:31.065731	manager_feedback	\N	Отличные результаты
3953	80	1	2026-01-16 12:05:31.066345	contacts	\N	+7 (920) 391-65-40, @петалек18, mikhail.sokolov64@company.ru
3954	80	1	2026-01-16 12:05:31.066867	funding_end_date	\N	2026-11-19
3955	80	1	2026-01-16 12:05:31.067502	candidate_status	\N	Увольнение по СС
3956	80	1	2026-01-16 12:05:31.068067	target_projects	\N	Infrastructure, Data Platform, Banking App
3957	80	1	2026-01-16 12:05:31.068498	transfer_date	\N	2026-11-03
3958	80	1	2026-01-16 12:05:31.068904	recruiter	\N	Белова И.Д.
3959	80	1	2026-01-16 12:05:31.06945	hr_bp	\N	Лебедева Т.М.
3960	80	1	2026-01-16 12:05:31.069973	comments	\N	В процессе согласования
3961	86	1	2026-01-16 12:05:31.095844	entry_date	\N	2024-09-27
3962	86	1	2026-01-16 12:05:31.096556	current_manager	\N	Козлов Д.В.
3963	86	1	2026-01-16 12:05:31.09718	it_block	\N	B2O
3964	86	1	2026-01-16 12:05:31.097979	ck_department	\N	ЦК Аналитики
3965	86	1	2026-01-16 12:05:31.098519	placement_type	\N	перевод
3966	86	1	2026-01-16 12:05:31.099004	ready_for_vacancy	\N	Нет
3967	86	1	2026-01-16 12:05:31.100193	resume_link	\N	https://drive.google.com/file/32152
3968	86	1	2026-01-16 12:05:31.100829	manager_feedback	\N	
3969	86	1	2026-01-16 12:05:31.101733	contacts	\N	+7 (909) 364-41-85, @волмакс53, tatiana.nikolaev70@company.ru
3970	86	1	2026-01-16 12:05:31.102507	funding_end_date	\N	2026-09-18
3971	86	1	2026-01-16 12:05:31.103233	candidate_status	\N	Забронирован
3972	86	1	2026-01-16 12:05:31.103832	target_projects	\N	Banking App
3973	86	1	2026-01-16 12:05:31.104375	transfer_date	\N	
3974	86	1	2026-01-16 12:05:31.104861	recruiter	\N	Орлов М.С.
3975	86	1	2026-01-16 12:05:31.105383	hr_bp	\N	Лебедева Т.М.
3976	86	1	2026-01-16 12:05:31.105914	comments	\N	
3977	98	1	2026-01-16 12:05:31.140604	entry_date	\N	2025-11-15
3978	98	1	2026-01-16 12:05:31.141088	current_manager	\N	Петров С.М.
3979	98	1	2026-01-16 12:05:31.141523	it_block	\N	Эксплуатация
3980	98	1	2026-01-16 12:05:31.142061	ck_department	\N	ЦК Инфраструктуры
3981	98	1	2026-01-16 12:05:31.142687	placement_type	\N	аутстафф
3982	98	1	2026-01-16 12:05:31.143156	ready_for_vacancy	\N	Да
3983	98	1	2026-01-16 12:05:31.143509	resume_link	\N	https://drive.google.com/file/35446
3984	98	1	2026-01-16 12:05:31.143821	manager_feedback	\N	Хороший специалист
3985	98	1	2026-01-16 12:05:31.144121	contacts	\N	+7 (931) 736-77-35, @новрома13, grigory.andreev82@company.ru
3986	98	1	2026-01-16 12:05:31.144418	funding_end_date	\N	2025-08-03
3987	98	1	2026-01-16 12:05:31.14472	candidate_status	\N	Свободен
3988	98	1	2026-01-16 12:05:31.145023	target_projects	\N	ML Pipeline, E-commerce Platform
3989	98	1	2026-01-16 12:05:31.145386	transfer_date	\N	
3990	98	1	2026-01-16 12:05:31.145713	recruiter	\N	Новикова Е.П.
3991	98	1	2026-01-16 12:05:31.146016	hr_bp	\N	Морозов К.А.
3992	98	1	2026-01-16 12:05:31.14631	comments	\N	
3993	109	1	2026-01-16 12:05:31.174094	entry_date	\N	2025-05-20
3994	109	1	2026-01-16 12:05:31.175034	current_manager	\N	Иванов А.П.
3995	109	1	2026-01-16 12:05:31.175653	it_block	\N	Прочее
3996	109	1	2026-01-16 12:05:31.176168	ck_department	\N	ЦК Аналитики
3997	109	1	2026-01-16 12:05:31.176657	placement_type	\N	любой
3998	109	1	2026-01-16 12:05:31.177135	ready_for_vacancy	\N	Нет
3999	109	1	2026-01-16 12:05:31.178018	resume_link	\N	https://drive.google.com/file/29748
4000	109	1	2026-01-16 12:05:31.178868	manager_feedback	\N	
4001	109	1	2026-01-16 12:05:31.179477	contacts	\N	+7 (950) 338-48-24, @васиван79, anton.kiselev93@company.ru
4002	109	1	2026-01-16 12:05:31.179982	funding_end_date	\N	2026-07-02
4003	109	1	2026-01-16 12:05:31.180465	candidate_status	\N	Переведен
4004	109	1	2026-01-16 12:05:31.180932	target_projects	\N	E-commerce Platform
4005	109	1	2026-01-16 12:05:31.181436	transfer_date	\N	2026-06-21
4006	109	1	2026-01-16 12:05:31.181914	recruiter	\N	Новикова Е.П.
4007	109	1	2026-01-16 12:05:31.182359	hr_bp	\N	Волкова Н.В.
4008	109	1	2026-01-16 12:05:31.182796	comments	\N	Срочно нужен проект
4009	422	1	2026-01-16 12:05:31.234306	entry_date	\N	2025-03-15
4010	422	1	2026-01-16 12:05:31.235171	current_manager	\N	Иванов А.П.
4011	422	1	2026-01-16 12:05:31.235769	it_block	\N	Диджитал
4012	422	1	2026-01-16 12:05:31.236303	ck_department	\N	Департамент цифровых продуктов
4013	422	1	2026-01-16 12:05:31.237212	placement_type	\N	любой
4014	422	1	2026-01-16 12:05:31.238047	ready_for_vacancy	\N	Да
4015	422	1	2026-01-16 12:05:31.238553	resume_link	\N	https://drive.google.com/file/20096
4016	422	1	2026-01-16 12:05:31.238923	manager_feedback	\N	Рекомендую
4017	422	1	2026-01-16 12:05:31.239387	contacts	\N	+7 (958) 667-10-99, @захдиан3, d.zakharova@rt.ru
4018	422	1	2026-01-16 12:05:31.239741	funding_end_date	\N	2025-08-21
4019	422	1	2026-01-16 12:05:31.240094	candidate_status	\N	Увольнение по СЖ
4020	422	1	2026-01-16 12:05:31.240412	target_projects	\N	E-commerce Platform, Mobile App, Госуслуги 2.0
4021	422	1	2026-01-16 12:05:31.240733	transfer_date	\N	2025-01-14
4022	422	1	2026-01-16 12:05:31.241222	recruiter	\N	Смирнова А.А.
4023	422	1	2026-01-16 12:05:31.241858	hr_bp	\N	Лебедева Т.М.
4024	422	1	2026-01-16 12:05:31.242278	comments	\N	
4025	423	1	2026-01-16 12:05:31.267258	entry_date	\N	2024-11-24
4026	423	1	2026-01-16 12:05:31.268263	current_manager	\N	Михайлова О.Н.
4027	423	1	2026-01-16 12:05:31.268832	it_block	\N	Развитие
4028	423	1	2026-01-16 12:05:31.269471	ck_department	\N	ЦК Инфраструктуры
4029	423	1	2026-01-16 12:05:31.27011	placement_type	\N	перевод
4030	423	1	2026-01-16 12:05:31.270496	ready_for_vacancy	\N	Нет
4031	423	1	2026-01-16 12:05:31.270834	resume_link	\N	https://drive.google.com/file/82607
4032	423	1	2026-01-16 12:05:31.271152	manager_feedback	\N	Нужно развитие
4033	423	1	2026-01-16 12:05:31.271733	contacts	\N	+7 (958) 189-51-40, @андолег94, o.andreev@rt.ru
4034	423	1	2026-01-16 12:05:31.272086	funding_end_date	\N	2026-07-15
4035	423	1	2026-01-16 12:05:31.272393	candidate_status	\N	Забронирован
4036	423	1	2026-01-16 12:05:31.272692	target_projects	\N	ML Pipeline
4037	423	1	2026-01-16 12:05:31.272993	transfer_date	\N	
4038	423	1	2026-01-16 12:05:31.273342	recruiter	\N	Новикова Е.П.
4039	423	1	2026-01-16 12:05:31.273739	hr_bp	\N	Лебедева Т.М.
4040	423	1	2026-01-16 12:05:31.274042	comments	\N	
4041	424	1	2026-01-16 12:05:31.293584	entry_date	\N	2024-09-28
4042	424	1	2026-01-16 12:05:31.294332	current_manager	\N	Иванов А.П.
4043	424	1	2026-01-16 12:05:31.294829	it_block	\N	Развитие
4044	424	1	2026-01-16 12:05:31.295189	ck_department	\N	ЦК Аналитики
4045	424	1	2026-01-16 12:05:31.295506	placement_type	\N	перевод
4046	424	1	2026-01-16 12:05:31.295806	ready_for_vacancy	\N	Нет
4047	424	1	2026-01-16 12:05:31.296279	resume_link	\N	https://drive.google.com/file/11282
4048	424	1	2026-01-16 12:05:31.296879	manager_feedback	\N	Хороший специалист
4049	424	1	2026-01-16 12:05:31.29739	contacts	\N	+7 (909) 520-35-84, @фроегор78, e.frolov@rt.ru
4050	424	1	2026-01-16 12:05:31.297804	funding_end_date	\N	2025-07-02
4051	424	1	2026-01-16 12:05:31.298231	candidate_status	\N	Свободен
4052	424	1	2026-01-16 12:05:31.298881	target_projects	\N	DevOps Platform, Mobile App
4053	424	1	2026-01-16 12:05:31.299283	transfer_date	\N	
4054	424	1	2026-01-16 12:05:31.29961	recruiter	\N	Белова И.Д.
4055	424	1	2026-01-16 12:05:31.299925	hr_bp	\N	Морозов К.А.
4056	424	1	2026-01-16 12:05:31.300222	comments	\N	
4057	425	1	2026-01-16 12:05:31.329634	entry_date	\N	2025-11-09
4058	425	1	2026-01-16 12:05:31.330747	current_manager	\N	Петров С.М.
4059	425	1	2026-01-16 12:05:31.331322	it_block	\N	НУК
4060	425	1	2026-01-16 12:05:31.331816	ck_department	\N	Департамент данных
4061	425	1	2026-01-16 12:05:31.332291	placement_type	\N	перевод
4062	425	1	2026-01-16 12:05:31.332755	ready_for_vacancy	\N	Да
4063	425	1	2026-01-16 12:05:31.333212	resume_link	\N	https://drive.google.com/file/31471
4064	425	1	2026-01-16 12:05:31.333971	manager_feedback	\N	Хороший специалист
4065	425	1	2026-01-16 12:05:31.334541	contacts	\N	+7 (961) 895-49-72, @белевге7, e.belova@rt.ru
4066	425	1	2026-01-16 12:05:31.335487	funding_end_date	\N	2026-07-27
4067	425	1	2026-01-16 12:05:31.336118	candidate_status	\N	Увольнение по СЖ
4068	425	1	2026-01-16 12:05:31.336648	target_projects	\N	ML Pipeline, DevOps Platform
4069	425	1	2026-01-16 12:05:31.33765	transfer_date	\N	2025-07-19
4070	425	1	2026-01-16 12:05:31.338549	recruiter	\N	Смирнова А.А.
4071	425	1	2026-01-16 12:05:31.339133	hr_bp	\N	Морозов К.А.
4072	425	1	2026-01-16 12:05:31.339647	comments	\N	
4073	426	1	2026-01-16 12:05:31.377423	entry_date	\N	2025-06-06
4074	426	1	2026-01-16 12:05:31.378343	current_manager	\N	Козлов Д.В.
4075	426	1	2026-01-16 12:05:31.378966	it_block	\N	Диджитал
4076	426	1	2026-01-16 12:05:31.379513	ck_department	\N	Департамент цифровых продуктов
4077	426	1	2026-01-16 12:05:31.38004	placement_type	\N	перевод
4078	426	1	2026-01-16 12:05:31.380595	ready_for_vacancy	\N	Нет
4079	426	1	2026-01-16 12:05:31.381114	resume_link	\N	https://drive.google.com/file/92736
4080	426	1	2026-01-16 12:05:31.381994	manager_feedback	\N	Нужно развитие
4081	426	1	2026-01-16 12:05:31.382689	contacts	\N	+7 (910) 356-76-49, @васартё66, a.vasilev@rt.ru
4082	426	1	2026-01-16 12:05:31.383251	funding_end_date	\N	2026-06-09
4083	426	1	2026-01-16 12:05:31.383763	candidate_status	\N	В работе
4084	426	1	2026-01-16 12:05:31.384252	target_projects	\N	E-commerce Platform, ML Pipeline
4085	426	1	2026-01-16 12:05:31.384996	transfer_date	\N	
4086	426	1	2026-01-16 12:05:31.385881	recruiter	\N	Орлов М.С.
4087	426	1	2026-01-16 12:05:31.386492	hr_bp	\N	Лебедева Т.М.
4088	426	1	2026-01-16 12:05:31.387414	comments	\N	В процессе согласования
4089	427	1	2026-01-16 12:05:31.417991	entry_date	\N	2024-06-09
4090	427	1	2026-01-16 12:05:31.419335	current_manager	\N	Иванов А.П.
4091	427	1	2026-01-16 12:05:31.420593	it_block	\N	НУК
4092	427	1	2026-01-16 12:05:31.421197	ck_department	\N	ЦК Аналитики
4093	427	1	2026-01-16 12:05:31.42194	placement_type	\N	перевод
4094	427	1	2026-01-16 12:05:31.422513	ready_for_vacancy	\N	Да
4095	427	1	2026-01-16 12:05:31.423177	resume_link	\N	https://drive.google.com/file/54562
4096	427	1	2026-01-16 12:05:31.423803	manager_feedback	\N	Отличные результаты
4097	427	1	2026-01-16 12:05:31.427049	contacts	\N	+7 (980) 526-15-12, @солмакс23, m.solovev@rt.ru
4098	427	1	2026-01-16 12:05:31.427742	funding_end_date	\N	2025-09-29
4099	427	1	2026-01-16 12:05:31.428464	candidate_status	\N	Увольнение по СС
4100	427	1	2026-01-16 12:05:31.429166	target_projects	\N	Data Platform, Banking App, DevOps Platform
4101	427	1	2026-01-16 12:05:31.42988	transfer_date	\N	2025-10-26
4102	427	1	2026-01-16 12:05:31.430399	recruiter	\N	Орлов М.С.
4103	427	1	2026-01-16 12:05:31.43086	hr_bp	\N	Лебедева Т.М.
4104	427	1	2026-01-16 12:05:31.431319	comments	\N	Срочно нужен проект
4105	428	1	2026-01-16 12:05:31.453901	entry_date	\N	2025-11-16
4106	428	1	2026-01-16 12:05:31.45473	current_manager	\N	Михайлова О.Н.
4107	428	1	2026-01-16 12:05:31.455422	it_block	\N	Диджитал
4108	428	1	2026-01-16 12:05:31.455926	ck_department	\N	ЦК Разработки
4109	428	1	2026-01-16 12:05:31.456425	placement_type	\N	аутстафф
4110	428	1	2026-01-16 12:05:31.456915	ready_for_vacancy	\N	Нет
4111	428	1	2026-01-16 12:05:31.457473	resume_link	\N	https://drive.google.com/file/81737
4112	428	1	2026-01-16 12:05:31.457976	manager_feedback	\N	Нужно развитие
4113	428	1	2026-01-16 12:05:31.458453	contacts	\N	+7 (901) 398-94-91, @медигор65, i.medvedev@rt.ru
4114	428	1	2026-01-16 12:05:31.458931	funding_end_date	\N	2025-07-03
4115	428	1	2026-01-16 12:05:31.459402	candidate_status	\N	Переведен
4116	428	1	2026-01-16 12:05:31.459875	target_projects	\N	Mobile App, ML Pipeline, DevOps Platform
4117	428	1	2026-01-16 12:05:31.460343	transfer_date	\N	2025-09-12
4118	428	1	2026-01-16 12:05:31.460809	recruiter	\N	Белова И.Д.
4119	428	1	2026-01-16 12:05:31.461292	hr_bp	\N	Волкова Н.В.
4120	428	1	2026-01-16 12:05:31.461797	comments	\N	Ожидает оффер
4121	429	1	2026-01-16 12:05:31.482364	entry_date	\N	2024-05-03
4122	429	1	2026-01-16 12:05:31.483109	current_manager	\N	Сидорова Е.К.
4123	429	1	2026-01-16 12:05:31.483855	it_block	\N	Диджитал
4124	429	1	2026-01-16 12:05:31.484542	ck_department	\N	ЦК Разработки
4125	429	1	2026-01-16 12:05:31.485058	placement_type	\N	перевод
4126	429	1	2026-01-16 12:05:31.485629	ready_for_vacancy	\N	Нет
4127	429	1	2026-01-16 12:05:31.486297	resume_link	\N	https://drive.google.com/file/17276
4128	429	1	2026-01-16 12:05:31.486829	manager_feedback	\N	Нужно развитие
4129	429	1	2026-01-16 12:05:31.487337	contacts	\N	+7 (968) 572-71-23, @новалек20, a.novikov@rt.ru
4130	429	1	2026-01-16 12:05:31.487924	funding_end_date	\N	2025-05-22
4131	429	1	2026-01-16 12:05:31.488369	candidate_status	\N	Увольнение по СЖ
4132	429	1	2026-01-16 12:05:31.488826	target_projects	\N	ML Pipeline, E-commerce Platform
4133	429	1	2026-01-16 12:05:31.489326	transfer_date	\N	2026-05-12
4134	429	1	2026-01-16 12:05:31.48984	recruiter	\N	Белова И.Д.
4135	429	1	2026-01-16 12:05:31.490297	hr_bp	\N	Морозов К.А.
4136	429	1	2026-01-16 12:05:31.490751	comments	\N	
4137	430	1	2026-01-16 12:05:31.510619	entry_date	\N	2024-08-25
4138	430	1	2026-01-16 12:05:31.511357	current_manager	\N	Петров С.М.
4139	430	1	2026-01-16 12:05:31.511859	it_block	\N	НУК
4140	430	1	2026-01-16 12:05:31.512438	ck_department	\N	Департамент цифровых продуктов
4141	430	1	2026-01-16 12:05:31.512959	placement_type	\N	аутстафф
4142	430	1	2026-01-16 12:05:31.513373	ready_for_vacancy	\N	Да
4143	430	1	2026-01-16 12:05:31.513871	resume_link	\N	https://drive.google.com/file/79290
4144	430	1	2026-01-16 12:05:31.514324	manager_feedback	\N	
4145	430	1	2026-01-16 12:05:31.514766	contacts	\N	+7 (981) 716-83-66, @стедени99, d.stepanov@rt.ru
4146	430	1	2026-01-16 12:05:31.51522	funding_end_date	\N	2025-11-02
4147	430	1	2026-01-16 12:05:31.515675	candidate_status	\N	Увольнение по СС
4148	430	1	2026-01-16 12:05:31.516088	target_projects	\N	Infrastructure
4149	430	1	2026-01-16 12:05:31.51678	transfer_date	\N	2025-03-06
4150	430	1	2026-01-16 12:05:31.517384	recruiter	\N	Белова И.Д.
4151	430	1	2026-01-16 12:05:31.518086	hr_bp	\N	Морозов К.А.
4152	430	1	2026-01-16 12:05:31.518918	comments	\N	
4153	431	1	2026-01-16 12:05:31.538977	entry_date	\N	2025-05-05
4154	431	1	2026-01-16 12:05:31.539775	current_manager	\N	Иванов А.П.
4155	431	1	2026-01-16 12:05:31.540293	it_block	\N	НУК
4156	431	1	2026-01-16 12:05:31.54077	ck_department	\N	ЦК Разработки
4157	431	1	2026-01-16 12:05:31.541347	placement_type	\N	любой
4158	431	1	2026-01-16 12:05:31.54199	ready_for_vacancy	\N	Да
4159	431	1	2026-01-16 12:05:31.542475	resume_link	\N	https://drive.google.com/file/69009
4160	431	1	2026-01-16 12:05:31.542993	manager_feedback	\N	Нужно развитие
4161	431	1	2026-01-16 12:05:31.543662	contacts	\N	+7 (939) 675-77-38, @волсофи63, s.volkova@rt.ru
4162	431	1	2026-01-16 12:05:31.544115	funding_end_date	\N	2025-03-29
4163	431	1	2026-01-16 12:05:31.545091	candidate_status	\N	Увольнение по СЖ
4164	431	1	2026-01-16 12:05:31.54582	target_projects	\N	Data Platform
4165	431	1	2026-01-16 12:05:31.546339	transfer_date	\N	2025-05-02
4166	431	1	2026-01-16 12:05:31.546967	recruiter	\N	Белова И.Д.
4167	431	1	2026-01-16 12:05:31.547475	hr_bp	\N	Лебедева Т.М.
4168	431	1	2026-01-16 12:05:31.547953	comments	\N	Ожидает оффер
4169	432	1	2026-01-16 12:05:31.572031	entry_date	\N	2025-02-14
4170	432	1	2026-01-16 12:05:31.573071	current_manager	\N	Михайлова О.Н.
4171	432	1	2026-01-16 12:05:31.573916	it_block	\N	Эксплуатация
4172	432	1	2026-01-16 12:05:31.574574	ck_department	\N	ЦК Разработки
4173	432	1	2026-01-16 12:05:31.57507	placement_type	\N	перевод
4174	432	1	2026-01-16 12:05:31.575548	ready_for_vacancy	\N	Да
4175	432	1	2026-01-16 12:05:31.5763	resume_link	\N	https://drive.google.com/file/65117
4176	432	1	2026-01-16 12:05:31.576811	manager_feedback	\N	Рекомендую
4177	432	1	2026-01-16 12:05:31.577496	contacts	\N	+7 (999) 421-77-46, @тарвале47, v.tarasova@rt.ru
4178	432	1	2026-01-16 12:05:31.578018	funding_end_date	\N	2026-01-04
4179	432	1	2026-01-16 12:05:31.578517	candidate_status	\N	Увольнение по СЖ
4180	432	1	2026-01-16 12:05:31.579008	target_projects	\N	ML Pipeline, Mobile App
4181	432	1	2026-01-16 12:05:31.579705	transfer_date	\N	2026-04-29
4182	432	1	2026-01-16 12:05:31.580209	recruiter	\N	Орлов М.С.
4183	432	1	2026-01-16 12:05:31.580683	hr_bp	\N	Морозов К.А.
4184	432	1	2026-01-16 12:05:31.581163	comments	\N	
4185	433	1	2026-01-16 12:05:31.604354	entry_date	\N	2025-09-24
4186	433	1	2026-01-16 12:05:31.605055	current_manager	\N	Михайлова О.Н.
4187	433	1	2026-01-16 12:05:31.605647	it_block	\N	Эксплуатация
4188	433	1	2026-01-16 12:05:31.606123	ck_department	\N	ЦК Инфраструктуры
4189	433	1	2026-01-16 12:05:31.606467	placement_type	\N	любой
4190	433	1	2026-01-16 12:05:31.606792	ready_for_vacancy	\N	Нет
4191	433	1	2026-01-16 12:05:31.607108	resume_link	\N	https://drive.google.com/file/66036
4192	433	1	2026-01-16 12:05:31.607517	manager_feedback	\N	Отличные результаты
4193	433	1	2026-01-16 12:05:31.607841	contacts	\N	+7 (976) 113-48-44, @сокдани48, d.sokolov@rt.ru
4194	433	1	2026-01-16 12:05:31.60815	funding_end_date	\N	2026-08-24
4195	433	1	2026-01-16 12:05:31.608454	candidate_status	\N	Забронирован
4196	433	1	2026-01-16 12:05:31.608746	target_projects	\N	E-commerce Platform, Infrastructure
4197	433	1	2026-01-16 12:05:31.60904	transfer_date	\N	
4198	433	1	2026-01-16 12:05:31.609419	recruiter	\N	Новикова Е.П.
4199	433	1	2026-01-16 12:05:31.609739	hr_bp	\N	Лебедева Т.М.
4200	433	1	2026-01-16 12:05:31.610034	comments	\N	Срочно нужен проект
4201	434	1	2026-01-16 12:05:31.627943	entry_date	\N	2024-11-14
4202	434	1	2026-01-16 12:05:31.628447	current_manager	\N	Михайлова О.Н.
4203	434	1	2026-01-16 12:05:31.628978	it_block	\N	Прочее
4204	434	1	2026-01-16 12:05:31.629617	ck_department	\N	ЦК Разработки
4205	434	1	2026-01-16 12:05:31.630141	placement_type	\N	перевод
4206	434	1	2026-01-16 12:05:31.630623	ready_for_vacancy	\N	Нет
4207	434	1	2026-01-16 12:05:31.631009	resume_link	\N	https://drive.google.com/file/14076
4208	434	1	2026-01-16 12:05:31.631554	manager_feedback	\N	Рекомендую
4209	434	1	2026-01-16 12:05:31.631966	contacts	\N	+7 (903) 304-67-79, @ковксен95, k.kovaleva@rt.ru
4210	434	1	2026-01-16 12:05:31.632392	funding_end_date	\N	2026-01-31
4211	434	1	2026-01-16 12:05:31.632711	candidate_status	\N	Переведен
4212	434	1	2026-01-16 12:05:31.633017	target_projects	\N	Mobile App, ML Pipeline
4213	434	1	2026-01-16 12:05:31.63336	transfer_date	\N	2025-06-23
4214	434	1	2026-01-16 12:05:31.633741	recruiter	\N	Новикова Е.П.
4215	434	1	2026-01-16 12:05:31.634088	hr_bp	\N	Волкова Н.В.
4216	434	1	2026-01-16 12:05:31.634942	comments	\N	Ожидает оффер
4217	435	1	2026-01-16 12:05:31.659206	entry_date	\N	2025-01-26
4218	435	1	2026-01-16 12:05:31.659749	current_manager	\N	Козлов Д.В.
4219	435	1	2026-01-16 12:05:31.660121	it_block	\N	НУК
4220	435	1	2026-01-16 12:05:31.660452	ck_department	\N	ЦК Разработки
4221	435	1	2026-01-16 12:05:31.660759	placement_type	\N	перевод
4222	435	1	2026-01-16 12:05:31.661064	ready_for_vacancy	\N	Нет
4223	435	1	2026-01-16 12:05:31.661443	resume_link	\N	https://drive.google.com/file/20585
4224	435	1	2026-01-16 12:05:31.661768	manager_feedback	\N	
4225	435	1	2026-01-16 12:05:31.662071	contacts	\N	+7 (955) 849-84-25, @алеконс75, k.alekseev@rt.ru
4226	435	1	2026-01-16 12:05:31.662369	funding_end_date	\N	2025-03-13
4227	435	1	2026-01-16 12:05:31.662663	candidate_status	\N	Свободен
4228	435	1	2026-01-16 12:05:31.662958	target_projects	\N	Госуслуги 2.0
4229	435	1	2026-01-16 12:05:31.663313	transfer_date	\N	
4230	435	1	2026-01-16 12:05:31.663797	recruiter	\N	Смирнова А.А.
4231	435	1	2026-01-16 12:05:31.664254	hr_bp	\N	Морозов К.А.
4232	435	1	2026-01-16 12:05:31.664953	comments	\N	
4233	436	1	2026-01-16 12:05:31.683997	entry_date	\N	2024-09-07
4234	436	1	2026-01-16 12:05:31.685164	current_manager	\N	Иванов А.П.
4235	436	1	2026-01-16 12:05:31.685741	it_block	\N	Прочее
4236	436	1	2026-01-16 12:05:31.686194	ck_department	\N	ЦК Разработки
4237	436	1	2026-01-16 12:05:31.686805	placement_type	\N	любой
4238	436	1	2026-01-16 12:05:31.687313	ready_for_vacancy	\N	Да
4239	436	1	2026-01-16 12:05:31.687851	resume_link	\N	https://drive.google.com/file/54190
4240	436	1	2026-01-16 12:05:31.688268	manager_feedback	\N	Рекомендую
4241	436	1	2026-01-16 12:05:31.688668	contacts	\N	+7 (987) 888-10-71, @смиюлия79, yu.smirnova@rt.ru
4242	436	1	2026-01-16 12:05:31.689061	funding_end_date	\N	2025-02-26
4243	436	1	2026-01-16 12:05:31.689757	candidate_status	\N	Увольнение по СЖ
4244	436	1	2026-01-16 12:05:31.690222	target_projects	\N	ML Pipeline, Mobile App
4245	436	1	2026-01-16 12:05:31.690638	transfer_date	\N	2026-09-13
4246	436	1	2026-01-16 12:05:31.69106	recruiter	\N	Смирнова А.А.
4247	436	1	2026-01-16 12:05:31.691458	hr_bp	\N	Волкова Н.В.
4248	436	1	2026-01-16 12:05:31.691924	comments	\N	Срочно нужен проект
4249	437	1	2026-01-16 12:05:31.711501	entry_date	\N	2025-01-14
4250	437	1	2026-01-16 12:05:31.712103	current_manager	\N	Козлов Д.В.
4251	437	1	2026-01-16 12:05:31.712551	it_block	\N	Эксплуатация
4252	437	1	2026-01-16 12:05:31.713092	ck_department	\N	Департамент данных
4253	437	1	2026-01-16 12:05:31.713664	placement_type	\N	перевод
4254	437	1	2026-01-16 12:05:31.714159	ready_for_vacancy	\N	Да
4255	437	1	2026-01-16 12:05:31.714612	resume_link	\N	https://drive.google.com/file/77252
4256	437	1	2026-01-16 12:05:31.714987	manager_feedback	\N	Рекомендую
4257	437	1	2026-01-16 12:05:31.715315	contacts	\N	+7 (963) 931-88-20, @медолег77, o.medvedev@rt.ru
4258	437	1	2026-01-16 12:05:31.716053	funding_end_date	\N	2026-01-18
4259	437	1	2026-01-16 12:05:31.716394	candidate_status	\N	Переведен
4260	437	1	2026-01-16 12:05:31.716739	target_projects	\N	E-commerce Platform, Infrastructure, Banking App
4261	437	1	2026-01-16 12:05:31.71704	transfer_date	\N	2026-04-11
4262	437	1	2026-01-16 12:05:31.717468	recruiter	\N	Орлов М.С.
4263	437	1	2026-01-16 12:05:31.71807	hr_bp	\N	Морозов К.А.
4264	437	1	2026-01-16 12:05:31.718634	comments	\N	
4265	438	1	2026-01-16 12:05:31.747545	entry_date	\N	2024-01-05
4266	438	1	2026-01-16 12:05:31.748216	current_manager	\N	Петров С.М.
4267	438	1	2026-01-16 12:05:31.749177	it_block	\N	B2O
4268	438	1	2026-01-16 12:05:31.749903	ck_department	\N	ЦК Аналитики
4269	438	1	2026-01-16 12:05:31.750541	placement_type	\N	перевод
4270	438	1	2026-01-16 12:05:31.751122	ready_for_vacancy	\N	Нет
4271	438	1	2026-01-16 12:05:31.751854	resume_link	\N	https://drive.google.com/file/59025
4272	438	1	2026-01-16 12:05:31.753515	manager_feedback	\N	Нужно развитие
4273	438	1	2026-01-16 12:05:31.755645	contacts	\N	+7 (905) 359-72-13, @орлники94, n.orlov@rt.ru
4274	438	1	2026-01-16 12:05:31.756342	funding_end_date	\N	2026-09-22
4275	438	1	2026-01-16 12:05:31.756813	candidate_status	\N	В работе
4276	438	1	2026-01-16 12:05:31.757584	target_projects	\N	Infrastructure, DevOps Platform
4277	438	1	2026-01-16 12:05:31.75824	transfer_date	\N	
4278	438	1	2026-01-16 12:05:31.758772	recruiter	\N	Белова И.Д.
4279	438	1	2026-01-16 12:05:31.759241	hr_bp	\N	Волкова Н.В.
4280	438	1	2026-01-16 12:05:31.759598	comments	\N	
4281	439	1	2026-01-16 12:05:31.781544	entry_date	\N	2025-11-08
4282	439	1	2026-01-16 12:05:31.78232	current_manager	\N	Петров С.М.
4283	439	1	2026-01-16 12:05:31.782978	it_block	\N	Развитие
4284	439	1	2026-01-16 12:05:31.78353	ck_department	\N	ЦК Инфраструктуры
4285	439	1	2026-01-16 12:05:31.783969	placement_type	\N	перевод
4286	439	1	2026-01-16 12:05:31.784291	ready_for_vacancy	\N	Нет
4287	439	1	2026-01-16 12:05:31.784888	resume_link	\N	https://drive.google.com/file/21138
4288	439	1	2026-01-16 12:05:31.785529	manager_feedback	\N	Хороший специалист
4289	439	1	2026-01-16 12:05:31.786267	contacts	\N	+7 (925) 741-57-39, @петлюбо24, l.petrova@rt.ru
4290	439	1	2026-01-16 12:05:31.78673	funding_end_date	\N	2026-11-22
4291	439	1	2026-01-16 12:05:31.787069	candidate_status	\N	Увольнение по СЖ
4292	439	1	2026-01-16 12:05:31.787373	target_projects	\N	Mobile App, Data Platform
4293	439	1	2026-01-16 12:05:31.78767	transfer_date	\N	2026-02-22
4294	439	1	2026-01-16 12:05:31.787959	recruiter	\N	Белова И.Д.
4295	439	1	2026-01-16 12:05:31.788247	hr_bp	\N	Лебедева Т.М.
4296	439	1	2026-01-16 12:05:31.788533	comments	\N	
4297	440	1	2026-01-16 12:05:31.806262	entry_date	\N	2025-01-14
4298	440	1	2026-01-16 12:05:31.806786	current_manager	\N	Иванов А.П.
4299	440	1	2026-01-16 12:05:31.807148	it_block	\N	Развитие
4300	440	1	2026-01-16 12:05:31.807476	ck_department	\N	ЦК Инфраструктуры
4301	440	1	2026-01-16 12:05:31.807782	placement_type	\N	аутстафф
4302	440	1	2026-01-16 12:05:31.808093	ready_for_vacancy	\N	Да
4303	440	1	2026-01-16 12:05:31.808701	resume_link	\N	https://drive.google.com/file/60290
4304	440	1	2026-01-16 12:05:31.809069	manager_feedback	\N	Хороший специалист
4305	440	1	2026-01-16 12:05:31.809466	contacts	\N	+7 (972) 462-93-62, @ильилья63, i.ilin@rt.ru
4306	440	1	2026-01-16 12:05:31.809938	funding_end_date	\N	2025-02-24
4307	440	1	2026-01-16 12:05:31.810508	candidate_status	\N	Увольнение по СС
4308	440	1	2026-01-16 12:05:31.810984	target_projects	\N	ML Pipeline, Infrastructure
4309	440	1	2026-01-16 12:05:31.811449	transfer_date	\N	2025-04-26
4310	440	1	2026-01-16 12:05:31.811985	recruiter	\N	Белова И.Д.
4311	440	1	2026-01-16 12:05:31.812603	hr_bp	\N	Волкова Н.В.
4312	440	1	2026-01-16 12:05:31.813434	comments	\N	
4313	441	1	2026-01-16 12:05:31.837527	entry_date	\N	2024-12-05
4314	441	1	2026-01-16 12:05:31.838375	current_manager	\N	Петров С.М.
4315	441	1	2026-01-16 12:05:31.838994	it_block	\N	НУК
4316	441	1	2026-01-16 12:05:31.839422	ck_department	\N	ЦК Аналитики
4317	441	1	2026-01-16 12:05:31.839852	placement_type	\N	перевод
4318	441	1	2026-01-16 12:05:31.840395	ready_for_vacancy	\N	Нет
4319	441	1	2026-01-16 12:05:31.840888	resume_link	\N	https://drive.google.com/file/59127
4320	441	1	2026-01-16 12:05:31.841365	manager_feedback	\N	Рекомендую
4321	441	1	2026-01-16 12:05:31.841841	contacts	\N	+7 (956) 966-38-26, @анталин40, a.antonova@rt.ru
4322	441	1	2026-01-16 12:05:31.842213	funding_end_date	\N	2026-10-15
4323	441	1	2026-01-16 12:05:31.842522	candidate_status	\N	В работе
4324	441	1	2026-01-16 12:05:31.842825	target_projects	\N	Data Platform, Mobile App
4325	441	1	2026-01-16 12:05:31.843128	transfer_date	\N	
4326	441	1	2026-01-16 12:05:31.843425	recruiter	\N	Смирнова А.А.
4327	441	1	2026-01-16 12:05:31.843727	hr_bp	\N	Лебедева Т.М.
4328	441	1	2026-01-16 12:05:31.844395	comments	\N	В процессе согласования
4329	442	1	2026-01-16 12:05:31.874132	entry_date	\N	2025-08-14
4330	442	1	2026-01-16 12:05:31.875141	current_manager	\N	Сидорова Е.К.
4331	442	1	2026-01-16 12:05:31.875958	it_block	\N	Прочее
4332	442	1	2026-01-16 12:05:31.876506	ck_department	\N	ЦК Разработки
4333	442	1	2026-01-16 12:05:31.876967	placement_type	\N	любой
4334	442	1	2026-01-16 12:05:31.877565	ready_for_vacancy	\N	Да
4335	442	1	2026-01-16 12:05:31.878025	resume_link	\N	https://drive.google.com/file/10141
4336	442	1	2026-01-16 12:05:31.878363	manager_feedback	\N	Рекомендую
4337	442	1	2026-01-16 12:05:31.878702	contacts	\N	+7 (978) 390-75-74, @кисдмит34, d.kiselev@rt.ru
4338	442	1	2026-01-16 12:05:31.879188	funding_end_date	\N	2025-08-16
4339	442	1	2026-01-16 12:05:31.879579	candidate_status	\N	Свободен
4340	442	1	2026-01-16 12:05:31.87992	target_projects	\N	DevOps Platform, Banking App, ML Pipeline
4341	442	1	2026-01-16 12:05:31.880241	transfer_date	\N	
4342	442	1	2026-01-16 12:05:31.880548	recruiter	\N	Смирнова А.А.
4343	442	1	2026-01-16 12:05:31.880975	hr_bp	\N	Лебедева Т.М.
4344	442	1	2026-01-16 12:05:31.881787	comments	\N	Ожидает оффер
4345	443	1	2026-01-16 12:05:31.903918	entry_date	\N	2024-11-16
4346	443	1	2026-01-16 12:05:31.90445	current_manager	\N	Иванов А.П.
4347	443	1	2026-01-16 12:05:31.904839	it_block	\N	НУК
4348	443	1	2026-01-16 12:05:31.905174	ck_department	\N	ЦК Разработки
4349	443	1	2026-01-16 12:05:31.905704	placement_type	\N	аутстафф
4350	443	1	2026-01-16 12:05:31.90604	ready_for_vacancy	\N	Нет
4351	443	1	2026-01-16 12:05:31.906365	resume_link	\N	https://drive.google.com/file/16172
4352	443	1	2026-01-16 12:05:31.906687	manager_feedback	\N	
4353	443	1	2026-01-16 12:05:31.907007	contacts	\N	+7 (954) 765-89-71, @полксен86, k.polyakova@rt.ru
4354	443	1	2026-01-16 12:05:31.907392	funding_end_date	\N	2025-10-12
4355	443	1	2026-01-16 12:05:31.907722	candidate_status	\N	Забронирован
4356	443	1	2026-01-16 12:05:31.908048	target_projects	\N	Infrastructure, E-commerce Platform, Госуслуги 2.0
4357	443	1	2026-01-16 12:05:31.908359	transfer_date	\N	
4358	443	1	2026-01-16 12:05:31.908672	recruiter	\N	Орлов М.С.
4359	443	1	2026-01-16 12:05:31.908988	hr_bp	\N	Лебедева Т.М.
4360	443	1	2026-01-16 12:05:31.909473	comments	\N	В процессе согласования
4361	444	1	2026-01-16 12:05:31.929621	entry_date	\N	2024-12-10
4362	444	1	2026-01-16 12:05:31.930266	current_manager	\N	Иванов А.П.
4363	444	1	2026-01-16 12:05:31.930757	it_block	\N	Прочее
4364	444	1	2026-01-16 12:05:31.931112	ck_department	\N	Департамент данных
4365	444	1	2026-01-16 12:05:31.931572	placement_type	\N	перевод
4366	444	1	2026-01-16 12:05:31.932053	ready_for_vacancy	\N	Да
4367	444	1	2026-01-16 12:05:31.932538	resume_link	\N	https://drive.google.com/file/32467
4368	444	1	2026-01-16 12:05:31.932949	manager_feedback	\N	Нужно развитие
4369	444	1	2026-01-16 12:05:31.933581	contacts	\N	+7 (926) 204-36-91, @ильверо18, v.ilina@rt.ru
4370	444	1	2026-01-16 12:05:31.934153	funding_end_date	\N	2025-04-28
4371	444	1	2026-01-16 12:05:31.934659	candidate_status	\N	В работе
4372	444	1	2026-01-16 12:05:31.935109	target_projects	\N	Госуслуги 2.0, DevOps Platform
4373	444	1	2026-01-16 12:05:31.935457	transfer_date	\N	
4374	444	1	2026-01-16 12:05:31.935837	recruiter	\N	Новикова Е.П.
4375	444	1	2026-01-16 12:05:31.936406	hr_bp	\N	Морозов К.А.
4376	444	1	2026-01-16 12:05:31.936785	comments	\N	
4377	445	1	2026-01-16 12:05:31.954574	entry_date	\N	2025-02-03
4378	445	1	2026-01-16 12:05:31.9551	current_manager	\N	Михайлова О.Н.
4379	445	1	2026-01-16 12:05:31.95549	it_block	\N	Эксплуатация
4380	445	1	2026-01-16 12:05:31.955878	ck_department	\N	ЦК Разработки
4381	445	1	2026-01-16 12:05:31.956245	placement_type	\N	любой
4382	445	1	2026-01-16 12:05:31.956591	ready_for_vacancy	\N	Да
4383	445	1	2026-01-16 12:05:31.95694	resume_link	\N	https://drive.google.com/file/45574
4384	445	1	2026-01-16 12:05:31.957528	manager_feedback	\N	Рекомендую
4385	445	1	2026-01-16 12:05:31.957993	contacts	\N	+7 (962) 701-42-72, @сокрусл22, r.sokolov@rt.ru
4386	445	1	2026-01-16 12:05:31.958361	funding_end_date	\N	2025-01-25
4387	445	1	2026-01-16 12:05:31.958717	candidate_status	\N	В работе
4388	445	1	2026-01-16 12:05:31.959076	target_projects	\N	DevOps Platform
4389	445	1	2026-01-16 12:05:31.959513	transfer_date	\N	
4390	445	1	2026-01-16 12:05:31.959887	recruiter	\N	Орлов М.С.
4391	445	1	2026-01-16 12:05:31.960307	hr_bp	\N	Волкова Н.В.
4392	445	1	2026-01-16 12:05:31.961053	comments	\N	В процессе согласования
4393	446	1	2026-01-16 12:05:31.989623	entry_date	\N	2024-01-09
4394	446	1	2026-01-16 12:05:31.990457	current_manager	\N	Козлов Д.В.
4395	446	1	2026-01-16 12:05:31.990864	it_block	\N	НУК
4396	446	1	2026-01-16 12:05:31.991202	ck_department	\N	Департамент данных
4397	446	1	2026-01-16 12:05:31.991514	placement_type	\N	аутстафф
4398	446	1	2026-01-16 12:05:31.991814	ready_for_vacancy	\N	Нет
4399	446	1	2026-01-16 12:05:31.992446	resume_link	\N	https://drive.google.com/file/21929
4400	446	1	2026-01-16 12:05:31.992782	manager_feedback	\N	Рекомендую
4401	446	1	2026-01-16 12:05:31.993089	contacts	\N	+7 (969) 602-66-48, @семматв31, m.semenov@rt.ru
4402	446	1	2026-01-16 12:05:31.993458	funding_end_date	\N	2025-10-03
4403	446	1	2026-01-16 12:05:31.99379	candidate_status	\N	Увольнение по СС
4404	446	1	2026-01-16 12:05:31.99412	target_projects	\N	Banking App, Infrastructure
4405	446	1	2026-01-16 12:05:31.994764	transfer_date	\N	2026-10-12
4406	446	1	2026-01-16 12:05:31.995362	recruiter	\N	Орлов М.С.
4407	446	1	2026-01-16 12:05:31.996261	hr_bp	\N	Лебедева Т.М.
4408	446	1	2026-01-16 12:05:31.996821	comments	\N	Срочно нужен проект
4409	447	1	2026-01-16 12:05:32.017622	entry_date	\N	2024-07-12
4410	447	1	2026-01-16 12:05:32.018431	current_manager	\N	Козлов Д.В.
4411	447	1	2026-01-16 12:05:32.019202	it_block	\N	B2O
4412	447	1	2026-01-16 12:05:32.019639	ck_department	\N	ЦК Инфраструктуры
4413	447	1	2026-01-16 12:05:32.020023	placement_type	\N	любой
4414	447	1	2026-01-16 12:05:32.020419	ready_for_vacancy	\N	Нет
4415	447	1	2026-01-16 12:05:32.020792	resume_link	\N	https://drive.google.com/file/70590
4416	447	1	2026-01-16 12:05:32.021146	manager_feedback	\N	Нужно развитие
4417	447	1	2026-01-16 12:05:32.021577	contacts	\N	+7 (945) 705-62-74, @серюлия68, yu.sergeeva@rt.ru
4418	447	1	2026-01-16 12:05:32.021958	funding_end_date	\N	2026-01-25
4419	447	1	2026-01-16 12:05:32.022309	candidate_status	\N	Переведен
4420	447	1	2026-01-16 12:05:32.022652	target_projects	\N	Data Platform, ML Pipeline
4421	447	1	2026-01-16 12:05:32.022999	transfer_date	\N	2025-11-19
4422	447	1	2026-01-16 12:05:32.023344	recruiter	\N	Орлов М.С.
4423	447	1	2026-01-16 12:05:32.023759	hr_bp	\N	Волкова Н.В.
4424	447	1	2026-01-16 12:05:32.024111	comments	\N	В процессе согласования
4425	448	1	2026-01-16 12:05:32.043339	entry_date	\N	2024-11-09
4426	448	1	2026-01-16 12:05:32.044058	current_manager	\N	Иванов А.П.
4427	448	1	2026-01-16 12:05:32.044565	it_block	\N	Эксплуатация
4428	448	1	2026-01-16 12:05:32.045039	ck_department	\N	Департамент данных
4429	448	1	2026-01-16 12:05:32.045603	placement_type	\N	перевод
4430	448	1	2026-01-16 12:05:32.0461	ready_for_vacancy	\N	Нет
4431	448	1	2026-01-16 12:05:32.046557	resume_link	\N	https://drive.google.com/file/80425
4432	448	1	2026-01-16 12:05:32.046999	manager_feedback	\N	Отличные результаты
4433	448	1	2026-01-16 12:05:32.047434	contacts	\N	+7 (930) 706-76-41, @семрусл73, r.semenov@rt.ru
4434	448	1	2026-01-16 12:05:32.047864	funding_end_date	\N	2025-10-10
4435	448	1	2026-01-16 12:05:32.048677	candidate_status	\N	Переведен
4436	448	1	2026-01-16 12:05:32.049445	target_projects	\N	Mobile App, Госуслуги 2.0, E-commerce Platform
4437	448	1	2026-01-16 12:05:32.050256	transfer_date	\N	2026-04-01
4438	448	1	2026-01-16 12:05:32.051078	recruiter	\N	Белова И.Д.
4439	448	1	2026-01-16 12:05:32.051809	hr_bp	\N	Волкова Н.В.
4440	448	1	2026-01-16 12:05:32.052381	comments	\N	Срочно нужен проект
4441	449	1	2026-01-16 12:05:32.080614	entry_date	\N	2024-06-24
4442	449	1	2026-01-16 12:05:32.08171	current_manager	\N	Иванов А.П.
4443	449	1	2026-01-16 12:05:32.082196	it_block	\N	НУК
4444	449	1	2026-01-16 12:05:32.082547	ck_department	\N	ЦК Разработки
4445	449	1	2026-01-16 12:05:32.083305	placement_type	\N	любой
4446	449	1	2026-01-16 12:05:32.083789	ready_for_vacancy	\N	Нет
4447	449	1	2026-01-16 12:05:32.084138	resume_link	\N	https://drive.google.com/file/48711
4448	449	1	2026-01-16 12:05:32.084788	manager_feedback	\N	
4449	449	1	2026-01-16 12:05:32.085418	contacts	\N	+7 (931) 129-66-92, @васполи43, p.vasileva@rt.ru
4450	449	1	2026-01-16 12:05:32.086066	funding_end_date	\N	2026-10-26
4451	449	1	2026-01-16 12:05:32.086719	candidate_status	\N	Увольнение по СС
4452	449	1	2026-01-16 12:05:32.087203	target_projects	\N	E-commerce Platform
4453	449	1	2026-01-16 12:05:32.087928	transfer_date	\N	2025-11-16
4454	449	1	2026-01-16 12:05:32.088644	recruiter	\N	Смирнова А.А.
4455	449	1	2026-01-16 12:05:32.089212	hr_bp	\N	Морозов К.А.
4456	449	1	2026-01-16 12:05:32.090007	comments	\N	Ожидает оффер
4457	450	1	2026-01-16 12:05:32.108151	entry_date	\N	2025-06-01
4458	450	1	2026-01-16 12:05:32.108658	current_manager	\N	Михайлова О.Н.
4459	450	1	2026-01-16 12:05:32.109023	it_block	\N	Развитие
4460	450	1	2026-01-16 12:05:32.109501	ck_department	\N	ЦК Аналитики
4461	450	1	2026-01-16 12:05:32.110018	placement_type	\N	перевод
4462	450	1	2026-01-16 12:05:32.110403	ready_for_vacancy	\N	Да
4463	450	1	2026-01-16 12:05:32.110735	resume_link	\N	https://drive.google.com/file/48261
4464	450	1	2026-01-16 12:05:32.111048	manager_feedback	\N	
4465	450	1	2026-01-16 12:05:32.111354	contacts	\N	+7 (911) 480-92-37, @кисдени59, d.kiselev@rt.ru
4466	450	1	2026-01-16 12:05:32.11166	funding_end_date	\N	2025-01-21
4467	450	1	2026-01-16 12:05:32.111972	candidate_status	\N	Увольнение по СЖ
4468	450	1	2026-01-16 12:05:32.112288	target_projects	\N	Госуслуги 2.0, Infrastructure, ML Pipeline
4469	450	1	2026-01-16 12:05:32.112729	transfer_date	\N	2026-03-11
4470	450	1	2026-01-16 12:05:32.113339	recruiter	\N	Орлов М.С.
4471	450	1	2026-01-16 12:05:32.113949	hr_bp	\N	Волкова Н.В.
4472	450	1	2026-01-16 12:05:32.114399	comments	\N	
4473	451	1	2026-01-16 12:05:32.142185	entry_date	\N	2025-12-06
4474	451	1	2026-01-16 12:05:32.142849	current_manager	\N	Сидорова Е.К.
4475	451	1	2026-01-16 12:05:32.143343	it_block	\N	Развитие
4476	451	1	2026-01-16 12:05:32.14379	ck_department	\N	Департамент цифровых продуктов
4477	451	1	2026-01-16 12:05:32.144221	placement_type	\N	аутстафф
4478	451	1	2026-01-16 12:05:32.144845	ready_for_vacancy	\N	Да
4479	451	1	2026-01-16 12:05:32.145557	resume_link	\N	https://drive.google.com/file/33247
4480	451	1	2026-01-16 12:05:32.146096	manager_feedback	\N	
4481	451	1	2026-01-16 12:05:32.146553	contacts	\N	+7 (904) 185-41-90, @егоарсе8, a.egorov@rt.ru
4482	451	1	2026-01-16 12:05:32.146979	funding_end_date	\N	2026-02-11
4483	451	1	2026-01-16 12:05:32.147809	candidate_status	\N	В работе
4484	451	1	2026-01-16 12:05:32.1483	target_projects	\N	E-commerce Platform, Infrastructure
4485	451	1	2026-01-16 12:05:32.148745	transfer_date	\N	
4486	451	1	2026-01-16 12:05:32.149167	recruiter	\N	Белова И.Д.
4487	451	1	2026-01-16 12:05:32.149695	hr_bp	\N	Волкова Н.В.
4488	451	1	2026-01-16 12:05:32.150131	comments	\N	
4489	452	1	2026-01-16 12:05:32.182877	entry_date	\N	2024-08-02
4490	452	1	2026-01-16 12:05:32.183982	current_manager	\N	Петров С.М.
4491	452	1	2026-01-16 12:05:32.185468	it_block	\N	Диджитал
4492	452	1	2026-01-16 12:05:32.186345	ck_department	\N	ЦК Инфраструктуры
4493	452	1	2026-01-16 12:05:32.186966	placement_type	\N	любой
4494	452	1	2026-01-16 12:05:32.187422	ready_for_vacancy	\N	Да
4495	452	1	2026-01-16 12:05:32.187847	resume_link	\N	https://drive.google.com/file/48391
4496	452	1	2026-01-16 12:05:32.188368	manager_feedback	\N	Рекомендую
4497	452	1	2026-01-16 12:05:32.189011	contacts	\N	+7 (924) 827-96-63, @фропаве18, p.frolov@rt.ru
4498	452	1	2026-01-16 12:05:32.189702	funding_end_date	\N	2026-09-18
4499	452	1	2026-01-16 12:05:32.190593	candidate_status	\N	Переведен
4500	452	1	2026-01-16 12:05:32.191279	target_projects	\N	Banking App
4501	452	1	2026-01-16 12:05:32.191999	transfer_date	\N	2026-02-10
4502	452	1	2026-01-16 12:05:32.192708	recruiter	\N	Новикова Е.П.
4503	452	1	2026-01-16 12:05:32.193588	hr_bp	\N	Морозов К.А.
4504	452	1	2026-01-16 12:05:32.194366	comments	\N	Срочно нужен проект
4505	453	1	2026-01-16 12:05:32.220259	entry_date	\N	2024-04-27
4506	453	1	2026-01-16 12:05:32.22091	current_manager	\N	Иванов А.П.
4507	453	1	2026-01-16 12:05:32.221778	it_block	\N	Прочее
4508	453	1	2026-01-16 12:05:32.222452	ck_department	\N	ЦК Инфраструктуры
4509	453	1	2026-01-16 12:05:32.222962	placement_type	\N	любой
4510	453	1	2026-01-16 12:05:32.223452	ready_for_vacancy	\N	Да
4511	453	1	2026-01-16 12:05:32.223946	resume_link	\N	https://drive.google.com/file/76772
4512	453	1	2026-01-16 12:05:32.224433	manager_feedback	\N	Хороший специалист
4513	453	1	2026-01-16 12:05:32.224907	contacts	\N	+7 (926) 247-85-80, @макалек68, a.maksimova@rt.ru
4514	453	1	2026-01-16 12:05:32.225423	funding_end_date	\N	2026-04-28
4515	453	1	2026-01-16 12:05:32.225934	candidate_status	\N	В работе
4516	453	1	2026-01-16 12:05:32.226566	target_projects	\N	E-commerce Platform, Data Platform, Госуслуги 2.0
4517	453	1	2026-01-16 12:05:32.227042	transfer_date	\N	
4518	453	1	2026-01-16 12:05:32.227518	recruiter	\N	Новикова Е.П.
4519	453	1	2026-01-16 12:05:32.228046	hr_bp	\N	Лебедева Т.М.
4520	453	1	2026-01-16 12:05:32.228517	comments	\N	
4521	454	1	2026-01-16 12:05:32.249805	entry_date	\N	2024-10-18
4522	454	1	2026-01-16 12:05:32.250557	current_manager	\N	Петров С.М.
4523	454	1	2026-01-16 12:05:32.251052	it_block	\N	НУК
4524	454	1	2026-01-16 12:05:32.251736	ck_department	\N	ЦК Инфраструктуры
4525	454	1	2026-01-16 12:05:32.252224	placement_type	\N	аутстафф
4526	454	1	2026-01-16 12:05:32.252833	ready_for_vacancy	\N	Да
4527	454	1	2026-01-16 12:05:32.253485	resume_link	\N	https://drive.google.com/file/82787
4528	454	1	2026-01-16 12:05:32.254158	manager_feedback	\N	
4529	454	1	2026-01-16 12:05:32.254901	contacts	\N	+7 (924) 313-55-27, @стевади42, v.stepanov@rt.ru
4530	454	1	2026-01-16 12:05:32.255581	funding_end_date	\N	2026-02-26
4531	454	1	2026-01-16 12:05:32.256228	candidate_status	\N	Забронирован
4532	454	1	2026-01-16 12:05:32.256885	target_projects	\N	E-commerce Platform
4533	454	1	2026-01-16 12:05:32.257568	transfer_date	\N	
4534	454	1	2026-01-16 12:05:32.25806	recruiter	\N	Белова И.Д.
4535	454	1	2026-01-16 12:05:32.258509	hr_bp	\N	Морозов К.А.
4536	454	1	2026-01-16 12:05:32.25921	comments	\N	
4537	455	1	2026-01-16 12:05:32.278727	entry_date	\N	2024-03-07
4538	455	1	2026-01-16 12:05:32.279456	current_manager	\N	Козлов Д.В.
4539	455	1	2026-01-16 12:05:32.280146	it_block	\N	B2O
4540	455	1	2026-01-16 12:05:32.280702	ck_department	\N	Департамент цифровых продуктов
4541	455	1	2026-01-16 12:05:32.281182	placement_type	\N	любой
4542	455	1	2026-01-16 12:05:32.281861	ready_for_vacancy	\N	Нет
4543	455	1	2026-01-16 12:05:32.282394	resume_link	\N	https://drive.google.com/file/13479
4544	455	1	2026-01-16 12:05:32.282885	manager_feedback	\N	Рекомендую
4545	455	1	2026-01-16 12:05:32.28336	contacts	\N	+7 (976) 752-43-38, @кисолег81, o.kiselev@rt.ru
4546	455	1	2026-01-16 12:05:32.283838	funding_end_date	\N	2025-06-14
4547	455	1	2026-01-16 12:05:32.28445	candidate_status	\N	В работе
4548	455	1	2026-01-16 12:05:32.284991	target_projects	\N	Banking App, Mobile App
4549	455	1	2026-01-16 12:05:32.285511	transfer_date	\N	
4550	455	1	2026-01-16 12:05:32.285891	recruiter	\N	Белова И.Д.
4551	455	1	2026-01-16 12:05:32.286669	hr_bp	\N	Волкова Н.В.
4552	455	1	2026-01-16 12:05:32.28732	comments	\N	
4553	456	1	2026-01-16 12:05:32.306082	entry_date	\N	2024-08-23
4554	456	1	2026-01-16 12:05:32.306593	current_manager	\N	Петров С.М.
4555	456	1	2026-01-16 12:05:32.30695	it_block	\N	Диджитал
4556	456	1	2026-01-16 12:05:32.307265	ck_department	\N	ЦК Аналитики
4557	456	1	2026-01-16 12:05:32.307565	placement_type	\N	перевод
4558	456	1	2026-01-16 12:05:32.307861	ready_for_vacancy	\N	Нет
4559	456	1	2026-01-16 12:05:32.308162	resume_link	\N	https://drive.google.com/file/43432
4560	456	1	2026-01-16 12:05:32.308453	manager_feedback	\N	Рекомендую
4561	456	1	2026-01-16 12:05:32.308744	contacts	\N	+7 (973) 685-30-74, @михдани33, d.mikhaylov@rt.ru
4562	456	1	2026-01-16 12:05:32.309034	funding_end_date	\N	2026-09-24
4563	456	1	2026-01-16 12:05:32.309433	candidate_status	\N	Увольнение по СС
4564	456	1	2026-01-16 12:05:32.309824	target_projects	\N	Госуслуги 2.0
4565	456	1	2026-01-16 12:05:32.310131	transfer_date	\N	2025-08-10
4566	456	1	2026-01-16 12:05:32.310436	recruiter	\N	Смирнова А.А.
4567	456	1	2026-01-16 12:05:32.310805	hr_bp	\N	Волкова Н.В.
4568	456	1	2026-01-16 12:05:32.311358	comments	\N	В процессе согласования
4569	457	1	2026-01-16 12:05:32.33639	entry_date	\N	2025-03-16
4570	457	1	2026-01-16 12:05:32.337203	current_manager	\N	Петров С.М.
4571	457	1	2026-01-16 12:05:32.337912	it_block	\N	НУК
4572	457	1	2026-01-16 12:05:32.338302	ck_department	\N	ЦК Аналитики
4573	457	1	2026-01-16 12:05:32.338649	placement_type	\N	любой
4574	457	1	2026-01-16 12:05:32.338987	ready_for_vacancy	\N	Да
4575	457	1	2026-01-16 12:05:32.339319	resume_link	\N	https://drive.google.com/file/99754
4576	457	1	2026-01-16 12:05:32.339644	manager_feedback	\N	Нужно развитие
4577	457	1	2026-01-16 12:05:32.339964	contacts	\N	+7 (996) 252-31-84, @кузтимо51, t.kuznetsov@rt.ru
4578	457	1	2026-01-16 12:05:32.340285	funding_end_date	\N	2026-10-19
4579	457	1	2026-01-16 12:05:32.340614	candidate_status	\N	Увольнение по СС
4580	457	1	2026-01-16 12:05:32.340941	target_projects	\N	E-commerce Platform, ML Pipeline
4581	457	1	2026-01-16 12:05:32.34131	transfer_date	\N	2026-03-19
4582	457	1	2026-01-16 12:05:32.341694	recruiter	\N	Новикова Е.П.
4583	457	1	2026-01-16 12:05:32.342032	hr_bp	\N	Волкова Н.В.
4584	457	1	2026-01-16 12:05:32.342364	comments	\N	
4585	458	1	2026-01-16 12:05:32.367024	entry_date	\N	2025-08-03
4586	458	1	2026-01-16 12:05:32.368086	current_manager	\N	Михайлова О.Н.
4587	458	1	2026-01-16 12:05:32.368743	it_block	\N	Эксплуатация
4588	458	1	2026-01-16 12:05:32.369428	ck_department	\N	Департамент цифровых продуктов
4589	458	1	2026-01-16 12:05:32.370176	placement_type	\N	любой
4590	458	1	2026-01-16 12:05:32.370953	ready_for_vacancy	\N	Да
4591	458	1	2026-01-16 12:05:32.371501	resume_link	\N	https://drive.google.com/file/27103
4592	458	1	2026-01-16 12:05:32.372039	manager_feedback	\N	Отличные результаты
4593	458	1	2026-01-16 12:05:32.372554	contacts	\N	+7 (956) 869-28-99, @якосаве45, s.yakovlev@rt.ru
4594	458	1	2026-01-16 12:05:32.373069	funding_end_date	\N	2025-08-23
4595	458	1	2026-01-16 12:05:32.373642	candidate_status	\N	В работе
4596	458	1	2026-01-16 12:05:32.37414	target_projects	\N	Mobile App, DevOps Platform, E-commerce Platform
4597	458	1	2026-01-16 12:05:32.374624	transfer_date	\N	
4598	458	1	2026-01-16 12:05:32.375123	recruiter	\N	Новикова Е.П.
4599	458	1	2026-01-16 12:05:32.375605	hr_bp	\N	Лебедева Т.М.
4600	458	1	2026-01-16 12:05:32.376072	comments	\N	
4601	459	1	2026-01-16 12:05:32.400122	entry_date	\N	2025-10-16
4602	459	1	2026-01-16 12:05:32.400787	current_manager	\N	Петров С.М.
4603	459	1	2026-01-16 12:05:32.401282	it_block	\N	НУК
4604	459	1	2026-01-16 12:05:32.402041	ck_department	\N	Департамент цифровых продуктов
4605	459	1	2026-01-16 12:05:32.402615	placement_type	\N	перевод
4606	459	1	2026-01-16 12:05:32.403392	ready_for_vacancy	\N	Нет
4607	459	1	2026-01-16 12:05:32.403899	resume_link	\N	https://drive.google.com/file/71145
4608	459	1	2026-01-16 12:05:32.404344	manager_feedback	\N	Хороший специалист
4609	459	1	2026-01-16 12:05:32.404916	contacts	\N	+7 (942) 118-25-64, @кузалек77, a.kuzmina@rt.ru
4610	459	1	2026-01-16 12:05:32.405321	funding_end_date	\N	2026-05-12
4611	459	1	2026-01-16 12:05:32.405675	candidate_status	\N	Переведен
4612	459	1	2026-01-16 12:05:32.405986	target_projects	\N	Infrastructure, DevOps Platform
4613	459	1	2026-01-16 12:05:32.406287	transfer_date	\N	2025-01-19
4614	459	1	2026-01-16 12:05:32.406585	recruiter	\N	Орлов М.С.
4615	459	1	2026-01-16 12:05:32.40688	hr_bp	\N	Волкова Н.В.
4616	459	1	2026-01-16 12:05:32.407178	comments	\N	Ожидает оффер
4617	460	1	2026-01-16 12:05:32.426362	entry_date	\N	2024-06-18
4618	460	1	2026-01-16 12:05:32.42684	current_manager	\N	Иванов А.П.
4619	460	1	2026-01-16 12:05:32.42719	it_block	\N	Диджитал
4620	460	1	2026-01-16 12:05:32.4275	ck_department	\N	Департамент цифровых продуктов
4621	460	1	2026-01-16 12:05:32.427799	placement_type	\N	аутстафф
4622	460	1	2026-01-16 12:05:32.428093	ready_for_vacancy	\N	Нет
4623	460	1	2026-01-16 12:05:32.428387	resume_link	\N	https://drive.google.com/file/76281
4624	460	1	2026-01-16 12:05:32.428675	manager_feedback	\N	Отличные результаты
4625	460	1	2026-01-16 12:05:32.42896	contacts	\N	+7 (964) 523-27-77, @никмакс93, m.nikolaev@rt.ru
4626	460	1	2026-01-16 12:05:32.429272	funding_end_date	\N	2026-02-04
4627	460	1	2026-01-16 12:05:32.429608	candidate_status	\N	В работе
4628	460	1	2026-01-16 12:05:32.429902	target_projects	\N	Infrastructure, DevOps Platform
4629	460	1	2026-01-16 12:05:32.430193	transfer_date	\N	
4630	460	1	2026-01-16 12:05:32.430481	recruiter	\N	Новикова Е.П.
4631	460	1	2026-01-16 12:05:32.430767	hr_bp	\N	Волкова Н.В.
4632	460	1	2026-01-16 12:05:32.431253	comments	\N	Срочно нужен проект
4633	461	1	2026-01-16 12:05:32.450419	entry_date	\N	2025-04-28
4634	461	1	2026-01-16 12:05:32.450909	current_manager	\N	Михайлова О.Н.
4635	461	1	2026-01-16 12:05:32.451448	it_block	\N	Эксплуатация
4636	461	1	2026-01-16 12:05:32.452005	ck_department	\N	ЦК Инфраструктуры
4637	461	1	2026-01-16 12:05:32.452348	placement_type	\N	аутстафф
4638	461	1	2026-01-16 12:05:32.452667	ready_for_vacancy	\N	Нет
4639	461	1	2026-01-16 12:05:32.453219	resume_link	\N	https://drive.google.com/file/13173
4640	461	1	2026-01-16 12:05:32.453821	manager_feedback	\N	Рекомендую
4641	461	1	2026-01-16 12:05:32.454168	contacts	\N	+7 (945) 414-61-44, @антдарь27, d.antonova@rt.ru
4642	461	1	2026-01-16 12:05:32.45476	funding_end_date	\N	2026-02-15
4643	461	1	2026-01-16 12:05:32.455142	candidate_status	\N	Переведен
4644	461	1	2026-01-16 12:05:32.455467	target_projects	\N	E-commerce Platform, ML Pipeline
4645	461	1	2026-01-16 12:05:32.455781	transfer_date	\N	2025-04-02
4646	461	1	2026-01-16 12:05:32.456086	recruiter	\N	Орлов М.С.
4647	461	1	2026-01-16 12:05:32.456388	hr_bp	\N	Волкова Н.В.
4648	461	1	2026-01-16 12:05:32.456689	comments	\N	В процессе согласования
4649	462	1	2026-01-16 12:05:32.477169	entry_date	\N	2025-07-30
4650	462	1	2026-01-16 12:05:32.478021	current_manager	\N	Козлов Д.В.
4651	462	1	2026-01-16 12:05:32.478846	it_block	\N	Развитие
4652	462	1	2026-01-16 12:05:32.479474	ck_department	\N	ЦК Разработки
4653	462	1	2026-01-16 12:05:32.479977	placement_type	\N	любой
4654	462	1	2026-01-16 12:05:32.482046	ready_for_vacancy	\N	Нет
4655	462	1	2026-01-16 12:05:32.482489	resume_link	\N	https://drive.google.com/file/80666
4656	462	1	2026-01-16 12:05:32.482852	manager_feedback	\N	Отличные результаты
4657	462	1	2026-01-16 12:05:32.483177	contacts	\N	+7 (976) 605-14-75, @андолег44, o.andreev@rt.ru
4658	462	1	2026-01-16 12:05:32.48349	funding_end_date	\N	2025-04-26
4659	462	1	2026-01-16 12:05:32.483802	candidate_status	\N	Свободен
4660	462	1	2026-01-16 12:05:32.484105	target_projects	\N	ML Pipeline
4661	462	1	2026-01-16 12:05:32.484823	transfer_date	\N	
4662	462	1	2026-01-16 12:05:32.485645	recruiter	\N	Белова И.Д.
4663	462	1	2026-01-16 12:05:32.48623	hr_bp	\N	Морозов К.А.
4664	462	1	2026-01-16 12:05:32.486636	comments	\N	Ожидает оффер
4665	463	1	2026-01-16 12:05:32.51295	entry_date	\N	2025-05-08
4666	463	1	2026-01-16 12:05:32.513887	current_manager	\N	Иванов А.П.
4667	463	1	2026-01-16 12:05:32.514622	it_block	\N	НУК
4668	463	1	2026-01-16 12:05:32.515168	ck_department	\N	ЦК Инфраструктуры
4669	463	1	2026-01-16 12:05:32.515769	placement_type	\N	перевод
4670	463	1	2026-01-16 12:05:32.516344	ready_for_vacancy	\N	Да
4671	463	1	2026-01-16 12:05:32.516744	resume_link	\N	https://drive.google.com/file/33876
4672	463	1	2026-01-16 12:05:32.517079	manager_feedback	\N	Отличные результаты
4673	463	1	2026-01-16 12:05:32.517488	contacts	\N	+7 (951) 761-96-35, @макпаве96, p.makarov@rt.ru
4674	463	1	2026-01-16 12:05:32.518054	funding_end_date	\N	2025-03-16
4675	463	1	2026-01-16 12:05:32.518727	candidate_status	\N	Увольнение по СС
4676	463	1	2026-01-16 12:05:32.519467	target_projects	\N	Banking App, ML Pipeline, Госуслуги 2.0
4677	463	1	2026-01-16 12:05:32.520046	transfer_date	\N	2025-11-28
4678	463	1	2026-01-16 12:05:32.520695	recruiter	\N	Смирнова А.А.
4679	463	1	2026-01-16 12:05:32.521294	hr_bp	\N	Лебедева Т.М.
4680	463	1	2026-01-16 12:05:32.521702	comments	\N	
4681	464	1	2026-01-16 12:05:32.556112	entry_date	\N	2025-06-21
4682	464	1	2026-01-16 12:05:32.557543	current_manager	\N	Михайлова О.Н.
4683	464	1	2026-01-16 12:05:32.558606	it_block	\N	Эксплуатация
4684	464	1	2026-01-16 12:05:32.559472	ck_department	\N	ЦК Инфраструктуры
4685	464	1	2026-01-16 12:05:32.560464	placement_type	\N	перевод
4686	464	1	2026-01-16 12:05:32.561486	ready_for_vacancy	\N	Нет
4687	464	1	2026-01-16 12:05:32.562453	resume_link	\N	https://drive.google.com/file/73539
4688	464	1	2026-01-16 12:05:32.56636	manager_feedback	\N	Хороший специалист
4689	464	1	2026-01-16 12:05:32.566909	contacts	\N	+7 (934) 987-83-65, @никарту62, a.nikitin@rt.ru
4690	464	1	2026-01-16 12:05:32.56745	funding_end_date	\N	2026-02-07
4691	464	1	2026-01-16 12:05:32.572853	candidate_status	\N	В работе
4692	464	1	2026-01-16 12:05:32.573583	target_projects	\N	Banking App, DevOps Platform
4693	464	1	2026-01-16 12:05:32.574111	transfer_date	\N	
4694	464	1	2026-01-16 12:05:32.574614	recruiter	\N	Белова И.Д.
4695	464	1	2026-01-16 12:05:32.575109	hr_bp	\N	Лебедева Т.М.
4696	464	1	2026-01-16 12:05:32.575601	comments	\N	Ожидает оффер
4697	465	1	2026-01-16 12:05:32.596416	entry_date	\N	2025-05-18
4698	465	1	2026-01-16 12:05:32.59709	current_manager	\N	Сидорова Е.К.
4699	465	1	2026-01-16 12:05:32.597694	it_block	\N	Диджитал
4700	465	1	2026-01-16 12:05:32.598366	ck_department	\N	Департамент данных
4701	465	1	2026-01-16 12:05:32.598889	placement_type	\N	перевод
4702	465	1	2026-01-16 12:05:32.599237	ready_for_vacancy	\N	Да
4703	465	1	2026-01-16 12:05:32.599571	resume_link	\N	https://drive.google.com/file/22516
4704	465	1	2026-01-16 12:05:32.599874	manager_feedback	\N	Хороший специалист
4705	465	1	2026-01-16 12:05:32.600164	contacts	\N	+7 (992) 571-88-61, @михлюдм44, l.mikhaylova@rt.ru
4706	465	1	2026-01-16 12:05:32.600453	funding_end_date	\N	2026-06-14
4707	465	1	2026-01-16 12:05:32.600739	candidate_status	\N	Увольнение по СС
4708	465	1	2026-01-16 12:05:32.601019	target_projects	\N	E-commerce Platform, Mobile App, Infrastructure
4709	465	1	2026-01-16 12:05:32.601768	transfer_date	\N	2025-03-01
4710	465	1	2026-01-16 12:05:32.602303	recruiter	\N	Белова И.Д.
4711	465	1	2026-01-16 12:05:32.602846	hr_bp	\N	Морозов К.А.
4712	465	1	2026-01-16 12:05:32.603168	comments	\N	
4713	466	1	2026-01-16 12:05:32.632068	entry_date	\N	2024-03-26
4714	466	1	2026-01-16 12:05:32.633289	current_manager	\N	Иванов А.П.
4715	466	1	2026-01-16 12:05:32.634328	it_block	\N	Диджитал
4716	466	1	2026-01-16 12:05:32.635261	ck_department	\N	ЦК Аналитики
4717	466	1	2026-01-16 12:05:32.635795	placement_type	\N	любой
4718	466	1	2026-01-16 12:05:32.636239	ready_for_vacancy	\N	Да
4719	466	1	2026-01-16 12:05:32.637105	resume_link	\N	https://drive.google.com/file/10036
4720	466	1	2026-01-16 12:05:32.637618	manager_feedback	\N	Хороший специалист
4721	466	1	2026-01-16 12:05:32.638319	contacts	\N	+7 (932) 941-97-82, @фрокири6, k.frolov@rt.ru
4722	466	1	2026-01-16 12:05:32.638777	funding_end_date	\N	2025-01-03
4723	466	1	2026-01-16 12:05:32.639218	candidate_status	\N	Свободен
4724	466	1	2026-01-16 12:05:32.639655	target_projects	\N	ML Pipeline
4725	466	1	2026-01-16 12:05:32.640098	transfer_date	\N	
4726	466	1	2026-01-16 12:05:32.640532	recruiter	\N	Орлов М.С.
4727	466	1	2026-01-16 12:05:32.64097	hr_bp	\N	Волкова Н.В.
4728	466	1	2026-01-16 12:05:32.641548	comments	\N	Срочно нужен проект
4729	467	1	2026-01-16 12:05:32.665218	entry_date	\N	2025-11-07
4730	467	1	2026-01-16 12:05:32.666093	current_manager	\N	Иванов А.П.
4731	467	1	2026-01-16 12:05:32.666806	it_block	\N	Диджитал
4732	467	1	2026-01-16 12:05:32.667312	ck_department	\N	ЦК Инфраструктуры
4733	467	1	2026-01-16 12:05:32.668007	placement_type	\N	любой
4734	467	1	2026-01-16 12:05:32.669043	ready_for_vacancy	\N	Нет
4735	467	1	2026-01-16 12:05:32.670035	resume_link	\N	https://drive.google.com/file/16632
4736	467	1	2026-01-16 12:05:32.670913	manager_feedback	\N	
4737	467	1	2026-01-16 12:05:32.671507	contacts	\N	+7 (957) 853-45-21, @орлелен35, e.orlova@rt.ru
4738	467	1	2026-01-16 12:05:32.672024	funding_end_date	\N	2025-08-02
4739	467	1	2026-01-16 12:05:32.672513	candidate_status	\N	Увольнение по СС
4740	467	1	2026-01-16 12:05:32.672987	target_projects	\N	Mobile App, E-commerce Platform
4741	467	1	2026-01-16 12:05:32.673546	transfer_date	\N	2025-09-14
4742	467	1	2026-01-16 12:05:32.674054	recruiter	\N	Белова И.Д.
4743	467	1	2026-01-16 12:05:32.674545	hr_bp	\N	Волкова Н.В.
4744	467	1	2026-01-16 12:05:32.675015	comments	\N	
4745	468	1	2026-01-16 12:05:32.708502	entry_date	\N	2025-10-21
4746	468	1	2026-01-16 12:05:32.709728	current_manager	\N	Козлов Д.В.
4747	468	1	2026-01-16 12:05:32.710978	it_block	\N	B2O
4748	468	1	2026-01-16 12:05:32.712042	ck_department	\N	ЦК Разработки
4749	468	1	2026-01-16 12:05:32.713063	placement_type	\N	любой
4750	468	1	2026-01-16 12:05:32.713987	ready_for_vacancy	\N	Нет
4751	468	1	2026-01-16 12:05:32.714868	resume_link	\N	https://drive.google.com/file/72597
4752	468	1	2026-01-16 12:05:32.715797	manager_feedback	\N	Отличные результаты
4753	468	1	2026-01-16 12:05:32.716599	contacts	\N	+7 (994) 777-75-71, @никмари81, m.nikolaeva@rt.ru
4754	468	1	2026-01-16 12:05:32.717655	funding_end_date	\N	2026-07-22
4755	468	1	2026-01-16 12:05:32.718936	candidate_status	\N	В работе
4756	468	1	2026-01-16 12:05:32.720234	target_projects	\N	ML Pipeline
4757	468	1	2026-01-16 12:05:32.721278	transfer_date	\N	
4758	468	1	2026-01-16 12:05:32.722108	recruiter	\N	Новикова Е.П.
4759	468	1	2026-01-16 12:05:32.722929	hr_bp	\N	Морозов К.А.
4760	468	1	2026-01-16 12:05:32.723772	comments	\N	
4761	469	1	2026-01-16 12:05:32.751441	entry_date	\N	2024-05-08
4762	469	1	2026-01-16 12:05:32.752213	current_manager	\N	Михайлова О.Н.
4763	469	1	2026-01-16 12:05:32.752766	it_block	\N	Диджитал
4764	469	1	2026-01-16 12:05:32.753304	ck_department	\N	ЦК Разработки
4765	469	1	2026-01-16 12:05:32.753894	placement_type	\N	аутстафф
4766	469	1	2026-01-16 12:05:32.754577	ready_for_vacancy	\N	Нет
4767	469	1	2026-01-16 12:05:32.754957	resume_link	\N	https://drive.google.com/file/31546
4768	469	1	2026-01-16 12:05:32.755269	manager_feedback	\N	
4769	469	1	2026-01-16 12:05:32.755579	contacts	\N	+7 (912) 340-36-58, @петксен11, k.petrova@rt.ru
4770	469	1	2026-01-16 12:05:32.755878	funding_end_date	\N	2026-02-14
4771	469	1	2026-01-16 12:05:32.756166	candidate_status	\N	Увольнение по СС
4772	469	1	2026-01-16 12:05:32.756451	target_projects	\N	Госуслуги 2.0, Mobile App
4773	469	1	2026-01-16 12:05:32.756735	transfer_date	\N	2025-04-08
4774	469	1	2026-01-16 12:05:32.757015	recruiter	\N	Белова И.Д.
4775	469	1	2026-01-16 12:05:32.757486	hr_bp	\N	Лебедева Т.М.
4776	469	1	2026-01-16 12:05:32.757943	comments	\N	
4777	470	1	2026-01-16 12:05:32.779042	entry_date	\N	2025-07-05
4778	470	1	2026-01-16 12:05:32.779952	current_manager	\N	Козлов Д.В.
4779	470	1	2026-01-16 12:05:32.780682	it_block	\N	B2O
4780	470	1	2026-01-16 12:05:32.781548	ck_department	\N	ЦК Аналитики
4781	470	1	2026-01-16 12:05:32.782149	placement_type	\N	аутстафф
4782	470	1	2026-01-16 12:05:32.782801	ready_for_vacancy	\N	Нет
4783	470	1	2026-01-16 12:05:32.783334	resume_link	\N	https://drive.google.com/file/87807
4784	470	1	2026-01-16 12:05:32.783726	manager_feedback	\N	Нужно развитие
4785	470	1	2026-01-16 12:05:32.784079	contacts	\N	+7 (968) 210-61-60, @алебогд79, b.aleksandrov@rt.ru
4786	470	1	2026-01-16 12:05:32.784476	funding_end_date	\N	2025-06-01
4787	470	1	2026-01-16 12:05:32.78507	candidate_status	\N	Увольнение по СС
4788	470	1	2026-01-16 12:05:32.78568	target_projects	\N	Data Platform, Mobile App
4789	470	1	2026-01-16 12:05:32.786746	transfer_date	\N	2026-10-14
4790	470	1	2026-01-16 12:05:32.787313	recruiter	\N	Белова И.Д.
4791	470	1	2026-01-16 12:05:32.787826	hr_bp	\N	Лебедева Т.М.
4792	470	1	2026-01-16 12:05:32.788328	comments	\N	Срочно нужен проект
4793	471	1	2026-01-16 12:05:32.806917	entry_date	\N	2025-08-01
4794	471	1	2026-01-16 12:05:32.807451	current_manager	\N	Сидорова Е.К.
4795	471	1	2026-01-16 12:05:32.807793	it_block	\N	Эксплуатация
4796	471	1	2026-01-16 12:05:32.808089	ck_department	\N	Департамент данных
4797	471	1	2026-01-16 12:05:32.808376	placement_type	\N	перевод
4798	471	1	2026-01-16 12:05:32.808659	ready_for_vacancy	\N	Нет
4799	471	1	2026-01-16 12:05:32.808941	resume_link	\N	https://drive.google.com/file/17611
4800	471	1	2026-01-16 12:05:32.809215	manager_feedback	\N	Рекомендую
4801	471	1	2026-01-16 12:05:32.809836	contacts	\N	+7 (901) 890-50-20, @ильмари1, m.ilina@rt.ru
4802	471	1	2026-01-16 12:05:32.810165	funding_end_date	\N	2026-10-12
4803	471	1	2026-01-16 12:05:32.810452	candidate_status	\N	Увольнение по СЖ
4804	471	1	2026-01-16 12:05:32.810734	target_projects	\N	DevOps Platform, Banking App, Mobile App
4805	471	1	2026-01-16 12:05:32.811013	transfer_date	\N	2025-08-12
4806	471	1	2026-01-16 12:05:32.811289	recruiter	\N	Белова И.Д.
4807	471	1	2026-01-16 12:05:32.811564	hr_bp	\N	Лебедева Т.М.
4808	471	1	2026-01-16 12:05:32.812226	comments	\N	
4809	506	1	2026-01-16 12:05:32.854734	entry_date	\N	2025-04-07
4810	506	1	2026-01-16 12:05:32.855615	current_manager	\N	Петров С.М.
4811	506	1	2026-01-16 12:05:32.856092	it_block	\N	Диджитал
4812	506	1	2026-01-16 12:05:32.856441	ck_department	\N	Департамент цифровых продуктов
4813	506	1	2026-01-16 12:05:32.856752	placement_type	\N	любой
4814	506	1	2026-01-16 12:05:32.857046	ready_for_vacancy	\N	Да
4815	506	1	2026-01-16 12:05:32.857433	resume_link	\N	https://drive.google.com/file/40399
4816	506	1	2026-01-16 12:05:32.858107	manager_feedback	\N	Рекомендую
4817	506	1	2026-01-16 12:05:32.858727	contacts	\N	+7 (951) 647-90-86, @орлбогд52, b.orlov@rt.ru
4818	506	1	2026-01-16 12:05:32.859199	funding_end_date	\N	2025-04-14
4819	506	1	2026-01-16 12:05:32.859664	candidate_status	\N	Увольнение по СС
4820	506	1	2026-01-16 12:05:32.860145	target_projects	\N	Mobile App, ML Pipeline, Banking App
4821	506	1	2026-01-16 12:05:32.860614	transfer_date	\N	2026-11-16
4822	506	1	2026-01-16 12:05:32.861099	recruiter	\N	Смирнова А.А.
4823	506	1	2026-01-16 12:05:32.861796	hr_bp	\N	Лебедева Т.М.
4824	506	1	2026-01-16 12:05:32.86248	comments	\N	
4825	507	1	2026-01-16 12:05:32.889921	entry_date	\N	2024-12-05
4826	507	1	2026-01-16 12:05:32.890544	current_manager	\N	Иванов А.П.
4827	507	1	2026-01-16 12:05:32.890935	it_block	\N	Прочее
4828	507	1	2026-01-16 12:05:32.891253	ck_department	\N	ЦК Аналитики
4829	507	1	2026-01-16 12:05:32.89157	placement_type	\N	любой
4830	507	1	2026-01-16 12:05:32.891865	ready_for_vacancy	\N	Да
4831	507	1	2026-01-16 12:05:32.892178	resume_link	\N	https://drive.google.com/file/18933
4832	507	1	2026-01-16 12:05:32.892527	manager_feedback	\N	Нужно развитие
4833	507	1	2026-01-16 12:05:32.892821	contacts	\N	+7 (902) 175-67-41, @новники44, n.novikov@rt.ru
4834	507	1	2026-01-16 12:05:32.89311	funding_end_date	\N	2025-09-02
4835	507	1	2026-01-16 12:05:32.893481	candidate_status	\N	Свободен
4836	507	1	2026-01-16 12:05:32.893796	target_projects	\N	Mobile App, E-commerce Platform, DevOps Platform
4837	507	1	2026-01-16 12:05:32.894089	transfer_date	\N	
4838	507	1	2026-01-16 12:05:32.894377	recruiter	\N	Смирнова А.А.
4839	507	1	2026-01-16 12:05:32.894668	hr_bp	\N	Волкова Н.В.
4840	507	1	2026-01-16 12:05:32.894948	comments	\N	
4841	508	1	2026-01-16 12:05:32.913334	entry_date	\N	2024-10-26
4842	508	1	2026-01-16 12:05:32.91385	current_manager	\N	Петров С.М.
4843	508	1	2026-01-16 12:05:32.914214	it_block	\N	Прочее
4844	508	1	2026-01-16 12:05:32.914533	ck_department	\N	ЦК Аналитики
4845	508	1	2026-01-16 12:05:32.91484	placement_type	\N	перевод
4846	508	1	2026-01-16 12:05:32.915234	ready_for_vacancy	\N	Да
4847	508	1	2026-01-16 12:05:32.91553	resume_link	\N	https://drive.google.com/file/77311
4848	508	1	2026-01-16 12:05:32.915825	manager_feedback	\N	Рекомендую
4849	508	1	2026-01-16 12:05:32.916172	contacts	\N	+7 (904) 472-56-57, @семвале18, v.semenova@rt.ru
4850	508	1	2026-01-16 12:05:32.916469	funding_end_date	\N	2026-11-08
4851	508	1	2026-01-16 12:05:32.916754	candidate_status	\N	Свободен
4852	508	1	2026-01-16 12:05:32.917037	target_projects	\N	E-commerce Platform, Infrastructure, Data Platform
4853	508	1	2026-01-16 12:05:32.91739	transfer_date	\N	
4854	508	1	2026-01-16 12:05:32.917862	recruiter	\N	Белова И.Д.
4855	508	1	2026-01-16 12:05:32.918401	hr_bp	\N	Морозов К.А.
4856	508	1	2026-01-16 12:05:32.918772	comments	\N	Срочно нужен проект
4857	509	1	2026-01-16 12:05:32.938053	entry_date	\N	2024-07-27
4858	509	1	2026-01-16 12:05:32.938666	current_manager	\N	Михайлова О.Н.
4859	509	1	2026-01-16 12:05:32.939095	it_block	\N	Диджитал
4860	509	1	2026-01-16 12:05:32.939476	ck_department	\N	ЦК Разработки
4861	509	1	2026-01-16 12:05:32.939845	placement_type	\N	перевод
4862	509	1	2026-01-16 12:05:32.940212	ready_for_vacancy	\N	Нет
4863	509	1	2026-01-16 12:05:32.940592	resume_link	\N	https://drive.google.com/file/75739
4864	509	1	2026-01-16 12:05:32.940953	manager_feedback	\N	Нужно развитие
4865	509	1	2026-01-16 12:05:32.941484	contacts	\N	+7 (988) 404-34-41, @орлнаде80, n.orlova@rt.ru
4866	509	1	2026-01-16 12:05:32.942048	funding_end_date	\N	2025-12-10
4867	509	1	2026-01-16 12:05:32.942557	candidate_status	\N	В работе
4868	509	1	2026-01-16 12:05:32.943183	target_projects	\N	ML Pipeline
4869	509	1	2026-01-16 12:05:32.943615	transfer_date	\N	
4870	509	1	2026-01-16 12:05:32.944011	recruiter	\N	Смирнова А.А.
4871	509	1	2026-01-16 12:05:32.944393	hr_bp	\N	Лебедева Т.М.
4872	509	1	2026-01-16 12:05:32.944771	comments	\N	Ожидает оффер
4873	510	1	2026-01-16 12:05:32.967729	entry_date	\N	2025-01-30
4874	510	1	2026-01-16 12:05:32.968479	current_manager	\N	Иванов А.П.
4875	510	1	2026-01-16 12:05:32.969142	it_block	\N	B2O
4876	510	1	2026-01-16 12:05:32.96996	ck_department	\N	Департамент данных
4877	510	1	2026-01-16 12:05:32.970701	placement_type	\N	аутстафф
4878	510	1	2026-01-16 12:05:32.971215	ready_for_vacancy	\N	Нет
4879	510	1	2026-01-16 12:05:32.971717	resume_link	\N	https://drive.google.com/file/79243
4880	510	1	2026-01-16 12:05:32.972189	manager_feedback	\N	Рекомендую
4881	510	1	2026-01-16 12:05:32.972675	contacts	\N	+7 (922) 981-84-32, @никнико96, n.nikolaev@rt.ru
4882	510	1	2026-01-16 12:05:32.973172	funding_end_date	\N	2026-05-12
4883	510	1	2026-01-16 12:05:32.973797	candidate_status	\N	Переведен
4884	510	1	2026-01-16 12:05:32.974452	target_projects	\N	ML Pipeline, Infrastructure
4885	510	1	2026-01-16 12:05:32.975272	transfer_date	\N	2026-07-10
4886	510	1	2026-01-16 12:05:32.976096	recruiter	\N	Белова И.Д.
4887	510	1	2026-01-16 12:05:32.976808	hr_bp	\N	Волкова Н.В.
4888	510	1	2026-01-16 12:05:32.977418	comments	\N	
4889	511	1	2026-01-16 12:05:32.998003	entry_date	\N	2025-04-10
4890	511	1	2026-01-16 12:05:32.998789	current_manager	\N	Сидорова Е.К.
4891	511	1	2026-01-16 12:05:32.999674	it_block	\N	B2O
4892	511	1	2026-01-16 12:05:33.000577	ck_department	\N	ЦК Разработки
4893	511	1	2026-01-16 12:05:33.001948	placement_type	\N	перевод
4894	511	1	2026-01-16 12:05:33.002502	ready_for_vacancy	\N	Нет
4895	511	1	2026-01-16 12:05:33.00359	resume_link	\N	https://drive.google.com/file/75293
4896	511	1	2026-01-16 12:05:33.004262	manager_feedback	\N	Отличные результаты
4897	511	1	2026-01-16 12:05:33.004755	contacts	\N	+7 (943) 828-99-68, @захекат32, e.zakharova@rt.ru
4898	511	1	2026-01-16 12:05:33.005262	funding_end_date	\N	2026-06-03
4899	511	1	2026-01-16 12:05:33.006145	candidate_status	\N	Забронирован
4900	511	1	2026-01-16 12:05:33.006998	target_projects	\N	Mobile App
4901	511	1	2026-01-16 12:05:33.00785	transfer_date	\N	
4902	511	1	2026-01-16 12:05:33.008521	recruiter	\N	Смирнова А.А.
4903	511	1	2026-01-16 12:05:33.009022	hr_bp	\N	Морозов К.А.
4904	511	1	2026-01-16 12:05:33.009755	comments	\N	
4905	512	1	2026-01-16 12:05:33.036969	entry_date	\N	2024-12-31
4906	512	1	2026-01-16 12:05:33.037837	current_manager	\N	Козлов Д.В.
4907	512	1	2026-01-16 12:05:33.038849	it_block	\N	НУК
4908	512	1	2026-01-16 12:05:33.039733	ck_department	\N	ЦК Разработки
4909	512	1	2026-01-16 12:05:33.040308	placement_type	\N	аутстафф
4910	512	1	2026-01-16 12:05:33.0407	ready_for_vacancy	\N	Да
4911	512	1	2026-01-16 12:05:33.041034	resume_link	\N	https://drive.google.com/file/76518
4912	512	1	2026-01-16 12:05:33.041643	manager_feedback	\N	Отличные результаты
4913	512	1	2026-01-16 12:05:33.04222	contacts	\N	+7 (907) 681-17-49, @никпаве63, p.nikolaev@rt.ru
4914	512	1	2026-01-16 12:05:33.042797	funding_end_date	\N	2025-07-15
4915	512	1	2026-01-16 12:05:33.0434	candidate_status	\N	Свободен
4916	512	1	2026-01-16 12:05:33.04385	target_projects	\N	E-commerce Platform, ML Pipeline
4917	512	1	2026-01-16 12:05:33.044472	transfer_date	\N	
4918	512	1	2026-01-16 12:05:33.044946	recruiter	\N	Орлов М.С.
4919	512	1	2026-01-16 12:05:33.04544	hr_bp	\N	Морозов К.А.
4920	512	1	2026-01-16 12:05:33.046055	comments	\N	В процессе согласования
4921	513	1	2026-01-16 12:05:33.069007	entry_date	\N	2024-06-09
4922	513	1	2026-01-16 12:05:33.069623	current_manager	\N	Михайлова О.Н.
4923	513	1	2026-01-16 12:05:33.070096	it_block	\N	B2O
4924	513	1	2026-01-16 12:05:33.070805	ck_department	\N	Департамент цифровых продуктов
4925	513	1	2026-01-16 12:05:33.07126	placement_type	\N	перевод
4926	513	1	2026-01-16 12:05:33.071622	ready_for_vacancy	\N	Да
4927	513	1	2026-01-16 12:05:33.071969	resume_link	\N	https://drive.google.com/file/40402
4928	513	1	2026-01-16 12:05:33.072283	manager_feedback	\N	Рекомендую
4929	513	1	2026-01-16 12:05:33.072591	contacts	\N	+7 (992) 922-73-88, @морольг90, o.morozova@rt.ru
4930	513	1	2026-01-16 12:05:33.072896	funding_end_date	\N	2026-07-29
4931	513	1	2026-01-16 12:05:33.0732	candidate_status	\N	Увольнение по СС
4932	513	1	2026-01-16 12:05:33.073719	target_projects	\N	ML Pipeline
4933	513	1	2026-01-16 12:05:33.074048	transfer_date	\N	2026-01-27
4934	513	1	2026-01-16 12:05:33.074353	recruiter	\N	Белова И.Д.
4935	513	1	2026-01-16 12:05:33.074655	hr_bp	\N	Волкова Н.В.
4936	513	1	2026-01-16 12:05:33.074954	comments	\N	В процессе согласования
4937	514	1	2026-01-16 12:05:33.093295	entry_date	\N	2024-12-07
4938	514	1	2026-01-16 12:05:33.09397	current_manager	\N	Михайлова О.Н.
4939	514	1	2026-01-16 12:05:33.094676	it_block	\N	Прочее
4940	514	1	2026-01-16 12:05:33.095311	ck_department	\N	ЦК Разработки
4941	514	1	2026-01-16 12:05:33.095952	placement_type	\N	аутстафф
4942	514	1	2026-01-16 12:05:33.096658	ready_for_vacancy	\N	Да
4943	514	1	2026-01-16 12:05:33.097057	resume_link	\N	https://drive.google.com/file/72576
4944	514	1	2026-01-16 12:05:33.097459	manager_feedback	\N	Рекомендую
4945	514	1	2026-01-16 12:05:33.097797	contacts	\N	+7 (924) 667-34-20, @васлюбо61, l.vasileva@rt.ru
4946	514	1	2026-01-16 12:05:33.0982	funding_end_date	\N	2026-01-22
4947	514	1	2026-01-16 12:05:33.098709	candidate_status	\N	Увольнение по СС
4948	514	1	2026-01-16 12:05:33.099408	target_projects	\N	Data Platform, E-commerce Platform, Mobile App
4949	514	1	2026-01-16 12:05:33.100094	transfer_date	\N	2025-04-14
4950	514	1	2026-01-16 12:05:33.100751	recruiter	\N	Белова И.Д.
4951	514	1	2026-01-16 12:05:33.101543	hr_bp	\N	Волкова Н.В.
4952	514	1	2026-01-16 12:05:33.102394	comments	\N	В процессе согласования
4953	515	1	2026-01-16 12:05:33.12653	entry_date	\N	2024-11-09
4954	515	1	2026-01-16 12:05:33.127564	current_manager	\N	Сидорова Е.К.
4955	515	1	2026-01-16 12:05:33.128132	it_block	\N	Эксплуатация
4956	515	1	2026-01-16 12:05:33.128561	ck_department	\N	Департамент данных
4957	515	1	2026-01-16 12:05:33.129042	placement_type	\N	перевод
4958	515	1	2026-01-16 12:05:33.129734	ready_for_vacancy	\N	Нет
4959	515	1	2026-01-16 12:05:33.130466	resume_link	\N	https://drive.google.com/file/97831
4960	515	1	2026-01-16 12:05:33.131229	manager_feedback	\N	Нужно развитие
4961	515	1	2026-01-16 12:05:33.132062	contacts	\N	+7 (908) 329-31-13, @стеанто79, a.stepanov@rt.ru
4962	515	1	2026-01-16 12:05:33.132898	funding_end_date	\N	2026-06-01
4963	515	1	2026-01-16 12:05:33.133598	candidate_status	\N	Увольнение по СС
4964	515	1	2026-01-16 12:05:33.134298	target_projects	\N	DevOps Platform, Banking App, Госуслуги 2.0
4965	515	1	2026-01-16 12:05:33.135161	transfer_date	\N	2025-11-02
4966	515	1	2026-01-16 12:05:33.135929	recruiter	\N	Смирнова А.А.
4967	515	1	2026-01-16 12:05:33.136585	hr_bp	\N	Лебедева Т.М.
4968	515	1	2026-01-16 12:05:33.137277	comments	\N	
4969	516	1	2026-01-16 12:05:33.155305	entry_date	\N	2024-06-13
4970	516	1	2026-01-16 12:05:33.155903	current_manager	\N	Козлов Д.В.
4971	516	1	2026-01-16 12:05:33.156366	it_block	\N	НУК
4972	516	1	2026-01-16 12:05:33.156861	ck_department	\N	ЦК Разработки
4973	516	1	2026-01-16 12:05:33.157524	placement_type	\N	любой
4974	516	1	2026-01-16 12:05:33.158079	ready_for_vacancy	\N	Да
4975	516	1	2026-01-16 12:05:33.158567	resume_link	\N	https://drive.google.com/file/35993
4976	516	1	2026-01-16 12:05:33.158927	manager_feedback	\N	Рекомендую
4977	516	1	2026-01-16 12:05:33.15932	contacts	\N	+7 (968) 351-11-63, @сокюрий35, yu.sokolov@rt.ru
4978	516	1	2026-01-16 12:05:33.159731	funding_end_date	\N	2026-04-22
4979	516	1	2026-01-16 12:05:33.160054	candidate_status	\N	В работе
4980	516	1	2026-01-16 12:05:33.160503	target_projects	\N	DevOps Platform, Госуслуги 2.0
4981	516	1	2026-01-16 12:05:33.161144	transfer_date	\N	
4982	516	1	2026-01-16 12:05:33.161689	recruiter	\N	Белова И.Д.
4983	516	1	2026-01-16 12:05:33.162178	hr_bp	\N	Лебедева Т.М.
4984	516	1	2026-01-16 12:05:33.162635	comments	\N	Срочно нужен проект
4985	517	1	2026-01-16 12:05:33.186314	entry_date	\N	2025-05-25
4986	517	1	2026-01-16 12:05:33.187052	current_manager	\N	Михайлова О.Н.
4987	517	1	2026-01-16 12:05:33.187537	it_block	\N	НУК
4988	517	1	2026-01-16 12:05:33.188024	ck_department	\N	Департамент цифровых продуктов
4989	517	1	2026-01-16 12:05:33.188551	placement_type	\N	перевод
4990	517	1	2026-01-16 12:05:33.1891	ready_for_vacancy	\N	Да
4991	517	1	2026-01-16 12:05:33.189705	resume_link	\N	https://drive.google.com/file/75245
4992	517	1	2026-01-16 12:05:33.190221	manager_feedback	\N	Отличные результаты
4993	517	1	2026-01-16 12:05:33.190591	contacts	\N	+7 (988) 823-43-59, @солматв51, m.solovev@rt.ru
4994	517	1	2026-01-16 12:05:33.190994	funding_end_date	\N	2025-01-04
4995	517	1	2026-01-16 12:05:33.191338	candidate_status	\N	Забронирован
4996	517	1	2026-01-16 12:05:33.191815	target_projects	\N	Infrastructure
4997	517	1	2026-01-16 12:05:33.192179	transfer_date	\N	
4998	517	1	2026-01-16 12:05:33.192585	recruiter	\N	Новикова Е.П.
4999	517	1	2026-01-16 12:05:33.192972	hr_bp	\N	Волкова Н.В.
5000	517	1	2026-01-16 12:05:33.193294	comments	\N	
5001	518	1	2026-01-16 12:05:33.22051	entry_date	\N	2025-09-22
5002	518	1	2026-01-16 12:05:33.221125	current_manager	\N	Иванов А.П.
5003	518	1	2026-01-16 12:05:33.221697	it_block	\N	B2O
5004	518	1	2026-01-16 12:05:33.222452	ck_department	\N	Департамент данных
5005	518	1	2026-01-16 12:05:33.222993	placement_type	\N	перевод
5006	518	1	2026-01-16 12:05:33.223362	ready_for_vacancy	\N	Нет
5007	518	1	2026-01-16 12:05:33.224	resume_link	\N	https://drive.google.com/file/78074
5008	518	1	2026-01-16 12:05:33.224661	manager_feedback	\N	
5009	518	1	2026-01-16 12:05:33.225154	contacts	\N	+7 (922) 558-44-78, @никольг99, o.nikitina@rt.ru
5010	518	1	2026-01-16 12:05:33.225632	funding_end_date	\N	2025-03-15
5011	518	1	2026-01-16 12:05:33.226113	candidate_status	\N	Увольнение по СЖ
5012	518	1	2026-01-16 12:05:33.226549	target_projects	\N	Госуслуги 2.0, ML Pipeline
5013	518	1	2026-01-16 12:05:33.226892	transfer_date	\N	2026-11-19
5014	518	1	2026-01-16 12:05:33.22726	recruiter	\N	Новикова Е.П.
5015	518	1	2026-01-16 12:05:33.22758	hr_bp	\N	Волкова Н.В.
5016	518	1	2026-01-16 12:05:33.227958	comments	\N	Ожидает оффер
5017	20	1	2026-01-16 12:05:33.249321	comments	В процессе согласования	
5018	20	1	2026-01-16 12:05:33.250067	contacts	+7 (958) 659-56-44, @яконики80, nikita.yakovlev4@company.ru	+7 (936) 561-24-94, @яконики43, nikita.yakovlev4@company.ru
5019	20	1	2026-01-16 12:05:33.250888	recruiter	Смирнова А.А.	Орлов М.С.
5020	20	1	2026-01-16 12:05:33.251387	entry_date	2024-09-18	2024-12-27
5021	20	1	2026-01-16 12:05:33.251929	resume_link	https://drive.google.com/file/62035	https://drive.google.com/file/14339
5022	20	1	2026-01-16 12:05:33.252302	ck_department	Департамент данных	Департамент цифровых продуктов
5023	20	1	2026-01-16 12:05:33.252643	placement_type	перевод	аутстафф
5024	20	1	2026-01-16 12:05:33.253105	target_projects	DevOps Platform, Infrastructure, E-commerce Platform	Госуслуги 2.0, E-commerce Platform, Banking App
5025	20	1	2026-01-16 12:05:33.2537	funding_end_date	2026-01-20	2025-03-15
5026	10	1	2026-01-16 12:05:33.273294	contacts	+7 (949) 245-24-35, @никартё80, nikolaev@company.ru	+7 (980) 229-45-16, @никартё41, nikolaev@company.ru
5027	10	1	2026-01-16 12:05:33.273965	it_block	B2O	Развитие
5028	10	1	2026-01-16 12:05:33.274651	entry_date	2024-11-29	2025-09-16
5029	10	1	2026-01-16 12:05:33.275239	resume_link	https://drive.google.com/file/27666	https://drive.google.com/file/79634
5030	10	1	2026-01-16 12:05:33.275633	transfer_date	2025-02-15	
5031	10	1	2026-01-16 12:05:33.275952	placement_type	любой	аутстафф
5032	10	1	2026-01-16 12:05:33.276692	current_manager	Петров С.М.	Козлов Д.В.
5033	10	1	2026-01-16 12:05:33.277353	target_projects	DevOps Platform, Infrastructure, Госуслуги 2.0	Banking App, Госуслуги 2.0, ML Pipeline
5034	10	1	2026-01-16 12:05:33.278046	candidate_status	Увольнение по СЖ	Забронирован
5035	10	1	2026-01-16 12:05:33.278688	funding_end_date	2025-06-25	2026-04-23
5036	10	1	2026-01-16 12:05:33.279222	manager_feedback	Отличные результаты	Хороший специалист
5037	12	1	2026-01-16 12:05:33.298704	comments	Срочно нужен проект	Ожидает оффер
5038	12	1	2026-01-16 12:05:33.299516	contacts	+7 (920) 847-86-32, @мормакс39, morozov@company.ru	+7 (942) 782-56-36, @мормакс36, morozov@company.ru
5039	12	1	2026-01-16 12:05:33.299931	it_block	Диджитал	B2O
5040	12	1	2026-01-16 12:05:33.300254	recruiter	Белова И.Д.	Новикова Е.П.
5041	12	1	2026-01-16 12:05:33.300784	entry_date	2025-10-31	2025-06-19
5042	12	1	2026-01-16 12:05:33.301162	resume_link	https://drive.google.com/file/84629	https://drive.google.com/file/34437
5043	12	1	2026-01-16 12:05:33.301724	ck_department	Департамент цифровых продуктов	ЦК Аналитики
5044	12	1	2026-01-16 12:05:33.302086	transfer_date		2026-05-01
5045	12	1	2026-01-16 12:05:33.302413	placement_type	перевод	любой
5046	12	1	2026-01-16 12:05:33.302706	current_manager	Михайлова О.Н.	Иванов А.П.
5047	12	1	2026-01-16 12:05:33.302999	target_projects	Mobile App, Infrastructure, E-commerce Platform	ML Pipeline, Data Platform
5048	12	1	2026-01-16 12:05:33.303288	candidate_status	В работе	Увольнение по СС
5049	12	1	2026-01-16 12:05:33.303571	funding_end_date	2026-10-25	2026-12-13
5050	12	1	2026-01-16 12:05:33.303851	manager_feedback	Хороший специалист	
5051	128	1	2026-01-16 12:05:33.322488	contacts	+7 (987) 253-11-67, @новрома14, mark.fedorov112@company.ru	+7 (900) 797-80-83, @новрома52, mark.fedorov112@company.ru
5052	128	1	2026-01-16 12:05:33.323282	it_block	Диджитал	Эксплуатация
5053	128	1	2026-01-16 12:05:33.323979	recruiter	Орлов М.С.	Новикова Е.П.
5054	128	1	2026-01-16 12:05:33.324468	entry_date	2025-09-24	2025-10-14
5055	128	1	2026-01-16 12:05:33.324926	resume_link	https://drive.google.com/file/51048	https://drive.google.com/file/19262
5056	128	1	2026-01-16 12:05:33.325455	ck_department	Департамент цифровых продуктов	ЦК Инфраструктуры
5057	128	1	2026-01-16 12:05:33.325887	transfer_date	2025-07-19	2025-12-12
5058	128	1	2026-01-16 12:05:33.326196	placement_type	аутстафф	перевод
5059	128	1	2026-01-16 12:05:33.326484	current_manager	Петров С.М.	Иванов А.П.
5060	128	1	2026-01-16 12:05:33.326766	target_projects	Infrastructure, Mobile App	Mobile App, Banking App, E-commerce Platform
5061	128	1	2026-01-16 12:05:33.327045	candidate_status	Переведен	Увольнение по СС
5062	128	1	2026-01-16 12:05:33.327323	funding_end_date	2026-11-07	2026-08-06
5063	128	1	2026-01-16 12:05:33.327718	manager_feedback	Нужно развитие	Хороший специалист
5064	128	1	2026-01-16 12:05:33.328168	ready_for_vacancy	Нет	Да
5065	217	1	2026-01-16 12:05:33.356271	hr_bp	Морозов К.А.	Волкова Н.В.
5066	217	1	2026-01-16 12:05:33.357035	comments	Срочно нужен проект	
5067	217	1	2026-01-16 12:05:33.357586	contacts	+7 (927) 603-67-97, @михандр65, valid@test.ru	+7 (941) 159-94-68, @михандр98, valid@test.ru
5068	217	1	2026-01-16 12:05:33.358149	it_block	B2O	НУК
5069	217	1	2026-01-16 12:05:33.358514	recruiter	Новикова Е.П.	Белова И.Д.
5070	217	1	2026-01-16 12:05:33.358828	entry_date	2025-06-25	2024-05-26
5071	217	1	2026-01-16 12:05:33.359303	resume_link	https://drive.google.com/file/23287	https://drive.google.com/file/43647
5072	217	1	2026-01-16 12:05:33.359648	ck_department	ЦК Разработки	ЦК Инфраструктуры
5073	217	1	2026-01-16 12:05:33.360053	current_manager	Иванов А.П.	Козлов Д.В.
5074	217	1	2026-01-16 12:05:33.360363	target_projects	Banking App, Data Platform, ML Pipeline	DevOps Platform
5075	217	1	2026-01-16 12:05:33.360692	candidate_status	Свободен	Забронирован
5076	217	1	2026-01-16 12:05:33.360987	funding_end_date	2026-12-13	2026-10-16
5077	8	1	2026-01-16 12:05:33.378212	contacts	+7 (968) 589-75-15, @сиддмит17, sidorov@company.ru	+7 (972) 399-59-72, @сиддмит81, sidorov@company.ru
5078	8	1	2026-01-16 12:05:33.378777	it_block	B2O	Диджитал
5079	8	1	2026-01-16 12:05:33.379115	recruiter	Смирнова А.А.	Белова И.Д.
5080	8	1	2026-01-16 12:05:33.379406	entry_date	2024-02-14	2025-02-26
5081	8	1	2026-01-16 12:05:33.379683	resume_link	https://drive.google.com/file/48728	https://drive.google.com/file/98658
5082	8	1	2026-01-16 12:05:33.380046	ck_department	Департамент данных	Департамент цифровых продуктов
5083	8	1	2026-01-16 12:05:33.380398	current_manager	Сидорова Е.К.	Иванов А.П.
5084	8	1	2026-01-16 12:05:33.380693	target_projects	Data Platform	Госуслуги 2.0
5085	8	1	2026-01-16 12:05:33.380968	funding_end_date	2025-03-09	2025-02-23
5086	8	1	2026-01-16 12:05:33.38127	manager_feedback	Отличные результаты	
5087	11	1	2026-01-16 12:05:33.40064	hr_bp	Морозов К.А.	Лебедева Т.М.
5088	11	1	2026-01-16 12:05:33.401099	contacts	+7 (980) 626-36-58, @феделен70, fedorova@company.ru	+7 (917) 905-48-80, @феделен67, fedorova@company.ru
5089	11	1	2026-01-16 12:05:33.401586	it_block	НУК	Эксплуатация
5090	11	1	2026-01-16 12:05:33.402112	entry_date	2025-10-18	2025-08-11
5091	11	1	2026-01-16 12:05:33.402479	resume_link	https://drive.google.com/file/70756	https://drive.google.com/file/10121
5092	11	1	2026-01-16 12:05:33.402784	ck_department	ЦК Разработки	ЦК Аналитики
5093	11	1	2026-01-16 12:05:33.40308	transfer_date		2025-09-17
5094	11	1	2026-01-16 12:05:33.403364	current_manager	Иванов А.П.	Петров С.М.
5095	11	1	2026-01-16 12:05:33.403648	target_projects	E-commerce Platform, Data Platform	Data Platform
5096	11	1	2026-01-16 12:05:33.404005	candidate_status	Забронирован	Увольнение по СС
5097	11	1	2026-01-16 12:05:33.404527	funding_end_date	2026-08-15	2026-11-20
5098	11	1	2026-01-16 12:05:33.404989	manager_feedback	Нужно развитие	
5099	11	1	2026-01-16 12:05:33.40555	ready_for_vacancy	Да	Нет
5100	395	1	2026-01-16 12:05:33.424147	contacts	+7 (964) 105-74-67, @меданто49, a.medvedev@rt.ru	+7 (945) 807-32-90, @меданто81, a.medvedev@rt.ru
5101	395	1	2026-01-16 12:05:33.424608	it_block	Эксплуатация	Диджитал
5102	395	1	2026-01-16 12:05:33.424943	recruiter	Новикова Е.П.	Смирнова А.А.
5103	395	1	2026-01-16 12:05:33.425294	entry_date	2025-02-13	2024-03-23
5104	395	1	2026-01-16 12:05:33.425933	resume_link	https://drive.google.com/file/24475	https://drive.google.com/file/11873
5105	395	1	2026-01-16 12:05:33.42634	transfer_date	2025-05-24	2025-11-05
5106	395	1	2026-01-16 12:05:33.426652	placement_type	перевод	аутстафф
5107	395	1	2026-01-16 12:05:33.426944	current_manager	Михайлова О.Н.	Сидорова Е.К.
5108	395	1	2026-01-16 12:05:33.427228	target_projects	Mobile App, E-commerce Platform	ML Pipeline
5109	395	1	2026-01-16 12:05:33.427508	candidate_status	Переведен	Увольнение по СЖ
5110	395	1	2026-01-16 12:05:33.427867	funding_end_date	2025-08-28	2025-01-03
5111	395	1	2026-01-16 12:05:33.428544	manager_feedback	Отличные результаты	Нужно развитие
5112	396	1	2026-01-16 12:05:33.445525	hr_bp	Волкова Н.В.	Лебедева Т.М.
5113	396	1	2026-01-16 12:05:33.446005	comments	Ожидает оффер	
5114	396	1	2026-01-16 12:05:33.446341	contacts	+7 (970) 341-61-23, @новевге84, e.novikov@rt.ru	+7 (953) 252-32-68, @новевге29, e.novikov@rt.ru
5115	396	1	2026-01-16 12:05:33.446647	it_block	B2O	НУК
5116	396	1	2026-01-16 12:05:33.447007	recruiter	Белова И.Д.	Смирнова А.А.
5117	396	1	2026-01-16 12:05:33.447304	entry_date	2025-05-05	2024-12-19
5118	396	1	2026-01-16 12:05:33.447593	resume_link	https://drive.google.com/file/53618	https://drive.google.com/file/90566
5119	396	1	2026-01-16 12:05:33.447877	ck_department	ЦК Инфраструктуры	ЦК Разработки
5120	396	1	2026-01-16 12:05:33.448162	current_manager	Иванов А.П.	Сидорова Е.К.
5121	396	1	2026-01-16 12:05:33.448443	target_projects	Banking App, E-commerce Platform	ML Pipeline, E-commerce Platform
5122	396	1	2026-01-16 12:05:33.448726	candidate_status	В работе	Забронирован
5123	396	1	2026-01-16 12:05:33.449008	funding_end_date	2025-07-15	2026-12-25
5124	218	1	2026-01-16 12:05:33.468191	comments	Срочно нужен проект	
5125	218	1	2026-01-16 12:05:33.468787	contacts	+7 (916) 423-48-78, @тестест96, testov@test.ru	+7 (968) 417-95-35, @тестест34, testov@test.ru
5126	218	1	2026-01-16 12:05:33.469184	recruiter	Белова И.Д.	Новикова Е.П.
5127	218	1	2026-01-16 12:05:33.469588	entry_date	2024-05-18	2025-06-11
5128	218	1	2026-01-16 12:05:33.470043	resume_link	https://drive.google.com/file/21803	https://drive.google.com/file/18744
5129	218	1	2026-01-16 12:05:33.470544	ck_department	ЦК Разработки	ЦК Инфраструктуры
5130	218	1	2026-01-16 12:05:33.470955	placement_type	аутстафф	перевод
5131	218	1	2026-01-16 12:05:33.471278	current_manager	Иванов А.П.	Сидорова Е.К.
5132	218	1	2026-01-16 12:05:33.471577	target_projects	ML Pipeline, Infrastructure	ML Pipeline
5133	218	1	2026-01-16 12:05:33.471959	candidate_status	Свободен	В работе
5134	218	1	2026-01-16 12:05:33.472346	funding_end_date	2026-11-18	2026-04-28
5135	218	1	2026-01-16 12:05:33.472667	manager_feedback	Хороший специалист	Нужно развитие
5136	219	1	2026-01-16 12:05:33.493362	hr_bp	Волкова Н.В.	Лебедева Т.М.
5137	219	1	2026-01-16 12:05:33.494288	comments	Срочно нужен проект	Ожидает оффер
5138	219	1	2026-01-16 12:05:33.494793	contacts	+7 (960) 613-96-79, @лебилья29, i.lebedev@rt.ru	+7 (919) 731-65-29, @лебилья31, i.lebedev@rt.ru
5139	219	1	2026-01-16 12:05:33.495202	it_block	B2O	Эксплуатация
5140	219	1	2026-01-16 12:05:33.495584	recruiter	Новикова Е.П.	Орлов М.С.
5141	219	1	2026-01-16 12:05:33.495957	entry_date	2025-05-26	2024-01-01
5142	219	1	2026-01-16 12:05:33.496333	resume_link	https://drive.google.com/file/71209	https://drive.google.com/file/84820
5143	219	1	2026-01-16 12:05:33.496785	ck_department	Департамент цифровых продуктов	Департамент данных
5144	219	1	2026-01-16 12:05:33.497168	current_manager	Иванов А.П.	Михайлова О.Н.
5145	219	1	2026-01-16 12:05:33.497849	target_projects	Data Platform, Mobile App	Госуслуги 2.0, Mobile App, E-commerce Platform
5146	219	1	2026-01-16 12:05:33.49825	candidate_status	Свободен	Забронирован
5147	219	1	2026-01-16 12:05:33.499189	funding_end_date	2025-01-20	2025-08-28
5148	219	1	2026-01-16 12:05:33.499627	manager_feedback	Рекомендую	Отличные результаты
5149	220	1	2026-01-16 12:05:33.534678	hr_bp	Морозов К.А.	Волкова Н.В.
5150	220	1	2026-01-16 12:05:33.535916	comments	Срочно нужен проект	
5151	220	1	2026-01-16 12:05:33.536712	contacts	+7 (955) 693-68-44, @гусвади75, v.gusev@rt.ru	+7 (931) 175-18-60, @гусвади26, v.gusev@rt.ru
5152	220	1	2026-01-16 12:05:33.537483	it_block	Эксплуатация	Прочее
5153	220	1	2026-01-16 12:05:33.538291	recruiter	Смирнова А.А.	Белова И.Д.
5154	220	1	2026-01-16 12:05:33.53888	entry_date	2024-08-09	2024-10-01
5155	220	1	2026-01-16 12:05:33.539419	resume_link	https://drive.google.com/file/12944	https://drive.google.com/file/95287
5156	220	1	2026-01-16 12:05:33.539914	transfer_date		2025-01-30
5157	220	1	2026-01-16 12:05:33.540398	current_manager	Сидорова Е.К.	Петров С.М.
5158	220	1	2026-01-16 12:05:33.540883	target_projects	Banking App, Infrastructure	Data Platform, Mobile App, Banking App
5159	220	1	2026-01-16 12:05:33.541433	candidate_status	Забронирован	Увольнение по СС
5160	220	1	2026-01-16 12:05:33.541938	funding_end_date	2026-09-22	2025-07-07
5161	221	1	2026-01-16 12:05:33.577585	hr_bp	Волкова Н.В.	Морозов К.А.
5162	221	1	2026-01-16 12:05:33.57821	contacts	+7 (945) 894-87-74, @гусксен4, k.guseva@rt.ru	+7 (971) 222-85-14, @гусксен25, k.guseva@rt.ru
5163	221	1	2026-01-16 12:05:33.578652	it_block	Диджитал	НУК
5164	221	1	2026-01-16 12:05:33.579067	entry_date	2025-06-22	2024-12-05
5165	221	1	2026-01-16 12:05:33.57981	resume_link	https://drive.google.com/file/48413	https://drive.google.com/file/80668
5166	221	1	2026-01-16 12:05:33.580175	ck_department	ЦК Разработки	ЦК Инфраструктуры
5167	221	1	2026-01-16 12:05:33.580745	transfer_date	2025-09-29	
5168	221	1	2026-01-16 12:05:33.581294	current_manager	Петров С.М.	Козлов Д.В.
5169	221	1	2026-01-16 12:05:33.581939	target_projects	E-commerce Platform	DevOps Platform
5170	221	1	2026-01-16 12:05:33.582431	candidate_status	Увольнение по СС	Свободен
5171	221	1	2026-01-16 12:05:33.582871	funding_end_date	2025-03-13	2026-02-14
5172	221	1	2026-01-16 12:05:33.583304	manager_feedback	Нужно развитие	
5173	223	1	2026-01-16 12:05:33.621363	hr_bp	Лебедева Т.М.	Волкова Н.В.
5174	223	1	2026-01-16 12:05:33.62221	contacts	+7 (940) 556-72-30, @гривале63, v.grigoreva@rt.ru	+7 (918) 498-93-50, @гривале87, v.grigoreva@rt.ru
5175	223	1	2026-01-16 12:05:33.622923	it_block	Диджитал	Развитие
5176	223	1	2026-01-16 12:05:33.623571	recruiter	Орлов М.С.	Белова И.Д.
5177	223	1	2026-01-16 12:05:33.624328	entry_date	2024-03-14	2024-10-25
5178	223	1	2026-01-16 12:05:33.624963	resume_link	https://drive.google.com/file/37540	https://drive.google.com/file/82397
5179	223	1	2026-01-16 12:05:33.625478	ck_department	ЦК Инфраструктуры	Департамент цифровых продуктов
5180	223	1	2026-01-16 12:05:33.625976	placement_type	аутстафф	перевод
5181	223	1	2026-01-16 12:05:33.626436	current_manager	Козлов Д.В.	Петров С.М.
5182	223	1	2026-01-16 12:05:33.626886	target_projects	Mobile App, E-commerce Platform	Data Platform
5183	223	1	2026-01-16 12:05:33.627337	candidate_status	В работе	Свободен
5184	223	1	2026-01-16 12:05:33.627791	funding_end_date	2026-05-14	2026-04-10
5185	224	1	2026-01-16 12:05:33.648204	contacts	+7 (934) 858-33-47, @никвади24, v.nikolaev@rt.ru	+7 (978) 679-10-77, @никвади85, v.nikolaev@rt.ru
5186	224	1	2026-01-16 12:05:33.648669	it_block	Эксплуатация	Развитие
5187	224	1	2026-01-16 12:05:33.649002	recruiter	Смирнова А.А.	Белова И.Д.
5188	224	1	2026-01-16 12:05:33.649587	entry_date	2025-10-17	2024-12-19
5189	224	1	2026-01-16 12:05:33.650162	resume_link	https://drive.google.com/file/57519	https://drive.google.com/file/52286
5190	224	1	2026-01-16 12:05:33.650624	ck_department	Департамент цифровых продуктов	ЦК Разработки
5191	224	1	2026-01-16 12:05:33.650958	transfer_date		2026-08-19
5192	224	1	2026-01-16 12:05:33.6515	placement_type	перевод	аутстафф
5193	224	1	2026-01-16 12:05:33.652153	current_manager	Козлов Д.В.	Сидорова Е.К.
5194	224	1	2026-01-16 12:05:33.65258	target_projects	ML Pipeline, Mobile App	ML Pipeline, Data Platform
5195	224	1	2026-01-16 12:05:33.652903	candidate_status	В работе	Увольнение по СЖ
5196	224	1	2026-01-16 12:05:33.653191	funding_end_date	2025-02-23	2025-02-26
5197	224	1	2026-01-16 12:05:33.653627	ready_for_vacancy	Да	Нет
5198	226	1	2026-01-16 12:05:33.672138	comments		Срочно нужен проект
5199	226	1	2026-01-16 12:05:33.672609	contacts	+7 (908) 734-55-54, @стестеп75, s.stepanov@rt.ru	+7 (913) 993-73-93, @стестеп56, s.stepanov@rt.ru
5200	226	1	2026-01-16 12:05:33.673061	it_block	B2O	Эксплуатация
5201	226	1	2026-01-16 12:05:33.673471	recruiter	Смирнова А.А.	Орлов М.С.
5202	226	1	2026-01-16 12:05:33.673852	entry_date	2024-03-23	2024-07-02
5203	226	1	2026-01-16 12:05:33.674148	resume_link	https://drive.google.com/file/94369	https://drive.google.com/file/39396
5204	226	1	2026-01-16 12:05:33.674432	ck_department	ЦК Аналитики	ЦК Разработки
5205	226	1	2026-01-16 12:05:33.674706	transfer_date	2025-04-18	
5206	226	1	2026-01-16 12:05:33.674976	current_manager	Михайлова О.Н.	Сидорова Е.К.
5207	226	1	2026-01-16 12:05:33.675245	target_projects	ML Pipeline, Data Platform	Mobile App, DevOps Platform
5208	226	1	2026-01-16 12:05:33.675646	candidate_status	Увольнение по СЖ	Забронирован
5209	226	1	2026-01-16 12:05:33.67594	funding_end_date	2025-11-12	2025-02-28
5210	226	1	2026-01-16 12:05:33.676217	manager_feedback	Хороший специалист	Отличные результаты
5211	227	1	2026-01-16 12:05:33.695781	comments	Ожидает оффер	
5212	227	1	2026-01-16 12:05:33.696354	contacts	+7 (900) 591-96-17, @фрокири5, k.frolov@rt.ru	+7 (957) 760-61-91, @фрокири3, k.frolov@rt.ru
5213	227	1	2026-01-16 12:05:33.69709	it_block	Развитие	B2O
5214	227	1	2026-01-16 12:05:33.697689	recruiter	Новикова Е.П.	Смирнова А.А.
5215	227	1	2026-01-16 12:05:33.698218	entry_date	2025-04-29	2025-12-20
5216	227	1	2026-01-16 12:05:33.698832	resume_link	https://drive.google.com/file/72260	https://drive.google.com/file/52972
5217	227	1	2026-01-16 12:05:33.699481	transfer_date	2025-03-02	2026-01-07
5218	227	1	2026-01-16 12:05:33.700081	placement_type	аутстафф	перевод
5219	227	1	2026-01-16 12:05:33.700854	current_manager	Михайлова О.Н.	Сидорова Е.К.
5220	227	1	2026-01-16 12:05:33.702337	target_projects	Banking App, Mobile App	Data Platform, ML Pipeline
5221	227	1	2026-01-16 12:05:33.703298	candidate_status	Увольнение по СЖ	Переведен
5222	227	1	2026-01-16 12:05:33.704033	funding_end_date	2026-07-02	2025-02-13
5223	227	1	2026-01-16 12:05:33.704679	manager_feedback		Рекомендую
5224	227	1	2026-01-16 12:05:33.705316	ready_for_vacancy	Нет	Да
5225	229	1	2026-01-16 12:05:33.725317	hr_bp	Морозов К.А.	Лебедева Т.М.
5226	229	1	2026-01-16 12:05:33.725849	comments		Ожидает оффер
5227	229	1	2026-01-16 12:05:33.726215	contacts	+7 (927) 779-40-89, @смивади75, v.smirnov@rt.ru	+7 (955) 461-57-26, @смивади39, v.smirnov@rt.ru
5228	229	1	2026-01-16 12:05:33.726524	it_block	Эксплуатация	Развитие
5229	229	1	2026-01-16 12:05:33.726823	recruiter	Новикова Е.П.	Смирнова А.А.
5230	229	1	2026-01-16 12:05:33.727368	entry_date	2024-12-30	2025-03-14
5231	229	1	2026-01-16 12:05:33.727868	resume_link	https://drive.google.com/file/17346	https://drive.google.com/file/11562
5232	229	1	2026-01-16 12:05:33.728284	ck_department	ЦК Разработки	Департамент цифровых продуктов
5233	229	1	2026-01-16 12:05:33.728769	placement_type	перевод	любой
5234	229	1	2026-01-16 12:05:33.729088	current_manager	Петров С.М.	Сидорова Е.К.
5235	229	1	2026-01-16 12:05:33.729491	target_projects	DevOps Platform, Infrastructure, Banking App	Infrastructure, Data Platform, Госуслуги 2.0
5236	229	1	2026-01-16 12:05:33.729865	funding_end_date	2026-01-29	2026-03-17
5237	229	1	2026-01-16 12:05:33.730169	manager_feedback		Хороший специалист
5238	19	1	2026-01-16 12:05:33.747115	contacts	+7 (969) 883-79-27, @васиван79, nikolay.romanov3@company.ru	+7 (970) 148-41-65, @васиван57, nikolay.romanov3@company.ru
5239	19	1	2026-01-16 12:05:33.747593	it_block	НУК	Развитие
5240	19	1	2026-01-16 12:05:33.747935	recruiter	Новикова Е.П.	Орлов М.С.
5241	19	1	2026-01-16 12:05:33.748241	entry_date	2024-07-25	2025-03-17
5242	19	1	2026-01-16 12:05:33.748537	resume_link	https://drive.google.com/file/85068	https://drive.google.com/file/54113
5243	19	1	2026-01-16 12:05:33.748825	ck_department	ЦК Аналитики	Департамент цифровых продуктов
5244	19	1	2026-01-16 12:05:33.749114	current_manager	Михайлова О.Н.	Сидорова Е.К.
5245	19	1	2026-01-16 12:05:33.749479	target_projects	DevOps Platform	Infrastructure, Data Platform, Banking App
5246	19	1	2026-01-16 12:05:33.749857	funding_end_date	2025-08-28	2025-03-06
5247	19	1	2026-01-16 12:05:33.750456	manager_feedback	Нужно развитие	
5248	22	1	2026-01-16 12:05:33.775701	hr_bp	Лебедева Т.М.	Морозов К.А.
5249	22	1	2026-01-16 12:05:33.776202	comments	Ожидает оффер	
5250	22	1	2026-01-16 12:05:33.776566	contacts	+7 (950) 554-65-81, @михандр69, maxim.grigoriev6@company.ru	+7 (973) 205-38-28, @михандр60, maxim.grigoriev6@company.ru
5251	22	1	2026-01-16 12:05:33.776899	recruiter	Белова И.Д.	Орлов М.С.
5252	22	1	2026-01-16 12:05:33.777218	entry_date	2025-10-06	2025-01-09
5253	22	1	2026-01-16 12:05:33.777782	resume_link	https://drive.google.com/file/49944	https://drive.google.com/file/89724
5254	22	1	2026-01-16 12:05:33.778384	ck_department	Департамент цифровых продуктов	Департамент данных
5255	22	1	2026-01-16 12:05:33.779108	placement_type	любой	перевод
5256	22	1	2026-01-16 12:05:33.779902	current_manager	Михайлова О.Н.	Сидорова Е.К.
5257	22	1	2026-01-16 12:05:33.780443	target_projects	Data Platform	Banking App
5258	22	1	2026-01-16 12:05:33.781288	candidate_status	Свободен	Забронирован
5259	22	1	2026-01-16 12:05:33.781726	funding_end_date	2025-06-23	2026-08-06
5260	22	1	2026-01-16 12:05:33.782095	manager_feedback		Рекомендую
5261	230	1	2026-01-16 12:05:33.814612	hr_bp	Волкова Н.В.	Лебедева Т.М.
5262	230	1	2026-01-16 12:05:33.815385	contacts	+7 (951) 167-32-74, @вордани38, d.vorobev@rt.ru	+7 (931) 380-95-29, @вордани18, d.vorobev@rt.ru
5263	230	1	2026-01-16 12:05:33.815922	recruiter	Орлов М.С.	Смирнова А.А.
5264	230	1	2026-01-16 12:05:33.816398	entry_date	2024-06-06	2024-03-27
5265	230	1	2026-01-16 12:05:33.816874	resume_link	https://drive.google.com/file/65001	https://drive.google.com/file/28944
5266	230	1	2026-01-16 12:05:33.81745	ck_department	ЦК Инфраструктуры	ЦК Разработки
5267	230	1	2026-01-16 12:05:33.818092	transfer_date	2026-06-26	2025-11-14
5268	230	1	2026-01-16 12:05:33.819098	current_manager	Козлов Д.В.	Петров С.М.
5269	230	1	2026-01-16 12:05:33.819965	target_projects	Banking App, Госуслуги 2.0, Data Platform	Infrastructure, Data Platform
5270	230	1	2026-01-16 12:05:33.820829	candidate_status	Увольнение по СЖ	Увольнение по СС
5271	230	1	2026-01-16 12:05:33.821947	funding_end_date	2026-02-26	2026-03-02
5272	230	1	2026-01-16 12:05:33.822713	manager_feedback	Отличные результаты	Рекомендую
5273	230	1	2026-01-16 12:05:33.823254	ready_for_vacancy	Нет	Да
5274	232	1	2026-01-16 12:05:33.854702	hr_bp	Морозов К.А.	Волкова Н.В.
5275	232	1	2026-01-16 12:05:33.855906	comments	В процессе согласования	
5276	232	1	2026-01-16 12:05:33.85699	contacts	+7 (956) 489-38-70, @ивадмит9, d.ivanov@rt.ru	+7 (986) 266-97-13, @ивадмит77, d.ivanov@rt.ru
5277	232	1	2026-01-16 12:05:33.858258	entry_date	2024-08-29	2024-02-12
5278	232	1	2026-01-16 12:05:33.859377	resume_link	https://drive.google.com/file/42912	https://drive.google.com/file/90826
5279	232	1	2026-01-16 12:05:33.860159	ck_department	Департамент цифровых продуктов	ЦК Аналитики
5280	232	1	2026-01-16 12:05:33.860764	placement_type	любой	перевод
5281	232	1	2026-01-16 12:05:33.861372	current_manager	Михайлова О.Н.	Петров С.М.
5282	232	1	2026-01-16 12:05:33.862411	target_projects	Infrastructure, Data Platform	Data Platform, ML Pipeline
5283	232	1	2026-01-16 12:05:33.863407	funding_end_date	2025-09-15	2025-05-24
5284	232	1	2026-01-16 12:05:33.863981	ready_for_vacancy	Да	Нет
5285	233	1	2026-01-16 12:05:33.892685	hr_bp	Волкова Н.В.	Лебедева Т.М.
5286	233	1	2026-01-16 12:05:33.893667	comments	Ожидает оффер	В процессе согласования
5287	233	1	2026-01-16 12:05:33.894306	contacts	+7 (913) 457-12-51, @гриалек42, a.grigorev@rt.ru	+7 (939) 983-32-22, @гриалек30, a.grigorev@rt.ru
5288	233	1	2026-01-16 12:05:33.894844	it_block	НУК	Прочее
5289	233	1	2026-01-16 12:05:33.895617	recruiter	Смирнова А.А.	Новикова Е.П.
5290	233	1	2026-01-16 12:05:33.896108	entry_date	2025-10-21	2024-10-29
5291	233	1	2026-01-16 12:05:33.896591	resume_link	https://drive.google.com/file/19842	https://drive.google.com/file/55301
5292	233	1	2026-01-16 12:05:33.89707	ck_department	ЦК Аналитики	ЦК Разработки
5293	233	1	2026-01-16 12:05:33.897671	transfer_date	2026-07-02	
5294	233	1	2026-01-16 12:05:33.898201	target_projects	E-commerce Platform, Mobile App	Infrastructure
5295	233	1	2026-01-16 12:05:33.898686	candidate_status	Переведен	Свободен
5296	233	1	2026-01-16 12:05:33.899682	funding_end_date	2025-11-27	2026-04-02
5297	233	1	2026-01-16 12:05:33.900216	manager_feedback	Хороший специалист	
5298	233	1	2026-01-16 12:05:33.900703	ready_for_vacancy	Да	Нет
5299	235	1	2026-01-16 12:05:33.936595	comments	Ожидает оффер	Срочно нужен проект
5300	235	1	2026-01-16 12:05:33.937543	contacts	+7 (968) 530-48-15, @петмари33, m.petrova@rt.ru	+7 (933) 278-11-70, @петмари59, m.petrova@rt.ru
5301	235	1	2026-01-16 12:05:33.938516	it_block	Прочее	Эксплуатация
5302	235	1	2026-01-16 12:05:33.939198	entry_date	2024-01-19	2025-10-30
5303	235	1	2026-01-16 12:05:33.939736	resume_link	https://drive.google.com/file/83401	https://drive.google.com/file/73853
5304	235	1	2026-01-16 12:05:33.940472	ck_department	ЦК Инфраструктуры	Департамент данных
5305	235	1	2026-01-16 12:05:33.941371	placement_type	аутстафф	перевод
5306	235	1	2026-01-16 12:05:33.942414	current_manager	Иванов А.П.	Петров С.М.
5307	235	1	2026-01-16 12:05:33.943102	target_projects	Mobile App, Data Platform, Infrastructure	Infrastructure
5308	235	1	2026-01-16 12:05:33.943655	candidate_status	Забронирован	В работе
5309	235	1	2026-01-16 12:05:33.944161	funding_end_date	2025-06-24	2026-08-06
5310	236	1	2026-01-16 12:05:33.968621	hr_bp	Лебедева Т.М.	Морозов К.А.
5311	236	1	2026-01-16 12:05:33.969258	comments	Ожидает оффер	
5312	236	1	2026-01-16 12:05:33.969733	contacts	+7 (910) 963-95-99, @семдани93, d.semenov@rt.ru	+7 (955) 721-97-94, @семдани95, d.semenov@rt.ru
5313	236	1	2026-01-16 12:05:33.970164	it_block	B2O	Прочее
5314	236	1	2026-01-16 12:05:33.9709	entry_date	2024-11-20	2025-11-26
5315	236	1	2026-01-16 12:05:33.971496	resume_link	https://drive.google.com/file/33643	https://drive.google.com/file/85746
5316	236	1	2026-01-16 12:05:33.971961	ck_department	ЦК Разработки	Департамент данных
5317	236	1	2026-01-16 12:05:33.972418	transfer_date	2025-07-29	
5318	236	1	2026-01-16 12:05:33.972872	current_manager	Козлов Д.В.	Сидорова Е.К.
5319	236	1	2026-01-16 12:05:33.973351	target_projects	DevOps Platform, ML Pipeline	ML Pipeline
5320	236	1	2026-01-16 12:05:33.974085	candidate_status	Переведен	Забронирован
5321	236	1	2026-01-16 12:05:33.974704	funding_end_date	2025-06-21	2026-11-16
5322	236	1	2026-01-16 12:05:33.975171	manager_feedback		Отличные результаты
5323	237	1	2026-01-16 12:05:33.995415	hr_bp	Лебедева Т.М.	Морозов К.А.
5324	237	1	2026-01-16 12:05:33.996127	contacts	+7 (946) 532-49-93, @винмари10, m.vinogradova@rt.ru	+7 (983) 649-62-89, @винмари41, m.vinogradova@rt.ru
5325	237	1	2026-01-16 12:05:33.996603	it_block	Эксплуатация	Прочее
5326	237	1	2026-01-16 12:05:33.997058	recruiter	Белова И.Д.	Смирнова А.А.
5327	237	1	2026-01-16 12:05:33.997543	entry_date	2025-03-29	2025-04-28
5328	237	1	2026-01-16 12:05:33.998039	resume_link	https://drive.google.com/file/74350	https://drive.google.com/file/75118
5329	237	1	2026-01-16 12:05:33.99848	ck_department	Департамент данных	ЦК Разработки
5330	237	1	2026-01-16 12:05:33.998926	transfer_date		2026-08-15
5331	237	1	2026-01-16 12:05:33.999369	placement_type	любой	перевод
5332	237	1	2026-01-16 12:05:34.000249	current_manager	Иванов А.П.	Михайлова О.Н.
5333	237	1	2026-01-16 12:05:34.000797	target_projects	Data Platform, Banking App, DevOps Platform	Data Platform
5334	237	1	2026-01-16 12:05:34.001347	candidate_status	Забронирован	Переведен
5335	237	1	2026-01-16 12:05:34.002055	funding_end_date	2026-05-02	2026-01-23
5336	237	1	2026-01-16 12:05:34.002798	manager_feedback		Отличные результаты
5337	237	1	2026-01-16 12:05:34.00349	ready_for_vacancy	Нет	Да
5338	239	1	2026-01-16 12:05:34.059356	comments	Ожидает оффер	
5339	239	1	2026-01-16 12:05:34.06011	contacts	+7 (995) 281-48-46, @ковмари32, m.kovaleva@rt.ru	+7 (967) 551-30-59, @ковмари36, m.kovaleva@rt.ru
5340	239	1	2026-01-16 12:05:34.060719	it_block	НУК	B2O
5341	239	1	2026-01-16 12:05:34.061167	recruiter	Орлов М.С.	Смирнова А.А.
5342	239	1	2026-01-16 12:05:34.068315	entry_date	2025-08-26	2025-06-11
5343	239	1	2026-01-16 12:05:34.069072	resume_link	https://drive.google.com/file/40717	https://drive.google.com/file/68276
5344	239	1	2026-01-16 12:05:34.069957	ck_department	ЦК Инфраструктуры	ЦК Разработки
5345	239	1	2026-01-16 12:05:34.070638	transfer_date	2026-10-30	2025-06-26
5346	239	1	2026-01-16 12:05:34.071231	placement_type	аутстафф	любой
5347	239	1	2026-01-16 12:05:34.071817	current_manager	Козлов Д.В.	Петров С.М.
5348	239	1	2026-01-16 12:05:34.072301	target_projects	Госуслуги 2.0, Banking App	E-commerce Platform, Госуслуги 2.0, Mobile App
5349	239	1	2026-01-16 12:05:34.072848	funding_end_date	2026-08-26	2025-11-19
5350	239	1	2026-01-16 12:05:34.073572	manager_feedback		Нужно развитие
5351	239	1	2026-01-16 12:05:34.074307	ready_for_vacancy	Нет	Да
5352	241	1	2026-01-16 12:05:34.290394	hr_bp	Морозов К.А.	Волкова Н.В.
5353	241	1	2026-01-16 12:05:34.29102	comments	В процессе согласования	
5354	241	1	2026-01-16 12:05:34.291513	contacts	+7 (980) 645-49-68, @зайкрис7, k.zaytseva@rt.ru	+7 (953) 789-22-17, @зайкрис51, k.zaytseva@rt.ru
5355	241	1	2026-01-16 12:05:34.291944	it_block	Диджитал	Эксплуатация
5356	241	1	2026-01-16 12:05:34.292382	entry_date	2024-10-12	2025-12-12
5357	241	1	2026-01-16 12:05:34.292776	resume_link	https://drive.google.com/file/52352	https://drive.google.com/file/13890
5358	241	1	2026-01-16 12:05:34.294676	ck_department	Департамент данных	ЦК Инфраструктуры
5359	241	1	2026-01-16 12:05:34.295129	transfer_date		2025-03-09
5360	241	1	2026-01-16 12:05:34.295465	target_projects	Data Platform, Banking App, Госуслуги 2.0	DevOps Platform, Data Platform
5361	241	1	2026-01-16 12:05:34.29577	candidate_status	Забронирован	Увольнение по СЖ
5362	241	1	2026-01-16 12:05:34.296065	funding_end_date	2025-05-14	2026-08-28
5363	241	1	2026-01-16 12:05:34.296445	manager_feedback	Отличные результаты	
5364	242	1	2026-01-16 12:05:34.461496	comments		Срочно нужен проект
5365	242	1	2026-01-16 12:05:34.462191	contacts	+7 (975) 637-86-88, @таригор19, i.tarasov@rt.ru	+7 (952) 243-93-65, @таригор83, i.tarasov@rt.ru
5366	242	1	2026-01-16 12:05:34.462686	it_block	НУК	Развитие
5367	242	1	2026-01-16 12:05:34.463256	recruiter	Смирнова А.А.	Орлов М.С.
5368	242	1	2026-01-16 12:05:34.463687	entry_date	2025-11-05	2025-08-30
5369	242	1	2026-01-16 12:05:34.464128	resume_link	https://drive.google.com/file/31026	https://drive.google.com/file/80760
5370	242	1	2026-01-16 12:05:34.464547	ck_department	ЦК Аналитики	ЦК Инфраструктуры
5371	242	1	2026-01-16 12:05:34.46494	transfer_date	2025-05-30	2025-08-15
5372	242	1	2026-01-16 12:05:34.465397	current_manager	Михайлова О.Н.	Иванов А.П.
5373	242	1	2026-01-16 12:05:34.465904	target_projects	DevOps Platform, Госуслуги 2.0	Mobile App, Infrastructure
5374	242	1	2026-01-16 12:05:34.466331	candidate_status	Увольнение по СС	Переведен
5375	242	1	2026-01-16 12:05:34.466722	funding_end_date	2025-10-15	2025-06-08
5376	144	1	2026-01-16 12:05:34.494427	comments	Срочно нужен проект	
5377	144	1	2026-01-16 12:05:34.495259	contacts	+7 (937) 428-59-57, @фёдсерг50, arseny.smirnov128@company.ru	+7 (944) 661-35-73, @фёдсерг76, arseny.smirnov128@company.ru
5378	144	1	2026-01-16 12:05:34.495814	it_block	Развитие	НУК
5379	144	1	2026-01-16 12:05:34.496435	recruiter	Белова И.Д.	Новикова Е.П.
5380	144	1	2026-01-16 12:05:34.497185	entry_date	2025-09-12	2024-10-18
5381	144	1	2026-01-16 12:05:34.497839	resume_link	https://drive.google.com/file/51239	https://drive.google.com/file/56042
5382	144	1	2026-01-16 12:05:34.498313	ck_department	ЦК Аналитики	ЦК Инфраструктуры
5383	144	1	2026-01-16 12:05:34.499144	transfer_date	2026-03-17	2026-12-16
5384	144	1	2026-01-16 12:05:34.500042	placement_type	аутстафф	перевод
5385	144	1	2026-01-16 12:05:34.500515	current_manager	Козлов Д.В.	Петров С.М.
5386	144	1	2026-01-16 12:05:34.500899	target_projects	Mobile App	Infrastructure, Data Platform
5387	144	1	2026-01-16 12:05:34.501275	candidate_status	Переведен	Увольнение по СС
5388	144	1	2026-01-16 12:05:34.501702	funding_end_date	2026-08-12	2025-11-06
5389	144	1	2026-01-16 12:05:34.502082	manager_feedback	Рекомендую	Нужно развитие
5390	144	1	2026-01-16 12:05:34.503126	ready_for_vacancy	Нет	Да
5391	67	1	2026-01-16 12:05:34.530146	hr_bp	Морозов К.А.	Лебедева Т.М.
5392	67	1	2026-01-16 12:05:34.531172	comments		Срочно нужен проект
5393	67	1	2026-01-16 12:05:34.531663	contacts	+7 (918) 346-95-33, @михандр57, evgeny.dmitriev51@company.ru	+7 (909) 302-19-19, @михандр44, evgeny.dmitriev51@company.ru
5394	67	1	2026-01-16 12:05:34.531993	it_block	Эксплуатация	Прочее
5395	67	1	2026-01-16 12:05:34.532288	recruiter	Орлов М.С.	Новикова Е.П.
5396	67	1	2026-01-16 12:05:34.532712	entry_date	2024-01-03	2025-11-21
5397	67	1	2026-01-16 12:05:34.533116	resume_link	https://drive.google.com/file/17091	https://drive.google.com/file/22327
5398	67	1	2026-01-16 12:05:34.533599	ck_department	Департамент данных	ЦК Инфраструктуры
5399	67	1	2026-01-16 12:05:34.534074	transfer_date	2026-02-12	2025-07-09
5400	67	1	2026-01-16 12:05:34.534575	placement_type	перевод	любой
5401	67	1	2026-01-16 12:05:34.535157	current_manager	Козлов Д.В.	Сидорова Е.К.
5402	67	1	2026-01-16 12:05:34.53585	target_projects	Data Platform	Banking App, Госуслуги 2.0, Infrastructure
5467	264	1	2026-01-16 12:05:34.792801	transfer_date		2025-11-17
5403	67	1	2026-01-16 12:05:34.536505	candidate_status	Переведен	Увольнение по СС
5404	67	1	2026-01-16 12:05:34.53715	funding_end_date	2026-03-01	2026-08-10
5405	67	1	2026-01-16 12:05:34.537793	manager_feedback	Хороший специалист	Отличные результаты
5406	180	1	2026-01-16 12:05:34.557163	hr_bp	Морозов К.А.	Волкова Н.В.
5407	180	1	2026-01-16 12:05:34.557828	comments	Ожидает оффер	
5408	180	1	2026-01-16 12:05:34.558653	contacts	+7 (959) 128-82-16, @иваалек68, vladimir.borisov164@company.ru	+7 (943) 366-27-30, @иваалек67, vladimir.borisov164@company.ru
5409	180	1	2026-01-16 12:05:34.559404	it_block	НУК	Прочее
5410	180	1	2026-01-16 12:05:34.560043	entry_date	2024-02-18	2024-01-23
5411	180	1	2026-01-16 12:05:34.560601	resume_link	https://drive.google.com/file/15648	https://drive.google.com/file/82977
5412	180	1	2026-01-16 12:05:34.560958	ck_department	ЦК Инфраструктуры	ЦК Разработки
5413	180	1	2026-01-16 12:05:34.561284	transfer_date	2026-08-30	2025-05-07
5414	180	1	2026-01-16 12:05:34.561865	placement_type	любой	аутстафф
5415	180	1	2026-01-16 12:05:34.562372	current_manager	Петров С.М.	Михайлова О.Н.
5416	180	1	2026-01-16 12:05:34.562953	target_projects	Госуслуги 2.0, DevOps Platform	E-commerce Platform, DevOps Platform
5417	180	1	2026-01-16 12:05:34.563374	candidate_status	Увольнение по СЖ	Переведен
5418	180	1	2026-01-16 12:05:34.563969	funding_end_date	2025-07-21	2025-10-26
5419	180	1	2026-01-16 12:05:34.564676	ready_for_vacancy	Да	Нет
5420	260	1	2026-01-16 12:05:34.584483	comments	Ожидает оффер	
5421	260	1	2026-01-16 12:05:34.58517	contacts	+7 (923) 297-76-10, @козглеб96, g.kozlov@rt.ru	+7 (979) 595-30-98, @козглеб31, g.kozlov@rt.ru
5422	260	1	2026-01-16 12:05:34.585763	it_block	Эксплуатация	B2O
5423	260	1	2026-01-16 12:05:34.586248	recruiter	Смирнова А.А.	Белова И.Д.
5424	260	1	2026-01-16 12:05:34.586905	entry_date	2024-06-14	2025-11-05
5425	260	1	2026-01-16 12:05:34.587335	resume_link	https://drive.google.com/file/97935	https://drive.google.com/file/69688
5426	260	1	2026-01-16 12:05:34.587831	ck_department	ЦК Инфраструктуры	Департамент данных
5427	260	1	2026-01-16 12:05:34.588343	placement_type	перевод	аутстафф
5428	260	1	2026-01-16 12:05:34.588929	target_projects	Banking App, ML Pipeline, Госуслуги 2.0	Госуслуги 2.0, Banking App
5429	260	1	2026-01-16 12:05:34.58949	candidate_status	Забронирован	В работе
5430	260	1	2026-01-16 12:05:34.589962	funding_end_date	2025-02-18	2026-11-06
5431	260	1	2026-01-16 12:05:34.590368	manager_feedback	Хороший специалист	Нужно развитие
5432	260	1	2026-01-16 12:05:34.590779	ready_for_vacancy	Да	Нет
5433	261	1	2026-01-16 12:05:34.72959	hr_bp	Морозов К.А.	Лебедева Т.М.
5434	261	1	2026-01-16 12:05:34.730376	comments	В процессе согласования	Срочно нужен проект
5435	261	1	2026-01-16 12:05:34.731011	contacts	+7 (975) 551-53-35, @семдени82, d.semenov@rt.ru	+7 (906) 399-32-78, @семдени90, d.semenov@rt.ru
5436	261	1	2026-01-16 12:05:34.731554	it_block	Диджитал	B2O
5437	261	1	2026-01-16 12:05:34.732069	recruiter	Смирнова А.А.	Новикова Е.П.
5438	261	1	2026-01-16 12:05:34.732601	entry_date	2025-04-03	2024-03-31
5439	261	1	2026-01-16 12:05:34.733095	resume_link	https://drive.google.com/file/53895	https://drive.google.com/file/81663
5440	261	1	2026-01-16 12:05:34.733629	ck_department	Департамент цифровых продуктов	ЦК Аналитики
5441	261	1	2026-01-16 12:05:34.734287	transfer_date	2025-07-06	2025-01-03
5442	261	1	2026-01-16 12:05:34.73473	current_manager	Иванов А.П.	Сидорова Е.К.
5443	261	1	2026-01-16 12:05:34.735152	target_projects	Mobile App, Infrastructure	Infrastructure
5444	261	1	2026-01-16 12:05:34.73557	candidate_status	Увольнение по СЖ	Увольнение по СС
5445	261	1	2026-01-16 12:05:34.736029	funding_end_date	2026-05-02	2025-09-27
5446	261	1	2026-01-16 12:05:34.736555	manager_feedback	Отличные результаты	Нужно развитие
5447	261	1	2026-01-16 12:05:34.73717	ready_for_vacancy	Нет	Да
5448	263	1	2026-01-16 12:05:34.764817	hr_bp	Морозов К.А.	Волкова Н.В.
5449	263	1	2026-01-16 12:05:34.765492	comments	В процессе согласования	Срочно нужен проект
5450	263	1	2026-01-16 12:05:34.766164	contacts	+7 (982) 472-77-73, @козпаве80, p.kozlov@rt.ru	+7 (923) 844-53-65, @козпаве75, p.kozlov@rt.ru
5451	263	1	2026-01-16 12:05:34.766793	it_block	Диджитал	B2O
5452	263	1	2026-01-16 12:05:34.767345	recruiter	Орлов М.С.	Смирнова А.А.
5453	263	1	2026-01-16 12:05:34.76805	entry_date	2024-06-07	2024-10-20
5454	263	1	2026-01-16 12:05:34.768615	resume_link	https://drive.google.com/file/31631	https://drive.google.com/file/75614
5455	263	1	2026-01-16 12:05:34.769133	ck_department	ЦК Инфраструктуры	Департамент цифровых продуктов
5456	263	1	2026-01-16 12:05:34.769718	placement_type	любой	перевод
5457	263	1	2026-01-16 12:05:34.770368	current_manager	Козлов Д.В.	Сидорова Е.К.
5458	263	1	2026-01-16 12:05:34.770804	target_projects	ML Pipeline	Banking App
5459	263	1	2026-01-16 12:05:34.771253	funding_end_date	2025-07-19	2026-12-20
5460	263	1	2026-01-16 12:05:34.771621	manager_feedback	Нужно развитие	Хороший специалист
5461	264	1	2026-01-16 12:05:34.790737	hr_bp	Волкова Н.В.	Морозов К.А.
5462	264	1	2026-01-16 12:05:34.791295	contacts	+7 (947) 829-66-73, @меданна44, a.medvedeva@rt.ru	+7 (991) 469-31-18, @меданна3, a.medvedeva@rt.ru
5463	264	1	2026-01-16 12:05:34.791646	it_block	B2O	НУК
5464	264	1	2026-01-16 12:05:34.791939	entry_date	2024-09-19	2025-11-04
5465	264	1	2026-01-16 12:05:34.792219	resume_link	https://drive.google.com/file/72812	https://drive.google.com/file/61465
5466	264	1	2026-01-16 12:05:34.792504	ck_department	Департамент данных	ЦК Аналитики
5468	264	1	2026-01-16 12:05:34.793081	current_manager	Михайлова О.Н.	Сидорова Е.К.
5469	264	1	2026-01-16 12:05:34.7936	target_projects	Mobile App	Mobile App, Banking App, Infrastructure
5470	264	1	2026-01-16 12:05:34.794307	candidate_status	Свободен	Увольнение по СС
5471	264	1	2026-01-16 12:05:34.79491	funding_end_date	2026-06-13	2026-11-10
5472	24	1	2026-01-16 12:05:34.814401	contacts	+7 (909) 118-19-94, @фёдсерг18, alexander.borisov8@company.ru	+7 (932) 288-30-98, @фёдсерг69, alexander.borisov8@company.ru
5473	24	1	2026-01-16 12:05:34.815204	recruiter	Новикова Е.П.	Белова И.Д.
5474	24	1	2026-01-16 12:05:34.8157	entry_date	2024-11-06	2025-09-17
5475	24	1	2026-01-16 12:05:34.816031	resume_link	https://drive.google.com/file/11546	https://drive.google.com/file/64483
5476	24	1	2026-01-16 12:05:34.816334	transfer_date	2026-03-01	2025-02-28
5477	24	1	2026-01-16 12:05:34.816635	current_manager	Петров С.М.	Сидорова Е.К.
5478	24	1	2026-01-16 12:05:34.816921	target_projects	ML Pipeline, Data Platform	Infrastructure, Mobile App
5479	24	1	2026-01-16 12:05:34.817207	candidate_status	Переведен	Увольнение по СС
5480	24	1	2026-01-16 12:05:34.817609	funding_end_date	2026-11-30	2025-04-23
5481	84	1	2026-01-16 12:05:34.850984	contacts	+7 (963) 628-78-57, @фёдсерг22, tatiana.vorobyov68@company.ru	+7 (986) 333-57-32, @фёдсерг86, tatiana.vorobyov68@company.ru
5482	84	1	2026-01-16 12:05:34.851753	it_block	Прочее	Развитие
5483	84	1	2026-01-16 12:05:34.852494	recruiter	Новикова Е.П.	Белова И.Д.
5484	84	1	2026-01-16 12:05:34.853003	entry_date	2025-07-17	2025-03-14
5485	84	1	2026-01-16 12:05:34.853668	resume_link	https://drive.google.com/file/27436	https://drive.google.com/file/79871
5486	84	1	2026-01-16 12:05:34.854313	ck_department	Департамент цифровых продуктов	ЦК Инфраструктуры
5487	84	1	2026-01-16 12:05:34.854791	transfer_date	2026-07-10	2026-10-10
5488	84	1	2026-01-16 12:05:34.855242	placement_type	перевод	аутстафф
5489	84	1	2026-01-16 12:05:34.855692	current_manager	Козлов Д.В.	Сидорова Е.К.
5490	84	1	2026-01-16 12:05:34.856133	target_projects	Госуслуги 2.0, Infrastructure	DevOps Platform
5491	84	1	2026-01-16 12:05:34.856583	candidate_status	Увольнение по СС	Переведен
5492	84	1	2026-01-16 12:05:34.857055	funding_end_date	2025-05-21	2026-02-03
5493	84	1	2026-01-16 12:05:34.857598	manager_feedback	Рекомендую	Нужно развитие
5494	276	1	2026-01-16 12:05:34.875898	hr_bp	Морозов К.А.	Лебедева Т.М.
5495	276	1	2026-01-16 12:05:34.876704	comments		Ожидает оффер
5496	276	1	2026-01-16 12:05:34.877214	contacts	+7 (908) 429-99-35, @никната53, n.nikolaeva@rt.ru	+7 (915) 457-20-81, @никната22, n.nikolaeva@rt.ru
5497	276	1	2026-01-16 12:05:34.877961	recruiter	Смирнова А.А.	Орлов М.С.
5498	276	1	2026-01-16 12:05:34.878437	entry_date	2025-01-30	2025-01-12
5499	276	1	2026-01-16 12:05:34.878897	resume_link	https://drive.google.com/file/27294	https://drive.google.com/file/12182
5500	276	1	2026-01-16 12:05:34.879345	transfer_date		2026-06-27
5501	276	1	2026-01-16 12:05:34.879993	placement_type	любой	аутстафф
5502	276	1	2026-01-16 12:05:34.88048	current_manager	Петров С.М.	Сидорова Е.К.
5503	276	1	2026-01-16 12:05:34.880962	target_projects	E-commerce Platform, Mobile App	Data Platform, ML Pipeline, E-commerce Platform
5504	276	1	2026-01-16 12:05:34.881465	candidate_status	Свободен	Увольнение по СС
5505	276	1	2026-01-16 12:05:34.88205	funding_end_date	2026-05-26	2025-09-21
5506	276	1	2026-01-16 12:05:34.882564	manager_feedback	Нужно развитие	Рекомендую
5507	277	1	2026-01-16 12:05:34.906211	hr_bp	Волкова Н.В.	Морозов К.А.
5508	277	1	2026-01-16 12:05:34.906922	contacts	+7 (921) 703-59-72, @попвлад6, v.popov@rt.ru	+7 (919) 248-61-28, @попвлад31, v.popov@rt.ru
5509	277	1	2026-01-16 12:05:34.907467	it_block	Диджитал	Прочее
5510	277	1	2026-01-16 12:05:34.907924	recruiter	Орлов М.С.	Смирнова А.А.
5511	277	1	2026-01-16 12:05:34.908373	entry_date	2024-05-02	2025-01-14
5512	277	1	2026-01-16 12:05:34.908818	resume_link	https://drive.google.com/file/45776	https://drive.google.com/file/64019
5513	277	1	2026-01-16 12:05:34.90928	ck_department	Департамент цифровых продуктов	ЦК Аналитики
5514	277	1	2026-01-16 12:05:34.909925	transfer_date		2025-09-20
5515	277	1	2026-01-16 12:05:34.910436	current_manager	Иванов А.П.	Козлов Д.В.
5516	277	1	2026-01-16 12:05:34.910921	target_projects	Госуслуги 2.0, Mobile App, Data Platform	Infrastructure
5517	277	1	2026-01-16 12:05:34.911447	candidate_status	Свободен	Увольнение по СЖ
5518	277	1	2026-01-16 12:05:34.911906	funding_end_date	2025-10-13	2025-08-02
5519	277	1	2026-01-16 12:05:34.912358	manager_feedback	Нужно развитие	Хороший специалист
5520	277	1	2026-01-16 12:05:34.912818	ready_for_vacancy	Нет	Да
5521	279	1	2026-01-16 12:05:34.934908	contacts	+7 (955) 109-47-10, @иваалин93, a.ivanova@rt.ru	+7 (957) 705-30-66, @иваалин98, a.ivanova@rt.ru
5522	279	1	2026-01-16 12:05:34.935481	it_block	B2O	Развитие
5523	279	1	2026-01-16 12:05:34.93593	recruiter	Смирнова А.А.	Новикова Е.П.
5524	279	1	2026-01-16 12:05:34.936499	entry_date	2024-04-08	2024-02-28
5525	279	1	2026-01-16 12:05:34.937157	resume_link	https://drive.google.com/file/59894	https://drive.google.com/file/51307
5526	279	1	2026-01-16 12:05:34.937891	ck_department	ЦК Аналитики	ЦК Инфраструктуры
5527	279	1	2026-01-16 12:05:34.938418	transfer_date		2025-11-03
5528	279	1	2026-01-16 12:05:34.938887	placement_type	любой	перевод
5529	279	1	2026-01-16 12:05:34.939347	current_manager	Сидорова Е.К.	Михайлова О.Н.
5530	279	1	2026-01-16 12:05:34.939809	target_projects	Госуслуги 2.0, ML Pipeline	E-commerce Platform, DevOps Platform
5531	279	1	2026-01-16 12:05:34.94026	candidate_status	В работе	Увольнение по СС
5532	279	1	2026-01-16 12:05:34.940705	funding_end_date	2025-02-07	2025-10-01
5533	279	1	2026-01-16 12:05:34.941528	manager_feedback	Нужно развитие	Хороший специалист
5534	280	1	2026-01-16 12:05:34.961304	comments	Ожидает оффер	Срочно нужен проект
5535	280	1	2026-01-16 12:05:34.96184	contacts	+7 (990) 950-27-61, @ильлюбо93, l.ilina@rt.ru	+7 (903) 514-92-10, @ильлюбо3, l.ilina@rt.ru
5536	280	1	2026-01-16 12:05:34.962203	it_block	Развитие	НУК
5537	280	1	2026-01-16 12:05:34.962506	recruiter	Орлов М.С.	Белова И.Д.
5538	280	1	2026-01-16 12:05:34.962805	entry_date	2024-11-26	2025-06-11
5539	280	1	2026-01-16 12:05:34.963116	resume_link	https://drive.google.com/file/14988	https://drive.google.com/file/80006
5540	280	1	2026-01-16 12:05:34.963409	ck_department	Департамент цифровых продуктов	Департамент данных
5541	280	1	2026-01-16 12:05:34.963691	transfer_date		2025-03-17
5542	280	1	2026-01-16 12:05:34.963973	current_manager	Козлов Д.В.	Петров С.М.
5543	280	1	2026-01-16 12:05:34.964253	target_projects	ML Pipeline	Infrastructure, Госуслуги 2.0, E-commerce Platform
5544	280	1	2026-01-16 12:05:34.964529	candidate_status	Забронирован	Переведен
5545	280	1	2026-01-16 12:05:34.964803	funding_end_date	2025-03-12	2026-12-13
5546	280	1	2026-01-16 12:05:34.965079	manager_feedback	Хороший специалист	
5547	282	1	2026-01-16 12:05:34.98579	comments		Ожидает оффер
5548	282	1	2026-01-16 12:05:34.986416	contacts	+7 (972) 548-63-55, @егоартё88, a.egorov@rt.ru	+7 (931) 736-23-84, @егоартё42, a.egorov@rt.ru
5549	282	1	2026-01-16 12:05:34.987237	it_block	Диджитал	Прочее
5550	282	1	2026-01-16 12:05:34.98791	recruiter	Новикова Е.П.	Белова И.Д.
5551	282	1	2026-01-16 12:05:34.988551	entry_date	2025-01-12	2025-04-25
5552	282	1	2026-01-16 12:05:34.989362	resume_link	https://drive.google.com/file/29503	https://drive.google.com/file/42952
5553	282	1	2026-01-16 12:05:34.989969	ck_department	ЦК Разработки	ЦК Аналитики
5554	282	1	2026-01-16 12:05:34.990394	transfer_date		2025-02-23
5555	282	1	2026-01-16 12:05:34.990709	placement_type	любой	аутстафф
5556	282	1	2026-01-16 12:05:34.991006	current_manager	Козлов Д.В.	Сидорова Е.К.
5557	282	1	2026-01-16 12:05:34.991298	target_projects	ML Pipeline, E-commerce Platform	Banking App, Infrastructure, Госуслуги 2.0
5558	282	1	2026-01-16 12:05:34.991575	candidate_status	Забронирован	Переведен
5559	282	1	2026-01-16 12:05:34.991852	funding_end_date	2026-05-06	2026-01-07
5560	282	1	2026-01-16 12:05:34.992126	manager_feedback		Отличные результаты
5561	282	1	2026-01-16 12:05:34.99241	ready_for_vacancy	Да	Нет
5562	283	1	2026-01-16 12:05:35.012319	hr_bp	Лебедева Т.М.	Морозов К.А.
5563	283	1	2026-01-16 12:05:35.01337	comments		В процессе согласования
5564	283	1	2026-01-16 12:05:35.014169	contacts	+7 (962) 894-11-75, @орлегор78, e.orlov@rt.ru	+7 (963) 914-10-18, @орлегор43, e.orlov@rt.ru
5565	283	1	2026-01-16 12:05:35.014762	it_block	НУК	Прочее
5566	283	1	2026-01-16 12:05:35.015596	recruiter	Смирнова А.А.	Орлов М.С.
5567	283	1	2026-01-16 12:05:35.016142	entry_date	2024-02-22	2024-05-27
5568	283	1	2026-01-16 12:05:35.01656	resume_link	https://drive.google.com/file/45954	https://drive.google.com/file/28248
5569	283	1	2026-01-16 12:05:35.016942	ck_department	ЦК Аналитики	ЦК Инфраструктуры
5570	283	1	2026-01-16 12:05:35.017329	transfer_date	2026-07-01	2026-07-25
5571	283	1	2026-01-16 12:05:35.017931	placement_type	аутстафф	перевод
5572	283	1	2026-01-16 12:05:35.018663	current_manager	Михайлова О.Н.	Козлов Д.В.
5573	283	1	2026-01-16 12:05:35.019124	target_projects	Infrastructure, E-commerce Platform	Госуслуги 2.0, Mobile App, ML Pipeline
5574	283	1	2026-01-16 12:05:35.019518	candidate_status	Увольнение по СЖ	Увольнение по СС
5575	283	1	2026-01-16 12:05:35.020133	funding_end_date	2026-12-20	2026-09-19
5576	283	1	2026-01-16 12:05:35.02087	manager_feedback		Рекомендую
5577	283	1	2026-01-16 12:05:35.021314	ready_for_vacancy	Нет	Да
5578	285	1	2026-01-16 12:05:35.044058	hr_bp	Волкова Н.В.	Морозов К.А.
5579	285	1	2026-01-16 12:05:35.045067	contacts	+7 (966) 588-54-70, @козалек70, a.kozlov@rt.ru	+7 (937) 877-33-31, @козалек31, a.kozlov@rt.ru
5580	285	1	2026-01-16 12:05:35.046023	it_block	НУК	B2O
5581	285	1	2026-01-16 12:05:35.04655	recruiter	Смирнова А.А.	Белова И.Д.
5582	285	1	2026-01-16 12:05:35.047023	entry_date	2024-12-12	2024-01-08
5583	285	1	2026-01-16 12:05:35.047948	resume_link	https://drive.google.com/file/48262	https://drive.google.com/file/13000
5584	285	1	2026-01-16 12:05:35.049174	ck_department	Департамент данных	ЦК Аналитики
5585	285	1	2026-01-16 12:05:35.050184	transfer_date	2026-01-12	
5586	285	1	2026-01-16 12:05:35.050965	current_manager	Сидорова Е.К.	Иванов А.П.
5587	285	1	2026-01-16 12:05:35.051911	target_projects	DevOps Platform	Banking App
5588	285	1	2026-01-16 12:05:35.052857	candidate_status	Переведен	В работе
5589	285	1	2026-01-16 12:05:35.053656	funding_end_date	2025-04-25	2026-02-06
5590	285	1	2026-01-16 12:05:35.054474	manager_feedback	Нужно развитие	Рекомендую
5591	285	1	2026-01-16 12:05:35.055287	ready_for_vacancy	Нет	Да
5592	286	1	2026-01-16 12:05:35.086551	hr_bp	Морозов К.А.	Лебедева Т.М.
5593	286	1	2026-01-16 12:05:35.087736	comments	В процессе согласования	
5594	286	1	2026-01-16 12:05:35.088768	contacts	+7 (908) 439-73-95, @попсвет95, s.popova@rt.ru	+7 (958) 194-48-15, @попсвет72, s.popova@rt.ru
5595	286	1	2026-01-16 12:05:35.089787	recruiter	Орлов М.С.	Белова И.Д.
5596	286	1	2026-01-16 12:05:35.090663	entry_date	2025-12-19	2025-05-02
5597	286	1	2026-01-16 12:05:35.091418	resume_link	https://drive.google.com/file/18030	https://drive.google.com/file/21312
5598	286	1	2026-01-16 12:05:35.092148	transfer_date	2025-05-06	2025-03-07
5599	286	1	2026-01-16 12:05:35.09283	placement_type	аутстафф	любой
5600	286	1	2026-01-16 12:05:35.093599	current_manager	Иванов А.П.	Сидорова Е.К.
5601	286	1	2026-01-16 12:05:35.094312	target_projects	Infrastructure, E-commerce Platform	Infrastructure, ML Pipeline
5602	286	1	2026-01-16 12:05:35.095061	candidate_status	Переведен	Увольнение по СЖ
5603	286	1	2026-01-16 12:05:35.095679	funding_end_date	2026-09-28	2026-04-06
5604	286	1	2026-01-16 12:05:35.096384	manager_feedback	Отличные результаты	
5605	286	1	2026-01-16 12:05:35.09686	ready_for_vacancy	Нет	Да
5606	288	1	2026-01-16 12:05:35.131849	comments	Срочно нужен проект	Ожидает оффер
5607	288	1	2026-01-16 12:05:35.133064	contacts	+7 (979) 352-24-47, @морвлад76, v.morozov@rt.ru	+7 (968) 558-67-66, @морвлад33, v.morozov@rt.ru
5608	288	1	2026-01-16 12:05:35.134417	it_block	Диджитал	B2O
5609	288	1	2026-01-16 12:05:35.135542	recruiter	Смирнова А.А.	Орлов М.С.
5610	288	1	2026-01-16 12:05:35.136459	entry_date	2025-08-25	2024-01-17
5611	288	1	2026-01-16 12:05:35.137423	resume_link	https://drive.google.com/file/77441	https://drive.google.com/file/78791
5612	288	1	2026-01-16 12:05:35.138067	ck_department	ЦК Инфраструктуры	Департамент данных
5613	288	1	2026-01-16 12:05:35.138508	transfer_date	2026-09-13	2025-07-16
5614	288	1	2026-01-16 12:05:35.139037	current_manager	Козлов Д.В.	Михайлова О.Н.
5615	288	1	2026-01-16 12:05:35.1398	target_projects	E-commerce Platform, Banking App	Infrastructure
5616	288	1	2026-01-16 12:05:35.140602	candidate_status	Увольнение по СЖ	Переведен
5617	288	1	2026-01-16 12:05:35.14143	funding_end_date	2025-01-10	2026-09-17
5618	288	1	2026-01-16 12:05:35.142429	manager_feedback	Хороший специалист	Нужно развитие
5619	288	1	2026-01-16 12:05:35.143351	ready_for_vacancy	Да	Нет
5620	79	1	2026-01-16 12:05:35.171341	comments	В процессе согласования	
5621	79	1	2026-01-16 12:05:35.171975	contacts	+7 (996) 834-24-85, @васиван13, andrey.romanov63@company.ru	+7 (950) 477-32-38, @васиван81, andrey.romanov63@company.ru
5622	79	1	2026-01-16 12:05:35.172664	it_block	Эксплуатация	B2O
5623	79	1	2026-01-16 12:05:35.173495	recruiter	Орлов М.С.	Белова И.Д.
5624	79	1	2026-01-16 12:05:35.174138	entry_date	2024-02-02	2025-11-03
5625	79	1	2026-01-16 12:05:35.174601	resume_link	https://drive.google.com/file/93796	https://drive.google.com/file/93690
5626	79	1	2026-01-16 12:05:35.17505	ck_department	Департамент цифровых продуктов	ЦК Разработки
5627	79	1	2026-01-16 12:05:35.175633	placement_type	перевод	аутстафф
5628	79	1	2026-01-16 12:05:35.176074	current_manager	Иванов А.П.	Козлов Д.В.
5629	79	1	2026-01-16 12:05:35.176532	target_projects	Banking App, Infrastructure, DevOps Platform	ML Pipeline, Госуслуги 2.0
5630	79	1	2026-01-16 12:05:35.176966	candidate_status	Свободен	В работе
5631	79	1	2026-01-16 12:05:35.177383	funding_end_date	2026-11-17	2026-06-02
5632	79	1	2026-01-16 12:05:35.177986	manager_feedback	Хороший специалист	Нужно развитие
5633	83	1	2026-01-16 12:05:35.199109	hr_bp	Лебедева Т.М.	Волкова Н.В.
5634	83	1	2026-01-16 12:05:35.199929	comments	Срочно нужен проект	Ожидает оффер
5635	83	1	2026-01-16 12:05:35.200437	contacts	+7 (959) 555-53-34, @новрома71, elena.semenov67@company.ru	+7 (981) 113-65-96, @новрома1, elena.semenov67@company.ru
5636	83	1	2026-01-16 12:05:35.20091	it_block	Эксплуатация	Диджитал
5637	83	1	2026-01-16 12:05:35.201685	recruiter	Смирнова А.А.	Новикова Е.П.
5638	83	1	2026-01-16 12:05:35.202328	entry_date	2025-10-27	2024-12-15
5639	83	1	2026-01-16 12:05:35.20282	resume_link	https://drive.google.com/file/37614	https://drive.google.com/file/13868
5640	83	1	2026-01-16 12:05:35.203287	transfer_date	2025-02-13	2025-09-06
5641	83	1	2026-01-16 12:05:35.20376	placement_type	перевод	аутстафф
5642	83	1	2026-01-16 12:05:35.204513	current_manager	Сидорова Е.К.	Иванов А.П.
5643	83	1	2026-01-16 12:05:35.205	target_projects	Госуслуги 2.0	Mobile App, Госуслуги 2.0, ML Pipeline
5644	83	1	2026-01-16 12:05:35.205961	candidate_status	Переведен	Увольнение по СЖ
5645	83	1	2026-01-16 12:05:35.206784	funding_end_date	2025-05-15	2025-06-25
5646	103	1	2026-01-16 12:05:35.227901	contacts	+7 (961) 645-58-74, @лебдмит39, daniil.makarov87@company.ru	+7 (972) 985-16-56, @лебдмит52, daniil.makarov87@company.ru
5647	103	1	2026-01-16 12:05:35.228702	it_block	B2O	НУК
5648	103	1	2026-01-16 12:05:35.229421	recruiter	Смирнова А.А.	Орлов М.С.
5649	103	1	2026-01-16 12:05:35.23009	entry_date	2025-05-03	2024-05-13
5650	103	1	2026-01-16 12:05:35.23074	resume_link	https://drive.google.com/file/50906	https://drive.google.com/file/12122
5651	103	1	2026-01-16 12:05:35.231534	ck_department	Департамент цифровых продуктов	Департамент данных
5652	103	1	2026-01-16 12:05:35.232223	transfer_date		2026-08-01
5653	103	1	2026-01-16 12:05:35.232891	current_manager	Михайлова О.Н.	Петров С.М.
5654	103	1	2026-01-16 12:05:35.233567	target_projects	DevOps Platform, Госуслуги 2.0, ML Pipeline	DevOps Platform, Infrastructure
5655	103	1	2026-01-16 12:05:35.23421	candidate_status	Свободен	Увольнение по СС
5656	103	1	2026-01-16 12:05:35.234878	funding_end_date	2025-11-18	2026-05-14
5657	103	1	2026-01-16 12:05:35.235456	ready_for_vacancy	Да	Нет
5658	94	1	2026-01-16 12:05:35.255915	hr_bp	Лебедева Т.М.	Волкова Н.В.
5659	94	1	2026-01-16 12:05:35.256727	contacts	+7 (970) 956-85-20, @васиван14, julia.alexandrov78@company.ru	+7 (987) 456-92-76, @васиван2, julia.alexandrov78@company.ru
5660	94	1	2026-01-16 12:05:35.257285	it_block	B2O	Прочее
5661	94	1	2026-01-16 12:05:35.25802	entry_date	2025-05-21	2024-11-28
5662	94	1	2026-01-16 12:05:35.258597	resume_link	https://drive.google.com/file/78594	https://drive.google.com/file/82087
5663	94	1	2026-01-16 12:05:35.259141	ck_department	ЦК Разработки	ЦК Инфраструктуры
5664	94	1	2026-01-16 12:05:35.259769	transfer_date	2026-09-18	
5665	94	1	2026-01-16 12:05:35.260276	current_manager	Михайлова О.Н.	Сидорова Е.К.
5666	94	1	2026-01-16 12:05:35.260756	target_projects	Data Platform, Banking App, Госуслуги 2.0	Data Platform, Infrastructure
5667	94	1	2026-01-16 12:05:35.261409	candidate_status	Увольнение по СЖ	Забронирован
5668	94	1	2026-01-16 12:05:35.262077	funding_end_date	2026-07-10	2025-05-05
5669	94	1	2026-01-16 12:05:35.26269	manager_feedback	Нужно развитие	Отличные результаты
5670	94	1	2026-01-16 12:05:35.263256	ready_for_vacancy	Нет	Да
5671	113	1	2026-01-16 12:05:35.284471	hr_bp	Морозов К.А.	Лебедева Т.М.
5672	113	1	2026-01-16 12:05:35.285097	comments	Срочно нужен проект	В процессе согласования
5673	113	1	2026-01-16 12:05:35.285644	contacts	+7 (900) 532-83-33, @новрома13, igor.dmitriev97@company.ru	+7 (949) 358-37-62, @новрома43, igor.dmitriev97@company.ru
5674	113	1	2026-01-16 12:05:35.286117	it_block	Эксплуатация	Прочее
5675	113	1	2026-01-16 12:05:35.286591	entry_date	2025-06-26	2024-12-06
5676	113	1	2026-01-16 12:05:35.287208	resume_link	https://drive.google.com/file/65428	https://drive.google.com/file/99016
5677	113	1	2026-01-16 12:05:35.28778	ck_department	ЦК Разработки	Департамент данных
5678	113	1	2026-01-16 12:05:35.288411	transfer_date	2026-01-02	
5679	113	1	2026-01-16 12:05:35.289002	placement_type	аутстафф	любой
5680	113	1	2026-01-16 12:05:35.289694	current_manager	Сидорова Е.К.	Михайлова О.Н.
5681	113	1	2026-01-16 12:05:35.290357	target_projects	DevOps Platform, Mobile App	E-commerce Platform, Banking App, Infrastructure
5682	113	1	2026-01-16 12:05:35.290778	candidate_status	Увольнение по СЖ	Свободен
5683	113	1	2026-01-16 12:05:35.291287	funding_end_date	2026-08-30	2026-04-29
5684	113	1	2026-01-16 12:05:35.291607	manager_feedback	Отличные результаты	Хороший специалист
5685	113	1	2026-01-16 12:05:35.2919	ready_for_vacancy	Да	Нет
5686	126	1	2026-01-16 12:05:35.310709	contacts	+7 (950) 508-94-43, @сокегор68, petr.frolov110@company.ru	+7 (965) 716-38-17, @сокегор47, petr.frolov110@company.ru
5687	126	1	2026-01-16 12:05:35.31145	recruiter	Орлов М.С.	Белова И.Д.
5688	126	1	2026-01-16 12:05:35.312054	entry_date	2025-09-20	2025-10-28
5689	126	1	2026-01-16 12:05:35.312541	resume_link	https://drive.google.com/file/45416	https://drive.google.com/file/31080
5690	126	1	2026-01-16 12:05:35.312997	ck_department	ЦК Аналитики	ЦК Инфраструктуры
5691	126	1	2026-01-16 12:05:35.313547	transfer_date	2025-07-18	2025-08-03
5692	126	1	2026-01-16 12:05:35.313992	placement_type	любой	аутстафф
5693	126	1	2026-01-16 12:05:35.314317	current_manager	Иванов А.П.	Михайлова О.Н.
5694	126	1	2026-01-16 12:05:35.314879	target_projects	Госуслуги 2.0, Infrastructure, E-commerce Platform	Infrastructure, Mobile App
5695	126	1	2026-01-16 12:05:35.315408	candidate_status	Увольнение по СЖ	Увольнение по СС
5696	126	1	2026-01-16 12:05:35.315908	funding_end_date	2026-05-20	2026-05-02
5697	126	1	2026-01-16 12:05:35.31621	manager_feedback	Рекомендую	Отличные результаты
5698	126	1	2026-01-16 12:05:35.316663	ready_for_vacancy	Да	Нет
5699	121	1	2026-01-16 12:05:35.340435	hr_bp	Волкова Н.В.	Лебедева Т.М.
5700	121	1	2026-01-16 12:05:35.340971	contacts	+7 (934) 507-47-18, @смиилья55, timur.petrov105@company.ru	+7 (911) 282-41-48, @смиилья84, timur.petrov105@company.ru
5701	121	1	2026-01-16 12:05:35.341447	it_block	Развитие	B2O
5702	121	1	2026-01-16 12:05:35.341958	entry_date	2024-11-12	2024-08-02
5703	121	1	2026-01-16 12:05:35.342448	resume_link	https://drive.google.com/file/87095	https://drive.google.com/file/72509
5704	121	1	2026-01-16 12:05:35.342787	ck_department	ЦК Аналитики	ЦК Инфраструктуры
5705	121	1	2026-01-16 12:05:35.343096	transfer_date	2025-02-03	
5706	121	1	2026-01-16 12:05:35.343794	target_projects	Banking App, ML Pipeline, Data Platform	DevOps Platform, E-commerce Platform, Data Platform
5707	121	1	2026-01-16 12:05:35.344182	candidate_status	Увольнение по СЖ	Свободен
5708	121	1	2026-01-16 12:05:35.344631	funding_end_date	2025-03-12	2025-02-23
5709	313	1	2026-01-16 12:05:35.363702	hr_bp	Лебедева Т.М.	Морозов К.А.
5710	313	1	2026-01-16 12:05:35.364427	comments	В процессе согласования	Срочно нужен проект
5711	313	1	2026-01-16 12:05:35.365067	contacts	+7 (902) 479-18-58, @полольг86, o.polyakova@rt.ru	+7 (978) 950-53-48, @полольг13, o.polyakova@rt.ru
5712	313	1	2026-01-16 12:05:35.365644	recruiter	Новикова Е.П.	Белова И.Д.
5713	313	1	2026-01-16 12:05:35.36621	entry_date	2025-07-27	2024-08-15
5714	313	1	2026-01-16 12:05:35.366744	resume_link	https://drive.google.com/file/31357	https://drive.google.com/file/18092
5715	313	1	2026-01-16 12:05:35.367269	ck_department	Департамент данных	ЦК Аналитики
5716	313	1	2026-01-16 12:05:35.367619	transfer_date	2025-07-10	2026-07-08
5717	313	1	2026-01-16 12:05:35.367968	current_manager	Иванов А.П.	Петров С.М.
5718	313	1	2026-01-16 12:05:35.368477	target_projects	Госуслуги 2.0, Data Platform	DevOps Platform
5719	313	1	2026-01-16 12:05:35.368923	candidate_status	Увольнение по СЖ	Увольнение по СС
5720	313	1	2026-01-16 12:05:35.369564	funding_end_date	2025-09-12	2026-12-22
5721	313	1	2026-01-16 12:05:35.370107	manager_feedback	Отличные результаты	Нужно развитие
5722	313	1	2026-01-16 12:05:35.370556	ready_for_vacancy	Нет	Да
5723	314	1	2026-01-16 12:05:35.390862	hr_bp	Лебедева Т.М.	Волкова Н.В.
5724	314	1	2026-01-16 12:05:35.391432	comments	Срочно нужен проект	Ожидает оффер
5725	314	1	2026-01-16 12:05:35.391956	contacts	+7 (979) 332-54-35, @лебанас45, a.lebedeva@rt.ru	+7 (997) 272-53-13, @лебанас51, a.lebedeva@rt.ru
5726	314	1	2026-01-16 12:05:35.392386	resume_link	https://drive.google.com/file/95942	https://drive.google.com/file/63274
5727	314	1	2026-01-16 12:05:35.392803	ck_department	ЦК Инфраструктуры	Департамент цифровых продуктов
5728	314	1	2026-01-16 12:05:35.393111	transfer_date		2026-11-03
5729	314	1	2026-01-16 12:05:35.393701	placement_type	перевод	аутстафф
5730	314	1	2026-01-16 12:05:35.394182	current_manager	Петров С.М.	Сидорова Е.К.
5731	314	1	2026-01-16 12:05:35.394555	target_projects	DevOps Platform, Data Platform	Infrastructure, Banking App
5732	314	1	2026-01-16 12:05:35.394896	candidate_status	В работе	Переведен
5733	314	1	2026-01-16 12:05:35.395231	funding_end_date	2025-04-11	2026-12-25
5734	314	1	2026-01-16 12:05:35.39562	manager_feedback		Рекомендую
5735	314	1	2026-01-16 12:05:35.395993	ready_for_vacancy	Нет	Да
5736	315	1	2026-01-16 12:05:35.415179	hr_bp	Лебедева Т.М.	Морозов К.А.
5737	315	1	2026-01-16 12:05:35.415886	comments		В процессе согласования
5738	315	1	2026-01-16 12:05:35.416348	contacts	+7 (933) 231-72-84, @винюлия14, yu.vinogradova@rt.ru	+7 (927) 605-74-38, @винюлия25, yu.vinogradova@rt.ru
5739	315	1	2026-01-16 12:05:35.416836	it_block	Диджитал	НУК
5740	315	1	2026-01-16 12:05:35.41731	recruiter	Орлов М.С.	Белова И.Д.
5741	315	1	2026-01-16 12:05:35.417876	entry_date	2025-02-22	2025-12-19
5742	315	1	2026-01-16 12:05:35.418366	resume_link	https://drive.google.com/file/69188	https://drive.google.com/file/61146
5743	315	1	2026-01-16 12:05:35.418966	ck_department	Департамент данных	Департамент цифровых продуктов
5744	315	1	2026-01-16 12:05:35.419564	transfer_date		2025-01-23
5745	315	1	2026-01-16 12:05:35.420167	placement_type	перевод	любой
5746	315	1	2026-01-16 12:05:35.42071	current_manager	Козлов Д.В.	Михайлова О.Н.
5747	315	1	2026-01-16 12:05:35.421592	target_projects	DevOps Platform, Mobile App	DevOps Platform, Infrastructure
5748	315	1	2026-01-16 12:05:35.422192	candidate_status	Свободен	Переведен
5749	315	1	2026-01-16 12:05:35.422717	funding_end_date	2025-06-19	2025-05-31
5750	315	1	2026-01-16 12:05:35.423261	manager_feedback	Хороший специалист	Отличные результаты
5751	315	1	2026-01-16 12:05:35.423771	ready_for_vacancy	Да	Нет
5752	316	1	2026-01-16 12:05:35.441638	hr_bp	Морозов К.А.	Волкова Н.В.
5753	316	1	2026-01-16 12:05:35.44227	contacts	+7 (968) 891-47-99, @яковикт66, v.yakovleva@rt.ru	+7 (969) 659-67-15, @яковикт70, v.yakovleva@rt.ru
5754	316	1	2026-01-16 12:05:35.442865	it_block	НУК	Развитие
5755	316	1	2026-01-16 12:05:35.443404	recruiter	Орлов М.С.	Белова И.Д.
5756	316	1	2026-01-16 12:05:35.443864	entry_date	2025-02-07	2024-08-19
5757	316	1	2026-01-16 12:05:35.444186	resume_link	https://drive.google.com/file/20560	https://drive.google.com/file/93135
5758	316	1	2026-01-16 12:05:35.444484	transfer_date		2026-09-22
5759	316	1	2026-01-16 12:05:35.444769	placement_type	аутстафф	перевод
5760	316	1	2026-01-16 12:05:35.445053	target_projects	ML Pipeline	Mobile App
5761	316	1	2026-01-16 12:05:35.445533	candidate_status	Забронирован	Переведен
5762	316	1	2026-01-16 12:05:35.445872	funding_end_date	2025-07-09	2025-03-15
5763	316	1	2026-01-16 12:05:35.446157	manager_feedback	Хороший специалист	Рекомендую
5764	316	1	2026-01-16 12:05:35.446439	ready_for_vacancy	Нет	Да
5765	318	1	2026-01-16 12:05:35.466672	hr_bp	Морозов К.А.	Волкова Н.В.
5766	318	1	2026-01-16 12:05:35.467154	comments	В процессе согласования	Срочно нужен проект
5767	318	1	2026-01-16 12:05:35.4675	contacts	+7 (960) 110-52-59, @гриматв10, m.grigorev@rt.ru	+7 (961) 927-48-93, @гриматв4, m.grigorev@rt.ru
5768	318	1	2026-01-16 12:05:35.467816	it_block	Диджитал	Прочее
5769	318	1	2026-01-16 12:05:35.468386	recruiter	Орлов М.С.	Смирнова А.А.
5770	318	1	2026-01-16 12:05:35.469507	entry_date	2025-09-16	2025-10-07
5771	318	1	2026-01-16 12:05:35.469866	resume_link	https://drive.google.com/file/91742	https://drive.google.com/file/96971
5772	318	1	2026-01-16 12:05:35.470305	ck_department	ЦК Аналитики	Департамент данных
5773	318	1	2026-01-16 12:05:35.470773	transfer_date		2026-12-14
5774	318	1	2026-01-16 12:05:35.471208	placement_type	перевод	аутстафф
5775	318	1	2026-01-16 12:05:35.471522	current_manager	Михайлова О.Н.	Козлов Д.В.
5776	318	1	2026-01-16 12:05:35.471812	target_projects	Infrastructure, Госуслуги 2.0, Mobile App	Госуслуги 2.0, Data Platform
5777	318	1	2026-01-16 12:05:35.472163	candidate_status	В работе	Переведен
5778	318	1	2026-01-16 12:05:35.472454	funding_end_date	2026-08-17	2026-03-14
5779	318	1	2026-01-16 12:05:35.472734	manager_feedback	Отличные результаты	Нужно развитие
5780	318	1	2026-01-16 12:05:35.473014	ready_for_vacancy	Нет	Да
5781	319	1	2026-01-16 12:05:35.492597	comments	Срочно нужен проект	
5782	319	1	2026-01-16 12:05:35.493307	contacts	+7 (933) 178-50-56, @андкири95, k.andreev@rt.ru	+7 (952) 381-27-67, @андкири68, k.andreev@rt.ru
5783	319	1	2026-01-16 12:05:35.493797	it_block	НУК	Диджитал
5784	319	1	2026-01-16 12:05:35.494154	recruiter	Новикова Е.П.	Белова И.Д.
5785	319	1	2026-01-16 12:05:35.494456	entry_date	2025-10-04	2024-03-09
5786	319	1	2026-01-16 12:05:35.494743	resume_link	https://drive.google.com/file/98149	https://drive.google.com/file/48546
5787	319	1	2026-01-16 12:05:35.495028	ck_department	ЦК Аналитики	ЦК Инфраструктуры
5788	319	1	2026-01-16 12:05:35.495303	target_projects	ML Pipeline, Banking App	Infrastructure
5789	319	1	2026-01-16 12:05:35.495574	candidate_status	В работе	Забронирован
5790	319	1	2026-01-16 12:05:35.495845	funding_end_date	2026-12-30	2026-12-18
5791	319	1	2026-01-16 12:05:35.496116	manager_feedback	Рекомендую	Хороший специалист
5857	136	1	2026-01-16 12:05:35.623105	funding_end_date	2026-11-19	2025-06-09
5792	321	1	2026-01-16 12:05:35.515271	hr_bp	Лебедева Т.М.	Морозов К.А.
5793	321	1	2026-01-16 12:05:35.516211	comments		В процессе согласования
5794	321	1	2026-01-16 12:05:35.516619	contacts	+7 (994) 234-74-53, @никвикт37, v.nikitina@rt.ru	+7 (988) 671-58-19, @никвикт64, v.nikitina@rt.ru
5795	321	1	2026-01-16 12:05:35.516997	it_block	Эксплуатация	Диджитал
5796	321	1	2026-01-16 12:05:35.517402	entry_date	2024-04-16	2024-02-13
5797	321	1	2026-01-16 12:05:35.51778	resume_link	https://drive.google.com/file/27949	https://drive.google.com/file/37610
5798	321	1	2026-01-16 12:05:35.518531	ck_department	ЦК Инфраструктуры	ЦК Аналитики
5799	321	1	2026-01-16 12:05:35.519299	placement_type	перевод	аутстафф
5800	321	1	2026-01-16 12:05:35.520126	current_manager	Михайлова О.Н.	Петров С.М.
5801	321	1	2026-01-16 12:05:35.520817	target_projects	Infrastructure, DevOps Platform, Госуслуги 2.0	Госуслуги 2.0, Mobile App, Banking App
5802	321	1	2026-01-16 12:05:35.521465	candidate_status	Забронирован	Свободен
5803	321	1	2026-01-16 12:05:35.522107	funding_end_date	2025-10-02	2026-08-22
5804	321	1	2026-01-16 12:05:35.522591	manager_feedback	Отличные результаты	
5805	321	1	2026-01-16 12:05:35.523061	ready_for_vacancy	Нет	Да
5806	322	1	2026-01-16 12:05:35.540385	hr_bp	Морозов К.А.	Лебедева Т.М.
5807	322	1	2026-01-16 12:05:35.541053	contacts	+7 (906) 578-82-54, @андирин13, i.andreeva@rt.ru	+7 (966) 507-95-57, @андирин44, i.andreeva@rt.ru
5808	322	1	2026-01-16 12:05:35.541515	it_block	НУК	Эксплуатация
5809	322	1	2026-01-16 12:05:35.541837	recruiter	Новикова Е.П.	Орлов М.С.
5810	322	1	2026-01-16 12:05:35.542138	entry_date	2024-01-06	2025-06-13
5811	322	1	2026-01-16 12:05:35.54242	resume_link	https://drive.google.com/file/10102	https://drive.google.com/file/58490
5812	322	1	2026-01-16 12:05:35.542703	ck_department	ЦК Инфраструктуры	Департамент данных
5813	322	1	2026-01-16 12:05:35.54308	transfer_date	2025-05-09	
5814	322	1	2026-01-16 12:05:35.543571	placement_type	перевод	аутстафф
5815	322	1	2026-01-16 12:05:35.54393	target_projects	ML Pipeline, Banking App	Banking App
5816	322	1	2026-01-16 12:05:35.544219	candidate_status	Увольнение по СС	Свободен
5817	322	1	2026-01-16 12:05:35.544494	funding_end_date	2026-08-23	2025-04-11
5818	322	1	2026-01-16 12:05:35.544767	manager_feedback	Рекомендую	
5819	322	1	2026-01-16 12:05:35.545039	ready_for_vacancy	Да	Нет
5820	324	1	2026-01-16 12:05:35.562361	hr_bp	Морозов К.А.	Волкова Н.В.
5821	324	1	2026-01-16 12:05:35.562962	comments	Срочно нужен проект	
5822	324	1	2026-01-16 12:05:35.563365	contacts	+7 (962) 867-80-17, @кисевге75, e.kiselev@rt.ru	+7 (916) 871-65-89, @кисевге56, e.kiselev@rt.ru
5823	324	1	2026-01-16 12:05:35.563679	it_block	Прочее	Эксплуатация
5824	324	1	2026-01-16 12:05:35.563973	recruiter	Белова И.Д.	Орлов М.С.
5825	324	1	2026-01-16 12:05:35.564262	entry_date	2024-02-02	2025-08-17
5826	324	1	2026-01-16 12:05:35.564554	resume_link	https://drive.google.com/file/44356	https://drive.google.com/file/15689
5827	324	1	2026-01-16 12:05:35.564834	transfer_date	2026-06-03	2026-05-31
5828	324	1	2026-01-16 12:05:35.5652	placement_type	аутстафф	перевод
5829	324	1	2026-01-16 12:05:35.56567	current_manager	Иванов А.П.	Михайлова О.Н.
5830	324	1	2026-01-16 12:05:35.566015	target_projects	DevOps Platform, Banking App, Mobile App	Banking App, DevOps Platform
5831	324	1	2026-01-16 12:05:35.566311	candidate_status	Увольнение по СС	Увольнение по СЖ
5832	324	1	2026-01-16 12:05:35.566813	funding_end_date	2025-03-29	2026-03-18
5833	324	1	2026-01-16 12:05:35.567231	manager_feedback	Отличные результаты	
5834	119	1	2026-01-16 12:05:35.592821	comments	Ожидает оффер	В процессе согласования
5835	119	1	2026-01-16 12:05:35.593385	contacts	+7 (972) 935-11-69, @семкири58, petr.korolev103@company.ru	+7 (952) 217-52-53, @семкири51, petr.korolev103@company.ru
5836	119	1	2026-01-16 12:05:35.593825	it_block	Эксплуатация	Диджитал
5837	119	1	2026-01-16 12:05:35.594186	recruiter	Новикова Е.П.	Орлов М.С.
5838	119	1	2026-01-16 12:05:35.594692	entry_date	2025-06-05	2025-03-28
5839	119	1	2026-01-16 12:05:35.595029	resume_link	https://drive.google.com/file/42991	https://drive.google.com/file/97306
5840	119	1	2026-01-16 12:05:35.595341	ck_department	ЦК Разработки	ЦК Аналитики
5841	119	1	2026-01-16 12:05:35.59574	transfer_date	2026-06-26	2026-01-31
5842	119	1	2026-01-16 12:05:35.596159	placement_type	любой	аутстафф
5843	119	1	2026-01-16 12:05:35.596636	current_manager	Михайлова О.Н.	Иванов А.П.
5844	119	1	2026-01-16 12:05:35.597032	target_projects	ML Pipeline, DevOps Platform, Banking App	E-commerce Platform
5845	119	1	2026-01-16 12:05:35.597417	candidate_status	Увольнение по СЖ	Переведен
5846	119	1	2026-01-16 12:05:35.597801	funding_end_date	2026-11-10	2026-01-10
5847	119	1	2026-01-16 12:05:35.598133	manager_feedback	Хороший специалист	Отличные результаты
5848	136	1	2026-01-16 12:05:35.61779	contacts	+7 (954) 743-43-94, @смиилья15, denis.sokolov120@company.ru	+7 (942) 796-70-77, @смиилья59, denis.sokolov120@company.ru
5849	136	1	2026-01-16 12:05:35.618624	it_block	Прочее	B2O
5850	136	1	2026-01-16 12:05:35.619374	entry_date	2024-06-04	2025-03-31
5851	136	1	2026-01-16 12:05:35.619895	resume_link	https://drive.google.com/file/64988	https://drive.google.com/file/56674
5852	136	1	2026-01-16 12:05:35.620663	ck_department	Департамент цифровых продуктов	ЦК Инфраструктуры
5853	136	1	2026-01-16 12:05:35.621222	placement_type	перевод	любой
5854	136	1	2026-01-16 12:05:35.621844	current_manager	Петров С.М.	Козлов Д.В.
5855	136	1	2026-01-16 12:05:35.622285	target_projects	DevOps Platform, Infrastructure	ML Pipeline
5856	136	1	2026-01-16 12:05:35.6227	candidate_status	Свободен	Забронирован
5858	136	1	2026-01-16 12:05:35.623805	manager_feedback		Хороший специалист
5859	136	1	2026-01-16 12:05:35.624617	ready_for_vacancy	Нет	Да
5860	129	1	2026-01-16 12:05:35.651993	comments		Ожидает оффер
5861	129	1	2026-01-16 12:05:35.653045	contacts	+7 (982) 857-94-70, @фёдсерг17, anna.alexeev113@company.ru	+7 (951) 221-23-54, @фёдсерг9, anna.alexeev113@company.ru
5862	129	1	2026-01-16 12:05:35.653979	it_block	Развитие	Диджитал
5863	129	1	2026-01-16 12:05:35.654674	recruiter	Смирнова А.А.	Белова И.Д.
5864	129	1	2026-01-16 12:05:35.655177	entry_date	2024-07-02	2025-05-22
5865	129	1	2026-01-16 12:05:35.65564	resume_link	https://drive.google.com/file/16736	https://drive.google.com/file/47708
5866	129	1	2026-01-16 12:05:35.656097	ck_department	Департамент данных	Департамент цифровых продуктов
5867	129	1	2026-01-16 12:05:35.656554	transfer_date	2025-11-12	
5868	129	1	2026-01-16 12:05:35.657006	placement_type	перевод	аутстафф
5869	129	1	2026-01-16 12:05:35.657545	current_manager	Козлов Д.В.	Михайлова О.Н.
5870	129	1	2026-01-16 12:05:35.658037	target_projects	Banking App, Госуслуги 2.0	Banking App, E-commerce Platform, Госуслуги 2.0
5871	129	1	2026-01-16 12:05:35.65851	candidate_status	Переведен	Забронирован
5872	129	1	2026-01-16 12:05:35.658999	funding_end_date	2025-12-30	2025-06-15
5873	129	1	2026-01-16 12:05:35.659979	manager_feedback	Отличные результаты	Хороший специалист
5874	134	1	2026-01-16 12:05:35.692295	comments	В процессе согласования	Срочно нужен проект
5875	134	1	2026-01-16 12:05:35.693316	contacts	+7 (999) 171-26-96, @семкири19, vadim.zakharov118@company.ru	+7 (998) 803-63-11, @семкири4, vadim.zakharov118@company.ru
5876	134	1	2026-01-16 12:05:35.694327	it_block	B2O	Прочее
5877	134	1	2026-01-16 12:05:35.69528	entry_date	2025-02-28	2024-07-22
5878	134	1	2026-01-16 12:05:35.696055	resume_link	https://drive.google.com/file/41153	https://drive.google.com/file/93017
5879	134	1	2026-01-16 12:05:35.696809	ck_department	Департамент цифровых продуктов	ЦК Аналитики
5880	134	1	2026-01-16 12:05:35.697387	transfer_date	2025-10-01	
5881	134	1	2026-01-16 12:05:35.697818	placement_type	перевод	аутстафф
5882	134	1	2026-01-16 12:05:35.698178	current_manager	Сидорова Е.К.	Иванов А.П.
5883	134	1	2026-01-16 12:05:35.698512	target_projects	Banking App, ML Pipeline, E-commerce Platform	Mobile App
5884	134	1	2026-01-16 12:05:35.698849	candidate_status	Увольнение по СС	В работе
5885	134	1	2026-01-16 12:05:35.699528	funding_end_date	2026-08-01	2025-07-14
5886	134	1	2026-01-16 12:05:35.700348	manager_feedback	Отличные результаты	Хороший специалист
5887	134	1	2026-01-16 12:05:35.700974	ready_for_vacancy	Да	Нет
5888	327	1	2026-01-16 12:05:35.738342	hr_bp	Волкова Н.В.	Морозов К.А.
5889	327	1	2026-01-16 12:05:35.739232	contacts	+7 (968) 479-57-93, @белелен83, e.belova@rt.ru	+7 (979) 700-67-45, @белелен65, e.belova@rt.ru
5890	327	1	2026-01-16 12:05:35.739847	it_block	НУК	Развитие
5891	327	1	2026-01-16 12:05:35.740748	entry_date	2025-07-07	2024-08-09
5892	327	1	2026-01-16 12:05:35.74148	resume_link	https://drive.google.com/file/92122	https://drive.google.com/file/35351
5893	327	1	2026-01-16 12:05:35.741906	ck_department	ЦК Аналитики	ЦК Разработки
5894	327	1	2026-01-16 12:05:35.742394	transfer_date		2026-09-17
5895	327	1	2026-01-16 12:05:35.742898	placement_type	перевод	любой
5896	327	1	2026-01-16 12:05:35.74358	current_manager	Петров С.М.	Михайлова О.Н.
5897	327	1	2026-01-16 12:05:35.744235	target_projects	Mobile App, Infrastructure, Data Platform	Infrastructure, DevOps Platform
5898	327	1	2026-01-16 12:05:35.744622	candidate_status	Забронирован	Увольнение по СЖ
5899	327	1	2026-01-16 12:05:35.745197	funding_end_date	2025-01-03	2026-09-16
5900	327	1	2026-01-16 12:05:35.745622	manager_feedback	Хороший специалист	
5901	328	1	2026-01-16 12:05:35.774481	hr_bp	Лебедева Т.М.	Волкова Н.В.
5902	328	1	2026-01-16 12:05:35.775061	comments	В процессе согласования	
5903	328	1	2026-01-16 12:05:35.777632	contacts	+7 (987) 726-54-15, @захбогд55, b.zakharov@rt.ru	+7 (959) 437-28-12, @захбогд81, b.zakharov@rt.ru
5904	328	1	2026-01-16 12:05:35.778315	it_block	Развитие	Диджитал
5905	328	1	2026-01-16 12:05:35.778831	recruiter	Смирнова А.А.	Белова И.Д.
5906	328	1	2026-01-16 12:05:35.77958	entry_date	2024-12-11	2024-04-10
5907	328	1	2026-01-16 12:05:35.780299	resume_link	https://drive.google.com/file/94034	https://drive.google.com/file/38625
5908	328	1	2026-01-16 12:05:35.781101	ck_department	ЦК Разработки	ЦК Инфраструктуры
5909	328	1	2026-01-16 12:05:35.781893	transfer_date	2026-10-16	
5910	328	1	2026-01-16 12:05:35.782414	target_projects	ML Pipeline, Infrastructure	Infrastructure
5911	328	1	2026-01-16 12:05:35.782937	candidate_status	Увольнение по СЖ	Забронирован
5912	328	1	2026-01-16 12:05:35.78381	funding_end_date	2026-03-28	2025-04-06
5913	328	1	2026-01-16 12:05:35.784907	manager_feedback		Хороший специалист
5914	114	1	2026-01-16 12:05:35.809557	hr_bp	Морозов К.А.	Волкова Н.В.
5915	114	1	2026-01-16 12:05:35.810399	comments	Срочно нужен проект	Ожидает оффер
5916	114	1	2026-01-16 12:05:35.81136	contacts	+7 (968) 475-29-75, @фёдсерг17, yaroslav.pavlov98@company.ru	+7 (954) 831-37-47, @фёдсерг41, yaroslav.pavlov98@company.ru
5917	114	1	2026-01-16 12:05:35.812084	it_block	Развитие	Прочее
5918	114	1	2026-01-16 12:05:35.812646	entry_date	2025-06-22	2024-12-17
5919	114	1	2026-01-16 12:05:35.813392	resume_link	https://drive.google.com/file/83136	https://drive.google.com/file/39769
5920	114	1	2026-01-16 12:05:35.814115	ck_department	ЦК Аналитики	Департамент цифровых продуктов
5921	114	1	2026-01-16 12:05:35.814818	placement_type	перевод	аутстафф
5922	114	1	2026-01-16 12:05:35.815299	current_manager	Михайлова О.Н.	Козлов Д.В.
5923	114	1	2026-01-16 12:05:35.8158	target_projects	Mobile App, E-commerce Platform	Data Platform
5924	114	1	2026-01-16 12:05:35.816249	candidate_status	Свободен	Забронирован
5925	114	1	2026-01-16 12:05:35.816719	funding_end_date	2025-01-01	2025-12-09
5926	116	1	2026-01-16 12:05:35.846151	comments	Ожидает оффер	
5927	116	1	2026-01-16 12:05:35.846637	contacts	+7 (969) 336-41-75, @волмакс8, ruslan.zakharov100@company.ru	+7 (926) 415-64-71, @волмакс13, ruslan.zakharov100@company.ru
5928	116	1	2026-01-16 12:05:35.847143	entry_date	2025-03-29	2025-05-21
5929	116	1	2026-01-16 12:05:35.847736	resume_link	https://drive.google.com/file/83025	https://drive.google.com/file/86334
5930	116	1	2026-01-16 12:05:35.848187	ck_department	ЦК Аналитики	ЦК Разработки
5931	116	1	2026-01-16 12:05:35.848526	transfer_date	2026-09-27	2026-03-14
5932	116	1	2026-01-16 12:05:35.848825	placement_type	аутстафф	перевод
5933	116	1	2026-01-16 12:05:35.849166	current_manager	Иванов А.П.	Петров С.М.
5934	116	1	2026-01-16 12:05:35.849816	target_projects	ML Pipeline	E-commerce Platform, Data Platform, DevOps Platform
5935	116	1	2026-01-16 12:05:35.85016	candidate_status	Увольнение по СС	Переведен
5936	116	1	2026-01-16 12:05:35.850451	funding_end_date	2026-06-21	2026-09-01
5937	116	1	2026-01-16 12:05:35.850728	manager_feedback	Нужно развитие	
5938	329	1	2026-01-16 12:05:35.875483	comments	Срочно нужен проект	
5939	329	1	2026-01-16 12:05:35.876053	contacts	+7 (977) 687-76-27, @вормарк29, m.vorobev@rt.ru	+7 (961) 822-46-23, @вормарк93, m.vorobev@rt.ru
5940	329	1	2026-01-16 12:05:35.876409	it_block	Диджитал	НУК
5941	329	1	2026-01-16 12:05:35.876712	recruiter	Смирнова А.А.	Новикова Е.П.
5942	329	1	2026-01-16 12:05:35.876999	entry_date	2024-01-19	2024-09-06
5943	329	1	2026-01-16 12:05:35.877374	resume_link	https://drive.google.com/file/49912	https://drive.google.com/file/55307
5944	329	1	2026-01-16 12:05:35.877861	ck_department	ЦК Инфраструктуры	ЦК Аналитики
5945	329	1	2026-01-16 12:05:35.878205	placement_type	аутстафф	перевод
5946	329	1	2026-01-16 12:05:35.878503	current_manager	Иванов А.П.	Козлов Д.В.
5947	329	1	2026-01-16 12:05:35.878788	target_projects	ML Pipeline	Banking App, Infrastructure, Data Platform
5948	329	1	2026-01-16 12:05:35.879069	candidate_status	Забронирован	Свободен
5949	329	1	2026-01-16 12:05:35.879347	funding_end_date	2026-09-11	2026-01-19
5950	329	1	2026-01-16 12:05:35.879628	manager_feedback		Нужно развитие
5951	137	1	2026-01-16 12:05:35.897674	hr_bp	Волкова Н.В.	Лебедева Т.М.
5952	137	1	2026-01-16 12:05:35.898152	contacts	+7 (944) 598-52-97, @куздени4, ilya.ivanov121@company.ru	+7 (907) 795-81-87, @куздени59, ilya.ivanov121@company.ru
5953	137	1	2026-01-16 12:05:35.898513	it_block	Эксплуатация	Развитие
5954	137	1	2026-01-16 12:05:35.898823	recruiter	Белова И.Д.	Новикова Е.П.
5955	137	1	2026-01-16 12:05:35.899115	entry_date	2024-10-07	2024-02-14
5956	137	1	2026-01-16 12:05:35.899387	resume_link	https://drive.google.com/file/24186	https://drive.google.com/file/14434
5957	137	1	2026-01-16 12:05:35.899669	ck_department	Департамент цифровых продуктов	ЦК Аналитики
5958	137	1	2026-01-16 12:05:35.89994	placement_type	любой	аутстафф
5959	137	1	2026-01-16 12:05:35.900255	current_manager	Петров С.М.	Иванов А.П.
5960	137	1	2026-01-16 12:05:35.900547	target_projects	ML Pipeline, Data Platform	Госуслуги 2.0
5961	137	1	2026-01-16 12:05:35.900815	candidate_status	Забронирован	В работе
5962	137	1	2026-01-16 12:05:35.901083	funding_end_date	2025-07-23	2025-09-02
5963	137	1	2026-01-16 12:05:35.901736	manager_feedback	Хороший специалист	Рекомендую
5964	137	1	2026-01-16 12:05:35.902532	ready_for_vacancy	Да	Нет
5965	147	1	2026-01-16 12:05:35.924877	hr_bp	Лебедева Т.М.	Морозов К.А.
5966	147	1	2026-01-16 12:05:35.926173	comments		Ожидает оффер
5967	147	1	2026-01-16 12:05:35.927141	contacts	+7 (946) 455-70-36, @алемиха17, mikhail.grigoriev131@company.ru	+7 (961) 278-80-47, @алемиха52, mikhail.grigoriev131@company.ru
5968	147	1	2026-01-16 12:05:35.927849	it_block	НУК	Диджитал
5969	147	1	2026-01-16 12:05:35.928696	recruiter	Белова И.Д.	Орлов М.С.
5970	147	1	2026-01-16 12:05:35.930411	entry_date	2025-03-18	2025-04-21
5971	147	1	2026-01-16 12:05:35.931364	resume_link	https://drive.google.com/file/98151	https://drive.google.com/file/28616
5972	147	1	2026-01-16 12:05:35.932258	transfer_date	2025-01-19	2026-09-12
5973	147	1	2026-01-16 12:05:35.933348	current_manager	Сидорова Е.К.	Козлов Д.В.
5974	147	1	2026-01-16 12:05:35.934136	target_projects	DevOps Platform, ML Pipeline	ML Pipeline
5975	147	1	2026-01-16 12:05:35.934663	candidate_status	Увольнение по СЖ	Увольнение по СС
5976	147	1	2026-01-16 12:05:35.935396	funding_end_date	2026-08-30	2025-02-20
5977	147	1	2026-01-16 12:05:35.935982	manager_feedback	Хороший специалист	
5978	330	1	2026-01-16 12:05:35.961907	comments	В процессе согласования	
5979	330	1	2026-01-16 12:05:35.962646	contacts	+7 (999) 724-52-90, @зайалек81, a.zaytsev@rt.ru	+7 (978) 258-56-16, @зайалек3, a.zaytsev@rt.ru
5980	330	1	2026-01-16 12:05:35.963152	it_block	Эксплуатация	Диджитал
5981	330	1	2026-01-16 12:05:35.963727	entry_date	2024-09-23	2025-05-22
5982	330	1	2026-01-16 12:05:35.965016	resume_link	https://drive.google.com/file/72730	https://drive.google.com/file/96591
5983	330	1	2026-01-16 12:05:35.965524	ck_department	Департамент цифровых продуктов	Департамент данных
5984	330	1	2026-01-16 12:05:35.96628	transfer_date	2025-10-20	
5985	330	1	2026-01-16 12:05:35.966816	placement_type	перевод	аутстафф
5986	330	1	2026-01-16 12:05:35.967153	target_projects	Госуслуги 2.0, Infrastructure, ML Pipeline	Госуслуги 2.0, E-commerce Platform
5987	330	1	2026-01-16 12:05:35.967616	candidate_status	Переведен	В работе
5988	330	1	2026-01-16 12:05:35.968423	funding_end_date	2025-07-31	2025-10-01
5989	330	1	2026-01-16 12:05:35.96886	manager_feedback	Рекомендую	Отличные результаты
5990	332	1	2026-01-16 12:05:35.991124	hr_bp	Волкова Н.В.	Морозов К.А.
5991	332	1	2026-01-16 12:05:35.992131	contacts	+7 (930) 399-59-55, @смиалин12, a.smirnova@rt.ru	+7 (993) 877-51-40, @смиалин74, a.smirnova@rt.ru
5992	332	1	2026-01-16 12:05:35.992794	it_block	Эксплуатация	Диджитал
5993	332	1	2026-01-16 12:05:35.99333	recruiter	Смирнова А.А.	Белова И.Д.
5994	332	1	2026-01-16 12:05:35.993972	entry_date	2024-06-05	2025-07-10
5995	332	1	2026-01-16 12:05:35.994852	resume_link	https://drive.google.com/file/48921	https://drive.google.com/file/48066
5996	332	1	2026-01-16 12:05:35.995652	ck_department	ЦК Инфраструктуры	Департамент данных
5997	332	1	2026-01-16 12:05:35.996248	transfer_date	2025-02-27	2026-05-27
5998	332	1	2026-01-16 12:05:35.99703	current_manager	Сидорова Е.К.	Михайлова О.Н.
5999	332	1	2026-01-16 12:05:35.998086	target_projects	Mobile App	Госуслуги 2.0, Mobile App, DevOps Platform
6000	332	1	2026-01-16 12:05:35.998799	candidate_status	Увольнение по СС	Увольнение по СЖ
6001	332	1	2026-01-16 12:05:35.999397	funding_end_date	2025-05-18	2026-09-29
6002	332	1	2026-01-16 12:05:35.99984	manager_feedback	Хороший специалист	Отличные результаты
6003	332	1	2026-01-16 12:05:36.000505	ready_for_vacancy	Да	Нет
6004	334	1	2026-01-16 12:05:36.028382	hr_bp	Морозов К.А.	Волкова Н.В.
6005	334	1	2026-01-16 12:05:36.02928	contacts	+7 (958) 539-60-14, @захалек65, a.zakharov@rt.ru	+7 (933) 760-27-81, @захалек63, a.zakharov@rt.ru
6006	334	1	2026-01-16 12:05:36.030053	it_block	Диджитал	НУК
6007	334	1	2026-01-16 12:05:36.03056	recruiter	Орлов М.С.	Смирнова А.А.
6008	334	1	2026-01-16 12:05:36.031008	entry_date	2024-06-03	2025-10-18
6009	334	1	2026-01-16 12:05:36.031448	resume_link	https://drive.google.com/file/83521	https://drive.google.com/file/62760
6010	334	1	2026-01-16 12:05:36.031891	ck_department	ЦК Разработки	ЦК Аналитики
6011	334	1	2026-01-16 12:05:36.032328	transfer_date	2026-05-09	2026-12-30
6012	334	1	2026-01-16 12:05:36.032842	placement_type	аутстафф	любой
6013	334	1	2026-01-16 12:05:36.033502	current_manager	Козлов Д.В.	Иванов А.П.
6014	334	1	2026-01-16 12:05:36.03411	target_projects	E-commerce Platform, DevOps Platform, Mobile App	ML Pipeline, Госуслуги 2.0, DevOps Platform
6015	334	1	2026-01-16 12:05:36.03466	funding_end_date	2026-11-10	2025-09-15
6016	334	1	2026-01-16 12:05:36.03564	manager_feedback	Нужно развитие	Отличные результаты
6017	336	1	2026-01-16 12:05:36.059435	comments	Ожидает оффер	
6018	336	1	2026-01-16 12:05:36.059945	contacts	+7 (955) 180-12-95, @тарксен91, k.tarasova@rt.ru	+7 (936) 643-43-49, @тарксен20, k.tarasova@rt.ru
6019	336	1	2026-01-16 12:05:36.060309	it_block	Эксплуатация	B2O
6020	336	1	2026-01-16 12:05:36.060691	recruiter	Орлов М.С.	Белова И.Д.
6021	336	1	2026-01-16 12:05:36.061178	entry_date	2025-07-15	2024-01-20
6022	336	1	2026-01-16 12:05:36.062429	resume_link	https://drive.google.com/file/34014	https://drive.google.com/file/91074
6023	336	1	2026-01-16 12:05:36.062856	ck_department	Департамент данных	Департамент цифровых продуктов
6024	336	1	2026-01-16 12:05:36.063327	transfer_date		2025-06-25
6025	336	1	2026-01-16 12:05:36.063768	placement_type	любой	аутстафф
6026	336	1	2026-01-16 12:05:36.064129	target_projects	Data Platform	ML Pipeline
6027	336	1	2026-01-16 12:05:36.064474	candidate_status	Забронирован	Увольнение по СС
6028	336	1	2026-01-16 12:05:36.065028	funding_end_date	2025-01-17	2026-03-07
6029	336	1	2026-01-16 12:05:36.065706	manager_feedback	Нужно развитие	Рекомендую
6030	337	1	2026-01-16 12:05:36.086243	hr_bp	Лебедева Т.М.	Морозов К.А.
6031	337	1	2026-01-16 12:05:36.087073	comments		Срочно нужен проект
6032	337	1	2026-01-16 12:05:36.087592	contacts	+7 (954) 898-89-11, @меданто84, a.medvedev@rt.ru	+7 (997) 883-67-97, @меданто62, a.medvedev@rt.ru
6033	337	1	2026-01-16 12:05:36.088043	it_block	Прочее	B2O
6034	337	1	2026-01-16 12:05:36.088652	entry_date	2025-08-28	2025-01-20
6035	337	1	2026-01-16 12:05:36.089315	resume_link	https://drive.google.com/file/42964	https://drive.google.com/file/54482
6036	337	1	2026-01-16 12:05:36.090848	ck_department	ЦК Аналитики	Департамент данных
6037	337	1	2026-01-16 12:05:36.091378	transfer_date	2025-09-09	2026-04-02
6038	337	1	2026-01-16 12:05:36.092107	placement_type	аутстафф	любой
6039	337	1	2026-01-16 12:05:36.092785	current_manager	Сидорова Е.К.	Иванов А.П.
6040	337	1	2026-01-16 12:05:36.093345	target_projects	E-commerce Platform, Госуслуги 2.0	Mobile App
6041	337	1	2026-01-16 12:05:36.094016	funding_end_date	2025-04-09	2026-05-22
6042	337	1	2026-01-16 12:05:36.094689	manager_feedback	Рекомендую	Нужно развитие
6043	337	1	2026-01-16 12:05:36.095249	ready_for_vacancy	Нет	Да
6044	339	1	2026-01-16 12:05:36.124812	hr_bp	Морозов К.А.	Лебедева Т.М.
6045	339	1	2026-01-16 12:05:36.126294	contacts	+7 (999) 240-10-43, @антстеп81, s.antonov@rt.ru	+7 (906) 892-82-44, @антстеп78, s.antonov@rt.ru
6046	339	1	2026-01-16 12:05:36.12717	it_block	Развитие	Прочее
6047	339	1	2026-01-16 12:05:36.128031	recruiter	Белова И.Д.	Новикова Е.П.
6048	339	1	2026-01-16 12:05:36.129129	entry_date	2025-01-27	2024-12-24
6049	339	1	2026-01-16 12:05:36.130319	resume_link	https://drive.google.com/file/17968	https://drive.google.com/file/24090
6050	339	1	2026-01-16 12:05:36.131326	ck_department	Департамент данных	ЦК Аналитики
6051	339	1	2026-01-16 12:05:36.132258	transfer_date	2025-09-30	
6052	339	1	2026-01-16 12:05:36.133294	placement_type	аутстафф	перевод
6053	339	1	2026-01-16 12:05:36.134122	current_manager	Иванов А.П.	Петров С.М.
6054	339	1	2026-01-16 12:05:36.135019	target_projects	Mobile App, DevOps Platform, E-commerce Platform	Infrastructure, Mobile App, Data Platform
6055	339	1	2026-01-16 12:05:36.135669	candidate_status	Увольнение по СС	Забронирован
6056	339	1	2026-01-16 12:05:36.13647	funding_end_date	2025-01-13	2025-10-02
6057	339	1	2026-01-16 12:05:36.137545	manager_feedback		Нужно развитие
6058	340	1	2026-01-16 12:05:36.166018	hr_bp	Морозов К.А.	Лебедева Т.М.
6059	340	1	2026-01-16 12:05:36.16673	comments		Срочно нужен проект
6060	340	1	2026-01-16 12:05:36.167234	contacts	+7 (993) 461-91-88, @моранас51, a.morozova@rt.ru	+7 (984) 519-44-89, @моранас54, a.morozova@rt.ru
6061	340	1	2026-01-16 12:05:36.167826	it_block	НУК	Эксплуатация
6062	340	1	2026-01-16 12:05:36.168534	recruiter	Смирнова А.А.	Новикова Е.П.
6063	340	1	2026-01-16 12:05:36.16918	entry_date	2025-03-17	2025-07-01
6064	340	1	2026-01-16 12:05:36.169683	resume_link	https://drive.google.com/file/37582	https://drive.google.com/file/70716
6065	340	1	2026-01-16 12:05:36.170182	ck_department	Департамент цифровых продуктов	ЦК Аналитики
6066	340	1	2026-01-16 12:05:36.170598	transfer_date	2026-01-07	2026-04-03
6067	340	1	2026-01-16 12:05:36.171166	placement_type	аутстафф	любой
6068	340	1	2026-01-16 12:05:36.171695	target_projects	Mobile App, Infrastructure	Mobile App, ML Pipeline
6069	340	1	2026-01-16 12:05:36.172206	candidate_status	Увольнение по СЖ	Переведен
6070	340	1	2026-01-16 12:05:36.172748	funding_end_date	2025-08-09	2025-05-20
6071	342	1	2026-01-16 12:05:36.200723	comments	Срочно нужен проект	
6072	342	1	2026-01-16 12:05:36.201331	contacts	+7 (929) 891-53-52, @винмари2, m.vinogradova@rt.ru	+7 (977) 488-39-97, @винмари86, m.vinogradova@rt.ru
6073	342	1	2026-01-16 12:05:36.202612	it_block	B2O	НУК
6074	342	1	2026-01-16 12:05:36.203328	entry_date	2025-05-21	2025-01-22
6075	342	1	2026-01-16 12:05:36.203783	resume_link	https://drive.google.com/file/75144	https://drive.google.com/file/22087
6076	342	1	2026-01-16 12:05:36.204613	current_manager	Михайлова О.Н.	Козлов Д.В.
6077	342	1	2026-01-16 12:05:36.205414	target_projects	Mobile App, ML Pipeline, Data Platform	Infrastructure
6078	342	1	2026-01-16 12:05:36.206236	candidate_status	Свободен	Забронирован
6079	342	1	2026-01-16 12:05:36.207072	funding_end_date	2026-11-05	2026-09-16
6080	342	1	2026-01-16 12:05:36.207824	manager_feedback		Отличные результаты
6081	342	1	2026-01-16 12:05:36.208535	ready_for_vacancy	Нет	Да
6082	343	1	2026-01-16 12:05:36.229272	comments		Срочно нужен проект
6083	343	1	2026-01-16 12:05:36.229814	contacts	+7 (962) 986-74-57, @никанто20, a.nikolaev@rt.ru	+7 (980) 787-31-88, @никанто7, a.nikolaev@rt.ru
6084	343	1	2026-01-16 12:05:36.230262	it_block	B2O	Эксплуатация
6085	343	1	2026-01-16 12:05:36.230966	recruiter	Орлов М.С.	Смирнова А.А.
6086	343	1	2026-01-16 12:05:36.231604	entry_date	2025-11-10	2024-09-14
6087	343	1	2026-01-16 12:05:36.232237	resume_link	https://drive.google.com/file/33158	https://drive.google.com/file/28046
6088	343	1	2026-01-16 12:05:36.23271	ck_department	ЦК Разработки	Департамент данных
6089	343	1	2026-01-16 12:05:36.233161	transfer_date		2025-01-02
6090	343	1	2026-01-16 12:05:36.233916	placement_type	перевод	аутстафф
6091	343	1	2026-01-16 12:05:36.235048	current_manager	Михайлова О.Н.	Иванов А.П.
6092	343	1	2026-01-16 12:05:36.235603	target_projects	Banking App, E-commerce Platform, Госуслуги 2.0	E-commerce Platform
6093	343	1	2026-01-16 12:05:36.235987	candidate_status	Забронирован	Увольнение по СЖ
6094	343	1	2026-01-16 12:05:36.237127	funding_end_date	2025-10-04	2025-11-05
6095	343	1	2026-01-16 12:05:36.238137	manager_feedback	Нужно развитие	
6096	344	1	2026-01-16 12:05:36.262277	hr_bp	Лебедева Т.М.	Морозов К.А.
6097	344	1	2026-01-16 12:05:36.262786	contacts	+7 (987) 604-30-30, @анттать67, t.antonova@rt.ru	+7 (904) 794-58-42, @анттать1, t.antonova@rt.ru
6098	344	1	2026-01-16 12:05:36.263178	it_block	Развитие	B2O
6099	344	1	2026-01-16 12:05:36.263513	entry_date	2024-08-13	2025-09-25
6100	344	1	2026-01-16 12:05:36.264597	resume_link	https://drive.google.com/file/95795	https://drive.google.com/file/81837
6101	344	1	2026-01-16 12:05:36.265148	ck_department	Департамент цифровых продуктов	ЦК Инфраструктуры
6102	344	1	2026-01-16 12:05:36.265907	transfer_date		2025-02-22
6103	344	1	2026-01-16 12:05:36.266291	placement_type	перевод	аутстафф
6104	344	1	2026-01-16 12:05:36.266591	current_manager	Петров С.М.	Иванов А.П.
6105	344	1	2026-01-16 12:05:36.266874	target_projects	Госуслуги 2.0, E-commerce Platform, Mobile App	Infrastructure, Госуслуги 2.0
6106	344	1	2026-01-16 12:05:36.267151	candidate_status	Забронирован	Переведен
6107	344	1	2026-01-16 12:05:36.267423	funding_end_date	2026-10-21	2025-07-26
6108	344	1	2026-01-16 12:05:36.267704	manager_feedback		Отличные результаты
6109	363	1	2026-01-16 12:05:36.293516	comments		Срочно нужен проект
6110	363	1	2026-01-16 12:05:36.294049	contacts	+7 (998) 939-65-63, @лебанна45, a.lebedeva@rt.ru	+7 (964) 546-96-53, @лебанна39, a.lebedeva@rt.ru
6111	363	1	2026-01-16 12:05:36.294394	it_block	Эксплуатация	Развитие
6112	363	1	2026-01-16 12:05:36.294682	recruiter	Смирнова А.А.	Новикова Е.П.
6113	363	1	2026-01-16 12:05:36.294955	entry_date	2024-09-04	2024-11-07
6114	363	1	2026-01-16 12:05:36.295225	resume_link	https://drive.google.com/file/62423	https://drive.google.com/file/17251
6115	363	1	2026-01-16 12:05:36.295491	ck_department	ЦК Разработки	ЦК Аналитики
6116	363	1	2026-01-16 12:05:36.295749	transfer_date	2025-06-30	2025-03-01
6117	363	1	2026-01-16 12:05:36.296006	placement_type	аутстафф	перевод
6118	363	1	2026-01-16 12:05:36.296766	current_manager	Иванов А.П.	Козлов Д.В.
6119	363	1	2026-01-16 12:05:36.297082	target_projects	ML Pipeline, Data Platform, Infrastructure	E-commerce Platform, Infrastructure, Госуслуги 2.0
6120	363	1	2026-01-16 12:05:36.297493	candidate_status	Увольнение по СС	Переведен
6121	363	1	2026-01-16 12:05:36.297799	funding_end_date	2025-06-25	2025-09-24
6122	363	1	2026-01-16 12:05:36.29807	manager_feedback		Нужно развитие
6123	363	1	2026-01-16 12:05:36.298337	ready_for_vacancy	Да	Нет
6124	364	1	2026-01-16 12:05:36.316639	hr_bp	Морозов К.А.	Волкова Н.В.
6125	364	1	2026-01-16 12:05:36.317151	comments	В процессе согласования	
6126	364	1	2026-01-16 12:05:36.317609	contacts	+7 (994) 735-58-44, @борвале91, v.borisova@rt.ru	+7 (962) 484-94-97, @борвале91, v.borisova@rt.ru
6127	364	1	2026-01-16 12:05:36.318499	it_block	Прочее	B2O
6128	364	1	2026-01-16 12:05:36.319159	recruiter	Орлов М.С.	Белова И.Д.
6129	364	1	2026-01-16 12:05:36.319772	entry_date	2025-05-15	2025-03-20
6130	364	1	2026-01-16 12:05:36.32024	resume_link	https://drive.google.com/file/50010	https://drive.google.com/file/59057
6131	364	1	2026-01-16 12:05:36.320703	ck_department	ЦК Аналитики	ЦК Инфраструктуры
6132	364	1	2026-01-16 12:05:36.321406	transfer_date	2025-10-16	2026-06-12
6133	364	1	2026-01-16 12:05:36.321919	placement_type	любой	аутстафф
6134	364	1	2026-01-16 12:05:36.322504	target_projects	DevOps Platform, Mobile App	ML Pipeline, Data Platform, Госуслуги 2.0
6135	364	1	2026-01-16 12:05:36.323082	candidate_status	Переведен	Увольнение по СЖ
6136	364	1	2026-01-16 12:05:36.323669	funding_end_date	2025-09-10	2025-04-15
6137	364	1	2026-01-16 12:05:36.324102	manager_feedback		Нужно развитие
6138	172	1	2026-01-16 12:05:36.342793	hr_bp	Лебедева Т.М.	Волкова Н.В.
6139	172	1	2026-01-16 12:05:36.343297	contacts	+7 (932) 198-84-29, @михандр58, tatiana.sergeev156@company.ru	+7 (996) 856-98-93, @михандр50, tatiana.sergeev156@company.ru
6140	172	1	2026-01-16 12:05:36.34364	it_block	Диджитал	НУК
6141	172	1	2026-01-16 12:05:36.343936	recruiter	Новикова Е.П.	Смирнова А.А.
6142	172	1	2026-01-16 12:05:36.344213	entry_date	2024-11-12	2024-01-24
6143	172	1	2026-01-16 12:05:36.344483	resume_link	https://drive.google.com/file/32723	https://drive.google.com/file/71772
6144	172	1	2026-01-16 12:05:36.344755	ck_department	ЦК Разработки	ЦК Инфраструктуры
6145	172	1	2026-01-16 12:05:36.345023	target_projects	DevOps Platform, E-commerce Platform	Госуслуги 2.0, Data Platform
6146	172	1	2026-01-16 12:05:36.345383	candidate_status	В работе	Забронирован
6147	172	1	2026-01-16 12:05:36.345836	funding_end_date	2025-08-03	2025-11-02
6148	172	1	2026-01-16 12:05:36.346147	manager_feedback	Нужно развитие	
6149	380	1	2026-01-16 12:05:36.383418	contacts	+7 (936) 248-61-68, @волдени46, d.volkov@rt.ru	+7 (983) 267-23-16, @волдени36, d.volkov@rt.ru
6150	380	1	2026-01-16 12:05:36.384198	it_block	B2O	Диджитал
6151	380	1	2026-01-16 12:05:36.384753	recruiter	Смирнова А.А.	Орлов М.С.
6152	380	1	2026-01-16 12:05:36.385397	entry_date	2025-09-12	2024-07-22
6153	380	1	2026-01-16 12:05:36.385858	resume_link	https://drive.google.com/file/80658	https://drive.google.com/file/50066
6154	380	1	2026-01-16 12:05:36.386183	transfer_date	2025-07-17	2026-05-25
6155	380	1	2026-01-16 12:05:36.386698	current_manager	Михайлова О.Н.	Козлов Д.В.
6156	380	1	2026-01-16 12:05:36.387067	target_projects	Data Platform, Госуслуги 2.0	Banking App, Госуслуги 2.0, E-commerce Platform
6157	380	1	2026-01-16 12:05:36.387617	funding_end_date	2026-03-26	2026-02-13
6158	380	1	2026-01-16 12:05:36.388076	manager_feedback	Хороший специалист	
6159	380	1	2026-01-16 12:05:36.388529	ready_for_vacancy	Да	Нет
6160	382	1	2026-01-16 12:05:36.413453	hr_bp	Волкова Н.В.	Морозов К.А.
6161	382	1	2026-01-16 12:05:36.413905	comments	Ожидает оффер	Срочно нужен проект
6162	382	1	2026-01-16 12:05:36.414226	contacts	+7 (936) 473-83-47, @коряна84, ya.koroleva@rt.ru	+7 (921) 840-15-30, @коряна22, ya.koroleva@rt.ru
6163	382	1	2026-01-16 12:05:36.414513	it_block	Развитие	B2O
6164	382	1	2026-01-16 12:05:36.414795	recruiter	Белова И.Д.	Новикова Е.П.
6165	382	1	2026-01-16 12:05:36.415077	entry_date	2024-08-02	2024-04-27
6166	382	1	2026-01-16 12:05:36.415355	resume_link	https://drive.google.com/file/23015	https://drive.google.com/file/22112
6167	382	1	2026-01-16 12:05:36.415765	ck_department	ЦК Аналитики	ЦК Инфраструктуры
6168	382	1	2026-01-16 12:05:36.416127	placement_type	перевод	любой
6169	382	1	2026-01-16 12:05:36.416415	target_projects	Mobile App, Госуслуги 2.0	Mobile App, Infrastructure, Госуслуги 2.0
6170	382	1	2026-01-16 12:05:36.416692	candidate_status	Забронирован	Свободен
6171	382	1	2026-01-16 12:05:36.416969	funding_end_date	2025-04-11	2026-01-03
6172	382	1	2026-01-16 12:05:36.417271	manager_feedback	Отличные результаты	Рекомендую
6173	382	1	2026-01-16 12:05:36.417914	ready_for_vacancy	Нет	Да
6174	383	1	2026-01-16 12:05:36.439859	hr_bp	Морозов К.А.	Лебедева Т.М.
6175	383	1	2026-01-16 12:05:36.440514	comments	В процессе согласования	
6176	383	1	2026-01-16 12:05:36.440897	contacts	+7 (978) 247-46-97, @фроксен15, k.frolova@rt.ru	+7 (905) 496-92-79, @фроксен59, k.frolova@rt.ru
6177	383	1	2026-01-16 12:05:36.441475	it_block	Развитие	Эксплуатация
6178	383	1	2026-01-16 12:05:36.441831	recruiter	Орлов М.С.	Смирнова А.А.
6179	383	1	2026-01-16 12:05:36.442143	entry_date	2024-03-27	2025-09-29
6180	383	1	2026-01-16 12:05:36.442447	resume_link	https://drive.google.com/file/26696	https://drive.google.com/file/43834
6181	383	1	2026-01-16 12:05:36.442737	ck_department	ЦК Разработки	Департамент цифровых продуктов
6182	383	1	2026-01-16 12:05:36.44303	transfer_date	2026-07-17	2025-03-10
6183	383	1	2026-01-16 12:05:36.443319	placement_type	аутстафф	любой
6184	383	1	2026-01-16 12:05:36.443609	current_manager	Петров С.М.	Козлов Д.В.
6185	383	1	2026-01-16 12:05:36.443979	target_projects	Infrastructure	Госуслуги 2.0, Data Platform
6186	383	1	2026-01-16 12:05:36.444292	candidate_status	Увольнение по СЖ	Увольнение по СС
6187	383	1	2026-01-16 12:05:36.444597	funding_end_date	2025-04-08	2026-07-22
6188	383	1	2026-01-16 12:05:36.444895	manager_feedback	Хороший специалист	Отличные результаты
6189	384	1	2026-01-16 12:05:36.462193	contacts	+7 (972) 186-75-27, @зайгали55, g.zaytseva@rt.ru	+7 (908) 998-72-61, @зайгали40, g.zaytseva@rt.ru
6190	384	1	2026-01-16 12:05:36.462694	it_block	НУК	Прочее
6191	384	1	2026-01-16 12:05:36.463065	recruiter	Белова И.Д.	Новикова Е.П.
6192	384	1	2026-01-16 12:05:36.463362	entry_date	2025-09-20	2024-11-15
6193	384	1	2026-01-16 12:05:36.463656	resume_link	https://drive.google.com/file/93801	https://drive.google.com/file/80548
6194	384	1	2026-01-16 12:05:36.463939	ck_department	ЦК Аналитики	ЦК Инфраструктуры
6195	384	1	2026-01-16 12:05:36.464228	transfer_date	2026-05-12	2026-09-05
6196	384	1	2026-01-16 12:05:36.464503	current_manager	Иванов А.П.	Козлов Д.В.
6197	384	1	2026-01-16 12:05:36.464786	target_projects	DevOps Platform, Data Platform, Госуслуги 2.0	Banking App
6198	384	1	2026-01-16 12:05:36.465067	candidate_status	Переведен	Увольнение по СС
6199	384	1	2026-01-16 12:05:36.465466	funding_end_date	2025-06-24	2026-01-21
6200	384	1	2026-01-16 12:05:36.465782	manager_feedback	Отличные результаты	Нужно развитие
6201	386	1	2026-01-16 12:05:36.488036	comments	Ожидает оффер	Срочно нужен проект
6202	386	1	2026-01-16 12:05:36.488706	contacts	+7 (917) 782-10-65, @смидани16, d.smirnov@rt.ru	+7 (978) 435-29-36, @смидани40, d.smirnov@rt.ru
6203	386	1	2026-01-16 12:05:36.489466	it_block	B2O	Эксплуатация
6204	386	1	2026-01-16 12:05:36.490005	recruiter	Белова И.Д.	Орлов М.С.
6205	386	1	2026-01-16 12:05:36.490403	entry_date	2024-09-06	2024-03-03
6206	386	1	2026-01-16 12:05:36.490731	resume_link	https://drive.google.com/file/95013	https://drive.google.com/file/30562
6207	386	1	2026-01-16 12:05:36.491046	ck_department	ЦК Аналитики	ЦК Инфраструктуры
6208	386	1	2026-01-16 12:05:36.491351	transfer_date	2025-07-02	
6209	386	1	2026-01-16 12:05:36.491656	current_manager	Козлов Д.В.	Михайлова О.Н.
6210	386	1	2026-01-16 12:05:36.491956	target_projects	Infrastructure, Mobile App, Banking App	ML Pipeline, Banking App, Mobile App
6211	386	1	2026-01-16 12:05:36.492259	candidate_status	Переведен	Забронирован
6212	386	1	2026-01-16 12:05:36.492561	funding_end_date	2025-11-27	2025-11-12
6213	386	1	2026-01-16 12:05:36.492934	ready_for_vacancy	Нет	Да
6214	387	1	2026-01-16 12:05:36.51245	comments	Срочно нужен проект	Ожидает оффер
6215	387	1	2026-01-16 12:05:36.513007	contacts	+7 (949) 351-69-42, @никлюдм31, l.nikitina@rt.ru	+7 (947) 930-83-56, @никлюдм30, l.nikitina@rt.ru
6216	387	1	2026-01-16 12:05:36.513449	it_block	НУК	Прочее
6217	387	1	2026-01-16 12:05:36.513849	recruiter	Новикова Е.П.	Белова И.Д.
6218	387	1	2026-01-16 12:05:36.514179	entry_date	2024-09-11	2024-02-18
6219	387	1	2026-01-16 12:05:36.514481	resume_link	https://drive.google.com/file/17515	https://drive.google.com/file/47586
6220	387	1	2026-01-16 12:05:36.515455	transfer_date		2026-05-11
6221	387	1	2026-01-16 12:05:36.516002	placement_type	аутстафф	перевод
6222	387	1	2026-01-16 12:05:36.516471	current_manager	Козлов Д.В.	Михайлова О.Н.
6223	387	1	2026-01-16 12:05:36.517167	target_projects	ML Pipeline, DevOps Platform, E-commerce Platform	Mobile App
6224	387	1	2026-01-16 12:05:36.517697	candidate_status	Свободен	Увольнение по СЖ
6225	387	1	2026-01-16 12:05:36.518214	funding_end_date	2026-06-11	2025-11-27
6226	387	1	2026-01-16 12:05:36.519002	manager_feedback	Отличные результаты	
6227	389	1	2026-01-16 12:05:36.540521	comments		В процессе согласования
6228	389	1	2026-01-16 12:05:36.541356	contacts	+7 (926) 252-46-94, @попилья56, i.popov@rt.ru	+7 (997) 462-12-13, @попилья44, i.popov@rt.ru
6229	389	1	2026-01-16 12:05:36.541845	it_block	Эксплуатация	B2O
6230	389	1	2026-01-16 12:05:36.542271	recruiter	Орлов М.С.	Новикова Е.П.
6231	389	1	2026-01-16 12:05:36.543463	entry_date	2025-01-05	2024-06-03
6232	389	1	2026-01-16 12:05:36.543917	resume_link	https://drive.google.com/file/57778	https://drive.google.com/file/41563
6233	389	1	2026-01-16 12:05:36.544313	ck_department	ЦК Инфраструктуры	Департамент данных
6234	389	1	2026-01-16 12:05:36.544984	transfer_date	2026-09-15	
6235	389	1	2026-01-16 12:05:36.545502	placement_type	перевод	любой
6236	389	1	2026-01-16 12:05:36.545834	current_manager	Сидорова Е.К.	Козлов Д.В.
6237	389	1	2026-01-16 12:05:36.546132	target_projects	Banking App, ML Pipeline	Data Platform, Mobile App
6238	389	1	2026-01-16 12:05:36.546416	candidate_status	Увольнение по СС	Свободен
6239	389	1	2026-01-16 12:05:36.546696	funding_end_date	2025-10-13	2025-05-11
6240	389	1	2026-01-16 12:05:36.547095	manager_feedback	Рекомендую	
6241	391	1	2026-01-16 12:05:36.569358	hr_bp	Лебедева Т.М.	Морозов К.А.
6242	391	1	2026-01-16 12:05:36.56997	contacts	+7 (967) 230-44-17, @кисанас95, a.kiseleva@rt.ru	+7 (958) 650-97-50, @кисанас39, a.kiseleva@rt.ru
6243	391	1	2026-01-16 12:05:36.570547	it_block	Диджитал	Прочее
6244	391	1	2026-01-16 12:05:36.571145	recruiter	Орлов М.С.	Смирнова А.А.
6245	391	1	2026-01-16 12:05:36.572285	entry_date	2024-02-25	2025-11-01
6246	391	1	2026-01-16 12:05:36.572913	resume_link	https://drive.google.com/file/60536	https://drive.google.com/file/57103
6247	391	1	2026-01-16 12:05:36.574042	ck_department	Департамент цифровых продуктов	ЦК Разработки
6248	391	1	2026-01-16 12:05:36.57451	placement_type	аутстафф	любой
6249	391	1	2026-01-16 12:05:36.575128	current_manager	Иванов А.П.	Сидорова Е.К.
6250	391	1	2026-01-16 12:05:36.575597	target_projects	Mobile App, Infrastructure	Infrastructure
6251	391	1	2026-01-16 12:05:36.575917	candidate_status	В работе	Свободен
6252	391	1	2026-01-16 12:05:36.576299	funding_end_date	2026-12-31	2026-11-06
6253	391	1	2026-01-16 12:05:36.576612	manager_feedback	Отличные результаты	
6254	392	1	2026-01-16 12:05:36.60445	hr_bp	Лебедева Т.М.	Морозов К.А.
6255	392	1	2026-01-16 12:05:36.60531	contacts	+7 (913) 783-79-29, @федмарк67, m.fedorov@rt.ru	+7 (923) 266-45-43, @федмарк80, m.fedorov@rt.ru
6256	392	1	2026-01-16 12:05:36.605875	it_block	B2O	НУК
6257	392	1	2026-01-16 12:05:36.606444	recruiter	Белова И.Д.	Смирнова А.А.
6258	392	1	2026-01-16 12:05:36.606839	entry_date	2024-10-01	2024-05-24
6259	392	1	2026-01-16 12:05:36.607389	resume_link	https://drive.google.com/file/81350	https://drive.google.com/file/69829
6260	392	1	2026-01-16 12:05:36.607739	ck_department	Департамент данных	Департамент цифровых продуктов
6261	392	1	2026-01-16 12:05:36.60815	transfer_date	2025-06-29	
6262	392	1	2026-01-16 12:05:36.608474	placement_type	аутстафф	перевод
6263	392	1	2026-01-16 12:05:36.608788	current_manager	Козлов Д.В.	Петров С.М.
6264	392	1	2026-01-16 12:05:36.609131	target_projects	Infrastructure	E-commerce Platform, Mobile App
6265	392	1	2026-01-16 12:05:36.609835	candidate_status	Увольнение по СЖ	В работе
6266	392	1	2026-01-16 12:05:36.610185	funding_end_date	2026-01-31	2026-08-13
6267	392	1	2026-01-16 12:05:36.610494	manager_feedback		Нужно развитие
6268	392	1	2026-01-16 12:05:36.610793	ready_for_vacancy	Да	Нет
6269	173	1	2026-01-16 12:05:36.630173	hr_bp	Лебедева Т.М.	Морозов К.А.
6270	173	1	2026-01-16 12:05:36.63087	contacts	+7 (980) 779-84-95, @новрома88, yaroslav.dmitriev157@company.ru	+7 (931) 281-42-63, @новрома11, yaroslav.dmitriev157@company.ru
6271	173	1	2026-01-16 12:05:36.631421	it_block	Развитие	Эксплуатация
6272	173	1	2026-01-16 12:05:36.632065	entry_date	2024-07-30	2024-05-01
6273	173	1	2026-01-16 12:05:36.632542	resume_link	https://drive.google.com/file/96648	https://drive.google.com/file/72377
6274	173	1	2026-01-16 12:05:36.63303	placement_type	аутстафф	любой
6275	173	1	2026-01-16 12:05:36.634283	current_manager	Михайлова О.Н.	Сидорова Е.К.
6276	173	1	2026-01-16 12:05:36.634727	target_projects	DevOps Platform, Banking App, E-commerce Platform	Госуслуги 2.0, ML Pipeline, Data Platform
6277	173	1	2026-01-16 12:05:36.635413	candidate_status	В работе	Свободен
6278	173	1	2026-01-16 12:05:36.635999	funding_end_date	2025-09-08	2025-05-28
6279	173	1	2026-01-16 12:05:36.636625	manager_feedback	Нужно развитие	Хороший специалист
6280	173	1	2026-01-16 12:05:36.637192	ready_for_vacancy	Нет	Да
6281	175	1	2026-01-16 12:05:36.662312	hr_bp	Морозов К.А.	Лебедева Т.М.
6282	175	1	2026-01-16 12:05:36.662879	contacts	+7 (966) 272-68-90, @морники27, anna.egorov159@company.ru	+7 (938) 348-75-92, @морники88, anna.egorov159@company.ru
6283	175	1	2026-01-16 12:05:36.663561	it_block	Диджитал	НУК
6284	175	1	2026-01-16 12:05:36.664072	entry_date	2024-09-04	2025-11-19
6285	175	1	2026-01-16 12:05:36.664655	resume_link	https://drive.google.com/file/33792	https://drive.google.com/file/15575
6286	175	1	2026-01-16 12:05:36.665203	ck_department	ЦК Инфраструктуры	ЦК Аналитики
6287	175	1	2026-01-16 12:05:36.665675	transfer_date	2025-08-14	
6288	175	1	2026-01-16 12:05:36.666319	placement_type	перевод	любой
6289	175	1	2026-01-16 12:05:36.666898	current_manager	Иванов А.П.	Петров С.М.
6290	175	1	2026-01-16 12:05:36.667357	target_projects	Data Platform	DevOps Platform
6291	175	1	2026-01-16 12:05:36.66782	candidate_status	Переведен	В работе
6292	175	1	2026-01-16 12:05:36.669093	funding_end_date	2026-09-26	2025-06-15
6293	175	1	2026-01-16 12:05:36.66978	manager_feedback	Отличные результаты	
6294	161	1	2026-01-16 12:05:36.695291	comments	Ожидает оффер	Срочно нужен проект
6295	161	1	2026-01-16 12:05:36.695924	contacts	+7 (938) 896-11-82, @волмакс95, arthur.kozlov145@company.ru	+7 (904) 709-49-49, @волмакс71, arthur.kozlov145@company.ru
6296	161	1	2026-01-16 12:05:36.697105	recruiter	Смирнова А.А.	Орлов М.С.
6297	161	1	2026-01-16 12:05:36.698077	entry_date	2024-08-29	2025-01-15
6298	161	1	2026-01-16 12:05:36.698662	resume_link	https://drive.google.com/file/55019	https://drive.google.com/file/73331
6299	161	1	2026-01-16 12:05:36.699265	ck_department	ЦК Аналитики	Департамент цифровых продуктов
6300	161	1	2026-01-16 12:05:36.699779	transfer_date	2025-01-14	
6301	161	1	2026-01-16 12:05:36.700261	placement_type	аутстафф	перевод
6302	161	1	2026-01-16 12:05:36.700758	target_projects	Госуслуги 2.0, E-commerce Platform	Mobile App, Data Platform, DevOps Platform
6303	161	1	2026-01-16 12:05:36.701659	candidate_status	Увольнение по СС	Забронирован
6304	161	1	2026-01-16 12:05:36.702289	funding_end_date	2025-12-15	2026-10-09
6305	161	1	2026-01-16 12:05:36.70271	manager_feedback	Нужно развитие	Хороший специалист
6306	170	1	2026-01-16 12:05:36.728002	hr_bp	Лебедева Т.М.	Морозов К.А.
6307	170	1	2026-01-16 12:05:36.728756	comments	В процессе согласования	
6308	170	1	2026-01-16 12:05:36.729624	contacts	+7 (922) 758-51-42, @петалек73, ekaterina.yakovlev154@company.ru	+7 (919) 283-69-51, @петалек21, ekaterina.yakovlev154@company.ru
6309	170	1	2026-01-16 12:05:36.730208	entry_date	2024-03-14	2025-12-01
6310	170	1	2026-01-16 12:05:36.731067	resume_link	https://drive.google.com/file/41625	https://drive.google.com/file/72111
6311	170	1	2026-01-16 12:05:36.731872	ck_department	Департамент цифровых продуктов	ЦК Инфраструктуры
6312	170	1	2026-01-16 12:05:36.732716	transfer_date		2026-01-12
6636	205	1	2026-01-16 12:05:37.552895	manager_feedback	Рекомендую	
6313	170	1	2026-01-16 12:05:36.733184	placement_type	перевод	аутстафф
6314	170	1	2026-01-16 12:05:36.733894	target_projects	E-commerce Platform	Banking App, Mobile App
6315	170	1	2026-01-16 12:05:36.734298	candidate_status	В работе	Увольнение по СС
6316	170	1	2026-01-16 12:05:36.734768	funding_end_date	2026-02-01	2026-12-09
6317	170	1	2026-01-16 12:05:36.735373	manager_feedback		Отличные результаты
6318	186	1	2026-01-16 12:05:36.754842	hr_bp	Волкова Н.В.	Лебедева Т.М.
6319	186	1	2026-01-16 12:05:36.755324	contacts	+7 (972) 220-76-85, @сокегор74, gleb.lebedev170@company.ru	+7 (905) 949-14-26, @сокегор85, gleb.lebedev170@company.ru
6320	186	1	2026-01-16 12:05:36.755667	it_block	Диджитал	НУК
6321	186	1	2026-01-16 12:05:36.756054	entry_date	2025-04-26	2025-09-13
6322	186	1	2026-01-16 12:05:36.756557	resume_link	https://drive.google.com/file/65954	https://drive.google.com/file/92211
6323	186	1	2026-01-16 12:05:36.757356	ck_department	ЦК Аналитики	Департамент данных
6324	186	1	2026-01-16 12:05:36.757846	transfer_date	2025-06-20	2026-07-24
6325	186	1	2026-01-16 12:05:36.758175	placement_type	любой	аутстафф
6326	186	1	2026-01-16 12:05:36.758464	target_projects	Госуслуги 2.0	Banking App
6327	186	1	2026-01-16 12:05:36.758749	candidate_status	Переведен	Увольнение по СС
6328	186	1	2026-01-16 12:05:36.759081	funding_end_date	2025-02-13	2025-12-14
6329	186	1	2026-01-16 12:05:36.759872	manager_feedback	Хороший специалист	
6330	191	1	2026-01-16 12:05:36.777161	hr_bp	Лебедева Т.М.	Волкова Н.В.
6331	191	1	2026-01-16 12:05:36.777805	comments	В процессе согласования	
6332	191	1	2026-01-16 12:05:36.778298	contacts	+7 (962) 965-58-63, @волмакс56, igor.nikitin175@company.ru	+7 (933) 266-62-62, @волмакс98, igor.nikitin175@company.ru
6333	191	1	2026-01-16 12:05:36.778792	it_block	Развитие	Диджитал
6334	191	1	2026-01-16 12:05:36.779198	recruiter	Новикова Е.П.	Смирнова А.А.
6335	191	1	2026-01-16 12:05:36.779515	entry_date	2025-02-20	2024-05-05
6336	191	1	2026-01-16 12:05:36.780602	resume_link	https://drive.google.com/file/81809	https://drive.google.com/file/68217
6337	191	1	2026-01-16 12:05:36.780994	ck_department	ЦК Инфраструктуры	Департамент данных
6338	191	1	2026-01-16 12:05:36.781466	transfer_date	2026-12-05	2025-03-31
6339	191	1	2026-01-16 12:05:36.78204	current_manager	Михайлова О.Н.	Петров С.М.
6340	191	1	2026-01-16 12:05:36.782501	target_projects	ML Pipeline	Banking App, Mobile App, Data Platform
6341	191	1	2026-01-16 12:05:36.782954	funding_end_date	2026-09-18	2026-07-20
6342	191	1	2026-01-16 12:05:36.783606	manager_feedback	Рекомендую	Нужно развитие
6343	191	1	2026-01-16 12:05:36.78425	ready_for_vacancy	Да	Нет
6344	197	1	2026-01-16 12:05:36.808284	hr_bp	Волкова Н.В.	Морозов К.А.
6345	197	1	2026-01-16 12:05:36.808722	contacts	+7 (975) 709-76-38, @куздени76, igor.pavlov181@company.ru	+7 (990) 702-99-12, @куздени8, igor.pavlov181@company.ru
6346	197	1	2026-01-16 12:05:36.809046	it_block	НУК	Развитие
6347	197	1	2026-01-16 12:05:36.809654	recruiter	Новикова Е.П.	Смирнова А.А.
6348	197	1	2026-01-16 12:05:36.81018	entry_date	2024-02-27	2024-12-08
6349	197	1	2026-01-16 12:05:36.810678	resume_link	https://drive.google.com/file/16991	https://drive.google.com/file/60046
6350	197	1	2026-01-16 12:05:36.811154	ck_department	ЦК Инфраструктуры	Департамент данных
6351	197	1	2026-01-16 12:05:36.811624	transfer_date		2026-11-24
6352	197	1	2026-01-16 12:05:36.812098	placement_type	любой	перевод
6353	197	1	2026-01-16 12:05:36.812418	current_manager	Михайлова О.Н.	Сидорова Е.К.
6354	197	1	2026-01-16 12:05:36.81274	target_projects	E-commerce Platform, Mobile App, Data Platform	Infrastructure, Data Platform
6355	197	1	2026-01-16 12:05:36.813059	candidate_status	В работе	Переведен
6356	197	1	2026-01-16 12:05:36.813716	funding_end_date	2025-06-14	2026-09-11
6357	197	1	2026-01-16 12:05:36.814318	manager_feedback		Хороший специалист
6358	197	1	2026-01-16 12:05:36.814754	ready_for_vacancy	Нет	Да
6359	196	1	2026-01-16 12:05:36.832076	hr_bp	Морозов К.А.	Лебедева Т.М.
6360	196	1	2026-01-16 12:05:36.832683	comments		Срочно нужен проект
6361	196	1	2026-01-16 12:05:36.833055	contacts	+7 (907) 357-97-74, @смиилья24, roman.zakharov180@company.ru	+7 (986) 405-48-49, @смиилья66, roman.zakharov180@company.ru
6362	196	1	2026-01-16 12:05:36.833471	recruiter	Новикова Е.П.	Смирнова А.А.
6363	196	1	2026-01-16 12:05:36.833853	entry_date	2024-08-27	2025-06-04
6364	196	1	2026-01-16 12:05:36.834162	resume_link	https://drive.google.com/file/69107	https://drive.google.com/file/87731
6365	196	1	2026-01-16 12:05:36.834463	ck_department	ЦК Инфраструктуры	ЦК Разработки
6366	196	1	2026-01-16 12:05:36.835105	placement_type	любой	аутстафф
6367	196	1	2026-01-16 12:05:36.83547	current_manager	Михайлова О.Н.	Петров С.М.
6368	196	1	2026-01-16 12:05:36.83593	target_projects	Banking App, E-commerce Platform, Госуслуги 2.0	Госуслуги 2.0, Infrastructure
6369	196	1	2026-01-16 12:05:36.836834	candidate_status	Забронирован	В работе
6370	196	1	2026-01-16 12:05:36.837386	funding_end_date	2025-06-28	2025-09-06
6371	199	1	2026-01-16 12:05:36.8548	hr_bp	Морозов К.А.	Волкова Н.В.
6372	199	1	2026-01-16 12:05:36.855263	comments		Срочно нужен проект
6373	199	1	2026-01-16 12:05:36.855601	contacts	+7 (919) 605-86-25, @васиван16, roman.smirnov183@company.ru	+7 (965) 607-25-25, @васиван7, roman.smirnov183@company.ru
6374	199	1	2026-01-16 12:05:36.855901	it_block	Развитие	Диджитал
6375	199	1	2026-01-16 12:05:36.856215	recruiter	Белова И.Д.	Орлов М.С.
6376	199	1	2026-01-16 12:05:36.857356	entry_date	2024-12-14	2025-06-20
6377	199	1	2026-01-16 12:05:36.85785	resume_link	https://drive.google.com/file/95748	https://drive.google.com/file/11200
6378	199	1	2026-01-16 12:05:36.858259	ck_department	ЦК Аналитики	ЦК Инфраструктуры
6379	199	1	2026-01-16 12:05:36.858826	transfer_date	2025-12-23	
6380	199	1	2026-01-16 12:05:36.859169	placement_type	аутстафф	перевод
6381	199	1	2026-01-16 12:05:36.85948	current_manager	Сидорова Е.К.	Михайлова О.Н.
6382	199	1	2026-01-16 12:05:36.859785	target_projects	Infrastructure	E-commerce Platform, DevOps Platform, Госуслуги 2.0
6383	199	1	2026-01-16 12:05:36.860101	candidate_status	Увольнение по СС	В работе
6384	199	1	2026-01-16 12:05:36.860396	funding_end_date	2026-08-15	2025-06-19
6385	199	1	2026-01-16 12:05:36.860687	manager_feedback	Отличные результаты	Рекомендую
6386	183	1	2026-01-16 12:05:36.887111	hr_bp	Лебедева Т.М.	Морозов К.А.
6387	183	1	2026-01-16 12:05:36.887908	comments	Срочно нужен проект	В процессе согласования
6388	183	1	2026-01-16 12:05:36.88847	contacts	+7 (953) 584-31-57, @попартё77, maxim.makarov167@company.ru	+7 (914) 642-14-46, @попартё41, maxim.makarov167@company.ru
6389	183	1	2026-01-16 12:05:36.888917	it_block	Прочее	B2O
6390	183	1	2026-01-16 12:05:36.889271	entry_date	2024-01-30	2024-08-04
6391	183	1	2026-01-16 12:05:36.889696	resume_link	https://drive.google.com/file/20661	https://drive.google.com/file/27593
6392	183	1	2026-01-16 12:05:36.89002	ck_department	ЦК Разработки	Департамент цифровых продуктов
6393	183	1	2026-01-16 12:05:36.890316	transfer_date	2026-03-23	
6394	183	1	2026-01-16 12:05:36.890991	current_manager	Иванов А.П.	Козлов Д.В.
6395	183	1	2026-01-16 12:05:36.891518	target_projects	DevOps Platform, Banking App, ML Pipeline	Infrastructure, Banking App
6396	183	1	2026-01-16 12:05:36.89214	candidate_status	Увольнение по СЖ	Забронирован
6397	183	1	2026-01-16 12:05:36.892581	funding_end_date	2026-10-01	2026-02-25
6398	183	1	2026-01-16 12:05:36.892945	manager_feedback		Нужно развитие
6399	204	1	2026-01-16 12:05:36.913439	hr_bp	Волкова Н.В.	Морозов К.А.
6400	204	1	2026-01-16 12:05:36.914187	comments		Ожидает оффер
6401	204	1	2026-01-16 12:05:36.91472	contacts	+7 (979) 899-43-33, @фёдсерг49, elena.vorobyov188@company.ru	+7 (984) 325-59-32, @фёдсерг59, elena.vorobyov188@company.ru
6402	204	1	2026-01-16 12:05:36.915054	it_block	Эксплуатация	B2O
6403	204	1	2026-01-16 12:05:36.915527	entry_date	2025-03-15	2024-05-20
6404	204	1	2026-01-16 12:05:36.915989	resume_link	https://drive.google.com/file/17526	https://drive.google.com/file/41497
6405	204	1	2026-01-16 12:05:36.91632	placement_type	перевод	любой
6406	204	1	2026-01-16 12:05:36.91662	target_projects	Data Platform	Data Platform, DevOps Platform
6407	204	1	2026-01-16 12:05:36.916907	candidate_status	Свободен	В работе
6408	204	1	2026-01-16 12:05:36.917189	funding_end_date	2026-11-20	2025-05-30
6409	152	1	2026-01-16 12:05:36.938613	contacts	+7 (962) 211-57-41, @куздени96, egor.vasilev136@company.ru	+7 (995) 851-77-26, @куздени58, egor.vasilev136@company.ru
6410	152	1	2026-01-16 12:05:36.939158	it_block	Развитие	Эксплуатация
6411	152	1	2026-01-16 12:05:36.9396	recruiter	Смирнова А.А.	Белова И.Д.
6412	152	1	2026-01-16 12:05:36.940495	entry_date	2024-12-15	2024-05-31
6413	152	1	2026-01-16 12:05:36.941035	resume_link	https://drive.google.com/file/18862	https://drive.google.com/file/63963
6414	152	1	2026-01-16 12:05:36.941567	ck_department	Департамент цифровых продуктов	ЦК Инфраструктуры
6415	152	1	2026-01-16 12:05:36.942168	transfer_date		2026-11-20
6416	152	1	2026-01-16 12:05:36.942702	target_projects	Infrastructure, Banking App	ML Pipeline
6417	152	1	2026-01-16 12:05:36.943056	candidate_status	Свободен	Увольнение по СЖ
6418	152	1	2026-01-16 12:05:36.943391	funding_end_date	2025-08-21	2025-11-27
6419	152	1	2026-01-16 12:05:36.943688	manager_feedback	Рекомендую	Хороший специалист
6420	184	1	2026-01-16 12:05:36.963211	comments		В процессе согласования
6421	184	1	2026-01-16 12:05:36.963826	contacts	+7 (981) 134-59-47, @васиван94, julia.kuznetsov168@company.ru	+7 (971) 307-31-22, @васиван64, julia.kuznetsov168@company.ru
6422	184	1	2026-01-16 12:05:36.964374	it_block	B2O	НУК
6423	184	1	2026-01-16 12:05:36.964833	recruiter	Орлов М.С.	Белова И.Д.
6424	184	1	2026-01-16 12:05:36.965318	entry_date	2025-03-23	2025-12-04
6425	184	1	2026-01-16 12:05:36.965917	resume_link	https://drive.google.com/file/85794	https://drive.google.com/file/19581
6426	184	1	2026-01-16 12:05:36.96641	current_manager	Козлов Д.В.	Михайлова О.Н.
6427	184	1	2026-01-16 12:05:36.967101	target_projects	ML Pipeline, Mobile App, Data Platform	Data Platform, E-commerce Platform, Госуслуги 2.0
6428	184	1	2026-01-16 12:05:36.96778	funding_end_date	2026-08-20	2025-04-29
6429	184	1	2026-01-16 12:05:36.969088	manager_feedback		Нужно развитие
6430	184	1	2026-01-16 12:05:36.969736	ready_for_vacancy	Нет	Да
6431	192	1	2026-01-16 12:05:36.996382	hr_bp	Волкова Н.В.	Лебедева Т.М.
6432	192	1	2026-01-16 12:05:36.99714	comments	Срочно нужен проект	Ожидает оффер
6433	192	1	2026-01-16 12:05:36.997919	contacts	+7 (923) 523-62-73, @алемиха94, vladimir.sergeev176@company.ru	+7 (932) 804-93-89, @алемиха71, vladimir.sergeev176@company.ru
6434	192	1	2026-01-16 12:05:36.998419	it_block	Эксплуатация	B2O
6435	192	1	2026-01-16 12:05:36.998767	recruiter	Смирнова А.А.	Белова И.Д.
6436	192	1	2026-01-16 12:05:36.999125	entry_date	2025-08-10	2025-08-18
6437	192	1	2026-01-16 12:05:36.999495	resume_link	https://drive.google.com/file/41682	https://drive.google.com/file/40681
6438	192	1	2026-01-16 12:05:36.999802	transfer_date	2025-09-15	2025-01-15
6439	192	1	2026-01-16 12:05:37.000089	placement_type	перевод	аутстафф
6440	192	1	2026-01-16 12:05:37.00038	current_manager	Петров С.М.	Михайлова О.Н.
6441	192	1	2026-01-16 12:05:37.000669	target_projects	Banking App	ML Pipeline
6637	205	1	2026-01-16 12:05:37.553322	ready_for_vacancy	Да	Нет
6442	192	1	2026-01-16 12:05:37.000957	candidate_status	Увольнение по СЖ	Переведен
6443	192	1	2026-01-16 12:05:37.00153	funding_end_date	2026-08-06	2025-12-07
6444	192	1	2026-01-16 12:05:37.002191	manager_feedback	Рекомендую	
6445	75	1	2026-01-16 12:05:37.021762	hr_bp	Лебедева Т.М.	Волкова Н.В.
6446	75	1	2026-01-16 12:05:37.022389	comments	Срочно нужен проект	В процессе согласования
6447	75	1	2026-01-16 12:05:37.022837	contacts	+7 (966) 736-95-53, @иваалек96, timofey.orlov59@company.ru	+7 (943) 385-68-83, @иваалек29, timofey.orlov59@company.ru
6448	75	1	2026-01-16 12:05:37.023326	it_block	Эксплуатация	НУК
6449	75	1	2026-01-16 12:05:37.02381	recruiter	Смирнова А.А.	Новикова Е.П.
6450	75	1	2026-01-16 12:05:37.024151	entry_date	2024-08-14	2025-04-27
6451	75	1	2026-01-16 12:05:37.024515	resume_link	https://drive.google.com/file/70809	https://drive.google.com/file/62247
6452	75	1	2026-01-16 12:05:37.024958	ck_department	ЦК Инфраструктуры	Департамент данных
6453	75	1	2026-01-16 12:05:37.025418	placement_type	аутстафф	любой
6454	75	1	2026-01-16 12:05:37.025932	current_manager	Козлов Д.В.	Петров С.М.
6455	75	1	2026-01-16 12:05:37.026405	target_projects	Госуслуги 2.0, Data Platform	ML Pipeline, Banking App, E-commerce Platform
6456	75	1	2026-01-16 12:05:37.026765	candidate_status	Забронирован	В работе
6457	75	1	2026-01-16 12:05:37.027208	funding_end_date	2026-06-16	2025-10-30
6458	75	1	2026-01-16 12:05:37.027582	ready_for_vacancy	Нет	Да
6459	198	1	2026-01-16 12:05:37.048665	hr_bp	Лебедева Т.М.	Морозов К.А.
6460	198	1	2026-01-16 12:05:37.049481	comments	Ожидает оффер	Срочно нужен проект
6461	198	1	2026-01-16 12:05:37.050123	contacts	+7 (932) 522-92-64, @попартё49, irina.andreev182@company.ru	+7 (915) 205-72-11, @попартё78, irina.andreev182@company.ru
6462	198	1	2026-01-16 12:05:37.050741	it_block	B2O	Диджитал
6463	198	1	2026-01-16 12:05:37.051334	recruiter	Белова И.Д.	Орлов М.С.
6464	198	1	2026-01-16 12:05:37.052574	entry_date	2024-03-31	2024-07-06
6465	198	1	2026-01-16 12:05:37.053083	resume_link	https://drive.google.com/file/34774	https://drive.google.com/file/15837
6466	198	1	2026-01-16 12:05:37.05354	ck_department	Департамент данных	ЦК Аналитики
6467	198	1	2026-01-16 12:05:37.054077	placement_type	перевод	любой
6468	198	1	2026-01-16 12:05:37.054766	current_manager	Петров С.М.	Козлов Д.В.
6469	198	1	2026-01-16 12:05:37.055253	target_projects	E-commerce Platform	ML Pipeline, Госуслуги 2.0, Mobile App
6470	198	1	2026-01-16 12:05:37.055911	funding_end_date	2026-08-09	2025-11-29
6471	198	1	2026-01-16 12:05:37.056582	manager_feedback		Нужно развитие
6472	90	1	2026-01-16 12:05:37.080732	hr_bp	Волкова Н.В.	Морозов К.А.
6473	90	1	2026-01-16 12:05:37.081324	comments	В процессе согласования	
6474	90	1	2026-01-16 12:05:37.081918	contacts	+7 (930) 311-61-96, @иваалек39, anna.popov74@company.ru	+7 (913) 885-87-76, @иваалек17, anna.popov74@company.ru
6475	90	1	2026-01-16 12:05:37.082532	it_block	НУК	Развитие
6476	90	1	2026-01-16 12:05:37.083055	recruiter	Новикова Е.П.	Белова И.Д.
6477	90	1	2026-01-16 12:05:37.0835	entry_date	2025-10-13	2025-08-23
6478	90	1	2026-01-16 12:05:37.084061	resume_link	https://drive.google.com/file/50261	https://drive.google.com/file/49394
6479	90	1	2026-01-16 12:05:37.084521	ck_department	Департамент данных	ЦК Разработки
6480	90	1	2026-01-16 12:05:37.085068	transfer_date	2026-10-07	
6481	90	1	2026-01-16 12:05:37.085535	placement_type	перевод	аутстафф
6482	90	1	2026-01-16 12:05:37.085938	current_manager	Сидорова Е.К.	Михайлова О.Н.
6483	90	1	2026-01-16 12:05:37.08633	target_projects	DevOps Platform, Banking App	Mobile App, E-commerce Platform
6484	90	1	2026-01-16 12:05:37.087521	candidate_status	Переведен	Свободен
6485	90	1	2026-01-16 12:05:37.087974	funding_end_date	2025-10-20	2026-06-19
6486	90	1	2026-01-16 12:05:37.088357	manager_feedback		Отличные результаты
6487	195	1	2026-01-16 12:05:37.106941	hr_bp	Волкова Н.В.	Лебедева Т.М.
6488	195	1	2026-01-16 12:05:37.107453	comments	В процессе согласования	Ожидает оффер
6489	195	1	2026-01-16 12:05:37.108624	contacts	+7 (957) 188-91-11, @иваалек17, igor.fedorov179@company.ru	+7 (978) 661-36-38, @иваалек69, igor.fedorov179@company.ru
6490	195	1	2026-01-16 12:05:37.109087	recruiter	Смирнова А.А.	Новикова Е.П.
6491	195	1	2026-01-16 12:05:37.109486	entry_date	2025-02-03	2024-06-05
6492	195	1	2026-01-16 12:05:37.10996	resume_link	https://drive.google.com/file/28156	https://drive.google.com/file/62255
6493	195	1	2026-01-16 12:05:37.110356	ck_department	Департамент цифровых продуктов	ЦК Инфраструктуры
6494	195	1	2026-01-16 12:05:37.110688	transfer_date		2026-05-02
6495	195	1	2026-01-16 12:05:37.110991	current_manager	Сидорова Е.К.	Козлов Д.В.
6496	195	1	2026-01-16 12:05:37.111403	target_projects	Infrastructure, Banking App	Data Platform
6497	195	1	2026-01-16 12:05:37.111808	candidate_status	В работе	Увольнение по СС
6498	195	1	2026-01-16 12:05:37.112121	funding_end_date	2026-01-24	2025-07-11
6499	195	1	2026-01-16 12:05:37.112574	manager_feedback	Отличные результаты	Рекомендую
6500	61	1	2026-01-16 12:05:37.133125	hr_bp	Волкова Н.В.	Лебедева Т.М.
6501	61	1	2026-01-16 12:05:37.133826	comments	В процессе согласования	
6502	61	1	2026-01-16 12:05:37.134335	contacts	+7 (912) 512-63-37, @смиилья34, alexey.lebedev45@company.ru	+7 (901) 609-98-21, @смиилья29, alexey.lebedev45@company.ru
6503	61	1	2026-01-16 12:05:37.134781	it_block	НУК	Диджитал
6504	61	1	2026-01-16 12:05:37.13527	recruiter	Смирнова А.А.	Орлов М.С.
6505	61	1	2026-01-16 12:05:37.13582	entry_date	2024-10-14	2025-09-15
6962	450	1	2026-01-16 12:05:38.488756	entry_date	2025-06-01	2024-03-25
6506	61	1	2026-01-16 12:05:37.136288	resume_link	https://drive.google.com/file/88027	https://drive.google.com/file/73185
6507	61	1	2026-01-16 12:05:37.136881	ck_department	ЦК Разработки	ЦК Инфраструктуры
6508	61	1	2026-01-16 12:05:37.137417	transfer_date	2026-01-15	
6509	61	1	2026-01-16 12:05:37.137809	current_manager	Козлов Д.В.	Михайлова О.Н.
6510	61	1	2026-01-16 12:05:37.138132	target_projects	E-commerce Platform	Data Platform, Banking App
6511	61	1	2026-01-16 12:05:37.138436	candidate_status	Увольнение по СС	Свободен
6512	61	1	2026-01-16 12:05:37.13874	funding_end_date	2025-05-25	2026-06-15
6513	61	1	2026-01-16 12:05:37.139191	manager_feedback	Отличные результаты	Хороший специалист
6514	104	1	2026-01-16 12:05:37.15741	hr_bp	Морозов К.А.	Лебедева Т.М.
6515	104	1	2026-01-16 12:05:37.158202	comments	Ожидает оффер	
6516	104	1	2026-01-16 12:05:37.159016	contacts	+7 (905) 537-25-69, @семкири46, ilya.andreev88@company.ru	+7 (976) 874-99-73, @семкири69, ilya.andreev88@company.ru
6517	104	1	2026-01-16 12:05:37.159434	it_block	Эксплуатация	Диджитал
6518	104	1	2026-01-16 12:05:37.159772	recruiter	Новикова Е.П.	Смирнова А.А.
6519	104	1	2026-01-16 12:05:37.160079	entry_date	2025-08-14	2025-01-15
6520	104	1	2026-01-16 12:05:37.160381	resume_link	https://drive.google.com/file/70837	https://drive.google.com/file/43012
6521	104	1	2026-01-16 12:05:37.160676	ck_department	Департамент данных	ЦК Аналитики
6522	104	1	2026-01-16 12:05:37.160974	transfer_date		2025-06-21
6523	104	1	2026-01-16 12:05:37.161274	placement_type	любой	перевод
6524	104	1	2026-01-16 12:05:37.161756	current_manager	Михайлова О.Н.	Петров С.М.
6525	104	1	2026-01-16 12:05:37.162103	target_projects	E-commerce Platform, Banking App	Banking App, ML Pipeline, DevOps Platform
6526	104	1	2026-01-16 12:05:37.162413	candidate_status	В работе	Увольнение по СЖ
6527	104	1	2026-01-16 12:05:37.162724	funding_end_date	2025-02-16	2025-02-19
6528	104	1	2026-01-16 12:05:37.163007	manager_feedback		Нужно развитие
6529	104	1	2026-01-16 12:05:37.163767	ready_for_vacancy	Нет	Да
6530	105	1	2026-01-16 12:05:37.182492	hr_bp	Лебедева Т.М.	Морозов К.А.
6531	105	1	2026-01-16 12:05:37.183003	comments	Ожидает оффер	
6532	105	1	2026-01-16 12:05:37.183364	contacts	+7 (970) 301-48-37, @иваалек58, grigory.egorov89@company.ru	+7 (931) 157-40-56, @иваалек29, grigory.egorov89@company.ru
6533	105	1	2026-01-16 12:05:37.183667	it_block	Прочее	Развитие
6534	105	1	2026-01-16 12:05:37.184205	recruiter	Новикова Е.П.	Смирнова А.А.
6535	105	1	2026-01-16 12:05:37.185374	entry_date	2024-12-11	2024-06-21
6536	105	1	2026-01-16 12:05:37.185842	resume_link	https://drive.google.com/file/94825	https://drive.google.com/file/74064
6537	105	1	2026-01-16 12:05:37.186246	transfer_date	2025-07-20	
6538	105	1	2026-01-16 12:05:37.186665	placement_type	аутстафф	любой
6539	105	1	2026-01-16 12:05:37.186992	current_manager	Михайлова О.Н.	Петров С.М.
6540	105	1	2026-01-16 12:05:37.187319	target_projects	Data Platform	Infrastructure
6541	105	1	2026-01-16 12:05:37.187621	candidate_status	Переведен	Забронирован
6542	105	1	2026-01-16 12:05:37.187951	funding_end_date	2026-06-22	2026-08-17
6543	105	1	2026-01-16 12:05:37.188235	manager_feedback	Хороший специалист	Нужно развитие
6544	211	1	2026-01-16 12:05:37.206426	comments	Срочно нужен проект	
6545	211	1	2026-01-16 12:05:37.207111	contacts	+7 (900) 546-91-19, @смиилья40, irina.sokolov195@company.ru	+7 (936) 270-57-44, @смиилья66, irina.sokolov195@company.ru
6546	211	1	2026-01-16 12:05:37.207618	it_block	B2O	Диджитал
6547	211	1	2026-01-16 12:05:37.208016	recruiter	Новикова Е.П.	Орлов М.С.
6548	211	1	2026-01-16 12:05:37.208443	entry_date	2024-06-10	2024-02-22
6549	211	1	2026-01-16 12:05:37.20888	resume_link	https://drive.google.com/file/96831	https://drive.google.com/file/16746
6550	211	1	2026-01-16 12:05:37.209407	ck_department	Департамент цифровых продуктов	Департамент данных
6551	211	1	2026-01-16 12:05:37.209776	transfer_date	2026-12-13	
6552	211	1	2026-01-16 12:05:37.210126	placement_type	перевод	аутстафф
6553	211	1	2026-01-16 12:05:37.210498	current_manager	Сидорова Е.К.	Козлов Д.В.
6554	211	1	2026-01-16 12:05:37.210797	target_projects	DevOps Platform, Banking App, E-commerce Platform	DevOps Platform, Госуслуги 2.0
6555	211	1	2026-01-16 12:05:37.211109	candidate_status	Увольнение по СС	В работе
6556	211	1	2026-01-16 12:05:37.211406	funding_end_date	2025-09-25	2026-02-06
6557	211	1	2026-01-16 12:05:37.211793	manager_feedback		Нужно развитие
6558	211	1	2026-01-16 12:05:37.212848	ready_for_vacancy	Нет	Да
6559	57	1	2026-01-16 12:05:37.23355	hr_bp	Лебедева Т.М.	Морозов К.А.
6560	57	1	2026-01-16 12:05:37.234066	contacts	+7 (916) 180-89-53, @алемиха57, alexey.stepanov41@company.ru	+7 (985) 619-94-46, @алемиха4, alexey.stepanov41@company.ru
6561	57	1	2026-01-16 12:05:37.234469	recruiter	Новикова Е.П.	Смирнова А.А.
6562	57	1	2026-01-16 12:05:37.235004	entry_date	2025-03-16	2024-07-12
6563	57	1	2026-01-16 12:05:37.235415	resume_link	https://drive.google.com/file/55835	https://drive.google.com/file/11821
6564	57	1	2026-01-16 12:05:37.23579	ck_department	Департамент данных	Департамент цифровых продуктов
6565	57	1	2026-01-16 12:05:37.236153	placement_type	перевод	аутстафф
6566	57	1	2026-01-16 12:05:37.236515	target_projects	Госуслуги 2.0	E-commerce Platform
6567	57	1	2026-01-16 12:05:37.236881	candidate_status	В работе	Забронирован
6568	57	1	2026-01-16 12:05:37.237218	funding_end_date	2026-12-01	2025-07-16
6569	57	1	2026-01-16 12:05:37.237574	manager_feedback	Нужно развитие	
6570	112	1	2026-01-16 12:05:37.258046	comments		В процессе согласования
7027	457	1	2026-01-16 12:05:38.637802	it_block	НУК	Диджитал
6571	112	1	2026-01-16 12:05:37.258582	contacts	+7 (998) 975-51-86, @михандр65, alexey.solovyov96@company.ru	+7 (980) 161-15-48, @михандр27, alexey.solovyov96@company.ru
6572	112	1	2026-01-16 12:05:37.259157	it_block	НУК	Прочее
6573	112	1	2026-01-16 12:05:37.25953	entry_date	2024-05-21	2025-04-28
6574	112	1	2026-01-16 12:05:37.259833	resume_link	https://drive.google.com/file/73379	https://drive.google.com/file/40323
6575	112	1	2026-01-16 12:05:37.260126	transfer_date	2025-06-26	2026-09-05
6576	112	1	2026-01-16 12:05:37.260498	placement_type	перевод	любой
6577	112	1	2026-01-16 12:05:37.260962	current_manager	Сидорова Е.К.	Петров С.М.
6578	112	1	2026-01-16 12:05:37.26138	target_projects	Banking App, DevOps Platform	Banking App, DevOps Platform, Data Platform
6579	112	1	2026-01-16 12:05:37.262115	funding_end_date	2026-04-23	2026-03-13
6580	112	1	2026-01-16 12:05:37.262471	manager_feedback	Хороший специалист	Рекомендую
6581	112	1	2026-01-16 12:05:37.264546	ready_for_vacancy	Да	Нет
6582	203	1	2026-01-16 12:05:37.305915	hr_bp	Морозов К.А.	Лебедева Т.М.
6583	203	1	2026-01-16 12:05:37.306519	contacts	+7 (917) 747-68-75, @новрома55, yuri.nikolaev187@company.ru	+7 (986) 137-79-70, @новрома93, yuri.nikolaev187@company.ru
6584	203	1	2026-01-16 12:05:37.306874	it_block	Диджитал	Эксплуатация
6585	203	1	2026-01-16 12:05:37.307171	recruiter	Смирнова А.А.	Белова И.Д.
6586	203	1	2026-01-16 12:05:37.307463	entry_date	2024-11-12	2025-05-16
6587	203	1	2026-01-16 12:05:37.307748	resume_link	https://drive.google.com/file/40593	https://drive.google.com/file/59344
6588	203	1	2026-01-16 12:05:37.308028	ck_department	ЦК Разработки	ЦК Аналитики
6589	203	1	2026-01-16 12:05:37.308303	transfer_date		2026-01-30
6590	203	1	2026-01-16 12:05:37.308574	placement_type	перевод	аутстафф
6591	203	1	2026-01-16 12:05:37.308843	current_manager	Козлов Д.В.	Михайлова О.Н.
6592	203	1	2026-01-16 12:05:37.30913	target_projects	Госуслуги 2.0	Infrastructure, E-commerce Platform
6593	203	1	2026-01-16 12:05:37.309533	candidate_status	Свободен	Увольнение по СЖ
6594	203	1	2026-01-16 12:05:37.309958	funding_end_date	2025-02-20	2025-10-21
6595	203	1	2026-01-16 12:05:37.310275	manager_feedback	Хороший специалист	
6596	203	1	2026-01-16 12:05:37.310571	ready_for_vacancy	Нет	Да
6597	131	1	2026-01-16 12:05:37.370506	hr_bp	Морозов К.А.	Лебедева Т.М.
6598	131	1	2026-01-16 12:05:37.371055	contacts	+7 (978) 462-33-86, @волмакс3, vladislav.alexeev115@company.ru	+7 (904) 398-14-31, @волмакс30, vladislav.alexeev115@company.ru
6599	131	1	2026-01-16 12:05:37.371517	it_block	Прочее	НУК
6600	131	1	2026-01-16 12:05:37.371945	recruiter	Новикова Е.П.	Смирнова А.А.
6601	131	1	2026-01-16 12:05:37.372438	entry_date	2025-08-12	2025-09-21
6602	131	1	2026-01-16 12:05:37.373093	resume_link	https://drive.google.com/file/71523	https://drive.google.com/file/46089
6603	131	1	2026-01-16 12:05:37.37368	ck_department	ЦК Инфраструктуры	Департамент цифровых продуктов
6604	131	1	2026-01-16 12:05:37.374498	transfer_date		2026-01-01
6605	131	1	2026-01-16 12:05:37.374923	current_manager	Иванов А.П.	Михайлова О.Н.
6606	131	1	2026-01-16 12:05:37.375305	target_projects	Data Platform, Mobile App, Banking App	Mobile App, ML Pipeline
6607	131	1	2026-01-16 12:05:37.375707	candidate_status	В работе	Увольнение по СС
6608	131	1	2026-01-16 12:05:37.376075	funding_end_date	2025-09-12	2026-07-11
6609	131	1	2026-01-16 12:05:37.376435	manager_feedback	Нужно развитие	Рекомендую
6610	131	1	2026-01-16 12:05:37.376786	ready_for_vacancy	Да	Нет
6611	159	1	2026-01-16 12:05:37.499884	hr_bp	Морозов К.А.	Лебедева Т.М.
6612	159	1	2026-01-16 12:05:37.500751	comments		Ожидает оффер
6613	159	1	2026-01-16 12:05:37.501279	contacts	+7 (970) 341-13-63, @фёдсерг8, timofey.yakovlev143@company.ru	+7 (967) 303-13-62, @фёдсерг91, timofey.yakovlev143@company.ru
6614	159	1	2026-01-16 12:05:37.501953	it_block	B2O	Прочее
6615	159	1	2026-01-16 12:05:37.502446	recruiter	Новикова Е.П.	Белова И.Д.
6616	159	1	2026-01-16 12:05:37.502887	entry_date	2024-09-09	2025-07-20
6617	159	1	2026-01-16 12:05:37.503434	resume_link	https://drive.google.com/file/72845	https://drive.google.com/file/51057
6618	159	1	2026-01-16 12:05:37.503799	transfer_date	2025-05-29	
6619	159	1	2026-01-16 12:05:37.50416	placement_type	перевод	аутстафф
6620	159	1	2026-01-16 12:05:37.504498	current_manager	Сидорова Е.К.	Козлов Д.В.
6621	159	1	2026-01-16 12:05:37.504821	target_projects	Mobile App, Data Platform, Госуслуги 2.0	Banking App, Infrastructure, ML Pipeline
6622	159	1	2026-01-16 12:05:37.505674	candidate_status	Увольнение по СЖ	Свободен
6623	159	1	2026-01-16 12:05:37.506389	funding_end_date	2025-12-01	2026-03-26
6624	159	1	2026-01-16 12:05:37.507157	manager_feedback	Рекомендую	Хороший специалист
6625	159	1	2026-01-16 12:05:37.507663	ready_for_vacancy	Нет	Да
6626	205	1	2026-01-16 12:05:37.539055	hr_bp	Лебедева Т.М.	Волкова Н.В.
6627	205	1	2026-01-16 12:05:37.539692	contacts	+7 (950) 545-53-87, @морники35, maxim.vasilev189@company.ru	+7 (978) 919-16-37, @морники43, maxim.vasilev189@company.ru
6628	205	1	2026-01-16 12:05:37.540234	it_block	Эксплуатация	Развитие
6629	205	1	2026-01-16 12:05:37.548801	recruiter	Смирнова А.А.	Новикова Е.П.
6630	205	1	2026-01-16 12:05:37.549556	entry_date	2025-09-15	2024-07-04
6631	205	1	2026-01-16 12:05:37.550295	resume_link	https://drive.google.com/file/64890	https://drive.google.com/file/82204
6632	205	1	2026-01-16 12:05:37.550833	ck_department	ЦК Разработки	ЦК Инфраструктуры
6633	205	1	2026-01-16 12:05:37.551444	placement_type	аутстафф	перевод
6634	205	1	2026-01-16 12:05:37.551902	target_projects	E-commerce Platform, DevOps Platform	DevOps Platform
6635	205	1	2026-01-16 12:05:37.552389	funding_end_date	2025-01-23	2026-03-31
6638	214	1	2026-01-16 12:05:37.588375	hr_bp	Волкова Н.В.	Морозов К.А.
6639	214	1	2026-01-16 12:05:37.588876	comments	Срочно нужен проект	Ожидает оффер
6640	214	1	2026-01-16 12:05:37.589662	contacts	+7 (944) 992-80-20, @васиван44, grigory.kuzmin198@company.ru	+7 (991) 367-25-51, @васиван93, grigory.kuzmin198@company.ru
6641	214	1	2026-01-16 12:05:37.590079	it_block	Развитие	НУК
6642	214	1	2026-01-16 12:05:37.590586	recruiter	Белова И.Д.	Смирнова А.А.
6643	214	1	2026-01-16 12:05:37.591002	entry_date	2025-09-02	2024-01-03
6644	214	1	2026-01-16 12:05:37.591997	resume_link	https://drive.google.com/file/35796	https://drive.google.com/file/43620
6645	214	1	2026-01-16 12:05:37.59248	ck_department	ЦК Аналитики	ЦК Инфраструктуры
6646	214	1	2026-01-16 12:05:37.59297	transfer_date	2026-10-01	
6647	214	1	2026-01-16 12:05:37.593478	target_projects	Госуслуги 2.0, Banking App, E-commerce Platform	DevOps Platform, Data Platform, Mobile App
6648	214	1	2026-01-16 12:05:37.59421	candidate_status	Переведен	Свободен
6649	214	1	2026-01-16 12:05:37.594598	funding_end_date	2026-12-26	2025-03-15
6650	41	1	2026-01-16 12:05:37.637604	hr_bp	Волкова Н.В.	Лебедева Т.М.
6651	41	1	2026-01-16 12:05:37.638425	contacts	+7 (966) 643-93-44, @волмакс12, tatiana.petrov25@company.ru	+7 (915) 103-50-61, @волмакс32, tatiana.petrov25@company.ru
6652	41	1	2026-01-16 12:05:37.63925	recruiter	Новикова Е.П.	Белова И.Д.
6653	41	1	2026-01-16 12:05:37.639949	entry_date	2024-11-21	2025-06-02
6654	41	1	2026-01-16 12:05:37.640879	resume_link	https://drive.google.com/file/15646	https://drive.google.com/file/66031
6655	41	1	2026-01-16 12:05:37.641577	ck_department	ЦК Инфраструктуры	Департамент цифровых продуктов
6656	41	1	2026-01-16 12:05:37.642053	transfer_date	2026-07-05	2026-01-22
6657	41	1	2026-01-16 12:05:37.64238	placement_type	аутстафф	перевод
6658	41	1	2026-01-16 12:05:37.643055	current_manager	Михайлова О.Н.	Козлов Д.В.
6659	41	1	2026-01-16 12:05:37.643615	target_projects	Infrastructure, ML Pipeline, Mobile App	Infrastructure, Data Platform, DevOps Platform
6660	41	1	2026-01-16 12:05:37.644391	funding_end_date	2026-06-01	2026-06-18
6661	41	1	2026-01-16 12:05:37.645051	manager_feedback		Отличные результаты
6662	41	1	2026-01-16 12:05:37.645618	ready_for_vacancy	Нет	Да
6663	99	1	2026-01-16 12:05:37.675064	contacts	+7 (973) 841-54-34, @фёдсерг22, anton.nikitin83@company.ru	+7 (980) 919-96-48, @фёдсерг74, anton.nikitin83@company.ru
6664	99	1	2026-01-16 12:05:37.675892	it_block	Диджитал	Эксплуатация
6665	99	1	2026-01-16 12:05:37.676483	entry_date	2024-06-04	2025-12-07
6666	99	1	2026-01-16 12:05:37.677275	resume_link	https://drive.google.com/file/97800	https://drive.google.com/file/49489
6667	99	1	2026-01-16 12:05:37.677861	ck_department	ЦК Инфраструктуры	Департамент данных
6668	99	1	2026-01-16 12:05:37.678403	placement_type	перевод	аутстафф
6669	99	1	2026-01-16 12:05:37.679048	current_manager	Иванов А.П.	Козлов Д.В.
6670	99	1	2026-01-16 12:05:37.679755	target_projects	Data Platform, Banking App, Госуслуги 2.0	Infrastructure, Banking App, DevOps Platform
6671	99	1	2026-01-16 12:05:37.680492	candidate_status	Свободен	В работе
6672	99	1	2026-01-16 12:05:37.681375	funding_end_date	2025-04-18	2025-08-16
6673	99	1	2026-01-16 12:05:37.68204	ready_for_vacancy	Да	Нет
6674	135	1	2026-01-16 12:05:37.70172	comments	Срочно нужен проект	В процессе согласования
6675	135	1	2026-01-16 12:05:37.702342	contacts	+7 (958) 214-92-39, @иваалек99, yaroslav.petrov119@company.ru	+7 (943) 138-52-97, @иваалек62, yaroslav.petrov119@company.ru
6676	135	1	2026-01-16 12:05:37.702898	it_block	Развитие	B2O
6677	135	1	2026-01-16 12:05:37.703479	recruiter	Смирнова А.А.	Орлов М.С.
6678	135	1	2026-01-16 12:05:37.704207	entry_date	2024-10-27	2025-06-23
6679	135	1	2026-01-16 12:05:37.7049	resume_link	https://drive.google.com/file/98697	https://drive.google.com/file/48024
6680	135	1	2026-01-16 12:05:37.705567	transfer_date	2025-06-16	2026-02-13
6681	135	1	2026-01-16 12:05:37.706426	placement_type	перевод	любой
6682	135	1	2026-01-16 12:05:37.706946	current_manager	Козлов Д.В.	Петров С.М.
6683	135	1	2026-01-16 12:05:37.708355	target_projects	E-commerce Platform, Mobile App	Data Platform, Mobile App, DevOps Platform
6684	135	1	2026-01-16 12:05:37.709055	funding_end_date	2025-02-07	2026-09-12
6685	135	1	2026-01-16 12:05:37.709868	manager_feedback		Рекомендую
6686	135	1	2026-01-16 12:05:37.71052	ready_for_vacancy	Да	Нет
6687	143	1	2026-01-16 12:05:37.730494	comments	Срочно нужен проект	В процессе согласования
6688	143	1	2026-01-16 12:05:37.731179	contacts	+7 (934) 877-84-68, @новрома30, evgeny.nikolaev127@company.ru	+7 (928) 314-33-62, @новрома54, evgeny.nikolaev127@company.ru
6689	143	1	2026-01-16 12:05:37.731721	recruiter	Белова И.Д.	Орлов М.С.
6690	143	1	2026-01-16 12:05:37.732181	entry_date	2024-06-25	2024-03-15
6691	143	1	2026-01-16 12:05:37.732644	resume_link	https://drive.google.com/file/91743	https://drive.google.com/file/62247
6692	143	1	2026-01-16 12:05:37.733331	placement_type	аутстафф	перевод
6693	143	1	2026-01-16 12:05:37.733936	current_manager	Михайлова О.Н.	Козлов Д.В.
6694	143	1	2026-01-16 12:05:37.73435	target_projects	Banking App, Data Platform	ML Pipeline, Infrastructure, Banking App
6695	143	1	2026-01-16 12:05:37.735058	candidate_status	Забронирован	Свободен
6696	143	1	2026-01-16 12:05:37.73559	funding_end_date	2025-03-27	2026-10-18
6697	143	1	2026-01-16 12:05:37.736415	manager_feedback	Нужно развитие	Отличные результаты
6698	143	1	2026-01-16 12:05:37.737053	ready_for_vacancy	Да	Нет
6699	160	1	2026-01-16 12:05:37.761308	hr_bp	Лебедева Т.М.	Волкова Н.В.
6700	160	1	2026-01-16 12:05:37.761781	comments		В процессе согласования
6830	434	1	2026-01-16 12:05:38.083912	manager_feedback	Рекомендую	Нужно развитие
6701	160	1	2026-01-16 12:05:37.762106	contacts	+7 (947) 613-43-46, @морники46, nikolay.borisov144@company.ru	+7 (907) 968-42-24, @морники17, nikolay.borisov144@company.ru
6702	160	1	2026-01-16 12:05:37.762517	it_block	Развитие	НУК
6703	160	1	2026-01-16 12:05:37.762815	recruiter	Белова И.Д.	Новикова Е.П.
6704	160	1	2026-01-16 12:05:37.763112	entry_date	2024-01-31	2024-08-20
6705	160	1	2026-01-16 12:05:37.7634	resume_link	https://drive.google.com/file/39815	https://drive.google.com/file/20711
6706	160	1	2026-01-16 12:05:37.763677	ck_department	ЦК Аналитики	ЦК Разработки
6707	160	1	2026-01-16 12:05:37.763954	placement_type	перевод	любой
6708	160	1	2026-01-16 12:05:37.764226	current_manager	Сидорова Е.К.	Михайлова О.Н.
6709	160	1	2026-01-16 12:05:37.764536	target_projects	E-commerce Platform, DevOps Platform, Data Platform	ML Pipeline
6710	160	1	2026-01-16 12:05:37.764967	candidate_status	В работе	Забронирован
6711	160	1	2026-01-16 12:05:37.76542	funding_end_date	2026-03-21	2025-11-27
6712	160	1	2026-01-16 12:05:37.76614	manager_feedback	Отличные результаты	Рекомендую
6713	160	1	2026-01-16 12:05:37.766583	ready_for_vacancy	Нет	Да
6714	167	1	2026-01-16 12:05:37.786165	hr_bp	Лебедева Т.М.	Волкова Н.В.
6715	167	1	2026-01-16 12:05:37.786922	contacts	+7 (970) 280-97-18, @куздени18, matvey.kuznetsov151@company.ru	+7 (972) 436-82-87, @куздени13, matvey.kuznetsov151@company.ru
6716	167	1	2026-01-16 12:05:37.787409	it_block	Эксплуатация	НУК
6717	167	1	2026-01-16 12:05:37.787749	recruiter	Орлов М.С.	Смирнова А.А.
6718	167	1	2026-01-16 12:05:37.788048	entry_date	2025-05-30	2024-08-11
6719	167	1	2026-01-16 12:05:37.788331	resume_link	https://drive.google.com/file/90860	https://drive.google.com/file/30465
6720	167	1	2026-01-16 12:05:37.788623	ck_department	ЦК Разработки	ЦК Инфраструктуры
6721	167	1	2026-01-16 12:05:37.788904	current_manager	Михайлова О.Н.	Сидорова Е.К.
6722	167	1	2026-01-16 12:05:37.7892	target_projects	ML Pipeline, DevOps Platform	ML Pipeline
6723	167	1	2026-01-16 12:05:37.789666	funding_end_date	2025-11-28	2025-05-30
6724	167	1	2026-01-16 12:05:37.790015	manager_feedback	Хороший специалист	
6725	168	1	2026-01-16 12:05:37.809958	comments	Срочно нужен проект	
6726	168	1	2026-01-16 12:05:37.810724	contacts	+7 (980) 539-92-50, @попартё32, artem.kuznetsov152@company.ru	+7 (994) 820-29-64, @попартё95, artem.kuznetsov152@company.ru
6727	168	1	2026-01-16 12:05:37.811277	it_block	НУК	Развитие
6728	168	1	2026-01-16 12:05:37.811684	recruiter	Новикова Е.П.	Орлов М.С.
6729	168	1	2026-01-16 12:05:37.812022	entry_date	2024-06-06	2025-02-22
6730	168	1	2026-01-16 12:05:37.812334	resume_link	https://drive.google.com/file/11010	https://drive.google.com/file/81437
6731	168	1	2026-01-16 12:05:37.812687	ck_department	Департамент цифровых продуктов	ЦК Разработки
6732	168	1	2026-01-16 12:05:37.813122	placement_type	любой	аутстафф
6733	168	1	2026-01-16 12:05:37.813702	current_manager	Сидорова Е.К.	Иванов А.П.
6734	168	1	2026-01-16 12:05:37.814196	target_projects	DevOps Platform, Data Platform, Mobile App	ML Pipeline, E-commerce Platform, Госуслуги 2.0
6735	168	1	2026-01-16 12:05:37.814991	candidate_status	В работе	Забронирован
6736	168	1	2026-01-16 12:05:37.815595	funding_end_date	2025-01-19	2026-12-30
6737	168	1	2026-01-16 12:05:37.816189	manager_feedback		Отличные результаты
6738	188	1	2026-01-16 12:05:37.841454	hr_bp	Волкова Н.В.	Лебедева Т.М.
6739	188	1	2026-01-16 12:05:37.842073	comments	Ожидает оффер	В процессе согласования
6740	188	1	2026-01-16 12:05:37.842762	contacts	+7 (904) 359-60-29, @новрома40, sergey.novikov172@company.ru	+7 (994) 881-84-57, @новрома94, sergey.novikov172@company.ru
6741	188	1	2026-01-16 12:05:37.843224	it_block	Эксплуатация	Развитие
6742	188	1	2026-01-16 12:05:37.843707	recruiter	Новикова Е.П.	Смирнова А.А.
6743	188	1	2026-01-16 12:05:37.844206	entry_date	2024-04-24	2025-08-31
6744	188	1	2026-01-16 12:05:37.844891	resume_link	https://drive.google.com/file/80308	https://drive.google.com/file/94290
6745	188	1	2026-01-16 12:05:37.84541	ck_department	ЦК Аналитики	ЦК Разработки
6746	188	1	2026-01-16 12:05:37.845952	current_manager	Козлов Д.В.	Михайлова О.Н.
6747	188	1	2026-01-16 12:05:37.846564	target_projects	Mobile App, ML Pipeline, Infrastructure	DevOps Platform, Infrastructure, Banking App
6748	188	1	2026-01-16 12:05:37.847565	candidate_status	Свободен	В работе
6749	188	1	2026-01-16 12:05:37.847892	funding_end_date	2026-09-14	2026-03-31
6750	188	1	2026-01-16 12:05:37.848278	ready_for_vacancy	Нет	Да
6751	206	1	2026-01-16 12:05:37.864642	hr_bp	Лебедева Т.М.	Волкова Н.В.
6752	206	1	2026-01-16 12:05:37.865062	comments		Ожидает оффер
6753	206	1	2026-01-16 12:05:37.865397	contacts	+7 (994) 968-86-12, @волмакс78, maxim.popov190@company.ru	+7 (981) 211-25-59, @волмакс92, maxim.popov190@company.ru
6754	206	1	2026-01-16 12:05:37.865876	it_block	Диджитал	Прочее
6755	206	1	2026-01-16 12:05:37.866315	entry_date	2025-04-25	2024-03-13
6756	206	1	2026-01-16 12:05:37.866624	resume_link	https://drive.google.com/file/80303	https://drive.google.com/file/57155
6757	206	1	2026-01-16 12:05:37.866927	placement_type	перевод	аутстафф
6758	206	1	2026-01-16 12:05:37.867199	current_manager	Михайлова О.Н.	Козлов Д.В.
6759	206	1	2026-01-16 12:05:37.86747	target_projects	Banking App, Infrastructure	Banking App
6760	206	1	2026-01-16 12:05:37.867739	funding_end_date	2025-01-17	2025-07-29
6761	206	1	2026-01-16 12:05:37.868342	manager_feedback	Рекомендую	Хороший специалист
6762	206	1	2026-01-16 12:05:37.868752	ready_for_vacancy	Да	Нет
6763	66	1	2026-01-16 12:05:37.889069	hr_bp	Морозов К.А.	Лебедева Т.М.
6764	66	1	2026-01-16 12:05:37.889728	comments		Ожидает оффер
6765	66	1	2026-01-16 12:05:37.890561	contacts	+7 (903) 605-64-61, @сокегор46, natalia.orlov50@company.ru	+7 (970) 147-47-48, @сокегор98, natalia.orlov50@company.ru
6766	66	1	2026-01-16 12:05:37.891114	entry_date	2024-03-11	2025-10-01
6767	66	1	2026-01-16 12:05:37.891611	resume_link	https://drive.google.com/file/80169	https://drive.google.com/file/90532
6768	66	1	2026-01-16 12:05:37.892154	ck_department	Департамент данных	ЦК Инфраструктуры
6769	66	1	2026-01-16 12:05:37.8926	placement_type	перевод	любой
6770	66	1	2026-01-16 12:05:37.893042	current_manager	Петров С.М.	Сидорова Е.К.
6771	66	1	2026-01-16 12:05:37.893442	target_projects	Data Platform, Госуслуги 2.0	Data Platform, Госуслуги 2.0, ML Pipeline
6772	66	1	2026-01-16 12:05:37.893793	candidate_status	Свободен	В работе
6773	66	1	2026-01-16 12:05:37.894083	funding_end_date	2026-05-08	2026-08-17
6774	66	1	2026-01-16 12:05:37.894374	manager_feedback	Нужно развитие	
6775	66	1	2026-01-16 12:05:37.894654	ready_for_vacancy	Да	Нет
6776	181	1	2026-01-16 12:05:37.914665	hr_bp	Волкова Н.В.	Лебедева Т.М.
6777	181	1	2026-01-16 12:05:37.915479	comments		В процессе согласования
6778	181	1	2026-01-16 12:05:37.916034	contacts	+7 (927) 174-20-97, @смиилья76, mark.novikov165@company.ru	+7 (985) 644-44-30, @смиилья30, mark.novikov165@company.ru
6779	181	1	2026-01-16 12:05:37.917475	it_block	Диджитал	B2O
6780	181	1	2026-01-16 12:05:37.91851	recruiter	Орлов М.С.	Белова И.Д.
6781	181	1	2026-01-16 12:05:37.919039	entry_date	2024-05-27	2025-06-08
6782	181	1	2026-01-16 12:05:37.919674	resume_link	https://drive.google.com/file/69092	https://drive.google.com/file/65355
6783	181	1	2026-01-16 12:05:37.920318	ck_department	ЦК Разработки	Департамент данных
6784	181	1	2026-01-16 12:05:37.921001	transfer_date	2026-11-24	
6785	181	1	2026-01-16 12:05:37.921574	placement_type	перевод	любой
6786	181	1	2026-01-16 12:05:37.922392	current_manager	Иванов А.П.	Михайлова О.Н.
6787	181	1	2026-01-16 12:05:37.922903	target_projects	Госуслуги 2.0, Infrastructure, Data Platform	Mobile App, Data Platform, E-commerce Platform
6788	181	1	2026-01-16 12:05:37.923412	candidate_status	Увольнение по СС	Забронирован
6789	181	1	2026-01-16 12:05:37.923882	funding_end_date	2025-10-20	2025-04-22
6790	181	1	2026-01-16 12:05:37.924447	ready_for_vacancy	Да	Нет
6791	68	1	2026-01-16 12:05:37.950132	comments		Срочно нужен проект
6792	68	1	2026-01-16 12:05:37.950853	contacts	+7 (951) 545-57-85, @новрома21, mark.novikov52@company.ru	+7 (958) 101-15-95, @новрома21, mark.novikov52@company.ru
6793	68	1	2026-01-16 12:05:37.951415	recruiter	Смирнова А.А.	Белова И.Д.
6794	68	1	2026-01-16 12:05:37.952102	entry_date	2025-02-24	2024-11-22
6795	68	1	2026-01-16 12:05:37.952675	resume_link	https://drive.google.com/file/46937	https://drive.google.com/file/54385
6796	68	1	2026-01-16 12:05:37.953474	ck_department	ЦК Инфраструктуры	Департамент данных
6797	68	1	2026-01-16 12:05:37.954095	transfer_date	2026-07-12	2025-09-21
6798	68	1	2026-01-16 12:05:37.95466	placement_type	перевод	аутстафф
6799	68	1	2026-01-16 12:05:37.955098	current_manager	Сидорова Е.К.	Петров С.М.
6800	68	1	2026-01-16 12:05:37.955597	target_projects	Infrastructure, E-commerce Platform	ML Pipeline
6801	68	1	2026-01-16 12:05:37.956039	funding_end_date	2025-02-05	2026-03-04
6802	68	1	2026-01-16 12:05:37.956467	manager_feedback	Нужно развитие	
6803	432	1	2026-01-16 12:05:38.042964	hr_bp	Морозов К.А.	Волкова Н.В.
6804	432	1	2026-01-16 12:05:38.043557	comments		В процессе согласования
6805	432	1	2026-01-16 12:05:38.044165	contacts	+7 (999) 421-77-46, @тарвале47, v.tarasova@rt.ru	+7 (938) 706-45-64, @тарвале91, v.tarasova@rt.ru
6806	432	1	2026-01-16 12:05:38.044755	entry_date	2025-02-14	2025-09-15
6807	432	1	2026-01-16 12:05:38.045348	resume_link	https://drive.google.com/file/65117	https://drive.google.com/file/24232
6808	432	1	2026-01-16 12:05:38.04583	ck_department	ЦК Разработки	Департамент цифровых продуктов
6809	432	1	2026-01-16 12:05:38.04646	transfer_date	2026-04-29	2025-08-22
6810	432	1	2026-01-16 12:05:38.046964	placement_type	перевод	аутстафф
6811	432	1	2026-01-16 12:05:38.047579	current_manager	Михайлова О.Н.	Сидорова Е.К.
6812	432	1	2026-01-16 12:05:38.048387	target_projects	ML Pipeline, Mobile App	Banking App, Data Platform
6813	432	1	2026-01-16 12:05:38.048916	candidate_status	Увольнение по СЖ	Переведен
6814	432	1	2026-01-16 12:05:38.049643	funding_end_date	2026-01-04	2025-07-04
6815	432	1	2026-01-16 12:05:38.050065	manager_feedback	Рекомендую	Отличные результаты
6816	432	1	2026-01-16 12:05:38.050637	ready_for_vacancy	Да	Нет
6817	434	1	2026-01-16 12:05:38.079302	hr_bp	Волкова Н.В.	Морозов К.А.
6818	434	1	2026-01-16 12:05:38.080108	contacts	+7 (903) 304-67-79, @ковксен95, k.kovaleva@rt.ru	+7 (930) 915-19-32, @ковксен5, k.kovaleva@rt.ru
6819	434	1	2026-01-16 12:05:38.080647	it_block	Прочее	Развитие
6820	434	1	2026-01-16 12:05:38.081004	recruiter	Новикова Е.П.	Белова И.Д.
6821	434	1	2026-01-16 12:05:38.081386	entry_date	2024-11-14	2024-10-13
6822	434	1	2026-01-16 12:05:38.081721	resume_link	https://drive.google.com/file/14076	https://drive.google.com/file/28701
6823	434	1	2026-01-16 12:05:38.082001	ck_department	ЦК Разработки	ЦК Аналитики
6824	434	1	2026-01-16 12:05:38.08229	transfer_date	2025-06-23	2025-12-11
6825	434	1	2026-01-16 12:05:38.082567	placement_type	перевод	аутстафф
6826	434	1	2026-01-16 12:05:38.082829	current_manager	Михайлова О.Н.	Сидорова Е.К.
6827	434	1	2026-01-16 12:05:38.083092	target_projects	Mobile App, ML Pipeline	DevOps Platform
6828	434	1	2026-01-16 12:05:38.083355	candidate_status	Переведен	Увольнение по СС
6829	434	1	2026-01-16 12:05:38.083631	funding_end_date	2026-01-31	2026-12-22
6831	435	1	2026-01-16 12:05:38.107886	hr_bp	Морозов К.А.	Лебедева Т.М.
6832	435	1	2026-01-16 12:05:38.108411	contacts	+7 (955) 849-84-25, @алеконс75, k.alekseev@rt.ru	+7 (925) 520-85-73, @алеконс21, k.alekseev@rt.ru
6833	435	1	2026-01-16 12:05:38.108759	it_block	НУК	Эксплуатация
6834	435	1	2026-01-16 12:05:38.10905	recruiter	Смирнова А.А.	Белова И.Д.
6835	435	1	2026-01-16 12:05:38.109434	entry_date	2025-01-26	2024-03-28
6836	435	1	2026-01-16 12:05:38.110102	resume_link	https://drive.google.com/file/20585	https://drive.google.com/file/22171
6837	435	1	2026-01-16 12:05:38.110445	current_manager	Козлов Д.В.	Сидорова Е.К.
6838	435	1	2026-01-16 12:05:38.110734	target_projects	Госуслуги 2.0	Banking App, DevOps Platform, ML Pipeline
6839	435	1	2026-01-16 12:05:38.111009	candidate_status	Свободен	В работе
6840	435	1	2026-01-16 12:05:38.11136	funding_end_date	2025-03-13	2026-05-12
6841	435	1	2026-01-16 12:05:38.112043	ready_for_vacancy	Нет	Да
6842	436	1	2026-01-16 12:05:38.132584	hr_bp	Волкова Н.В.	Лебедева Т.М.
6843	436	1	2026-01-16 12:05:38.133516	comments	Срочно нужен проект	
6844	436	1	2026-01-16 12:05:38.134109	contacts	+7 (987) 888-10-71, @смиюлия79, yu.smirnova@rt.ru	+7 (977) 799-85-55, @смиюлия50, yu.smirnova@rt.ru
6845	436	1	2026-01-16 12:05:38.134659	it_block	Прочее	НУК
6846	436	1	2026-01-16 12:05:38.135128	entry_date	2024-09-07	2024-11-08
6847	436	1	2026-01-16 12:05:38.135628	resume_link	https://drive.google.com/file/54190	https://drive.google.com/file/73451
6848	436	1	2026-01-16 12:05:38.136332	ck_department	ЦК Разработки	Департамент цифровых продуктов
6849	436	1	2026-01-16 12:05:38.136778	transfer_date	2026-09-13	2025-03-22
6850	436	1	2026-01-16 12:05:38.137221	placement_type	любой	перевод
6851	436	1	2026-01-16 12:05:38.137944	target_projects	ML Pipeline, Mobile App	Infrastructure, E-commerce Platform, ML Pipeline
6852	436	1	2026-01-16 12:05:38.138508	candidate_status	Увольнение по СЖ	Увольнение по СС
6853	436	1	2026-01-16 12:05:38.138964	funding_end_date	2025-02-26	2025-09-14
6854	436	1	2026-01-16 12:05:38.139473	manager_feedback	Рекомендую	
6855	436	1	2026-01-16 12:05:38.140083	ready_for_vacancy	Да	Нет
6856	437	1	2026-01-16 12:05:38.171384	comments		Срочно нужен проект
6857	437	1	2026-01-16 12:05:38.172074	contacts	+7 (963) 931-88-20, @медолег77, o.medvedev@rt.ru	+7 (925) 945-46-63, @медолег38, o.medvedev@rt.ru
6858	437	1	2026-01-16 12:05:38.172543	it_block	Эксплуатация	Развитие
6859	437	1	2026-01-16 12:05:38.173004	entry_date	2025-01-14	2025-07-02
6860	437	1	2026-01-16 12:05:38.173535	resume_link	https://drive.google.com/file/77252	https://drive.google.com/file/18973
6861	437	1	2026-01-16 12:05:38.173996	transfer_date	2026-04-11	
6862	437	1	2026-01-16 12:05:38.174442	current_manager	Козлов Д.В.	Петров С.М.
6863	437	1	2026-01-16 12:05:38.175012	target_projects	E-commerce Platform, Infrastructure, Banking App	E-commerce Platform, ML Pipeline, Data Platform
6864	437	1	2026-01-16 12:05:38.175473	candidate_status	Переведен	Свободен
6865	437	1	2026-01-16 12:05:38.175974	funding_end_date	2026-01-18	2025-07-02
6866	437	1	2026-01-16 12:05:38.176433	manager_feedback	Рекомендую	
6867	438	1	2026-01-16 12:05:38.271211	hr_bp	Волкова Н.В.	Морозов К.А.
6868	438	1	2026-01-16 12:05:38.27528	contacts	+7 (905) 359-72-13, @орлники94, n.orlov@rt.ru	+7 (947) 852-68-95, @орлники41, n.orlov@rt.ru
6869	438	1	2026-01-16 12:05:38.27569	it_block	B2O	Эксплуатация
6870	438	1	2026-01-16 12:05:38.276053	entry_date	2024-01-05	2025-09-14
6871	438	1	2026-01-16 12:05:38.276416	resume_link	https://drive.google.com/file/59025	https://drive.google.com/file/86079
6872	438	1	2026-01-16 12:05:38.276756	transfer_date		2026-12-29
6873	438	1	2026-01-16 12:05:38.277164	placement_type	перевод	аутстафф
6874	438	1	2026-01-16 12:05:38.277559	current_manager	Петров С.М.	Козлов Д.В.
6875	438	1	2026-01-16 12:05:38.277899	target_projects	Infrastructure, DevOps Platform	Infrastructure, Госуслуги 2.0
6876	438	1	2026-01-16 12:05:38.278235	candidate_status	В работе	Увольнение по СС
6877	438	1	2026-01-16 12:05:38.278584	funding_end_date	2026-09-22	2025-11-07
6878	438	1	2026-01-16 12:05:38.278915	manager_feedback	Нужно развитие	Отличные результаты
6879	440	1	2026-01-16 12:05:38.311235	hr_bp	Волкова Н.В.	Морозов К.А.
6880	440	1	2026-01-16 12:05:38.311872	comments		В процессе согласования
6881	440	1	2026-01-16 12:05:38.312273	contacts	+7 (972) 462-93-62, @ильилья63, i.ilin@rt.ru	+7 (994) 916-66-18, @ильилья28, i.ilin@rt.ru
6882	440	1	2026-01-16 12:05:38.313016	it_block	Развитие	Диджитал
6883	440	1	2026-01-16 12:05:38.31406	recruiter	Белова И.Д.	Орлов М.С.
6884	440	1	2026-01-16 12:05:38.315207	entry_date	2025-01-14	2025-03-29
6885	440	1	2026-01-16 12:05:38.315838	resume_link	https://drive.google.com/file/60290	https://drive.google.com/file/13674
6886	440	1	2026-01-16 12:05:38.316345	ck_department	ЦК Инфраструктуры	ЦК Аналитики
6887	440	1	2026-01-16 12:05:38.316862	transfer_date	2025-04-26	
6888	440	1	2026-01-16 12:05:38.317437	placement_type	аутстафф	перевод
6889	440	1	2026-01-16 12:05:38.318059	current_manager	Иванов А.П.	Михайлова О.Н.
6890	440	1	2026-01-16 12:05:38.318699	target_projects	ML Pipeline, Infrastructure	Data Platform
6891	440	1	2026-01-16 12:05:38.319559	candidate_status	Увольнение по СС	Свободен
6892	440	1	2026-01-16 12:05:38.321053	funding_end_date	2025-02-24	2025-09-06
6893	440	1	2026-01-16 12:05:38.32266	manager_feedback	Хороший специалист	Отличные результаты
6894	441	1	2026-01-16 12:05:38.350797	hr_bp	Лебедева Т.М.	Морозов К.А.
6895	441	1	2026-01-16 12:05:38.351299	comments	В процессе согласования	Срочно нужен проект
6961	450	1	2026-01-16 12:05:38.488228	recruiter	Орлов М.С.	Новикова Е.П.
6896	441	1	2026-01-16 12:05:38.351864	contacts	+7 (956) 966-38-26, @анталин40, a.antonova@rt.ru	+7 (963) 710-86-77, @анталин37, a.antonova@rt.ru
6897	441	1	2026-01-16 12:05:38.352436	it_block	НУК	Развитие
6898	441	1	2026-01-16 12:05:38.35319	recruiter	Смирнова А.А.	Орлов М.С.
6899	441	1	2026-01-16 12:05:38.353824	entry_date	2024-12-05	2025-08-14
6900	441	1	2026-01-16 12:05:38.35425	resume_link	https://drive.google.com/file/59127	https://drive.google.com/file/78232
6901	441	1	2026-01-16 12:05:38.354615	ck_department	ЦК Аналитики	Департамент данных
6902	441	1	2026-01-16 12:05:38.354995	transfer_date		2026-04-24
6903	441	1	2026-01-16 12:05:38.356236	placement_type	перевод	аутстафф
6904	441	1	2026-01-16 12:05:38.356927	target_projects	Data Platform, Mobile App	Mobile App
6905	441	1	2026-01-16 12:05:38.35743	candidate_status	В работе	Увольнение по СЖ
6906	441	1	2026-01-16 12:05:38.357876	funding_end_date	2026-10-15	2025-01-25
6907	441	1	2026-01-16 12:05:38.358273	manager_feedback	Рекомендую	
6908	441	1	2026-01-16 12:05:38.358631	ready_for_vacancy	Нет	Да
6909	443	1	2026-01-16 12:05:38.382083	contacts	+7 (954) 765-89-71, @полксен86, k.polyakova@rt.ru	+7 (965) 441-89-98, @полксен56, k.polyakova@rt.ru
6910	443	1	2026-01-16 12:05:38.382618	it_block	НУК	Прочее
6911	443	1	2026-01-16 12:05:38.382964	entry_date	2024-11-16	2025-09-18
6912	443	1	2026-01-16 12:05:38.384123	resume_link	https://drive.google.com/file/16172	https://drive.google.com/file/19641
6913	443	1	2026-01-16 12:05:38.384654	ck_department	ЦК Разработки	ЦК Инфраструктуры
6914	443	1	2026-01-16 12:05:38.385256	transfer_date		2025-09-26
6915	443	1	2026-01-16 12:05:38.385825	placement_type	аутстафф	перевод
6916	443	1	2026-01-16 12:05:38.386365	current_manager	Иванов А.П.	Козлов Д.В.
6917	443	1	2026-01-16 12:05:38.386942	target_projects	Infrastructure, E-commerce Platform, Госуслуги 2.0	ML Pipeline
6918	443	1	2026-01-16 12:05:38.387375	candidate_status	Забронирован	Увольнение по СЖ
6919	443	1	2026-01-16 12:05:38.387684	funding_end_date	2025-10-12	2025-05-25
6920	445	1	2026-01-16 12:05:38.407532	comments	В процессе согласования	
6921	445	1	2026-01-16 12:05:38.408221	contacts	+7 (962) 701-42-72, @сокрусл22, r.sokolov@rt.ru	+7 (993) 843-15-71, @сокрусл70, r.sokolov@rt.ru
6922	445	1	2026-01-16 12:05:38.408751	it_block	Эксплуатация	Развитие
6923	445	1	2026-01-16 12:05:38.409214	recruiter	Орлов М.С.	Белова И.Д.
6924	445	1	2026-01-16 12:05:38.409892	entry_date	2025-02-03	2024-12-16
6925	445	1	2026-01-16 12:05:38.410322	resume_link	https://drive.google.com/file/45574	https://drive.google.com/file/68206
6926	445	1	2026-01-16 12:05:38.410638	ck_department	ЦК Разработки	ЦК Аналитики
6927	445	1	2026-01-16 12:05:38.411496	current_manager	Михайлова О.Н.	Петров С.М.
6928	445	1	2026-01-16 12:05:38.411808	target_projects	DevOps Platform	E-commerce Platform, Mobile App, ML Pipeline
6929	445	1	2026-01-16 12:05:38.412088	candidate_status	В работе	Забронирован
6930	445	1	2026-01-16 12:05:38.412364	funding_end_date	2025-01-25	2025-01-07
6931	445	1	2026-01-16 12:05:38.412938	manager_feedback	Рекомендую	Отличные результаты
6932	446	1	2026-01-16 12:05:38.434035	hr_bp	Лебедева Т.М.	Волкова Н.В.
6933	446	1	2026-01-16 12:05:38.434537	comments	Срочно нужен проект	
6934	446	1	2026-01-16 12:05:38.435264	contacts	+7 (969) 602-66-48, @семматв31, m.semenov@rt.ru	+7 (942) 407-60-95, @семматв14, m.semenov@rt.ru
6935	446	1	2026-01-16 12:05:38.435911	it_block	НУК	Развитие
6936	446	1	2026-01-16 12:05:38.436516	recruiter	Орлов М.С.	Смирнова А.А.
6937	446	1	2026-01-16 12:05:38.437306	entry_date	2024-01-09	2025-07-06
6938	446	1	2026-01-16 12:05:38.437725	resume_link	https://drive.google.com/file/21929	https://drive.google.com/file/71857
6939	446	1	2026-01-16 12:05:38.438263	ck_department	Департамент данных	ЦК Аналитики
6940	446	1	2026-01-16 12:05:38.438711	transfer_date	2026-10-12	2025-07-26
6941	446	1	2026-01-16 12:05:38.439186	target_projects	Banking App, Infrastructure	Data Platform, Госуслуги 2.0, Banking App
6942	446	1	2026-01-16 12:05:38.439737	funding_end_date	2025-10-03	2026-10-09
6943	446	1	2026-01-16 12:05:38.440057	manager_feedback	Рекомендую	Нужно развитие
6944	448	1	2026-01-16 12:05:38.457391	comments	Срочно нужен проект	
6945	448	1	2026-01-16 12:05:38.457845	contacts	+7 (930) 706-76-41, @семрусл73, r.semenov@rt.ru	+7 (985) 342-40-30, @семрусл13, r.semenov@rt.ru
6946	448	1	2026-01-16 12:05:38.45817	recruiter	Белова И.Д.	Смирнова А.А.
6947	448	1	2026-01-16 12:05:38.458496	entry_date	2024-11-09	2024-09-18
6948	448	1	2026-01-16 12:05:38.458782	resume_link	https://drive.google.com/file/80425	https://drive.google.com/file/50935
6949	448	1	2026-01-16 12:05:38.459058	ck_department	Департамент данных	ЦК Аналитики
6950	448	1	2026-01-16 12:05:38.459329	transfer_date	2026-04-01	2026-08-01
6951	448	1	2026-01-16 12:05:38.459694	placement_type	перевод	аутстафф
6952	448	1	2026-01-16 12:05:38.46023	current_manager	Иванов А.П.	Козлов Д.В.
6953	448	1	2026-01-16 12:05:38.460697	target_projects	Mobile App, Госуслуги 2.0, E-commerce Platform	DevOps Platform, ML Pipeline, Infrastructure
6954	448	1	2026-01-16 12:05:38.461388	candidate_status	Переведен	Увольнение по СС
6955	448	1	2026-01-16 12:05:38.462034	funding_end_date	2025-10-10	2025-12-26
6956	448	1	2026-01-16 12:05:38.462541	manager_feedback	Отличные результаты	Рекомендую
6957	448	1	2026-01-16 12:05:38.463014	ready_for_vacancy	Нет	Да
6958	450	1	2026-01-16 12:05:38.486095	hr_bp	Волкова Н.В.	Лебедева Т.М.
6959	450	1	2026-01-16 12:05:38.486812	contacts	+7 (911) 480-92-37, @кисдени59, d.kiselev@rt.ru	+7 (943) 713-60-47, @кисдени5, d.kiselev@rt.ru
6960	450	1	2026-01-16 12:05:38.487424	it_block	Развитие	Диджитал
6963	450	1	2026-01-16 12:05:38.489458	resume_link	https://drive.google.com/file/48261	https://drive.google.com/file/71128
6964	450	1	2026-01-16 12:05:38.49016	ck_department	ЦК Аналитики	Департамент цифровых продуктов
6965	450	1	2026-01-16 12:05:38.490796	transfer_date	2026-03-11	2025-09-02
6966	450	1	2026-01-16 12:05:38.491196	current_manager	Михайлова О.Н.	Петров С.М.
6967	450	1	2026-01-16 12:05:38.491855	target_projects	Госуслуги 2.0, Infrastructure, ML Pipeline	Infrastructure, ML Pipeline, DevOps Platform
6968	450	1	2026-01-16 12:05:38.4925	candidate_status	Увольнение по СЖ	Увольнение по СС
6969	450	1	2026-01-16 12:05:38.492861	funding_end_date	2025-01-21	2026-05-09
6970	450	1	2026-01-16 12:05:38.493279	manager_feedback		Нужно развитие
6971	450	1	2026-01-16 12:05:38.493706	ready_for_vacancy	Да	Нет
6972	451	1	2026-01-16 12:05:38.513556	hr_bp	Волкова Н.В.	Лебедева Т.М.
6973	451	1	2026-01-16 12:05:38.514614	comments		В процессе согласования
6974	451	1	2026-01-16 12:05:38.515462	contacts	+7 (904) 185-41-90, @егоарсе8, a.egorov@rt.ru	+7 (953) 890-35-96, @егоарсе42, a.egorov@rt.ru
6975	451	1	2026-01-16 12:05:38.515994	it_block	Развитие	B2O
6976	451	1	2026-01-16 12:05:38.516499	recruiter	Белова И.Д.	Орлов М.С.
6977	451	1	2026-01-16 12:05:38.517177	entry_date	2025-12-06	2024-08-23
6978	451	1	2026-01-16 12:05:38.517861	resume_link	https://drive.google.com/file/33247	https://drive.google.com/file/39002
6979	451	1	2026-01-16 12:05:38.518392	ck_department	Департамент цифровых продуктов	Департамент данных
6980	451	1	2026-01-16 12:05:38.519005	transfer_date		2025-10-15
6981	451	1	2026-01-16 12:05:38.519705	current_manager	Сидорова Е.К.	Михайлова О.Н.
6982	451	1	2026-01-16 12:05:38.520215	target_projects	E-commerce Platform, Infrastructure	ML Pipeline, DevOps Platform, Mobile App
6983	451	1	2026-01-16 12:05:38.520689	candidate_status	В работе	Увольнение по СЖ
6984	451	1	2026-01-16 12:05:38.521145	funding_end_date	2026-02-11	2025-02-18
6985	451	1	2026-01-16 12:05:38.521802	manager_feedback		Нужно развитие
6986	453	1	2026-01-16 12:05:38.54059	hr_bp	Лебедева Т.М.	Волкова Н.В.
6987	453	1	2026-01-16 12:05:38.54115	contacts	+7 (926) 247-85-80, @макалек68, a.maksimova@rt.ru	+7 (961) 279-93-95, @макалек45, a.maksimova@rt.ru
6988	453	1	2026-01-16 12:05:38.541743	it_block	Прочее	Развитие
6989	453	1	2026-01-16 12:05:38.542452	entry_date	2024-04-27	2024-04-30
6990	453	1	2026-01-16 12:05:38.543038	resume_link	https://drive.google.com/file/76772	https://drive.google.com/file/70178
6991	453	1	2026-01-16 12:05:38.543717	ck_department	ЦК Инфраструктуры	ЦК Аналитики
6992	453	1	2026-01-16 12:05:38.544068	transfer_date		2025-01-25
6993	453	1	2026-01-16 12:05:38.544471	placement_type	любой	перевод
6994	453	1	2026-01-16 12:05:38.545042	current_manager	Иванов А.П.	Петров С.М.
6995	453	1	2026-01-16 12:05:38.545577	target_projects	E-commerce Platform, Data Platform, Госуслуги 2.0	Banking App, Mobile App, E-commerce Platform
6996	453	1	2026-01-16 12:05:38.546205	candidate_status	В работе	Увольнение по СЖ
6997	453	1	2026-01-16 12:05:38.547192	funding_end_date	2026-04-28	2025-01-25
6998	453	1	2026-01-16 12:05:38.547823	manager_feedback	Хороший специалист	Рекомендую
6999	455	1	2026-01-16 12:05:38.566467	comments		Срочно нужен проект
7000	455	1	2026-01-16 12:05:38.567041	contacts	+7 (976) 752-43-38, @кисолег81, o.kiselev@rt.ru	+7 (975) 327-14-45, @кисолег28, o.kiselev@rt.ru
7001	455	1	2026-01-16 12:05:38.56801	it_block	B2O	Прочее
7002	455	1	2026-01-16 12:05:38.568632	recruiter	Белова И.Д.	Новикова Е.П.
7003	455	1	2026-01-16 12:05:38.569305	entry_date	2024-03-07	2024-07-08
7004	455	1	2026-01-16 12:05:38.569822	resume_link	https://drive.google.com/file/13479	https://drive.google.com/file/42060
7005	455	1	2026-01-16 12:05:38.570608	ck_department	Департамент цифровых продуктов	ЦК Инфраструктуры
7006	455	1	2026-01-16 12:05:38.571405	transfer_date		2026-12-08
7007	455	1	2026-01-16 12:05:38.572212	current_manager	Козлов Д.В.	Петров С.М.
7008	455	1	2026-01-16 12:05:38.572757	target_projects	Banking App, Mobile App	Data Platform, Mobile App
7009	455	1	2026-01-16 12:05:38.573338	candidate_status	В работе	Переведен
7010	455	1	2026-01-16 12:05:38.574018	funding_end_date	2025-06-14	2026-11-18
7011	456	1	2026-01-16 12:05:38.598134	hr_bp	Волкова Н.В.	Морозов К.А.
7012	456	1	2026-01-16 12:05:38.598624	comments	В процессе согласования	
7013	456	1	2026-01-16 12:05:38.599087	contacts	+7 (973) 685-30-74, @михдани33, d.mikhaylov@rt.ru	+7 (925) 442-29-59, @михдани62, d.mikhaylov@rt.ru
7014	456	1	2026-01-16 12:05:38.599523	it_block	Диджитал	Развитие
7015	456	1	2026-01-16 12:05:38.599962	recruiter	Смирнова А.А.	Белова И.Д.
7016	456	1	2026-01-16 12:05:38.600452	entry_date	2024-08-23	2025-09-28
7017	456	1	2026-01-16 12:05:38.60087	resume_link	https://drive.google.com/file/43432	https://drive.google.com/file/32114
7018	456	1	2026-01-16 12:05:38.601202	ck_department	ЦК Аналитики	Департамент цифровых продуктов
7019	456	1	2026-01-16 12:05:38.602074	transfer_date	2025-08-10	
7020	456	1	2026-01-16 12:05:38.602756	placement_type	перевод	любой
7021	456	1	2026-01-16 12:05:38.603386	target_projects	Госуслуги 2.0	ML Pipeline, DevOps Platform, Data Platform
7022	456	1	2026-01-16 12:05:38.604211	candidate_status	Увольнение по СС	В работе
7023	456	1	2026-01-16 12:05:38.605121	funding_end_date	2026-09-24	2025-01-13
7024	456	1	2026-01-16 12:05:38.605912	manager_feedback	Рекомендую	Хороший специалист
7025	457	1	2026-01-16 12:05:38.63578	hr_bp	Волкова Н.В.	Морозов К.А.
7026	457	1	2026-01-16 12:05:38.637093	contacts	+7 (996) 252-31-84, @кузтимо51, t.kuznetsov@rt.ru	+7 (997) 742-32-76, @кузтимо78, t.kuznetsov@rt.ru
7028	457	1	2026-01-16 12:05:38.638346	entry_date	2025-03-16	2025-04-24
7029	457	1	2026-01-16 12:05:38.639033	resume_link	https://drive.google.com/file/99754	https://drive.google.com/file/89753
7030	457	1	2026-01-16 12:05:38.639588	ck_department	ЦК Аналитики	ЦК Разработки
7031	457	1	2026-01-16 12:05:38.639962	transfer_date	2026-03-19	2026-02-05
7032	457	1	2026-01-16 12:05:38.640258	placement_type	любой	аутстафф
7033	457	1	2026-01-16 12:05:38.640539	current_manager	Петров С.М.	Козлов Д.В.
7034	457	1	2026-01-16 12:05:38.640812	target_projects	E-commerce Platform, ML Pipeline	Госуслуги 2.0, Banking App, Mobile App
7035	457	1	2026-01-16 12:05:38.641088	funding_end_date	2026-10-19	2025-06-23
7036	458	1	2026-01-16 12:05:38.657173	comments		Ожидает оффер
7037	458	1	2026-01-16 12:05:38.657906	contacts	+7 (956) 869-28-99, @якосаве45, s.yakovlev@rt.ru	+7 (935) 236-34-38, @якосаве70, s.yakovlev@rt.ru
7038	458	1	2026-01-16 12:05:38.658391	it_block	Эксплуатация	B2O
7039	458	1	2026-01-16 12:05:38.658885	recruiter	Новикова Е.П.	Орлов М.С.
7040	458	1	2026-01-16 12:05:38.6592	entry_date	2025-08-03	2024-10-25
7041	458	1	2026-01-16 12:05:38.659552	resume_link	https://drive.google.com/file/27103	https://drive.google.com/file/33401
7042	458	1	2026-01-16 12:05:38.659845	ck_department	Департамент цифровых продуктов	Департамент данных
7043	458	1	2026-01-16 12:05:38.660125	transfer_date		2026-08-10
7044	458	1	2026-01-16 12:05:38.660398	placement_type	любой	аутстафф
7045	458	1	2026-01-16 12:05:38.660667	target_projects	Mobile App, DevOps Platform, E-commerce Platform	Госуслуги 2.0, Data Platform, Banking App
7046	458	1	2026-01-16 12:05:38.66094	candidate_status	В работе	Увольнение по СЖ
7047	458	1	2026-01-16 12:05:38.66121	funding_end_date	2025-08-23	2025-07-17
7048	458	1	2026-01-16 12:05:38.661545	manager_feedback	Отличные результаты	
7049	460	1	2026-01-16 12:05:38.679114	hr_bp	Волкова Н.В.	Лебедева Т.М.
7050	460	1	2026-01-16 12:05:38.679541	comments	Срочно нужен проект	Ожидает оффер
7051	460	1	2026-01-16 12:05:38.67986	contacts	+7 (964) 523-27-77, @никмакс93, m.nikolaev@rt.ru	+7 (969) 327-75-38, @никмакс73, m.nikolaev@rt.ru
7052	460	1	2026-01-16 12:05:38.680148	it_block	Диджитал	НУК
7053	460	1	2026-01-16 12:05:38.680428	recruiter	Новикова Е.П.	Смирнова А.А.
7054	460	1	2026-01-16 12:05:38.680722	entry_date	2024-06-18	2024-12-23
7055	460	1	2026-01-16 12:05:38.681002	resume_link	https://drive.google.com/file/76281	https://drive.google.com/file/65709
7056	460	1	2026-01-16 12:05:38.681357	ck_department	Департамент цифровых продуктов	ЦК Разработки
7057	460	1	2026-01-16 12:05:38.681687	placement_type	аутстафф	любой
7058	460	1	2026-01-16 12:05:38.68197	current_manager	Иванов А.П.	Сидорова Е.К.
7059	460	1	2026-01-16 12:05:38.682636	target_projects	Infrastructure, DevOps Platform	Data Platform, Госуслуги 2.0, DevOps Platform
7060	460	1	2026-01-16 12:05:38.683128	candidate_status	В работе	Забронирован
7061	460	1	2026-01-16 12:05:38.683671	funding_end_date	2026-02-04	2025-04-19
7062	460	1	2026-01-16 12:05:38.684051	manager_feedback	Отличные результаты	Рекомендую
7063	460	1	2026-01-16 12:05:38.684503	ready_for_vacancy	Нет	Да
7064	462	1	2026-01-16 12:05:38.700262	hr_bp	Морозов К.А.	Лебедева Т.М.
7065	462	1	2026-01-16 12:05:38.700847	comments	Ожидает оффер	
7066	462	1	2026-01-16 12:05:38.701563	contacts	+7 (976) 605-14-75, @андолег44, o.andreev@rt.ru	+7 (996) 552-21-63, @андолег40, o.andreev@rt.ru
7067	462	1	2026-01-16 12:05:38.702114	it_block	Развитие	Прочее
7068	462	1	2026-01-16 12:05:38.702847	recruiter	Белова И.Д.	Орлов М.С.
7069	462	1	2026-01-16 12:05:38.703534	entry_date	2025-07-30	2024-02-22
7070	462	1	2026-01-16 12:05:38.704199	resume_link	https://drive.google.com/file/80666	https://drive.google.com/file/84662
7071	462	1	2026-01-16 12:05:38.704694	ck_department	ЦК Разработки	Департамент цифровых продуктов
7072	462	1	2026-01-16 12:05:38.705316	transfer_date		2026-02-01
7073	462	1	2026-01-16 12:05:38.705955	current_manager	Козлов Д.В.	Иванов А.П.
7074	462	1	2026-01-16 12:05:38.706645	target_projects	ML Pipeline	Infrastructure
7075	462	1	2026-01-16 12:05:38.707291	candidate_status	Свободен	Увольнение по СС
7076	462	1	2026-01-16 12:05:38.707772	funding_end_date	2025-04-26	2025-12-11
7077	462	1	2026-01-16 12:05:38.708263	ready_for_vacancy	Нет	Да
7078	463	1	2026-01-16 12:05:38.724857	hr_bp	Лебедева Т.М.	Волкова Н.В.
7079	463	1	2026-01-16 12:05:38.725643	contacts	+7 (951) 761-96-35, @макпаве96, p.makarov@rt.ru	+7 (974) 382-75-84, @макпаве90, p.makarov@rt.ru
7080	463	1	2026-01-16 12:05:38.726354	it_block	НУК	Развитие
7081	463	1	2026-01-16 12:05:38.72671	recruiter	Смирнова А.А.	Новикова Е.П.
7082	463	1	2026-01-16 12:05:38.727032	entry_date	2025-05-08	2025-06-14
7083	463	1	2026-01-16 12:05:38.727313	resume_link	https://drive.google.com/file/33876	https://drive.google.com/file/25475
7084	463	1	2026-01-16 12:05:38.727586	ck_department	ЦК Инфраструктуры	Департамент цифровых продуктов
7085	463	1	2026-01-16 12:05:38.72786	transfer_date	2025-11-28	2025-08-10
7086	463	1	2026-01-16 12:05:38.728359	placement_type	перевод	любой
7087	463	1	2026-01-16 12:05:38.728774	current_manager	Иванов А.П.	Петров С.М.
7088	463	1	2026-01-16 12:05:38.729072	target_projects	Banking App, ML Pipeline, Госуслуги 2.0	Banking App, Infrastructure
7089	463	1	2026-01-16 12:05:38.729466	funding_end_date	2025-03-16	2026-02-05
7090	463	1	2026-01-16 12:05:38.729979	manager_feedback	Отличные результаты	Нужно развитие
7091	463	1	2026-01-16 12:05:38.730344	ready_for_vacancy	Да	Нет
7092	465	1	2026-01-16 12:05:38.747792	hr_bp	Морозов К.А.	Волкова Н.В.
7093	465	1	2026-01-16 12:05:38.74853	comments		Ожидает оффер
7094	465	1	2026-01-16 12:05:38.74901	contacts	+7 (992) 571-88-61, @михлюдм44, l.mikhaylova@rt.ru	+7 (908) 538-12-65, @михлюдм80, l.mikhaylova@rt.ru
7095	465	1	2026-01-16 12:05:38.749623	it_block	Диджитал	Развитие
7096	465	1	2026-01-16 12:05:38.750025	recruiter	Белова И.Д.	Смирнова А.А.
7097	465	1	2026-01-16 12:05:38.750342	entry_date	2025-05-18	2025-04-10
7098	465	1	2026-01-16 12:05:38.750632	resume_link	https://drive.google.com/file/22516	https://drive.google.com/file/81746
7099	465	1	2026-01-16 12:05:38.750969	ck_department	Департамент данных	ЦК Аналитики
7100	465	1	2026-01-16 12:05:38.751655	transfer_date	2025-03-01	2026-07-18
7101	465	1	2026-01-16 12:05:38.752132	placement_type	перевод	любой
7102	465	1	2026-01-16 12:05:38.75266	current_manager	Сидорова Е.К.	Козлов Д.В.
7103	465	1	2026-01-16 12:05:38.753159	target_projects	E-commerce Platform, Mobile App, Infrastructure	E-commerce Platform, DevOps Platform
7104	465	1	2026-01-16 12:05:38.753604	candidate_status	Увольнение по СС	Переведен
7105	465	1	2026-01-16 12:05:38.753906	funding_end_date	2026-06-14	2026-10-27
7106	465	1	2026-01-16 12:05:38.754184	ready_for_vacancy	Да	Нет
7107	466	1	2026-01-16 12:05:38.770836	hr_bp	Волкова Н.В.	Морозов К.А.
7108	466	1	2026-01-16 12:05:38.771319	comments	Срочно нужен проект	Ожидает оффер
7109	466	1	2026-01-16 12:05:38.771842	contacts	+7 (932) 941-97-82, @фрокири6, k.frolov@rt.ru	+7 (913) 286-13-20, @фрокири83, k.frolov@rt.ru
7110	466	1	2026-01-16 12:05:38.772252	it_block	Диджитал	Эксплуатация
7111	466	1	2026-01-16 12:05:38.772581	entry_date	2024-03-26	2024-10-21
7112	466	1	2026-01-16 12:05:38.772871	resume_link	https://drive.google.com/file/10036	https://drive.google.com/file/57990
7113	466	1	2026-01-16 12:05:38.773155	ck_department	ЦК Аналитики	ЦК Разработки
7114	466	1	2026-01-16 12:05:38.773439	transfer_date		2026-10-12
7115	466	1	2026-01-16 12:05:38.773724	placement_type	любой	аутстафф
7116	466	1	2026-01-16 12:05:38.774022	current_manager	Иванов А.П.	Петров С.М.
7117	466	1	2026-01-16 12:05:38.774303	target_projects	ML Pipeline	Data Platform, DevOps Platform, ML Pipeline
7118	466	1	2026-01-16 12:05:38.774583	candidate_status	Свободен	Переведен
7119	466	1	2026-01-16 12:05:38.774874	funding_end_date	2025-01-03	2025-10-05
7120	466	1	2026-01-16 12:05:38.775386	manager_feedback	Хороший специалист	
7121	468	1	2026-01-16 12:05:38.792159	hr_bp	Морозов К.А.	Волкова Н.В.
7122	468	1	2026-01-16 12:05:38.792602	comments		Ожидает оффер
7123	468	1	2026-01-16 12:05:38.793051	contacts	+7 (994) 777-75-71, @никмари81, m.nikolaeva@rt.ru	+7 (901) 589-46-78, @никмари3, m.nikolaeva@rt.ru
7124	468	1	2026-01-16 12:05:38.793439	it_block	B2O	Развитие
7125	468	1	2026-01-16 12:05:38.793757	recruiter	Новикова Е.П.	Смирнова А.А.
7126	468	1	2026-01-16 12:05:38.794046	entry_date	2025-10-21	2024-02-25
7127	468	1	2026-01-16 12:05:38.794333	resume_link	https://drive.google.com/file/72597	https://drive.google.com/file/82604
7128	468	1	2026-01-16 12:05:38.794743	ck_department	ЦК Разработки	ЦК Инфраструктуры
7129	468	1	2026-01-16 12:05:38.79516	transfer_date		2026-05-31
7130	468	1	2026-01-16 12:05:38.795624	placement_type	любой	перевод
7131	468	1	2026-01-16 12:05:38.795928	current_manager	Козлов Д.В.	Петров С.М.
7132	468	1	2026-01-16 12:05:38.796225	target_projects	ML Pipeline	E-commerce Platform
7133	468	1	2026-01-16 12:05:38.796505	candidate_status	В работе	Увольнение по СС
7134	468	1	2026-01-16 12:05:38.796781	funding_end_date	2026-07-22	2026-08-08
7135	468	1	2026-01-16 12:05:38.797049	ready_for_vacancy	Нет	Да
7136	470	1	2026-01-16 12:05:38.815271	hr_bp	Лебедева Т.М.	Морозов К.А.
7137	470	1	2026-01-16 12:05:38.815991	comments	Срочно нужен проект	
7138	470	1	2026-01-16 12:05:38.816732	contacts	+7 (968) 210-61-60, @алебогд79, b.aleksandrov@rt.ru	+7 (935) 869-67-18, @алебогд95, b.aleksandrov@rt.ru
7139	470	1	2026-01-16 12:05:38.817538	it_block	B2O	Прочее
7140	470	1	2026-01-16 12:05:38.818042	recruiter	Белова И.Д.	Смирнова А.А.
7141	470	1	2026-01-16 12:05:38.818765	entry_date	2025-07-05	2025-06-02
7142	470	1	2026-01-16 12:05:38.819592	resume_link	https://drive.google.com/file/87807	https://drive.google.com/file/39107
7143	470	1	2026-01-16 12:05:38.820054	ck_department	ЦК Аналитики	Департамент данных
7144	470	1	2026-01-16 12:05:38.820363	transfer_date	2026-10-14	
7145	470	1	2026-01-16 12:05:38.820643	current_manager	Козлов Д.В.	Иванов А.П.
7146	470	1	2026-01-16 12:05:38.820944	target_projects	Data Platform, Mobile App	Infrastructure
7147	470	1	2026-01-16 12:05:38.821221	candidate_status	Увольнение по СС	Свободен
7148	470	1	2026-01-16 12:05:38.821923	funding_end_date	2025-06-01	2025-09-01
7149	470	1	2026-01-16 12:05:38.822483	ready_for_vacancy	Нет	Да
7150	471	1	2026-01-16 12:05:38.840397	comments		Срочно нужен проект
7151	471	1	2026-01-16 12:05:38.841034	contacts	+7 (901) 890-50-20, @ильмари1, m.ilina@rt.ru	+7 (959) 625-50-45, @ильмари85, m.ilina@rt.ru
7152	471	1	2026-01-16 12:05:38.841778	it_block	Эксплуатация	B2O
7153	471	1	2026-01-16 12:05:38.842309	recruiter	Белова И.Д.	Новикова Е.П.
7154	471	1	2026-01-16 12:05:38.842639	entry_date	2025-08-01	2024-12-20
7155	471	1	2026-01-16 12:05:38.842932	resume_link	https://drive.google.com/file/17611	https://drive.google.com/file/27437
7156	471	1	2026-01-16 12:05:38.843249	ck_department	Департамент данных	ЦК Разработки
7157	471	1	2026-01-16 12:05:38.843534	transfer_date	2025-08-12	
7158	471	1	2026-01-16 12:05:38.843813	current_manager	Сидорова Е.К.	Козлов Д.В.
7159	471	1	2026-01-16 12:05:38.844096	target_projects	DevOps Platform, Banking App, Mobile App	DevOps Platform
7160	471	1	2026-01-16 12:05:38.844375	candidate_status	Увольнение по СЖ	В работе
7161	471	1	2026-01-16 12:05:38.844648	funding_end_date	2026-10-12	2025-07-28
7162	471	1	2026-01-16 12:05:38.844993	manager_feedback	Рекомендую	Нужно развитие
7163	471	1	2026-01-16 12:05:38.845317	ready_for_vacancy	Нет	Да
7164	506	1	2026-01-16 12:05:38.861187	comments		Срочно нужен проект
7165	506	1	2026-01-16 12:05:38.861748	contacts	+7 (951) 647-90-86, @орлбогд52, b.orlov@rt.ru	+7 (963) 149-12-28, @орлбогд54, b.orlov@rt.ru
7166	506	1	2026-01-16 12:05:38.862429	it_block	Диджитал	Развитие
7167	506	1	2026-01-16 12:05:38.862918	entry_date	2025-04-07	2025-10-10
7168	506	1	2026-01-16 12:05:38.863383	resume_link	https://drive.google.com/file/40399	https://drive.google.com/file/37058
7169	506	1	2026-01-16 12:05:38.86381	ck_department	Департамент цифровых продуктов	ЦК Инфраструктуры
7170	506	1	2026-01-16 12:05:38.864235	transfer_date	2026-11-16	
7171	506	1	2026-01-16 12:05:38.864654	placement_type	любой	аутстафф
7172	506	1	2026-01-16 12:05:38.865068	current_manager	Петров С.М.	Михайлова О.Н.
7173	506	1	2026-01-16 12:05:38.865529	target_projects	Mobile App, ML Pipeline, Banking App	ML Pipeline, Infrastructure, Banking App
7174	506	1	2026-01-16 12:05:38.865979	candidate_status	Увольнение по СС	Свободен
7175	506	1	2026-01-16 12:05:38.866431	funding_end_date	2025-04-14	2026-06-06
7176	506	1	2026-01-16 12:05:38.866959	manager_feedback	Рекомендую	Хороший специалист
7177	506	1	2026-01-16 12:05:38.867414	ready_for_vacancy	Да	Нет
7178	507	1	2026-01-16 12:05:38.88733	hr_bp	Волкова Н.В.	Лебедева Т.М.
7179	507	1	2026-01-16 12:05:38.887805	comments		В процессе согласования
7180	507	1	2026-01-16 12:05:38.88815	contacts	+7 (902) 175-67-41, @новники44, n.novikov@rt.ru	+7 (921) 512-13-21, @новники15, n.novikov@rt.ru
7181	507	1	2026-01-16 12:05:38.888455	it_block	Прочее	Эксплуатация
7182	507	1	2026-01-16 12:05:38.888746	entry_date	2024-12-05	2024-04-21
7183	507	1	2026-01-16 12:05:38.889032	resume_link	https://drive.google.com/file/18933	https://drive.google.com/file/38762
7184	507	1	2026-01-16 12:05:38.88942	ck_department	ЦК Аналитики	Департамент данных
7185	507	1	2026-01-16 12:05:38.889788	current_manager	Иванов А.П.	Петров С.М.
7186	507	1	2026-01-16 12:05:38.89008	target_projects	Mobile App, E-commerce Platform, DevOps Platform	DevOps Platform
7187	507	1	2026-01-16 12:05:38.890355	candidate_status	Свободен	В работе
7188	507	1	2026-01-16 12:05:38.890658	funding_end_date	2025-09-02	2026-11-10
7189	507	1	2026-01-16 12:05:38.890969	manager_feedback	Нужно развитие	Отличные результаты
7190	508	1	2026-01-16 12:05:38.908234	hr_bp	Морозов К.А.	Лебедева Т.М.
7191	508	1	2026-01-16 12:05:38.908657	comments	Срочно нужен проект	В процессе согласования
7192	508	1	2026-01-16 12:05:38.908972	contacts	+7 (904) 472-56-57, @семвале18, v.semenova@rt.ru	+7 (903) 689-72-25, @семвале38, v.semenova@rt.ru
7193	508	1	2026-01-16 12:05:38.909283	it_block	Прочее	Диджитал
7194	508	1	2026-01-16 12:05:38.909718	recruiter	Белова И.Д.	Орлов М.С.
7195	508	1	2026-01-16 12:05:38.91001	entry_date	2024-10-26	2025-06-30
7196	508	1	2026-01-16 12:05:38.910289	resume_link	https://drive.google.com/file/77311	https://drive.google.com/file/42799
7197	508	1	2026-01-16 12:05:38.910561	ck_department	ЦК Аналитики	Департамент цифровых продуктов
7198	508	1	2026-01-16 12:05:38.910829	placement_type	перевод	аутстафф
7199	508	1	2026-01-16 12:05:38.911097	current_manager	Петров С.М.	Иванов А.П.
7200	508	1	2026-01-16 12:05:38.911371	target_projects	E-commerce Platform, Infrastructure, Data Platform	Госуслуги 2.0, E-commerce Platform
7201	508	1	2026-01-16 12:05:38.911641	funding_end_date	2026-11-08	2025-03-24
7202	508	1	2026-01-16 12:05:38.91191	manager_feedback	Рекомендую	Отличные результаты
7203	508	1	2026-01-16 12:05:38.912176	ready_for_vacancy	Да	Нет
7204	510	1	2026-01-16 12:05:38.931494	comments		Срочно нужен проект
7205	510	1	2026-01-16 12:05:38.931948	contacts	+7 (922) 981-84-32, @никнико96, n.nikolaev@rt.ru	+7 (986) 645-42-92, @никнико47, n.nikolaev@rt.ru
7206	510	1	2026-01-16 12:05:38.932306	it_block	B2O	Эксплуатация
7207	510	1	2026-01-16 12:05:38.932607	entry_date	2025-01-30	2024-07-17
7208	510	1	2026-01-16 12:05:38.933018	resume_link	https://drive.google.com/file/79243	https://drive.google.com/file/20385
7209	510	1	2026-01-16 12:05:38.933823	ck_department	Департамент данных	ЦК Аналитики
7210	510	1	2026-01-16 12:05:38.934537	transfer_date	2026-07-10	
7211	510	1	2026-01-16 12:05:38.935457	placement_type	аутстафф	любой
7212	510	1	2026-01-16 12:05:38.936269	current_manager	Иванов А.П.	Петров С.М.
7213	510	1	2026-01-16 12:05:38.936775	target_projects	ML Pipeline, Infrastructure	Mobile App, Data Platform
7214	510	1	2026-01-16 12:05:38.937434	candidate_status	Переведен	Свободен
7215	510	1	2026-01-16 12:05:38.937911	funding_end_date	2026-05-12	2025-10-11
7216	512	1	2026-01-16 12:05:38.956568	comments	В процессе согласования	
7217	512	1	2026-01-16 12:05:38.957442	contacts	+7 (907) 681-17-49, @никпаве63, p.nikolaev@rt.ru	+7 (985) 136-91-66, @никпаве77, p.nikolaev@rt.ru
7218	512	1	2026-01-16 12:05:38.957989	it_block	НУК	B2O
7219	512	1	2026-01-16 12:05:38.958475	recruiter	Орлов М.С.	Белова И.Д.
7220	512	1	2026-01-16 12:05:38.959141	entry_date	2024-12-31	2024-10-15
7221	512	1	2026-01-16 12:05:38.959663	resume_link	https://drive.google.com/file/76518	https://drive.google.com/file/57158
7222	512	1	2026-01-16 12:05:38.96013	ck_department	ЦК Разработки	ЦК Инфраструктуры
7223	512	1	2026-01-16 12:05:38.960577	transfer_date		2025-08-08
7224	512	1	2026-01-16 12:05:38.961018	placement_type	аутстафф	перевод
7225	512	1	2026-01-16 12:05:38.961557	target_projects	E-commerce Platform, ML Pipeline	Data Platform, Госуслуги 2.0
7226	512	1	2026-01-16 12:05:38.962215	candidate_status	Свободен	Увольнение по СС
7227	512	1	2026-01-16 12:05:38.962741	funding_end_date	2025-07-15	2025-09-03
7228	512	1	2026-01-16 12:05:38.96325	manager_feedback	Отличные результаты	
7229	513	1	2026-01-16 12:05:38.986155	comments	В процессе согласования	Ожидает оффер
7230	513	1	2026-01-16 12:05:38.986636	contacts	+7 (992) 922-73-88, @морольг90, o.morozova@rt.ru	+7 (987) 391-35-15, @морольг32, o.morozova@rt.ru
7231	513	1	2026-01-16 12:05:38.986965	it_block	B2O	Диджитал
7232	513	1	2026-01-16 12:05:38.987249	recruiter	Белова И.Д.	Смирнова А.А.
7233	513	1	2026-01-16 12:05:38.987527	entry_date	2024-06-09	2024-10-27
7234	513	1	2026-01-16 12:05:38.9878	resume_link	https://drive.google.com/file/40402	https://drive.google.com/file/95255
7235	513	1	2026-01-16 12:05:38.988075	ck_department	Департамент цифровых продуктов	ЦК Разработки
7236	513	1	2026-01-16 12:05:38.988345	transfer_date	2026-01-27	
7237	513	1	2026-01-16 12:05:38.988615	placement_type	перевод	аутстафф
7238	513	1	2026-01-16 12:05:38.988892	current_manager	Михайлова О.Н.	Сидорова Е.К.
7239	513	1	2026-01-16 12:05:38.98916	target_projects	ML Pipeline	Mobile App, E-commerce Platform, Banking App
7240	513	1	2026-01-16 12:05:38.989525	candidate_status	Увольнение по СС	Забронирован
7241	513	1	2026-01-16 12:05:38.990386	funding_end_date	2026-07-29	2026-06-19
7242	513	1	2026-01-16 12:05:38.990782	manager_feedback	Рекомендую	Нужно развитие
7243	513	1	2026-01-16 12:05:38.991092	ready_for_vacancy	Да	Нет
7244	514	1	2026-01-16 12:05:39.010177	contacts	+7 (924) 667-34-20, @васлюбо61, l.vasileva@rt.ru	+7 (947) 551-31-14, @васлюбо20, l.vasileva@rt.ru
7245	514	1	2026-01-16 12:05:39.010811	it_block	Прочее	B2O
7246	514	1	2026-01-16 12:05:39.011453	recruiter	Белова И.Д.	Смирнова А.А.
7247	514	1	2026-01-16 12:05:39.011976	entry_date	2024-12-07	2025-01-01
7248	514	1	2026-01-16 12:05:39.012561	resume_link	https://drive.google.com/file/72576	https://drive.google.com/file/18256
7249	514	1	2026-01-16 12:05:39.013154	ck_department	ЦК Разработки	Департамент цифровых продуктов
7250	514	1	2026-01-16 12:05:39.013698	transfer_date	2025-04-14	
7251	514	1	2026-01-16 12:05:39.014069	current_manager	Михайлова О.Н.	Сидорова Е.К.
7252	514	1	2026-01-16 12:05:39.014367	target_projects	Data Platform, E-commerce Platform, Mobile App	ML Pipeline, Infrastructure, DevOps Platform
7253	514	1	2026-01-16 12:05:39.014643	candidate_status	Увольнение по СС	Забронирован
7254	514	1	2026-01-16 12:05:39.014913	funding_end_date	2026-01-22	2025-05-31
7255	514	1	2026-01-16 12:05:39.015242	manager_feedback	Рекомендую	Хороший специалист
7256	516	1	2026-01-16 12:05:39.031413	comments	Срочно нужен проект	
7257	516	1	2026-01-16 12:05:39.031975	contacts	+7 (968) 351-11-63, @сокюрий35, yu.sokolov@rt.ru	+7 (990) 810-31-75, @сокюрий98, yu.sokolov@rt.ru
7258	516	1	2026-01-16 12:05:39.032327	it_block	НУК	B2O
7259	516	1	2026-01-16 12:05:39.03276	recruiter	Белова И.Д.	Смирнова А.А.
7260	516	1	2026-01-16 12:05:39.03307	entry_date	2024-06-13	2025-01-07
7261	516	1	2026-01-16 12:05:39.033436	resume_link	https://drive.google.com/file/35993	https://drive.google.com/file/91445
7262	516	1	2026-01-16 12:05:39.033826	ck_department	ЦК Разработки	Департамент данных
7263	516	1	2026-01-16 12:05:39.03412	transfer_date		2026-03-08
7264	516	1	2026-01-16 12:05:39.034395	current_manager	Козлов Д.В.	Петров С.М.
7265	516	1	2026-01-16 12:05:39.034853	target_projects	DevOps Platform, Госуслуги 2.0	Data Platform, DevOps Platform, Госуслуги 2.0
7266	516	1	2026-01-16 12:05:39.035666	candidate_status	В работе	Увольнение по СС
7267	516	1	2026-01-16 12:05:39.036414	funding_end_date	2026-04-22	2026-10-30
7268	516	1	2026-01-16 12:05:39.036765	manager_feedback	Рекомендую	Нужно развитие
7269	516	1	2026-01-16 12:05:39.037059	ready_for_vacancy	Да	Нет
7270	517	1	2026-01-16 12:05:39.054114	comments		Ожидает оффер
7271	517	1	2026-01-16 12:05:39.054558	contacts	+7 (988) 823-43-59, @солматв51, m.solovev@rt.ru	+7 (908) 280-55-38, @солматв58, m.solovev@rt.ru
7272	517	1	2026-01-16 12:05:39.055253	it_block	НУК	Эксплуатация
7273	517	1	2026-01-16 12:05:39.055705	recruiter	Новикова Е.П.	Смирнова А.А.
7274	517	1	2026-01-16 12:05:39.056005	entry_date	2025-05-25	2025-01-21
7275	517	1	2026-01-16 12:05:39.056277	resume_link	https://drive.google.com/file/75245	https://drive.google.com/file/95637
7276	517	1	2026-01-16 12:05:39.056601	ck_department	Департамент цифровых продуктов	Департамент данных
7277	517	1	2026-01-16 12:05:39.057126	transfer_date		2026-03-26
7278	517	1	2026-01-16 12:05:39.057584	placement_type	перевод	аутстафф
7279	517	1	2026-01-16 12:05:39.057897	current_manager	Михайлова О.Н.	Козлов Д.В.
7280	517	1	2026-01-16 12:05:39.058173	target_projects	Infrastructure	ML Pipeline, Banking App, Mobile App
7281	517	1	2026-01-16 12:05:39.058445	candidate_status	Забронирован	Увольнение по СС
7282	517	1	2026-01-16 12:05:39.058736	funding_end_date	2025-01-04	2026-06-27
7283	20	1	2026-01-16 12:05:39.077008	hr_bp	Волкова Н.В.	Лебедева Т.М.
7284	20	1	2026-01-16 12:05:39.077845	contacts	+7 (936) 561-24-94, @яконики43, nikita.yakovlev4@company.ru	+7 (937) 884-64-77, @яконики17, nikita.yakovlev4@company.ru
7285	20	1	2026-01-16 12:05:39.078386	recruiter	Орлов М.С.	Смирнова А.А.
7286	20	1	2026-01-16 12:05:39.079028	entry_date	2024-12-27	2024-02-29
7287	20	1	2026-01-16 12:05:39.07973	resume_link	https://drive.google.com/file/14339	https://drive.google.com/file/21696
7288	20	1	2026-01-16 12:05:39.08033	ck_department	Департамент цифровых продуктов	ЦК Разработки
7289	20	1	2026-01-16 12:05:39.080776	placement_type	аутстафф	перевод
7290	20	1	2026-01-16 12:05:39.081207	target_projects	Госуслуги 2.0, E-commerce Platform, Banking App	Infrastructure, ML Pipeline, Mobile App
7291	20	1	2026-01-16 12:05:39.081988	candidate_status	В работе	Свободен
7292	20	1	2026-01-16 12:05:39.082699	funding_end_date	2025-03-15	2026-03-18
7293	8	1	2026-01-16 12:05:39.101552	hr_bp	Лебедева Т.М.	Волкова Н.В.
7294	8	1	2026-01-16 12:05:39.102134	contacts	+7 (972) 399-59-72, @сиддмит81, sidorov@company.ru	+7 (973) 187-98-21, @сиддмит80, sidorov@company.ru
7295	8	1	2026-01-16 12:05:39.102797	it_block	Диджитал	B2O
7296	8	1	2026-01-16 12:05:39.103303	entry_date	2025-02-26	2025-03-07
7297	8	1	2026-01-16 12:05:39.103717	resume_link	https://drive.google.com/file/98658	https://drive.google.com/file/77521
7298	8	1	2026-01-16 12:05:39.104349	ck_department	Департамент цифровых продуктов	ЦК Разработки
7299	8	1	2026-01-16 12:05:39.104942	transfer_date		2025-10-31
7300	8	1	2026-01-16 12:05:39.105561	placement_type	аутстафф	любой
7301	8	1	2026-01-16 12:05:39.106174	current_manager	Иванов А.П.	Петров С.М.
7302	8	1	2026-01-16 12:05:39.10666	target_projects	Госуслуги 2.0	Banking App, E-commerce Platform
7303	8	1	2026-01-16 12:05:39.107156	candidate_status	В работе	Переведен
7304	8	1	2026-01-16 12:05:39.107605	funding_end_date	2025-02-23	2025-06-22
7305	8	1	2026-01-16 12:05:39.108243	manager_feedback		Отличные результаты
7306	218	1	2026-01-16 12:05:39.128634	hr_bp	Морозов К.А.	Лебедева Т.М.
7307	218	1	2026-01-16 12:05:39.129188	contacts	+7 (968) 417-95-35, @тестест34, testov@test.ru	+7 (987) 445-63-61, @тестест71, testov@test.ru
7308	218	1	2026-01-16 12:05:39.129913	it_block	B2O	Развитие
7309	218	1	2026-01-16 12:05:39.130384	recruiter	Новикова Е.П.	Орлов М.С.
7310	218	1	2026-01-16 12:05:39.130845	entry_date	2025-06-11	2025-07-24
7311	218	1	2026-01-16 12:05:39.13126	resume_link	https://drive.google.com/file/18744	https://drive.google.com/file/18806
7312	218	1	2026-01-16 12:05:39.131825	ck_department	ЦК Инфраструктуры	ЦК Аналитики
7313	218	1	2026-01-16 12:05:39.132271	placement_type	перевод	любой
7314	218	1	2026-01-16 12:05:39.132697	current_manager	Сидорова Е.К.	Козлов Д.В.
7315	218	1	2026-01-16 12:05:39.13313	funding_end_date	2026-04-28	2026-09-06
7316	218	1	2026-01-16 12:05:39.133776	manager_feedback	Нужно развитие	Хороший специалист
7317	218	1	2026-01-16 12:05:39.134426	ready_for_vacancy	Нет	Да
7318	221	1	2026-01-16 12:05:39.193299	comments		В процессе согласования
7319	221	1	2026-01-16 12:05:39.194134	contacts	+7 (971) 222-85-14, @гусксен25, k.guseva@rt.ru	+7 (954) 499-23-21, @гусксен79, k.guseva@rt.ru
7320	221	1	2026-01-16 12:05:39.195044	it_block	НУК	Прочее
7321	221	1	2026-01-16 12:05:39.195983	entry_date	2024-12-05	2024-06-22
7322	221	1	2026-01-16 12:05:39.196756	resume_link	https://drive.google.com/file/80668	https://drive.google.com/file/57611
7323	221	1	2026-01-16 12:05:39.197504	transfer_date		2026-03-24
7324	221	1	2026-01-16 12:05:39.198153	current_manager	Козлов Д.В.	Иванов А.П.
7325	221	1	2026-01-16 12:05:39.199061	target_projects	DevOps Platform	Infrastructure
7326	221	1	2026-01-16 12:05:39.200248	candidate_status	Свободен	Увольнение по СС
7327	221	1	2026-01-16 12:05:39.201104	funding_end_date	2026-02-14	2025-05-27
7328	221	1	2026-01-16 12:05:39.20177	manager_feedback		Хороший специалист
7329	22	1	2026-01-16 12:05:39.233083	hr_bp	Морозов К.А.	Лебедева Т.М.
7330	22	1	2026-01-16 12:05:39.233781	contacts	+7 (973) 205-38-28, @михандр60, maxim.grigoriev6@company.ru	+7 (966) 289-47-10, @михандр53, maxim.grigoriev6@company.ru
7331	22	1	2026-01-16 12:05:39.234482	recruiter	Орлов М.С.	Белова И.Д.
7332	22	1	2026-01-16 12:05:39.23509	entry_date	2025-01-09	2024-03-02
7333	22	1	2026-01-16 12:05:39.235642	resume_link	https://drive.google.com/file/89724	https://drive.google.com/file/75180
7334	22	1	2026-01-16 12:05:39.236402	placement_type	перевод	аутстафф
7335	22	1	2026-01-16 12:05:39.236983	current_manager	Сидорова Е.К.	Михайлова О.Н.
7336	22	1	2026-01-16 12:05:39.237572	target_projects	Banking App	DevOps Platform, ML Pipeline
7337	22	1	2026-01-16 12:05:39.238248	funding_end_date	2026-08-06	2025-05-15
7338	22	1	2026-01-16 12:05:39.238671	manager_feedback	Рекомендую	Нужно развитие
7339	22	1	2026-01-16 12:05:39.239245	ready_for_vacancy	Да	Нет
7340	239	1	2026-01-16 12:05:39.26975	comments		Ожидает оффер
7341	239	1	2026-01-16 12:05:39.270424	contacts	+7 (967) 551-30-59, @ковмари36, m.kovaleva@rt.ru	+7 (977) 320-37-55, @ковмари61, m.kovaleva@rt.ru
7342	239	1	2026-01-16 12:05:39.270943	it_block	B2O	Прочее
7343	239	1	2026-01-16 12:05:39.271522	recruiter	Смирнова А.А.	Орлов М.С.
7344	239	1	2026-01-16 12:05:39.272163	entry_date	2025-06-11	2024-07-24
7345	239	1	2026-01-16 12:05:39.272548	resume_link	https://drive.google.com/file/68276	https://drive.google.com/file/98307
7346	239	1	2026-01-16 12:05:39.273009	ck_department	ЦК Разработки	ЦК Инфраструктуры
7347	239	1	2026-01-16 12:05:39.273477	transfer_date	2025-06-26	
7348	239	1	2026-01-16 12:05:39.274278	current_manager	Петров С.М.	Сидорова Е.К.
7349	239	1	2026-01-16 12:05:39.274693	target_projects	E-commerce Platform, Госуслуги 2.0, Mobile App	E-commerce Platform
7350	239	1	2026-01-16 12:05:39.27506	candidate_status	Увольнение по СЖ	В работе
7351	239	1	2026-01-16 12:05:39.275414	funding_end_date	2025-11-19	2026-01-15
7352	239	1	2026-01-16 12:05:39.275838	manager_feedback	Нужно развитие	
7353	239	1	2026-01-16 12:05:39.276206	ready_for_vacancy	Да	Нет
7354	261	1	2026-01-16 12:05:39.302453	comments	Срочно нужен проект	Ожидает оффер
7355	261	1	2026-01-16 12:05:39.302928	contacts	+7 (906) 399-32-78, @семдени90, d.semenov@rt.ru	+7 (917) 238-26-28, @семдени37, d.semenov@rt.ru
7356	261	1	2026-01-16 12:05:39.303466	it_block	B2O	Эксплуатация
7357	261	1	2026-01-16 12:05:39.304109	recruiter	Новикова Е.П.	Смирнова А.А.
7358	261	1	2026-01-16 12:05:39.30538	entry_date	2024-03-31	2024-07-24
7359	261	1	2026-01-16 12:05:39.30596	resume_link	https://drive.google.com/file/81663	https://drive.google.com/file/19602
7360	261	1	2026-01-16 12:05:39.306546	transfer_date	2025-01-03	
7361	261	1	2026-01-16 12:05:39.30722	current_manager	Сидорова Е.К.	Иванов А.П.
7362	261	1	2026-01-16 12:05:39.307798	target_projects	Infrastructure	Banking App, Infrastructure, E-commerce Platform
7363	261	1	2026-01-16 12:05:39.308464	candidate_status	Увольнение по СС	Забронирован
7364	261	1	2026-01-16 12:05:39.308988	funding_end_date	2025-09-27	2025-06-29
7365	261	1	2026-01-16 12:05:39.309922	manager_feedback	Нужно развитие	
7366	261	1	2026-01-16 12:05:39.310768	ready_for_vacancy	Да	Нет
7367	84	1	2026-01-16 12:05:39.334692	hr_bp	Волкова Н.В.	Морозов К.А.
7368	84	1	2026-01-16 12:05:39.335205	comments		Ожидает оффер
7369	84	1	2026-01-16 12:05:39.335673	contacts	+7 (986) 333-57-32, @фёдсерг86, tatiana.vorobyov68@company.ru	+7 (914) 146-46-34, @фёдсерг92, tatiana.vorobyov68@company.ru
7370	84	1	2026-01-16 12:05:39.336258	it_block	Развитие	Диджитал
7371	84	1	2026-01-16 12:05:39.336861	recruiter	Белова И.Д.	Смирнова А.А.
7372	84	1	2026-01-16 12:05:39.337643	entry_date	2025-03-14	2025-04-26
7373	84	1	2026-01-16 12:05:39.338075	resume_link	https://drive.google.com/file/79871	https://drive.google.com/file/84128
7374	84	1	2026-01-16 12:05:39.338608	ck_department	ЦК Инфраструктуры	ЦК Разработки
7375	84	1	2026-01-16 12:05:39.339093	transfer_date	2026-10-10	
7376	84	1	2026-01-16 12:05:39.340167	placement_type	аутстафф	любой
7377	84	1	2026-01-16 12:05:39.340471	current_manager	Сидорова Е.К.	Петров С.М.
7378	84	1	2026-01-16 12:05:39.340746	target_projects	DevOps Platform	Infrastructure, DevOps Platform, Госуслуги 2.0
7379	84	1	2026-01-16 12:05:39.34118	candidate_status	Переведен	В работе
7380	84	1	2026-01-16 12:05:39.341759	funding_end_date	2026-02-03	2026-10-29
7381	84	1	2026-01-16 12:05:39.342336	manager_feedback	Нужно развитие	Отличные результаты
7382	84	1	2026-01-16 12:05:39.342729	ready_for_vacancy	Да	Нет
7383	276	1	2026-01-16 12:05:39.360193	hr_bp	Лебедева Т.М.	Морозов К.А.
7384	276	1	2026-01-16 12:05:39.360875	contacts	+7 (915) 457-20-81, @никната22, n.nikolaeva@rt.ru	+7 (994) 230-60-24, @никната60, n.nikolaeva@rt.ru
7385	276	1	2026-01-16 12:05:39.361435	it_block	B2O	Эксплуатация
7386	276	1	2026-01-16 12:05:39.361896	recruiter	Орлов М.С.	Новикова Е.П.
7387	276	1	2026-01-16 12:05:39.362493	entry_date	2025-01-12	2024-06-05
7388	276	1	2026-01-16 12:05:39.363012	resume_link	https://drive.google.com/file/12182	https://drive.google.com/file/43842
7389	276	1	2026-01-16 12:05:39.363358	ck_department	Департамент данных	ЦК Инфраструктуры
7390	276	1	2026-01-16 12:05:39.363843	transfer_date	2026-06-27	2026-02-25
7391	276	1	2026-01-16 12:05:39.364153	placement_type	аутстафф	любой
7392	276	1	2026-01-16 12:05:39.364564	current_manager	Сидорова Е.К.	Иванов А.П.
7393	276	1	2026-01-16 12:05:39.365068	target_projects	Data Platform, ML Pipeline, E-commerce Platform	Infrastructure, ML Pipeline, Госуслуги 2.0
7394	276	1	2026-01-16 12:05:39.365621	candidate_status	Увольнение по СС	Увольнение по СЖ
7395	276	1	2026-01-16 12:05:39.365967	funding_end_date	2025-09-21	2026-06-10
7396	276	1	2026-01-16 12:05:39.366507	manager_feedback	Рекомендую	
7397	276	1	2026-01-16 12:05:39.366956	ready_for_vacancy	Да	Нет
7398	279	1	2026-01-16 12:05:39.383728	comments		Ожидает оффер
7399	279	1	2026-01-16 12:05:39.384368	contacts	+7 (957) 705-30-66, @иваалин98, a.ivanova@rt.ru	+7 (976) 405-30-14, @иваалин20, a.ivanova@rt.ru
7400	279	1	2026-01-16 12:05:39.38501	it_block	Развитие	Прочее
7401	279	1	2026-01-16 12:05:39.385522	recruiter	Новикова Е.П.	Белова И.Д.
7402	279	1	2026-01-16 12:05:39.386112	entry_date	2024-02-28	2024-02-15
7403	279	1	2026-01-16 12:05:39.386936	resume_link	https://drive.google.com/file/51307	https://drive.google.com/file/24605
7404	279	1	2026-01-16 12:05:39.387467	ck_department	ЦК Инфраструктуры	ЦК Аналитики
7405	279	1	2026-01-16 12:05:39.388006	transfer_date	2025-11-03	
7406	279	1	2026-01-16 12:05:39.388909	current_manager	Михайлова О.Н.	Петров С.М.
7407	279	1	2026-01-16 12:05:39.389297	target_projects	E-commerce Platform, DevOps Platform	Госуслуги 2.0, Banking App, Infrastructure
7408	279	1	2026-01-16 12:05:39.389735	candidate_status	Увольнение по СС	В работе
7409	279	1	2026-01-16 12:05:39.390238	funding_end_date	2025-10-01	2025-06-15
7410	279	1	2026-01-16 12:05:39.390858	manager_feedback	Хороший специалист	Отличные результаты
7411	286	1	2026-01-16 12:05:39.410535	hr_bp	Лебедева Т.М.	Морозов К.А.
7412	286	1	2026-01-16 12:05:39.41169	contacts	+7 (958) 194-48-15, @попсвет72, s.popova@rt.ru	+7 (935) 205-94-39, @попсвет57, s.popova@rt.ru
7413	286	1	2026-01-16 12:05:39.412386	it_block	Развитие	Эксплуатация
7414	286	1	2026-01-16 12:05:39.412876	recruiter	Белова И.Д.	Новикова Е.П.
7415	286	1	2026-01-16 12:05:39.413352	entry_date	2025-05-02	2025-07-19
7416	286	1	2026-01-16 12:05:39.414002	resume_link	https://drive.google.com/file/21312	https://drive.google.com/file/54087
7417	286	1	2026-01-16 12:05:39.414482	ck_department	Департамент цифровых продуктов	Департамент данных
7418	286	1	2026-01-16 12:05:39.414935	transfer_date	2025-03-07	
7419	286	1	2026-01-16 12:05:39.415612	placement_type	любой	аутстафф
7420	286	1	2026-01-16 12:05:39.416102	current_manager	Сидорова Е.К.	Петров С.М.
7421	286	1	2026-01-16 12:05:39.417085	target_projects	Infrastructure, ML Pipeline	Mobile App, Infrastructure, ML Pipeline
7422	286	1	2026-01-16 12:05:39.417971	candidate_status	Увольнение по СЖ	Свободен
7423	286	1	2026-01-16 12:05:39.418528	funding_end_date	2026-04-06	2025-10-29
7424	286	1	2026-01-16 12:05:39.41901	manager_feedback		Нужно развитие
7425	286	1	2026-01-16 12:05:39.419413	ready_for_vacancy	Да	Нет
7426	126	1	2026-01-16 12:05:39.438955	contacts	+7 (965) 716-38-17, @сокегор47, petr.frolov110@company.ru	+7 (939) 848-80-84, @сокегор71, petr.frolov110@company.ru
7427	126	1	2026-01-16 12:05:39.439582	it_block	Прочее	B2O
7428	126	1	2026-01-16 12:05:39.440131	recruiter	Белова И.Д.	Новикова Е.П.
7429	126	1	2026-01-16 12:05:39.440463	entry_date	2025-10-28	2025-07-28
7430	126	1	2026-01-16 12:05:39.440759	resume_link	https://drive.google.com/file/31080	https://drive.google.com/file/19804
7431	126	1	2026-01-16 12:05:39.441044	ck_department	ЦК Инфраструктуры	ЦК Аналитики
7432	126	1	2026-01-16 12:05:39.441361	transfer_date	2025-08-03	
7433	126	1	2026-01-16 12:05:39.441744	placement_type	аутстафф	перевод
7434	126	1	2026-01-16 12:05:39.442041	current_manager	Михайлова О.Н.	Сидорова Е.К.
7435	126	1	2026-01-16 12:05:39.442377	target_projects	Infrastructure, Mobile App	DevOps Platform
7436	126	1	2026-01-16 12:05:39.442788	candidate_status	Увольнение по СС	Забронирован
7437	126	1	2026-01-16 12:05:39.443427	funding_end_date	2026-05-02	2026-03-28
7438	126	1	2026-01-16 12:05:39.443944	ready_for_vacancy	Нет	Да
7439	319	1	2026-01-16 12:05:39.461706	comments		Срочно нужен проект
7440	319	1	2026-01-16 12:05:39.462287	contacts	+7 (952) 381-27-67, @андкири68, k.andreev@rt.ru	+7 (905) 499-28-11, @андкири31, k.andreev@rt.ru
7441	319	1	2026-01-16 12:05:39.462655	recruiter	Белова И.Д.	Смирнова А.А.
7442	319	1	2026-01-16 12:05:39.462986	entry_date	2024-03-09	2024-08-09
7443	319	1	2026-01-16 12:05:39.463306	resume_link	https://drive.google.com/file/48546	https://drive.google.com/file/91290
7444	319	1	2026-01-16 12:05:39.463887	ck_department	ЦК Инфраструктуры	ЦК Разработки
7445	319	1	2026-01-16 12:05:39.464359	placement_type	любой	перевод
7446	319	1	2026-01-16 12:05:39.464664	current_manager	Сидорова Е.К.	Петров С.М.
7447	319	1	2026-01-16 12:05:39.464983	target_projects	Infrastructure	Data Platform, Госуслуги 2.0
7448	319	1	2026-01-16 12:05:39.465371	candidate_status	Забронирован	Свободен
7449	319	1	2026-01-16 12:05:39.465739	funding_end_date	2026-12-18	2026-08-06
7450	319	1	2026-01-16 12:05:39.466029	manager_feedback	Хороший специалист	
7451	129	1	2026-01-16 12:05:39.484393	comments	Ожидает оффер	
7452	129	1	2026-01-16 12:05:39.485158	contacts	+7 (951) 221-23-54, @фёдсерг9, anna.alexeev113@company.ru	+7 (977) 727-97-35, @фёдсерг69, anna.alexeev113@company.ru
7453	129	1	2026-01-16 12:05:39.485683	it_block	Диджитал	Эксплуатация
7454	129	1	2026-01-16 12:05:39.48633	recruiter	Белова И.Д.	Орлов М.С.
7455	129	1	2026-01-16 12:05:39.486937	entry_date	2025-05-22	2024-11-04
7456	129	1	2026-01-16 12:05:39.487667	resume_link	https://drive.google.com/file/47708	https://drive.google.com/file/78675
7457	129	1	2026-01-16 12:05:39.488354	ck_department	Департамент цифровых продуктов	ЦК Аналитики
7458	129	1	2026-01-16 12:05:39.489002	placement_type	аутстафф	перевод
7459	129	1	2026-01-16 12:05:39.489679	current_manager	Михайлова О.Н.	Петров С.М.
7460	129	1	2026-01-16 12:05:39.490178	target_projects	Banking App, E-commerce Platform, Госуслуги 2.0	Госуслуги 2.0, Mobile App, DevOps Platform
7461	129	1	2026-01-16 12:05:39.490833	candidate_status	Забронирован	Свободен
7462	129	1	2026-01-16 12:05:39.491286	funding_end_date	2025-06-15	2026-03-20
7463	129	1	2026-01-16 12:05:39.491787	manager_feedback	Хороший специалист	Отличные результаты
7464	99	1	2026-01-16 12:05:39.519836	comments		В процессе согласования
7465	99	1	2026-01-16 12:05:39.52064	contacts	+7 (980) 919-96-48, @фёдсерг74, anton.nikitin83@company.ru	+7 (998) 470-73-32, @фёдсерг48, anton.nikitin83@company.ru
7466	99	1	2026-01-16 12:05:39.521074	it_block	Эксплуатация	B2O
7467	99	1	2026-01-16 12:05:39.521564	recruiter	Смирнова А.А.	Белова И.Д.
7468	99	1	2026-01-16 12:05:39.521969	entry_date	2025-12-07	2025-07-03
7469	99	1	2026-01-16 12:05:39.522493	resume_link	https://drive.google.com/file/49489	https://drive.google.com/file/36801
7470	99	1	2026-01-16 12:05:39.523024	transfer_date		2025-03-16
7471	99	1	2026-01-16 12:05:39.523425	placement_type	аутстафф	любой
7472	99	1	2026-01-16 12:05:39.523725	current_manager	Козлов Д.В.	Петров С.М.
7473	99	1	2026-01-16 12:05:39.52406	target_projects	Infrastructure, Banking App, DevOps Platform	Госуслуги 2.0, Infrastructure, DevOps Platform
7474	99	1	2026-01-16 12:05:39.524498	candidate_status	В работе	Увольнение по СЖ
7475	99	1	2026-01-16 12:05:39.524839	funding_end_date	2025-08-16	2025-09-05
7476	99	1	2026-01-16 12:05:39.525131	manager_feedback	Хороший специалист	Рекомендую
7477	99	1	2026-01-16 12:05:39.525669	ready_for_vacancy	Нет	Да
7478	206	1	2026-01-16 12:05:39.549823	comments	Ожидает оффер	Срочно нужен проект
7479	206	1	2026-01-16 12:05:39.550495	contacts	+7 (981) 211-25-59, @волмакс92, maxim.popov190@company.ru	+7 (954) 844-12-95, @волмакс15, maxim.popov190@company.ru
7480	206	1	2026-01-16 12:05:39.551348	it_block	Прочее	B2O
7481	206	1	2026-01-16 12:05:39.551997	recruiter	Орлов М.С.	Смирнова А.А.
7482	206	1	2026-01-16 12:05:39.552447	entry_date	2024-03-13	2025-12-30
7483	206	1	2026-01-16 12:05:39.553207	resume_link	https://drive.google.com/file/57155	https://drive.google.com/file/29996
7484	206	1	2026-01-16 12:05:39.553958	ck_department	ЦК Инфраструктуры	ЦК Аналитики
7485	206	1	2026-01-16 12:05:39.554556	placement_type	аутстафф	любой
7486	206	1	2026-01-16 12:05:39.554956	current_manager	Козлов Д.В.	Михайлова О.Н.
7487	206	1	2026-01-16 12:05:39.555487	target_projects	Banking App	Data Platform, Banking App
7488	206	1	2026-01-16 12:05:39.556071	candidate_status	В работе	Забронирован
7489	206	1	2026-01-16 12:05:39.556569	funding_end_date	2025-07-29	2025-12-08
7490	206	1	2026-01-16 12:05:39.557181	manager_feedback	Хороший специалист	Нужно развитие
7491	181	1	2026-01-16 12:05:39.586924	hr_bp	Лебедева Т.М.	Волкова Н.В.
7492	181	1	2026-01-16 12:05:39.587432	comments	В процессе согласования	Ожидает оффер
7493	181	1	2026-01-16 12:05:39.588071	contacts	+7 (985) 644-44-30, @смиилья30, mark.novikov165@company.ru	+7 (967) 632-80-59, @смиилья10, mark.novikov165@company.ru
7494	181	1	2026-01-16 12:05:39.588621	it_block	B2O	Развитие
7495	181	1	2026-01-16 12:05:39.589173	recruiter	Белова И.Д.	Новикова Е.П.
7496	181	1	2026-01-16 12:05:39.589866	entry_date	2025-06-08	2024-01-16
7497	181	1	2026-01-16 12:05:39.590242	resume_link	https://drive.google.com/file/65355	https://drive.google.com/file/41745
7498	181	1	2026-01-16 12:05:39.59138	ck_department	Департамент данных	ЦК Аналитики
7499	181	1	2026-01-16 12:05:39.592182	placement_type	любой	аутстафф
7500	181	1	2026-01-16 12:05:39.592818	current_manager	Михайлова О.Н.	Козлов Д.В.
7501	181	1	2026-01-16 12:05:39.593444	target_projects	Mobile App, Data Platform, E-commerce Platform	Data Platform, DevOps Platform, Infrastructure
7502	181	1	2026-01-16 12:05:39.593996	funding_end_date	2025-04-22	2025-05-14
7503	181	1	2026-01-16 12:05:39.594495	manager_feedback	Отличные результаты	Рекомендую
7504	432	1	2026-01-16 12:05:39.611123	hr_bp	Волкова Н.В.	Лебедева Т.М.
7505	432	1	2026-01-16 12:05:39.611564	comments	В процессе согласования	Срочно нужен проект
7506	432	1	2026-01-16 12:05:39.611886	contacts	+7 (938) 706-45-64, @тарвале91, v.tarasova@rt.ru	+7 (955) 258-91-30, @тарвале61, v.tarasova@rt.ru
7507	432	1	2026-01-16 12:05:39.612246	it_block	Эксплуатация	B2O
7508	432	1	2026-01-16 12:05:39.612705	entry_date	2025-09-15	2024-05-29
7509	432	1	2026-01-16 12:05:39.613029	resume_link	https://drive.google.com/file/24232	https://drive.google.com/file/39511
7510	432	1	2026-01-16 12:05:39.613468	ck_department	Департамент цифровых продуктов	ЦК Инфраструктуры
7511	432	1	2026-01-16 12:05:39.613993	transfer_date	2025-08-22	2025-02-18
7512	432	1	2026-01-16 12:05:39.614427	placement_type	аутстафф	перевод
7513	432	1	2026-01-16 12:05:39.614799	current_manager	Сидорова Е.К.	Михайлова О.Н.
7514	432	1	2026-01-16 12:05:39.615249	target_projects	Banking App, Data Platform	DevOps Platform
7515	432	1	2026-01-16 12:05:39.615598	funding_end_date	2025-07-04	2026-07-18
7516	432	1	2026-01-16 12:05:39.61588	manager_feedback	Отличные результаты	
7517	435	1	2026-01-16 12:05:39.638978	hr_bp	Лебедева Т.М.	Морозов К.А.
7518	435	1	2026-01-16 12:05:39.640291	comments		Срочно нужен проект
7519	435	1	2026-01-16 12:05:39.640731	contacts	+7 (925) 520-85-73, @алеконс21, k.alekseev@rt.ru	+7 (918) 480-89-32, @алеконс21, k.alekseev@rt.ru
7520	435	1	2026-01-16 12:05:39.641143	recruiter	Белова И.Д.	Новикова Е.П.
7521	435	1	2026-01-16 12:05:39.64172	entry_date	2024-03-28	2024-04-23
7522	435	1	2026-01-16 12:05:39.642144	resume_link	https://drive.google.com/file/22171	https://drive.google.com/file/96583
7523	435	1	2026-01-16 12:05:39.642499	ck_department	ЦК Разработки	Департамент данных
7524	435	1	2026-01-16 12:05:39.642794	transfer_date		2026-04-26
7525	435	1	2026-01-16 12:05:39.643073	current_manager	Сидорова Е.К.	Петров С.М.
7526	435	1	2026-01-16 12:05:39.643348	target_projects	Banking App, DevOps Platform, ML Pipeline	Mobile App, Banking App, E-commerce Platform
7527	435	1	2026-01-16 12:05:39.643621	candidate_status	В работе	Увольнение по СС
7528	435	1	2026-01-16 12:05:39.643902	funding_end_date	2026-05-12	2026-03-27
7529	435	1	2026-01-16 12:05:39.644176	manager_feedback		Рекомендую
7530	435	1	2026-01-16 12:05:39.644448	ready_for_vacancy	Да	Нет
7531	441	1	2026-01-16 12:05:39.776993	hr_bp	Морозов К.А.	Лебедева Т.М.
7532	441	1	2026-01-16 12:05:39.777776	comments	Срочно нужен проект	
7533	441	1	2026-01-16 12:05:39.778446	contacts	+7 (963) 710-86-77, @анталин37, a.antonova@rt.ru	+7 (940) 792-60-93, @анталин30, a.antonova@rt.ru
7534	441	1	2026-01-16 12:05:39.77918	entry_date	2025-08-14	2024-09-10
7535	441	1	2026-01-16 12:05:39.779748	resume_link	https://drive.google.com/file/78232	https://drive.google.com/file/81738
7536	441	1	2026-01-16 12:05:39.780298	transfer_date	2026-04-24	
7537	441	1	2026-01-16 12:05:39.7809	current_manager	Петров С.М.	Михайлова О.Н.
7538	441	1	2026-01-16 12:05:39.781366	target_projects	Mobile App	Infrastructure, E-commerce Platform, Госуслуги 2.0
7539	441	1	2026-01-16 12:05:39.781901	candidate_status	Увольнение по СЖ	В работе
7540	441	1	2026-01-16 12:05:39.782695	funding_end_date	2025-01-25	2025-09-07
7541	441	1	2026-01-16 12:05:39.783204	manager_feedback		Рекомендую
7542	441	1	2026-01-16 12:05:39.783839	ready_for_vacancy	Да	Нет
7543	453	1	2026-01-16 12:05:39.818909	hr_bp	Волкова Н.В.	Лебедева Т.М.
7544	453	1	2026-01-16 12:05:39.819657	comments		В процессе согласования
7545	453	1	2026-01-16 12:05:39.82038	contacts	+7 (961) 279-93-95, @макалек45, a.maksimova@rt.ru	+7 (930) 437-78-22, @макалек9, a.maksimova@rt.ru
7546	453	1	2026-01-16 12:05:39.821721	it_block	Развитие	B2O
7547	453	1	2026-01-16 12:05:39.822419	recruiter	Новикова Е.П.	Орлов М.С.
7548	453	1	2026-01-16 12:05:39.823018	entry_date	2024-04-30	2024-03-30
7549	453	1	2026-01-16 12:05:39.823571	resume_link	https://drive.google.com/file/70178	https://drive.google.com/file/57962
7550	453	1	2026-01-16 12:05:39.82415	ck_department	ЦК Аналитики	ЦК Разработки
7551	453	1	2026-01-16 12:05:39.824679	transfer_date	2025-01-25	
7552	453	1	2026-01-16 12:05:39.82526	placement_type	перевод	аутстафф
7553	453	1	2026-01-16 12:05:39.825845	current_manager	Петров С.М.	Иванов А.П.
7554	453	1	2026-01-16 12:05:39.826431	target_projects	Banking App, Mobile App, E-commerce Platform	DevOps Platform, Госуслуги 2.0
7555	453	1	2026-01-16 12:05:39.826899	candidate_status	Увольнение по СЖ	В работе
7556	453	1	2026-01-16 12:05:39.827425	funding_end_date	2025-01-25	2026-03-15
7557	453	1	2026-01-16 12:05:39.830028	manager_feedback	Рекомендую	Отличные результаты
7558	453	1	2026-01-16 12:05:39.831262	ready_for_vacancy	Да	Нет
7559	463	1	2026-01-16 12:05:39.883711	hr_bp	Волкова Н.В.	Лебедева Т.М.
7560	463	1	2026-01-16 12:05:39.884398	contacts	+7 (974) 382-75-84, @макпаве90, p.makarov@rt.ru	+7 (940) 197-87-38, @макпаве16, p.makarov@rt.ru
7561	463	1	2026-01-16 12:05:39.884795	it_block	Развитие	B2O
7562	463	1	2026-01-16 12:05:39.885382	recruiter	Новикова Е.П.	Белова И.Д.
7563	463	1	2026-01-16 12:05:39.885845	entry_date	2025-06-14	2024-01-23
7564	463	1	2026-01-16 12:05:39.886306	resume_link	https://drive.google.com/file/25475	https://drive.google.com/file/74352
7565	463	1	2026-01-16 12:05:39.886704	ck_department	Департамент цифровых продуктов	ЦК Аналитики
7566	463	1	2026-01-16 12:05:39.887306	transfer_date	2025-08-10	2026-03-18
7567	463	1	2026-01-16 12:05:39.88778	placement_type	любой	аутстафф
7568	463	1	2026-01-16 12:05:39.888242	current_manager	Петров С.М.	Козлов Д.В.
7569	463	1	2026-01-16 12:05:39.888697	target_projects	Banking App, Infrastructure	Mobile App, Data Platform, Госуслуги 2.0
7570	463	1	2026-01-16 12:05:39.88916	funding_end_date	2026-02-05	2025-01-14
7571	463	1	2026-01-16 12:05:39.88964	manager_feedback	Нужно развитие	Хороший специалист
7572	507	1	2026-01-16 12:05:39.937319	comments	В процессе согласования	
7573	507	1	2026-01-16 12:05:39.93785	contacts	+7 (921) 512-13-21, @новники15, n.novikov@rt.ru	+7 (956) 110-73-35, @новники56, n.novikov@rt.ru
7574	507	1	2026-01-16 12:05:39.938385	it_block	Эксплуатация	Прочее
7575	507	1	2026-01-16 12:05:39.938841	recruiter	Смирнова А.А.	Орлов М.С.
7576	507	1	2026-01-16 12:05:39.93924	entry_date	2024-04-21	2024-06-01
7577	507	1	2026-01-16 12:05:39.939725	resume_link	https://drive.google.com/file/38762	https://drive.google.com/file/53523
7578	507	1	2026-01-16 12:05:39.940174	transfer_date		2025-07-31
7579	507	1	2026-01-16 12:05:39.940591	current_manager	Петров С.М.	Михайлова О.Н.
7580	507	1	2026-01-16 12:05:39.940942	target_projects	DevOps Platform	Mobile App
7581	507	1	2026-01-16 12:05:39.941352	candidate_status	В работе	Увольнение по СС
7582	507	1	2026-01-16 12:05:39.941829	funding_end_date	2026-11-10	2025-08-02
7583	507	1	2026-01-16 12:05:39.942371	ready_for_vacancy	Да	Нет
7584	517	1	2026-01-16 12:05:39.994719	hr_bp	Волкова Н.В.	Морозов К.А.
7585	517	1	2026-01-16 12:05:39.996052	contacts	+7 (908) 280-55-38, @солматв58, m.solovev@rt.ru	+7 (914) 215-92-59, @солматв19, m.solovev@rt.ru
7586	517	1	2026-01-16 12:05:39.99667	it_block	Эксплуатация	B2O
7587	517	1	2026-01-16 12:05:39.99891	recruiter	Смирнова А.А.	Новикова Е.П.
7588	517	1	2026-01-16 12:05:40.000566	entry_date	2025-01-21	2024-12-14
7589	517	1	2026-01-16 12:05:40.002978	resume_link	https://drive.google.com/file/95637	https://drive.google.com/file/28887
7590	517	1	2026-01-16 12:05:40.004136	transfer_date	2026-03-26	2025-12-28
7591	517	1	2026-01-16 12:05:40.00477	current_manager	Козлов Д.В.	Петров С.М.
7592	517	1	2026-01-16 12:05:40.005309	target_projects	ML Pipeline, Banking App, Mobile App	E-commerce Platform, Infrastructure, DevOps Platform
7593	517	1	2026-01-16 12:05:40.006076	funding_end_date	2026-06-27	2026-09-20
7594	517	1	2026-01-16 12:05:40.006767	manager_feedback	Отличные результаты	Нужно развитие
7595	221	1	2026-01-16 12:05:40.044683	comments	В процессе согласования	
7596	221	1	2026-01-16 12:05:40.045795	contacts	+7 (954) 499-23-21, @гусксен79, k.guseva@rt.ru	+7 (939) 424-25-39, @гусксен90, k.guseva@rt.ru
7597	221	1	2026-01-16 12:05:40.046444	it_block	Прочее	Развитие
7598	221	1	2026-01-16 12:05:40.046993	entry_date	2024-06-22	2024-08-31
7599	221	1	2026-01-16 12:05:40.047534	resume_link	https://drive.google.com/file/57611	https://drive.google.com/file/86037
7600	221	1	2026-01-16 12:05:40.04807	transfer_date	2026-03-24	2025-03-23
7601	221	1	2026-01-16 12:05:40.048557	placement_type	перевод	аутстафф
7602	221	1	2026-01-16 12:05:40.048972	current_manager	Иванов А.П.	Петров С.М.
7603	221	1	2026-01-16 12:05:40.049465	target_projects	Infrastructure	ML Pipeline, Mobile App
7604	221	1	2026-01-16 12:05:40.049871	candidate_status	Увольнение по СС	Увольнение по СЖ
7605	221	1	2026-01-16 12:05:40.050251	funding_end_date	2025-05-27	2025-02-04
7606	221	1	2026-01-16 12:05:40.050921	manager_feedback	Хороший специалист	Рекомендую
7607	239	1	2026-01-16 12:05:40.091513	hr_bp	Волкова Н.В.	Лебедева Т.М.
7608	239	1	2026-01-16 12:05:40.091931	comments	Ожидает оффер	В процессе согласования
7609	239	1	2026-01-16 12:05:40.092247	contacts	+7 (977) 320-37-55, @ковмари61, m.kovaleva@rt.ru	+7 (902) 213-84-83, @ковмари88, m.kovaleva@rt.ru
7610	239	1	2026-01-16 12:05:40.092539	it_block	Прочее	B2O
7611	239	1	2026-01-16 12:05:40.092834	recruiter	Орлов М.С.	Смирнова А.А.
7612	239	1	2026-01-16 12:05:40.093123	entry_date	2024-07-24	2024-02-07
7613	239	1	2026-01-16 12:05:40.093644	resume_link	https://drive.google.com/file/98307	https://drive.google.com/file/42611
7614	239	1	2026-01-16 12:05:40.093957	ck_department	ЦК Инфраструктуры	Департамент данных
7615	239	1	2026-01-16 12:05:40.094227	placement_type	любой	перевод
7616	239	1	2026-01-16 12:05:40.094494	current_manager	Сидорова Е.К.	Михайлова О.Н.
7617	239	1	2026-01-16 12:05:40.094768	target_projects	E-commerce Platform	DevOps Platform, Banking App, Infrastructure
7618	239	1	2026-01-16 12:05:40.095107	funding_end_date	2026-01-15	2025-05-04
7619	239	1	2026-01-16 12:05:40.095554	manager_feedback		Хороший специалист
7620	239	1	2026-01-16 12:05:40.09597	ready_for_vacancy	Нет	Да
7621	84	1	2026-01-16 12:05:40.159977	hr_bp	Морозов К.А.	Лебедева Т.М.
7622	84	1	2026-01-16 12:05:40.160735	comments	Ожидает оффер	
7623	84	1	2026-01-16 12:05:40.161423	contacts	+7 (914) 146-46-34, @фёдсерг92, tatiana.vorobyov68@company.ru	+7 (951) 846-25-22, @фёдсерг67, tatiana.vorobyov68@company.ru
7624	84	1	2026-01-16 12:05:40.162132	it_block	Диджитал	B2O
7625	84	1	2026-01-16 12:05:40.16271	recruiter	Смирнова А.А.	Белова И.Д.
7626	84	1	2026-01-16 12:05:40.163196	entry_date	2025-04-26	2025-11-13
7627	84	1	2026-01-16 12:05:40.1637	resume_link	https://drive.google.com/file/84128	https://drive.google.com/file/11074
7628	84	1	2026-01-16 12:05:40.164144	ck_department	ЦК Разработки	Департамент цифровых продуктов
7629	84	1	2026-01-16 12:05:40.164717	transfer_date		2026-11-18
7630	84	1	2026-01-16 12:05:40.165281	current_manager	Петров С.М.	Иванов А.П.
7631	84	1	2026-01-16 12:05:40.165805	target_projects	Infrastructure, DevOps Platform, Госуслуги 2.0	ML Pipeline
7632	84	1	2026-01-16 12:05:40.166412	candidate_status	В работе	Переведен
7633	84	1	2026-01-16 12:05:40.166933	funding_end_date	2026-10-29	2025-05-29
7634	84	1	2026-01-16 12:05:40.167331	manager_feedback	Отличные результаты	
7635	84	1	2026-01-16 12:05:40.167725	ready_for_vacancy	Нет	Да
7636	520	7	2026-01-16 13:51:12.776815	status	На бенче	На проекте
7637	520	7	2026-01-16 13:51:12.78182	comments	\N	Изменено Юзером2
7638	520	6	2026-01-16 13:51:41.77246	position	Middle Developer	Senior Developer
7639	520	6	2026-01-16 13:51:41.773454	grade	Middle	Senior
7640	520	6	2026-01-16 13:51:41.774133	comments	Изменено Юзером2	Изменено Юзером2, потом Юзером1
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: resourceuser
--

COPY public.employees (id, full_name, email, custom_fields, created_at, updated_at) FROM stdin;
6	Иванов Алексей Петрович	a.ivanov@company.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "status": "На бенче", "comments": "Срочно нужен проект", "contacts": "+7 (986) 977-47-74, @иваалек96, a.ivanov@company.ru", "it_block": "Развитие", "location": "Москва", "position": "Senior Developer", "hire_date": "2020-03-15", "recruiter": "Орлов М.С.", "department": "Backend", "entry_date": "2025-12-19", "resume_link": "https://drive.google.com/file/64868", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline, Data Platform, E-commerce Platform", "candidate_status": "Забронирован", "funding_end_date": "2025-08-12", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 15:53:01.214832	2026-01-16 12:05:20.864387
9	Козлова Анна Игоревна	kozlova@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": 2800, "skills": "Selenium, JMeter, API Testing", "status": "На проекте", "project": "Banking App", "comments": "В процессе согласования", "contacts": "+7 (930) 336-63-61, @козанна1, kozlova@company.ru", "it_block": "Развитие", "location": "Гибрид", "position": "QA Engineer", "hire_date": "2019-09-20", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2025-09-06", "resume_link": "https://drive.google.com/file/82499", "ck_department": "Департамент данных", "transfer_date": "2026-07-22", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Infrastructure, Data Platform, Banking App", "candidate_status": "Переведен", "funding_end_date": "2026-07-27", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 15:53:01.214832	2026-01-16 12:05:21.004243
213	Попов Артём Павлович	timur.romanov197@company.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1505", "skills": "JavaScript,React", "status": "На бенче", "project": "Analytics Platform", "comments": "", "contacts": "+7 (992) 140-75-43, @попартё1, timur.romanov197@company.ru", "it_block": "Развитие", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2019-03-20", "recruiter": "Белова И.Д.", "department": "Design", "entry_date": "2025-09-03", "resume_link": "https://drive.google.com/file/56213", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-11-18", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Mobile App, Banking App", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-01-01", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:42.765718	2026-01-16 12:05:21.129279
14	Соколов Игорь Павлович	sokolov@company.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": 4000, "skills": "Agile, Scrum, Jira", "status": "На проекте", "project": "E-commerce Platform", "comments": "", "contacts": "+7 (969) 333-74-29, @сокигор80, sokolov@company.ru", "it_block": "Эксплуатация", "location": "Гибрид", "position": "Project Manager", "hire_date": "2017-08-22", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2024-04-13", "resume_link": "https://drive.google.com/file/66403", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "E-commerce Platform", "candidate_status": "В работе", "funding_end_date": "2026-07-12", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 15:53:01.214832	2026-01-16 12:05:21.296899
13	Волкова Ольга Николаевна	volkova@company.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": 3000, "skills": "SQL, Python, Tableau", "status": "В отпуске", "project": "Data Platform", "comments": "", "contacts": "+7 (987) 430-45-51, @волольг21, volkova@company.ru", "it_block": "Прочее", "location": "Москва", "position": "Analyst", "hire_date": "2019-04-08", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2024-12-22", "resume_link": "https://drive.google.com/file/45257", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Banking App, Mobile App, Data Platform", "candidate_status": "Свободен", "funding_end_date": "2026-03-19", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 15:53:01.214832	2026-01-16 12:05:21.456343
394	Соколова Мария Михайловна	m.sokolova@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1546", "skills": "Team Leadership, Scrum, Stakeholder Management, Risk Management", "status": "Болеет", "project": "", "comments": "Срочно нужен проект", "contacts": "+7 (950) 119-77-86, @сокмари92, m.sokolova@rt.ru", "it_block": "НУК", "location": "Москва", "position": "Project Manager", "hire_date": "2018-06-24", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2024-01-01", "resume_link": "https://drive.google.com/file/68664", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline", "candidate_status": "В работе", "funding_end_date": "2026-02-18", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:53.775623	2026-01-16 12:05:21.56206
7	Петрова Мария Сергеевна	petrova@company.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "status": "На проекте", "comments": "", "contacts": "+7 (965) 866-79-73, @петмари88, petrova@company.ru", "it_block": "Прочее", "location": "Удалённо", "position": "Tech Lead", "hire_date": "2021-06-01", "recruiter": "Белова И.Д.", "department": "Frontend", "entry_date": "2025-07-17", "resume_link": "https://drive.google.com/file/48396", "ck_department": "Департамент данных", "transfer_date": "2026-03-07", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline, Госуслуги 2.0", "candidate_status": "Переведен", "funding_end_date": "2026-07-27", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 15:53:01.214832	2026-01-16 12:05:21.724662
222	Соловьев Никита Александрович	n.solovev@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2472", "skills": "Manual Testing, JMeter, JUnit, Selenium", "status": "На проекте", "project": "IoT платформа", "comments": "Ожидает оффер", "contacts": "+7 (982) 274-76-50, @солники26, n.solovev@rt.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "QA Engineer", "hire_date": "2016-06-19", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2025-07-10", "resume_link": "https://drive.google.com/file/13343", "ck_department": "ЦК Разработки", "transfer_date": "2025-06-09", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "E-commerce Platform, DevOps Platform, Data Platform", "candidate_status": "Переведен", "funding_end_date": "2026-08-08", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:46.688097	2026-01-16 12:05:22.098885
225	Семенова Татьяна Александровна	t.semenova@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1635", "skills": "Figma, UI/UX, Adobe XD, Prototyping", "status": "На проекте", "project": "RT Cloud", "comments": "Срочно нужен проект", "contacts": "+7 (987) 156-15-39, @семтать63, t.semenova@rt.ru", "it_block": "B2O", "location": "Гибрид", "position": "Designer", "hire_date": "2020-11-16", "recruiter": "Новикова Е.П.", "department": "Design", "entry_date": "2024-03-01", "resume_link": "https://drive.google.com/file/21731", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "DevOps Platform", "candidate_status": "В работе", "funding_end_date": "2026-03-09", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:46.838155	2026-01-16 12:05:22.248056
228	Егорова Анна Никитична	a.egorova@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1773", "skills": "Wireframing, Sketch, Figma, Prototyping", "status": "На проекте", "project": "RT Cloud", "comments": "В процессе согласования", "contacts": "+7 (970) 901-75-45, @егоанна14, a.egorova@rt.ru", "it_block": "НУК", "location": "Удалённо", "position": "Designer", "hire_date": "2024-09-16", "recruiter": "Новикова Е.П.", "department": "Design", "entry_date": "2024-10-11", "resume_link": "https://drive.google.com/file/96371", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "ML Pipeline, Infrastructure, Mobile App", "candidate_status": "Забронирован", "funding_end_date": "2025-10-28", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:47.01276	2026-01-16 12:05:22.446544
17	Кузнецов Денис Дмитриевич	timofey.romanov1@company.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2885", "skills": "Node.js,Express", "status": "В отпуске", "project": "E-commerce", "comments": "В процессе согласования", "contacts": "+7 (902) 801-53-10, @куздени58, timofey.romanov1@company.ru", "it_block": "Развитие", "location": "Гибрид", "position": "Team Lead", "hire_date": "2022-09-02", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2024-12-24", "resume_link": "https://drive.google.com/file/93508", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-10-24", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Infrastructure, Data Platform, ML Pipeline", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-02-09", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 18:21:21.614472	2026-01-16 12:05:22.540785
16	Смирнов Илья Владимирович	ivan.ivanov@company.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1500", "skills": "Java,Spring", "status": "На проекте", "project": "CRM System", "comments": "Срочно нужен проект", "contacts": "+7 (957) 709-94-50, @смиилья77, ivan.ivanov@company.ru", "it_block": "Прочее", "location": "Москва", "position": "Senior Developer", "hire_date": "2022-05-15", "recruiter": "Орлов М.С.", "department": "Backend", "entry_date": "2024-03-31", "resume_link": "https://drive.google.com/file/29686", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Banking App, Госуслуги 2.0", "candidate_status": "В работе", "funding_end_date": "2026-09-28", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 18:20:34.315834	2026-01-16 12:05:22.671517
231	Соколов Матвей Юрьевич	m.sokolov@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2985", "skills": "Redis, PostgreSQL, Kubernetes, Java", "status": "На проекте", "project": "Wink платформа", "comments": "", "contacts": "+7 (939) 105-78-21, @сокматв65, m.sokolov@rt.ru", "it_block": "Прочее", "location": "Удалённо", "position": "Senior Developer", "hire_date": "2016-08-28", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2024-12-28", "resume_link": "https://drive.google.com/file/18511", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Госуслуги 2.0, Mobile App", "candidate_status": "В работе", "funding_end_date": "2025-10-14", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:47.14367	2026-01-16 12:05:22.763194
234	Антонова Анна Руслановна	a.antonova@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1868", "skills": "Vue.js, Webpack, Redux, React", "status": "На проекте", "project": "Техподдержка 3.0", "comments": "Ожидает оффер", "contacts": "+7 (964) 735-32-31, @антанна37, a.antonova@rt.ru", "it_block": "B2O", "location": "Москва", "position": "Middle Developer", "hire_date": "2025-05-19", "recruiter": "Орлов М.С.", "department": "Frontend", "entry_date": "2025-07-10", "resume_link": "https://drive.google.com/file/68595", "ck_department": "ЦК Разработки", "transfer_date": "2026-01-27", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline", "candidate_status": "Переведен", "funding_end_date": "2025-04-25", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:47.320666	2026-01-16 12:05:22.899284
99	Фёдоров Сергей Евгеньевич	anton.nikitin83@company.ru	{"grade": "Lead", "hr_bp": "Волкова Н.В.", "mentor": "Novikova O.P.", "salary": "2453", "skills": "AWS,Terraform", "status": "На проекте", "project": "Admin Panel", "comments": "В процессе согласования", "contacts": "+7 (998) 470-73-32, @фёдсерг48, anton.nikitin83@company.ru", "it_block": "B2O", "location": "Москва", "position": "Middle Developer", "hire_date": "2019-09-25", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2025-07-03", "resume_link": "https://drive.google.com/file/36801", "ck_department": "Департамент данных", "transfer_date": "2025-03-16", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Госуслуги 2.0, Infrastructure, DevOps Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-09-05", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 18:21:30.545049	2026-01-16 12:05:39.526168
26	Волков Максим Владимирович	vladimir.egorov10@company.ru	{"grade": "Senior", "mentor": "", "salary": "902", "skills": "Rust,WebAssembly", "status": "На бенче", "project": "Security Audit", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2021-04-06", "department": "DevOps"}	2026-01-15 18:21:22.559573	2026-01-15 18:21:22.559578
42	Алексеев Михаил Иванович	grigory.kozlov26@company.ru	{"grade": "Principal", "mentor": "Kozlova E.A.", "salary": "1523", "skills": "PostgreSQL,Redis", "status": "На бенче", "project": "Refactoring", "location": "Удалённо", "position": "Junior Developer", "hire_date": "2021-02-07", "department": "Backend"}	2026-01-15 18:21:24.410552	2026-01-15 18:21:24.410634
29	Семёнов Кирилл Евгеньевич	danil.novikov13@company.ru	{"grade": "Principal", "mentor": "", "salary": "2662", "skills": "TypeScript,Vue", "status": "На бенче", "project": "Data Pipeline", "location": "Гибрид", "position": "QA Engineer", "hire_date": "2018-08-22", "department": "Management"}	2026-01-15 18:21:22.890852	2026-01-15 18:21:22.890858
40	Морозов Никита Александрович	irina.ivanov24@company.ru	{"grade": "Junior", "mentor": "", "salary": "2939", "skills": "PostgreSQL,Redis", "status": "На бенче", "project": "", "location": "Гибрид", "position": "Designer", "hire_date": "2022-12-12", "department": "DevOps"}	2026-01-15 18:21:24.177169	2026-01-15 18:21:24.177242
34	Васильев Иван Сергеевич	natalia.zaitsev18@company.ru	{"grade": "Principal", "mentor": "", "salary": "1064", "skills": "PostgreSQL,Redis", "status": "В отпуске", "project": "Refactoring", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2020-12-21", "department": "DevOps"}	2026-01-15 18:21:23.459427	2026-01-15 18:21:23.459433
43	Лебедев Дмитрий Павлович	arseny.nikitin27@company.ru	{"grade": "Principal", "mentor": "", "salary": "1029", "skills": "Ruby,Rails", "status": "Болеет", "project": "Data Pipeline", "location": "Гибрид", "position": "Project Manager", "hire_date": "2021-04-28", "department": "Mobile"}	2026-01-15 18:21:24.527727	2026-01-15 18:21:24.52774
243	Алексеева Анастасия Николаевна	a.alekseeva@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2853", "skills": "GitLab CI, AWS, Jenkins, Docker", "status": "В отпуске", "project": "", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2024-05-27", "department": "DevOps"}	2026-01-15 20:53:47.77892	2026-01-15 20:53:47.778996
238	Алексеев Владислав Вадимович	v.alekseev@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1249", "skills": "REST API, Docker, Microservices, Spring Boot", "status": "На проекте", "project": "CRM Enterprise", "comments": "", "contacts": "+7 (909) 988-59-16, @алевлад62, v.alekseev@rt.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Junior Developer", "hire_date": "2018-03-10", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2024-10-14", "resume_link": "https://drive.google.com/file/41364", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-12-16", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "Infrastructure, Data Platform, DevOps Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-08-08", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:47.533644	2026-01-16 12:05:23.073395
240	Антонова Анастасия Павловна	a.antonova@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2948", "skills": "Android SDK, Swift, Mobile CI/CD, React Native", "status": "На проекте", "project": "ML Pipeline", "comments": "", "contacts": "+7 (982) 471-59-18, @антанас88, a.antonova@rt.ru", "it_block": "Прочее", "location": "Гибрид", "position": "Senior Developer", "hire_date": "2019-02-09", "recruiter": "Орлов М.С.", "department": "Mobile", "entry_date": "2024-04-09", "resume_link": "https://drive.google.com/file/96989", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "Infrastructure", "candidate_status": "Свободен", "funding_end_date": "2025-07-09", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:47.629893	2026-01-16 12:05:23.155234
23	Новиков Роман Павлович	denis.fedorov7@company.ru	{"grade": "Principal", "hr_bp": "Лебедева Т.М.", "mentor": "Petrov M.I.", "salary": "1963", "skills": "Swift,iOS", "status": "Болеет", "project": "", "comments": "", "contacts": "+7 (986) 428-20-44, @новрома5, denis.fedorov7@company.ru", "it_block": "НУК", "location": "Санкт-Петербург", "position": "Designer", "hire_date": "2018-04-14", "recruiter": "Новикова Е.П.", "department": "Backend", "entry_date": "2025-11-15", "resume_link": "https://drive.google.com/file/37126", "ck_department": "ЦК Аналитики", "transfer_date": "2026-10-25", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "Banking App", "candidate_status": "Переведен", "funding_end_date": "2026-11-15", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 18:21:22.211227	2026-01-16 12:05:23.271036
63	Попов Артём Павлович	arseny.morozov47@company.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "Ivanov A.S.", "salary": "2162", "skills": "PostgreSQL,Redis", "status": "Болеет", "project": "E-commerce", "comments": "", "contacts": "+7 (970) 214-69-96, @попартё67, arseny.morozov47@company.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2019-03-04", "recruiter": "Орлов М.С.", "department": "QA", "entry_date": "2024-09-14", "resume_link": "https://drive.google.com/file/99148", "ck_department": "ЦК Разработки", "transfer_date": "2025-03-28", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Banking App", "candidate_status": "Переведен", "funding_end_date": "2026-07-11", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:26.674477	2026-01-16 12:05:23.383361
244	Соловьев Кирилл Евгеньевич	k.solovev@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2936", "skills": "ETL, SQL, A/B Testing, Excel", "status": "На проекте", "project": "Service Mesh", "location": "Москва", "position": "Analyst", "hire_date": "2024-05-17", "department": "Analytics"}	2026-01-15 20:53:47.833605	2026-01-15 20:53:47.833629
245	Никитин Савелий Дмитриевич	s.nikitin@rt.ru	{"grade": "Junior", "mentor": "Лебедев Константин Павлович", "salary": "959", "skills": "Kubernetes, Prometheus, GitLab CI, AWS", "status": "На проекте", "project": "Партнерский портал", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2017-12-04", "department": "DevOps"}	2026-01-15 20:53:47.877901	2026-01-15 20:53:47.877933
246	Григорьев Олег Павлович	o.grigorev@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2351", "skills": "Budgeting, Team Leadership, Agile, Scrum", "status": "На проекте", "project": "Monitoring System", "location": "Удалённо", "position": "Project Manager", "hire_date": "2023-08-31", "department": "Management"}	2026-01-15 20:53:47.92281	2026-01-15 20:53:47.922874
247	Андреев Иван Александрович	i.andreev@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2375", "skills": "Grafana, Prometheus, Terraform, AWS", "status": "На бенче", "project": "", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2022-11-26", "department": "DevOps"}	2026-01-15 20:53:47.9695	2026-01-15 20:53:47.969529
248	Козлова Яна Юрьевна	ya.kozlova@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3397", "skills": "ETL, Power BI, SQL, Tableau", "status": "На проекте", "project": "B2B личный кабинет", "location": "Удалённо", "position": "Analyst", "hire_date": "2023-02-18", "department": "Analytics"}	2026-01-15 20:53:48.033674	2026-01-15 20:53:48.033699
249	Попов Илья Маркович	i.popov@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2872", "skills": "JUnit, Automation, Selenium, TestNG", "status": "На проекте", "project": "ML Pipeline", "location": "Москва", "position": "QA Engineer", "hire_date": "2019-05-16", "department": "QA"}	2026-01-15 20:53:48.075043	2026-01-15 20:53:48.075064
250	Григорьев Даниил Михайлович	d.grigorev@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2822", "skills": "React Native, Mobile CI/CD, Swift, iOS SDK", "status": "На проекте", "project": "Единая биометрическая система", "location": "Санкт-Петербург", "position": "Senior Developer", "hire_date": "2016-09-14", "department": "Mobile"}	2026-01-15 20:53:48.141315	2026-01-15 20:53:48.141341
251	Зайцева Евгения Вадимовна	e.zaytseva@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1764", "skills": "GraphQL, TypeScript, JavaScript, Node.js", "status": "На проекте", "project": "IoT платформа", "location": "Санкт-Петербург", "position": "Middle Developer", "hire_date": "2024-04-07", "department": "Frontend"}	2026-01-15 20:53:48.189548	2026-01-15 20:53:48.189574
252	Кузнецова Галина Павловна	g.kuznetsova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1378", "skills": "Vue.js, React, Redux, Node.js", "status": "На проекте", "project": "CRM Enterprise", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2017-03-18", "department": "Frontend"}	2026-01-15 20:53:48.225514	2026-01-15 20:53:48.225532
253	Тарасова Мария Павловна	m.tarasova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1854", "skills": "Scrum, Jira, Budgeting, Team Leadership", "status": "На проекте", "project": "Analytics Dashboard", "location": "Москва", "position": "Project Manager", "hire_date": "2025-07-26", "department": "Management"}	2026-01-15 20:53:48.260776	2026-01-15 20:53:48.26081
254	Дмитриев Юрий Максимович	yu.dmitriev@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2400", "skills": "Grafana, Jenkins, Terraform, Linux", "status": "На проекте", "project": "Monitoring System", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2018-12-20", "department": "DevOps"}	2026-01-15 20:53:48.298252	2026-01-15 20:53:48.298357
28	Лебедев Дмитрий Алексеевич	yaroslav.orlov12@company.ru	{"grade": "Middle", "mentor": "", "salary": "1358", "skills": "AWS,Terraform", "status": "На бенче", "project": "Analytics Platform", "location": "Москва", "position": "Middle Developer", "hire_date": "2020-03-21", "department": "Design"}	2026-01-15 18:21:22.790039	2026-01-15 18:21:22.790044
37	Михайлов Андрей Дмитриевич	yaroslav.korolev21@company.ru	{"grade": "Senior", "mentor": "", "salary": "2457", "skills": "Ruby,Rails", "status": "На бенче", "project": "Refactoring", "location": "Москва", "position": "Team Lead", "hire_date": "2020-05-01", "department": "Management"}	2026-01-15 18:21:23.807494	2026-01-15 18:21:23.807499
31	Смирнов Илья Андреевич	timofey.petrov15@company.ru	{"grade": "Senior", "mentor": "", "salary": "1175", "skills": "Swift,iOS", "status": "В отпуске", "project": "Infrastructure", "location": "Москва", "position": "Analyst", "hire_date": "2020-02-07", "department": "Mobile"}	2026-01-15 18:21:23.112639	2026-01-15 18:21:23.112645
35	Петров Алексей Михайлович	pavel.lebedev19@company.ru	{"grade": "Middle", "mentor": "", "salary": "1359", "skills": "Python,Django", "status": "В отпуске", "project": "Admin Panel", "location": "Москва", "position": "Project Manager", "hire_date": "2021-01-06", "department": "Mobile"}	2026-01-15 18:21:23.595679	2026-01-15 18:21:23.595685
36	Соколов Егор Владимирович	alexey.yakovlev20@company.ru	{"grade": "Middle", "mentor": "Kozlova E.A.", "salary": "2802", "skills": "Docker,Kubernetes", "status": "В отпуске", "project": "Admin Panel", "location": "Москва", "position": "Designer", "hire_date": "2020-01-15", "department": "QA"}	2026-01-15 18:21:23.706748	2026-01-15 18:21:23.706753
45	Иванов Александр Михайлович	natalia.sergeev29@company.ru	{"grade": "Principal", "mentor": "", "salary": "1559", "skills": "Ruby,Rails", "status": "В отпуске", "project": "Security Audit", "location": "Москва", "position": "Tech Lead", "hire_date": "2023-03-03", "department": "QA"}	2026-01-15 18:21:24.744738	2026-01-15 18:21:24.744742
47	Кузнецов Денис Дмитриевич	anna.stepanov31@company.ru	{"grade": "Junior", "mentor": "", "salary": "2153", "skills": "Docker,Kubernetes", "status": "На бенче", "project": "ML Platform", "location": "Санкт-Петербург", "position": "Senior Developer", "hire_date": "2022-10-02", "department": "Mobile"}	2026-01-15 18:21:24.940166	2026-01-15 18:21:24.94017
58	Лебедев Дмитрий Алексеевич	tatiana.volkov42@company.ru	{"grade": "Senior", "mentor": "Kozlova E.A.", "salary": "2328", "skills": "Swift,iOS", "status": "В отпуске", "project": "Refactoring", "location": "Санкт-Петербург", "position": "Middle Developer", "hire_date": "2021-03-27", "department": "Mobile"}	2026-01-15 18:21:26.144762	2026-01-15 18:21:26.144766
52	Михайлов Андрей Иванович	ilya.popov36@company.ru	{"grade": "Principal", "mentor": "", "salary": "1277", "skills": "Rust,WebAssembly", "status": "Болеет", "project": "Performance", "location": "Санкт-Петербург", "position": "Analyst", "hire_date": "2024-12-13", "department": "Management"}	2026-01-15 18:21:25.492402	2026-01-15 18:21:25.492406
255	Королева Екатерина Дмитриевна	e.koroleva@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3902", "skills": "Kubernetes, Grafana, Ansible, AWS", "status": "На проекте", "project": "DataLake", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2022-04-13", "department": "DevOps"}	2026-01-15 20:53:48.353513	2026-01-15 20:53:48.353537
256	Федоров Александр Сергеевич	a.fedorov@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2421", "skills": "Postman, API Testing, JMeter, Manual Testing", "status": "На проекте", "project": "RT Cloud", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2020-10-28", "department": "QA"}	2026-01-15 20:53:48.407542	2026-01-15 20:53:48.407567
257	Яковлев Павел Константинович	p.yakovlev@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2330", "skills": "Team Leadership, Agile, Scrum, Jira", "status": "На проекте", "project": "IoT платформа", "location": "Гибрид", "position": "Project Manager", "hire_date": "2019-05-22", "department": "Management"}	2026-01-15 20:53:48.463885	2026-01-15 20:53:48.463912
258	Соколова Екатерина Игоревна	e.sokolova@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2580", "skills": "Design Systems, Sketch, Wireframing, Figma", "status": "На проекте", "project": "5G инфраструктура", "location": "Москва", "position": "Designer", "hire_date": "2017-10-13", "department": "Design"}	2026-01-15 20:53:48.526986	2026-01-15 20:53:48.527015
259	Соловьев Максим Сергеевич	m.solovev@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1561", "skills": "Scrum, Agile, Risk Management, Confluence", "status": "На проекте", "project": "Monitoring System", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2023-03-21", "department": "Management"}	2026-01-15 20:53:48.580369	2026-01-15 20:53:48.580393
435	Алексеев Константин Павлович	k.alekseev@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1906", "skills": "User Research, UI/UX, Adobe XD, Figma", "status": "На проекте", "project": "AI Contact Center", "comments": "Срочно нужен проект", "contacts": "+7 (918) 480-89-32, @алеконс21, k.alekseev@rt.ru", "it_block": "Эксплуатация", "location": "Санкт-Петербург", "position": "Designer", "hire_date": "2022-12-14", "recruiter": "Новикова Е.П.", "department": "Design", "entry_date": "2024-04-23", "resume_link": "https://drive.google.com/file/96583", "ck_department": "Департамент данных", "transfer_date": "2026-04-26", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Mobile App, Banking App, E-commerce Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-03-27", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.021217	2026-01-16 12:05:39.644815
262	Фролов Савелий Антонович	s.frolov@rt.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Борисова Виктория Вадимовна", "salary": "664", "skills": "Prometheus, Ansible, GitLab CI, Grafana", "status": "На проекте", "project": "Видеонаблюдение", "comments": "", "contacts": "+7 (915) 789-65-24, @фросаве87, s.frolov@rt.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2023-01-15", "recruiter": "Смирнова А.А.", "department": "DevOps", "entry_date": "2025-08-19", "resume_link": "https://drive.google.com/file/84134", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Mobile App", "candidate_status": "В работе", "funding_end_date": "2026-03-12", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:48.71808	2026-01-16 12:05:23.614966
265	Семенова Галина Андреевна	g.semenova@rt.ru	{"grade": "Principal", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "5009", "skills": "Docker, PostgreSQL, REST API, Spring Boot", "status": "На проекте", "project": "Mobile App", "comments": "Ожидает оффер", "contacts": "+7 (968) 738-59-75, @семгали73, g.semenova@rt.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "Tech Lead", "hire_date": "2016-01-28", "recruiter": "Смирнова А.А.", "department": "Backend", "entry_date": "2025-06-24", "resume_link": "https://drive.google.com/file/41003", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2026-01-23", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "DevOps Platform, E-commerce Platform, Infrastructure", "candidate_status": "Переведен", "funding_end_date": "2025-03-14", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:48.864503	2026-01-16 12:05:23.72246
50	Петров Алексей Александрович	andrey.kuznetsov34@company.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1670", "skills": "PHP,Laravel", "status": "Болеет", "project": "Performance", "comments": "Срочно нужен проект", "contacts": "+7 (958) 370-32-29, @петалек10, andrey.kuznetsov34@company.ru", "it_block": "Прочее", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2023-02-21", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2025-05-19", "resume_link": "https://drive.google.com/file/43013", "ck_department": "Департамент данных", "transfer_date": "2025-12-05", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Mobile App, Госуслуги 2.0, E-commerce Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-09-30", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:25.278107	2026-01-16 12:05:23.841055
55	Морозов Никита Михайлович	igor.sokolov39@company.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "Petrov M.I.", "salary": "2953", "skills": "Ruby,Rails", "status": "На бенче", "project": "Refactoring", "comments": "", "contacts": "+7 (942) 218-16-62, @морники83, igor.sokolov39@company.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Senior Developer", "hire_date": "2022-04-28", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2024-04-24", "resume_link": "https://drive.google.com/file/29064", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-01-08", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Infrastructure, E-commerce Platform", "candidate_status": "Переведен", "funding_end_date": "2026-12-02", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:25.82858	2026-01-16 12:05:23.976819
519	Тестов Юзер Третий	test3@test.ru	{"grade": "Junior", "status": "На бенче", "position": "QA Engineer", "department": "QA"}	2026-01-16 13:49:22.26724	2026-01-16 13:49:22.267254
521	Тестов Юзер Второй	test2@test.ru	{"grade": "Senior", "status": "На проекте", "position": "Senior Developer", "department": "Frontend"}	2026-01-16 13:49:31.267339	2026-01-16 13:49:31.267353
269	Петрова Кристина Марковна	k.petrova@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1518", "skills": "Next.js, Vue.js, HTML/CSS, JavaScript", "status": "На проекте", "project": "Mobile App", "comments": "", "contacts": "+7 (996) 382-32-11, @петкрис20, k.petrova@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Middle Developer", "hire_date": "2019-07-19", "recruiter": "Смирнова А.А.", "department": "Frontend", "entry_date": "2025-01-05", "resume_link": "https://drive.google.com/file/59461", "ck_department": "Департамент данных", "transfer_date": "2026-06-09", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Mobile App", "candidate_status": "Переведен", "funding_end_date": "2026-05-24", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:49.069157	2026-01-16 12:05:24.19711
272	Соловьев Максим Романович	m.solovev@rt.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "3619", "skills": "Swift, iOS SDK, Kotlin, Firebase", "status": "В отпуске", "project": "", "comments": "Срочно нужен проект", "contacts": "+7 (933) 173-53-38, @солмакс36, m.solovev@rt.ru", "it_block": "Эксплуатация", "location": "Санкт-Петербург", "position": "Team Lead", "hire_date": "2025-11-11", "recruiter": "Смирнова А.А.", "department": "Mobile", "entry_date": "2025-05-07", "resume_link": "https://drive.google.com/file/84312", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "Data Platform, ML Pipeline, Mobile App", "candidate_status": "Забронирован", "funding_end_date": "2025-12-09", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:49.187417	2026-01-16 12:05:24.320533
274	Захаров Арсений Егорович	a.zakharov@rt.ru	{"grade": "Lead", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "3552", "skills": "Confluence, Budgeting, Risk Management, Kanban", "status": "На проекте", "project": "Единая биометрическая система", "comments": "", "contacts": "+7 (907) 437-76-60, @захарсе61, a.zakharov@rt.ru", "it_block": "Эксплуатация", "location": "Гибрид", "position": "Project Manager", "hire_date": "2018-10-10", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2025-09-15", "resume_link": "https://drive.google.com/file/20851", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2026-10-13", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "Banking App, Госуслуги 2.0, ML Pipeline", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-05-05", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:49.265716	2026-01-16 12:05:24.410638
71	Волков Максим Андреевич	nikita.solovyov55@company.ru	{"grade": "Principal", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1527", "skills": "Kotlin,Android", "status": "В отпуске", "project": "Performance", "comments": "В процессе согласования", "contacts": "+7 (900) 520-66-22, @волмакс29, nikita.solovyov55@company.ru", "it_block": "Развитие", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2019-04-20", "recruiter": "Белова И.Д.", "department": "Frontend", "entry_date": "2025-09-10", "resume_link": "https://drive.google.com/file/83058", "ck_department": "ЦК Аналитики", "transfer_date": "2026-08-01", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Госуслуги 2.0, Banking App, Data Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-05-16", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:27.492268	2026-01-16 12:05:24.532576
74	Семёнов Кирилл Сергеевич	anton.alexeev58@company.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "Ivanov A.S.", "salary": "2921", "skills": "Rust,WebAssembly", "status": "Болеет", "project": "Infrastructure", "comments": "", "contacts": "+7 (951) 803-63-93, @семкири78, anton.alexeev58@company.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "Middle Developer", "hire_date": "2020-07-17", "recruiter": "Новикова Е.П.", "department": "QA", "entry_date": "2024-01-06", "resume_link": "https://drive.google.com/file/91668", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "Infrastructure", "candidate_status": "Свободен", "funding_end_date": "2025-09-22", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 18:21:27.795975	2026-01-16 12:05:24.602535
88	Лебедев Дмитрий Алексеевич	vladimir.lebedev72@company.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "Novikova O.P.", "salary": "1731", "skills": "Ruby,Rails", "status": "На бенче", "project": "Data Pipeline", "comments": "", "contacts": "+7 (916) 235-66-13, @лебдмит48, vladimir.lebedev72@company.ru", "it_block": "Развитие", "location": "Удалённо", "position": "Team Lead", "hire_date": "2021-11-02", "recruiter": "Новикова Е.П.", "department": "Backend", "entry_date": "2024-06-02", "resume_link": "https://drive.google.com/file/92544", "ck_department": "ЦК Разработки", "transfer_date": "2026-05-30", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Infrastructure", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-12-15", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:29.328663	2026-01-16 12:05:24.714051
72	Алексеев Михаил Иванович	vladimir.korolev56@company.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "898", "skills": "AWS,Terraform", "status": "В отпуске", "project": "ML Platform", "comments": "", "contacts": "+7 (924) 800-60-74, @алемиха4, vladimir.korolev56@company.ru", "it_block": "Развитие", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2018-02-23", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2025-04-18", "resume_link": "https://drive.google.com/file/93265", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2026-09-27", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Infrastructure", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-04-23", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:27.593655	2026-01-16 12:05:24.821026
520	Тестов Юзер Первый	test1@test.ru	{"grade": "Senior", "status": "На проекте", "comments": "Изменено Юзером2, потом Юзером1", "position": "Senior Developer", "department": "Backend"}	2026-01-16 13:49:30.687109	2026-01-16 13:51:41.775367
110	Петров Алексей Александрович	matvey.sokolov94@company.ru	{"grade": "Principal", "mentor": "Novikova O.P.", "salary": "1564", "skills": "PostgreSQL,Redis", "status": "На бенче", "project": "Analytics Platform", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2023-11-02", "department": "Management"}	2026-01-15 18:21:31.707143	2026-01-15 18:21:31.707147
96	Соколов Егор Владимирович	matvey.alexandrov80@company.ru	{"grade": "Junior", "mentor": "", "salary": "1851", "skills": "Ruby,Rails", "status": "Болеет", "project": "", "location": "Санкт-Петербург", "position": "Team Lead", "hire_date": "2021-07-02", "department": "Management"}	2026-01-15 18:21:30.213162	2026-01-15 18:21:30.213167
278	Григорьева Елена Ярославовна	e.grigoreva@rt.ru	{"grade": "Principal", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "4914", "skills": "Team Leadership, Scrum, Agile, Jira", "status": "На проекте", "project": "Monitoring System", "comments": "Срочно нужен проект", "contacts": "+7 (985) 859-46-88, @гриелен26, e.grigoreva@rt.ru", "it_block": "Диджитал", "location": "Гибрид", "position": "Project Manager", "hire_date": "2024-03-27", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2024-06-04", "resume_link": "https://drive.google.com/file/43642", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "Banking App, Infrastructure", "candidate_status": "В работе", "funding_end_date": "2025-05-23", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:49.409915	2026-01-16 12:05:24.914993
281	Королева Юлия Константиновна	yu.koroleva@rt.ru	{"grade": "Lead", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "3697", "skills": "Data Visualization, Power BI, ETL, Clickhouse", "status": "На проекте", "project": "CRM Enterprise", "comments": "Срочно нужен проект", "contacts": "+7 (983) 378-36-34, @корюлия56, yu.koroleva@rt.ru", "it_block": "НУК", "location": "Гибрид", "position": "Analyst", "hire_date": "2024-10-15", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2024-11-15", "resume_link": "https://drive.google.com/file/41763", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "E-commerce Platform, ML Pipeline, Infrastructure", "candidate_status": "Забронирован", "funding_end_date": "2026-10-04", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:49.533881	2026-01-16 12:05:25.049947
284	Алексеев Арсений Олегович	a.alekseev@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Дмитриев Александр Евгеньевич", "salary": "1266", "skills": "Risk Management, Stakeholder Management, Jira, Team Leadership", "status": "В отпуске", "project": "", "comments": "", "contacts": "+7 (907) 730-30-17, @алеарсе5, a.alekseev@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Project Manager", "hire_date": "2024-11-26", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2025-05-26", "resume_link": "https://drive.google.com/file/39163", "ck_department": "ЦК Аналитики", "transfer_date": "2025-06-30", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Infrastructure, DevOps Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-09-23", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:49.658365	2026-01-16 12:05:25.161739
287	Захаров Константин Сергеевич	k.zakharov@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2468", "skills": "ETL, Statistics, A/B Testing, Data Visualization", "status": "На проекте", "project": "Analytics Dashboard", "comments": "", "contacts": "+7 (957) 905-88-98, @захконс29, k.zakharov@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Analyst", "hire_date": "2021-04-26", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2024-11-05", "resume_link": "https://drive.google.com/file/48767", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Data Platform, Госуслуги 2.0", "candidate_status": "Забронирован", "funding_end_date": "2025-02-01", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:49.794619	2026-01-16 12:05:25.26468
289	Григорьев Руслан Николаевич	r.grigorev@rt.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Ильин Иван Владимирович", "salary": "1004", "skills": "REST API, Spring Boot, Kubernetes, gRPC", "status": "На проекте", "project": "DevOps Platform", "comments": "", "contacts": "+7 (901) 994-18-72, @грирусл36, r.grigorev@rt.ru", "it_block": "B2O", "location": "Гибрид", "position": "Junior Developer", "hire_date": "2019-08-12", "recruiter": "Орлов М.С.", "department": "Backend", "entry_date": "2024-06-16", "resume_link": "https://drive.google.com/file/72602", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2026-12-18", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Data Platform, Госуслуги 2.0", "candidate_status": "Переведен", "funding_end_date": "2025-06-20", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:49.852757	2026-01-16 12:05:25.328585
70	Морозов Никита Александрович	konstantin.lebedev54@company.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "852", "skills": "Docker,Kubernetes", "status": "Болеет", "project": "", "comments": "", "contacts": "+7 (922) 938-83-59, @морники35, konstantin.lebedev54@company.ru", "it_block": "Прочее", "location": "Москва", "position": "Project Manager", "hire_date": "2019-12-21", "recruiter": "Орлов М.С.", "department": "Backend", "entry_date": "2025-01-28", "resume_link": "https://drive.google.com/file/28177", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2026-11-16", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "Mobile App", "candidate_status": "Переведен", "funding_end_date": "2026-08-13", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:27.393578	2026-01-16 12:05:25.43575
290	Максимова Наталья Александровна	n.maksimova@rt.ru	{"grade": "Junior", "mentor": "Киселева Любовь Ивановна", "salary": "852", "skills": "Kubernetes, Grafana, GitLab CI, Ansible", "status": "В отпуске", "project": "", "location": "Гибрид", "position": "DevOps Engineer", "hire_date": "2020-03-05", "department": "DevOps"}	2026-01-15 20:53:49.880616	2026-01-15 20:53:49.880644
291	Кузнецов Михаил Русланович	m.kuznetsov@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1527", "skills": "Excel, SQL, Data Visualization, A/B Testing", "status": "На проекте", "project": "API Gateway", "location": "Гибрид", "position": "Analyst", "hire_date": "2021-12-14", "department": "Analytics"}	2026-01-15 20:53:49.927878	2026-01-15 20:53:49.927904
292	Петров Андрей Павлович	a.petrov@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1804", "skills": "Selenium, TestNG, JMeter, Postman", "status": "На проекте", "project": "Service Mesh", "location": "Москва", "position": "QA Engineer", "hire_date": "2024-02-15", "department": "QA"}	2026-01-15 20:53:49.966198	2026-01-15 20:53:49.966229
293	Петров Андрей Павлович	a.petrov@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2472", "skills": "Agile, Confluence, Team Leadership, Stakeholder Management", "status": "На проекте", "project": "Analytics Dashboard", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2019-12-09", "department": "Management"}	2026-01-15 20:53:49.992374	2026-01-15 20:53:49.992399
294	Ковалев Глеб Степанович	g.kovalev@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3377", "skills": "Webpack, Redux, JavaScript, Next.js", "status": "На проекте", "project": "DataLake", "location": "Москва", "position": "Team Lead", "hire_date": "2024-09-10", "department": "Frontend"}	2026-01-15 20:53:50.026612	2026-01-15 20:53:50.026723
295	Полякова Светлана Тимуровна	s.polyakova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1710", "skills": "Kubernetes, gRPC, Spring Boot, Docker", "status": "Болеет", "project": "", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2021-12-04", "department": "Backend"}	2026-01-15 20:53:50.068623	2026-01-15 20:53:50.06865
296	Захаров Артём Олегович	a.zakharov@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3985", "skills": "Manual Testing, JMeter, Selenium, Automation", "status": "На бенче", "project": "", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2022-11-08", "department": "QA"}	2026-01-15 20:53:50.119562	2026-01-15 20:53:50.119588
297	Лебедева София Дмитриевна	s.lebedeva@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1367", "skills": "Flutter, Mobile CI/CD, iOS SDK, React Native", "status": "На проекте", "project": "DevOps Platform", "location": "Удалённо", "position": "Middle Developer", "hire_date": "2022-06-02", "department": "Mobile"}	2026-01-15 20:53:50.162092	2026-01-15 20:53:50.162117
102	Алексеев Михаил Иванович	arthur.ivanov86@company.ru	{"grade": "Junior", "mentor": "Ivanov A.S.", "salary": "2382", "skills": "Rust,WebAssembly", "status": "На бенче", "project": "Performance", "location": "Удалённо", "position": "Junior Developer", "hire_date": "2020-03-18", "department": "Frontend"}	2026-01-15 18:21:30.841486	2026-01-15 18:21:30.84149
108	Попов Артём Алексеевич	daniil.nikolaev92@company.ru	{"grade": "Lead", "mentor": "", "salary": "2496", "skills": "PHP,Laravel", "status": "На бенче", "project": "", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2024-10-25", "department": "Backend"}	2026-01-15 18:21:31.491489	2026-01-15 18:21:31.491494
91	Смирнов Илья Андреевич	yaroslav.stepanov75@company.ru	{"grade": "Middle", "mentor": "Kozlova E.A.", "salary": "2606", "skills": "Rust,WebAssembly", "status": "В отпуске", "project": "ML Platform", "location": "Удалённо", "position": "Analyst", "hire_date": "2021-02-23", "department": "Mobile"}	2026-01-15 18:21:29.659805	2026-01-15 18:21:29.659809
97	Михайлов Андрей Дмитриевич	anna.volkov81@company.ru	{"grade": "Junior", "mentor": "Kozlova E.A.", "salary": "1102", "skills": "Java,Spring", "status": "В отпуске", "project": "Admin Panel", "location": "Удалённо", "position": "Tech Lead", "hire_date": "2022-07-01", "department": "QA"}	2026-01-15 18:21:30.328879	2026-01-15 18:21:30.328883
92	Кузнецов Денис Иванович	maxim.kiselev76@company.ru	{"grade": "Middle", "mentor": "Novikova O.P.", "salary": "1270", "skills": "Go,gRPC", "status": "Болеет", "project": "Analytics Platform", "location": "Удалённо", "position": "Tech Lead", "hire_date": "2019-07-27", "department": "Frontend"}	2026-01-15 18:21:29.759901	2026-01-15 18:21:29.759905
93	Попов Артём Павлович	vladislav.yakovlev77@company.ru	{"grade": "Middle", "mentor": "Kozlova E.A.", "salary": "2612", "skills": "Kotlin,Android", "status": "Болеет", "project": "Infrastructure", "location": "Удалённо", "position": "Project Manager", "hire_date": "2019-04-20", "department": "DevOps"}	2026-01-15 18:21:29.895631	2026-01-15 18:21:29.895636
18	Попов Артём Алексеевич	ekaterina.petrov2@company.ru	{"grade": "Senior", "mentor": "Novikova O.P.", "salary": "2158", "skills": "Ruby,Rails", "status": "В отпуске", "project": "", "location": "Гибрид", "position": "Junior Developer", "hire_date": "2019-11-07", "department": "Analytics"}	2026-01-15 18:21:21.711351	2026-01-15 18:21:21.711358
21	Соколов Егор Андреевич	timofey.zakharov5@company.ru	{"grade": "Lead", "mentor": "", "salary": "2994", "skills": "PHP,Laravel", "status": "Болеет", "project": "Admin Panel", "location": "Гибрид", "position": "Tech Lead", "hire_date": "2024-08-27", "department": "Design"}	2026-01-15 18:21:22.010774	2026-01-15 18:21:22.01078
298	Зайцева Марина Михайловна	m.zaytseva@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1524", "skills": "Scrum, Jira, Team Leadership, Agile", "status": "На проекте", "project": "Техподдержка 3.0", "location": "Удалённо", "position": "Project Manager", "hire_date": "2019-03-07", "department": "Management"}	2026-01-15 20:53:50.20069	2026-01-15 20:53:50.200719
299	Поляков Иван Максимович	i.polyakov@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1609", "skills": "Grafana, Prometheus, Ansible, AWS", "status": "На бенче", "project": "", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2022-10-03", "department": "DevOps"}	2026-01-15 20:53:50.242663	2026-01-15 20:53:50.242691
300	Александров Глеб Ярославович	g.aleksandrov@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3363", "skills": "User Research, Design Systems, Adobe XD, Sketch", "status": "На проекте", "project": "RT Cloud", "location": "Москва", "position": "Designer", "hire_date": "2023-03-12", "department": "Design"}	2026-01-15 20:53:50.286511	2026-01-15 20:53:50.286538
301	Сергеева Мария Александровна	m.sergeeva@rt.ru	{"grade": "Principal", "mentor": "", "salary": "5044", "skills": "Linux, Grafana, Terraform, AWS", "status": "На проекте", "project": "Умный дом Ростелеком", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2019-10-20", "department": "DevOps"}	2026-01-15 20:53:50.319915	2026-01-15 20:53:50.319935
302	Макаров Роман Игоревич	r.makarov@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2630", "skills": "Confluence, Jira, Team Leadership, Agile", "status": "На бенче", "project": "", "location": "Москва", "position": "Project Manager", "hire_date": "2020-03-06", "department": "Management"}	2026-01-15 20:53:50.345815	2026-01-15 20:53:50.345898
303	Федоров Константин Владимирович	k.fedorov@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2939", "skills": "Docker, Terraform, Linux, Ansible", "status": "На проекте", "project": "RT Cloud", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2016-01-30", "department": "DevOps"}	2026-01-15 20:53:50.385675	2026-01-15 20:53:50.385708
304	Степанова Виктория Андреевна	v.stepanova@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3957", "skills": "Docker, Linux, Prometheus, GitLab CI", "status": "На проекте", "project": "Единая биометрическая система", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2024-04-20", "department": "DevOps"}	2026-01-15 20:53:50.423564	2026-01-15 20:53:50.423591
305	Попов Роман Павлович	r.popov@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2878", "skills": "Risk Management, Team Leadership, Budgeting, Agile", "status": "На проекте", "project": "Умный дом Ростелеком", "location": "Москва", "position": "Project Manager", "hire_date": "2024-02-09", "department": "Management"}	2026-01-15 20:53:50.455985	2026-01-15 20:53:50.456012
306	Воробьев Андрей Маркович	a.vorobev@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1855", "skills": "Stakeholder Management, Jira, Confluence, Risk Management", "status": "На бенче", "project": "", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2025-10-04", "department": "Management"}	2026-01-15 20:53:50.486573	2026-01-15 20:53:50.4866
307	Гусев Иван Евгеньевич	i.gusev@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1517", "skills": "Android SDK, Kotlin, Firebase, Flutter", "status": "На проекте", "project": "Цифровой офис", "location": "Москва", "position": "Middle Developer", "hire_date": "2020-11-29", "department": "Mobile"}	2026-01-15 20:53:50.514919	2026-01-15 20:53:50.514947
308	Королев Вадим Александрович	v.korolev@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1588", "skills": "Design Systems, User Research, Sketch, UI/UX", "status": "На проекте", "project": "Единая биометрическая система", "location": "Москва", "position": "Designer", "hire_date": "2024-01-12", "department": "Design"}	2026-01-15 20:53:50.553948	2026-01-15 20:53:50.553976
309	Никитина Татьяна Ильинична	t.nikitina@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3526", "skills": "Selenium, Manual Testing, Automation, JMeter", "status": "На проекте", "project": "API Gateway", "location": "Москва", "position": "QA Engineer", "hire_date": "2016-11-16", "department": "QA"}	2026-01-15 20:53:50.59063	2026-01-15 20:53:50.590663
310	Романова Наталья Дмитриевна	n.romanova@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2456", "skills": "ETL, Power BI, Clickhouse, Statistics", "status": "На проекте", "project": "Единая биометрическая система", "location": "Гибрид", "position": "Analyst", "hire_date": "2019-04-30", "department": "Analytics"}	2026-01-15 20:53:50.632902	2026-01-15 20:53:50.632943
311	Борисова Полина Максимовна	p.borisova@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2428", "skills": "JavaScript, HTML/CSS, Redux, React", "status": "На бенче", "project": "", "location": "Москва", "position": "Senior Developer", "hire_date": "2021-06-26", "department": "Frontend"}	2026-01-15 20:53:50.665342	2026-01-15 20:53:50.665487
95	Петров Алексей Михайлович	maxim.yakovlev79@company.ru	{"grade": "Senior", "mentor": "Novikova O.P.", "salary": "2453", "skills": "Go,gRPC", "status": "В отпуске", "project": "ML Platform", "location": "Гибрид", "position": "Tech Lead", "hire_date": "2024-09-04", "department": "Mobile"}	2026-01-15 18:21:30.115626	2026-01-15 18:21:30.11563
118	Лебедев Дмитрий Алексеевич	arthur.makarov102@company.ru	{"grade": "Lead", "hr_bp": "Морозов К.А.", "mentor": "Ivanov A.S.", "salary": "1491", "skills": "TypeScript,Vue", "status": "На бенче", "project": "Mobile App", "comments": "В процессе согласования", "contacts": "+7 (901) 846-87-47, @лебдмит77, arthur.makarov102@company.ru", "it_block": "Эксплуатация", "location": "Санкт-Петербург", "position": "Designer", "hire_date": "2019-09-24", "recruiter": "Смирнова А.А.", "department": "Frontend", "entry_date": "2024-05-03", "resume_link": "https://drive.google.com/file/41445", "ck_department": "Департамент данных", "transfer_date": "2025-09-27", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "ML Pipeline, Госуслуги 2.0", "candidate_status": "Переведен", "funding_end_date": "2025-04-29", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:32.621818	2026-01-16 12:05:25.604205
312	Киселева Светлана Александровна	s.kiseleva@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "954", "skills": "JavaScript, HTML/CSS, Webpack, Next.js", "status": "На проекте", "project": "API Gateway", "comments": "Срочно нужен проект", "contacts": "+7 (963) 220-95-41, @киссвет21, s.kiseleva@rt.ru", "it_block": "Диджитал", "location": "Москва", "position": "Junior Developer", "hire_date": "2024-02-06", "recruiter": "Смирнова А.А.", "department": "Frontend", "entry_date": "2025-11-12", "resume_link": "https://drive.google.com/file/75205", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Госуслуги 2.0, Mobile App, Infrastructure", "candidate_status": "Свободен", "funding_end_date": "2025-12-21", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:50.690263	2026-01-16 12:05:25.715053
317	Белов Юрий Никитич	yu.belov@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2417", "skills": "Sketch, Figma, Adobe XD, User Research", "status": "На проекте", "project": "Service Mesh", "comments": "Ожидает оффер", "contacts": "+7 (949) 394-57-32, @белюрий20, yu.belov@rt.ru", "it_block": "Развитие", "location": "Санкт-Петербург", "position": "Designer", "hire_date": "2022-10-27", "recruiter": "Смирнова А.А.", "department": "Design", "entry_date": "2025-12-02", "resume_link": "https://drive.google.com/file/97086", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "перевод", "current_manager": "Иванов А.П.", "target_projects": "ML Pipeline, Banking App, Data Platform", "candidate_status": "В работе", "funding_end_date": "2025-01-04", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:50.886359	2026-01-16 12:05:25.871548
320	Попова Любовь Максимовна	l.popova@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1335", "skills": "Node.js, HTML/CSS, React, GraphQL", "status": "На бенче", "project": "", "comments": "В процессе согласования", "contacts": "+7 (987) 923-72-23, @поплюбо42, l.popova@rt.ru", "it_block": "НУК", "location": "Санкт-Петербург", "position": "Middle Developer", "hire_date": "2025-07-09", "recruiter": "Новикова Е.П.", "department": "Frontend", "entry_date": "2025-06-07", "resume_link": "https://drive.google.com/file/53573", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "Госуслуги 2.0", "candidate_status": "В работе", "funding_end_date": "2025-05-24", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:50.985561	2026-01-16 12:05:25.968935
323	Сергеева Ольга Марковна	o.sergeeva@rt.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2896", "skills": "Manual Testing, Allure, JUnit, Automation", "status": "На проекте", "project": "5G инфраструктура", "comments": "", "contacts": "+7 (944) 797-31-21, @серольг67, o.sergeeva@rt.ru", "it_block": "НУК", "location": "Гибрид", "position": "QA Engineer", "hire_date": "2017-09-04", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2025-10-18", "resume_link": "https://drive.google.com/file/10524", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Data Platform", "candidate_status": "Свободен", "funding_end_date": "2025-02-03", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:51.128301	2026-01-16 12:05:26.081905
325	Зайцева Татьяна Романовна	t.zaytseva@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Николаева Галина Степановна", "salary": "1245", "skills": "SQL, Data Visualization, Power BI, Excel", "status": "На проекте", "project": "Service Mesh", "comments": "", "contacts": "+7 (952) 256-32-65, @зайтать23, t.zaytseva@rt.ru", "it_block": "Диджитал", "location": "Удалённо", "position": "Analyst", "hire_date": "2019-06-29", "recruiter": "Орлов М.С.", "department": "Analytics", "entry_date": "2024-01-22", "resume_link": "https://drive.google.com/file/52527", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "E-commerce Platform, Mobile App, DevOps Platform", "candidate_status": "Забронирован", "funding_end_date": "2026-06-23", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:51.208768	2026-01-16 12:05:26.180603
123	Попов Артём Павлович	mikhail.mikhailov107@company.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "Sidorov K.V.", "salary": "1271", "skills": "TypeScript,Vue", "status": "В отпуске", "project": "", "comments": "В процессе согласования", "contacts": "+7 (965) 975-28-21, @попартё80, mikhail.mikhailov107@company.ru", "it_block": "Эксплуатация", "location": "Удалённо", "position": "Designer", "hire_date": "2021-03-09", "recruiter": "Смирнова А.А.", "department": "Frontend", "entry_date": "2025-05-19", "resume_link": "https://drive.google.com/file/51024", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "Infrastructure, Banking App, Data Platform", "candidate_status": "Свободен", "funding_end_date": "2026-07-02", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:33.139001	2026-01-16 12:05:26.3092
326	Белов Владимир Артёмович	v.belov@rt.ru	{"grade": "Lead", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "3619", "skills": "Scrum, Risk Management, Jira, Budgeting", "status": "В отпуске", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (985) 694-29-67, @белвлад89, v.belov@rt.ru", "it_block": "Прочее", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2024-01-11", "recruiter": "Новикова Е.П.", "department": "Management", "entry_date": "2025-07-26", "resume_link": "https://drive.google.com/file/42968", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "Data Platform", "candidate_status": "В работе", "funding_end_date": "2026-08-18", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.257346	2026-01-16 12:05:26.409451
115	Морозов Никита Михайлович	egor.fedorov99@company.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Sidorov K.V.", "salary": "2503", "skills": "TypeScript,Vue", "status": "В отпуске", "project": "Refactoring", "comments": "", "contacts": "+7 (929) 841-10-78, @морники61, egor.fedorov99@company.ru", "it_block": "B2O", "location": "Москва", "position": "Tech Lead", "hire_date": "2018-02-16", "recruiter": "Смирнова А.А.", "department": "Design", "entry_date": "2025-01-17", "resume_link": "https://drive.google.com/file/73823", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "E-commerce Platform", "candidate_status": "Свободен", "funding_end_date": "2026-04-13", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:32.292062	2026-01-16 12:05:26.62131
138	Попов Артём Алексеевич	artem.vorobyov122@company.ru	{"grade": "Principal", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2120", "skills": "Ruby,Rails", "status": "На бенче", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (981) 183-39-29, @попартё13, artem.vorobyov122@company.ru", "it_block": "Прочее", "location": "Санкт-Петербург", "position": "Team Lead", "hire_date": "2022-02-14", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2024-11-20", "resume_link": "https://drive.google.com/file/68098", "ck_department": "ЦК Аналитики", "transfer_date": "2025-08-27", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Госуслуги 2.0, DevOps Platform", "candidate_status": "Переведен", "funding_end_date": "2025-02-13", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 18:21:34.735829	2026-01-16 12:05:26.732184
331	Соколов Арсений Дмитриевич	a.sokolov@rt.ru	{"grade": "Principal", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "4884", "skills": "Statistics, SQL, Python, ETL", "status": "На проекте", "project": "Цифровой офис", "comments": "", "contacts": "+7 (958) 860-61-98, @сокарсе12, a.sokolov@rt.ru", "it_block": "Развитие", "location": "Москва", "position": "Analyst", "hire_date": "2025-10-28", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2024-02-19", "resume_link": "https://drive.google.com/file/65294", "ck_department": "ЦК Аналитики", "transfer_date": "2026-06-21", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Mobile App", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-11-01", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:51.504414	2026-01-16 12:05:26.843525
333	Алексеева Марина Максимовна	m.alekseeva@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2754", "skills": "Jenkins, Terraform, Prometheus, Ansible", "status": "На проекте", "project": "Госуслуги 2.0", "comments": "Ожидает оффер", "contacts": "+7 (988) 537-61-56, @алемари56, m.alekseeva@rt.ru", "it_block": "НУК", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2022-09-20", "recruiter": "Белова И.Д.", "department": "DevOps", "entry_date": "2025-12-10", "resume_link": "https://drive.google.com/file/71472", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "E-commerce Platform, Mobile App", "candidate_status": "Свободен", "funding_end_date": "2025-03-10", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.571496	2026-01-16 12:05:26.927162
335	Федоров Даниил Иванович	d.fedorov@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "888", "skills": "Redux, Vue.js, HTML/CSS, TypeScript", "status": "На проекте", "project": "RT Cloud", "comments": "Ожидает оффер", "contacts": "+7 (994) 989-93-76, @феддани36, d.fedorov@rt.ru", "it_block": "Прочее", "location": "Санкт-Петербург", "position": "Junior Developer", "hire_date": "2017-04-23", "recruiter": "Белова И.Д.", "department": "Frontend", "entry_date": "2025-12-11", "resume_link": "https://drive.google.com/file/28594", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Banking App, Госуслуги 2.0, Infrastructure", "candidate_status": "В работе", "funding_end_date": "2025-04-14", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.622503	2026-01-16 12:05:26.981132
338	Михайлова Александра Андреевна	a.mikhaylova@rt.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2533", "skills": "Webpack, Redux, TypeScript, Next.js", "status": "На проекте", "project": "IoT платформа", "comments": "", "contacts": "+7 (946) 540-22-53, @михалек74, a.mikhaylova@rt.ru", "it_block": "НУК", "location": "Гибрид", "position": "Senior Developer", "hire_date": "2024-12-06", "recruiter": "Новикова Е.П.", "department": "Frontend", "entry_date": "2024-06-22", "resume_link": "https://drive.google.com/file/83024", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2026-10-17", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "ML Pipeline, E-commerce Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-08-03", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:51.735736	2026-01-16 12:05:27.07441
341	Зайцева Ксения Евгеньевна	k.zaytseva@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Сергеев Александр Олегович", "salary": "794", "skills": "Adobe XD, Figma, Design Systems, Wireframing", "status": "На бенче", "project": "", "comments": "", "contacts": "+7 (997) 460-94-12, @зайксен84, k.zaytseva@rt.ru", "it_block": "B2O", "location": "Гибрид", "position": "Designer", "hire_date": "2017-09-22", "recruiter": "Белова И.Д.", "department": "Design", "entry_date": "2024-12-11", "resume_link": "https://drive.google.com/file/48365", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-08-15", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Mobile App, Infrastructure", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-06-24", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.860741	2026-01-16 12:05:27.204813
345	Кузьмин Константин Игоревич	k.kuzmin@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1773", "skills": "GraphQL, Webpack, Vue.js, Next.js", "status": "На бенче", "project": "", "location": "Удалённо", "position": "Middle Developer", "hire_date": "2017-10-07", "department": "Frontend"}	2026-01-15 20:53:52.028066	2026-01-15 20:53:52.028087
156	Соколов Егор Владимирович	kirill.solovyov140@company.ru	{"grade": "Senior", "mentor": "Novikova O.P.", "salary": "2312", "skills": "Docker,Kubernetes", "status": "В отпуске", "project": "", "location": "Санкт-Петербург", "position": "Team Lead", "hire_date": "2020-09-18", "department": "Design"}	2026-01-15 18:21:36.620123	2026-01-15 18:21:36.620127
346	Антонова Валерия Вадимовна	v.antonova@rt.ru	{"grade": "Junior", "mentor": "Максимов Андрей Евгеньевич", "salary": "1254", "skills": "Webpack, Node.js, GraphQL, HTML/CSS", "status": "На проекте", "project": "Monitoring System", "location": "Удалённо", "position": "Junior Developer", "hire_date": "2020-05-02", "department": "Frontend"}	2026-01-15 20:53:52.058893	2026-01-15 20:53:52.058901
151	Смирнов Илья Андреевич	nikita.orlov135@company.ru	{"grade": "Lead", "mentor": "", "salary": "2086", "skills": "TypeScript,Vue", "status": "Болеет", "project": "CRM System", "location": "Санкт-Петербург", "position": "Tech Lead", "hire_date": "2022-05-27", "department": "Design"}	2026-01-15 18:21:36.119687	2026-01-15 18:21:36.119691
154	Васильев Иван Сергеевич	arseny.kuznetsov138@company.ru	{"grade": "Lead", "mentor": "Ivanov A.S.", "salary": "957", "skills": "TypeScript,Vue", "status": "Болеет", "project": "Analytics Platform", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2022-05-26", "department": "QA"}	2026-01-15 18:21:36.42343	2026-01-15 18:21:36.423434
347	Захарова Татьяна Николаевна	t.zakharova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1314", "skills": "React Native, Kotlin, Mobile CI/CD, Android SDK", "status": "На проекте", "project": "DataLake", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2023-02-05", "department": "Mobile"}	2026-01-15 20:53:52.100546	2026-01-15 20:53:52.100553
141	Соколов Егор Андреевич	elena.pavlov125@company.ru	{"grade": "Senior", "mentor": "Ivanov A.S.", "salary": "1403", "skills": "Kotlin,Android", "status": "На бенче", "project": "Performance", "location": "Удалённо", "position": "Team Lead", "hire_date": "2019-07-02", "department": "Management"}	2026-01-15 18:21:35.054137	2026-01-15 18:21:35.054141
146	Волков Максим Владимирович	ivan.novikov130@company.ru	{"grade": "Principal", "mentor": "Novikova O.P.", "salary": "908", "skills": "Node.js,Express", "status": "В отпуске", "project": "Security Audit", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2022-09-07", "department": "Design"}	2026-01-15 18:21:35.609447	2026-01-15 18:21:35.609451
153	Попов Артём Павлович	olga.yakovlev137@company.ru	{"grade": "Middle", "mentor": "Sidorov K.V.", "salary": "1485", "skills": "Swift,iOS", "status": "В отпуске", "project": "API Gateway", "location": "Удалённо", "position": "Tech Lead", "hire_date": "2019-10-18", "department": "QA"}	2026-01-15 18:21:36.326431	2026-01-15 18:21:36.326435
348	Ильина Евгения Павловна	e.ilina@rt.ru	{"grade": "Principal", "mentor": "", "salary": "5443", "skills": "Spring Boot, Java, gRPC, Redis", "status": "В отпуске", "project": "", "location": "Санкт-Петербург", "position": "Tech Lead", "hire_date": "2020-04-17", "department": "Backend"}	2026-01-15 20:53:52.125965	2026-01-15 20:53:52.125973
139	Васильев Иван Евгеньевич	grigory.stepanov123@company.ru	{"grade": "Principal", "mentor": "", "salary": "935", "skills": "Docker,Kubernetes", "status": "Болеет", "project": "Analytics Platform", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2022-02-26", "department": "QA"}	2026-01-15 18:21:34.841407	2026-01-15 18:21:34.841411
349	Белов Михаил Денисович	m.belov@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1841", "skills": "Statistics, Data Visualization, Python, Tableau", "status": "На проекте", "project": "AI Contact Center", "location": "Санкт-Петербург", "position": "Analyst", "hire_date": "2018-04-02", "department": "Analytics"}	2026-01-15 20:53:52.15	2026-01-15 20:53:52.150006
155	Петров Алексей Михайлович	sergey.frolov139@company.ru	{"grade": "Middle", "mentor": "Sidorov K.V.", "salary": "835", "skills": "Ruby,Rails", "status": "Болеет", "project": "", "location": "Удалённо", "position": "Designer", "hire_date": "2024-06-25", "department": "Frontend"}	2026-01-15 18:21:36.523459	2026-01-15 18:21:36.523463
140	Петров Алексей Александрович	anton.alexandrov124@company.ru	{"grade": "Lead", "mentor": "", "salary": "2180", "skills": "Docker,Kubernetes", "status": "На бенче", "project": "Infrastructure", "location": "Гибрид", "position": "Senior Developer", "hire_date": "2023-04-17", "department": "Frontend"}	2026-01-15 18:21:34.957176	2026-01-15 18:21:34.95718
142	Михайлов Андрей Иванович	roman.andreev126@company.ru	{"grade": "Senior", "mentor": "Kozlova E.A.", "salary": "801", "skills": "C#,.NET", "status": "Болеет", "project": "", "location": "Гибрид", "position": "DevOps Engineer", "hire_date": "2022-12-09", "department": "Backend"}	2026-01-15 18:21:35.158692	2026-01-15 18:21:35.158696
350	Яковлева Любовь Владимировна	l.yakovleva@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3473", "skills": "Excel, Clickhouse, Python, Power BI", "status": "На проекте", "project": "Monitoring System", "location": "Москва", "position": "Analyst", "hire_date": "2021-08-30", "department": "Analytics"}	2026-01-15 20:53:52.202295	2026-01-15 20:53:52.202302
351	Яковлев Тимур Константинович	t.yakovlev@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1655", "skills": "Microservices, Docker, Kafka, Kubernetes", "status": "На проекте", "project": "Видеонаблюдение", "location": "Москва", "position": "Middle Developer", "hire_date": "2022-09-06", "department": "Backend"}	2026-01-15 20:53:52.264427	2026-01-15 20:53:52.264434
157	Михайлов Андрей Дмитриевич	arseny.volkov141@company.ru	{"grade": "Middle", "mentor": "Sidorov K.V.", "salary": "1289", "skills": "C#,.NET", "status": "Болеет", "project": "Analytics Platform", "location": "Гибрид", "position": "Senior Developer", "hire_date": "2024-11-04", "department": "Frontend"}	2026-01-15 18:21:36.724651	2026-01-15 18:21:36.724654
145	Морозов Никита Михайлович	danil.pavlov129@company.ru	{"grade": "Principal", "mentor": "Petrov M.I.", "salary": "1117", "skills": "Node.js,Express", "status": "На бенче", "project": "", "location": "Москва", "position": "QA Engineer", "hire_date": "2022-05-03", "department": "Mobile"}	2026-01-15 18:21:35.509216	2026-01-15 18:21:35.50922
352	Петрова Виктория Андреевна	v.petrova@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2708", "skills": "Kanban, Confluence, Jira, Agile", "status": "На проекте", "project": "Госуслуги 2.0", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2016-07-13", "department": "Management"}	2026-01-15 20:53:52.302115	2026-01-15 20:53:52.30212
353	Смирнов Арсений Николаевич	a.smirnov@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2589", "skills": "Team Leadership, Confluence, Kanban, Budgeting", "status": "На проекте", "project": "Видеонаблюдение", "location": "Удалённо", "position": "Project Manager", "hire_date": "2021-07-11", "department": "Management"}	2026-01-15 20:53:52.334549	2026-01-15 20:53:52.334569
158	Новиков Роман Алексеевич	yaroslav.fedorov142@company.ru	{"grade": "Principal", "mentor": "", "salary": "1195", "skills": "Kotlin,Android", "status": "В отпуске", "project": "", "location": "Москва", "position": "Project Manager", "hire_date": "2021-06-14", "department": "QA"}	2026-01-15 18:21:36.841353	2026-01-15 18:21:36.841357
162	Алексеев Михаил Иванович	julia.korolev146@company.ru	{"grade": "Principal", "mentor": "", "salary": "1741", "skills": "Ruby,Rails", "status": "На бенче", "project": "Analytics Platform", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2024-02-13", "department": "DevOps"}	2026-01-15 18:21:37.254296	2026-01-15 18:21:37.2543
354	Петрова Татьяна Павловна	t.petrova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1640", "skills": "Selenium, Allure, JMeter, TestNG", "status": "На проекте", "project": "RT Cloud", "location": "Москва", "position": "QA Engineer", "hire_date": "2020-09-29", "department": "QA"}	2026-01-15 20:53:52.364883	2026-01-15 20:53:52.364891
169	Васильев Иван Евгеньевич	ruslan.kuznetsov153@company.ru	{"grade": "Lead", "mentor": "Kozlova E.A.", "salary": "2011", "skills": "C#,.NET", "status": "На бенче", "project": "Performance", "location": "Санкт-Петербург", "position": "Team Lead", "hire_date": "2020-01-06", "department": "Mobile"}	2026-01-15 18:21:38.051266	2026-01-15 18:21:38.05127
171	Соколов Егор Андреевич	evgeny.fedorov155@company.ru	{"grade": "Middle", "mentor": "Novikova O.P.", "salary": "1325", "skills": "AWS,Terraform", "status": "Болеет", "project": "ML Platform", "location": "Удалённо", "position": "Team Lead", "hire_date": "2023-08-20", "department": "DevOps"}	2026-01-15 18:21:38.258242	2026-01-15 18:21:38.258246
179	Семёнов Кирилл Евгеньевич	vadim.dmitriev163@company.ru	{"grade": "Lead", "mentor": "Ivanov A.S.", "salary": "2512", "skills": "Node.js,Express", "status": "Болеет", "project": "Admin Panel", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2019-12-12", "department": "Analytics"}	2026-01-15 18:21:39.140287	2026-01-15 18:21:39.140291
355	Петров Юрий Дмитриевич	yu.petrov@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1521", "skills": "Team Leadership, Jira, Budgeting, Kanban", "status": "На проекте", "project": "AI Contact Center", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2016-09-25", "department": "Management"}	2026-01-15 20:53:52.402447	2026-01-15 20:53:52.402454
356	Дмитриев Юрий Иванович	yu.dmitriev@rt.ru	{"grade": "Principal", "mentor": "", "salary": "5258", "skills": "Docker, REST API, Kubernetes, PostgreSQL", "status": "На проекте", "project": "Госуслуги 2.0", "location": "Москва", "position": "Tech Lead", "hire_date": "2016-05-26", "department": "Backend"}	2026-01-15 20:53:52.436139	2026-01-15 20:53:52.436152
357	Яковлев Савелий Игоревич	s.yakovlev@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1909", "skills": "TypeScript, React, Webpack, HTML/CSS", "status": "На проекте", "project": "AI Contact Center", "location": "Удалённо", "position": "Middle Developer", "hire_date": "2022-04-07", "department": "Frontend"}	2026-01-15 20:53:52.476668	2026-01-15 20:53:52.476674
358	Борисов Максим Павлович	m.borisov@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1777", "skills": "Kubernetes, Microservices, Docker, PostgreSQL", "status": "На бенче", "project": "", "location": "Москва", "position": "Middle Developer", "hire_date": "2016-07-25", "department": "Backend"}	2026-01-15 20:53:52.510382	2026-01-15 20:53:52.510388
359	Ильина Ольга Владимировна	o.ilina@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2631", "skills": "Prometheus, AWS, Terraform, Jenkins", "status": "На проекте", "project": "Техподдержка 3.0", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2019-04-08", "department": "DevOps"}	2026-01-15 20:53:52.545848	2026-01-15 20:53:52.545855
360	Гусева Анастасия Артёмовна	a.guseva@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2918", "skills": "Android SDK, Swift, Firebase, Kotlin", "status": "На проекте", "project": "B2B личный кабинет", "location": "Москва", "position": "Senior Developer", "hire_date": "2019-09-01", "department": "Mobile"}	2026-01-15 20:53:52.577066	2026-01-15 20:53:52.577072
361	Воробьев Артём Маркович	a.vorobev@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1508", "skills": "TypeScript, React, Redux, JavaScript", "status": "На проекте", "project": "Цифровой офис", "location": "Москва", "position": "Middle Developer", "hire_date": "2019-03-31", "department": "Frontend"}	2026-01-15 20:53:52.608778	2026-01-15 20:53:52.608783
362	Козлова Светлана Ивановна	s.kozlova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1554", "skills": "Next.js, GraphQL, Webpack, Redux", "status": "На проекте", "project": "Цифровой офис", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2025-04-09", "department": "Frontend"}	2026-01-15 20:53:52.637876	2026-01-15 20:53:52.637881
366	Соколов Сергей Вадимович	s.sokolov@rt.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Попов Михаил Степанович", "salary": "1134", "skills": "React Native, iOS SDK, Mobile CI/CD, Firebase", "status": "На проекте", "project": "DataLake", "comments": "Ожидает оффер", "contacts": "+7 (918) 665-35-18, @соксерг94, s.sokolov@rt.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "Junior Developer", "hire_date": "2020-01-26", "recruiter": "Орлов М.С.", "department": "Mobile", "entry_date": "2025-01-17", "resume_link": "https://drive.google.com/file/82333", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "E-commerce Platform, Banking App", "candidate_status": "Свободен", "funding_end_date": "2025-09-27", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:52.76305	2026-01-16 12:05:27.56887
368	Киселев Сергей Андреевич	s.kiselev@rt.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2707", "skills": "Linux, Grafana, Kubernetes, Prometheus", "status": "В отпуске", "project": "", "comments": "", "contacts": "+7 (977) 520-40-49, @киссерг74, s.kiselev@rt.ru", "it_block": "B2O", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2025-01-19", "recruiter": "Новикова Е.П.", "department": "DevOps", "entry_date": "2025-06-26", "resume_link": "https://drive.google.com/file/93793", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "Mobile App, ML Pipeline", "candidate_status": "В работе", "funding_end_date": "2025-06-16", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:52.825592	2026-01-16 12:05:27.646309
371	Королева Анна Денисовна	a.koroleva@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2966", "skills": "Redis, PostgreSQL, Java, REST API", "status": "На проекте", "project": "Техподдержка 3.0", "comments": "Ожидает оффер", "contacts": "+7 (912) 564-62-88, @коранна4, a.koroleva@rt.ru", "it_block": "НУК", "location": "Удалённо", "position": "Senior Developer", "hire_date": "2024-03-25", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2025-07-29", "resume_link": "https://drive.google.com/file/99950", "ck_department": "Департамент данных", "transfer_date": "2025-03-17", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-01-14", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:52.912497	2026-01-16 12:05:27.775016
373	Никитин Марк Ярославович	m.nikitin@rt.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2662", "skills": "Allure, JUnit, Manual Testing, Performance Testing", "status": "В отпуске", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (939) 461-48-49, @никмарк66, m.nikitin@rt.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2019-03-15", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2024-08-28", "resume_link": "https://drive.google.com/file/87813", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-03-15", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "E-commerce Platform, Госуслуги 2.0, Banking App", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-02-21", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:52.96953	2026-01-16 12:05:27.855322
376	Кузнецов Юрий Никитич	yu.kuznetsov@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2741", "skills": "Firebase, Kotlin, Swift, Flutter", "status": "На проекте", "project": "Billing System", "comments": "", "contacts": "+7 (936) 520-21-52, @кузюрий80, yu.kuznetsov@rt.ru", "it_block": "Развитие", "location": "Удалённо", "position": "Senior Developer", "hire_date": "2022-09-06", "recruiter": "Смирнова А.А.", "department": "Mobile", "entry_date": "2024-06-06", "resume_link": "https://drive.google.com/file/63207", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline", "candidate_status": "Забронирован", "funding_end_date": "2026-05-06", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:53.103663	2026-01-16 12:05:27.993324
379	Михайлов Арсений Вадимович	a.mikhaylov@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1687", "skills": "Kafka, Microservices, Spring Boot, Java", "status": "На бенче", "project": "", "comments": "В процессе согласования", "contacts": "+7 (987) 975-94-86, @михарсе66, a.mikhaylov@rt.ru", "it_block": "Развитие", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2022-02-02", "recruiter": "Новикова Е.П.", "department": "Backend", "entry_date": "2024-11-01", "resume_link": "https://drive.google.com/file/20294", "ck_department": "ЦК Разработки", "transfer_date": "2026-04-07", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "ML Pipeline, Госуслуги 2.0, Data Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-09-28", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:53.241732	2026-01-16 12:05:28.095772
381	Кузьмин Тимофей Евгеньевич	t.kuzmin@rt.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Кузьмин Артур Денисович", "salary": "1281", "skills": "Allure, Postman, TestNG, Automation", "status": "На проекте", "project": "Умный дом Ростелеком", "comments": "", "contacts": "+7 (986) 997-63-69, @кузтимо28, t.kuzmin@rt.ru", "it_block": "Диджитал", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2018-02-18", "recruiter": "Новикова Е.П.", "department": "QA", "entry_date": "2025-03-24", "resume_link": "https://drive.google.com/file/30838", "ck_department": "ЦК Аналитики", "transfer_date": "2025-12-11", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "Госуслуги 2.0", "candidate_status": "Переведен", "funding_end_date": "2026-04-24", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:53.305758	2026-01-16 12:05:28.161889
385	Захарова Светлана Антоновна	s.zakharova@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Сорокин Денис Олегович", "salary": "755", "skills": "Grafana, Linux, Docker, Jenkins", "status": "Болеет", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (925) 841-93-85, @захсвет53, s.zakharova@rt.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2018-03-26", "recruiter": "Смирнова А.А.", "department": "DevOps", "entry_date": "2025-05-15", "resume_link": "https://drive.google.com/file/76272", "ck_department": "Департамент данных", "transfer_date": "2025-06-24", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Госуслуги 2.0, E-commerce Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-12-02", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:53.494912	2026-01-16 12:05:28.29937
388	Ковалев Владислав Никитич	v.kovalev@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1605", "skills": "Adobe XD, Design Systems, Sketch, Prototyping", "status": "На бенче", "project": "", "comments": "", "contacts": "+7 (976) 411-20-46, @коввлад85, v.kovalev@rt.ru", "it_block": "НУК", "location": "Москва", "position": "Designer", "hire_date": "2020-09-16", "recruiter": "Смирнова А.А.", "department": "Design", "entry_date": "2025-02-05", "resume_link": "https://drive.google.com/file/93872", "ck_department": "Департамент данных", "transfer_date": "2025-10-13", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "Mobile App, DevOps Platform", "candidate_status": "Переведен", "funding_end_date": "2025-05-29", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:53.612077	2026-01-16 12:05:28.400375
390	Антонов Матвей Тимурович	m.antonov@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1381", "skills": "Agile, Kanban, Budgeting, Scrum", "status": "На проекте", "project": "Партнерский портал", "comments": "Срочно нужен проект", "contacts": "+7 (930) 757-11-98, @антматв50, m.antonov@rt.ru", "it_block": "Эксплуатация", "location": "Удалённо", "position": "Project Manager", "hire_date": "2016-06-24", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2024-12-29", "resume_link": "https://drive.google.com/file/28859", "ck_department": "ЦК Разработки", "transfer_date": "2026-06-25", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "Banking App", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-10-31", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:53.683609	2026-01-16 12:05:28.479889
166	Смирнов Илья Владимирович	sergey.smirnov150@company.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1971", "skills": "Swift,iOS", "status": "Болеет", "project": "API Gateway", "comments": "", "contacts": "+7 (919) 110-80-36, @смиилья87, sergey.smirnov150@company.ru", "it_block": "B2O", "location": "Гибрид", "position": "QA Engineer", "hire_date": "2020-08-16", "recruiter": "Новикова Е.П.", "department": "Frontend", "entry_date": "2024-03-30", "resume_link": "https://drive.google.com/file/10636", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "DevOps Platform", "candidate_status": "Свободен", "funding_end_date": "2026-03-22", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 18:21:37.708759	2026-01-16 12:05:28.589869
165	Иванов Александр Михайлович	svetlana.kuznetsov149@company.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2356", "skills": "Go,gRPC", "status": "На бенче", "project": "ML Platform", "comments": "", "contacts": "+7 (967) 481-71-34, @иваалек1, svetlana.kuznetsov149@company.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "QA Engineer", "hire_date": "2024-04-15", "recruiter": "Смирнова А.А.", "department": "Mobile", "entry_date": "2025-05-28", "resume_link": "https://drive.google.com/file/39024", "ck_department": "ЦК Аналитики", "transfer_date": "2025-11-27", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "ML Pipeline, Госуслуги 2.0, Infrastructure", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-10-11", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 18:21:37.57537	2026-01-16 12:05:28.654958
164	Семёнов Кирилл Сергеевич	oleg.kiselev148@company.ru	{"grade": "Lead", "hr_bp": "Волкова Н.В.", "mentor": "Ivanov A.S.", "salary": "1555", "skills": "Rust,WebAssembly", "status": "Болеет", "project": "CRM System", "comments": "Срочно нужен проект", "contacts": "+7 (996) 203-36-58, @семкири48, oleg.kiselev148@company.ru", "it_block": "Диджитал", "location": "Москва", "position": "QA Engineer", "hire_date": "2020-05-17", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2024-12-09", "resume_link": "https://drive.google.com/file/62754", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Госуслуги 2.0, Data Platform, DevOps Platform", "candidate_status": "Забронирован", "funding_end_date": "2025-12-17", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 18:21:37.458893	2026-01-16 12:05:28.753451
187	Михайлов Андрей Дмитриевич	arseny.morozov171@company.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "Sidorov K.V.", "salary": "2071", "skills": "AWS,Terraform", "status": "На бенче", "project": "Infrastructure", "comments": "Ожидает оффер", "contacts": "+7 (959) 386-82-90, @михандр18, arseny.morozov171@company.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "Middle Developer", "hire_date": "2020-08-09", "recruiter": "Смирнова А.А.", "department": "Frontend", "entry_date": "2024-02-13", "resume_link": "https://drive.google.com/file/44590", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-11-02", "placement_type": "перевод", "current_manager": "Иванов А.П.", "target_projects": "Госуслуги 2.0, Mobile App, Infrastructure", "candidate_status": "Переведен", "funding_end_date": "2026-07-13", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:40.009105	2026-01-16 12:05:28.847986
193	Лебедев Дмитрий Павлович	igor.yakovlev177@company.ru	{"grade": "Principal", "mentor": "Ivanov A.S.", "salary": "1739", "skills": "TypeScript,Vue", "status": "В отпуске", "project": "", "location": "Москва", "position": "Tech Lead", "hire_date": "2018-03-03", "department": "Frontend"}	2026-01-15 18:21:40.637271	2026-01-15 18:21:40.637275
194	Семёнов Кирилл Сергеевич	ivan.sergeev178@company.ru	{"grade": "Principal", "mentor": "", "salary": "1350", "skills": "PHP,Laravel", "status": "Болеет", "project": "Mobile App", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2021-05-01", "department": "Mobile"}	2026-01-15 18:21:40.759233	2026-01-15 18:21:40.759237
200	Петров Алексей Александрович	vladimir.grigoriev184@company.ru	{"grade": "Middle", "mentor": "Kozlova E.A.", "salary": "1024", "skills": "Ruby,Rails", "status": "Болеет", "project": "API Gateway", "location": "Москва", "position": "Senior Developer", "hire_date": "2022-12-04", "department": "Design"}	2026-01-15 18:21:41.360155	2026-01-15 18:21:41.360159
25	Морозов Никита Михайлович	viktor.petrov9@company.ru	{"grade": "Middle", "mentor": "", "salary": "2284", "skills": "Ruby,Rails", "status": "На проекте", "project": "", "location": "Санкт-Петербург", "position": "Junior Developer", "hire_date": "2023-08-15", "department": "Backend"}	2026-01-15 18:21:22.428453	2026-01-15 18:21:22.428458
30	Иванов Александр Александрович	petr.vorobyov14@company.ru	{"grade": "Principal", "mentor": "Ivanov A.S.", "salary": "1789", "skills": "Node.js,Express", "status": "На проекте", "project": "Security Audit", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2023-01-01", "department": "Mobile"}	2026-01-15 18:21:22.995278	2026-01-15 18:21:22.995283
38	Новиков Роман Алексеевич	oleg.kozlov22@company.ru	{"grade": "Lead", "mentor": "", "salary": "2653", "skills": "AWS,Terraform", "status": "На проекте", "project": "Performance", "location": "Санкт-Петербург", "position": "Tech Lead", "hire_date": "2023-07-02", "department": "QA"}	2026-01-15 18:21:23.928326	2026-01-15 18:21:23.928332
62	Кузнецов Денис Иванович	irina.alexeev46@company.ru	{"grade": "Principal", "mentor": "Ivanov A.S.", "salary": "2695", "skills": "Rust,WebAssembly", "status": "На проекте", "project": "ML Platform", "location": "Санкт-Петербург", "position": "Team Lead", "hire_date": "2023-03-27", "department": "QA"}	2026-01-15 18:21:26.578173	2026-01-15 18:21:26.578177
73	Лебедев Дмитрий Павлович	natalia.volkov57@company.ru	{"grade": "Junior", "mentor": "Kozlova E.A.", "salary": "1611", "skills": "C#,.NET", "status": "На проекте", "project": "Refactoring", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2019-01-04", "department": "Analytics"}	2026-01-15 18:21:27.694328	2026-01-15 18:21:27.694332
27	Алексеев Михаил Дмитриевич	igor.makarov11@company.ru	{"grade": "Middle", "mentor": "", "salary": "2187", "skills": "Swift,iOS", "status": "На проекте", "project": "API Gateway", "location": "Удалённо", "position": "Team Lead", "hire_date": "2018-06-24", "department": "Management"}	2026-01-15 18:21:22.676385	2026-01-15 18:21:22.676391
51	Соколов Егор Андреевич	danil.kozlov35@company.ru	{"grade": "Senior", "mentor": "", "salary": "1504", "skills": "Python,Django", "status": "На проекте", "project": "Refactoring", "location": "Удалённо", "position": "Team Lead", "hire_date": "2019-03-16", "department": "DevOps"}	2026-01-15 18:21:25.393719	2026-01-15 18:21:25.393723
59	Семёнов Кирилл Евгеньевич	yaroslav.korolev43@company.ru	{"grade": "Junior", "mentor": "Ivanov A.S.", "salary": "2106", "skills": "C#,.NET", "status": "На проекте", "project": "Infrastructure", "location": "Удалённо", "position": "Tech Lead", "hire_date": "2024-06-20", "department": "Frontend"}	2026-01-15 18:21:26.244955	2026-01-15 18:21:26.244958
185	Петров Алексей Михайлович	sergey.kiselev169@company.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2730", "skills": "PHP,Laravel", "status": "Болеет", "project": "", "comments": "", "contacts": "+7 (986) 500-85-23, @петалек4, sergey.kiselev169@company.ru", "it_block": "Эксплуатация", "location": "Санкт-Петербург", "position": "Team Lead", "hire_date": "2021-08-09", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2024-04-25", "resume_link": "https://drive.google.com/file/16759", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "Banking App, DevOps Platform", "candidate_status": "В работе", "funding_end_date": "2026-08-16", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 18:21:39.761143	2026-01-16 12:05:28.946245
189	Фёдоров Сергей Евгеньевич	viktor.alexandrov173@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "Ivanov A.S.", "salary": "1838", "skills": "Kotlin,Android", "status": "В отпуске", "project": "Infrastructure", "comments": "Срочно нужен проект", "contacts": "+7 (976) 864-71-20, @фёдсерг82, viktor.alexandrov173@company.ru", "it_block": "НУК", "location": "Удалённо", "position": "Designer", "hire_date": "2018-05-21", "recruiter": "Смирнова А.А.", "department": "Mobile", "entry_date": "2024-08-09", "resume_link": "https://drive.google.com/file/84872", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "перевод", "current_manager": "Иванов А.П.", "target_projects": "Mobile App, ML Pipeline", "candidate_status": "Свободен", "funding_end_date": "2025-12-12", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:40.20963	2026-01-16 12:05:29.06122
190	Морозов Никита Александрович	artem.kozlov174@company.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Novikova O.P.", "salary": "2637", "skills": "Go,gRPC", "status": "В отпуске", "project": "API Gateway", "comments": "Ожидает оффер", "contacts": "+7 (910) 163-56-91, @морники9, artem.kozlov174@company.ru", "it_block": "Развитие", "location": "Москва", "position": "Analyst", "hire_date": "2023-05-01", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2025-05-20", "resume_link": "https://drive.google.com/file/34043", "ck_department": "Департамент данных", "transfer_date": "2025-06-23", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "DevOps Platform, E-commerce Platform, ML Pipeline", "candidate_status": "Переведен", "funding_end_date": "2025-04-21", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 18:21:40.326771	2026-01-16 12:05:29.219387
65	Петров Алексей Михайлович	roman.sokolov49@company.ru	{"grade": "Senior", "mentor": "Petrov M.I.", "salary": "2697", "skills": "Go,gRPC", "status": "На проекте", "project": "CRM System", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2022-07-04", "department": "Analytics"}	2026-01-15 18:21:26.894182	2026-01-15 18:21:26.894186
216	Соколов Егор Владимирович	anton.petrov200@company.ru	{"grade": "Junior", "mentor": "Ivanov A.S.", "salary": "2412", "skills": "Kotlin,Android", "status": "На бенче", "project": "Admin Panel", "location": "Удалённо", "position": "Project Manager", "hire_date": "2023-03-03", "department": "QA"}	2026-01-15 18:21:43.099178	2026-01-15 18:21:43.099183
208	Лебедев Дмитрий Алексеевич	petr.zaitsev192@company.ru	{"grade": "Junior", "mentor": "Sidorov K.V.", "salary": "1073", "skills": "TypeScript,Vue", "status": "В отпуске", "project": "Refactoring", "location": "Удалённо", "position": "Tech Lead", "hire_date": "2022-09-28", "department": "Frontend"}	2026-01-15 18:21:42.209233	2026-01-15 18:21:42.209237
32	Кузнецов Денис Иванович	anton.semenov16@company.ru	{"grade": "Lead", "mentor": "Petrov M.I.", "salary": "1452", "skills": "Swift,iOS", "status": "На проекте", "project": "Infrastructure", "location": "Гибрид", "position": "Analyst", "hire_date": "2019-07-09", "department": "QA"}	2026-01-15 18:21:23.212178	2026-01-15 18:21:23.212184
210	Иванов Александр Александрович	konstantin.nikolaev194@company.ru	{"grade": "Lead", "mentor": "", "salary": "1329", "skills": "Docker,Kubernetes", "status": "Болеет", "project": "ML Platform", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2021-03-22", "department": "Frontend"}	2026-01-15 18:21:42.425583	2026-01-15 18:21:42.425587
39	Фёдоров Сергей Евгеньевич	andrey.petrov23@company.ru	{"grade": "Principal", "mentor": "", "salary": "2008", "skills": "Docker,Kubernetes", "status": "На проекте", "project": "Mobile App", "location": "Москва", "position": "QA Engineer", "hire_date": "2023-06-08", "department": "Management"}	2026-01-15 18:21:24.061937	2026-01-15 18:21:24.061944
207	Алексеев Михаил Дмитриевич	alexander.romanov191@company.ru	{"grade": "Senior", "mentor": "", "salary": "1071", "skills": "Rust,WebAssembly", "status": "В отпуске", "project": "API Gateway", "location": "Москва", "position": "Analyst", "hire_date": "2018-04-24", "department": "Mobile"}	2026-01-15 18:21:42.082055	2026-01-15 18:21:42.082059
209	Семёнов Кирилл Евгеньевич	arseny.sergeev193@company.ru	{"grade": "Senior", "mentor": "", "salary": "1805", "skills": "Python,Django", "status": "Болеет", "project": "", "location": "Москва", "position": "Designer", "hire_date": "2018-12-18", "department": "DevOps"}	2026-01-15 18:21:42.311433	2026-01-15 18:21:42.311437
81	Соколов Егор Андреевич	svetlana.smirnov65@company.ru	{"grade": "Lead", "mentor": "Kozlova E.A.", "salary": "1279", "skills": "Python,Django", "status": "На проекте", "project": "Mobile App", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2020-12-03", "department": "QA"}	2026-01-15 18:21:28.55671	2026-01-15 18:21:28.556716
82	Михайлов Андрей Иванович	yaroslav.volkov66@company.ru	{"grade": "Middle", "mentor": "Kozlova E.A.", "salary": "1016", "skills": "AWS,Terraform", "status": "На проекте", "project": "API Gateway", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2019-03-22", "department": "Backend"}	2026-01-15 18:21:28.653355	2026-01-15 18:21:28.653359
87	Алексеев Михаил Дмитриевич	mikhail.dmitriev71@company.ru	{"grade": "Senior", "mentor": "Ivanov A.S.", "salary": "1568", "skills": "Java,Spring", "status": "На проекте", "project": "API Gateway", "location": "Санкт-Петербург", "position": "Team Lead", "hire_date": "2022-05-14", "department": "Backend"}	2026-01-15 18:21:29.198749	2026-01-15 18:21:29.198752
107	Кузнецов Денис Дмитриевич	tatiana.smirnov91@company.ru	{"grade": "Principal", "mentor": "", "salary": "1618", "skills": "Swift,iOS", "status": "На проекте", "project": "", "location": "Санкт-Петербург", "position": "Analyst", "hire_date": "2022-10-14", "department": "Mobile"}	2026-01-15 18:21:31.392316	2026-01-15 18:21:31.392321
101	Волков Максим Андреевич	arthur.sergeev85@company.ru	{"grade": "Middle", "mentor": "Kozlova E.A.", "salary": "2905", "skills": "Go,gRPC", "status": "На проекте", "project": "Security Audit", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2024-11-07", "department": "Design"}	2026-01-15 18:21:30.739014	2026-01-15 18:21:30.739018
106	Смирнов Илья Владимирович	gleb.makarov90@company.ru	{"grade": "Senior", "mentor": "", "salary": "2309", "skills": "PHP,Laravel", "status": "На проекте", "project": "Data Pipeline", "location": "Удалённо", "position": "Senior Developer", "hire_date": "2024-07-10", "department": "Design"}	2026-01-15 18:21:31.27577	2026-01-15 18:21:31.275774
122	Кузнецов Денис Иванович	igor.gusev106@company.ru	{"grade": "Lead", "mentor": "Sidorov K.V.", "salary": "2133", "skills": "TypeScript,Vue", "status": "На проекте", "project": "Mobile App", "location": "Удалённо", "position": "Junior Developer", "hire_date": "2024-11-18", "department": "Analytics"}	2026-01-15 18:21:33.04032	2026-01-15 18:21:33.040324
124	Васильев Иван Сергеевич	natalia.makarov108@company.ru	{"grade": "Principal", "mentor": "", "salary": "2205", "skills": "Python,Django", "status": "На проекте", "project": "", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2018-05-27", "department": "QA"}	2026-01-15 18:21:33.241242	2026-01-15 18:21:33.241246
127	Михайлов Андрей Дмитриевич	danil.yakovlev111@company.ru	{"grade": "Middle", "mentor": "", "salary": "2209", "skills": "AWS,Terraform", "status": "На проекте", "project": "Performance", "location": "Удалённо", "position": "Senior Developer", "hire_date": "2018-09-20", "department": "Frontend"}	2026-01-15 18:21:33.57367	2026-01-15 18:21:33.573674
150	Иванов Александр Александрович	artem.korolev134@company.ru	{"grade": "Middle", "mentor": "Ivanov A.S.", "salary": "2872", "skills": "Node.js,Express", "status": "На проекте", "project": "Admin Panel", "location": "Удалённо", "position": "Junior Developer", "hire_date": "2023-09-08", "department": "QA"}	2026-01-15 18:21:36.022357	2026-01-15 18:21:36.022362
100	Морозов Никита Александрович	roman.petrov84@company.ru	{"grade": "Lead", "mentor": "", "salary": "2818", "skills": "Ruby,Rails", "status": "На проекте", "project": "Admin Panel", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2021-02-10", "department": "DevOps"}	2026-01-15 18:21:30.640934	2026-01-15 18:21:30.640937
120	Иванов Александр Александрович	grigory.semenov104@company.ru	{"grade": "Middle", "mentor": "Novikova O.P.", "salary": "2420", "skills": "Rust,WebAssembly", "status": "На проекте", "project": "API Gateway", "location": "Гибрид", "position": "Senior Developer", "hire_date": "2021-08-24", "department": "Backend"}	2026-01-15 18:21:32.831117	2026-01-15 18:21:32.831121
132	Алексеев Михаил Иванович	andrey.frolov116@company.ru	{"grade": "Lead", "mentor": "Petrov M.I.", "salary": "2845", "skills": "TypeScript,Vue", "status": "На проекте", "project": "", "location": "Гибрид", "position": "Analyst", "hire_date": "2019-09-16", "department": "Management"}	2026-01-15 18:21:34.10286	2026-01-15 18:21:34.102864
148	Лебедев Дмитрий Алексеевич	ilya.novikov132@company.ru	{"grade": "Lead", "mentor": "", "salary": "2489", "skills": "Node.js,Express", "status": "На проекте", "project": "CRM System", "location": "Гибрид", "position": "QA Engineer", "hire_date": "2022-06-13", "department": "DevOps"}	2026-01-15 18:21:35.809104	2026-01-15 18:21:35.809109
215	Петров Алексей Михайлович	artem.zakharov199@company.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Petrov M.I.", "salary": "936", "skills": "JavaScript,React", "status": "На проекте", "project": "Admin Panel", "comments": "", "contacts": "+7 (992) 179-59-69, @петалек5, artem.zakharov199@company.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "Analyst", "hire_date": "2022-03-10", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2024-12-13", "resume_link": "https://drive.google.com/file/32906", "ck_department": "ЦК Аналитики", "transfer_date": "2025-11-15", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "Госуслуги 2.0, E-commerce Platform", "candidate_status": "Переведен", "funding_end_date": "2025-06-22", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:42.993492	2026-01-16 12:05:29.536613
174	Фёдоров Сергей Сергеевич	roman.kiselev158@company.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Novikova O.P.", "salary": "1284", "skills": "Rust,WebAssembly", "status": "На проекте", "project": "Infrastructure", "comments": "Ожидает оффер", "contacts": "+7 (982) 264-36-61, @фёдсерг63, roman.kiselev158@company.ru", "it_block": "Прочее", "location": "Удалённо", "position": "Team Lead", "hire_date": "2021-02-10", "recruiter": "Орлов М.С.", "department": "Mobile", "entry_date": "2024-09-16", "resume_link": "https://drive.google.com/file/99519", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-05-25", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Infrastructure, Mobile App", "candidate_status": "Переведен", "funding_end_date": "2026-09-17", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:38.596988	2026-01-16 12:05:29.617059
182	Кузнецов Денис Иванович	timofey.kiselev166@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1825", "skills": "Python,Django", "status": "На проекте", "project": "Infrastructure", "comments": "Ожидает оффер", "contacts": "+7 (964) 807-47-14, @куздени53, timofey.kiselev166@company.ru", "it_block": "Эксплуатация", "location": "Гибрид", "position": "Junior Developer", "hire_date": "2018-04-23", "recruiter": "Смирнова А.А.", "department": "Backend", "entry_date": "2025-11-06", "resume_link": "https://drive.google.com/file/32225", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-06-16", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Госуслуги 2.0, Mobile App", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-07-13", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 18:21:39.444044	2026-01-16 12:05:29.740395
76	Смирнов Илья Владимирович	alexander.smirnov60@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "Ivanov A.S.", "salary": "2057", "skills": "JavaScript,React", "status": "В отпуске", "project": "Mobile App", "comments": "", "contacts": "+7 (907) 247-33-39, @смиилья44, alexander.smirnov60@company.ru", "it_block": "Прочее", "location": "Гибрид", "position": "Designer", "hire_date": "2021-03-23", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2025-12-30", "resume_link": "https://drive.google.com/file/89745", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "Banking App, Госуслуги 2.0, DevOps Platform", "candidate_status": "В работе", "funding_end_date": "2025-09-22", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 18:21:27.995326	2026-01-16 12:05:29.834667
133	Лебедев Дмитрий Павлович	ruslan.kozlov117@company.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "Novikova O.P.", "salary": "2620", "skills": "Ruby,Rails", "status": "В отпуске", "project": "Admin Panel", "comments": "Ожидает оффер", "contacts": "+7 (931) 725-14-52, @лебдмит54, ruslan.kozlov117@company.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "Analyst", "hire_date": "2022-07-15", "recruiter": "Смирнова А.А.", "department": "Backend", "entry_date": "2025-08-15", "resume_link": "https://drive.google.com/file/16375", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-02-19", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Data Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-12-16", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:34.211011	2026-01-16 12:05:29.956445
54	Фёдоров Сергей Сергеевич	arseny.nikitin38@company.ru	{"grade": "Principal", "hr_bp": "Лебедева Т.М.", "mentor": "Novikova O.P.", "salary": "1289", "skills": "Ruby,Rails", "status": "Болеет", "project": "Performance", "comments": "Ожидает оффер", "contacts": "+7 (933) 890-58-69, @фёдсерг89, arseny.nikitin38@company.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2020-10-21", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2024-08-19", "resume_link": "https://drive.google.com/file/54770", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "DevOps Platform, Infrastructure", "candidate_status": "В работе", "funding_end_date": "2025-02-28", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:25.727031	2026-01-16 12:05:30.036199
125	Петров Алексей Михайлович	andrey.mikhailov109@company.ru	{"grade": "Lead", "hr_bp": "Морозов К.А.", "mentor": "Petrov M.I.", "salary": "2145", "skills": "TypeScript,Vue", "status": "В отпуске", "project": "", "comments": "", "contacts": "+7 (956) 989-19-88, @петалек5, andrey.mikhailov109@company.ru", "it_block": "Диджитал", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2020-01-11", "recruiter": "Белова И.Д.", "department": "DevOps", "entry_date": "2025-07-16", "resume_link": "https://drive.google.com/file/42310", "ck_department": "ЦК Разработки", "transfer_date": "2025-04-30", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline", "candidate_status": "Переведен", "funding_end_date": "2025-04-23", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:33.35855	2026-01-16 12:05:30.191478
178	Лебедев Дмитрий Алексеевич	viktor.alexandrov162@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "Novikova O.P.", "salary": "959", "skills": "AWS,Terraform", "status": "В отпуске", "project": "", "comments": "Срочно нужен проект", "contacts": "+7 (922) 773-43-51, @лебдмит5, viktor.alexandrov162@company.ru", "it_block": "Прочее", "location": "Гибрид", "position": "Team Lead", "hire_date": "2023-03-04", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2025-01-14", "resume_link": "https://drive.google.com/file/66556", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-03-16", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Banking App, Госуслуги 2.0, Mobile App", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-11-26", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:39.039207	2026-01-16 12:05:30.296512
33	Попов Артём Павлович	olga.lebedev17@company.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Novikova O.P.", "salary": "809", "skills": "TypeScript,Vue", "status": "Болеет", "project": "Security Audit", "comments": "", "contacts": "+7 (948) 138-71-53, @попартё8, olga.lebedev17@company.ru", "it_block": "НУК", "location": "Москва", "position": "Junior Developer", "hire_date": "2019-10-26", "recruiter": "Новикова Е.П.", "department": "Analytics", "entry_date": "2025-03-15", "resume_link": "https://drive.google.com/file/90351", "ck_department": "ЦК Разработки", "transfer_date": "2026-04-21", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Infrastructure, Госуслуги 2.0, E-commerce Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-06-15", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:23.329404	2026-01-16 12:05:30.408433
117	Алексеев Михаил Дмитриевич	ekaterina.alexeev101@company.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Novikova O.P.", "salary": "918", "skills": "AWS,Terraform", "status": "На проекте", "project": "", "comments": "", "contacts": "+7 (957) 145-92-47, @алемиха74, ekaterina.alexeev101@company.ru", "it_block": "Развитие", "location": "Москва", "position": "Tech Lead", "hire_date": "2018-10-01", "recruiter": "Новикова Е.П.", "department": "Frontend", "entry_date": "2025-02-12", "resume_link": "https://drive.google.com/file/80565", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Госуслуги 2.0, Mobile App, Data Platform", "candidate_status": "В работе", "funding_end_date": "2026-11-28", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:32.524965	2026-01-16 12:05:30.492117
149	Семёнов Кирилл Евгеньевич	olga.sergeev133@company.ru	{"grade": "Lead", "hr_bp": "Волкова Н.В.", "mentor": "Kozlova E.A.", "salary": "1214", "skills": "AWS,Terraform", "status": "На проекте", "project": "Data Pipeline", "comments": "", "contacts": "+7 (905) 405-50-44, @семкири84, olga.sergeev133@company.ru", "it_block": "Развитие", "location": "Москва", "position": "QA Engineer", "hire_date": "2019-11-10", "recruiter": "Смирнова А.А.", "department": "Backend", "entry_date": "2024-09-18", "resume_link": "https://drive.google.com/file/59261", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Data Platform, ML Pipeline", "candidate_status": "Забронирован", "funding_end_date": "2026-05-31", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:35.925948	2026-01-16 12:05:30.575469
163	Лебедев Дмитрий Павлович	svetlana.korolev147@company.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "804", "skills": "Node.js,Express", "status": "На проекте", "project": "Performance", "comments": "", "contacts": "+7 (997) 221-58-80, @лебдмит26, svetlana.korolev147@company.ru", "it_block": "B2O", "location": "Москва", "position": "Project Manager", "hire_date": "2023-01-11", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2024-03-15", "resume_link": "https://drive.google.com/file/21850", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Banking App, ML Pipeline, Infrastructure", "candidate_status": "В работе", "funding_end_date": "2025-04-11", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:37.357343	2026-01-16 12:05:30.632838
177	Алексеев Михаил Дмитриевич	ekaterina.novikov161@company.ru	{"grade": "Principal", "hr_bp": "Морозов К.А.", "mentor": "Petrov M.I.", "salary": "2288", "skills": "AWS,Terraform", "status": "На проекте", "project": "Mobile App", "comments": "", "contacts": "+7 (911) 956-39-17, @алемиха33, ekaterina.novikov161@company.ru", "it_block": "Прочее", "location": "Москва", "position": "Tech Lead", "hire_date": "2023-03-25", "recruiter": "Белова И.Д.", "department": "Design", "entry_date": "2024-11-20", "resume_link": "https://drive.google.com/file/23094", "ck_department": "ЦК Аналитики", "transfer_date": "2025-04-11", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Infrastructure, DevOps Platform, Data Platform", "candidate_status": "Переведен", "funding_end_date": "2025-07-03", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 18:21:38.920514	2026-01-16 12:05:30.741405
111	Соколов Егор Андреевич	tatiana.egorov95@company.ru	{"grade": "Senior", "mentor": "", "salary": "2731", "skills": "Docker,Kubernetes", "status": "В отпуске", "project": "CRM System", "location": "Москва", "position": "Junior Developer", "hire_date": "2020-05-25", "department": "QA"}	2026-01-15 18:21:31.842966	2026-01-15 18:21:31.842984
130	Морозов Никита Александрович	natalia.petrov114@company.ru	{"grade": "Senior", "mentor": "", "salary": "2217", "skills": "Java,Spring", "status": "В отпуске", "project": "Mobile App", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2018-03-06", "department": "Frontend"}	2026-01-15 18:21:33.894858	2026-01-15 18:21:33.894862
201	Соколов Егор Андреевич	daniil.yakovlev185@company.ru	{"grade": "Senior", "mentor": "", "salary": "1282", "skills": "Python,Django", "status": "В отпуске", "project": "Analytics Platform", "location": "Москва", "position": "Tech Lead", "hire_date": "2021-10-04", "department": "Mobile"}	2026-01-15 18:21:41.458351	2026-01-15 18:21:41.458356
202	Михайлов Андрей Иванович	danil.lebedev186@company.ru	{"grade": "Senior", "mentor": "Sidorov K.V.", "salary": "1599", "skills": "PostgreSQL,Redis", "status": "В отпуске", "project": "Performance", "location": "Москва", "position": "Senior Developer", "hire_date": "2020-04-16", "department": "Design"}	2026-01-15 18:21:41.559078	2026-01-15 18:21:41.559082
212	Кузнецов Денис Иванович	mark.zaitsev196@company.ru	{"grade": "Middle", "mentor": "Sidorov K.V.", "salary": "2751", "skills": "Rust,WebAssembly", "status": "В отпуске", "project": "Admin Panel", "location": "Москва", "position": "Analyst", "hire_date": "2019-12-08", "department": "Backend"}	2026-01-15 18:21:42.659445	2026-01-15 18:21:42.659449
44	Семёнов Кирилл Сергеевич	svetlana.lebedev28@company.ru	{"grade": "Junior", "mentor": "", "salary": "1822", "skills": "Docker,Kubernetes", "status": "Болеет", "project": "Mobile App", "location": "Москва", "position": "Middle Developer", "hire_date": "2023-02-25", "department": "Analytics"}	2026-01-15 18:21:24.640242	2026-01-15 18:21:24.640247
53	Новиков Роман Павлович	roman.dmitriev37@company.ru	{"grade": "Lead", "mentor": "Sidorov K.V.", "salary": "2651", "skills": "C#,.NET", "status": "Болеет", "project": "ML Platform", "location": "Москва", "position": "Team Lead", "hire_date": "2021-03-16", "department": "Management"}	2026-01-15 18:21:25.61116	2026-01-15 18:21:25.611164
393	Волков Кирилл Дмитриевич	k.volkov@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1478", "skills": "React Native, Mobile CI/CD, Android SDK, Swift", "status": "На бенче", "project": "", "location": "Санкт-Петербург", "position": "Middle Developer", "hire_date": "2020-12-16", "department": "Mobile"}	2026-01-15 20:53:53.75264	2026-01-15 20:53:53.752646
60	Иванов Александр Александрович	anton.sergeev44@company.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "Kozlova E.A.", "salary": "2491", "skills": "Rust,WebAssembly", "status": "Болеет", "project": "Performance", "comments": "", "contacts": "+7 (949) 337-33-45, @иваалек95, anton.sergeev44@company.ru", "it_block": "B2O", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2020-11-09", "recruiter": "Смирнова А.А.", "department": "Frontend", "entry_date": "2024-03-31", "resume_link": "https://drive.google.com/file/52142", "ck_department": "Департамент данных", "transfer_date": "2025-07-29", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Госуслуги 2.0, E-commerce Platform", "candidate_status": "Переведен", "funding_end_date": "2026-08-22", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:26.36095	2026-01-16 12:05:30.869175
64	Васильев Иван Сергеевич	yuri.romanov48@company.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "Sidorov K.V.", "salary": "1910", "skills": "C#,.NET", "status": "Болеет", "project": "Analytics Platform", "comments": "Ожидает оффер", "contacts": "+7 (995) 821-81-72, @васиван49, yuri.romanov48@company.ru", "it_block": "Диджитал", "location": "Гибрид", "position": "Analyst", "hire_date": "2019-12-12", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2024-05-04", "resume_link": "https://drive.google.com/file/73361", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "E-commerce Platform", "candidate_status": "Свободен", "funding_end_date": "2026-01-10", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:26.776499	2026-01-16 12:05:30.99187
80	Петров Алексей Александрович	mikhail.sokolov64@company.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Ivanov A.S.", "salary": "2840", "skills": "Java,Spring", "status": "В отпуске", "project": "API Gateway", "comments": "В процессе согласования", "contacts": "+7 (920) 391-65-40, @петалек18, mikhail.sokolov64@company.ru", "it_block": "Диджитал", "location": "Москва", "position": "Junior Developer", "hire_date": "2019-10-06", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2024-06-28", "resume_link": "https://drive.google.com/file/42311", "ck_department": "ЦК Разработки", "transfer_date": "2026-11-03", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Infrastructure, Data Platform, Banking App", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-11-19", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 18:21:28.44463	2026-01-16 12:05:31.070675
109	Васильев Иван Евгеньевич	anton.kiselev93@company.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2485", "skills": "Node.js,Express", "status": "В отпуске", "project": "Admin Panel", "comments": "Срочно нужен проект", "contacts": "+7 (950) 338-48-24, @васиван79, anton.kiselev93@company.ru", "it_block": "Прочее", "location": "Москва", "position": "Junior Developer", "hire_date": "2021-02-22", "recruiter": "Новикова Е.П.", "department": "DevOps", "entry_date": "2025-05-20", "resume_link": "https://drive.google.com/file/29748", "ck_department": "ЦК Аналитики", "transfer_date": "2026-06-21", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "E-commerce Platform", "candidate_status": "Переведен", "funding_end_date": "2026-07-02", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:31.604454	2026-01-16 12:05:31.18343
397	Волкова Марина Антоновна	m.volkova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1638", "skills": "Next.js, GraphQL, HTML/CSS, Redux", "status": "На проекте", "project": "Mobile App", "location": "Москва", "position": "Middle Developer", "hire_date": "2020-10-31", "department": "Frontend"}	2026-01-15 20:53:53.87991	2026-01-15 20:53:53.879915
398	Соколова Юлия Ярославовна	yu.sokolova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1523", "skills": "Adobe XD, Figma, UI/UX, User Research", "status": "На проекте", "project": "Mobile App", "location": "Москва", "position": "Designer", "hire_date": "2021-08-09", "department": "Design"}	2026-01-15 20:53:53.917281	2026-01-15 20:53:53.917288
399	Ковалев Роман Ильич	r.kovalev@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2361", "skills": "Redux, Node.js, GraphQL, Vue.js", "status": "На проекте", "project": "Единая биометрическая система", "location": "Санкт-Петербург", "position": "Senior Developer", "hire_date": "2025-09-17", "department": "Frontend"}	2026-01-15 20:53:53.948668	2026-01-15 20:53:53.948675
400	Тарасов Тимофей Степанович	t.tarasov@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2792", "skills": "REST API, Java, gRPC, Kubernetes", "status": "На проекте", "project": "Кибербезопасность B2B", "location": "Гибрид", "position": "Senior Developer", "hire_date": "2023-05-13", "department": "Backend"}	2026-01-15 20:53:53.974459	2026-01-15 20:53:53.974466
401	Михайлова Алина Егоровна	a.mikhaylova@rt.ru	{"grade": "Junior", "mentor": "", "salary": "831", "skills": "Team Leadership, Scrum, Jira, Kanban", "status": "На проекте", "project": "Госуслуги 2.0", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2025-06-24", "department": "Management"}	2026-01-15 20:53:54.000672	2026-01-15 20:53:54.000679
402	Волков Игорь Антонович	i.volkov@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2715", "skills": "Docker, Microservices, Java, Redis", "status": "На проекте", "project": "API Gateway", "location": "Москва", "position": "Senior Developer", "hire_date": "2019-01-05", "department": "Backend"}	2026-01-15 20:53:54.027054	2026-01-15 20:53:54.027061
403	Степанов Михаил Степанович	m.stepanov@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1535", "skills": "AWS, Grafana, Linux, Ansible", "status": "На проекте", "project": "Единая биометрическая система", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2017-09-03", "department": "DevOps"}	2026-01-15 20:53:54.053015	2026-01-15 20:53:54.053022
404	Александров Артём Степанович	a.aleksandrov@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1570", "skills": "Adobe XD, Figma, Wireframing, Sketch", "status": "На бенче", "project": "", "location": "Москва", "position": "Designer", "hire_date": "2025-08-10", "department": "Design"}	2026-01-15 20:53:54.075381	2026-01-15 20:53:54.075388
405	Егорова Вероника Ильинична	v.egorova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1786", "skills": "Firebase, Mobile CI/CD, Swift, iOS SDK", "status": "На проекте", "project": "Госуслуги 2.0", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2019-10-26", "department": "Mobile"}	2026-01-15 20:53:54.108149	2026-01-15 20:53:54.108155
406	Орлова Надежда Владимировна	n.orlova@rt.ru	{"grade": "Junior", "mentor": "Романов Тимофей Антонович", "salary": "681", "skills": "Jenkins, Ansible, Terraform, Prometheus", "status": "На проекте", "project": "Цифровой офис", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2018-05-19", "department": "DevOps"}	2026-01-15 20:53:54.13809	2026-01-15 20:53:54.138097
407	Зайцев Игорь Игоревич	i.zaytsev@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1412", "skills": "Microservices, REST API, Redis, Spring Boot", "status": "В отпуске", "project": "", "location": "Санкт-Петербург", "position": "Middle Developer", "hire_date": "2017-04-20", "department": "Backend"}	2026-01-15 20:53:54.16462	2026-01-15 20:53:54.164627
408	Новикова Алина Артёмовна	a.novikova@rt.ru	{"grade": "Junior", "mentor": "", "salary": "874", "skills": "Firebase, React Native, Swift, Mobile CI/CD", "status": "На проекте", "project": "ML Pipeline", "location": "Удалённо", "position": "Junior Developer", "hire_date": "2017-11-05", "department": "Mobile"}	2026-01-15 20:53:54.18931	2026-01-15 20:53:54.189317
409	Николаев Матвей Николаевич	m.nikolaev@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2578", "skills": "TypeScript, GraphQL, Next.js, Node.js", "status": "На бенче", "project": "", "location": "Удалённо", "position": "Senior Developer", "hire_date": "2018-02-18", "department": "Frontend"}	2026-01-15 20:53:54.22416	2026-01-15 20:53:54.224166
410	Васильева Диана Игоревна	d.vasileva@rt.ru	{"grade": "Junior", "mentor": "Смирнов Юрий Ярославович", "salary": "1166", "skills": "Power BI, Statistics, ETL, Clickhouse", "status": "На проекте", "project": "IoT платформа", "location": "Москва", "position": "Analyst", "hire_date": "2018-04-18", "department": "Analytics"}	2026-01-15 20:53:54.257034	2026-01-15 20:53:54.25704
411	Федорова Любовь Антоновна	l.fedorova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1510", "skills": "iOS SDK, Android SDK, Kotlin, Mobile CI/CD", "status": "На проекте", "project": "Партнерский портал", "location": "Москва", "position": "Middle Developer", "hire_date": "2020-03-30", "department": "Mobile"}	2026-01-15 20:53:54.28554	2026-01-15 20:53:54.285561
412	Васильев Богдан Александрович	b.vasilev@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2515", "skills": "Python, Power BI, ETL, Clickhouse", "status": "В отпуске", "project": "", "location": "Гибрид", "position": "Analyst", "hire_date": "2021-04-22", "department": "Analytics"}	2026-01-15 20:53:54.32282	2026-01-15 20:53:54.322827
413	Иванов Владимир Денисович	v.ivanov@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3619", "skills": "React Native, Kotlin, iOS SDK, Mobile CI/CD", "status": "На проекте", "project": "Видеонаблюдение", "location": "Удалённо", "position": "Team Lead", "hire_date": "2022-02-15", "department": "Mobile"}	2026-01-15 20:53:54.351352	2026-01-15 20:53:54.351357
414	Ильина Валерия Игоревна	v.ilina@rt.ru	{"grade": "Junior", "mentor": "Поляков Егор Кириллович", "salary": "1052", "skills": "ETL, Excel, Tableau, A/B Testing", "status": "На проекте", "project": "Умный дом Ростелеком", "location": "Удалённо", "position": "Analyst", "hire_date": "2023-09-27", "department": "Analytics"}	2026-01-15 20:53:54.371958	2026-01-15 20:53:54.371963
415	Егорова Диана Ивановна	d.egorova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1446", "skills": "React, Vue.js, GraphQL, TypeScript", "status": "На проекте", "project": "Wink платформа", "location": "Удалённо", "position": "Middle Developer", "hire_date": "2023-08-18", "department": "Frontend"}	2026-01-15 20:53:54.391153	2026-01-15 20:53:54.391157
416	Васильев Максим Кириллович	m.vasilev@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2827", "skills": "User Research, Sketch, Adobe XD, Wireframing", "status": "На проекте", "project": "Техподдержка 3.0", "location": "Москва", "position": "Designer", "hire_date": "2021-05-30", "department": "Design"}	2026-01-15 20:53:54.40893	2026-01-15 20:53:54.408934
417	Полякова София Руслановна	s.polyakova@rt.ru	{"grade": "Junior", "mentor": "Козлов Степан Антонович", "salary": "1013", "skills": "Kafka, Kubernetes, Microservices, gRPC", "status": "На проекте", "project": "Monitoring System", "location": "Гибрид", "position": "Junior Developer", "hire_date": "2024-12-07", "department": "Backend"}	2026-01-15 20:53:54.441496	2026-01-15 20:53:54.441501
418	Семенов Игорь Павлович	i.semenov@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1933", "skills": "Kafka, Docker, Java, Microservices", "status": "На проекте", "project": "Цифровой офис", "location": "Москва", "position": "Middle Developer", "hire_date": "2020-07-01", "department": "Backend"}	2026-01-15 20:53:54.47064	2026-01-15 20:53:54.470647
419	Смирнова Алиса Юрьевна	a.smirnova@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2300", "skills": "JavaScript, React, HTML/CSS, Vue.js", "status": "На проекте", "project": "DevOps Platform", "location": "Москва", "position": "Senior Developer", "hire_date": "2023-02-24", "department": "Frontend"}	2026-01-15 20:53:54.494362	2026-01-15 20:53:54.494368
420	Михайлова Кристина Артёмовна	k.mikhaylova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1308", "skills": "Performance Testing, Postman, Automation, Selenium", "status": "На проекте", "project": "Единая биометрическая система", "location": "Гибрид", "position": "QA Engineer", "hire_date": "2017-09-16", "department": "QA"}	2026-01-15 20:53:54.522153	2026-01-15 20:53:54.522159
421	Никитин Александр Андреевич	a.nikitin@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2920", "skills": "JUnit, Allure, API Testing, Automation", "status": "На бенче", "project": "", "location": "Москва", "position": "QA Engineer", "hire_date": "2025-03-09", "department": "QA"}	2026-01-15 20:53:54.543721	2026-01-15 20:53:54.543727
425	Белова Евгения Павловна	e.belova@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1548", "skills": "HTML/CSS, Webpack, Redux, JavaScript", "status": "На бенче", "project": "", "comments": "", "contacts": "+7 (961) 895-49-72, @белевге7, e.belova@rt.ru", "it_block": "НУК", "location": "Москва", "position": "Middle Developer", "hire_date": "2017-10-31", "recruiter": "Смирнова А.А.", "department": "Frontend", "entry_date": "2025-11-09", "resume_link": "https://drive.google.com/file/31471", "ck_department": "Департамент данных", "transfer_date": "2025-07-19", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline, DevOps Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-07-27", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:54.651615	2026-01-16 12:05:31.340553
428	Медведев Игорь Тимурович	i.medvedev@rt.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Петрова Яна Сергеевна", "salary": "1037", "skills": "Grafana, Docker, Prometheus, GitLab CI", "status": "На проекте", "project": "CRM Enterprise", "comments": "Ожидает оффер", "contacts": "+7 (901) 398-94-91, @медигор65, i.medvedev@rt.ru", "it_block": "Диджитал", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2024-08-25", "recruiter": "Белова И.Д.", "department": "DevOps", "entry_date": "2025-11-16", "resume_link": "https://drive.google.com/file/81737", "ck_department": "ЦК Разработки", "transfer_date": "2025-09-12", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Mobile App, ML Pipeline, DevOps Platform", "candidate_status": "Переведен", "funding_end_date": "2025-07-03", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:54.722588	2026-01-16 12:05:31.462548
430	Степанов Денис Денисович	d.stepanov@rt.ru	{"grade": "Lead", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "3715", "skills": "Node.js, Redux, Next.js, HTML/CSS", "status": "На проекте", "project": "Mobile App", "comments": "", "contacts": "+7 (981) 716-83-66, @стедени99, d.stepanov@rt.ru", "it_block": "НУК", "location": "Москва", "position": "Team Lead", "hire_date": "2016-06-19", "recruiter": "Белова И.Д.", "department": "Frontend", "entry_date": "2024-08-25", "resume_link": "https://drive.google.com/file/79290", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-03-06", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "Infrastructure", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-11-02", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:54.811869	2026-01-16 12:05:31.519962
433	Соколов Даниил Дмитриевич	d.sokolov@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1123", "skills": "API Testing, Postman, TestNG, Manual Testing", "status": "На бенче", "project": "", "comments": "Срочно нужен проект", "contacts": "+7 (976) 113-48-44, @сокдани48, d.sokolov@rt.ru", "it_block": "Эксплуатация", "location": "Гибрид", "position": "QA Engineer", "hire_date": "2025-07-16", "recruiter": "Новикова Е.П.", "department": "QA", "entry_date": "2025-09-24", "resume_link": "https://drive.google.com/file/66036", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "E-commerce Platform, Infrastructure", "candidate_status": "Забронирован", "funding_end_date": "2026-08-24", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:54.94637	2026-01-16 12:05:31.610581
439	Петрова Любовь Михайловна	l.petrova@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Медведев Игорь Кириллович", "salary": "603", "skills": "Tableau, Statistics, Excel, SQL", "status": "В отпуске", "project": "", "comments": "", "contacts": "+7 (925) 741-57-39, @петлюбо24, l.petrova@rt.ru", "it_block": "Развитие", "location": "Москва", "position": "Analyst", "hire_date": "2017-07-19", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2025-11-08", "resume_link": "https://drive.google.com/file/21138", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-02-22", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Mobile App, Data Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-11-22", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.171361	2026-01-16 12:05:31.789036
442	Киселев Дмитрий Александрович	d.kiselev@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2689", "skills": "Grafana, Docker, Kubernetes, Prometheus", "status": "На проекте", "project": "5G инфраструктура", "comments": "Ожидает оффер", "contacts": "+7 (978) 390-75-74, @кисдмит34, d.kiselev@rt.ru", "it_block": "Прочее", "location": "Гибрид", "position": "DevOps Engineer", "hire_date": "2023-08-17", "recruiter": "Смирнова А.А.", "department": "DevOps", "entry_date": "2025-08-14", "resume_link": "https://drive.google.com/file/10141", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "DevOps Platform, Banking App, ML Pipeline", "candidate_status": "Свободен", "funding_end_date": "2025-08-16", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:55.27764	2026-01-16 12:05:31.882484
444	Ильина Вероника Кирилловна	v.ilina@rt.ru	{"grade": "Lead", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "3412", "skills": "Prototyping, Sketch, Wireframing, UI/UX", "status": "На бенче", "project": "", "comments": "", "contacts": "+7 (926) 204-36-91, @ильверо18, v.ilina@rt.ru", "it_block": "Прочее", "location": "Санкт-Петербург", "position": "Designer", "hire_date": "2019-07-09", "recruiter": "Новикова Е.П.", "department": "Design", "entry_date": "2024-12-10", "resume_link": "https://drive.google.com/file/32467", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "перевод", "current_manager": "Иванов А.П.", "target_projects": "Госуслуги 2.0, DevOps Platform", "candidate_status": "В работе", "funding_end_date": "2025-04-28", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:55.351223	2026-01-16 12:05:31.93735
447	Сергеева Юлия Ивановна	yu.sergeeva@rt.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1184", "skills": "Adobe XD, User Research, Wireframing, Figma", "status": "Болеет", "project": "", "comments": "В процессе согласования", "contacts": "+7 (945) 705-62-74, @серюлия68, yu.sergeeva@rt.ru", "it_block": "B2O", "location": "Москва", "position": "Designer", "hire_date": "2023-03-04", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2024-07-12", "resume_link": "https://drive.google.com/file/70590", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-11-19", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "Data Platform, ML Pipeline", "candidate_status": "Переведен", "funding_end_date": "2026-01-25", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.430209	2026-01-16 12:05:32.024707
449	Васильева Полина Олеговна	p.vasileva@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1748", "skills": "Postman, Manual Testing, JMeter, Automation", "status": "Болеет", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (931) 129-66-92, @васполи43, p.vasileva@rt.ru", "it_block": "НУК", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2020-04-03", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2024-06-24", "resume_link": "https://drive.google.com/file/48711", "ck_department": "ЦК Разработки", "transfer_date": "2025-11-16", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "E-commerce Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-10-26", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.478736	2026-01-16 12:05:32.090665
452	Фролов Павел Владимирович	p.frolov@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1849", "skills": "JavaScript, TypeScript, React, HTML/CSS", "status": "В отпуске", "project": "", "comments": "Срочно нужен проект", "contacts": "+7 (924) 827-96-63, @фропаве18, p.frolov@rt.ru", "it_block": "Диджитал", "location": "Москва", "position": "Middle Developer", "hire_date": "2016-07-06", "recruiter": "Новикова Е.П.", "department": "Frontend", "entry_date": "2024-08-02", "resume_link": "https://drive.google.com/file/48391", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-02-10", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Banking App", "candidate_status": "Переведен", "funding_end_date": "2026-09-18", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:55.584258	2026-01-16 12:05:32.19524
454	Степанов Вадим Павлович	v.stepanov@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1382", "skills": "SQL, Tableau, Power BI, Clickhouse", "status": "На проекте", "project": "Service Mesh", "comments": "", "contacts": "+7 (924) 313-55-27, @стевади42, v.stepanov@rt.ru", "it_block": "НУК", "location": "Гибрид", "position": "Analyst", "hire_date": "2017-09-13", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2024-10-18", "resume_link": "https://drive.google.com/file/82787", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "E-commerce Platform", "candidate_status": "Забронирован", "funding_end_date": "2026-02-26", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:55.628936	2026-01-16 12:05:32.259842
472	Максимов Руслан Юрьевич	r.maksimov@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1485", "skills": "Swift, Android SDK, Firebase, Flutter", "status": "На проекте", "project": "Партнерский портал", "location": "Москва", "position": "Middle Developer", "hire_date": "2019-06-18", "department": "Mobile"}	2026-01-15 20:53:56.333996	2026-01-15 20:53:56.334003
473	Поляков Олег Олегович	o.polyakov@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3870", "skills": "UI/UX, Sketch, User Research, Adobe XD", "status": "На проекте", "project": "DataLake", "location": "Удалённо", "position": "Designer", "hire_date": "2018-04-15", "department": "Design"}	2026-01-15 20:53:56.359537	2026-01-15 20:53:56.359544
474	Зайцев Никита Олегович	n.zaytsev@rt.ru	{"grade": "Junior", "mentor": "", "salary": "1231", "skills": "JUnit, Selenium, Performance Testing, TestNG", "status": "На проекте", "project": "AI Contact Center", "location": "Гибрид", "position": "QA Engineer", "hire_date": "2023-05-20", "department": "QA"}	2026-01-15 20:53:56.393281	2026-01-15 20:53:56.393288
459	Кузьмина Александра Павловна	a.kuzmina@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1356", "skills": "Stakeholder Management, Budgeting, Confluence, Kanban", "status": "На проекте", "project": "Госуслуги 2.0", "comments": "Ожидает оффер", "contacts": "+7 (942) 118-25-64, @кузалек77, a.kuzmina@rt.ru", "it_block": "НУК", "location": "Удалённо", "position": "Project Manager", "hire_date": "2018-01-12", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2025-10-16", "resume_link": "https://drive.google.com/file/71145", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-01-19", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Infrastructure, DevOps Platform", "candidate_status": "Переведен", "funding_end_date": "2026-05-12", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.825698	2026-01-16 12:05:32.407598
461	Антонова Дарья Олеговна	d.antonova@rt.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1288", "skills": "Firebase, Swift, Kotlin, React Native", "status": "В отпуске", "project": "", "comments": "В процессе согласования", "contacts": "+7 (945) 414-61-44, @антдарь27, d.antonova@rt.ru", "it_block": "Эксплуатация", "location": "Санкт-Петербург", "position": "Junior Developer", "hire_date": "2022-03-21", "recruiter": "Орлов М.С.", "department": "Mobile", "entry_date": "2025-04-28", "resume_link": "https://drive.google.com/file/13173", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-04-02", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "E-commerce Platform, ML Pipeline", "candidate_status": "Переведен", "funding_end_date": "2026-02-15", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.921599	2026-01-16 12:05:32.457119
464	Никитин Артур Игоревич	a.nikitin@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "897", "skills": "Docker, Java, Kubernetes, Microservices", "status": "На проекте", "project": "Mobile App", "comments": "Ожидает оффер", "contacts": "+7 (934) 987-83-65, @никарту62, a.nikitin@rt.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Junior Developer", "hire_date": "2024-04-14", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2025-06-21", "resume_link": "https://drive.google.com/file/73539", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Banking App, DevOps Platform", "candidate_status": "В работе", "funding_end_date": "2026-02-07", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:56.018402	2026-01-16 12:05:32.576243
467	Орлова Елена Алексеевна	e.orlova@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1524", "skills": "Kubernetes, PostgreSQL, Spring Boot, Redis", "status": "На проекте", "project": "Цифровой офис", "comments": "", "contacts": "+7 (957) 853-45-21, @орлелен35, e.orlova@rt.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "Middle Developer", "hire_date": "2016-11-14", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2025-11-07", "resume_link": "https://drive.google.com/file/16632", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-09-14", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Mobile App, E-commerce Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-08-02", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:56.159436	2026-01-16 12:05:32.675658
469	Петрова Ксения Артёмовна	k.petrova@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2797", "skills": "Sketch, Figma, Adobe XD, UI/UX", "status": "На проекте", "project": "Service Mesh", "comments": "", "contacts": "+7 (912) 340-36-58, @петксен11, k.petrova@rt.ru", "it_block": "Диджитал", "location": "Москва", "position": "Designer", "hire_date": "2024-10-14", "recruiter": "Белова И.Д.", "department": "Design", "entry_date": "2024-05-08", "resume_link": "https://drive.google.com/file/31546", "ck_department": "ЦК Разработки", "transfer_date": "2025-04-08", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Госуслуги 2.0, Mobile App", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-02-14", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:56.244874	2026-01-16 12:05:32.758421
475	Козлов Игорь Алексеевич	i.kozlov@rt.ru	{"grade": "Junior", "mentor": "Морозова Галина Владимировна", "salary": "943", "skills": "Kotlin, React Native, Swift, iOS SDK", "status": "На бенче", "project": "", "location": "Гибрид", "position": "Junior Developer", "hire_date": "2022-07-12", "department": "Mobile"}	2026-01-15 20:53:56.427511	2026-01-15 20:53:56.427518
476	Федоров Егор Романович	e.fedorov@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1590", "skills": "Kanban, Agile, Risk Management, Budgeting", "status": "На проекте", "project": "RT Cloud", "location": "Удалённо", "position": "Project Manager", "hire_date": "2017-08-20", "department": "Management"}	2026-01-15 20:53:56.459918	2026-01-15 20:53:56.459926
477	Кузнецов Егор Вадимович	e.kuznetsov@rt.ru	{"grade": "Junior", "mentor": "Новиков Ярослав Андреевич", "salary": "613", "skills": "Team Leadership, Kanban, Confluence, Stakeholder Management", "status": "На проекте", "project": "Госуслуги 2.0", "location": "Москва", "position": "Project Manager", "hire_date": "2017-03-10", "department": "Management"}	2026-01-15 20:53:56.492583	2026-01-15 20:53:56.492589
478	Ильина Марина Романовна	m.ilina@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2643", "skills": "ETL, Data Visualization, Tableau, Statistics", "status": "На проекте", "project": "Billing System", "location": "Гибрид", "position": "Analyst", "hire_date": "2022-03-10", "department": "Analytics"}	2026-01-15 20:53:56.54565	2026-01-15 20:53:56.545659
479	Лебедев Матвей Степанович	m.lebedev@rt.ru	{"grade": "Junior", "mentor": "", "salary": "729", "skills": "Selenium, TestNG, Postman, Allure", "status": "На проекте", "project": "Analytics Dashboard", "location": "Гибрид", "position": "QA Engineer", "hire_date": "2018-07-27", "department": "QA"}	2026-01-15 20:53:56.606156	2026-01-15 20:53:56.606164
480	Морозов Антон Николаевич	a.morozov@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1385", "skills": "gRPC, PostgreSQL, Kubernetes, Spring Boot", "status": "На проекте", "project": "Техподдержка 3.0", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2022-06-27", "department": "Backend"}	2026-01-15 20:53:56.64502	2026-01-15 20:53:56.645027
481	Новиков Марк Николаевич	m.novikov@rt.ru	{"grade": "Principal", "mentor": "", "salary": "5189", "skills": "Agile, Stakeholder Management, Team Leadership, Kanban", "status": "На проекте", "project": "ML Pipeline", "location": "Москва", "position": "Project Manager", "hire_date": "2019-02-19", "department": "Management"}	2026-01-15 20:53:56.687354	2026-01-15 20:53:56.687362
482	Козлова Диана Максимовна	d.kozlova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1525", "skills": "Kanban, Stakeholder Management, Risk Management, Agile", "status": "На проекте", "project": "Mobile App", "location": "Удалённо", "position": "Project Manager", "hire_date": "2020-07-22", "department": "Management"}	2026-01-15 20:53:56.722902	2026-01-15 20:53:56.722909
483	Федорова Валерия Константиновна	v.fedorova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1442", "skills": "User Research, Wireframing, Design Systems, Sketch", "status": "На проекте", "project": "IoT платформа", "location": "Москва", "position": "Designer", "hire_date": "2020-10-08", "department": "Design"}	2026-01-15 20:53:56.757323	2026-01-15 20:53:56.75733
484	Козлов Никита Денисович	n.kozlov@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2625", "skills": "Python, Power BI, ETL, A/B Testing", "status": "На проекте", "project": "ML Pipeline", "location": "Удалённо", "position": "Analyst", "hire_date": "2022-01-17", "department": "Analytics"}	2026-01-15 20:53:56.79305	2026-01-15 20:53:56.793057
485	Соколова Яна Романовна	ya.sokolova@rt.ru	{"grade": "Junior", "mentor": "", "salary": "1044", "skills": "Prototyping, Sketch, UI/UX, Design Systems", "status": "На проекте", "project": "Service Mesh", "location": "Санкт-Петербург", "position": "Designer", "hire_date": "2018-12-09", "department": "Design"}	2026-01-15 20:53:56.8313	2026-01-15 20:53:56.831308
486	Смирнов Роман Тимурович	r.smirnov@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2711", "skills": "Team Leadership, Agile, Risk Management, Jira", "status": "На проекте", "project": "5G инфраструктура", "location": "Москва", "position": "Project Manager", "hire_date": "2017-07-11", "department": "Management"}	2026-01-15 20:53:56.864571	2026-01-15 20:53:56.864578
487	Зайцев Глеб Евгеньевич	g.zaytsev@rt.ru	{"grade": "Junior", "mentor": "Алексеев Артур Евгеньевич", "salary": "672", "skills": "Postman, Performance Testing, Allure, TestNG", "status": "На бенче", "project": "", "location": "Москва", "position": "QA Engineer", "hire_date": "2020-12-18", "department": "QA"}	2026-01-15 20:53:56.905776	2026-01-15 20:53:56.905784
488	Фролова Кристина Юрьевна	k.frolova@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1609", "skills": "Data Visualization, Excel, Clickhouse, Statistics", "status": "В отпуске", "project": "", "location": "Гибрид", "position": "Analyst", "hire_date": "2021-09-15", "department": "Analytics"}	2026-01-15 20:53:56.959317	2026-01-15 20:53:56.959324
489	Смирнов Николай Максимович	n.smirnov@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2377", "skills": "JMeter, JUnit, Automation, TestNG", "status": "На бенче", "project": "", "location": "Москва", "position": "QA Engineer", "hire_date": "2018-03-01", "department": "QA"}	2026-01-15 20:53:57.018856	2026-01-15 20:53:57.018862
490	Белов Максим Романович	m.belov@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3844", "skills": "SQL, Clickhouse, Power BI, Tableau", "status": "На проекте", "project": "DevOps Platform", "location": "Гибрид", "position": "Analyst", "hire_date": "2024-07-30", "department": "Analytics"}	2026-01-15 20:53:57.053742	2026-01-15 20:53:57.053761
491	Сорокина Екатерина Евгеньевна	e.sorokina@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1776", "skills": "A/B Testing, Tableau, ETL, Statistics", "status": "На проекте", "project": "Умный дом Ростелеком", "location": "Санкт-Петербург", "position": "Analyst", "hire_date": "2025-03-05", "department": "Analytics"}	2026-01-15 20:53:57.092141	2026-01-15 20:53:57.092149
492	Сергеев Денис Степанович	d.sergeev@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1336", "skills": "Grafana, Linux, Prometheus, Terraform", "status": "На проекте", "project": "DataLake", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2022-08-01", "department": "DevOps"}	2026-01-15 20:53:57.124379	2026-01-15 20:53:57.124386
493	Михайлова Татьяна Ярославовна	t.mikhaylova@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3833", "skills": "TestNG, API Testing, JMeter, Performance Testing", "status": "На проекте", "project": "B2B личный кабинет", "location": "Москва", "position": "QA Engineer", "hire_date": "2025-10-11", "department": "QA"}	2026-01-15 20:53:57.157568	2026-01-15 20:53:57.157576
494	Ильин Антон Сергеевич	a.ilin@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2752", "skills": "JUnit, Manual Testing, Selenium, JMeter", "status": "На проекте", "project": "Единая биометрическая система", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2021-08-04", "department": "QA"}	2026-01-15 20:53:57.192405	2026-01-15 20:53:57.192412
495	Алексеев Владимир Максимович	v.alekseev@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2508", "skills": "Wireframing, Adobe XD, Sketch, Prototyping", "status": "На проекте", "project": "ML Pipeline", "location": "Москва", "position": "Designer", "hire_date": "2018-08-28", "department": "Design"}	2026-01-15 20:53:57.226973	2026-01-15 20:53:57.226981
496	Новиков Роман Тимурович	r.novikov@rt.ru	{"grade": "Junior", "mentor": "Зайцева Анна Егоровна", "salary": "780", "skills": "Firebase, Flutter, Mobile CI/CD, Kotlin", "status": "На проекте", "project": "Monitoring System", "location": "Удалённо", "position": "Junior Developer", "hire_date": "2024-11-12", "department": "Mobile"}	2026-01-15 20:53:57.257897	2026-01-15 20:53:57.257902
497	Волков Даниил Иванович	d.volkov@rt.ru	{"grade": "Junior", "mentor": "Борисов Михаил Егорович", "salary": "1196", "skills": "React, Next.js, Node.js, Redux", "status": "На проекте", "project": "ML Pipeline", "location": "Москва", "position": "Junior Developer", "hire_date": "2022-03-26", "department": "Frontend"}	2026-01-15 20:53:57.289752	2026-01-15 20:53:57.289759
498	Федоров Артём Ярославович	a.fedorov@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3461", "skills": "Python, Data Visualization, A/B Testing, Power BI", "status": "На проекте", "project": "AI Contact Center", "location": "Удалённо", "position": "Analyst", "hire_date": "2017-06-14", "department": "Analytics"}	2026-01-15 20:53:57.324006	2026-01-15 20:53:57.324061
499	Воробьева Алиса Ивановна	a.vorobeva@rt.ru	{"grade": "Middle", "mentor": "", "salary": "1723", "skills": "React, HTML/CSS, Webpack, JavaScript", "status": "На бенче", "project": "", "location": "Удалённо", "position": "Middle Developer", "hire_date": "2017-08-31", "department": "Frontend"}	2026-01-15 20:53:57.363584	2026-01-15 20:53:57.363592
500	Григорьев Игорь Ильич	i.grigorev@rt.ru	{"grade": "Lead", "mentor": "", "salary": "3773", "skills": "Jira, Risk Management, Team Leadership, Stakeholder Management", "status": "Болеет", "project": "", "location": "Москва", "position": "Project Manager", "hire_date": "2016-07-27", "department": "Management"}	2026-01-15 20:53:57.397312	2026-01-15 20:53:57.397319
501	Фролова Диана Денисовна	d.frolova@rt.ru	{"grade": "Junior", "mentor": "Полякова Анна Дмитриевна", "salary": "1094", "skills": "Stakeholder Management, Jira, Risk Management, Budgeting", "status": "На проекте", "project": "B2B личный кабинет", "location": "Гибрид", "position": "Project Manager", "hire_date": "2020-10-12", "department": "Management"}	2026-01-15 20:53:57.426959	2026-01-15 20:53:57.426966
502	Николаева Александра Константиновна	a.nikolaeva@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2519", "skills": "Wireframing, Figma, Prototyping, Sketch", "status": "На проекте", "project": "Кибербезопасность B2B", "location": "Москва", "position": "Designer", "hire_date": "2019-04-25", "department": "Design"}	2026-01-15 20:53:57.475746	2026-01-15 20:53:57.4758
503	Романов Николай Олегович	n.romanov@rt.ru	{"grade": "Principal", "mentor": "", "salary": "4936", "skills": "GitLab CI, Ansible, Terraform, Prometheus", "status": "На проекте", "project": "Analytics Dashboard", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2018-06-26", "department": "DevOps"}	2026-01-15 20:53:57.515618	2026-01-15 20:53:57.515626
504	Гусев Данил Павлович	d.gusev@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2797", "skills": "Prometheus, GitLab CI, Jenkins, AWS", "status": "На проекте", "project": "Wink платформа", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2020-05-16", "department": "DevOps"}	2026-01-15 20:53:57.562806	2026-01-15 20:53:57.562814
505	Новиков Данил Олегович	d.novikov@rt.ru	{"grade": "Senior", "mentor": "", "salary": "2338", "skills": "AWS, Kubernetes, GitLab CI, Grafana", "status": "На проекте", "project": "5G инфраструктура", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2024-01-20", "department": "DevOps"}	2026-01-15 20:53:57.604164	2026-01-15 20:53:57.604175
509	Орлова Надежда Денисовна	n.orlova@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1661", "skills": "Microservices, Redis, Java, REST API", "status": "На бенче", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (988) 404-34-41, @орлнаде80, n.orlova@rt.ru", "it_block": "Диджитал", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2020-10-28", "recruiter": "Смирнова А.А.", "department": "Backend", "entry_date": "2024-07-27", "resume_link": "https://drive.google.com/file/75739", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "ML Pipeline", "candidate_status": "В работе", "funding_end_date": "2025-12-10", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:57.762685	2026-01-16 12:05:32.945436
511	Захарова Екатерина Романовна	e.zakharova@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Егоров Кирилл Никитич", "salary": "752", "skills": "Kubernetes, Kafka, Redis, PostgreSQL", "status": "На бенче", "project": "", "comments": "", "contacts": "+7 (943) 828-99-68, @захекат32, e.zakharova@rt.ru", "it_block": "B2O", "location": "Гибрид", "position": "Junior Developer", "hire_date": "2024-07-04", "recruiter": "Смирнова А.А.", "department": "Backend", "entry_date": "2025-04-10", "resume_link": "https://drive.google.com/file/75293", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "Mobile App", "candidate_status": "Забронирован", "funding_end_date": "2026-06-03", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:57.860441	2026-01-16 12:05:33.010912
515	Степанов Антон Ярославович	a.stepanov@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "663", "skills": "TestNG, Automation, Allure, Selenium", "status": "На проекте", "project": "AI Contact Center", "comments": "", "contacts": "+7 (908) 329-31-13, @стеанто79, a.stepanov@rt.ru", "it_block": "Эксплуатация", "location": "Гибрид", "position": "QA Engineer", "hire_date": "2023-04-29", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2024-11-09", "resume_link": "https://drive.google.com/file/97831", "ck_department": "Департамент данных", "transfer_date": "2025-11-02", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "DevOps Platform, Banking App, Госуслуги 2.0", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-06-01", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:58.013936	2026-01-16 12:05:33.13812
518	Никитина Ольга Степановна	o.nikitina@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1610", "skills": "Stakeholder Management, Budgeting, Confluence, Team Leadership", "status": "На бенче", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (922) 558-44-78, @никольг99, o.nikitina@rt.ru", "it_block": "B2O", "location": "Удалённо", "position": "Project Manager", "hire_date": "2018-05-02", "recruiter": "Новикова Е.П.", "department": "Management", "entry_date": "2025-09-22", "resume_link": "https://drive.google.com/file/78074", "ck_department": "Департамент данных", "transfer_date": "2026-11-19", "placement_type": "перевод", "current_manager": "Иванов А.П.", "target_projects": "Госуслуги 2.0, ML Pipeline", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-03-15", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:58.108703	2026-01-16 12:05:33.228555
10	Николаев Артём Владимирович	nikolaev@company.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "Сидоров Дмитрий", "salary": 3200, "skills": "Docker, Kubernetes, AWS", "status": "На проекте", "project": "Infrastructure", "comments": "", "contacts": "+7 (980) 229-45-16, @никартё41, nikolaev@company.ru", "it_block": "Развитие", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2022-02-14", "recruiter": "Новикова Е.П.", "department": "DevOps", "entry_date": "2025-09-16", "resume_link": "https://drive.google.com/file/79634", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Banking App, Госуслуги 2.0, ML Pipeline", "candidate_status": "Забронирован", "funding_end_date": "2026-04-23", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 15:53:01.214832	2026-01-16 12:05:33.279749
12	Морозов Максим Денисович	morozov@company.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": 2200, "skills": "Figma, UI/UX, Prototyping", "status": "На проекте", "project": "Mobile App", "comments": "Ожидает оффер", "contacts": "+7 (942) 782-56-36, @мормакс36, morozov@company.ru", "it_block": "B2O", "location": "Удалённо", "position": "Designer", "hire_date": "2021-11-15", "recruiter": "Новикова Е.П.", "department": "Design", "entry_date": "2025-06-19", "resume_link": "https://drive.google.com/file/34437", "ck_department": "ЦК Аналитики", "transfer_date": "2026-05-01", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "ML Pipeline, Data Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-12-13", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 15:53:01.214832	2026-01-16 12:05:33.304287
128	Новиков Роман Алексеевич	mark.fedorov112@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "Petrov M.I.", "salary": "983", "skills": "AWS,Terraform", "status": "На проекте", "project": "Analytics Platform", "comments": "Срочно нужен проект", "contacts": "+7 (900) 797-80-83, @новрома52, mark.fedorov112@company.ru", "it_block": "Эксплуатация", "location": "Санкт-Петербург", "position": "Senior Developer", "hire_date": "2023-09-19", "recruiter": "Новикова Е.П.", "department": "DevOps", "entry_date": "2025-10-14", "resume_link": "https://drive.google.com/file/19262", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-12-12", "placement_type": "перевод", "current_manager": "Иванов А.П.", "target_projects": "Mobile App, Banking App, E-commerce Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-08-06", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:33.676401	2026-01-16 12:05:33.328904
217	Михайлов Андрей Дмитриевич	valid@test.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "status": "На проекте", "comments": "", "contacts": "+7 (941) 159-94-68, @михандр98, valid@test.ru", "it_block": "НУК", "location": "Москва", "position": "Senior Developer", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2024-05-26", "resume_link": "https://drive.google.com/file/43647", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "DevOps Platform", "candidate_status": "Забронирован", "funding_end_date": "2026-10-16", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:31:14.000408	2026-01-16 12:05:33.361514
11	Федорова Елена Андреевна	fedorova@company.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Петрова Мария", "salary": 1500, "skills": "React, JavaScript", "status": "На бенче", "project": "", "comments": "", "contacts": "+7 (917) 905-48-80, @феделен67, fedorova@company.ru", "it_block": "Эксплуатация", "location": "Санкт-Петербург", "position": "Junior Developer", "hire_date": "2024-07-01", "recruiter": "Новикова Е.П.", "department": "Frontend", "entry_date": "2025-08-11", "resume_link": "https://drive.google.com/file/10121", "ck_department": "ЦК Аналитики", "transfer_date": "2025-09-17", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Data Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-11-20", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 15:53:01.214832	2026-01-16 12:05:33.406111
395	Медведев Антон Евгеньевич	a.medvedev@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1512", "skills": "Budgeting, Risk Management, Team Leadership, Agile", "status": "На проекте", "project": "ML Pipeline", "comments": "", "contacts": "+7 (945) 807-32-90, @меданто81, a.medvedev@rt.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2022-06-29", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2024-03-23", "resume_link": "https://drive.google.com/file/11873", "ck_department": "ЦК Аналитики", "transfer_date": "2025-11-05", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "ML Pipeline", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-01-03", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:53.804938	2026-01-16 12:05:33.42915
396	Новиков Евгений Дмитриевич	e.novikov@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1778", "skills": "Clickhouse, SQL, Power BI, Excel", "status": "На проекте", "project": "DevOps Platform", "comments": "", "contacts": "+7 (953) 252-32-68, @новевге29, e.novikov@rt.ru", "it_block": "НУК", "location": "Москва", "position": "Analyst", "hire_date": "2018-10-12", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2024-12-19", "resume_link": "https://drive.google.com/file/90566", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "ML Pipeline, E-commerce Platform", "candidate_status": "Забронирован", "funding_end_date": "2026-12-25", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:53.843476	2026-01-16 12:05:33.449437
219	Лебедев Илья Дмитриевич	i.lebedev@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1773", "skills": "Power BI, ETL, Data Visualization, Statistics", "status": "На проекте", "project": "Госуслуги 2.0", "comments": "Ожидает оффер", "contacts": "+7 (919) 731-65-29, @лебилья31, i.lebedev@rt.ru", "it_block": "Эксплуатация", "location": "Удалённо", "position": "Analyst", "hire_date": "2024-01-04", "recruiter": "Орлов М.С.", "department": "Analytics", "entry_date": "2024-01-01", "resume_link": "https://drive.google.com/file/84820", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Госуслуги 2.0, Mobile App, E-commerce Platform", "candidate_status": "Забронирован", "funding_end_date": "2025-08-28", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:46.472958	2026-01-16 12:05:33.500132
220	Гусев Вадим Максимович	v.gusev@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1865", "skills": "Team Leadership, Kanban, Risk Management, Budgeting", "status": "В отпуске", "project": "", "comments": "", "contacts": "+7 (931) 175-18-60, @гусвади26, v.gusev@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Project Manager", "hire_date": "2018-02-21", "recruiter": "Белова И.Д.", "department": "Management", "entry_date": "2024-10-01", "resume_link": "https://drive.google.com/file/95287", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-01-30", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Data Platform, Mobile App, Banking App", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-07-07", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:46.570696	2026-01-16 12:05:33.542607
223	Григорьева Валерия Юрьевна	v.grigoreva@rt.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2452", "skills": "Kubernetes, AWS, Ansible, Grafana", "status": "На проекте", "project": "Кибербезопасность B2B", "comments": "", "contacts": "+7 (918) 498-93-50, @гривале87, v.grigoreva@rt.ru", "it_block": "Развитие", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2025-04-02", "recruiter": "Белова И.Д.", "department": "DevOps", "entry_date": "2024-10-25", "resume_link": "https://drive.google.com/file/82397", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Data Platform", "candidate_status": "Свободен", "funding_end_date": "2026-04-10", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:46.748814	2026-01-16 12:05:33.628379
224	Николаев Вадим Ильич	v.nikolaev@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1848", "skills": "Figma, UI/UX, Design Systems, Adobe XD", "status": "На проекте", "project": "Service Mesh", "comments": "В процессе согласования", "contacts": "+7 (978) 679-10-77, @никвади85, v.nikolaev@rt.ru", "it_block": "Развитие", "location": "Гибрид", "position": "Designer", "hire_date": "2025-08-08", "recruiter": "Белова И.Д.", "department": "Design", "entry_date": "2024-12-19", "resume_link": "https://drive.google.com/file/52286", "ck_department": "ЦК Разработки", "transfer_date": "2026-08-19", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "ML Pipeline, Data Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-02-26", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:46.788665	2026-01-16 12:05:33.654252
226	Степанов Степан Антонович	s.stepanov@rt.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2377", "skills": "UI/UX, Prototyping, User Research, Design Systems", "status": "На проекте", "project": "CRM Enterprise", "comments": "Срочно нужен проект", "contacts": "+7 (913) 993-73-93, @стестеп56, s.stepanov@rt.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Designer", "hire_date": "2017-01-07", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2024-07-02", "resume_link": "https://drive.google.com/file/39396", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "Mobile App, DevOps Platform", "candidate_status": "Забронирован", "funding_end_date": "2025-02-28", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:46.897606	2026-01-16 12:05:33.676724
227	Фролов Кирилл Дмитриевич	k.frolov@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1795", "skills": "Performance Testing, Manual Testing, JUnit, Selenium", "status": "На проекте", "project": "5G инфраструктура", "comments": "", "contacts": "+7 (957) 760-61-91, @фрокири3, k.frolov@rt.ru", "it_block": "B2O", "location": "Гибрид", "position": "QA Engineer", "hire_date": "2020-06-24", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2025-12-20", "resume_link": "https://drive.google.com/file/52972", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-01-07", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "Data Platform, ML Pipeline", "candidate_status": "Переведен", "funding_end_date": "2025-02-13", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:46.962156	2026-01-16 12:05:33.706184
229	Смирнов Вадим Вадимович	v.smirnov@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Захарова Юлия Марковна", "salary": "988", "skills": "Design Systems, Wireframing, Figma, Adobe XD", "status": "На проекте", "project": "5G инфраструктура", "comments": "Ожидает оффер", "contacts": "+7 (955) 461-57-26, @смивади39, v.smirnov@rt.ru", "it_block": "Развитие", "location": "Санкт-Петербург", "position": "Designer", "hire_date": "2016-12-20", "recruiter": "Смирнова А.А.", "department": "Design", "entry_date": "2025-03-14", "resume_link": "https://drive.google.com/file/11562", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "Infrastructure, Data Platform, Госуслуги 2.0", "candidate_status": "Забронирован", "funding_end_date": "2026-03-17", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:47.056834	2026-01-16 12:05:33.730598
19	Васильев Иван Евгеньевич	nikolay.romanov3@company.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "Ivanov A.S.", "salary": "1219", "skills": "Swift,iOS", "status": "На бенче", "project": "API Gateway", "comments": "", "contacts": "+7 (970) 148-41-65, @васиван57, nikolay.romanov3@company.ru", "it_block": "Развитие", "location": "Москва", "position": "Project Manager", "hire_date": "2021-04-19", "recruiter": "Орлов М.С.", "department": "Frontend", "entry_date": "2025-03-17", "resume_link": "https://drive.google.com/file/54113", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "Infrastructure, Data Platform, Banking App", "candidate_status": "Свободен", "funding_end_date": "2025-03-06", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 18:21:21.807783	2026-01-16 12:05:33.751352
230	Воробьев Данил Тимурович	d.vorobev@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2693", "skills": "Automation, Allure, TestNG, Manual Testing", "status": "На проекте", "project": "DevOps Platform", "comments": "Ожидает оффер", "contacts": "+7 (931) 380-95-29, @вордани18, d.vorobev@rt.ru", "it_block": "НУК", "location": "Москва", "position": "QA Engineer", "hire_date": "2025-05-08", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2024-03-27", "resume_link": "https://drive.google.com/file/28944", "ck_department": "ЦК Разработки", "transfer_date": "2025-11-14", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Infrastructure, Data Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-03-02", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:47.092706	2026-01-16 12:05:33.823974
232	Иванов Дмитрий Денисович	d.ivanov@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1371", "skills": "Next.js, Vue.js, TypeScript, Webpack", "status": "На проекте", "project": "Цифровой офис", "comments": "", "contacts": "+7 (986) 266-97-13, @ивадмит77, d.ivanov@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Middle Developer", "hire_date": "2023-04-21", "recruiter": "Смирнова А.А.", "department": "Frontend", "entry_date": "2024-02-12", "resume_link": "https://drive.google.com/file/90826", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Data Platform, ML Pipeline", "candidate_status": "Свободен", "funding_end_date": "2025-05-24", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:47.191868	2026-01-16 12:05:33.864705
233	Григорьев Александр Маркович	a.grigorev@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Павлов Антон Олегович", "salary": "621", "skills": "Allure, TestNG, API Testing, Manual Testing", "status": "В отпуске", "project": "", "comments": "В процессе согласования", "contacts": "+7 (939) 983-32-22, @гриалек30, a.grigorev@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "QA Engineer", "hire_date": "2024-03-09", "recruiter": "Новикова Е.П.", "department": "QA", "entry_date": "2024-10-29", "resume_link": "https://drive.google.com/file/55301", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "Infrastructure", "candidate_status": "Свободен", "funding_end_date": "2026-04-02", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:47.251292	2026-01-16 12:05:33.901603
235	Петрова Марина Игоревна	m.petrova@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "866", "skills": "Wireframing, Figma, Prototyping, Design Systems", "status": "На проекте", "project": "Monitoring System", "comments": "Срочно нужен проект", "contacts": "+7 (933) 278-11-70, @петмари59, m.petrova@rt.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Designer", "hire_date": "2023-03-20", "recruiter": "Белова И.Д.", "department": "Design", "entry_date": "2025-10-30", "resume_link": "https://drive.google.com/file/73853", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Infrastructure", "candidate_status": "В работе", "funding_end_date": "2026-08-06", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:47.381136	2026-01-16 12:05:33.944844
236	Семенов Данил Кириллович	d.semenov@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Королев Антон Романович", "salary": "1017", "skills": "Redis, Docker, Microservices, Java", "status": "На проекте", "project": "IoT платформа", "comments": "", "contacts": "+7 (955) 721-97-94, @семдани95, d.semenov@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Junior Developer", "hire_date": "2025-09-28", "recruiter": "Орлов М.С.", "department": "Backend", "entry_date": "2025-11-26", "resume_link": "https://drive.google.com/file/85746", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "ML Pipeline", "candidate_status": "Забронирован", "funding_end_date": "2026-11-16", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:47.430637	2026-01-16 12:05:33.975763
237	Виноградова Марина Андреевна	m.vinogradova@rt.ru	{"grade": "Lead", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "3393", "skills": "Prometheus, Kubernetes, Grafana, Ansible", "status": "На проекте", "project": "CRM Enterprise", "comments": "", "contacts": "+7 (983) 649-62-89, @винмари41, m.vinogradova@rt.ru", "it_block": "Прочее", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2016-07-07", "recruiter": "Смирнова А.А.", "department": "DevOps", "entry_date": "2025-04-28", "resume_link": "https://drive.google.com/file/75118", "ck_department": "ЦК Разработки", "transfer_date": "2026-08-15", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Data Platform", "candidate_status": "Переведен", "funding_end_date": "2026-01-23", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:47.490993	2026-01-16 12:05:34.004408
241	Зайцева Кристина Николаевна	k.zaytseva@rt.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2693", "skills": "Java, Microservices, REST API, Redis", "status": "На проекте", "project": "Кибербезопасность B2B", "comments": "", "contacts": "+7 (953) 789-22-17, @зайкрис51, k.zaytseva@rt.ru", "it_block": "Эксплуатация", "location": "Гибрид", "position": "Senior Developer", "hire_date": "2025-09-22", "recruiter": "Орлов М.С.", "department": "Backend", "entry_date": "2025-12-12", "resume_link": "https://drive.google.com/file/13890", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-03-09", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "DevOps Platform, Data Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-08-28", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:47.674632	2026-01-16 12:05:34.297102
242	Тарасов Игорь Денисович	i.tarasov@rt.ru	{"grade": "Principal", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "5421", "skills": "Statistics, ETL, Data Visualization, Excel", "status": "На проекте", "project": "IoT платформа", "comments": "Срочно нужен проект", "contacts": "+7 (952) 243-93-65, @таригор83, i.tarasov@rt.ru", "it_block": "Развитие", "location": "Гибрид", "position": "Analyst", "hire_date": "2020-03-31", "recruiter": "Орлов М.С.", "department": "Analytics", "entry_date": "2025-08-30", "resume_link": "https://drive.google.com/file/80760", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-08-15", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Mobile App, Infrastructure", "candidate_status": "Переведен", "funding_end_date": "2025-06-08", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:47.721807	2026-01-16 12:05:34.467252
144	Фёдоров Сергей Сергеевич	arseny.smirnov128@company.ru	{"grade": "Principal", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1074", "skills": "AWS,Terraform", "status": "На проекте", "project": "Security Audit", "comments": "", "contacts": "+7 (944) 661-35-73, @фёдсерг76, arseny.smirnov128@company.ru", "it_block": "НУК", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2018-03-10", "recruiter": "Новикова Е.П.", "department": "Analytics", "entry_date": "2024-10-18", "resume_link": "https://drive.google.com/file/56042", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-12-16", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Infrastructure, Data Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-11-06", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 18:21:35.392014	2026-01-16 12:05:34.504138
67	Михайлов Андрей Дмитриевич	evgeny.dmitriev51@company.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "Kozlova E.A.", "salary": "1699", "skills": "C#,.NET", "status": "Болеет", "project": "Refactoring", "comments": "Срочно нужен проект", "contacts": "+7 (909) 302-19-19, @михандр44, evgeny.dmitriev51@company.ru", "it_block": "Прочее", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2023-11-08", "recruiter": "Новикова Е.П.", "department": "Management", "entry_date": "2025-11-21", "resume_link": "https://drive.google.com/file/22327", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-07-09", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "Banking App, Госуслуги 2.0, Infrastructure", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-08-10", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 18:21:27.089378	2026-01-16 12:05:34.53845
180	Иванов Александр Александрович	vladimir.borisov164@company.ru	{"grade": "Lead", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2394", "skills": "PostgreSQL,Redis", "status": "Болеет", "project": "Refactoring", "comments": "", "contacts": "+7 (943) 366-27-30, @иваалек67, vladimir.borisov164@company.ru", "it_block": "Прочее", "location": "Санкт-Петербург", "position": "Designer", "hire_date": "2020-10-07", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2024-01-23", "resume_link": "https://drive.google.com/file/82977", "ck_department": "ЦК Разработки", "transfer_date": "2025-05-07", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "E-commerce Platform, DevOps Platform", "candidate_status": "Переведен", "funding_end_date": "2025-10-26", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:39.240703	2026-01-16 12:05:34.565658
260	Козлов Глеб Иванович	g.kozlov@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1398", "skills": "Stakeholder Management, Risk Management, Team Leadership, Kanban", "status": "На проекте", "project": "DataLake", "comments": "", "contacts": "+7 (979) 595-30-98, @козглеб31, g.kozlov@rt.ru", "it_block": "B2O", "location": "Москва", "position": "Project Manager", "hire_date": "2023-10-20", "recruiter": "Белова И.Д.", "department": "Management", "entry_date": "2025-11-05", "resume_link": "https://drive.google.com/file/69688", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "Госуслуги 2.0, Banking App", "candidate_status": "В работе", "funding_end_date": "2026-11-06", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:48.621257	2026-01-16 12:05:34.591311
48	Попов Артём Алексеевич	arthur.borisov32@company.ru	{"grade": "Lead", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2958", "skills": "TypeScript,Vue", "status": "На бенче", "project": "Security Audit", "comments": "Ожидает оффер", "contacts": "+7 (941) 764-79-30, @попартё25, arthur.borisov32@company.ru", "it_block": "B2O", "location": "Удалённо", "position": "Team Lead", "hire_date": "2018-01-26", "recruiter": "Орлов М.С.", "department": "Mobile", "entry_date": "2025-02-15", "resume_link": "https://drive.google.com/file/46972", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "DevOps Platform, Data Platform, Infrastructure", "candidate_status": "В работе", "funding_end_date": "2025-10-29", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:25.061002	2026-01-16 12:05:23.791808
85	Морозов Никита Михайлович	julia.grigoriev69@company.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Sidorov K.V.", "salary": "1019", "skills": "Kotlin,Android", "status": "Болеет", "project": "Data Pipeline", "comments": "", "contacts": "+7 (933) 348-94-68, @морники64, julia.grigoriev69@company.ru", "it_block": "Прочее", "location": "Удалённо", "position": "Senior Developer", "hire_date": "2019-04-18", "recruiter": "Новикова Е.П.", "department": "Analytics", "entry_date": "2024-01-18", "resume_link": "https://drive.google.com/file/21642", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-04-27", "placement_type": "перевод", "current_manager": "Иванов А.П.", "target_projects": "Госуслуги 2.0, Infrastructure", "candidate_status": "Переведен", "funding_end_date": "2025-08-28", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:28.976985	2026-01-16 12:05:23.882456
49	Васильев Иван Евгеньевич	anna.novikov33@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "Petrov M.I.", "salary": "2543", "skills": "TypeScript,Vue", "status": "В отпуске", "project": "Data Pipeline", "comments": "Срочно нужен проект", "contacts": "+7 (976) 980-46-22, @васиван66, anna.novikov33@company.ru", "it_block": "Развитие", "location": "Гибрид", "position": "Senior Developer", "hire_date": "2020-05-07", "recruiter": "Новикова Е.П.", "department": "Management", "entry_date": "2024-02-24", "resume_link": "https://drive.google.com/file/95253", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Data Platform, Banking App", "candidate_status": "Свободен", "funding_end_date": "2026-04-24", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 18:21:25.164719	2026-01-16 12:05:23.937857
263	Козлов Павел Иванович	p.kozlov@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1799", "skills": "Adobe XD, Wireframing, Figma, UI/UX", "status": "На проекте", "project": "Analytics Dashboard", "comments": "Срочно нужен проект", "contacts": "+7 (923) 844-53-65, @козпаве75, p.kozlov@rt.ru", "it_block": "B2O", "location": "Москва", "position": "Designer", "hire_date": "2019-01-22", "recruiter": "Смирнова А.А.", "department": "Design", "entry_date": "2024-10-20", "resume_link": "https://drive.google.com/file/75614", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-07-30", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "Banking App", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-12-20", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:48.784059	2026-01-16 12:05:34.772082
264	Медведева Анна Егоровна	a.medvedeva@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "704", "skills": "Excel, Power BI, A/B Testing, Tableau", "status": "На проекте", "project": "Видеонаблюдение", "comments": "", "contacts": "+7 (991) 469-31-18, @меданна3, a.medvedeva@rt.ru", "it_block": "НУК", "location": "Санкт-Петербург", "position": "Analyst", "hire_date": "2018-10-21", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2025-11-04", "resume_link": "https://drive.google.com/file/61465", "ck_department": "ЦК Аналитики", "transfer_date": "2025-11-17", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "Mobile App, Banking App, Infrastructure", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-11-10", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:48.825624	2026-01-16 12:05:34.795487
24	Фёдоров Сергей Сергеевич	alexander.borisov8@company.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "Petrov M.I.", "salary": "2935", "skills": "Rust,WebAssembly", "status": "Болеет", "project": "Security Audit", "comments": "", "contacts": "+7 (932) 288-30-98, @фёдсерг69, alexander.borisov8@company.ru", "it_block": "Эксплуатация", "location": "Удалённо", "position": "Senior Developer", "hire_date": "2023-09-15", "recruiter": "Белова И.Д.", "department": "Design", "entry_date": "2025-09-17", "resume_link": "https://drive.google.com/file/64483", "ck_department": "ЦК Аналитики", "transfer_date": "2025-02-28", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "Infrastructure, Mobile App", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-04-23", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 18:21:22.324132	2026-01-16 12:05:34.818419
46	Смирнов Илья Владимирович	oleg.morozov30@company.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "Sidorov K.V.", "salary": "1891", "skills": "Node.js,Express", "status": "Болеет", "project": "Data Pipeline", "comments": "", "contacts": "+7 (979) 798-42-14, @смиилья68, oleg.morozov30@company.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Analyst", "hire_date": "2022-11-01", "recruiter": "Новикова Е.П.", "department": "QA", "entry_date": "2024-09-14", "resume_link": "https://drive.google.com/file/18670", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "E-commerce Platform", "candidate_status": "Свободен", "funding_end_date": "2026-07-17", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 18:21:24.844742	2026-01-16 12:05:24.011676
266	Киселев Владимир Антонович	v.kiselev@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2992", "skills": "Team Leadership, Agile, Risk Management, Budgeting", "status": "На проекте", "project": "AI Contact Center", "comments": "В процессе согласования", "contacts": "+7 (900) 137-37-29, @кисвлад38, v.kiselev@rt.ru", "it_block": "Развитие", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2019-08-22", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2024-04-10", "resume_link": "https://drive.google.com/file/65811", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "Infrastructure, Госуслуги 2.0, E-commerce Platform", "candidate_status": "Забронирован", "funding_end_date": "2026-10-10", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:48.918276	2026-01-16 12:05:24.055747
267	Соколов Арсений Павлович	a.sokolov@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Федоров Михаил Иванович", "salary": "1211", "skills": "Spring Boot, PostgreSQL, Kafka, Kubernetes", "status": "На проекте", "project": "IoT платформа", "comments": "", "contacts": "+7 (914) 663-50-55, @сокарсе88, a.sokolov@rt.ru", "it_block": "Эксплуатация", "location": "Санкт-Петербург", "position": "Junior Developer", "hire_date": "2016-03-07", "recruiter": "Новикова Е.П.", "department": "Backend", "entry_date": "2025-07-01", "resume_link": "https://drive.google.com/file/47970", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2026-02-28", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "Data Platform", "candidate_status": "Переведен", "funding_end_date": "2025-11-22", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:48.955849	2026-01-16 12:05:24.109173
268	Лебедева Надежда Романовна	n.lebedeva@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2774", "skills": "Allure, Manual Testing, Selenium, JMeter", "status": "На проекте", "project": "Госуслуги 2.0", "comments": "", "contacts": "+7 (962) 609-82-32, @лебнаде53, n.lebedeva@rt.ru", "it_block": "Диджитал", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2025-02-13", "recruiter": "Белова И.Д.", "department": "QA", "entry_date": "2024-03-29", "resume_link": "https://drive.google.com/file/66196", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "DevOps Platform", "candidate_status": "В работе", "funding_end_date": "2025-05-26", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:49.013032	2026-01-16 12:05:24.15305
270	Григорьева Кристина Никитична	k.grigoreva@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1387", "skills": "Figma, Wireframing, Adobe XD, Prototyping", "status": "На проекте", "project": "CRM Enterprise", "comments": "В процессе согласования", "contacts": "+7 (971) 683-68-53, @грикрис81, k.grigoreva@rt.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Designer", "hire_date": "2021-10-05", "recruiter": "Смирнова А.А.", "department": "Design", "entry_date": "2024-11-22", "resume_link": "https://drive.google.com/file/27320", "ck_department": "ЦК Аналитики", "transfer_date": "2025-10-12", "placement_type": "перевод", "current_manager": "Иванов А.П.", "target_projects": "Infrastructure", "candidate_status": "Переведен", "funding_end_date": "2025-12-13", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:49.119073	2026-01-16 12:05:24.236114
271	Воробьева Валерия Ивановна	v.vorobeva@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1674", "skills": "Firebase, Swift, Mobile CI/CD, Flutter", "status": "На проекте", "project": "5G инфраструктура", "comments": "", "contacts": "+7 (967) 374-22-72, @ворвале50, v.vorobeva@rt.ru", "it_block": "Эксплуатация", "location": "Санкт-Петербург", "position": "Middle Developer", "hire_date": "2018-10-19", "recruiter": "Новикова Е.П.", "department": "Mobile", "entry_date": "2025-10-24", "resume_link": "https://drive.google.com/file/71490", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "Mobile App", "candidate_status": "В работе", "funding_end_date": "2025-12-18", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:49.154207	2026-01-16 12:05:24.271832
273	Киселев Илья Дмитриевич	i.kiselev@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Борисов Егор Денисович", "salary": "994", "skills": "Sketch, Prototyping, UI/UX, Adobe XD", "status": "В отпуске", "project": "", "comments": "", "contacts": "+7 (926) 372-52-79, @кисилья81, i.kiselev@rt.ru", "it_block": "Развитие", "location": "Гибрид", "position": "Designer", "hire_date": "2025-02-02", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2024-08-28", "resume_link": "https://drive.google.com/file/38400", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Data Platform, DevOps Platform, ML Pipeline", "candidate_status": "В работе", "funding_end_date": "2025-04-26", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:49.225715	2026-01-16 12:05:24.371406
275	Дмитриев Михаил Иванович	m.dmitriev@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1997", "skills": "Mobile CI/CD, Swift, Kotlin, React Native", "status": "На проекте", "project": "Цифровой офис", "comments": "В процессе согласования", "contacts": "+7 (946) 595-41-50, @дмимиха86, m.dmitriev@rt.ru", "it_block": "Прочее", "location": "Санкт-Петербург", "position": "Middle Developer", "hire_date": "2025-09-01", "recruiter": "Новикова Е.П.", "department": "Mobile", "entry_date": "2025-02-28", "resume_link": "https://drive.google.com/file/61797", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-08-22", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Mobile App", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-08-24", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:49.300499	2026-01-16 12:05:24.451243
15	Лебедева Наталья Викторовна	lebedeva@company.ru	{"grade": "Lead", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": 4200, "skills": "Swift, Kotlin, Flutter", "status": "На проекте", "project": "Mobile App", "comments": "Ожидает оффер", "contacts": "+7 (906) 510-51-38, @лебната80, lebedeva@company.ru", "it_block": "Прочее", "location": "Москва", "position": "Tech Lead", "hire_date": "2018-05-30", "recruiter": "Белова И.Д.", "department": "Mobile", "entry_date": "2025-03-27", "resume_link": "https://drive.google.com/file/54234", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-07-28", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "E-commerce Platform, DevOps Platform, Mobile App", "candidate_status": "Переведен", "funding_end_date": "2025-09-30", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 15:53:01.214832	2026-01-16 12:05:24.49207
69	Фёдоров Сергей Евгеньевич	dmitry.alexandrov53@company.ru	{"grade": "Principal", "hr_bp": "Лебедева Т.М.", "mentor": "Petrov M.I.", "salary": "2183", "skills": "Kotlin,Android", "status": "Болеет", "project": "", "comments": "Срочно нужен проект", "contacts": "+7 (901) 926-88-14, @фёдсерг44, dmitry.alexandrov53@company.ru", "it_block": "Прочее", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2022-08-10", "recruiter": "Новикова Е.П.", "department": "Design", "entry_date": "2024-05-06", "resume_link": "https://drive.google.com/file/64974", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Infrastructure, Banking App", "candidate_status": "В работе", "funding_end_date": "2025-11-11", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 18:21:27.28977	2026-01-16 12:05:24.564611
89	Семёнов Кирилл Евгеньевич	vladislav.popov73@company.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Petrov M.I.", "salary": "2766", "skills": "TypeScript,Vue", "status": "Болеет", "project": "Infrastructure", "comments": "", "contacts": "+7 (984) 466-82-75, @семкири23, vladislav.popov73@company.ru", "it_block": "Прочее", "location": "Санкт-Петербург", "position": "Team Lead", "hire_date": "2019-03-08", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2024-01-16", "resume_link": "https://drive.google.com/file/35105", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "ML Pipeline", "candidate_status": "Забронирован", "funding_end_date": "2025-02-02", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 18:21:29.429001	2026-01-16 12:05:24.638495
78	Попов Артём Алексеевич	vladislav.fedorov62@company.ru	{"grade": "Lead", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "886", "skills": "Rust,WebAssembly", "status": "На бенче", "project": "ML Platform", "comments": "", "contacts": "+7 (950) 519-82-26, @попартё77, vladislav.fedorov62@company.ru", "it_block": "Развитие", "location": "Удалённо", "position": "Senior Developer", "hire_date": "2021-02-18", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2024-10-30", "resume_link": "https://drive.google.com/file/57383", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Иванов А.П.", "target_projects": "ML Pipeline", "candidate_status": "Забронирован", "funding_end_date": "2025-01-08", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 18:21:28.209675	2026-01-16 12:05:24.680613
77	Кузнецов Денис Дмитриевич	maxim.alexeev61@company.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2294", "skills": "PHP,Laravel", "status": "Болеет", "project": "CRM System", "comments": "", "contacts": "+7 (921) 812-73-86, @куздени61, maxim.alexeev61@company.ru", "it_block": "Развитие", "location": "Удалённо", "position": "Analyst", "hire_date": "2022-03-09", "recruiter": "Новикова Е.П.", "department": "Design", "entry_date": "2025-01-08", "resume_link": "https://drive.google.com/file/91309", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Data Platform, Mobile App, Госуслуги 2.0", "candidate_status": "Свободен", "funding_end_date": "2026-02-10", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:28.112507	2026-01-16 12:05:24.748662
277	Попов Владимир Андреевич	v.popov@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2546", "skills": "Data Visualization, Power BI, Clickhouse, Excel", "status": "На проекте", "project": "CRM Enterprise", "comments": "", "contacts": "+7 (919) 248-61-28, @попвлад31, v.popov@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Analyst", "hire_date": "2016-06-06", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2025-01-14", "resume_link": "https://drive.google.com/file/64019", "ck_department": "ЦК Аналитики", "transfer_date": "2025-09-20", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "Infrastructure", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-08-02", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:49.377917	2026-01-16 12:05:34.913528
280	Ильина Любовь Кирилловна	l.ilina@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1461", "skills": "Excel, Python, Power BI, Statistics", "status": "На проекте", "project": "RT Cloud", "comments": "Срочно нужен проект", "contacts": "+7 (903) 514-92-10, @ильлюбо3, l.ilina@rt.ru", "it_block": "НУК", "location": "Удалённо", "position": "Analyst", "hire_date": "2022-01-09", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2025-06-11", "resume_link": "https://drive.google.com/file/80006", "ck_department": "Департамент данных", "transfer_date": "2025-03-17", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Infrastructure, Госуслуги 2.0, E-commerce Platform", "candidate_status": "Переведен", "funding_end_date": "2026-12-13", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:49.492167	2026-01-16 12:05:34.965582
282	Егоров Артём Маркович	a.egorov@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2591", "skills": "Prometheus, Grafana, Docker, AWS", "status": "На проекте", "project": "Wink платформа", "comments": "Ожидает оффер", "contacts": "+7 (931) 736-23-84, @егоартё42, a.egorov@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2025-03-06", "recruiter": "Белова И.Д.", "department": "DevOps", "entry_date": "2025-04-25", "resume_link": "https://drive.google.com/file/42952", "ck_department": "ЦК Аналитики", "transfer_date": "2025-02-23", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "Banking App, Infrastructure, Госуслуги 2.0", "candidate_status": "Переведен", "funding_end_date": "2026-01-07", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:49.579907	2026-01-16 12:05:34.992855
283	Орлов Егор Русланович	e.orlov@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2896", "skills": "Risk Management, Kanban, Confluence, Agile", "status": "На проекте", "project": "Умный дом Ростелеком", "comments": "В процессе согласования", "contacts": "+7 (963) 914-10-18, @орлегор43, e.orlov@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Project Manager", "hire_date": "2024-01-18", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2024-05-27", "resume_link": "https://drive.google.com/file/28248", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-07-25", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Госуслуги 2.0, Mobile App, ML Pipeline", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-09-19", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:49.622664	2026-01-16 12:05:35.021979
285	Козлов Алексей Андреевич	a.kozlov@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Орлов Артём Иванович", "salary": "838", "skills": "AWS, Jenkins, Docker, Linux", "status": "На проекте", "project": "IoT платформа", "comments": "", "contacts": "+7 (937) 877-33-31, @козалек31, a.kozlov@rt.ru", "it_block": "B2O", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2016-12-28", "recruiter": "Белова И.Д.", "department": "DevOps", "entry_date": "2024-01-08", "resume_link": "https://drive.google.com/file/13000", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Banking App", "candidate_status": "В работе", "funding_end_date": "2026-02-06", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:49.705721	2026-01-16 12:05:35.056168
288	Морозов Владимир Юрьевич	v.morozov@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1833", "skills": "Grafana, AWS, Prometheus, Terraform", "status": "На проекте", "project": "Billing System", "comments": "Ожидает оффер", "contacts": "+7 (968) 558-67-66, @морвлад33, v.morozov@rt.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2020-12-29", "recruiter": "Орлов М.С.", "department": "DevOps", "entry_date": "2024-01-17", "resume_link": "https://drive.google.com/file/78791", "ck_department": "Департамент данных", "transfer_date": "2025-07-16", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Infrastructure", "candidate_status": "Переведен", "funding_end_date": "2026-09-17", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:49.822067	2026-01-16 12:05:35.144294
79	Васильев Иван Евгеньевич	andrey.romanov63@company.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1980", "skills": "PHP,Laravel", "status": "Болеет", "project": "Analytics Platform", "comments": "", "contacts": "+7 (950) 477-32-38, @васиван81, andrey.romanov63@company.ru", "it_block": "B2O", "location": "Гибрид", "position": "Junior Developer", "hire_date": "2022-02-14", "recruiter": "Белова И.Д.", "department": "DevOps", "entry_date": "2025-11-03", "resume_link": "https://drive.google.com/file/93690", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "ML Pipeline, Госуслуги 2.0", "candidate_status": "В работе", "funding_end_date": "2026-06-02", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:28.327387	2026-01-16 12:05:35.178628
83	Новиков Роман Павлович	elena.semenov67@company.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2788", "skills": "TypeScript,Vue", "status": "Болеет", "project": "Security Audit", "comments": "Ожидает оффер", "contacts": "+7 (981) 113-65-96, @новрома1, elena.semenov67@company.ru", "it_block": "Диджитал", "location": "Гибрид", "position": "Team Lead", "hire_date": "2018-07-27", "recruiter": "Новикова Е.П.", "department": "Mobile", "entry_date": "2024-12-15", "resume_link": "https://drive.google.com/file/13868", "ck_department": "ЦК Аналитики", "transfer_date": "2025-09-06", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Mobile App, Госуслуги 2.0, ML Pipeline", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-06-25", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 18:21:28.757316	2026-01-16 12:05:35.207779
103	Лебедев Дмитрий Павлович	daniil.makarov87@company.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "Kozlova E.A.", "salary": "1436", "skills": "PHP,Laravel", "status": "На бенче", "project": "Analytics Platform", "comments": "Срочно нужен проект", "contacts": "+7 (972) 985-16-56, @лебдмит52, daniil.makarov87@company.ru", "it_block": "НУК", "location": "Москва", "position": "QA Engineer", "hire_date": "2022-01-04", "recruiter": "Орлов М.С.", "department": "Frontend", "entry_date": "2024-05-13", "resume_link": "https://drive.google.com/file/12122", "ck_department": "Департамент данных", "transfer_date": "2026-08-01", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "DevOps Platform, Infrastructure", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-05-14", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:30.941129	2026-01-16 12:05:35.236089
94	Васильев Иван Сергеевич	julia.alexandrov78@company.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "Kozlova E.A.", "salary": "1687", "skills": "AWS,Terraform", "status": "В отпуске", "project": "", "comments": "Срочно нужен проект", "contacts": "+7 (987) 456-92-76, @васиван2, julia.alexandrov78@company.ru", "it_block": "Прочее", "location": "Москва", "position": "Designer", "hire_date": "2018-09-03", "recruiter": "Новикова Е.П.", "department": "QA", "entry_date": "2024-11-28", "resume_link": "https://drive.google.com/file/82087", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "Data Platform, Infrastructure", "candidate_status": "Забронирован", "funding_end_date": "2025-05-05", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 18:21:30.01144	2026-01-16 12:05:35.264094
113	Новиков Роман Павлович	igor.dmitriev97@company.ru	{"grade": "Principal", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1135", "skills": "Swift,iOS", "status": "Болеет", "project": "Data Pipeline", "comments": "В процессе согласования", "contacts": "+7 (949) 358-37-62, @новрома43, igor.dmitriev97@company.ru", "it_block": "Прочее", "location": "Москва", "position": "Project Manager", "hire_date": "2020-11-13", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2024-12-06", "resume_link": "https://drive.google.com/file/99016", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "E-commerce Platform, Banking App, Infrastructure", "candidate_status": "Свободен", "funding_end_date": "2026-04-29", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:32.054509	2026-01-16 12:05:35.292384
121	Смирнов Илья Андреевич	timur.petrov105@company.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2955", "skills": "PHP,Laravel", "status": "Болеет", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (911) 282-41-48, @смиилья84, timur.petrov105@company.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "Tech Lead", "hire_date": "2018-09-22", "recruiter": "Новикова Е.П.", "department": "Mobile", "entry_date": "2024-08-02", "resume_link": "https://drive.google.com/file/72509", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "DevOps Platform, E-commerce Platform, Data Platform", "candidate_status": "Свободен", "funding_end_date": "2025-02-23", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:32.942863	2026-01-16 12:05:35.345212
313	Полякова Ольга Юрьевна	o.polyakova@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2943", "skills": "A/B Testing, Tableau, Clickhouse, Python", "status": "В отпуске", "project": "", "comments": "Срочно нужен проект", "contacts": "+7 (978) 950-53-48, @полольг13, o.polyakova@rt.ru", "it_block": "НУК", "location": "Москва", "position": "Analyst", "hire_date": "2025-06-08", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2024-08-15", "resume_link": "https://drive.google.com/file/18092", "ck_department": "ЦК Аналитики", "transfer_date": "2026-07-08", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "DevOps Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-12-22", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:50.723083	2026-01-16 12:05:35.371068
314	Лебедева Анастасия Романовна	a.lebedeva@rt.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2706", "skills": "Power BI, Statistics, ETL, SQL", "status": "На проекте", "project": "Mobile App", "comments": "Ожидает оффер", "contacts": "+7 (997) 272-53-13, @лебанас51, a.lebedeva@rt.ru", "it_block": "НУК", "location": "Санкт-Петербург", "position": "Analyst", "hire_date": "2021-01-30", "recruiter": "Орлов М.С.", "department": "Analytics", "entry_date": "2024-05-22", "resume_link": "https://drive.google.com/file/63274", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2026-11-03", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "Infrastructure, Banking App", "candidate_status": "Переведен", "funding_end_date": "2026-12-25", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:50.776698	2026-01-16 12:05:35.396455
315	Виноградова Юлия Александровна	yu.vinogradova@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Ковалева Александра Павловна", "salary": "869", "skills": "Clickhouse, Data Visualization, Statistics, Excel", "status": "В отпуске", "project": "", "comments": "В процессе согласования", "contacts": "+7 (927) 605-74-38, @винюлия25, yu.vinogradova@rt.ru", "it_block": "НУК", "location": "Москва", "position": "Analyst", "hire_date": "2017-02-14", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2025-12-19", "resume_link": "https://drive.google.com/file/61146", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-01-23", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "DevOps Platform, Infrastructure", "candidate_status": "Переведен", "funding_end_date": "2025-05-31", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:50.812457	2026-01-16 12:05:35.424458
316	Яковлева Виктория Михайловна	v.yakovleva@rt.ru	{"grade": "Principal", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "5442", "skills": "Scrum, Budgeting, Agile, Team Leadership", "status": "На проекте", "project": "Техподдержка 3.0", "comments": "", "contacts": "+7 (969) 659-67-15, @яковикт70, v.yakovleva@rt.ru", "it_block": "Развитие", "location": "Москва", "position": "Project Manager", "hire_date": "2024-07-30", "recruiter": "Белова И.Д.", "department": "Management", "entry_date": "2024-08-19", "resume_link": "https://drive.google.com/file/93135", "ck_department": "ЦК Разработки", "transfer_date": "2026-09-22", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Mobile App", "candidate_status": "Переведен", "funding_end_date": "2025-03-15", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:50.840293	2026-01-16 12:05:35.44684
318	Григорьев Матвей Николаевич	m.grigorev@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1941", "skills": "Grafana, Linux, GitLab CI, Terraform", "status": "На бенче", "project": "", "comments": "Срочно нужен проект", "contacts": "+7 (961) 927-48-93, @гриматв4, m.grigorev@rt.ru", "it_block": "Прочее", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2022-07-07", "recruiter": "Смирнова А.А.", "department": "DevOps", "entry_date": "2025-10-07", "resume_link": "https://drive.google.com/file/96971", "ck_department": "Департамент данных", "transfer_date": "2026-12-14", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Госуслуги 2.0, Data Platform", "candidate_status": "Переведен", "funding_end_date": "2026-03-14", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:50.917506	2026-01-16 12:05:35.473505
321	Никитина Виктория Марковна	v.nikitina@rt.ru	{"grade": "Lead", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "3464", "skills": "Excel, SQL, Data Visualization, ETL", "status": "На проекте", "project": "DevOps Platform", "comments": "В процессе согласования", "contacts": "+7 (988) 671-58-19, @никвикт64, v.nikitina@rt.ru", "it_block": "Диджитал", "location": "Удалённо", "position": "Analyst", "hire_date": "2017-06-22", "recruiter": "Орлов М.С.", "department": "Analytics", "entry_date": "2024-02-13", "resume_link": "https://drive.google.com/file/37610", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "Госуслуги 2.0, Mobile App, Banking App", "candidate_status": "Свободен", "funding_end_date": "2026-08-22", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.013646	2026-01-16 12:05:35.523745
322	Андреева Ирина Константиновна	i.andreeva@rt.ru	{"grade": "Principal", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "4903", "skills": "Mobile CI/CD, Swift, iOS SDK, Flutter", "status": "На проекте", "project": "ML Pipeline", "comments": "", "contacts": "+7 (966) 507-95-57, @андирин44, i.andreeva@rt.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Tech Lead", "hire_date": "2018-12-29", "recruiter": "Орлов М.С.", "department": "Mobile", "entry_date": "2025-06-13", "resume_link": "https://drive.google.com/file/58490", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "Banking App", "candidate_status": "Свободен", "funding_end_date": "2025-04-11", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:51.070477	2026-01-16 12:05:35.545494
324	Киселев Евгений Евгеньевич	e.kiselev@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1738", "skills": "Stakeholder Management, Risk Management, Confluence, Team Leadership", "status": "На проекте", "project": "AI Contact Center", "comments": "", "contacts": "+7 (916) 871-65-89, @кисевге56, e.kiselev@rt.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Project Manager", "hire_date": "2022-09-13", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2025-08-17", "resume_link": "https://drive.google.com/file/15689", "ck_department": "ЦК Аналитики", "transfer_date": "2026-05-31", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Banking App, DevOps Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-03-18", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.167516	2026-01-16 12:05:35.567976
119	Семёнов Кирилл Евгеньевич	petr.korolev103@company.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1629", "skills": "AWS,Terraform", "status": "На бенче", "project": "ML Platform", "comments": "В процессе согласования", "contacts": "+7 (952) 217-52-53, @семкири51, petr.korolev103@company.ru", "it_block": "Диджитал", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2021-03-04", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2025-03-28", "resume_link": "https://drive.google.com/file/97306", "ck_department": "ЦК Аналитики", "transfer_date": "2026-01-31", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "E-commerce Platform", "candidate_status": "Переведен", "funding_end_date": "2026-01-10", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 18:21:32.731934	2026-01-16 12:05:35.598586
136	Смирнов Илья Владимирович	denis.sokolov120@company.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2004", "skills": "AWS,Terraform", "status": "На бенче", "project": "ML Platform", "comments": "", "contacts": "+7 (942) 796-70-77, @смиилья59, denis.sokolov120@company.ru", "it_block": "B2O", "location": "Удалённо", "position": "Designer", "hire_date": "2018-10-11", "recruiter": "Орлов М.С.", "department": "Frontend", "entry_date": "2025-03-31", "resume_link": "https://drive.google.com/file/56674", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "ML Pipeline", "candidate_status": "Забронирован", "funding_end_date": "2025-06-09", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:34.542266	2026-01-16 12:05:35.625599
327	Белова Елена Романовна	e.belova@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1728", "skills": "Selenium, Allure, JMeter, Performance Testing", "status": "На проекте", "project": "Mobile App", "comments": "", "contacts": "+7 (979) 700-67-45, @белелен65, e.belova@rt.ru", "it_block": "Развитие", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2017-01-06", "recruiter": "Белова И.Д.", "department": "QA", "entry_date": "2024-08-09", "resume_link": "https://drive.google.com/file/35351", "ck_department": "ЦК Разработки", "transfer_date": "2026-09-17", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "Infrastructure, DevOps Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-09-16", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.290909	2026-01-16 12:05:35.746092
328	Захаров Богдан Ярославович	b.zakharov@rt.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Тарасова Любовь Алексеевна", "salary": "842", "skills": "Power BI, Tableau, Clickhouse, A/B Testing", "status": "На проекте", "project": "Техподдержка 3.0", "comments": "", "contacts": "+7 (959) 437-28-12, @захбогд81, b.zakharov@rt.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "Analyst", "hire_date": "2021-05-06", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2024-04-10", "resume_link": "https://drive.google.com/file/38625", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "перевод", "current_manager": "Иванов А.П.", "target_projects": "Infrastructure", "candidate_status": "Забронирован", "funding_end_date": "2025-04-06", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.34462	2026-01-16 12:05:35.785701
114	Фёдоров Сергей Сергеевич	yaroslav.pavlov98@company.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2263", "skills": "C#,.NET", "status": "На бенче", "project": "Refactoring", "comments": "Ожидает оффер", "contacts": "+7 (954) 831-37-47, @фёдсерг41, yaroslav.pavlov98@company.ru", "it_block": "Прочее", "location": "Гибрид", "position": "Project Manager", "hire_date": "2019-06-20", "recruiter": "Новикова Е.П.", "department": "Frontend", "entry_date": "2024-12-17", "resume_link": "https://drive.google.com/file/39769", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Data Platform", "candidate_status": "Забронирован", "funding_end_date": "2025-12-09", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 18:21:32.170873	2026-01-16 12:05:35.818104
116	Волков Максим Владимирович	ruslan.zakharov100@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "Sidorov K.V.", "salary": "1120", "skills": "Go,gRPC", "status": "Болеет", "project": "Analytics Platform", "comments": "", "contacts": "+7 (926) 415-64-71, @волмакс13, ruslan.zakharov100@company.ru", "it_block": "Эксплуатация", "location": "Гибрид", "position": "Project Manager", "hire_date": "2023-11-01", "recruiter": "Орлов М.С.", "department": "QA", "entry_date": "2025-05-21", "resume_link": "https://drive.google.com/file/86334", "ck_department": "ЦК Разработки", "transfer_date": "2026-03-14", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "E-commerce Platform, Data Platform, DevOps Platform", "candidate_status": "Переведен", "funding_end_date": "2026-09-01", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 18:21:32.407277	2026-01-16 12:05:35.852172
329	Воробьев Марк Сергеевич	m.vorobev@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2422", "skills": "Selenium, Manual Testing, JUnit, Allure", "status": "На бенче", "project": "", "comments": "", "contacts": "+7 (961) 822-46-23, @вормарк93, m.vorobev@rt.ru", "it_block": "НУК", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2024-09-11", "recruiter": "Новикова Е.П.", "department": "QA", "entry_date": "2024-09-06", "resume_link": "https://drive.google.com/file/55307", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Banking App, Infrastructure, Data Platform", "candidate_status": "Свободен", "funding_end_date": "2026-01-19", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.406349	2026-01-16 12:05:35.880131
137	Кузнецов Денис Дмитриевич	ilya.ivanov121@company.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1752", "skills": "Node.js,Express", "status": "На бенче", "project": "CRM System", "comments": "", "contacts": "+7 (907) 795-81-87, @куздени59, ilya.ivanov121@company.ru", "it_block": "Развитие", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2023-03-19", "recruiter": "Новикова Е.П.", "department": "DevOps", "entry_date": "2024-02-14", "resume_link": "https://drive.google.com/file/14434", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Госуслуги 2.0", "candidate_status": "В работе", "funding_end_date": "2025-09-02", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:34.638764	2026-01-16 12:05:35.903259
330	Зайцев Алексей Тимурович	a.zaytsev@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2332", "skills": "Figma, Design Systems, UI/UX, Adobe XD", "status": "Болеет", "project": "", "comments": "", "contacts": "+7 (978) 258-56-16, @зайалек3, a.zaytsev@rt.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "Designer", "hire_date": "2021-12-29", "recruiter": "Новикова Е.П.", "department": "Design", "entry_date": "2025-05-22", "resume_link": "https://drive.google.com/file/96591", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Госуслуги 2.0, E-commerce Platform", "candidate_status": "В работе", "funding_end_date": "2025-10-01", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:51.457173	2026-01-16 12:05:35.969782
332	Смирнова Алина Кирилловна	a.smirnova@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Полякова Екатерина Степановна", "salary": "916", "skills": "Next.js, Node.js, TypeScript, Vue.js", "status": "На проекте", "project": "Цифровой офис", "comments": "Срочно нужен проект", "contacts": "+7 (993) 877-51-40, @смиалин74, a.smirnova@rt.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "Junior Developer", "hire_date": "2022-03-10", "recruiter": "Белова И.Д.", "department": "Frontend", "entry_date": "2025-07-10", "resume_link": "https://drive.google.com/file/48066", "ck_department": "Департамент данных", "transfer_date": "2026-05-27", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Госуслуги 2.0, Mobile App, DevOps Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-09-29", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:51.542467	2026-01-16 12:05:36.001119
334	Захаров Александр Михайлович	a.zakharov@rt.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Макаров Марк Игоревич", "salary": "1253", "skills": "Python, A/B Testing, Excel, Data Visualization", "status": "На проекте", "project": "Mobile App", "comments": "", "contacts": "+7 (933) 760-27-81, @захалек63, a.zakharov@rt.ru", "it_block": "НУК", "location": "Санкт-Петербург", "position": "Analyst", "hire_date": "2019-12-20", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2025-10-18", "resume_link": "https://drive.google.com/file/62760", "ck_department": "ЦК Аналитики", "transfer_date": "2026-12-30", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "ML Pipeline, Госуслуги 2.0, DevOps Platform", "candidate_status": "Переведен", "funding_end_date": "2025-09-15", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.596137	2026-01-16 12:05:36.036287
336	Тарасова Ксения Ильинична	k.tarasova@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1886", "skills": "Prometheus, Ansible, Kubernetes, Grafana", "status": "На проекте", "project": "RT Cloud", "comments": "", "contacts": "+7 (936) 643-43-49, @тарксен20, k.tarasova@rt.ru", "it_block": "B2O", "location": "Гибрид", "position": "DevOps Engineer", "hire_date": "2021-12-18", "recruiter": "Белова И.Д.", "department": "DevOps", "entry_date": "2024-01-20", "resume_link": "https://drive.google.com/file/91074", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-06-25", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-03-07", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:51.67905	2026-01-16 12:05:36.066237
337	Медведев Антон Олегович	a.medvedev@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1984", "skills": "API Testing, Allure, JMeter, JUnit", "status": "На проекте", "project": "API Gateway", "comments": "Срочно нужен проект", "contacts": "+7 (997) 883-67-97, @меданто62, a.medvedev@rt.ru", "it_block": "B2O", "location": "Москва", "position": "QA Engineer", "hire_date": "2019-12-29", "recruiter": "Орлов М.С.", "department": "QA", "entry_date": "2025-01-20", "resume_link": "https://drive.google.com/file/54482", "ck_department": "Департамент данных", "transfer_date": "2026-04-02", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Mobile App", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-05-22", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.709899	2026-01-16 12:05:36.095846
339	Антонов Степан Игоревич	s.antonov@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1692", "skills": "Kotlin, Firebase, Swift, Flutter", "status": "На бенче", "project": "", "comments": "", "contacts": "+7 (906) 892-82-44, @антстеп78, s.antonov@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Middle Developer", "hire_date": "2022-07-24", "recruiter": "Новикова Е.П.", "department": "Mobile", "entry_date": "2024-12-24", "resume_link": "https://drive.google.com/file/24090", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Infrastructure, Mobile App, Data Platform", "candidate_status": "Забронирован", "funding_end_date": "2025-10-02", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:51.7706	2026-01-16 12:05:36.138556
342	Виноградова Мария Ивановна	m.vinogradova@rt.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2419", "skills": "Jenkins, Grafana, Ansible, GitLab CI", "status": "На проекте", "project": "API Gateway", "comments": "", "contacts": "+7 (977) 488-39-97, @винмари86, m.vinogradova@rt.ru", "it_block": "НУК", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2023-09-04", "recruiter": "Орлов М.С.", "department": "DevOps", "entry_date": "2025-01-22", "resume_link": "https://drive.google.com/file/22087", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Infrastructure", "candidate_status": "Забронирован", "funding_end_date": "2026-09-16", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.911432	2026-01-16 12:05:36.209796
343	Николаев Антон Олегович	a.nikolaev@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2432", "skills": "Python, A/B Testing, Tableau, Excel", "status": "На проекте", "project": "Mobile App", "comments": "Срочно нужен проект", "contacts": "+7 (980) 787-31-88, @никанто7, a.nikolaev@rt.ru", "it_block": "Эксплуатация", "location": "Удалённо", "position": "Analyst", "hire_date": "2025-09-08", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2024-09-14", "resume_link": "https://drive.google.com/file/28046", "ck_department": "Департамент данных", "transfer_date": "2025-01-02", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "E-commerce Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-11-05", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.967285	2026-01-16 12:05:36.240455
344	Антонова Татьяна Николаевна	t.antonova@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1772", "skills": "Team Leadership, Confluence, Jira, Risk Management", "status": "На бенче", "project": "", "comments": "Срочно нужен проект", "contacts": "+7 (904) 794-58-42, @анттать1, t.antonova@rt.ru", "it_block": "B2O", "location": "Удалённо", "position": "Project Manager", "hire_date": "2025-07-17", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2025-09-25", "resume_link": "https://drive.google.com/file/81837", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-02-22", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Infrastructure, Госуслуги 2.0", "candidate_status": "Переведен", "funding_end_date": "2025-07-26", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:52.000837	2026-01-16 12:05:36.269123
363	Лебедева Анна Ивановна	a.lebedeva@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Гусев Тимофей Максимович", "salary": "1218", "skills": "Java, Kafka, Kubernetes, Microservices", "status": "В отпуске", "project": "", "comments": "Срочно нужен проект", "contacts": "+7 (964) 546-96-53, @лебанна39, a.lebedeva@rt.ru", "it_block": "Развитие", "location": "Гибрид", "position": "Junior Developer", "hire_date": "2020-02-14", "recruiter": "Новикова Е.П.", "department": "Backend", "entry_date": "2024-11-07", "resume_link": "https://drive.google.com/file/17251", "ck_department": "ЦК Аналитики", "transfer_date": "2025-03-01", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "E-commerce Platform, Infrastructure, Госуслуги 2.0", "candidate_status": "Переведен", "funding_end_date": "2025-09-24", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:52.666392	2026-01-16 12:05:36.298693
364	Борисова Валерия Ивановна	v.borisova@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1466", "skills": "Clickhouse, Statistics, Tableau, Python", "status": "На проекте", "project": "Wink платформа", "comments": "", "contacts": "+7 (962) 484-94-97, @борвале91, v.borisova@rt.ru", "it_block": "B2O", "location": "Гибрид", "position": "Analyst", "hire_date": "2020-05-21", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2025-03-20", "resume_link": "https://drive.google.com/file/59057", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-06-12", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "ML Pipeline, Data Platform, Госуслуги 2.0", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-04-15", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:52.699782	2026-01-16 12:05:36.324764
172	Михайлов Андрей Иванович	tatiana.sergeev156@company.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Ivanov A.S.", "salary": "2843", "skills": "Rust,WebAssembly", "status": "В отпуске", "project": "Mobile App", "comments": "", "contacts": "+7 (996) 856-98-93, @михандр50, tatiana.sergeev156@company.ru", "it_block": "НУК", "location": "Гибрид", "position": "QA Engineer", "hire_date": "2020-05-24", "recruiter": "Смирнова А.А.", "department": "Design", "entry_date": "2024-01-24", "resume_link": "https://drive.google.com/file/71772", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "Госуслуги 2.0, Data Platform", "candidate_status": "Забронирован", "funding_end_date": "2025-11-02", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:38.375867	2026-01-16 12:05:36.346543
176	Волков Максим Владимирович	nikita.frolov160@company.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "Novikova O.P.", "salary": "2761", "skills": "Ruby,Rails", "status": "В отпуске", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (901) 572-69-12, @волмакс54, nikita.frolov160@company.ru", "it_block": "НУК", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2018-04-03", "recruiter": "Смирнова А.А.", "department": "Design", "entry_date": "2024-08-06", "resume_link": "https://drive.google.com/file/54075", "ck_department": "ЦК Разработки", "transfer_date": "2025-03-01", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "DevOps Platform, Mobile App, E-commerce Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-04-20", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:38.821575	2026-01-16 12:05:27.489044
365	Алексеева Екатерина Егоровна	e.alekseeva@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Егоров Кирилл Игоревич", "salary": "619", "skills": "Kotlin, Mobile CI/CD, Swift, iOS SDK", "status": "На проекте", "project": "ML Pipeline", "comments": "В процессе согласования", "contacts": "+7 (939) 145-78-72, @алеекат51, e.alekseeva@rt.ru", "it_block": "Диджитал", "location": "Гибрид", "position": "Junior Developer", "hire_date": "2022-12-17", "recruiter": "Белова И.Д.", "department": "Mobile", "entry_date": "2025-05-06", "resume_link": "https://drive.google.com/file/62104", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline", "candidate_status": "Забронирован", "funding_end_date": "2025-01-17", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:52.734449	2026-01-16 12:05:27.520653
367	Михайлова Дарья Антоновна	d.mikhaylova@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1817", "skills": "Tableau, Data Visualization, Python, Clickhouse", "status": "На проекте", "project": "Единая биометрическая система", "comments": "", "contacts": "+7 (935) 404-12-57, @михдарь59, d.mikhaylova@rt.ru", "it_block": "Развитие", "location": "Москва", "position": "Analyst", "hire_date": "2018-04-23", "recruiter": "Орлов М.С.", "department": "Analytics", "entry_date": "2024-04-05", "resume_link": "https://drive.google.com/file/37630", "ck_department": "ЦК Аналитики", "transfer_date": "2025-02-15", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Госуслуги 2.0", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-12-28", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:52.79477	2026-01-16 12:05:27.609495
369	Воробьев Артём Антонович	a.vorobev@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Тарасова Александра Николаевна", "salary": "1183", "skills": "Scrum, Confluence, Budgeting, Agile", "status": "На проекте", "project": "Billing System", "comments": "Срочно нужен проект", "contacts": "+7 (936) 531-99-92, @ворартё90, a.vorobev@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Project Manager", "hire_date": "2023-10-15", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2024-04-27", "resume_link": "https://drive.google.com/file/30972", "ck_department": "ЦК Разработки", "transfer_date": "2026-12-19", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Banking App", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-10-08", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:52.855511	2026-01-16 12:05:27.675005
370	Сорокин Кирилл Максимович	k.sorokin@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1905", "skills": "Ansible, GitLab CI, Terraform, Docker", "status": "На проекте", "project": "Service Mesh", "comments": "", "contacts": "+7 (998) 738-68-46, @соркири92, k.sorokin@rt.ru", "it_block": "Развитие", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2021-11-11", "recruiter": "Орлов М.С.", "department": "DevOps", "entry_date": "2024-03-29", "resume_link": "https://drive.google.com/file/28811", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-11-21", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "DevOps Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-09-14", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:52.882856	2026-01-16 12:05:27.723943
372	Николаев Савелий Алексеевич	s.nikolaev@rt.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1066", "skills": "Clickhouse, ETL, Power BI, Tableau", "status": "На бенче", "project": "", "comments": "", "contacts": "+7 (937) 883-77-21, @никсаве14, s.nikolaev@rt.ru", "it_block": "B2O", "location": "Удалённо", "position": "Analyst", "hire_date": "2019-05-16", "recruiter": "Новикова Е.П.", "department": "Analytics", "entry_date": "2024-05-04", "resume_link": "https://drive.google.com/file/67039", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Mobile App, DevOps Platform", "candidate_status": "Забронирован", "funding_end_date": "2026-01-23", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:52.945699	2026-01-16 12:05:27.818783
374	Волкова Диана Кирилловна	d.volkova@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1657", "skills": "Swift, Firebase, Android SDK, React Native", "status": "На проекте", "project": "DataLake", "comments": "Срочно нужен проект", "contacts": "+7 (981) 665-39-18, @волдиан71, d.volkova@rt.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "Middle Developer", "hire_date": "2018-03-30", "recruiter": "Новикова Е.П.", "department": "Mobile", "entry_date": "2025-04-08", "resume_link": "https://drive.google.com/file/89656", "ck_department": "ЦК Аналитики", "transfer_date": "2025-01-21", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "Госуслуги 2.0, Mobile App", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-04-25", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:52.995459	2026-01-16 12:05:27.901003
375	Волкова Ольга Тимуровна	o.volkova@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Александров Максим Русланович", "salary": "887", "skills": "React Native, Flutter, Swift, Mobile CI/CD", "status": "На проекте", "project": "AI Contact Center", "comments": "", "contacts": "+7 (991) 648-88-12, @волольг98, o.volkova@rt.ru", "it_block": "Прочее", "location": "Санкт-Петербург", "position": "Junior Developer", "hire_date": "2017-04-21", "recruiter": "Орлов М.С.", "department": "Mobile", "entry_date": "2024-09-15", "resume_link": "https://drive.google.com/file/80911", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Infrastructure, DevOps Platform", "candidate_status": "В работе", "funding_end_date": "2025-11-17", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:53.039465	2026-01-16 12:05:27.952615
377	Фролов Вадим Михайлович	v.frolov@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1715", "skills": "Adobe XD, Prototyping, User Research, UI/UX", "status": "На проекте", "project": "Analytics Dashboard", "comments": "Срочно нужен проект", "contacts": "+7 (923) 726-95-86, @фровади45, v.frolov@rt.ru", "it_block": "Развитие", "location": "Москва", "position": "Designer", "hire_date": "2017-10-06", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2025-07-18", "resume_link": "https://drive.google.com/file/19371", "ck_department": "Департамент данных", "transfer_date": "2026-04-09", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "Infrastructure", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-06-03", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:53.142525	2026-01-16 12:05:28.030265
378	Кузьмина Ксения Дмитриевна	k.kuzmina@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1780", "skills": "Statistics, ETL, A/B Testing, Python", "status": "На проекте", "project": "Госуслуги 2.0", "comments": "", "contacts": "+7 (988) 418-92-36, @кузксен54, k.kuzmina@rt.ru", "it_block": "Эксплуатация", "location": "Удалённо", "position": "Analyst", "hire_date": "2020-03-17", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2024-09-05", "resume_link": "https://drive.google.com/file/91828", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-01-25", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "Infrastructure", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-07-23", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:53.202532	2026-01-16 12:05:28.064314
382	Королева Яна Сергеевна	ya.koroleva@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1343", "skills": "iOS SDK, Flutter, Firebase, Android SDK", "status": "На проекте", "project": "ML Pipeline", "comments": "Срочно нужен проект", "contacts": "+7 (921) 840-15-30, @коряна22, ya.koroleva@rt.ru", "it_block": "B2O", "location": "Удалённо", "position": "Middle Developer", "hire_date": "2020-04-27", "recruiter": "Новикова Е.П.", "department": "Mobile", "entry_date": "2024-04-27", "resume_link": "https://drive.google.com/file/22112", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "Mobile App, Infrastructure, Госуслуги 2.0", "candidate_status": "Свободен", "funding_end_date": "2026-01-03", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:53.360715	2026-01-16 12:05:36.418448
383	Фролова Ксения Игоревна	k.frolova@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2629", "skills": "Automation, Postman, API Testing, Manual Testing", "status": "На проекте", "project": "Mobile App", "comments": "", "contacts": "+7 (905) 496-92-79, @фроксен59, k.frolova@rt.ru", "it_block": "Эксплуатация", "location": "Гибрид", "position": "QA Engineer", "hire_date": "2022-01-03", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2025-09-29", "resume_link": "https://drive.google.com/file/43834", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-03-10", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "Госуслуги 2.0, Data Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-07-22", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:53.403367	2026-01-16 12:05:36.445363
384	Зайцева Галина Константиновна	g.zaytseva@rt.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2927", "skills": "gRPC, Spring Boot, Kafka, Microservices", "status": "На проекте", "project": "DataLake", "comments": "Срочно нужен проект", "contacts": "+7 (908) 998-72-61, @зайгали40, g.zaytseva@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Senior Developer", "hire_date": "2018-01-26", "recruiter": "Новикова Е.П.", "department": "Backend", "entry_date": "2024-11-15", "resume_link": "https://drive.google.com/file/80548", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-09-05", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Banking App", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-01-21", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:53.459939	2026-01-16 12:05:36.466159
387	Никитина Людмила Олеговна	l.nikitina@rt.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Михайлов Владимир Денисович", "salary": "669", "skills": "Stakeholder Management, Team Leadership, Scrum, Confluence", "status": "На проекте", "project": "AI Contact Center", "comments": "Ожидает оффер", "contacts": "+7 (947) 930-83-56, @никлюдм30, l.nikitina@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Project Manager", "hire_date": "2025-10-29", "recruiter": "Белова И.Д.", "department": "Management", "entry_date": "2024-02-18", "resume_link": "https://drive.google.com/file/47586", "ck_department": "Департамент данных", "transfer_date": "2026-05-11", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Mobile App", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-11-27", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:53.575784	2026-01-16 12:05:36.519756
389	Попов Илья Олегович	i.popov@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1390", "skills": "Budgeting, Confluence, Stakeholder Management, Team Leadership", "status": "Болеет", "project": "", "comments": "В процессе согласования", "contacts": "+7 (997) 462-12-13, @попилья44, i.popov@rt.ru", "it_block": "B2O", "location": "Гибрид", "position": "Project Manager", "hire_date": "2024-04-18", "recruiter": "Новикова Е.П.", "department": "Management", "entry_date": "2024-06-03", "resume_link": "https://drive.google.com/file/41563", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "Data Platform, Mobile App", "candidate_status": "Свободен", "funding_end_date": "2025-05-11", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:53.652555	2026-01-16 12:05:36.54775
391	Киселева Анастасия Сергеевна	a.kiseleva@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1704", "skills": "Stakeholder Management, Agile, Risk Management, Budgeting", "status": "На проекте", "project": "5G инфраструктура", "comments": "", "contacts": "+7 (958) 650-97-50, @кисанас39, a.kiseleva@rt.ru", "it_block": "Прочее", "location": "Гибрид", "position": "Project Manager", "hire_date": "2016-01-28", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2025-11-01", "resume_link": "https://drive.google.com/file/57103", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "Infrastructure", "candidate_status": "Свободен", "funding_end_date": "2026-11-06", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:53.7058	2026-01-16 12:05:36.577007
392	Федоров Марк Ярославович	m.fedorov@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1969", "skills": "Kubernetes, Microservices, Java, gRPC", "status": "На проекте", "project": "5G инфраструктура", "comments": "", "contacts": "+7 (923) 266-45-43, @федмарк80, m.fedorov@rt.ru", "it_block": "НУК", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2023-04-29", "recruiter": "Смирнова А.А.", "department": "Backend", "entry_date": "2024-05-24", "resume_link": "https://drive.google.com/file/69829", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "E-commerce Platform, Mobile App", "candidate_status": "В работе", "funding_end_date": "2026-08-13", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:53.729511	2026-01-16 12:05:36.611183
173	Новиков Роман Павлович	yaroslav.dmitriev157@company.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2206", "skills": "Go,gRPC", "status": "Болеет", "project": "", "comments": "", "contacts": "+7 (931) 281-42-63, @новрома11, yaroslav.dmitriev157@company.ru", "it_block": "Эксплуатация", "location": "Гибрид", "position": "Senior Developer", "hire_date": "2022-06-17", "recruiter": "Белова И.Д.", "department": "Mobile", "entry_date": "2024-05-01", "resume_link": "https://drive.google.com/file/72377", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "Госуслуги 2.0, ML Pipeline, Data Platform", "candidate_status": "Свободен", "funding_end_date": "2025-05-28", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:38.493263	2026-01-16 12:05:36.637753
175	Морозов Никита Михайлович	anna.egorov159@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "Sidorov K.V.", "salary": "1377", "skills": "PostgreSQL,Redis", "status": "На бенче", "project": "Mobile App", "comments": "", "contacts": "+7 (938) 348-75-92, @морники88, anna.egorov159@company.ru", "it_block": "НУК", "location": "Москва", "position": "Middle Developer", "hire_date": "2023-02-01", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2025-11-19", "resume_link": "https://drive.google.com/file/15575", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "DevOps Platform", "candidate_status": "В работе", "funding_end_date": "2025-06-15", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:38.728027	2026-01-16 12:05:36.670388
170	Петров Алексей Александрович	ekaterina.yakovlev154@company.ru	{"grade": "Lead", "hr_bp": "Морозов К.А.", "mentor": "Ivanov A.S.", "salary": "1044", "skills": "Rust,WebAssembly", "status": "Болеет", "project": "", "comments": "", "contacts": "+7 (919) 283-69-51, @петалек21, ekaterina.yakovlev154@company.ru", "it_block": "B2O", "location": "Москва", "position": "Designer", "hire_date": "2018-09-22", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2025-12-01", "resume_link": "https://drive.google.com/file/72111", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-01-12", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Banking App, Mobile App", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-12-09", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:38.144604	2026-01-16 12:05:36.735838
186	Соколов Егор Владимирович	gleb.lebedev170@company.ru	{"grade": "Principal", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2406", "skills": "TypeScript,Vue", "status": "На бенче", "project": "Refactoring", "comments": "", "contacts": "+7 (905) 949-14-26, @сокегор85, gleb.lebedev170@company.ru", "it_block": "НУК", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2018-12-20", "recruiter": "Орлов М.С.", "department": "DevOps", "entry_date": "2025-09-13", "resume_link": "https://drive.google.com/file/92211", "ck_department": "Департамент данных", "transfer_date": "2026-07-24", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Banking App", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-12-14", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:39.860738	2026-01-16 12:05:36.760587
191	Волков Максим Андреевич	igor.nikitin175@company.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2386", "skills": "Rust,WebAssembly", "status": "На бенче", "project": "Security Audit", "comments": "", "contacts": "+7 (933) 266-62-62, @волмакс98, igor.nikitin175@company.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2019-07-20", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2024-05-05", "resume_link": "https://drive.google.com/file/68217", "ck_department": "Департамент данных", "transfer_date": "2025-03-31", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Banking App, Mobile App, Data Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-07-20", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:40.44289	2026-01-16 12:05:36.78552
197	Кузнецов Денис Дмитриевич	igor.pavlov181@company.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Novikova O.P.", "salary": "2101", "skills": "Go,gRPC", "status": "В отпуске", "project": "Performance", "comments": "Срочно нужен проект", "contacts": "+7 (990) 702-99-12, @куздени8, igor.pavlov181@company.ru", "it_block": "Развитие", "location": "Санкт-Петербург", "position": "Designer", "hire_date": "2020-01-13", "recruiter": "Смирнова А.А.", "department": "Mobile", "entry_date": "2024-12-08", "resume_link": "https://drive.google.com/file/60046", "ck_department": "Департамент данных", "transfer_date": "2026-11-24", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "Infrastructure, Data Platform", "candidate_status": "Переведен", "funding_end_date": "2026-09-11", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:41.063392	2026-01-16 12:05:36.815407
196	Смирнов Илья Владимирович	roman.zakharov180@company.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "Sidorov K.V.", "salary": "952", "skills": "Kotlin,Android", "status": "Болеет", "project": "API Gateway", "comments": "Срочно нужен проект", "contacts": "+7 (986) 405-48-49, @смиилья66, roman.zakharov180@company.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2020-03-18", "recruiter": "Смирнова А.А.", "department": "Design", "entry_date": "2025-06-04", "resume_link": "https://drive.google.com/file/87731", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "Госуслуги 2.0, Infrastructure", "candidate_status": "В работе", "funding_end_date": "2025-09-06", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 18:21:40.96554	2026-01-16 12:05:36.837955
199	Васильев Иван Евгеньевич	roman.smirnov183@company.ru	{"grade": "Lead", "hr_bp": "Волкова Н.В.", "mentor": "Petrov M.I.", "salary": "1751", "skills": "Docker,Kubernetes", "status": "Болеет", "project": "E-commerce", "comments": "Срочно нужен проект", "contacts": "+7 (965) 607-25-25, @васиван7, roman.smirnov183@company.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "Project Manager", "hire_date": "2022-03-08", "recruiter": "Орлов М.С.", "department": "Mobile", "entry_date": "2025-06-20", "resume_link": "https://drive.google.com/file/11200", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "E-commerce Platform, DevOps Platform, Госуслуги 2.0", "candidate_status": "В работе", "funding_end_date": "2025-06-19", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 18:21:41.261984	2026-01-16 12:05:36.861473
204	Фёдоров Сергей Сергеевич	elena.vorobyov188@company.ru	{"grade": "Principal", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2395", "skills": "Rust,WebAssembly", "status": "Болеет", "project": "API Gateway", "comments": "Ожидает оффер", "contacts": "+7 (984) 325-59-32, @фёдсерг59, elena.vorobyov188@company.ru", "it_block": "B2O", "location": "Гибрид", "position": "Designer", "hire_date": "2023-01-19", "recruiter": "Белова И.Д.", "department": "Management", "entry_date": "2024-05-20", "resume_link": "https://drive.google.com/file/41497", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Data Platform, DevOps Platform", "candidate_status": "В работе", "funding_end_date": "2025-05-30", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:41.775329	2026-01-16 12:05:36.917797
184	Васильев Иван Сергеевич	julia.kuznetsov168@company.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2433", "skills": "Docker,Kubernetes", "status": "На проекте", "project": "Admin Panel", "comments": "В процессе согласования", "contacts": "+7 (971) 307-31-22, @васиван64, julia.kuznetsov168@company.ru", "it_block": "НУК", "location": "Санкт-Петербург", "position": "Analyst", "hire_date": "2020-09-06", "recruiter": "Белова И.Д.", "department": "Mobile", "entry_date": "2025-12-04", "resume_link": "https://drive.google.com/file/19581", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "Data Platform, E-commerce Platform, Госуслуги 2.0", "candidate_status": "Забронирован", "funding_end_date": "2025-04-29", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 18:21:39.664573	2026-01-16 12:05:36.970465
192	Алексеев Михаил Иванович	vladimir.sergeev176@company.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2414", "skills": "TypeScript,Vue", "status": "На проекте", "project": "Infrastructure", "comments": "Ожидает оффер", "contacts": "+7 (932) 804-93-89, @алемиха71, vladimir.sergeev176@company.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2020-10-15", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2025-08-18", "resume_link": "https://drive.google.com/file/40681", "ck_department": "ЦК Аналитики", "transfer_date": "2025-01-15", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "ML Pipeline", "candidate_status": "Переведен", "funding_end_date": "2025-12-07", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 18:21:40.539407	2026-01-16 12:05:37.002781
75	Иванов Александр Михайлович	timofey.orlov59@company.ru	{"grade": "Principal", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1976", "skills": "PHP,Laravel", "status": "В отпуске", "project": "", "comments": "В процессе согласования", "contacts": "+7 (943) 385-68-83, @иваалек29, timofey.orlov59@company.ru", "it_block": "НУК", "location": "Санкт-Петербург", "position": "Team Lead", "hire_date": "2022-07-06", "recruiter": "Новикова Е.П.", "department": "DevOps", "entry_date": "2025-04-27", "resume_link": "https://drive.google.com/file/62247", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline, Banking App, E-commerce Platform", "candidate_status": "В работе", "funding_end_date": "2025-10-30", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 18:21:27.893873	2026-01-16 12:05:37.028043
198	Попов Артём Алексеевич	irina.andreev182@company.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Kozlova E.A.", "salary": "2787", "skills": "Kotlin,Android", "status": "На проекте", "project": "API Gateway", "comments": "Срочно нужен проект", "contacts": "+7 (915) 205-72-11, @попартё78, irina.andreev182@company.ru", "it_block": "Диджитал", "location": "Удалённо", "position": "Designer", "hire_date": "2021-06-28", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2024-07-06", "resume_link": "https://drive.google.com/file/15837", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "ML Pipeline, Госуслуги 2.0, Mobile App", "candidate_status": "Свободен", "funding_end_date": "2025-11-29", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 18:21:41.160728	2026-01-16 12:05:37.057188
195	Иванов Александр Михайлович	igor.fedorov179@company.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2740", "skills": "Swift,iOS", "status": "На проекте", "project": "Admin Panel", "comments": "Ожидает оффер", "contacts": "+7 (978) 661-36-38, @иваалек69, igor.fedorov179@company.ru", "it_block": "B2O", "location": "Гибрид", "position": "Analyst", "hire_date": "2023-07-13", "recruiter": "Новикова Е.П.", "department": "Mobile", "entry_date": "2024-06-05", "resume_link": "https://drive.google.com/file/62255", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-05-02", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Data Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-07-11", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 18:21:40.859992	2026-01-16 12:05:37.113076
61	Смирнов Илья Андреевич	alexey.lebedev45@company.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Novikova O.P.", "salary": "1011", "skills": "PHP,Laravel", "status": "На бенче", "project": "ML Platform", "comments": "", "contacts": "+7 (901) 609-98-21, @смиилья29, alexey.lebedev45@company.ru", "it_block": "Диджитал", "location": "Гибрид", "position": "Designer", "hire_date": "2023-02-18", "recruiter": "Орлов М.С.", "department": "QA", "entry_date": "2025-09-15", "resume_link": "https://drive.google.com/file/73185", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Data Platform, Banking App", "candidate_status": "Свободен", "funding_end_date": "2026-06-15", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:26.459716	2026-01-16 12:05:37.139876
104	Семёнов Кирилл Сергеевич	ilya.andreev88@company.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2907", "skills": "Docker,Kubernetes", "status": "В отпуске", "project": "Performance", "comments": "", "contacts": "+7 (976) 874-99-73, @семкири69, ilya.andreev88@company.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2024-07-17", "recruiter": "Смирнова А.А.", "department": "Frontend", "entry_date": "2025-01-15", "resume_link": "https://drive.google.com/file/43012", "ck_department": "ЦК Аналитики", "transfer_date": "2025-06-21", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Banking App, ML Pipeline, DevOps Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-02-19", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 18:21:31.057515	2026-01-16 12:05:37.164428
105	Иванов Александр Михайлович	grigory.egorov89@company.ru	{"grade": "Principal", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1778", "skills": "Python,Django", "status": "В отпуске", "project": "Security Audit", "comments": "", "contacts": "+7 (931) 157-40-56, @иваалек29, grigory.egorov89@company.ru", "it_block": "Развитие", "location": "Санкт-Петербург", "position": "Designer", "hire_date": "2023-04-25", "recruiter": "Смирнова А.А.", "department": "DevOps", "entry_date": "2024-06-21", "resume_link": "https://drive.google.com/file/74064", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Infrastructure", "candidate_status": "Забронирован", "funding_end_date": "2026-08-17", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 18:21:31.173632	2026-01-16 12:05:37.188785
211	Смирнов Илья Андреевич	irina.sokolov195@company.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "Novikova O.P.", "salary": "2726", "skills": "Go,gRPC", "status": "В отпуске", "project": "Performance", "comments": "", "contacts": "+7 (936) 270-57-44, @смиилья66, irina.sokolov195@company.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "Junior Developer", "hire_date": "2022-06-28", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2024-02-22", "resume_link": "https://drive.google.com/file/16746", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "DevOps Platform, Госуслуги 2.0", "candidate_status": "В работе", "funding_end_date": "2026-02-06", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 18:21:42.543066	2026-01-16 12:05:37.213386
57	Алексеев Михаил Дмитриевич	alexey.stepanov41@company.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "Ivanov A.S.", "salary": "1985", "skills": "Swift,iOS", "status": "Болеет", "project": "Security Audit", "comments": "", "contacts": "+7 (985) 619-94-46, @алемиха4, alexey.stepanov41@company.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "Junior Developer", "hire_date": "2023-06-15", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2024-07-12", "resume_link": "https://drive.google.com/file/11821", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "E-commerce Platform", "candidate_status": "Забронирован", "funding_end_date": "2025-07-16", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:26.027713	2026-01-16 12:05:37.238
203	Новиков Роман Павлович	yuri.nikolaev187@company.ru	{"grade": "Principal", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2103", "skills": "Kotlin,Android", "status": "В отпуске", "project": "E-commerce", "comments": "Ожидает оффер", "contacts": "+7 (986) 137-79-70, @новрома93, yuri.nikolaev187@company.ru", "it_block": "Эксплуатация", "location": "Удалённо", "position": "Middle Developer", "hire_date": "2024-05-28", "recruiter": "Белова И.Д.", "department": "QA", "entry_date": "2025-05-16", "resume_link": "https://drive.google.com/file/59344", "ck_department": "ЦК Аналитики", "transfer_date": "2026-01-30", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Infrastructure, E-commerce Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-10-21", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 18:21:41.67055	2026-01-16 12:05:37.310943
131	Волков Максим Андреевич	vladislav.alexeev115@company.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "Kozlova E.A.", "salary": "2920", "skills": "PHP,Laravel", "status": "В отпуске", "project": "Admin Panel", "comments": "", "contacts": "+7 (904) 398-14-31, @волмакс30, vladislav.alexeev115@company.ru", "it_block": "НУК", "location": "Гибрид", "position": "DevOps Engineer", "hire_date": "2024-10-06", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2025-09-21", "resume_link": "https://drive.google.com/file/46089", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2026-01-01", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Mobile App, ML Pipeline", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-07-11", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:33.992384	2026-01-16 12:05:37.377321
159	Фёдоров Сергей Евгеньевич	timofey.yakovlev143@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1957", "skills": "C#,.NET", "status": "В отпуске", "project": "Data Pipeline", "comments": "Ожидает оффер", "contacts": "+7 (967) 303-13-62, @фёдсерг91, timofey.yakovlev143@company.ru", "it_block": "Прочее", "location": "Гибрид", "position": "Designer", "hire_date": "2019-10-24", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2025-07-20", "resume_link": "https://drive.google.com/file/51057", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Banking App, Infrastructure, ML Pipeline", "candidate_status": "Свободен", "funding_end_date": "2026-03-26", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:36.957159	2026-01-16 12:05:37.508344
205	Морозов Никита Михайлович	maxim.vasilev189@company.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2557", "skills": "AWS,Terraform", "status": "В отпуске", "project": "CRM System", "comments": "", "contacts": "+7 (978) 919-16-37, @морники43, maxim.vasilev189@company.ru", "it_block": "Развитие", "location": "Гибрид", "position": "Designer", "hire_date": "2023-11-01", "recruiter": "Новикова Е.П.", "department": "Mobile", "entry_date": "2024-07-04", "resume_link": "https://drive.google.com/file/82204", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "DevOps Platform", "candidate_status": "Забронирован", "funding_end_date": "2026-03-31", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:41.87689	2026-01-16 12:05:37.553939
214	Васильев Иван Сергеевич	grigory.kuzmin198@company.ru	{"grade": "Principal", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2950", "skills": "Ruby,Rails", "status": "В отпуске", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (991) 367-25-51, @васиван93, grigory.kuzmin198@company.ru", "it_block": "НУК", "location": "Гибрид", "position": "Tech Lead", "hire_date": "2019-03-23", "recruiter": "Смирнова А.А.", "department": "Mobile", "entry_date": "2024-01-03", "resume_link": "https://drive.google.com/file/43620", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "DevOps Platform, Data Platform, Mobile App", "candidate_status": "Свободен", "funding_end_date": "2025-03-15", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:42.876422	2026-01-16 12:05:37.59501
41	Волков Максим Андреевич	tatiana.petrov25@company.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "833", "skills": "TypeScript,Vue", "status": "Болеет", "project": "Analytics Platform", "comments": "", "contacts": "+7 (915) 103-50-61, @волмакс32, tatiana.petrov25@company.ru", "it_block": "Развитие", "location": "Москва", "position": "Senior Developer", "hire_date": "2023-05-16", "recruiter": "Белова И.Д.", "department": "Frontend", "entry_date": "2025-06-02", "resume_link": "https://drive.google.com/file/66031", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2026-01-22", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Infrastructure, Data Platform, DevOps Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-06-18", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 18:21:24.29546	2026-01-16 12:05:37.646408
135	Иванов Александр Михайлович	yaroslav.petrov119@company.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "910", "skills": "C#,.NET", "status": "На проекте", "project": "Analytics Platform", "comments": "В процессе согласования", "contacts": "+7 (943) 138-52-97, @иваалек62, yaroslav.petrov119@company.ru", "it_block": "B2O", "location": "Москва", "position": "QA Engineer", "hire_date": "2020-04-28", "recruiter": "Орлов М.С.", "department": "Backend", "entry_date": "2025-06-23", "resume_link": "https://drive.google.com/file/48024", "ck_department": "ЦК Аналитики", "transfer_date": "2026-02-13", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Data Platform, Mobile App, DevOps Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-09-12", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:34.442096	2026-01-16 12:05:37.71137
143	Новиков Роман Павлович	evgeny.nikolaev127@company.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Ivanov A.S.", "salary": "2907", "skills": "C#,.NET", "status": "На проекте", "project": "Data Pipeline", "comments": "В процессе согласования", "contacts": "+7 (928) 314-33-62, @новрома54, evgeny.nikolaev127@company.ru", "it_block": "НУК", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2024-12-19", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2024-03-15", "resume_link": "https://drive.google.com/file/62247", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "ML Pipeline, Infrastructure, Banking App", "candidate_status": "Свободен", "funding_end_date": "2026-10-18", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:35.277751	2026-01-16 12:05:37.737881
160	Морозов Никита Александрович	nikolay.borisov144@company.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1127", "skills": "AWS,Terraform", "status": "На проекте", "project": "Infrastructure", "comments": "В процессе согласования", "contacts": "+7 (907) 968-42-24, @морники17, nikolay.borisov144@company.ru", "it_block": "НУК", "location": "Москва", "position": "Junior Developer", "hire_date": "2023-06-06", "recruiter": "Новикова Е.П.", "department": "Mobile", "entry_date": "2024-08-20", "resume_link": "https://drive.google.com/file/20711", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "ML Pipeline", "candidate_status": "Забронирован", "funding_end_date": "2025-11-27", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 18:21:37.054728	2026-01-16 12:05:37.766999
167	Кузнецов Денис Дмитриевич	matvey.kuznetsov151@company.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "Kozlova E.A.", "salary": "2998", "skills": "PostgreSQL,Redis", "status": "На проекте", "project": "", "comments": "", "contacts": "+7 (972) 436-82-87, @куздени13, matvey.kuznetsov151@company.ru", "it_block": "НУК", "location": "Москва", "position": "Middle Developer", "hire_date": "2020-04-14", "recruiter": "Смирнова А.А.", "department": "Frontend", "entry_date": "2024-08-11", "resume_link": "https://drive.google.com/file/30465", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "ML Pipeline", "candidate_status": "Свободен", "funding_end_date": "2025-05-30", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 18:21:37.826486	2026-01-16 12:05:37.790391
168	Попов Артём Алексеевич	artem.kuznetsov152@company.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "Kozlova E.A.", "salary": "2812", "skills": "Rust,WebAssembly", "status": "На проекте", "project": "Performance", "comments": "", "contacts": "+7 (994) 820-29-64, @попартё95, artem.kuznetsov152@company.ru", "it_block": "Развитие", "location": "Москва", "position": "Team Lead", "hire_date": "2024-11-03", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2025-02-22", "resume_link": "https://drive.google.com/file/81437", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "ML Pipeline, E-commerce Platform, Госуслуги 2.0", "candidate_status": "Забронирован", "funding_end_date": "2026-12-30", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:37.943276	2026-01-16 12:05:37.816669
188	Новиков Роман Алексеевич	sergey.novikov172@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "Petrov M.I.", "salary": "2551", "skills": "C#,.NET", "status": "На проекте", "project": "Analytics Platform", "comments": "В процессе согласования", "contacts": "+7 (994) 881-84-57, @новрома94, sergey.novikov172@company.ru", "it_block": "Развитие", "location": "Москва", "position": "Team Lead", "hire_date": "2024-02-10", "recruiter": "Смирнова А.А.", "department": "Mobile", "entry_date": "2025-08-31", "resume_link": "https://drive.google.com/file/94290", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "DevOps Platform, Infrastructure, Banking App", "candidate_status": "В работе", "funding_end_date": "2026-03-31", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 18:21:40.108573	2026-01-16 12:05:37.848942
56	Волков Максим Владимирович	gleb.ivanov40@company.ru	{"grade": "Principal", "hr_bp": "Волкова Н.В.", "mentor": "Kozlova E.A.", "salary": "2957", "skills": "Kotlin,Android", "status": "На бенче", "project": "", "comments": "", "contacts": "+7 (971) 424-74-90, @волмакс39, gleb.ivanov40@company.ru", "it_block": "НУК", "location": "Москва", "position": "Analyst", "hire_date": "2023-04-12", "recruiter": "Новикова Е.П.", "department": "Analytics", "entry_date": "2025-11-14", "resume_link": "https://drive.google.com/file/30291", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "DevOps Platform, Banking App", "candidate_status": "В работе", "funding_end_date": "2025-01-31", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:25.923942	2026-01-16 12:05:31.04176
86	Волков Максим Владимирович	tatiana.nikolaev70@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "Kozlova E.A.", "salary": "2582", "skills": "JavaScript,React", "status": "В отпуске", "project": "Refactoring", "comments": "", "contacts": "+7 (909) 364-41-85, @волмакс53, tatiana.nikolaev70@company.ru", "it_block": "B2O", "location": "Москва", "position": "Analyst", "hire_date": "2023-06-16", "recruiter": "Орлов М.С.", "department": "Mobile", "entry_date": "2024-09-27", "resume_link": "https://drive.google.com/file/32152", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Banking App", "candidate_status": "Забронирован", "funding_end_date": "2026-09-18", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:29.096913	2026-01-16 12:05:31.106605
98	Новиков Роман Алексеевич	grigory.andreev82@company.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1790", "skills": "JavaScript,React", "status": "В отпуске", "project": "Mobile App", "comments": "", "contacts": "+7 (931) 736-77-35, @новрома13, grigory.andreev82@company.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Middle Developer", "hire_date": "2023-02-17", "recruiter": "Новикова Е.П.", "department": "QA", "entry_date": "2025-11-15", "resume_link": "https://drive.google.com/file/35446", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline, E-commerce Platform", "candidate_status": "Свободен", "funding_end_date": "2025-08-03", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:30.427169	2026-01-16 12:05:31.146825
66	Соколов Егор Владимирович	natalia.orlov50@company.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "Petrov M.I.", "salary": "1095", "skills": "Swift,iOS", "status": "Болеет", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (970) 147-47-48, @сокегор98, natalia.orlov50@company.ru", "it_block": "Прочее", "location": "Удалённо", "position": "Middle Developer", "hire_date": "2023-12-11", "recruiter": "Новикова Е.П.", "department": "Management", "entry_date": "2025-10-01", "resume_link": "https://drive.google.com/file/90532", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "Data Platform, Госуслуги 2.0, ML Pipeline", "candidate_status": "В работе", "funding_end_date": "2026-08-17", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:26.992009	2026-01-16 12:05:37.895035
68	Новиков Роман Алексеевич	mark.novikov52@company.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "Ivanov A.S.", "salary": "2100", "skills": "TypeScript,Vue", "status": "Болеет", "project": "Performance", "comments": "Срочно нужен проект", "contacts": "+7 (958) 101-15-95, @новрома21, mark.novikov52@company.ru", "it_block": "НУК", "location": "Гибрид", "position": "Tech Lead", "hire_date": "2022-06-06", "recruiter": "Белова И.Д.", "department": "QA", "entry_date": "2024-11-22", "resume_link": "https://drive.google.com/file/54385", "ck_department": "Департамент данных", "transfer_date": "2025-09-21", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-03-04", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 18:21:27.193187	2026-01-16 12:05:37.956991
422	Захарова Диана Тимуровна	d.zakharova@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2883", "skills": "Statistics, Python, SQL, Tableau", "status": "Болеет", "project": "", "comments": "", "contacts": "+7 (958) 667-10-99, @захдиан3, d.zakharova@rt.ru", "it_block": "Диджитал", "location": "Москва", "position": "Analyst", "hire_date": "2024-06-17", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2025-03-15", "resume_link": "https://drive.google.com/file/20096", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-01-14", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "E-commerce Platform, Mobile App, Госуслуги 2.0", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-08-21", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:54.566519	2026-01-16 12:05:31.242797
423	Андреев Олег Алексеевич	o.andreev@rt.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "3644", "skills": "ETL, Power BI, Tableau, Data Visualization", "status": "В отпуске", "project": "", "comments": "", "contacts": "+7 (958) 189-51-40, @андолег94, o.andreev@rt.ru", "it_block": "Развитие", "location": "Удалённо", "position": "Analyst", "hire_date": "2020-08-13", "recruiter": "Новикова Е.П.", "department": "Analytics", "entry_date": "2024-11-24", "resume_link": "https://drive.google.com/file/82607", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "ML Pipeline", "candidate_status": "Забронирован", "funding_end_date": "2026-07-15", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:54.599093	2026-01-16 12:05:31.274495
424	Фролов Егор Кириллович	e.frolov@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2813", "skills": "User Research, Prototyping, Figma, Adobe XD", "status": "На проекте", "project": "Billing System", "comments": "", "contacts": "+7 (909) 520-35-84, @фроегор78, e.frolov@rt.ru", "it_block": "Развитие", "location": "Гибрид", "position": "Designer", "hire_date": "2021-07-08", "recruiter": "Белова И.Д.", "department": "Design", "entry_date": "2024-09-28", "resume_link": "https://drive.google.com/file/11282", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Иванов А.П.", "target_projects": "DevOps Platform, Mobile App", "candidate_status": "Свободен", "funding_end_date": "2025-07-02", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:54.627383	2026-01-16 12:05:31.300653
426	Васильев Артём Романович	a.vasilev@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1473", "skills": "iOS SDK, Android SDK, Firebase, React Native", "status": "Болеет", "project": "", "comments": "В процессе согласования", "contacts": "+7 (910) 356-76-49, @васартё66, a.vasilev@rt.ru", "it_block": "Диджитал", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2024-03-27", "recruiter": "Орлов М.С.", "department": "Mobile", "entry_date": "2025-06-06", "resume_link": "https://drive.google.com/file/92736", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "E-commerce Platform, ML Pipeline", "candidate_status": "В работе", "funding_end_date": "2026-06-09", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:54.672965	2026-01-16 12:05:31.388246
427	Соловьев Максим Маркович	m.solovev@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1315", "skills": "Data Visualization, Statistics, Python, A/B Testing", "status": "На проекте", "project": "CRM Enterprise", "comments": "Срочно нужен проект", "contacts": "+7 (980) 526-15-12, @солмакс23, m.solovev@rt.ru", "it_block": "НУК", "location": "Москва", "position": "Analyst", "hire_date": "2016-09-29", "recruiter": "Орлов М.С.", "department": "Analytics", "entry_date": "2024-06-09", "resume_link": "https://drive.google.com/file/54562", "ck_department": "ЦК Аналитики", "transfer_date": "2025-10-26", "placement_type": "перевод", "current_manager": "Иванов А.П.", "target_projects": "Data Platform, Banking App, DevOps Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-09-29", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:54.701043	2026-01-16 12:05:31.432936
429	Новиков Алексей Юрьевич	a.novikov@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2487", "skills": "Design Systems, Prototyping, User Research, UI/UX", "status": "На проекте", "project": "Кибербезопасность B2B", "comments": "", "contacts": "+7 (968) 572-71-23, @новалек20, a.novikov@rt.ru", "it_block": "Диджитал", "location": "Удалённо", "position": "Designer", "hire_date": "2023-10-22", "recruiter": "Белова И.Д.", "department": "Design", "entry_date": "2024-05-03", "resume_link": "https://drive.google.com/file/17276", "ck_department": "ЦК Разработки", "transfer_date": "2026-05-12", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "ML Pipeline, E-commerce Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-05-22", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:54.765712	2026-01-16 12:05:31.491975
431	Волкова София Егоровна	s.volkova@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1471", "skills": "JUnit, Postman, JMeter, Performance Testing", "status": "На проекте", "project": "Госуслуги 2.0", "comments": "Ожидает оффер", "contacts": "+7 (939) 675-77-38, @волсофи63, s.volkova@rt.ru", "it_block": "НУК", "location": "Москва", "position": "QA Engineer", "hire_date": "2020-11-16", "recruiter": "Белова И.Д.", "department": "QA", "entry_date": "2025-05-05", "resume_link": "https://drive.google.com/file/69009", "ck_department": "ЦК Разработки", "transfer_date": "2025-05-02", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Data Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-03-29", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:54.852177	2026-01-16 12:05:31.548973
434	Ковалева Ксения Сергеевна	k.kovaleva@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1446", "skills": "GraphQL, Webpack, Redux, React", "status": "Болеет", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (930) 915-19-32, @ковксен5, k.kovaleva@rt.ru", "it_block": "Развитие", "location": "Удалённо", "position": "Middle Developer", "hire_date": "2023-03-22", "recruiter": "Белова И.Д.", "department": "Frontend", "entry_date": "2024-10-13", "resume_link": "https://drive.google.com/file/28701", "ck_department": "ЦК Аналитики", "transfer_date": "2025-12-11", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "DevOps Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-12-22", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:54.976696	2026-01-16 12:05:38.084379
436	Смирнова Юлия Никитична	yu.smirnova@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2754", "skills": "Kubernetes, REST API, Java, PostgreSQL", "status": "На проекте", "project": "B2B личный кабинет", "comments": "", "contacts": "+7 (977) 799-85-55, @смиюлия50, yu.smirnova@rt.ru", "it_block": "НУК", "location": "Москва", "position": "Senior Developer", "hire_date": "2023-10-03", "recruiter": "Смирнова А.А.", "department": "Backend", "entry_date": "2024-11-08", "resume_link": "https://drive.google.com/file/73451", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-03-22", "placement_type": "перевод", "current_manager": "Иванов А.П.", "target_projects": "Infrastructure, E-commerce Platform, ML Pipeline", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-09-14", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.0697	2026-01-16 12:05:38.140654
437	Медведев Олег Степанович	o.medvedev@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1940", "skills": "AWS, Prometheus, Ansible, GitLab CI", "status": "На проекте", "project": "AI Contact Center", "comments": "Срочно нужен проект", "contacts": "+7 (925) 945-46-63, @медолег38, o.medvedev@rt.ru", "it_block": "Развитие", "location": "Удалённо", "position": "DevOps Engineer", "hire_date": "2020-04-24", "recruiter": "Орлов М.С.", "department": "DevOps", "entry_date": "2025-07-02", "resume_link": "https://drive.google.com/file/18973", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "E-commerce Platform, ML Pipeline, Data Platform", "candidate_status": "Свободен", "funding_end_date": "2025-07-02", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:55.104834	2026-01-16 12:05:38.176992
438	Орлов Никита Андреевич	n.orlov@rt.ru	{"grade": "Lead", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "3630", "skills": "Selenium, API Testing, Performance Testing, Allure", "status": "На проекте", "project": "Видеонаблюдение", "comments": "", "contacts": "+7 (947) 852-68-95, @орлники41, n.orlov@rt.ru", "it_block": "Эксплуатация", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2022-10-13", "recruiter": "Белова И.Д.", "department": "QA", "entry_date": "2025-09-14", "resume_link": "https://drive.google.com/file/86079", "ck_department": "ЦК Аналитики", "transfer_date": "2026-12-29", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Infrastructure, Госуслуги 2.0", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-11-07", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.140787	2026-01-16 12:05:38.279337
440	Ильин Илья Сергеевич	i.ilin@rt.ru	{"grade": "Principal", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "5286", "skills": "Microservices, Kubernetes, Java, PostgreSQL", "status": "На проекте", "project": "Analytics Dashboard", "comments": "В процессе согласования", "contacts": "+7 (994) 916-66-18, @ильилья28, i.ilin@rt.ru", "it_block": "Диджитал", "location": "Гибрид", "position": "Tech Lead", "hire_date": "2025-09-05", "recruiter": "Орлов М.С.", "department": "Backend", "entry_date": "2025-03-29", "resume_link": "https://drive.google.com/file/13674", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "Data Platform", "candidate_status": "Свободен", "funding_end_date": "2025-09-06", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:55.192892	2026-01-16 12:05:38.323331
443	Полякова Ксения Марковна	k.polyakova@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Антонов Андрей Маркович", "salary": "682", "skills": "Design Systems, Sketch, User Research, Wireframing", "status": "На проекте", "project": "Видеонаблюдение", "comments": "В процессе согласования", "contacts": "+7 (965) 441-89-98, @полксен56, k.polyakova@rt.ru", "it_block": "Прочее", "location": "Удалённо", "position": "Designer", "hire_date": "2021-12-04", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2025-09-18", "resume_link": "https://drive.google.com/file/19641", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-09-26", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "ML Pipeline", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-05-25", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.31349	2026-01-16 12:05:38.388073
445	Соколов Руслан Вадимович	r.sokolov@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1737", "skills": "SQL, Excel, A/B Testing, Data Visualization", "status": "На проекте", "project": "ML Pipeline", "comments": "", "contacts": "+7 (993) 843-15-71, @сокрусл70, r.sokolov@rt.ru", "it_block": "Развитие", "location": "Москва", "position": "Analyst", "hire_date": "2018-01-25", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2024-12-16", "resume_link": "https://drive.google.com/file/68206", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "E-commerce Platform, Mobile App, ML Pipeline", "candidate_status": "Забронирован", "funding_end_date": "2025-01-07", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:55.377409	2026-01-16 12:05:38.413524
446	Семенов Матвей Вадимович	m.semenov@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1620", "skills": "iOS SDK, Kotlin, React Native, Swift", "status": "На проекте", "project": "Техподдержка 3.0", "comments": "", "contacts": "+7 (942) 407-60-95, @семматв14, m.semenov@rt.ru", "it_block": "Развитие", "location": "Москва", "position": "Middle Developer", "hire_date": "2024-08-22", "recruiter": "Смирнова А.А.", "department": "Mobile", "entry_date": "2025-07-06", "resume_link": "https://drive.google.com/file/71857", "ck_department": "ЦК Аналитики", "transfer_date": "2025-07-26", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Data Platform, Госуслуги 2.0, Banking App", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-10-09", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.406451	2026-01-16 12:05:38.44054
448	Семенов Руслан Максимович	r.semenov@rt.ru	{"grade": "Lead", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "3813", "skills": "Kubernetes, Java, Kafka, REST API", "status": "На проекте", "project": "Analytics Dashboard", "comments": "", "contacts": "+7 (985) 342-40-30, @семрусл13, r.semenov@rt.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Team Lead", "hire_date": "2017-03-31", "recruiter": "Смирнова А.А.", "department": "Backend", "entry_date": "2024-09-18", "resume_link": "https://drive.google.com/file/50935", "ck_department": "ЦК Аналитики", "transfer_date": "2026-08-01", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "DevOps Platform, ML Pipeline, Infrastructure", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-12-26", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:55.457657	2026-01-16 12:05:38.46363
450	Киселев Денис Вадимович	d.kiselev@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1911", "skills": "Linux, Prometheus, AWS, Kubernetes", "status": "На бенче", "project": "", "comments": "", "contacts": "+7 (943) 713-60-47, @кисдени5, d.kiselev@rt.ru", "it_block": "Диджитал", "location": "Москва", "position": "DevOps Engineer", "hire_date": "2024-11-24", "recruiter": "Новикова Е.П.", "department": "DevOps", "entry_date": "2024-03-25", "resume_link": "https://drive.google.com/file/71128", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2025-09-02", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Infrastructure, ML Pipeline, DevOps Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-05-09", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.524482	2026-01-16 12:05:38.494498
451	Егоров Арсений Сергеевич	a.egorov@rt.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "3757", "skills": "Kubernetes, Linux, Ansible, Jenkins", "status": "На бенче", "project": "", "comments": "В процессе согласования", "contacts": "+7 (953) 890-35-96, @егоарсе42, a.egorov@rt.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2022-08-30", "recruiter": "Орлов М.С.", "department": "DevOps", "entry_date": "2024-08-23", "resume_link": "https://drive.google.com/file/39002", "ck_department": "Департамент данных", "transfer_date": "2025-10-15", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "ML Pipeline, DevOps Platform, Mobile App", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-02-18", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:55.558882	2026-01-16 12:05:38.522724
455	Киселев Олег Дмитриевич	o.kiselev@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1315", "skills": "Wireframing, Figma, Adobe XD, User Research", "status": "На проекте", "project": "Service Mesh", "comments": "Срочно нужен проект", "contacts": "+7 (975) 327-14-45, @кисолег28, o.kiselev@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Designer", "hire_date": "2025-10-05", "recruiter": "Новикова Е.П.", "department": "Design", "entry_date": "2024-07-08", "resume_link": "https://drive.google.com/file/42060", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-12-08", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Data Platform, Mobile App", "candidate_status": "Переведен", "funding_end_date": "2026-11-18", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.65941	2026-01-16 12:05:38.574924
456	Михайлов Данил Николаевич	d.mikhaylov@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2321", "skills": "Stakeholder Management, Scrum, Jira, Budgeting", "status": "На проекте", "project": "Техподдержка 3.0", "comments": "", "contacts": "+7 (925) 442-29-59, @михдани62, d.mikhaylov@rt.ru", "it_block": "Развитие", "location": "Москва", "position": "Project Manager", "hire_date": "2022-10-03", "recruiter": "Белова И.Д.", "department": "Management", "entry_date": "2025-09-28", "resume_link": "https://drive.google.com/file/32114", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline, DevOps Platform, Data Platform", "candidate_status": "В работе", "funding_end_date": "2025-01-13", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.681871	2026-01-16 12:05:38.606707
457	Кузнецов Тимофей Кириллович	t.kuznetsov@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1735", "skills": "Clickhouse, Statistics, Python, SQL", "status": "На проекте", "project": "ML Pipeline", "comments": "", "contacts": "+7 (997) 742-32-76, @кузтимо78, t.kuznetsov@rt.ru", "it_block": "Диджитал", "location": "Удалённо", "position": "Analyst", "hire_date": "2020-07-18", "recruiter": "Новикова Е.П.", "department": "Analytics", "entry_date": "2025-04-24", "resume_link": "https://drive.google.com/file/89753", "ck_department": "ЦК Разработки", "transfer_date": "2026-02-05", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Госуслуги 2.0, Banking App, Mobile App", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-06-23", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:55.742326	2026-01-16 12:05:38.641524
458	Яковлев Савелий Тимурович	s.yakovlev@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2800", "skills": "Kubernetes, Docker, Kafka, gRPC", "status": "На проекте", "project": "Mobile App", "comments": "Ожидает оффер", "contacts": "+7 (935) 236-34-38, @якосаве70, s.yakovlev@rt.ru", "it_block": "B2O", "location": "Гибрид", "position": "Senior Developer", "hire_date": "2019-04-11", "recruiter": "Орлов М.С.", "department": "Backend", "entry_date": "2024-10-25", "resume_link": "https://drive.google.com/file/33401", "ck_department": "Департамент данных", "transfer_date": "2026-08-10", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Госуслуги 2.0, Data Platform, Banking App", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-07-17", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:55.788473	2026-01-16 12:05:38.661918
460	Николаев Максим Ярославович	m.nikolaev@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2910", "skills": "Adobe XD, Figma, Prototyping, User Research", "status": "На проекте", "project": "Service Mesh", "comments": "Ожидает оффер", "contacts": "+7 (969) 327-75-38, @никмакс73, m.nikolaev@rt.ru", "it_block": "НУК", "location": "Санкт-Петербург", "position": "Designer", "hire_date": "2016-03-19", "recruiter": "Смирнова А.А.", "department": "Design", "entry_date": "2024-12-23", "resume_link": "https://drive.google.com/file/65709", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "любой", "current_manager": "Сидорова Е.К.", "target_projects": "Data Platform, Госуслуги 2.0, DevOps Platform", "candidate_status": "Забронирован", "funding_end_date": "2025-04-19", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Да"}	2026-01-15 20:53:55.883846	2026-01-16 12:05:38.685219
462	Андреев Олег Максимович	o.andreev@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1554", "skills": "Adobe XD, UI/UX, Prototyping, Wireframing", "status": "В отпуске", "project": "", "comments": "", "contacts": "+7 (996) 552-21-63, @андолег40, o.andreev@rt.ru", "it_block": "Прочее", "location": "Удалённо", "position": "Designer", "hire_date": "2025-05-18", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2024-02-22", "resume_link": "https://drive.google.com/file/84662", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2026-02-01", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Infrastructure", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-12-11", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:55.959853	2026-01-16 12:05:38.708851
465	Михайлова Людмила Кирилловна	l.mikhaylova@rt.ru	{"grade": "Junior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1094", "skills": "Agile, Stakeholder Management, Scrum, Team Leadership", "status": "На проекте", "project": "DataLake", "comments": "Ожидает оффер", "contacts": "+7 (908) 538-12-65, @михлюдм80, l.mikhaylova@rt.ru", "it_block": "Развитие", "location": "Москва", "position": "Project Manager", "hire_date": "2017-03-24", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2025-04-10", "resume_link": "https://drive.google.com/file/81746", "ck_department": "ЦК Аналитики", "transfer_date": "2026-07-18", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "E-commerce Platform, DevOps Platform", "candidate_status": "Переведен", "funding_end_date": "2026-10-27", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:56.057611	2026-01-16 12:05:38.754572
466	Фролов Кирилл Ярославович	k.frolov@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2672", "skills": "Data Visualization, Python, A/B Testing, Statistics", "status": "На проекте", "project": "RT Cloud", "comments": "Ожидает оффер", "contacts": "+7 (913) 286-13-20, @фрокири83, k.frolov@rt.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Analyst", "hire_date": "2019-01-19", "recruiter": "Орлов М.С.", "department": "Analytics", "entry_date": "2024-10-21", "resume_link": "https://drive.google.com/file/57990", "ck_department": "ЦК Разработки", "transfer_date": "2026-10-12", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "Data Platform, DevOps Platform, ML Pipeline", "candidate_status": "Переведен", "funding_end_date": "2025-10-05", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:56.10995	2026-01-16 12:05:38.77583
468	Николаева Мария Вадимовна	m.nikolaeva@rt.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2893", "skills": "JavaScript, TypeScript, Node.js, HTML/CSS", "status": "На проекте", "project": "5G инфраструктура", "comments": "Ожидает оффер", "contacts": "+7 (901) 589-46-78, @никмари3, m.nikolaeva@rt.ru", "it_block": "Развитие", "location": "Москва", "position": "Senior Developer", "hire_date": "2022-05-22", "recruiter": "Смирнова А.А.", "department": "Frontend", "entry_date": "2024-02-25", "resume_link": "https://drive.google.com/file/82604", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-05-31", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "E-commerce Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-08-08", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:56.210583	2026-01-16 12:05:38.797495
470	Александров Богдан Дмитриевич	b.aleksandrov@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Николаев Артём Вадимович", "salary": "836", "skills": "Jira, Risk Management, Budgeting, Stakeholder Management", "status": "На проекте", "project": "Умный дом Ростелеком", "comments": "", "contacts": "+7 (935) 869-67-18, @алебогд95, b.aleksandrov@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Project Manager", "hire_date": "2024-10-28", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2025-06-02", "resume_link": "https://drive.google.com/file/39107", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Infrastructure", "candidate_status": "Свободен", "funding_end_date": "2025-09-01", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:56.276285	2026-01-16 12:05:38.82293
471	Ильина Мария Артёмовна	m.ilina@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1844", "skills": "JUnit, Performance Testing, Manual Testing, Selenium", "status": "На проекте", "project": "Analytics Dashboard", "comments": "Срочно нужен проект", "contacts": "+7 (959) 625-50-45, @ильмари85, m.ilina@rt.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2024-06-26", "recruiter": "Новикова Е.П.", "department": "QA", "entry_date": "2024-12-20", "resume_link": "https://drive.google.com/file/27437", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "DevOps Platform", "candidate_status": "В работе", "funding_end_date": "2025-07-28", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:56.305482	2026-01-16 12:05:38.845856
506	Орлов Богдан Максимович	b.orlov@rt.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "3911", "skills": "TestNG, Performance Testing, JUnit, JMeter", "status": "На проекте", "project": "Единая биометрическая система", "comments": "Срочно нужен проект", "contacts": "+7 (963) 149-12-28, @орлбогд54, b.orlov@rt.ru", "it_block": "Развитие", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2017-09-14", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2025-10-10", "resume_link": "https://drive.google.com/file/37058", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "ML Pipeline, Infrastructure, Banking App", "candidate_status": "Свободен", "funding_end_date": "2026-06-06", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:57.645371	2026-01-16 12:05:38.867956
508	Семенова Валерия Дмитриевна	v.semenova@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Кузьмина Ксения Павловна", "salary": "1236", "skills": "JUnit, Automation, Performance Testing, TestNG", "status": "На бенче", "project": "", "comments": "В процессе согласования", "contacts": "+7 (903) 689-72-25, @семвале38, v.semenova@rt.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "QA Engineer", "hire_date": "2018-02-13", "recruiter": "Орлов М.С.", "department": "QA", "entry_date": "2025-06-30", "resume_link": "https://drive.google.com/file/42799", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Госуслуги 2.0, E-commerce Platform", "candidate_status": "Свободен", "funding_end_date": "2025-03-24", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:57.712518	2026-01-16 12:05:38.912597
510	Николаев Николай Юрьевич	n.nikolaev@rt.ru	{"grade": "Lead", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "3406", "skills": "Data Visualization, Statistics, Clickhouse, Python", "status": "На проекте", "project": "DevOps Platform", "comments": "Срочно нужен проект", "contacts": "+7 (986) 645-42-92, @никнико47, n.nikolaev@rt.ru", "it_block": "Эксплуатация", "location": "Санкт-Петербург", "position": "Analyst", "hire_date": "2018-06-10", "recruiter": "Белова И.Д.", "department": "Analytics", "entry_date": "2024-07-17", "resume_link": "https://drive.google.com/file/20385", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Mobile App, Data Platform", "candidate_status": "Свободен", "funding_end_date": "2025-10-11", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:57.80295	2026-01-16 12:05:38.938343
512	Николаев Павел Степанович	p.nikolaev@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "Воробьев Вадим Павлович", "salary": "1149", "skills": "Spring Boot, Redis, REST API, Kubernetes", "status": "На проекте", "project": "Service Mesh", "comments": "", "contacts": "+7 (985) 136-91-66, @никпаве77, p.nikolaev@rt.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "Junior Developer", "hire_date": "2018-01-27", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2024-10-15", "resume_link": "https://drive.google.com/file/57158", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-08-08", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Data Platform, Госуслуги 2.0", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-09-03", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:57.900097	2026-01-16 12:05:38.963929
513	Морозова Ольга Егоровна	o.morozova@rt.ru	{"grade": "Lead", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "3458", "skills": "Risk Management, Budgeting, Kanban, Jira", "status": "На проекте", "project": "Партнерский портал", "comments": "Ожидает оффер", "contacts": "+7 (987) 391-35-15, @морольг32, o.morozova@rt.ru", "it_block": "Диджитал", "location": "Гибрид", "position": "Project Manager", "hire_date": "2016-08-23", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2024-10-27", "resume_link": "https://drive.google.com/file/95255", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "Mobile App, E-commerce Platform, Banking App", "candidate_status": "Забронирован", "funding_end_date": "2026-06-19", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:57.93626	2026-01-16 12:05:38.991462
514	Васильева Любовь Кирилловна	l.vasileva@rt.ru	{"grade": "Lead", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "3784", "skills": "Mobile CI/CD, Swift, iOS SDK, Kotlin", "status": "На бенче", "project": "", "comments": "В процессе согласования", "contacts": "+7 (947) 551-31-14, @васлюбо20, l.vasileva@rt.ru", "it_block": "B2O", "location": "Москва", "position": "Team Lead", "hire_date": "2025-01-17", "recruiter": "Смирнова А.А.", "department": "Mobile", "entry_date": "2025-01-01", "resume_link": "https://drive.google.com/file/18256", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Сидорова Е.К.", "target_projects": "ML Pipeline, Infrastructure, DevOps Platform", "candidate_status": "Забронирован", "funding_end_date": "2025-05-31", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:57.962497	2026-01-16 12:05:39.015685
516	Соколов Юрий Артёмович	yu.sokolov@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1775", "skills": "Team Leadership, Scrum, Agile, Jira", "status": "На проекте", "project": "Цифровой офис", "comments": "", "contacts": "+7 (990) 810-31-75, @сокюрий98, yu.sokolov@rt.ru", "it_block": "B2O", "location": "Удалённо", "position": "Project Manager", "hire_date": "2018-07-18", "recruiter": "Смирнова А.А.", "department": "Management", "entry_date": "2025-01-07", "resume_link": "https://drive.google.com/file/91445", "ck_department": "Департамент данных", "transfer_date": "2026-03-08", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Data Platform, DevOps Platform, Госуслуги 2.0", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-10-30", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:58.050466	2026-01-16 12:05:39.037495
20	Яковлев Никита Артёмович	nikita.yakovlev4@company.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2648", "skills": "JavaScript,React", "status": "На проекте", "project": "Infrastructure", "comments": "", "contacts": "+7 (937) 884-64-77, @яконики17, nikita.yakovlev4@company.ru", "it_block": "Эксплуатация", "location": "Санкт-Петербург", "position": "Tech Lead", "hire_date": "2023-03-05", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2024-02-29", "resume_link": "https://drive.google.com/file/21696", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Infrastructure, ML Pipeline, Mobile App", "candidate_status": "Свободен", "funding_end_date": "2026-03-18", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:21.907785	2026-01-16 12:05:39.083369
8	Сидоров Дмитрий Александрович	sidorov@company.ru	{"grade": "Lead", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": 4500, "skills": "Java, Kotlin, Microservices", "status": "На проекте", "project": "Banking App", "comments": "", "contacts": "+7 (973) 187-98-21, @сиддмит80, sidorov@company.ru", "it_block": "B2O", "location": "Москва", "position": "Team Lead", "hire_date": "2018-01-10", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2025-03-07", "resume_link": "https://drive.google.com/file/77521", "ck_department": "ЦК Разработки", "transfer_date": "2025-10-31", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Banking App, E-commerce Platform", "candidate_status": "Переведен", "funding_end_date": "2025-06-22", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 15:53:01.214832	2026-01-16 12:05:39.108934
218	Тестов Тест Тестович	testov@test.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "status": "На проекте", "comments": "", "contacts": "+7 (987) 445-63-61, @тестест71, testov@test.ru", "it_block": "Развитие", "location": "Санкт-Петербург", "position": "DevOps Engineer", "recruiter": "Орлов М.С.", "department": "Backend", "entry_date": "2025-07-24", "resume_link": "https://drive.google.com/file/18806", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "любой", "current_manager": "Козлов Д.В.", "target_projects": "ML Pipeline", "candidate_status": "В работе", "funding_end_date": "2026-09-06", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:41:11.419729	2026-01-16 12:05:39.135167
22	Михайлов Андрей Иванович	maxim.grigoriev6@company.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Kozlova E.A.", "salary": "920", "skills": "PHP,Laravel", "status": "На бенче", "project": "ML Platform", "comments": "", "contacts": "+7 (966) 289-47-10, @михандр53, maxim.grigoriev6@company.ru", "it_block": "Развитие", "location": "Москва", "position": "Junior Developer", "hire_date": "2023-05-11", "recruiter": "Белова И.Д.", "department": "Design", "entry_date": "2024-03-02", "resume_link": "https://drive.google.com/file/75180", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "DevOps Platform, ML Pipeline", "candidate_status": "Забронирован", "funding_end_date": "2025-05-15", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:22.112367	2026-01-16 12:05:39.239758
261	Семенов Денис Тимурович	d.semenov@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1676", "skills": "TypeScript, React, JavaScript, Webpack", "status": "На проекте", "project": "DataLake", "comments": "Ожидает оффер", "contacts": "+7 (917) 238-26-28, @семдени37, d.semenov@rt.ru", "it_block": "Эксплуатация", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2025-09-13", "recruiter": "Смирнова А.А.", "department": "Frontend", "entry_date": "2024-07-24", "resume_link": "https://drive.google.com/file/19602", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Banking App, Infrastructure, E-commerce Platform", "candidate_status": "Забронирован", "funding_end_date": "2025-06-29", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:48.676785	2026-01-16 12:05:39.311714
276	Николаева Наталья Тимуровна	n.nikolaeva@rt.ru	{"grade": "Senior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2907", "skills": "Team Leadership, Agile, Confluence, Scrum", "status": "На проекте", "project": "AI Contact Center", "comments": "Ожидает оффер", "contacts": "+7 (994) 230-60-24, @никната60, n.nikolaeva@rt.ru", "it_block": "Эксплуатация", "location": "Удалённо", "position": "Project Manager", "hire_date": "2025-04-18", "recruiter": "Новикова Е.П.", "department": "Management", "entry_date": "2024-06-05", "resume_link": "https://drive.google.com/file/43842", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-02-25", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "Infrastructure, ML Pipeline, Госуслуги 2.0", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-06-10", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:49.331436	2026-01-16 12:05:39.367482
279	Иванова Алина Андреевна	a.ivanova@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2472", "skills": "gRPC, Kubernetes, REST API, PostgreSQL", "status": "На бенче", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (976) 405-30-14, @иваалин20, a.ivanova@rt.ru", "it_block": "Прочее", "location": "Москва", "position": "Senior Developer", "hire_date": "2016-06-15", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2024-02-15", "resume_link": "https://drive.google.com/file/24605", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Госуслуги 2.0, Banking App, Infrastructure", "candidate_status": "В работе", "funding_end_date": "2025-06-15", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:49.445461	2026-01-16 12:05:39.39156
286	Попова Светлана Павловна	s.popova@rt.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "1367", "skills": "Scrum, Risk Management, Agile, Kanban", "status": "На проекте", "project": "Wink платформа", "comments": "", "contacts": "+7 (935) 205-94-39, @попсвет57, s.popova@rt.ru", "it_block": "Эксплуатация", "location": "Удалённо", "position": "Project Manager", "hire_date": "2020-11-27", "recruiter": "Новикова Е.П.", "department": "Management", "entry_date": "2025-07-19", "resume_link": "https://drive.google.com/file/54087", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "Mobile App, Infrastructure, ML Pipeline", "candidate_status": "Свободен", "funding_end_date": "2025-10-29", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:49.760041	2026-01-16 12:05:39.419974
126	Соколов Егор Владимирович	petr.frolov110@company.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "Kozlova E.A.", "salary": "2753", "skills": "Kotlin,Android", "status": "На бенче", "project": "", "comments": "", "contacts": "+7 (939) 848-80-84, @сокегор71, petr.frolov110@company.ru", "it_block": "B2O", "location": "Санкт-Петербург", "position": "Junior Developer", "hire_date": "2021-11-23", "recruiter": "Новикова Е.П.", "department": "Design", "entry_date": "2025-07-28", "resume_link": "https://drive.google.com/file/19804", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Сидорова Е.К.", "target_projects": "DevOps Platform", "candidate_status": "Забронирован", "funding_end_date": "2026-03-28", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 18:21:33.460877	2026-01-16 12:05:39.444454
319	Андреев Кирилл Ярославович	k.andreev@rt.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "3863", "skills": "Wireframing, Figma, Design Systems, Prototyping", "status": "На проекте", "project": "AI Contact Center", "comments": "Срочно нужен проект", "contacts": "+7 (905) 499-28-11, @андкири31, k.andreev@rt.ru", "it_block": "Диджитал", "location": "Москва", "position": "Designer", "hire_date": "2021-09-23", "recruiter": "Смирнова А.А.", "department": "Design", "entry_date": "2024-08-09", "resume_link": "https://drive.google.com/file/91290", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Data Platform, Госуслуги 2.0", "candidate_status": "Свободен", "funding_end_date": "2026-08-06", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:50.954356	2026-01-16 12:05:39.46654
129	Фёдоров Сергей Евгеньевич	anna.alexeev113@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2768", "skills": "AWS,Terraform", "status": "Болеет", "project": "E-commerce", "comments": "", "contacts": "+7 (977) 727-97-35, @фёдсерг69, anna.alexeev113@company.ru", "it_block": "Эксплуатация", "location": "Удалённо", "position": "Tech Lead", "hire_date": "2019-10-13", "recruiter": "Орлов М.С.", "department": "Frontend", "entry_date": "2024-11-04", "resume_link": "https://drive.google.com/file/78675", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Госуслуги 2.0, Mobile App, DevOps Platform", "candidate_status": "Свободен", "funding_end_date": "2026-03-20", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 18:21:33.792322	2026-01-16 12:05:39.492547
134	Семёнов Кирилл Сергеевич	vadim.zakharov118@company.ru	{"grade": "Lead", "hr_bp": "Лебедева Т.М.", "mentor": "Ivanov A.S.", "salary": "2608", "skills": "Java,Spring", "status": "Болеет", "project": "Analytics Platform", "comments": "Срочно нужен проект", "contacts": "+7 (998) 803-63-11, @семкири4, vadim.zakharov118@company.ru", "it_block": "Прочее", "location": "Удалённо", "position": "Team Lead", "hire_date": "2023-08-11", "recruiter": "Смирнова А.А.", "department": "Backend", "entry_date": "2024-07-22", "resume_link": "https://drive.google.com/file/93017", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "Mobile App", "candidate_status": "В работе", "funding_end_date": "2025-07-14", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:34.324824	2026-01-16 12:05:35.701902
147	Алексеев Михаил Дмитриевич	mikhail.grigoriev131@company.ru	{"grade": "Principal", "hr_bp": "Морозов К.А.", "mentor": "Kozlova E.A.", "salary": "2740", "skills": "Java,Spring", "status": "В отпуске", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (961) 278-80-47, @алемиха52, mikhail.grigoriev131@company.ru", "it_block": "Диджитал", "location": "Санкт-Петербург", "position": "DevOps Engineer", "hire_date": "2022-12-11", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2025-04-21", "resume_link": "https://drive.google.com/file/28616", "ck_department": "Департамент данных", "transfer_date": "2026-09-12", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "ML Pipeline", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-02-20", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:35.709044	2026-01-16 12:05:35.937106
340	Морозова Анастасия Кирилловна	a.morozova@rt.ru	{"grade": "Principal", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "5495", "skills": "Risk Management, Agile, Confluence, Stakeholder Management", "status": "На проекте", "project": "API Gateway", "comments": "Срочно нужен проект", "contacts": "+7 (984) 519-44-89, @моранас54, a.morozova@rt.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Project Manager", "hire_date": "2021-01-15", "recruiter": "Новикова Е.П.", "department": "Management", "entry_date": "2025-07-01", "resume_link": "https://drive.google.com/file/70716", "ck_department": "ЦК Аналитики", "transfer_date": "2026-04-03", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "Mobile App, ML Pipeline", "candidate_status": "Переведен", "funding_end_date": "2025-05-20", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 20:53:51.818983	2026-01-16 12:05:36.173342
380	Волков Денис Романович	d.volkov@rt.ru	{"grade": "Middle", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1493", "skills": "Sketch, User Research, Figma, Prototyping", "status": "На проекте", "project": "Умный дом Ростелеком", "comments": "", "contacts": "+7 (983) 267-23-16, @волдени36, d.volkov@rt.ru", "it_block": "Диджитал", "location": "Москва", "position": "Designer", "hire_date": "2022-08-11", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2024-07-22", "resume_link": "https://drive.google.com/file/50066", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-05-25", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Banking App, Госуслуги 2.0, E-commerce Platform", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2026-02-13", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:53.260161	2026-01-16 12:05:36.389072
386	Смирнов Даниил Павлович	d.smirnov@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "668", "skills": "Adobe XD, Wireframing, User Research, UI/UX", "status": "На проекте", "project": "API Gateway", "comments": "Срочно нужен проект", "contacts": "+7 (978) 435-29-36, @смидани40, d.smirnov@rt.ru", "it_block": "Эксплуатация", "location": "Москва", "position": "Designer", "hire_date": "2022-01-18", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2024-03-03", "resume_link": "https://drive.google.com/file/30562", "ck_department": "ЦК Инфраструктуры", "transfer_date": "", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "ML Pipeline, Banking App, Mobile App", "candidate_status": "Забронирован", "funding_end_date": "2025-11-12", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 20:53:53.527683	2026-01-16 12:05:36.493462
161	Волков Максим Андреевич	arthur.kozlov145@company.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1931", "skills": "Swift,iOS", "status": "Болеет", "project": "Mobile App", "comments": "Срочно нужен проект", "contacts": "+7 (904) 709-49-49, @волмакс71, arthur.kozlov145@company.ru", "it_block": "B2O", "location": "Москва", "position": "Project Manager", "hire_date": "2019-04-28", "recruiter": "Орлов М.С.", "department": "Design", "entry_date": "2025-01-15", "resume_link": "https://drive.google.com/file/73331", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "Mobile App, Data Platform, DevOps Platform", "candidate_status": "Забронирован", "funding_end_date": "2026-10-09", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:37.153421	2026-01-16 12:05:36.704201
183	Попов Артём Павлович	maxim.makarov167@company.ru	{"grade": "Principal", "hr_bp": "Морозов К.А.", "mentor": "Novikova O.P.", "salary": "2425", "skills": "Docker,Kubernetes", "status": "Болеет", "project": "API Gateway", "comments": "В процессе согласования", "contacts": "+7 (914) 642-14-46, @попартё41, maxim.makarov167@company.ru", "it_block": "B2O", "location": "Гибрид", "position": "Team Lead", "hire_date": "2023-12-15", "recruiter": "Орлов М.С.", "department": "QA", "entry_date": "2024-08-04", "resume_link": "https://drive.google.com/file/27593", "ck_department": "Департамент цифровых продуктов", "transfer_date": "", "placement_type": "перевод", "current_manager": "Козлов Д.В.", "target_projects": "Infrastructure, Banking App", "candidate_status": "Забронирован", "funding_end_date": "2026-02-25", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:39.558158	2026-01-16 12:05:36.893358
152	Кузнецов Денис Иванович	egor.vasilev136@company.ru	{"grade": "Middle", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "2705", "skills": "PostgreSQL,Redis", "status": "На проекте", "project": "ML Platform", "comments": "", "contacts": "+7 (995) 851-77-26, @куздени58, egor.vasilev136@company.ru", "it_block": "Эксплуатация", "location": "Гибрид", "position": "Tech Lead", "hire_date": "2021-09-16", "recruiter": "Белова И.Д.", "department": "Management", "entry_date": "2024-05-31", "resume_link": "https://drive.google.com/file/63963", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2026-11-20", "placement_type": "перевод", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-11-27", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 18:21:36.216041	2026-01-16 12:05:36.944248
90	Иванов Александр Александрович	anna.popov74@company.ru	{"grade": "Lead", "hr_bp": "Морозов К.А.", "mentor": "Sidorov K.V.", "salary": "2396", "skills": "PostgreSQL,Redis", "status": "В отпуске", "project": "Refactoring", "comments": "", "contacts": "+7 (913) 885-87-76, @иваалек17, anna.popov74@company.ru", "it_block": "Развитие", "location": "Удалённо", "position": "Project Manager", "hire_date": "2018-01-10", "recruiter": "Белова И.Д.", "department": "Backend", "entry_date": "2025-08-23", "resume_link": "https://drive.google.com/file/49394", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Mobile App, E-commerce Platform", "candidate_status": "Свободен", "funding_end_date": "2026-06-19", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Да"}	2026-01-15 18:21:29.544819	2026-01-16 12:05:37.08888
112	Михайлов Андрей Иванович	alexey.solovyov96@company.ru	{"grade": "Principal", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "2899", "skills": "JavaScript,React", "status": "В отпуске", "project": "", "comments": "В процессе согласования", "contacts": "+7 (980) 161-15-48, @михандр27, alexey.solovyov96@company.ru", "it_block": "Прочее", "location": "Удалённо", "position": "Team Lead", "hire_date": "2021-03-23", "recruiter": "Орлов М.С.", "department": "Analytics", "entry_date": "2025-04-28", "resume_link": "https://drive.google.com/file/40323", "ck_department": "Департамент данных", "transfer_date": "2026-09-05", "placement_type": "любой", "current_manager": "Петров С.М.", "target_projects": "Banking App, DevOps Platform, Data Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-03-13", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:31.958167	2026-01-16 12:05:37.265359
206	Волков Максим Владимирович	maxim.popov190@company.ru	{"grade": "Senior", "hr_bp": "Волкова Н.В.", "mentor": "Kozlova E.A.", "salary": "1866", "skills": "PostgreSQL,Redis", "status": "На проекте", "project": "", "comments": "Срочно нужен проект", "contacts": "+7 (954) 844-12-95, @волмакс15, maxim.popov190@company.ru", "it_block": "B2O", "location": "Москва", "position": "Junior Developer", "hire_date": "2022-12-07", "recruiter": "Смирнова А.А.", "department": "Analytics", "entry_date": "2025-12-30", "resume_link": "https://drive.google.com/file/29996", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "Data Platform, Banking App", "candidate_status": "Забронирован", "funding_end_date": "2025-12-08", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:41.973339	2026-01-16 12:05:39.558249
181	Смирнов Илья Андреевич	mark.novikov165@company.ru	{"grade": "Principal", "hr_bp": "Волкова Н.В.", "mentor": "", "salary": "1833", "skills": "Kotlin,Android", "status": "Болеет", "project": "Performance", "comments": "Ожидает оффер", "contacts": "+7 (967) 632-80-59, @смиилья10, mark.novikov165@company.ru", "it_block": "Развитие", "location": "Удалённо", "position": "Junior Developer", "hire_date": "2023-10-01", "recruiter": "Новикова Е.П.", "department": "Frontend", "entry_date": "2024-01-16", "resume_link": "https://drive.google.com/file/41745", "ck_department": "ЦК Аналитики", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Data Platform, DevOps Platform, Infrastructure", "candidate_status": "Забронирован", "funding_end_date": "2025-05-14", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 18:21:39.342006	2026-01-16 12:05:39.595181
432	Тарасова Валерия Павловна	v.tarasova@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1505", "skills": "Firebase, Mobile CI/CD, iOS SDK, Android SDK", "status": "На проекте", "project": "Партнерский портал", "comments": "Срочно нужен проект", "contacts": "+7 (955) 258-91-30, @тарвале61, v.tarasova@rt.ru", "it_block": "B2O", "location": "Москва", "position": "Middle Developer", "hire_date": "2019-11-30", "recruiter": "Орлов М.С.", "department": "Mobile", "entry_date": "2024-05-29", "resume_link": "https://drive.google.com/file/39511", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-02-18", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "DevOps Platform", "candidate_status": "Переведен", "funding_end_date": "2026-07-18", "manager_feedback": "", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:54.888844	2026-01-16 12:05:39.61626
441	Антонова Алина Константиновна	a.antonova@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1361", "skills": "Webpack, React, Vue.js, Node.js", "status": "На бенче", "project": "", "comments": "", "contacts": "+7 (940) 792-60-93, @анталин30, a.antonova@rt.ru", "it_block": "Развитие", "location": "Гибрид", "position": "Middle Developer", "hire_date": "2022-11-13", "recruiter": "Орлов М.С.", "department": "Frontend", "entry_date": "2024-09-10", "resume_link": "https://drive.google.com/file/81738", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Михайлова О.Н.", "target_projects": "Infrastructure, E-commerce Platform, Госуслуги 2.0", "candidate_status": "В работе", "funding_end_date": "2025-09-07", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.226777	2026-01-16 12:05:39.78445
453	Максимова Александра Юрьевна	a.maksimova@rt.ru	{"grade": "Senior", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "2632", "skills": "Budgeting, Risk Management, Confluence, Jira", "status": "На проекте", "project": "Техподдержка 3.0", "comments": "В процессе согласования", "contacts": "+7 (930) 437-78-22, @макалек9, a.maksimova@rt.ru", "it_block": "B2O", "location": "Москва", "position": "Project Manager", "hire_date": "2019-02-18", "recruiter": "Орлов М.С.", "department": "Management", "entry_date": "2024-03-30", "resume_link": "https://drive.google.com/file/57962", "ck_department": "ЦК Разработки", "transfer_date": "", "placement_type": "аутстафф", "current_manager": "Иванов А.П.", "target_projects": "DevOps Platform, Госуслуги 2.0", "candidate_status": "В работе", "funding_end_date": "2026-03-15", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.605079	2026-01-16 12:05:39.833028
463	Макаров Павел Вадимович	p.makarov@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Медведев Данил Никитич", "salary": "1268", "skills": "Figma, UI/UX, Prototyping, Design Systems", "status": "На проекте", "project": "Партнерский портал", "comments": "", "contacts": "+7 (940) 197-87-38, @макпаве16, p.makarov@rt.ru", "it_block": "B2O", "location": "Удалённо", "position": "Designer", "hire_date": "2025-08-07", "recruiter": "Белова И.Д.", "department": "Design", "entry_date": "2024-01-23", "resume_link": "https://drive.google.com/file/74352", "ck_department": "ЦК Аналитики", "transfer_date": "2026-03-18", "placement_type": "аутстафф", "current_manager": "Козлов Д.В.", "target_projects": "Mobile App, Data Platform, Госуслуги 2.0", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-01-14", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:55.993531	2026-01-16 12:05:39.890084
507	Новиков Никита Владимирович	n.novikov@rt.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "", "salary": "1434", "skills": "Manual Testing, JMeter, Postman, Selenium", "status": "На проекте", "project": "RT Cloud", "comments": "", "contacts": "+7 (956) 110-73-35, @новники56, n.novikov@rt.ru", "it_block": "Прочее", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2022-10-15", "recruiter": "Орлов М.С.", "department": "QA", "entry_date": "2024-06-01", "resume_link": "https://drive.google.com/file/53523", "ck_department": "Департамент данных", "transfer_date": "2025-07-31", "placement_type": "любой", "current_manager": "Михайлова О.Н.", "target_projects": "Mobile App", "candidate_status": "Увольнение по СС", "funding_end_date": "2025-08-02", "manager_feedback": "Отличные результаты", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:57.683763	2026-01-16 12:05:39.942955
517	Соловьев Матвей Андреевич	m.solovev@rt.ru	{"grade": "Lead", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "3596", "skills": "Mobile CI/CD, Android SDK, Kotlin, Flutter", "status": "На бенче", "project": "", "comments": "Ожидает оффер", "contacts": "+7 (914) 215-92-59, @солматв19, m.solovev@rt.ru", "it_block": "B2O", "location": "Москва", "position": "Team Lead", "hire_date": "2018-10-12", "recruiter": "Новикова Е.П.", "department": "Mobile", "entry_date": "2024-12-14", "resume_link": "https://drive.google.com/file/28887", "ck_department": "Департамент данных", "transfer_date": "2025-12-28", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "E-commerce Platform, Infrastructure, DevOps Platform", "candidate_status": "Увольнение по СС", "funding_end_date": "2026-09-20", "manager_feedback": "Нужно развитие", "ready_for_vacancy": "Да"}	2026-01-15 20:53:58.079344	2026-01-16 12:05:40.007517
221	Гусева Ксения Алексеевна	k.guseva@rt.ru	{"grade": "Junior", "hr_bp": "Морозов К.А.", "mentor": "", "salary": "857", "skills": "Scrum, Team Leadership, Agile, Jira", "status": "Болеет", "project": "", "comments": "", "contacts": "+7 (939) 424-25-39, @гусксен90, k.guseva@rt.ru", "it_block": "Развитие", "location": "Удалённо", "position": "Project Manager", "hire_date": "2021-01-29", "recruiter": "Новикова Е.П.", "department": "Management", "entry_date": "2024-08-31", "resume_link": "https://drive.google.com/file/86037", "ck_department": "ЦК Инфраструктуры", "transfer_date": "2025-03-23", "placement_type": "аутстафф", "current_manager": "Петров С.М.", "target_projects": "ML Pipeline, Mobile App", "candidate_status": "Увольнение по СЖ", "funding_end_date": "2025-02-04", "manager_feedback": "Рекомендую", "ready_for_vacancy": "Нет"}	2026-01-15 20:53:46.630567	2026-01-16 12:05:40.051597
239	Ковалева Марина Вадимовна	m.kovaleva@rt.ru	{"grade": "Junior", "hr_bp": "Лебедева Т.М.", "mentor": "Максимов Данил Романович", "salary": "916", "skills": "JUnit, Selenium, Automation, API Testing", "status": "На бенче", "project": "", "comments": "В процессе согласования", "contacts": "+7 (902) 213-84-83, @ковмари88, m.kovaleva@rt.ru", "it_block": "B2O", "location": "Удалённо", "position": "QA Engineer", "hire_date": "2017-10-22", "recruiter": "Смирнова А.А.", "department": "QA", "entry_date": "2024-02-07", "resume_link": "https://drive.google.com/file/42611", "ck_department": "Департамент данных", "transfer_date": "", "placement_type": "перевод", "current_manager": "Михайлова О.Н.", "target_projects": "DevOps Platform, Banking App, Infrastructure", "candidate_status": "В работе", "funding_end_date": "2025-05-04", "manager_feedback": "Хороший специалист", "ready_for_vacancy": "Да"}	2026-01-15 20:53:47.584138	2026-01-16 12:05:40.096382
84	Фёдоров Сергей Сергеевич	tatiana.vorobyov68@company.ru	{"grade": "Middle", "hr_bp": "Лебедева Т.М.", "mentor": "Ivanov A.S.", "salary": "2203", "skills": "Node.js,Express", "status": "Болеет", "project": "CRM System", "comments": "", "contacts": "+7 (951) 846-25-22, @фёдсерг67, tatiana.vorobyov68@company.ru", "it_block": "B2O", "location": "Удалённо", "position": "Project Manager", "hire_date": "2019-08-21", "recruiter": "Белова И.Д.", "department": "Frontend", "entry_date": "2025-11-13", "resume_link": "https://drive.google.com/file/11074", "ck_department": "Департамент цифровых продуктов", "transfer_date": "2026-11-18", "placement_type": "любой", "current_manager": "Иванов А.П.", "target_projects": "ML Pipeline", "candidate_status": "Переведен", "funding_end_date": "2025-05-29", "manager_feedback": "", "ready_for_vacancy": "Да"}	2026-01-15 18:21:28.860655	2026-01-16 12:05:40.168171
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: resourceuser
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	create users table	SQL	V1__create_users_table.sql	-93158329	resourceuser	2026-01-15 15:38:13.898561	21	t
2	2	create dictionaries table	SQL	V2__create_dictionaries_table.sql	-1254384220	resourceuser	2026-01-15 15:38:13.9564	11	t
3	3	create column definitions table	SQL	V3__create_column_definitions_table.sql	486676430	resourceuser	2026-01-15 15:38:13.982071	7	t
4	4	create employees table	SQL	V4__create_employees_table.sql	-70650262	resourceuser	2026-01-15 15:38:13.997608	8	t
5	5	create employee history table	SQL	V5__create_employee_history_table.sql	-2016065729	resourceuser	2026-01-15 15:38:14.013471	11	t
6	6	init data	SQL	V6__init_data.sql	-2125450525	resourceuser	2026-01-15 15:38:14.030587	6	t
7	7	create column presets table	SQL	V7__create_column_presets_table.sql	-1215985081	resourceuser	2026-01-16 09:37:47.424618	60	t
8	8	add is global to column presets	SQL	V8__add_is_global_to_column_presets.sql	-580182228	resourceuser	2026-01-16 10:10:22.117154	24	t
9	9	create saved filters table	SQL	V9__create_saved_filters_table.sql	418614726	resourceuser	2026-01-16 10:10:22.177072	25	t
10	10	create record locks table	SQL	V10__create_record_locks_table.sql	1090507250	resourceuser	2026-01-16 10:10:22.21277	12	t
11	11	create user sessions and users	SQL	V11__create_user_sessions_and_users.sql	-1641335759	resourceuser	2026-01-16 10:46:36.333738	35	t
12	12	create nine box assessments	SQL	V12__create_nine_box_assessments.sql	-1300345994	resourceuser	2026-01-16 14:35:57.496512	87	t
\.


--
-- Data for Name: nine_box_assessments; Type: TABLE DATA; Schema: public; Owner: resourceuser
--

COPY public.nine_box_assessments (id, employee_id, assessed_by, assessed_at, q1_results, q2_goals, q3_quality, q4_growth, q5_leadership, performance_score, potential_score, box_position, comment) FROM stdin;
41	43	1	2026-01-16 18:17:24.05675	5	5	5	1	2	5.00	1.50	3	\N
42	243	1	2026-01-16 18:17:24.159668	1	1	1	3	3	1.00	3.00	4	\N
43	238	1	2026-01-16 18:17:24.279231	3	3	3	3	3	3.00	3.00	5	\N
44	240	1	2026-01-16 18:17:24.386878	5	5	5	3	3	5.00	3.00	6	\N
45	23	1	2026-01-16 18:17:24.494465	1	1	1	5	5	1.00	5.00	7	\N
46	63	1	2026-01-16 18:17:24.592941	3	3	3	5	5	3.00	5.00	8	\N
47	244	1	2026-01-16 18:17:24.688854	5	5	5	5	5	5.00	5.00	9	\N
48	245	1	2026-01-16 18:17:24.800803	1	1	1	1	1	1.00	1.00	1	\N
49	246	1	2026-01-16 18:17:24.92492	3	3	3	1	2	3.00	1.50	2	\N
50	247	1	2026-01-16 18:17:25.038657	5	5	5	1	2	5.00	1.50	3	\N
51	248	1	2026-01-16 18:17:25.175231	1	1	1	3	3	1.00	3.00	4	\N
52	249	1	2026-01-16 18:17:25.307759	3	3	3	3	3	3.00	3.00	5	\N
53	250	1	2026-01-16 18:17:25.443495	5	5	5	3	3	5.00	3.00	6	\N
54	251	1	2026-01-16 18:17:25.56237	1	1	1	5	5	1.00	5.00	7	\N
55	252	1	2026-01-16 18:17:25.664369	3	3	3	5	5	3.00	5.00	8	\N
56	253	1	2026-01-16 18:17:25.766616	5	5	5	5	5	5.00	5.00	9	\N
57	254	1	2026-01-16 18:17:25.877361	1	1	1	1	1	1.00	1.00	1	\N
58	28	1	2026-01-16 18:17:25.979517	3	3	3	1	2	3.00	1.50	2	\N
59	37	1	2026-01-16 18:17:26.090049	5	5	5	1	2	5.00	1.50	3	\N
60	31	1	2026-01-16 18:17:26.203011	1	1	1	3	3	1.00	3.00	4	\N
61	35	1	2026-01-16 18:17:26.324073	3	3	3	3	3	3.00	3.00	5	\N
62	36	1	2026-01-16 18:17:26.427264	5	5	5	3	3	5.00	3.00	6	\N
63	45	1	2026-01-16 18:17:26.54306	1	1	1	5	5	1.00	5.00	7	\N
22	9	1	2026-01-16 18:14:23.991744	3	3	3	1	2	3.00	1.50	2	\N
64	47	1	2026-01-16 18:17:26.669705	3	3	3	5	5	3.00	5.00	8	\N
65	58	1	2026-01-16 18:17:26.767784	5	5	5	5	5	5.00	5.00	9	\N
66	52	1	2026-01-16 18:17:26.859098	1	1	1	1	1	1.00	1.00	1	\N
67	255	1	2026-01-16 18:17:26.948072	3	3	3	1	2	3.00	1.50	2	\N
68	256	1	2026-01-16 18:17:27.042224	5	5	5	1	2	5.00	1.50	3	\N
69	257	1	2026-01-16 18:17:27.136104	1	1	1	3	3	1.00	3.00	4	\N
70	258	1	2026-01-16 18:17:27.23378	3	3	3	3	3	3.00	3.00	5	\N
23	213	1	2026-01-16 18:14:24.101003	5	5	5	1	2	5.00	1.50	3	\N
21	6	1	2026-01-16 18:14:23.885817	1	1	1	1	1	1.00	1.00	1	\N
24	14	1	2026-01-16 18:14:24.211617	1	1	1	3	3	1.00	3.00	4	\N
25	13	1	2026-01-16 18:14:24.307208	3	3	3	3	3	3.00	3.00	5	\N
26	394	1	2026-01-16 18:14:24.422969	5	5	5	3	3	5.00	3.00	6	\N
27	7	1	2026-01-16 18:14:24.520055	1	1	1	5	5	1.00	5.00	7	\N
28	222	1	2026-01-16 18:14:24.617168	3	3	3	5	5	3.00	5.00	8	\N
29	225	1	2026-01-16 18:14:24.754413	5	5	5	5	5	5.00	5.00	9	\N
30	228	1	2026-01-16 18:14:24.876269	1	1	1	1	1	1.00	1.00	1	\N
31	17	1	2026-01-16 18:14:25.01153	3	3	3	1	2	3.00	1.50	2	\N
32	16	1	2026-01-16 18:14:25.135877	5	5	5	1	2	5.00	1.50	3	\N
33	231	1	2026-01-16 18:14:25.264467	1	1	1	3	3	1.00	3.00	4	\N
34	234	1	2026-01-16 18:14:25.372468	3	3	3	3	3	3.00	3.00	5	\N
35	99	1	2026-01-16 18:14:25.476702	5	5	5	3	3	5.00	3.00	6	\N
36	26	1	2026-01-16 18:14:25.578972	1	1	1	5	5	1.00	5.00	7	\N
37	42	1	2026-01-16 18:14:25.702807	3	3	3	5	5	3.00	5.00	8	\N
38	29	1	2026-01-16 18:14:25.799751	5	5	5	5	5	5.00	5.00	9	\N
39	40	1	2026-01-16 18:14:25.890031	1	1	1	1	1	1.00	1.00	1	\N
40	34	1	2026-01-16 18:14:25.995406	3	3	3	1	2	3.00	1.50	2	\N
\.


--
-- Data for Name: record_locks; Type: TABLE DATA; Schema: public; Owner: resourceuser
--

COPY public.record_locks (id, entity_type, entity_id, locked_by, locked_at, expires_at) FROM stdin;
\.


--
-- Data for Name: saved_filters; Type: TABLE DATA; Schema: public; Owner: resourceuser
--

COPY public.saved_filters (id, user_id, name, filter_config, is_global, is_default, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: resourceuser
--

COPY public.user_sessions (id, user_id, session_token, created_at, last_activity) FROM stdin;
6	6	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJVc2VyMSIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzY4NTYyOTU1LCJleHAiOjE3Njg2NDkzNTV9.AgnR5bKayym_PbNoO3gfRWparv9RT8-HcHC5rpRF2EW8y0Z4K-taTgBtHRznKldE	2026-01-16 14:29:15.31986	2026-01-16 14:29:15.319879
22	1	eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTc2ODU3NjY1NCwiZXhwIjoxNzY4NjYzMDU0fQ.YUzsXzhhhv8jJhm2-Qz2qsHfnUCgawpgaWvltZDcOD-19LdRUys3hDhRHUnLsPbw	2026-01-16 18:17:34.083117	2026-01-16 18:17:34.083136
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: resourceuser
--

COPY public.users (id, username, password_hash, role, created_at, created_by) FROM stdin;
1	admin	$2a$10$djI3GzGNAME3s0/TBfNNyOki1bx.UFZASIa0fQDcHUv9C92QjVHN2	ADMIN	2026-01-15 15:38:14.036496	\N
3	Galya	$2a$10$DO9Q43htarIZt1FL9zgO9O7kaRADh3juCG3wCTuPa.kl1k0rvYWw2	ADMIN	2026-01-15 16:55:32.733998	1
4	Kris	$2a$10$NJ8nE/b4Qxj9fHGQLqEI2u2iJaNldH0iNDwABiWe9uZbTJy8NqVme	ADMIN	2026-01-15 16:56:14.733851	1
5	Irek	$2a$10$N8qlRVxtwEitVpp2oktjsO7wx0QvwxSPf3cu0LRAolt4K9BwFdPye	ADMIN	2026-01-15 17:35:10.199379	1
6	User1	$2a$10$wN/a0cGpAH.DOpdYlwBmJeMc6Z35UrBzb/EEgbEdoy.uqsljAil0a	USER	2026-01-16 10:46:36.355208	\N
7	User2	$2a$10$Gt58IiDz8fSlxFdaacBIYO2BTiEGrQTE7V7/ZKQwuFLuHzUoS4Ueq	USER	2026-01-16 10:46:36.355208	\N
8	User3	$2a$10$f0EPp4WS903/IoIglaYwj.lWQPYRW9uXJWdlyB8QVMzh5NAU.C/3G	USER	2026-01-16 10:46:36.355208	\N
9	User4	$2a$10$i87GwQTzSgO0fnFAakkyY.Uw1aTis.PRr7HVhvCOWYQ3sUeQLl3SK	USER	2026-01-16 10:46:36.355208	\N
10	User5	$2a$10$MHw27lR6E9njQLIDiZvkp.lxbCupaZJqFQMtCmJWc/VzOZEaPNmOG	USER	2026-01-16 10:46:36.355208	\N
11	User6	$2a$10$nPFZkDQhuT5JwqBUN65AhONy54PRa90UXbU6En80KxQokmZ5i.oee	USER	2026-01-16 10:46:36.355208	\N
12	User7	$2a$10$NFQF9PlTgi5IYxL0YjIl2e/.hQC.Qv31F7dtV4GBwVlZT8KJxgkwm	USER	2026-01-16 10:46:36.355208	\N
13	User8	$2a$10$pG2If11XogOS.AP6POqYy.wM6DNxor3nOBsESaLir1mevo68XO5fG	USER	2026-01-16 10:46:36.355208	\N
14	User9	$2a$10$vpTNpjMzo0L2PluJRKK9heqT4FF7BcTyTJqrP4xdOKX3hkkrPH20u	USER	2026-01-16 10:46:36.355208	\N
15	User10	$2a$10$3Ec.sTBC1TTH20lhUc4FlOI6HRgae1rtxuPbKHl76DFUnWZYT5HNu	USER	2026-01-16 10:46:36.355208	\N
\.


--
-- Name: column_definitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resourceuser
--

SELECT pg_catalog.setval('public.column_definitions_id_seq', 34, true);


--
-- Name: column_presets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resourceuser
--

SELECT pg_catalog.setval('public.column_presets_id_seq', 2, true);


--
-- Name: dictionaries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resourceuser
--

SELECT pg_catalog.setval('public.dictionaries_id_seq', 15, true);


--
-- Name: employee_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resourceuser
--

SELECT pg_catalog.setval('public.employee_history_id_seq', 7640, true);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resourceuser
--

SELECT pg_catalog.setval('public.employees_id_seq', 521, true);


--
-- Name: nine_box_assessments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resourceuser
--

SELECT pg_catalog.setval('public.nine_box_assessments_id_seq', 70, true);


--
-- Name: record_locks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resourceuser
--

SELECT pg_catalog.setval('public.record_locks_id_seq', 1, true);


--
-- Name: saved_filters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resourceuser
--

SELECT pg_catalog.setval('public.saved_filters_id_seq', 1, false);


--
-- Name: user_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resourceuser
--

SELECT pg_catalog.setval('public.user_sessions_id_seq', 22, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: resourceuser
--

SELECT pg_catalog.setval('public.users_id_seq', 15, true);


--
-- Name: column_definitions column_definitions_name_key; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.column_definitions
    ADD CONSTRAINT column_definitions_name_key UNIQUE (name);


--
-- Name: column_definitions column_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.column_definitions
    ADD CONSTRAINT column_definitions_pkey PRIMARY KEY (id);


--
-- Name: column_presets column_presets_pkey; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.column_presets
    ADD CONSTRAINT column_presets_pkey PRIMARY KEY (id);


--
-- Name: dictionaries dictionaries_name_key; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.dictionaries
    ADD CONSTRAINT dictionaries_name_key UNIQUE (name);


--
-- Name: dictionaries dictionaries_pkey; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.dictionaries
    ADD CONSTRAINT dictionaries_pkey PRIMARY KEY (id);


--
-- Name: employee_history employee_history_pkey; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.employee_history
    ADD CONSTRAINT employee_history_pkey PRIMARY KEY (id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: nine_box_assessments nine_box_assessments_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.nine_box_assessments
    ADD CONSTRAINT nine_box_assessments_employee_id_key UNIQUE (employee_id);


--
-- Name: nine_box_assessments nine_box_assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.nine_box_assessments
    ADD CONSTRAINT nine_box_assessments_pkey PRIMARY KEY (id);


--
-- Name: record_locks record_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.record_locks
    ADD CONSTRAINT record_locks_pkey PRIMARY KEY (id);


--
-- Name: saved_filters saved_filters_pkey; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.saved_filters
    ADD CONSTRAINT saved_filters_pkey PRIMARY KEY (id);


--
-- Name: column_presets uk_column_presets_user_name; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.column_presets
    ADD CONSTRAINT uk_column_presets_user_name UNIQUE (user_id, name);


--
-- Name: record_locks uk_record_lock; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.record_locks
    ADD CONSTRAINT uk_record_lock UNIQUE (entity_type, entity_id);


--
-- Name: saved_filters uk_saved_filters_user_name; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.saved_filters
    ADD CONSTRAINT uk_saved_filters_user_name UNIQUE (user_id, name);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);


--
-- Name: user_sessions user_sessions_user_id_key; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_key UNIQUE (user_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_column_presets_global; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_column_presets_global ON public.column_presets USING btree (is_global) WHERE (is_global = true);


--
-- Name: idx_column_presets_user; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_column_presets_user ON public.column_presets USING btree (user_id);


--
-- Name: idx_employee_history_changed_at; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_employee_history_changed_at ON public.employee_history USING btree (changed_at);


--
-- Name: idx_employee_history_employee; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_employee_history_employee ON public.employee_history USING btree (employee_id);


--
-- Name: idx_employees_custom_fields; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_employees_custom_fields ON public.employees USING gin (custom_fields);


--
-- Name: idx_employees_full_name; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_employees_full_name ON public.employees USING btree (full_name);


--
-- Name: idx_nine_box_assessed_at; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_nine_box_assessed_at ON public.nine_box_assessments USING btree (assessed_at);


--
-- Name: idx_nine_box_box_position; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_nine_box_box_position ON public.nine_box_assessments USING btree (box_position);


--
-- Name: idx_nine_box_employee; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_nine_box_employee ON public.nine_box_assessments USING btree (employee_id);


--
-- Name: idx_record_locks_entity; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_record_locks_entity ON public.record_locks USING btree (entity_type, entity_id);


--
-- Name: idx_record_locks_expires; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_record_locks_expires ON public.record_locks USING btree (expires_at);


--
-- Name: idx_saved_filters_global; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_saved_filters_global ON public.saved_filters USING btree (is_global) WHERE (is_global = true);


--
-- Name: idx_saved_filters_user; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_saved_filters_user ON public.saved_filters USING btree (user_id);


--
-- Name: idx_user_sessions_token; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_user_sessions_token ON public.user_sessions USING btree (session_token);


--
-- Name: idx_user_sessions_user; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_user_sessions_user ON public.user_sessions USING btree (user_id);


--
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: resourceuser
--

CREATE INDEX idx_users_username ON public.users USING btree (username);


--
-- Name: column_definitions column_definitions_dictionary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.column_definitions
    ADD CONSTRAINT column_definitions_dictionary_id_fkey FOREIGN KEY (dictionary_id) REFERENCES public.dictionaries(id);


--
-- Name: column_presets column_presets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.column_presets
    ADD CONSTRAINT column_presets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: employee_history employee_history_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.employee_history
    ADD CONSTRAINT employee_history_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id);


--
-- Name: employee_history employee_history_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.employee_history
    ADD CONSTRAINT employee_history_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: nine_box_assessments nine_box_assessments_assessed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.nine_box_assessments
    ADD CONSTRAINT nine_box_assessments_assessed_by_fkey FOREIGN KEY (assessed_by) REFERENCES public.users(id);


--
-- Name: nine_box_assessments nine_box_assessments_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.nine_box_assessments
    ADD CONSTRAINT nine_box_assessments_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: record_locks record_locks_locked_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.record_locks
    ADD CONSTRAINT record_locks_locked_by_fkey FOREIGN KEY (locked_by) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: saved_filters saved_filters_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.saved_filters
    ADD CONSTRAINT saved_filters_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: resourceuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict XH6VOSVqPIxJd2G2CMZVbiBSNCt8vFxDEcFjBESl2oGPfvGf2VFEyPrR7EjKuNq

