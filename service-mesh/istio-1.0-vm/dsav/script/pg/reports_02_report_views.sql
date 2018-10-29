--
-- Name: 
--    reports_02_report_views.sql
-- Purpose: 
--    This contains the view definitions for the reporting database
--    There are two types of views defined in this file.  
--    1.  Views that represent a report view, abstracting complex joins from the report writer
--    2.  Views that project JSON field data as columns
--
-- \c core_reports specifies to which database to use in pgsql
\c core_reports

BEGIN;

--
-- TOC entry 203 (class 1259 OID 16756)
-- Name: v_coldesc_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_coldesc_list AS
 SELECT columns.table_schema AS schema,
    columns.table_name AS tablename,
    columns.column_name AS columnname,
    pg_description.description
   FROM ((pg_statio_all_tables
     JOIN pg_description ON ((pg_description.objoid = pg_statio_all_tables.relid)))
     JOIN information_schema.columns ON (((pg_description.objsubid = (columns.ordinal_position)::integer) AND ((columns.table_schema)::name = pg_statio_all_tables.schemaname) AND ((columns.table_name)::name = pg_statio_all_tables.relname))))
  WHERE (pg_statio_all_tables.schemaname = 'public'::name);


ALTER TABLE public.v_coldesc_list OWNER TO postgres;

--
-- TOC entry 3841 (class 0 OID 0)
-- Dependencies: 203
-- Name: VIEW v_coldesc_list; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.v_coldesc_list IS 'Returns a list of column descriptions';


--
-- TOC entry 204 (class 1259 OID 16761)
-- Name: v_coldesc_missing_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_coldesc_missing_list AS
 SELECT columns.table_name,
    columns.column_name
   FROM information_schema.columns
  WHERE (((columns.table_schema)::text = 'public'::text) AND (NOT ((((columns.table_name)::text || ','::text) || (columns.column_name)::text) IN ( SELECT (((columns_1.table_name)::text || ','::text) || (columns_1.column_name)::text)
           FROM ((pg_statio_all_tables
             JOIN pg_description ON ((pg_description.objoid = pg_statio_all_tables.relid)))
             JOIN information_schema.columns columns_1 ON (((pg_description.objsubid = (columns_1.ordinal_position)::integer) AND ((columns_1.table_schema)::name = pg_statio_all_tables.schemaname) AND ((columns_1.table_name)::name = pg_statio_all_tables.relname))))
          WHERE (pg_statio_all_tables.schemaname = 'public'::name)))));


ALTER TABLE public.v_coldesc_missing_list OWNER TO postgres;

--
-- TOC entry 3842 (class 0 OID 0)
-- Dependencies: 204
-- Name: VIEW v_coldesc_missing_list; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.v_coldesc_missing_list IS 'Returns a list of columns that have no descriptions';


--
-- TOC entry 205 (class 1259 OID 16766)
-- Name: v_database_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_database_list AS
 SELECT pg_database.datname AS database
   FROM pg_database
  WHERE (pg_database.datistemplate = false);


ALTER TABLE public.v_database_list OWNER TO postgres;

--
-- TOC entry 3843 (class 0 OID 0)
-- Dependencies: 205
-- Name: VIEW v_database_list; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.v_database_list IS 'Returns a list of database names';


--
-- TOC entry 212 (class 1259 OID 20037)
-- Name: v_object_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_object_list AS
 SELECT n.nspname AS schema,
    c.relname AS datname,
        CASE c.relkind
            WHEN 'r'::"char" THEN 'table'::text
            WHEN 'v'::"char" THEN 'view'::text
            WHEN 'i'::"char" THEN 'index'::text
            WHEN 'S'::"char" THEN 'sequence'::text
            WHEN 's'::"char" THEN 'special'::text
            ELSE NULL::text
        END AS type,
    u.usename AS owner
   FROM ((pg_class c
     LEFT JOIN pg_user u ON ((u.usesysid = c.relowner)))
     LEFT JOIN pg_namespace n ON ((n.oid = c.relnamespace)))
  WHERE ((n.nspname = 'public'::name) AND (n.nspname <> ALL (ARRAY['pg_catalog'::name, 'pg_toast'::name, 'information_schema'::name])));


ALTER TABLE public.v_object_list OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 16785)
-- Name: v_tabledesc_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_tabledesc_list AS
 SELECT tables.table_schema AS schema,
    tables.table_name AS tablename,
    pg_description.description
   FROM ((pg_statio_all_tables
     JOIN pg_description ON ((pg_description.objoid = pg_statio_all_tables.relid)))
     JOIN information_schema.tables ON ((((tables.table_schema)::name = pg_statio_all_tables.schemaname) AND ((tables.table_name)::name = pg_statio_all_tables.relname))))
  WHERE (pg_statio_all_tables.schemaname = 'public'::name);


ALTER TABLE public.v_tabledesc_list OWNER TO postgres;

--
-- TOC entry 3844 (class 0 OID 0)
-- Dependencies: 206
-- Name: VIEW v_tabledesc_list; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.v_tabledesc_list IS 'Returns a list of table descriptions';


-- View: public.v_tablecolumn_list

-- DROP VIEW public.v_tablecolumn_list;

CREATE OR REPLACE VIEW public.v_tablecolumn_list AS
 SELECT pg_tables.tablename,
    pg_attribute.attname AS columnname,
    format_type(pg_attribute.atttypid, NULL::integer) AS type,
    pg_attribute.atttypmod AS len,
    ( SELECT col_description(pg_attribute.attrelid, pg_attribute.attnum::integer) AS col_description) AS comment,
        CASE pg_attribute.attnotnull
            WHEN false THEN 1
            ELSE 0
        END AS "notnull",
    pg_constraint.conname AS key,
    pc2.conname AS ckey,
    ( SELECT pg_attrdef.adsrc
           FROM pg_attrdef
          WHERE pg_attrdef.adrelid = pg_class.oid AND pg_attrdef.adnum = pg_attribute.attnum) AS def
   FROM pg_tables,
    pg_class
     JOIN pg_attribute ON pg_class.oid = pg_attribute.attrelid AND pg_attribute.attnum > 0
     LEFT JOIN pg_constraint ON pg_constraint.contype = 'p'::"char" AND pg_constraint.conrelid = pg_class.oid AND (pg_attribute.attnum = ANY (pg_constraint.conkey))
     LEFT JOIN pg_constraint pc2 ON pc2.contype = 'f'::"char" AND pc2.conrelid = pg_class.oid AND (pg_attribute.attnum = ANY (pc2.conkey))
  WHERE pg_class.relname = pg_tables.tablename AND pg_tables.tableowner = "current_user"() AND pg_attribute.atttypid <> 0::oid AND pg_tables.schemaname = 'public'::name
  ORDER BY pg_tables.tablename, pg_attribute.attname;

ALTER TABLE public.v_tablecolumn_list
    OWNER TO postgres;



-- TOC entry 210 (class 1259 OID 20021)
-- Name: v_tablesize_list; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_tablesize_list AS
 SELECT pg_stat_user_tables.schemaname,
    pg_stat_user_tables.relname AS "TableName",
    pg_stat_user_tables.n_live_tup AS "EstimatedRows"
   FROM pg_stat_user_tables
  ORDER BY pg_stat_user_tables.n_live_tup DESC;


ALTER TABLE public.v_tablesize_list OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 21571)
-- Name: vt_accounts; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vt_accounts AS
 SELECT accounts._class,
    accounts.acctgroup,
    accounts.acctnbr,
    accounts.accttitle,
    accounts.closedtm,
    accounts.description,
    accounts.opendtm,
    accounts.broker,
    accounts.folderid,
    accounts.isbrokered,
    accounts.laststmtdtm,
    accounts.nextstmtdtm,
    accounts.stmtfreq,
    accounts.tcdtl,
    accounts.tmzone,
    accounts.rptasof
   FROM public.accounts;


ALTER TABLE public.vt_accounts OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 21561)
-- Name: vt_positions; Type: VIEW; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.vt_positions AS
 SELECT positions.rptasof,
    positions._class,
    positions._cdt,
    positions._ddt,
    positions._id,
    positions._udt,
    positions.acctgroup,
    positions.acctnbr,
    positions.bal,
    positions.closedtm,
    positions.createlogref,
    positions.name,
    positions.opendtm,
    positions.posnref,
    positions.seqnbr,
    positions.authavailbal,
    positions.authodamt,
    positions.availbal,
    positions.collectedbal,
    positions.company,
    positions.components,
    positions.ccycode,
    positions.deptid,
    positions.flags,
    positions.fundexpdtm,
    positions.glcat,
    positions.glsetcode,
    positions.pledgedbal,
    positions.prodname,
    positions.sweepavailbal,
    positions.vertical,
    positions.accumtodtm,
    positions.accrcalctm,
    positions.acrintbal,
    positions.accrminbal,
    positions.adjterm,
    positions.apy,
    positions.apye,
    positions.balopt,
    positions.calcmthd,
    positions.componentname,
    positions.dayslstpost,
    positions.daysnxtpost,
    positions.disbmtopt,
    positions.index,
    positions.intdisbmtinstr,
    positions.is1099exempt,
    positions.iscompounddly,
    positions.iswthfed,
    positions.iswthstate,
    positions.lastpostdtm,
    positions.nomrate,
    positions.nextpostdtm,
    positions.postfreq,
    positions.promodtl,
    positions.promoexpdtm,
    positions.sumaccrbal,
    positions.sumintpd,
    positions.sumwthfed,
    positions.sumwthstate,
    positions.version_int,
    (positions.flags::jsonb ->> 'ishold'::text)::boolean AS ishold,
    (positions.flags::jsonb ->> 'isrestrict'::text)::boolean AS isrestrict,
    (positions.flags::jsonb ->> 'isstop'::text)::boolean AS isstop,
    positions.intdisbmtinstr ->> 'receiverFi'::text AS intdisbmtinstr_receiverfi,
    positions.intdisbmtinstr ->> 'acctNbr'::text AS intdisbmtinstr_acctnbr,
    positions.intdisbmtinstr ->> 'acctTitle'::text AS intdisbmtinstr_accttitle,
    ((positions.intdisbmtinstr ->> 'counterparty'::text)::jsonb) -> 'finInst'::text AS intdisbmtinstr_counterparty_fininst,
    positions.index ->> 'reviewFreq'::text AS index_reviewfreq,
    positions.index ->> 'nextReviewDt'::text AS index_nextreviewdt,
    positions.index ->> 'indexName'::text AS index_indexname,
	  positions.glbal,
	  positions._asofdt
  FROM positions;

ALTER TABLE public.vt_positions
    OWNER TO postgres;


--
-- TOC entry 232 (class 1259 OID 21557)
-- Name: vt_product; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vt_product AS
 SELECT product.rptasof,
    product.ifxaccttype,
    product.avlenddtmm,
    product.avlstartdtmm,
    product.components,
    product.ccycode,
    product.description,
    product.fundterm,
    product.glcat,
    product.glsetcode,
    product.isfedexempt,
    product.isregd,
    product.isstateexempt,
    product.logref,
    product.name,
    product.prodgroup,
    product.prodsubtype,
    product.prodtype,
    product.stmtfreq,
    product.version
   FROM public.product;


ALTER TABLE public.vt_product OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 22729)
-- Name: vr_bal_2; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vr_bal_2

-- DROP VIEW public.vr_bal_2;

CREATE OR REPLACE VIEW public.vr_bal_2 AS
 SELECT vt_positions.rptasof,
    vt_positions.posnref,
    vt_accounts.accttitle,
    vt_positions.prodname,
    vt_product.ifxaccttype,
    vt_positions.glsetcode,
    vt_positions.deptid,
    vt_positions.vertical,
    vt_positions.ccycode,
    vt_positions.bal,
    vt_positions.glbal,
    vt_positions.availbal,
    vt_accounts.isbrokered,
    vt_positions.nomrate,
    vt_positions.apye,
    vt_positions.acrintbal,
    f_tz(vt_positions.lastpostdtm, vt_accounts.tmzone::text) as lastpostdtm,
    f_tz(vt_positions.nextpostdtm, vt_accounts.tmzone::text) as nextpostdtm,
    vt_positions.sumaccrbal,
    vt_positions.sumintpd,
    vt_positions.sumwthfed,
    vt_positions.sumwthstate,
    vt_positions.ishold,
    vt_positions.isrestrict,
    vt_positions.isstop,
    f_tz(vt_positions.index_nextreviewdt::timestamp, vt_accounts.tmzone::text) as index_nextreviewdt,
    f_tz(vt_positions.opendtm, vt_accounts.tmzone::text) as opendtm
   FROM vt_positions
     JOIN vt_accounts ON vt_positions.acctgroup = vt_accounts.acctgroup AND vt_positions.acctnbr::text = vt_accounts.acctnbr::text AND vt_accounts.rptasof::date = vt_positions.rptasof::date
     JOIN vt_product ON vt_product.name::text = vt_positions.prodname::text AND vt_product.rptasof::date = vt_positions.rptasof::date
  WHERE vt_positions.closedtm IS NULL AND vt_product.ifxaccttype::text = 'SDA'::text;

ALTER TABLE public.vr_bal_2
    OWNER TO postgres;
COMMENT ON VIEW public.vr_bal_2
    IS 'Lists all customer position balances for an accounting day';



--
-- TOC entry 222 (class 1259 OID 21279)
-- Name: vt_positiongl; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vt_positiongl AS
 SELECT positiongl.rptasof,
    positiongl._asofdt,
    positiongl._cdt,
    positiongl._ddt,
    positiongl._id,
    positiongl._udt,
    positiongl._class,
    positiongl.company,
    positiongl.ccycode,
    positiongl.deptid,
    positiongl.glcat,
    positiongl.vertical,
    positiongl.acctgroup,
    positiongl.acctnbr,
    positiongl.bal,
    positiongl.closedtm,
    positiongl.createlogref,
    positiongl.name,
    positiongl.opendtm,
    positiongl.posnref,
    positiongl.seqnbr
   FROM public.positiongl;


ALTER TABLE public.vt_positiongl OWNER TO postgres;

--
-- TOC entry 3846 (class 0 OID 0)
-- Dependencies: 222
-- Name: VIEW vt_positiongl; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.vt_positiongl IS 'Contains data or an individual general ledger position, including the current bal';


--
-- TOC entry 236 (class 1259 OID 22279)
-- Name: vr_bal_2a; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vr_bal_2a

-- DROP VIEW public.vr_bal_2a;

CREATE OR REPLACE VIEW public.vr_bal_2a AS
 SELECT vt_positiongl.rptasof,
    vt_accounts.acctgroup,
    vt_accounts.acctnbr,
    vt_positiongl.name,
    vt_positiongl.posnref,
    vt_positiongl.glcat,
        CASE
            WHEN vt_positiongl.glcat = 1 THEN 'A'::text
            WHEN vt_positiongl.glcat = 2 THEN 'L'::text
            WHEN vt_positiongl.glcat = 3 THEN 'C'::text
            WHEN vt_positiongl.glcat = 4 THEN 'R'::text
            WHEN vt_positiongl.glcat = 5 THEN 'E'::text
            ELSE ' '::text
        END AS gltype,
    vt_positiongl.deptid,
    vt_positiongl.vertical,
    vt_positiongl.ccycode,
    vt_positiongl.bal
   FROM vt_positiongl
     JOIN vt_accounts ON vt_accounts.acctgroup = vt_positiongl.acctgroup AND vt_accounts.acctnbr::text = vt_positiongl.acctnbr::text AND vt_accounts.rptasof::date = vt_positiongl.rptasof::date
	;

ALTER TABLE public.vr_bal_2a
    OWNER TO postgres;
COMMENT ON VIEW public.vr_bal_2a
    IS 'Lists all GL position balances for an accounting day';

--
-- TOC entry 231 (class 1259 OID 21553)
-- Name: vt_trncodes; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vt_trncodes AS
 SELECT trncodes.rptasof,
    trncodes.networkexcl,
    trncodes.networkincl,
    trncodes.description,
    trncodes.isaccumdtl,
    trncodes.maxentry,
    trncodes.roleexcl,
    trncodes.roleincl,
    trncodes.trncode
   FROM public.trncodes;


ALTER TABLE public.vt_trncodes OWNER TO postgres;

--
-- TOC entry 3848 (class 0 OID 0)
-- Dependencies: 231
-- Name: VIEW vt_trncodes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON VIEW public.vt_trncodes IS 'Lists the codes that define the posting action that is to occur when a debit or credit is posted to an account';


--
-- TOC entry 242 (class 1259 OID 22643)
-- Name: vt_trnentries; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vt_trnentries

-- DROP VIEW public.vt_trnentries;

CREATE OR REPLACE VIEW public.vt_trnentries AS
 SELECT trnentries._id,
    trnentries._ix,
    trnentries.acctgroup,
    trnentries.acctnbr,
    trnentries.addhold,
    trnentries.amt,
    trnentries.assetclass,
    trnentries.assetid,
    trnentries.auth,
    trnentries.chkitem,
    trnentries.comment,
    trnentries.company,
    trnentries.ccycode,
    trnentries.deptid,
    trnentries.exch,
    trnentries.gldist,
    trnentries.glsetcode,
    trnentries.iscontact,
    trnentries.isdr,
    trnentries.passbook,
    trnentries.posnid,
    trnentries.posnref,
    trnentries.removehold,
    trnentries.rtnbr,
    trnentries.seqnbr,
    trnentries.src,
    trnentries.trace,
    trnentries.vertical,
    case 
		when (trnentries.gldist ->> 'ledger'::text) is not null
			then trnentries.gldist ->> 'ledger'::text
		when (trnentries.gldist ->> 'accrInt'::text) is not null
			then trnentries.gldist ->> 'ledger'::text
		when (trnentries.gldist ->> 'avlInt'::text) is not null
			then trnentries.gldist ->> 'ledger'::text
		when (trnentries.gldist ->> 'negAccr'::text) is not null
			then trnentries.gldist ->> 'ledger'::text
		when (trnentries.gldist ->> 'accrFee'::text) is not null
			then trnentries.gldist ->> 'ledger'::text
		when (trnentries.gldist ->> 'wthState'::text) is not null
			then trnentries.gldist ->> 'ledger'::text
		when (trnentries.gldist ->> 'wthFed'::text) is not null
			then trnentries.gldist ->> 'ledger'::text
		else trnentries.amt::text
	end AS gldist_ledger,
    trnentries.gldist ->> 'accrInt'::text AS gldist_accrint,
    trnentries.gldist ->> 'avlInt'::text AS gldist_avlint,
    trnentries.gldist ->> 'negAccr'::text AS gldist_negaccr,
    trnentries.gldist ->> 'accrFee'::text AS gldist_accrfee,
    trnentries.gldist ->> 'wthState'::text AS gldist_wthstate,
    trnentries.gldist ->> 'wthFed'::text AS gldist_wthfed,
    trnentries.exch ->> 'exchRate'::text AS exch_exchrate,
    trnentries.exch ->> 'baseAmt'::text AS exch_baseamt,
    trnentries.exch ->> 'costRate'::text AS exch_costrate,
    trnentries.exch ->> 'isMultiply'::text AS exch_ismultiply,
    trnentries.exch ->> 'marginCode'::text AS exch_margincode,
    trnentries.exch ->> 'treasRef'::text AS exch_treasref,
    trnentries.passbook ->> 'bookBal'::text AS passbook_bookbal,
    trnentries.passbook ->> 'bookNbr'::text AS passbook_booknbr,
    trnentries.passbook ->> 'isNoBook'::text AS passbook_isnobook,
    trnentries.chkitem ->> 'payee'::text AS chk_payee,
    trnentries.chkitem ->> 'issueDt'::text AS chk_issuedate,
    trnentries.chkitem ->> 'chkNbr'::text AS chk_chknbr,
    trnentries.chkitem ->> 'sprayNbr'::text AS chk_spraynbr,
    trnentries.chkitem ->> 'imageUri'::text AS chk_imguri
   FROM trnentries;

ALTER TABLE public.vt_trnentries
    OWNER TO postgres;
COMMENT ON VIEW public.vt_trnentries
    IS 'Lists the individual debit and credit transactions that make up a trnset';


--
-- TOC entry 230 (class 1259 OID 21544)
-- Name: vt_trnset; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vt_trnset

-- DROP VIEW public.vt_trnset;

CREATE OR REPLACE VIEW public.vt_trnset AS
 SELECT trnset._id,
    trnset.attachs,
    trnset.batchid,
    trnset.bill,
    trnset.network,
    trnset.effectdtm,
    trnset.eft,
    trnset.gljrnldate,
    trnset.logref,
    trnset.mode,
    trnset.note,
    trnset.pmtorder,
    trnset.otherproperties,
    trnset.reverse,
    trnset.reversedby,
    trnset.settledtm,
    trnset.sttn,
    trnset.tags,
    trnset.template,
    trnset.trncode,
    trnset.workitem,
    trnset.eft -> 'network'::text AS eftnetwork,
    trnset.eft -> 'localDt'::text AS eftlocaldtm,
    trnset.eft -> 'journalDt'::text AS eftjrnldtm,
    trnset.eft -> 'msgId'::text AS eftmsgid,
    trnset.eft -> 'authId'::text AS authid,
    trnset.eft -> 'authCd'::text AS authcode,
    trnset.eft -> 'cardNbr'::text AS cardnbr,
    trnset.eft -> 'merch'::text AS merch,
    trnset.eft -> 'eftFee'::text AS eftfee,
    trnset.sttn -> 'device'::text AS device,
    trnset.sttn -> 'localDt'::text AS sttnlocaldtm,
    trnset.sttn -> 'journalDt'::text AS sttnjrnldtm,
    trnset.sttn -> 'branchId'::text AS branchid,
    trnset.sttn -> 'cashierId'::text AS cashierid,
    trnset.sttn -> 'msgId'::text AS sttnmsgid,
    trnset.sttn -> 'receipt'::text AS receipt,
    trnset.sttn -> 'addr'::text AS addr,
    trnset.attachs -> 'name'::text AS attachname,
    trnset.attachs -> 'uri'::text AS attachuri,
	trnset.trndtm
   FROM trnset;

ALTER TABLE public.vt_trnset
    OWNER TO postgres;
COMMENT ON VIEW public.vt_trnset
    IS 'Lists the debit and credit transactions that make up a bald trnsaction';


-- TOC entry 244 (class 1259 OID 22654)
-- Name: vr_bal_5; Type: VIEW; Schema: public; Owner: postgres
--
-- View: public.vr_bal_5

-- DROP VIEW public.vr_bal_5;

CREATE OR REPLACE VIEW public.vr_bal_5 AS
 SELECT DISTINCT vt_positions.rptasof::date AS rptasof,
    vt_positions.acctnbr,
    vt_positions.posnref,
    vt_positions.prodname,
    vt_product.ifxaccttype,
    vt_positions.ccycode,
    vt_trnset.trncode,
    f_tz(vt_trnset.effectdtm, vt_accounts.tmzone::text) AS effectdtm,
    f_tz(vt_trnset.gljrnldate, vt_accounts.tmzone::text) AS gljrnldate,
    vt_trnset.network,
    vt_trnset.batchid,
    vt_trnset.reverse,
    ( SELECT x.tsrevby
           FROM ( SELECT DISTINCT trnset._id AS trnid,
                    trnset.reverse AS trnrev,
                    ts._id AS tsrevby,
                    ts.reverse AS tsrev
                   FROM trnset
                     JOIN trnset ts ON ts.reverse::text = trnset._id::text) x
          WHERE x.trnid::text = vt_trnset._id::text) AS reversedby,
    vt_trnset.mode,
    vt_trnset.logref,
    vt_trncodes.description AS trndesc,
    vt_trnentries.isdr,
    vt_trnentries.amt,
    vt_trnset.trndtm::date AS trndtm,
        CASE
            WHEN vt_trnentries.isdr = true THEN vt_trnentries.amt::text
            ELSE '0'::text
        END AS dramount,
        CASE
            WHEN vt_trnentries.isdr = false THEN vt_trnentries.amt::text
            ELSE '0'::text
        END AS cramount
   FROM vt_trnset
     JOIN vt_trnentries ON vt_trnentries._id::text = vt_trnset._id::text AND vt_trnentries.glsetcode IS NOT NULL
     JOIN vt_positions ON vt_positions._id::text = vt_trnentries.posnid::text AND vt_positions.rptasof::date = vt_trnset.trndtm::date
     JOIN vt_accounts ON vt_positions.acctgroup = vt_accounts.acctgroup AND vt_positions.acctnbr::text = vt_accounts.acctnbr::text AND vt_accounts.rptasof::date = vt_positions.rptasof::date
     JOIN vt_product ON vt_product.name::text = vt_positions.prodname::text AND vt_product.rptasof::date = vt_trnset.trndtm::date
     LEFT JOIN vt_trncodes ON vt_trnset.trncode::text = vt_trncodes.trncode::text AND vt_trnset.trndtm::date = vt_trncodes.rptasof::date;

ALTER TABLE public.vr_bal_5
    OWNER TO postgres;
COMMENT ON VIEW public.vr_bal_5
    IS 'Lists all customer transactions for an accounting day';

--
-- TOC entry 243 (class 1259 OID 22648)
-- Name: vr_bal_6; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vr_bal_6

-- DROP VIEW public.vr_bal_6;

CREATE OR REPLACE VIEW public.vr_bal_6 AS
 SELECT DISTINCT vt_positiongl.rptasof::date AS rptasof,
    vt_trnentries.acctnbr,
    vt_positiongl.posnref,
    vt_positiongl.ccycode,
    vt_trnset.trncode,
    f_tz(vt_trnset.effectdtm, vt_accounts.tmzone::text) AS effectdtm,
    f_tz(vt_trnset.gljrnldate, vt_accounts.tmzone::text) AS gljrnldate,
    vt_trnset.network,
    vt_trnset.batchid,
    vt_trnset.reverse,
    vt_trnset.mode,
    vt_trnset.logref,
    vt_trncodes.description AS trndesc,
    vt_trnentries.isdr,
    vt_trnentries.amt,
        CASE
            WHEN vt_trnentries.isdr = true THEN vt_trnentries.amt
            ELSE '0'::numeric
        END AS dramount,
        CASE
            WHEN vt_trnentries.isdr = false THEN vt_trnentries.amt
            ELSE '0'::numeric
        END AS cramount,
    ( SELECT x.tsrevby
           FROM ( SELECT DISTINCT trnset._id AS trnid,
                    trnset.reverse AS trnrev,
                    ts._id AS tsrevby,
                    ts.reverse AS tsrev
                   FROM trnset
                     JOIN trnset ts ON ts.reverse::text = trnset._id::text) x
          WHERE x.trnid::text = vt_trnset._id::text) AS reversedby,
    vt_trnset._id,
    vt_trnset.trndtm::date AS trndtm
   FROM vt_positiongl
     JOIN vt_trnentries ON vt_positiongl._id::text = vt_trnentries.posnid::text AND vt_trnentries.glsetcode IS NULL
     JOIN vt_trnset ON vt_trnentries._id::text = vt_trnset._id::text
     JOIN vt_accounts ON vt_positiongl.acctgroup = vt_accounts.acctgroup AND vt_positiongl.acctnbr::text = vt_accounts.acctnbr::text AND vt_accounts.rptasof::date = vt_positiongl.rptasof::date
     LEFT JOIN vt_trncodes ON vt_trnset.trncode::text = vt_trncodes.trncode::text AND vt_trnset.trndtm::date = vt_trncodes.rptasof::date;

ALTER TABLE public.vr_bal_6
    OWNER TO postgres;
COMMENT ON VIEW public.vr_bal_6
    IS 'Lists all GL transactions for an accounting day';


--
-- TOC entry 249 (class 1259 OID 22683)
-- Name: vr_dep_4; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vr_dep_4

-- DROP VIEW public.vr_dep_4;

CREATE OR REPLACE VIEW public.vr_dep_4 AS
 SELECT DISTINCT vt_positions.rptasof::date AS rptasof,
    vt_positions.acctnbr,
    vt_positions.posnref,
    vt_positions.prodname,
    vt_product.ifxaccttype,
    vt_positions.glsetcode,
    vt_positions.ccycode,
    vt_trnset.trncode,
    f_tz(vt_trnset.effectdtm, vt_accounts.tmzone::text) AS effectdtm,
    f_tz(vt_trnset.gljrnldate, vt_accounts.tmzone::text) AS gljrnldate,
    f_tz(vt_positions.lastpostdtm, vt_accounts.tmzone::text) AS lastpostdtm,
    f_tz(vt_positions.nextpostdtm, vt_accounts.tmzone::text) AS nextpostdtm,
    vt_positions.nomrate,
    vt_positions.index_indexname,
    vt_positions.index_reviewfreq,
    f_tz(vt_positions.index_nextreviewdt::timestamp without time zone::timestamp with time zone, vt_accounts.tmzone::text) AS index_nextreviewdt,
    vt_positions.apye,
    f_tz(vt_positions.promoexpdtm, vt_accounts.tmzone::text) AS promoexpdtm,
    vt_positions.intdisbmtinstr_receiverfi,
    vt_positions.intdisbmtinstr_acctnbr,
    vt_positions.intdisbmtinstr_accttitle,
    vt_positions.intdisbmtinstr_counterparty_fininst AS counterparty_fininst,
    vt_trnset.network,
    vt_trnset.batchid,
    vt_trnset.reverse,
    vt_trnset.mode,
    vt_trnset.logref,
    vt_trncodes.description AS trndesc,
    vt_trnentries.isdr,
    vt_trnentries.amt,
        CASE
            WHEN vt_trnentries.isdr = true THEN vt_trnentries.amt
            ELSE '0'::numeric
        END AS dramount,
        CASE
            WHEN vt_trnentries.isdr = false THEN vt_trnentries.amt
            ELSE '0'::numeric
        END AS cramount,
    ( SELECT x.tsrevby
           FROM ( SELECT DISTINCT trnset._id AS trnid,
                    trnset.reverse AS trnrev,
                    ts._id AS tsrevby,
                    ts.reverse AS tsrev
                   FROM trnset
                     JOIN trnset ts ON ts.reverse::text = trnset._id::text) x
          WHERE x.trnid::text = vt_trnset._id::text) AS reversedby,
    vt_trnset._id,
    vt_trnset.trndtm::date AS trndtm
   FROM vt_trnentries
     JOIN vt_trnset ON vt_trnset._id::text = vt_trnentries._id::text
     JOIN vt_positions ON vt_positions._id::text = vt_trnentries.posnid::text AND vt_trnset.trndtm::date = vt_positions.rptasof::date
     JOIN vt_accounts ON vt_positions.acctgroup = vt_accounts.acctgroup AND vt_positions.acctnbr::text = vt_accounts.acctnbr::text AND vt_accounts.rptasof::date = vt_positions.rptasof::date
     JOIN vt_product ON vt_product.name::text = vt_positions.prodname::text AND vt_product.rptasof::date = vt_positions.rptasof::date
     LEFT JOIN vt_trncodes ON vt_trnset.trncode::text = vt_trncodes.trncode::text AND vt_trnset.trndtm::date = vt_trncodes.rptasof::date
  WHERE "position"(upper(vt_trnset.tags::text), 'INTERESTPOST'::text) > 0 and
		vt_trnentries.isdr = false
  ;

ALTER TABLE public.vr_dep_4
    OWNER TO postgres;
COMMENT ON VIEW public.vr_dep_4
    IS 'Lists all interest posting credit transactions';


--
-- TOC entry 239 (class 1259 OID 22603)
-- Name: vt_orders; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vt_orders

-- DROP VIEW public.vt_orders;

CREATE OR REPLACE VIEW public.vt_orders AS
 SELECT orders._id,
    orders.rptasof,
    orders.benenetamt,
    orders.cancelby,
    orders.canceldtm,
    orders.chkedby,
    orders.counterparty,
    orders.createby,
    orders.createdtm,
    orders.intermedfi,
    orders.logref,
    orders.network,
    orders.orderamt,
    orders.orderdtm,
    orders.orderinfo,
    orders.ordersrc,
    orders.orderstatus,
    orders.ordertotamt,
    orders.ordertype,
    orders.originsrc,
    orders.originator,
    orders.posnid,
    orders.procdt,
    orders.receiverfee,
    orders.receiverfi,
    orders.remainretry,
    orders.senderfee,
    orders.senderfi,
    orders.threshholdamt,
    orders.verifydtm,
    orders.recur,
    orders.recur ->> 'freq' AS recur_freq,
    orders.recur ->> 'expireDt' AS recur_expdtm,
    orders.recur ->> 'lastDt' AS recur_lastdtm,
    orders.recur ->> 'nextDt' AS recur_nextdtm,
    orders.recur ->> 'count' AS recur_count,
    orders.recur ->> 'remain' AS recur_remain,
    orders.counterparty ->> '_Id' AS counterparty__id,
    orders.counterparty ->> 'acctBranch' AS counterparty_acctbranch,
    orders.counterparty ->> 'acctgroup' AS counterparty_acctgroup,
    orders.counterparty ->> 'acctnbr' AS counterparty_acctnbr,
    orders.counterparty ->> 'accttitle' AS counterparty_accttitle,
    orders.counterparty ->> 'custid' AS counterparty_custid,
    orders.counterparty ->> 'ifxaccttype' AS counterparty_ifxaccttype,
    orders.counterparty ->> 'reference' AS counterparty_reference,
    orders.counterparty ->> 'finInst' AS counterparty_fininst,
    orders.cancelby ->> 'name' AS cancelby_name,
    orders.chkedby ->> 'name' AS chkedby_name,
    orders.createby ->> 'name' AS createby_name,
    orders.originator ->> 'name' AS originator_name,
    orders.intermedfi ->> 'finInstAba' AS intermedfi_fininstaba,
    orders.senderfi ->> 'finInstAba' AS senderfi_fininstaba
   FROM orders;

ALTER TABLE public.vt_orders
    OWNER TO postgres;


--
-- TOC entry 240 (class 1259 OID 22608)
-- Name: vr_dep_5; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vr_dep_5

-- DROP VIEW public.vr_dep_5;

CREATE OR REPLACE VIEW public.vr_dep_5 AS
 SELECT vt_orders.rptasof,
    vt_orders.posnid,
    vt_accounts.accttitle,
        CASE
            WHEN vt_orders.ordertype = 1 THEN 'BkT'::text
            WHEN vt_orders.ordertype = 2 THEN 'PO'::text
            WHEN vt_orders.ordertype = 3 THEN 'CO'::text
            WHEN vt_orders.ordertype = 4 THEN 'SPO'::text
            WHEN vt_orders.ordertype = 5 THEN 'SCO'::text
            ELSE ''::text
        END AS ordertype,
    f_tz(vt_orders.orderdtm, vt_accounts.tmzone::text) AS orderdtm,
    vt_orders.network,
        CASE
            WHEN vt_orders.ordersrc = 1 THEN 'CusDir'::text
            WHEN vt_orders.ordersrc = 2 THEN 'CusInd'::text
            WHEN vt_orders.ordersrc = 3 THEN '3rdPart'::text
            WHEN vt_orders.ordersrc = 4 THEN 'BankOps'::text
            WHEN vt_orders.ordersrc = 5 THEN 'AutoDis'::text
            ELSE ''::text
        END AS ordersrc,
    f_tz(vt_orders.verifydtm, vt_accounts.tmzone::text) AS verifydtm,
    vt_orders.chkedby_name,
        CASE
            WHEN vt_orders.originsrc = 1 THEN 'WEB'::text
            WHEN vt_orders.originsrc = 2 THEN 'PPD'::text
            WHEN vt_orders.originsrc = 3 THEN 'TEL'::text
            ELSE ''::text
        END AS originsrc,
    vt_orders.originator_name,
    f_tz(vt_orders.createdtm, vt_accounts.tmzone::text) AS createdtm,
    vt_orders.createby_name,
    vt_orders.counterparty_accttitle,
        CASE
            WHEN vt_orders.orderstatus = 1 THEN 'Enter'::text
            WHEN vt_orders.orderstatus = 2 THEN 'Ver'::text
            WHEN vt_orders.orderstatus = 3 THEN 'InProc'::text
            WHEN vt_orders.orderstatus = 4 THEN 'Compl'::text
            WHEN vt_orders.orderstatus = 5 THEN 'Cancld'::text
            ELSE ''::text
        END AS orderstatus,
    vt_orders.recur_freq,
    f_tz(vt_orders.recur_expdtm::timestamp, vt_accounts.tmzone::text) AS recur_expdtm,
    f_tz(vt_orders.recur_lastdtm::timestamp, vt_accounts.tmzone::text) AS recur_lastdtm,
    f_tz(vt_orders.recur_nextdtm::timestamp, vt_accounts.tmzone::text) AS recur_nextdtm,
    vt_orders.recur_count,
    vt_orders.recur_remain,
    vt_orders.orderamt,
    vt_orders.threshholdamt,
    vt_positions.availbal,
    vt_positions.bal,
    vt_orders.counterparty_acctnbr
   FROM vt_orders
     JOIN vt_positions ON vt_orders.posnid::text = vt_positions._id::text AND vt_orders.rptasof = vt_positions.rptasof::date
     JOIN vt_accounts ON vt_positions.acctgroup = vt_accounts.acctgroup AND vt_positions.acctnbr::text = vt_accounts.acctnbr::text AND vt_accounts.rptasof::date = vt_positions.rptasof::date;

ALTER TABLE public.vr_dep_5
    OWNER TO postgres;
COMMENT ON VIEW public.vr_dep_5
    IS 'Lists all pending transfer transactions';

--
-- TOC entry 246 (class 1259 OID 22664)
-- Name: vt_trnentryexc; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vt_trnentryexc

-- DROP VIEW public.vt_trnentryexc;

CREATE OR REPLACE VIEW public.vt_trnentryexc AS
 SELECT row_number() OVER (ORDER BY vt_trnentries._id) AS datarow,
    vt_trnentries._id,
    vt_trnentries._ix,
    vt_trnentries.acctgroup,
    vt_trnentries.acctnbr,
    vt_trnentries.posnid,
    vt_trnentries.posnref,
    vt_trnentries.auth -> 'isAuthAll'::text AS authall,
    btrim(elem.value, '"'::text)::jsonb AS exception
   FROM vt_trnentries,
    LATERAL jsonb_array_elements_text(vt_trnentries.auth -> 'exceptions'::text) elem(value)
  WHERE vt_trnentries.auth IS NOT NULL;

ALTER TABLE public.vt_trnentryexc
    OWNER TO postgres;


--
-- TOC entry 247 (class 1259 OID 22669)
-- Name: vt_trnentryexcepts; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vt_trnentryexcepts

-- DROP VIEW public.vt_trnentryexcepts;

CREATE OR REPLACE VIEW public.vt_trnentryexcepts AS
 SELECT vt_trnentryexc.datarow,
    vt_trnentryexc._id,
    vt_trnentryexc._ix,
    vt_trnentryexc.acctgroup,
    vt_trnentryexc.acctnbr,
    vt_trnentryexc.posnid,
    vt_trnentryexc.posnref,
    vt_trnentryexc.authall,
    vt_trnentryexc.exception ->> 'note'::text AS except_note,
    vt_trnentryexc.exception ->> 'exceptCode'::text AS except_code,
    vt_trnentryexc.exception ->> 'reason'::text AS except_reason,
    vt_trnentryexc.exception ->> 'userId'::text AS except_userid
   FROM vt_trnentryexc
  WHERE vt_trnentryexc.exception IS NOT NULL;

ALTER TABLE public.vt_trnentryexcepts
    OWNER TO postgres;



--
-- TOC entry 248 (class 1259 OID 22673)
-- Name: vr_sav_10; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vr_sav_10

-- DROP VIEW public.vr_sav_10;

CREATE OR REPLACE VIEW public.vr_sav_10 AS
 SELECT DISTINCT vt_trnentryexcepts.datarow,
    vt_trnset._id,
    vt_positions.rptasof::date AS rptasof,
    vt_positions.acctnbr,
    vt_positions.posnref,
    vt_positions.prodname,
    vt_product.ifxaccttype,
    vt_positions.ccycode,
    vt_trnset.trncode,
    f_tz(vt_trnset.effectdtm, vt_accounts.tmzone::text) AS effectdtm,
    f_tz(vt_trnset.gljrnldate, vt_accounts.tmzone::text) AS gljrnldate,
    vt_trnset.network,
    vt_trnset.batchid,
    vt_trnset.reverse,
    ( SELECT x.tsrevby
           FROM ( SELECT DISTINCT trnset._id AS trnid,
                    trnset.reverse AS trnrev,
                    ts._id AS tsrevby,
                    ts.reverse AS tsrev
                   FROM trnset
                     JOIN trnset ts ON ts.reverse::text = trnset._id::text) x
          WHERE x.trnid::text = vt_trnset._id::text) AS reversedby,
    vt_trnset.mode,
    vt_trnset.logref,
    vt_trncodes.description AS trndesc,
    vt_trnentries.isdr,
    vt_trnentries.amt,
    vt_trnentryexcepts.authall,
    vt_trnentryexcepts.except_note,
    vt_trnentryexcepts.except_code,
    vt_trnentryexcepts.except_reason,
    vt_trnentryexcepts.except_userid,
    vt_positions.glsetcode,
    vt_trnentries.gldist,
        CASE
            WHEN vt_trnentries.gldist_accrint IS NOT NULL THEN vt_trnentries.gldist_accrint
            ELSE '0'::text
        END AS gldist_accrint,
        CASE
            WHEN vt_trnentries.gldist_avlint IS NOT NULL THEN vt_trnentries.gldist_avlint
            ELSE '0'::text
        END AS gldist_avlint,
        CASE
            WHEN vt_trnentries.gldist_negaccr IS NOT NULL THEN vt_trnentries.gldist_negaccr
            ELSE '0'::text
        END AS gldist_negaccr,
        CASE
            WHEN vt_trnentries.gldist_accrfee IS NOT NULL THEN vt_trnentries.gldist_accrfee
            ELSE '0'::text
        END AS gldist_accrfee,
        CASE
            WHEN vt_trnentries.gldist_wthstate IS NOT NULL THEN vt_trnentries.gldist_wthstate
            ELSE '0'::text
        END AS gldist_wthstate,
        CASE
            WHEN vt_trnentries.gldist_wthfed IS NOT NULL THEN vt_trnentries.gldist_wthfed
            ELSE '0'::text
        END AS gldist_wthfed,
        CASE
            WHEN vt_trnentries.gldist_ledger IS NULL THEN vt_trnentries.amt::text
            ELSE vt_trnentries.gldist_ledger
        END AS gldist_ledger,
        CASE
            WHEN vt_trnentries.isdr = true THEN vt_trnentries.amt::text
            ELSE '0'::text
        END AS dramount,
        CASE
            WHEN vt_trnentries.isdr = false THEN vt_trnentries.amt::text
            ELSE '0'::text
        END AS cramount,
    vt_trnset.trndtm::date AS trndtm
   FROM vt_trnentryexcepts
     JOIN vt_trnentries ON vt_trnentries._id::text = vt_trnentryexcepts._id::text AND vt_trnentries._ix = vt_trnentryexcepts._ix
     JOIN vt_trnset ON vt_trnset._id::text = vt_trnentries._id::text
     JOIN vt_positions ON vt_positions._id::text = vt_trnentries.posnid::text AND vt_trnset.trndtm::date = vt_positions.rptasof::date
     JOIN vt_accounts ON vt_accounts.acctgroup = vt_positions.acctgroup AND vt_accounts.acctnbr::text = vt_positions.acctnbr::text AND vt_accounts.rptasof::date = vt_positions.rptasof::date
     JOIN vt_product ON vt_product.name::text = vt_positions.prodname::text AND vt_product.rptasof::date = vt_positions.rptasof::date
     LEFT JOIN vt_trncodes ON vt_trncodes.trncode::text = vt_trnset.trncode::text
  WHERE vt_trnentryexcepts.datarow IS NOT NULL;

ALTER TABLE public.vr_sav_10
    OWNER TO postgres;
COMMENT ON VIEW public.vr_sav_10
    IS 'Lists all transaction exceptions that were overridden';

-- View: public.vr_sav_10a

-- DROP VIEW public.vr_sav_10a;

CREATE OR REPLACE VIEW public.vr_sav_10a AS
 SELECT DISTINCT vt_trnset._id,
    vt_positions.rptasof::date AS rptasof,
    vt_positions.acctnbr,
    vt_positions.posnref,
    vt_positions.prodname,
    vt_product.ifxaccttype,
    vt_positions.ccycode,
    vt_trnset.trncode,
    f_tz(vt_trnset.effectdtm, vt_accounts.tmzone::text) AS effectdtm,
    f_tz(vt_trnset.gljrnldate, vt_accounts.tmzone::text) AS gljrnldate,
    vt_trnset.network,
    vt_trnset.batchid,
    vt_trnset.reverse,
    ( SELECT x.tsrevby
           FROM ( SELECT DISTINCT trnset._id AS trnid,
                    trnset.reverse AS trnrev,
                    ts._id AS tsrevby,
                    ts.reverse AS tsrev
                   FROM trnset
                     JOIN trnset ts ON ts.reverse::text = trnset._id::text) x
          WHERE x.trnid::text = vt_trnset._id::text) AS reversedby,
    vt_trnset.mode,
    vt_trnset.logref,
    vt_trncodes.description AS trndesc,
    vt_trnentries.isdr,
    vt_trnentries.amt,
    vt_positions.glsetcode,
    vt_trnentries.gldist,
        CASE
            WHEN vt_trnentries.gldist_accrint IS NOT NULL THEN vt_trnentries.gldist_accrint
            ELSE '0'::text
        END AS gldist_accrint,
        CASE
            WHEN vt_trnentries.gldist_avlint IS NOT NULL THEN vt_trnentries.gldist_avlint
            ELSE '0'::text
        END AS gldist_avlint,
        CASE
            WHEN vt_trnentries.gldist_negaccr IS NOT NULL THEN vt_trnentries.gldist_negaccr
            ELSE '0'::text
        END AS gldist_negaccr,
        CASE
            WHEN vt_trnentries.gldist_accrfee IS NOT NULL THEN vt_trnentries.gldist_accrfee
            ELSE '0'::text
        END AS gldist_accrfee,
        CASE
            WHEN vt_trnentries.gldist_wthstate IS NOT NULL THEN vt_trnentries.gldist_wthstate
            ELSE '0'::text
        END AS gldist_wthstate,
        CASE
            WHEN vt_trnentries.gldist_wthfed IS NOT NULL THEN vt_trnentries.gldist_wthfed
            ELSE '0'::text
        END AS gldist_wthfed,
        CASE
            WHEN vt_trnentries.gldist_ledger IS NULL THEN vt_trnentries.amt::text
            ELSE vt_trnentries.gldist_ledger
        END AS gldist_ledger,
        CASE
            WHEN vt_trnentries.isdr = true THEN vt_trnentries.amt
            ELSE '0'::numeric
        END AS dramount,
        CASE
            WHEN vt_trnentries.isdr = false THEN vt_trnentries.amt
            ELSE '0'::numeric
        END AS cramount,
    vt_trnset.trndtm::date AS trndtm
   FROM vt_trnentries
     JOIN vt_trnset ON vt_trnset._id::text = vt_trnentries._id::text
     JOIN vt_positions ON vt_positions._id::text = vt_trnentries.posnid::text AND vt_trnset.trndtm::date = vt_positions.rptasof::date
     JOIN vt_accounts ON vt_accounts.acctgroup = vt_positions.acctgroup AND vt_accounts.acctnbr::text = vt_positions.acctnbr::text AND vt_accounts.rptasof::date = vt_positions.rptasof::date
     JOIN vt_product ON vt_product.name::text = vt_positions.prodname::text AND vt_product.rptasof::date = vt_positions.rptasof::date
     LEFT JOIN vt_trncodes ON vt_trncodes.trncode::text = vt_trnset.trncode::text AND vt_trnset.trndtm::date = vt_trncodes.rptasof::date;

ALTER TABLE public.vr_sav_10a
    OWNER TO postgres;
COMMENT ON VIEW public.vr_sav_10a
    IS 'Lists all transaction details';


--
-- TOC entry 238 (class 1259 OID 22415)
-- Name: vr_sav_11; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vr_sav_11

-- DROP VIEW public.vr_sav_11;

CREATE OR REPLACE VIEW public.vr_sav_11 AS
 SELECT DISTINCT vt_positions.rptasof::date AS rptasof,
    vt_product.ifxaccttype,
    vt_positions.prodname,
    vt_positions.ccycode,
    vt_positions.posnref,
    vt_accounts.accttitle,
    vt_positions.glsetcode,
    vt_positions.deptid,
    vt_positions.vertical,
    vt_positions.nomrate,
    vt_positions.apye,
    vt_positions.availbal,
    vt_positions.bal,
    vt_accounts.isbrokered,
    f_tz(vt_positions.nextpostdtm, vt_accounts.tmzone::text) AS nextpostdtm,
    vt_positions.sumaccrbal,
    vt_positions.sumintpd,
    vt_positions.sumwthfed,
    vt_positions.sumwthstate,
    vt_positions.ishold,
    vt_positions.isrestrict,
    vt_positions.isstop,
    vt_positions.glbal,
    f_tz(vt_positions.opendtm, vt_accounts.tmzone::text) AS opendtm,
    vt_positions.acrintbal
   FROM vt_positions
     JOIN vt_accounts ON vt_accounts.acctgroup = vt_positions.acctgroup AND vt_accounts.acctnbr::text = vt_positions.acctnbr::text AND vt_accounts.rptasof::date = vt_positions.rptasof::date
     JOIN vt_product ON vt_product.name::text = vt_positions.prodname::text AND vt_product.rptasof::date = vt_positions.rptasof::date
  WHERE vt_product.ifxaccttype::text = 'SDA'::text AND vt_positions.closedtm IS NULL;

ALTER TABLE public.vr_sav_11
    OWNER TO postgres;
COMMENT ON VIEW public.vr_sav_11
    IS 'Lists a summary of the balances of positions by product';


--
-- TOC entry 250 (class 1259 OID 22688)
-- Name: vr_sav_2; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vr_sav_2

-- DROP VIEW public.vr_sav_2;

CREATE OR REPLACE VIEW public.vr_sav_2 AS
 SELECT DISTINCT vt_positions.rptasof::date AS rptasof,
    vt_trnset._id,
    vt_accounts.acctnbr,
    vt_accounts.accttitle,
    vt_positions.posnref,
    vt_positions.prodname,
    vt_positions.ccycode,
    vt_trnset.trncode,
    vt_trncodes.description AS trndesc,
    vt_trnset.reverse,
    ( SELECT x.tsrevby
           FROM ( SELECT DISTINCT trnset._id AS trnid,
                    trnset.reverse AS trnrev,
                    ts._id AS tsrevby,
                    ts.reverse AS tsrev
                   FROM trnset
                     JOIN trnset ts ON ts.reverse::text = trnset._id::text) x
          WHERE x.trnid::text = vt_trnset._id::text) AS reversedby,
        CASE
            WHEN vt_trnset.reverse IS NOT NULL THEN true
            ELSE false
        END AS isreverse,
    vt_trnentries.isdr,
    vt_trnentries.amt,
    vt_trnset.network,
        CASE
            WHEN vt_trnentries.isdr = true THEN vt_trnentries.amt
            ELSE '0'::numeric
        END AS dramount,
        CASE
            WHEN vt_trnentries.isdr = false THEN vt_trnentries.amt
            ELSE '0'::numeric
        END AS cramount,
    vt_trnset.trndtm::date AS trndtm,
    f_tz(vt_trnset.effectdtm, vt_accounts.tmzone::text) AS effectdtm,
    f_tz(vt_trnset.gljrnldate, vt_accounts.tmzone::text) AS gljrnldate
   FROM vt_trnentries
     JOIN vt_trnset ON vt_trnset._id::text = vt_trnentries._id::text
     JOIN vt_positions ON vt_positions._id::text = vt_trnentries.posnid::text AND vt_trnset.trndtm::date = vt_positions.rptasof::date
     JOIN vt_product ON vt_product.name::text = vt_positions.prodname::text AND vt_product.rptasof::date = vt_positions.rptasof::date
     JOIN vt_accounts ON vt_accounts.acctgroup = vt_positions.acctgroup AND vt_accounts.acctnbr::text = vt_positions.acctnbr::text AND vt_accounts.rptasof::date = vt_positions.rptasof::date
     LEFT JOIN vt_trncodes ON vt_trnset.trncode::text = vt_trncodes.trncode::text AND vt_trnset.trndtm::date = vt_trncodes.rptasof::date
  WHERE vt_trnentries.isdr = true AND vt_product.isregd = true AND vt_trnentries.gldist_ledger IS NOT NULL;

ALTER TABLE public.vr_sav_2
    OWNER TO postgres;
COMMENT ON VIEW public.vr_sav_2
    IS 'Lists all customer transactions for an accounting day';


--
-- TOC entry 241 (class 1259 OID 22636)
-- Name: vr_sav_6; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vr_sav_6

-- DROP VIEW public.vr_sav_6;

CREATE OR REPLACE VIEW public.vr_sav_6 AS
 SELECT DISTINCT vt_positions.rptasof::date AS rptasof,
    vt_accounts.accttitle,
    vt_positions.posnref,
    vt_positions.prodname,
    vt_product.ifxaccttype,
    vt_positions.glsetcode,
    vt_positions.deptid,
    vt_positions.vertical,
    vt_positions.ccycode,
    f_tz(vt_positions.opendtm, vt_accounts.tmzone::text) AS opendtm,
    vt_accounts.isbrokered,
    vt_positions.nomrate,
    vt_positions.apye,
    vt_positions.availbal,
    vt_positions.bal,
    vt_positions.pledgedbal,
    f_tz(vt_positions.fundexpdtm, vt_accounts.tmzone::text) AS fundexpdtm
   FROM vt_positions
     JOIN vt_accounts ON vt_accounts.acctgroup = vt_positions.acctgroup AND vt_accounts.acctnbr::text = vt_positions.acctnbr::text AND vt_accounts.rptasof::date = vt_positions.rptasof::date
     JOIN vt_product ON vt_product.name::text = vt_positions.prodname::text AND vt_product.rptasof::date = vt_positions.rptasof::date;

ALTER TABLE public.vr_sav_6
    OWNER TO postgres;
COMMENT ON VIEW public.vr_sav_6
    IS 'Lists all new accounts opened on a daily basis';


--
-- TOC entry 245 (class 1259 OID 22659)
-- Name: vr_trns_4; Type: VIEW; Schema: public; Owner: postgres
--

-- View: public.vr_trns_4

-- DROP VIEW public.vr_trns_4;

CREATE OR REPLACE VIEW public.vr_trns_4 AS
 SELECT DISTINCT vt_positions.rptasof::date AS rptasof,
    vt_positions.acctnbr,
    vt_positions.posnref,
    vt_positions.prodname,
    vt_product.ifxaccttype,
    vt_positions.ccycode,
    vt_trnset.trncode,
    f_tz(vt_trnset.effectdtm, vt_accounts.tmzone::text) AS effectdtm,
    f_tz(vt_trnset.gljrnldate, vt_accounts.tmzone::text) AS gljrnldate,
    vt_trnset.network,
    vt_trnset.batchid,
    vt_trnset.reverse,
    ( SELECT x.tsrevby
           FROM ( SELECT DISTINCT trnset._id AS trnid,
                    trnset.reverse AS trnrev,
                    ts._id AS tsrevby,
                    ts.reverse AS tsrev
                   FROM trnset
                     JOIN trnset ts ON ts.reverse::text = trnset._id::text) x
          WHERE x.trnid::text = vt_trnset._id::text) AS reversedby,
    vt_trnset.mode,
    vt_trnset.logref,
    vt_trncodes.description AS trndesc,
    vt_trnentries.isdr,
    vt_trnentries.amt,
        CASE
            WHEN vt_trnentries.isdr = true THEN vt_trnentries.amt
            ELSE '0'::numeric
        END AS dramount,
        CASE
            WHEN vt_trnentries.isdr = false THEN vt_trnentries.amt
            ELSE '0'::numeric
        END AS cramount,
    vt_trnset.trndtm::date AS trndtm
   FROM vt_trnentries
     JOIN vt_trnset ON vt_trnset._id::text = vt_trnentries._id::text
     JOIN vt_positions ON vt_positions._id::text = vt_trnentries.posnid::text AND vt_trnset.trndtm::date = vt_positions.rptasof::date
     JOIN vt_accounts ON vt_accounts.acctgroup = vt_positions.acctgroup AND vt_accounts.acctnbr::text = vt_positions.acctnbr::text AND vt_accounts.rptasof::date = vt_positions.rptasof::date
     JOIN vt_product ON vt_product.name::text = vt_positions.prodname::text AND vt_product.rptasof::date = vt_positions.rptasof::date
     LEFT JOIN vt_trncodes ON vt_trnset.trncode::text = vt_trncodes.trncode::text AND vt_trncodes.rptasof::date = vt_positions.rptasof::date
  WHERE vt_trnset.network IS NULL;

ALTER TABLE public.vr_trns_4
    OWNER TO postgres;
COMMENT ON VIEW public.vr_trns_4
    IS 'Lists all transactions originated from network "SAVANA" which assumes them to be manually input';



--
-- TOC entry 251 (class 1259 OID 22694)
-- Name: vt_addr; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vt_addr AS
 SELECT addr.rptasof,
    addr._id,
    addr.city,
    addr.cntry,
    addr.geoloc,
    addr.postcode,
    addr.premise,
    addr.region,
    addr.street
   FROM public.addr;


ALTER TABLE public.vt_addr OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 22698)
-- Name: vt_customer; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vt_customer AS
 SELECT customer.rptasof,
    customer.custgroup,
    customer.custnbr,
    customer.partyid,
    customer._class,
    customer.contactpref,
    customer.cntry,
    customer.folderid,
    customer.name,
    customer.preferaddrid,
    customer.preferemailid,
    customer.preferphoneid,
    customer.taxid,
    customer."isOrg"
   FROM public.customer;


ALTER TABLE public.vt_customer OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 22702)
-- Name: vt_hold; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vt_hold AS
 SELECT hold.rptasof,
    hold._id,
    hold.acctgroup,
    hold.authref,
    hold.canceldtm,
    hold.dur,
    hold.enddtm,
    hold.holdamt,
    hold.holdtype,
    hold.holdinterval,
    hold.note,
    hold.posnid,
    hold.posnref,
    hold.reason,
    hold.slices,
    hold.startdtm
   FROM public.hold;


ALTER TABLE public.vt_hold OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 22706)
-- Name: vt_organizations; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vt_organizations AS
 SELECT organizations.rptasof,
    organizations._id,
    organizations.dba,
    organizations.dbaname,
    organizations.description,
    organizations.dunsnbr,
    organizations.emaildomain,
    organizations.estdate,
    organizations.isgovtown,
    organizations.isintrntl,
    organizations.ispubliclyheld,
    organizations.issmallbusiness,
    organizations.istaxexempt,
    organizations.legalform,
    organizations.monthfiscalyrend,
    organizations.nbremployed,
    organizations.primarybankid,
    organizations.region,
    organizations.taxexempttype,
    organizations.tradename,
    organizations.websiteurl
   FROM public.organizations;


ALTER TABLE public.vt_organizations OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 22710)
-- Name: vt_persons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vt_persons AS
 SELECT persons.rptasof,
    persons._id,
    persons.agebracket,
    persons.aliases,
    persons.alternatelanguage,
    persons.birthdate,
    persons.citizencntry,
    persons.deathdate,
    persons.education,
    persons.employmentstatus,
    persons.ethnicity,
    persons.familiarname,
    persons.firstname,
    persons.gender,
    persons.govtid,
    persons.incbracket,
    persons.lastname,
    persons.maidenname,
    persons.maritalstatus,
    persons.middlename,
    persons.militarystatus,
    persons.mogrossinc,
    persons.mothersmaidenname,
    persons.nbrinhhold,
    persons.occupation,
    persons.preferredlanguage,
    persons.prefix,
    persons.primaryemployerid,
    persons.residencystatus,
    persons.spouse,
    persons.studenttype,
    persons.suffix,
    persons.webaddr
   FROM public.persons;


ALTER TABLE public.vt_persons OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 22715)
-- Name: vt_positiontd; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vt_positiontd AS
 SELECT positiontd.rptasof,
    positiontd._cts,
    positiontd._dts,
    positiontd._id,
    positiontd._uts,
    positiontd.componentname,
    positiontd.crtermext,
    positiontd.earlydrpen,
    positiontd.expcrgracedtm,
    positiontd.expdrgracedtm,
    positiontd.initterm,
    positiontd.intmatrix,
    positiontd.intrate,
    positiontd.lastrolldtm,
    positiontd.matdisbmtinstr,
    positiontd.maturitydtm,
    positiontd.maturityopt,
    positiontd.notice,
    positiontd.noticedtm,
    positiontd.origrolldtm,
    positiontd.penmatrix,
    positiontd.rateschedmatrix,
    positiontd.rollcnt,
    positiontd.rollcrgrace,
    positiontd.rolldrgraceadj,
    positiontd.rollgracepd,
    positiontd.rollgracerate,
    positiontd.rollprod,
    positiontd.term,
    positiontd.version
   FROM public.positiontd;


ALTER TABLE public.vt_positiontd OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 22720)
-- Name: vt_restrict; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vt_restrict AS
 SELECT restrict.rptasof,
    restrict._id,
    restrict.acctgroup,
    restrict.acctnbr,
    restrict.canceldtm,
    restrict.doc,
    restrict.enddtm,
    restrict.level,
    restrict.note,
    restrict.partyid,
    restrict.posnid,
    restrict.restrictcode,
    restrict.startdtm
   FROM public.restrict;


ALTER TABLE public.vt_restrict OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 22319)
-- Name: vt_trnentryauth; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vt_trnentryauth AS
 SELECT trnentries._id,
    trnentries._ix,
    trnentries.acctgroup,
    trnentries.acctnbr,
    trnentries.posnid,
    trnentries.posnref,
    ARRAY( SELECT btrim(elem.value, '"'::text) AS btrim
           FROM jsonb_array_elements_text((trnentries.auth -> 'exCode'::text)) elem(value)) AS excepts
   FROM public.trnentries;


ALTER TABLE public.vt_trnentryauth OWNER TO postgres;


COMMIT;
