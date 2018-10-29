--
-- Name: 
--    reports_01_init_schema.sql
-- Purpose: 
--    This contains the DDL to initilize the reporting database table structure
--    The reporting schema is different from core server as it redefines the table structure
--    based on reporting requirements 
--
--
-- \c core_reports specifies to which database to use in pgsql
\c core_reports

BEGIN;


-- Table: public.accounts

-- DROP TABLE public.accounts;

CREATE TABLE public.accounts
(
    _class character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    acctgroup integer NOT NULL,
    acctnbr character varying(20) COLLATE pg_catalog."default" NOT NULL,
    accttitle character varying(255) COLLATE pg_catalog."default" NOT NULL,
    closedtm timestamptz DEFAULT NULL,
    description character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    opendtm timestamptz DEFAULT NULL,
    broker jsonb,
    folderid character varying(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    isbrokered boolean,
    laststmtdtm timestamptz DEFAULT NULL,
    nextstmtdtm timestamptz DEFAULT NULL,
    stmtfreq character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    tcdtl jsonb,
    tmzone character varying(3) COLLATE pg_catalog."default",
    rptasof timestamptz NOT NULL,
    CONSTRAINT accounts_pkey PRIMARY KEY (rptasof, acctgroup, acctnbr),
    CONSTRAINT accounts_acctgroup_chk CHECK (acctgroup >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.accounts
    OWNER to postgres;

COMMENT ON COLUMN public.accounts._class
    IS 'The class of the account';

COMMENT ON COLUMN public.accounts.acctgroup
    IS 'Account Group code';

COMMENT ON COLUMN public.accounts.acctnbr
    IS 'The unique account identifier within an accountGroup';

COMMENT ON COLUMN public.accounts.accttitle
    IS 'The account title';

COMMENT ON COLUMN public.accounts.closedtm
    IS 'Date the account was closed';

COMMENT ON COLUMN public.accounts.description
    IS 'Account description';

COMMENT ON COLUMN public.accounts.opendtm
    IS 'Date the account was opened';

COMMENT ON COLUMN public.accounts.broker
    IS 'Broker originating the account';

COMMENT ON COLUMN public.accounts.folderid
    IS 'Documents and attachs folder Id';

COMMENT ON COLUMN public.accounts.isbrokered
    IS 'Indicates whether or not the account was originated by a broker';

COMMENT ON COLUMN public.accounts.laststmtdtm
    IS 'Last statement creation date-time';

COMMENT ON COLUMN public.accounts.nextstmtdtm
    IS 'Next statement creation date-time';

COMMENT ON COLUMN public.accounts.stmtfreq
    IS 'Default freq to create a statement';

COMMENT ON COLUMN public.accounts.tcdtl
    IS 'Version and date of the term and conditions signed by the account owner(s)';

COMMENT ON COLUMN public.accounts.tmzone
    IS 'Time zone assigned to account for daily procing window';

COMMENT ON COLUMN public.accounts.rptasof
    IS 'The date the table data changed';
    
-- Table: public.addr

-- DROP TABLE public.addr;

CREATE TABLE public.addr
(
    rptasof timestamptz NOT NULL,
    _id character varying(42) COLLATE pg_catalog."default" NOT NULL,
    city character varying(40) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    cntry character varying(2) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    geoloc jsonb,
    postcode character varying(9) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    premise character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    region character varying(2) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    street text COLLATE pg_catalog."default",
    CONSTRAINT addr_pkey PRIMARY KEY (rptasof, _id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.addr
    OWNER to postgres;
COMMENT ON TABLE public.addr
    IS 'Contains addr data for customers';

COMMENT ON COLUMN public.addr.rptasof
    IS 'The date the table data changed';

COMMENT ON COLUMN public.addr._id
    IS 'The unique addr identifier';

COMMENT ON COLUMN public.addr.city
    IS 'Address city';

COMMENT ON COLUMN public.addr.cntry
    IS 'Address cntry';

COMMENT ON COLUMN public.addr.geoloc
    IS 'Fixed geographic location of addr';

COMMENT ON COLUMN public.addr.postcode
    IS 'The addr postal code';

COMMENT ON COLUMN public.addr.premise
    IS 'Name location or building name';

COMMENT ON COLUMN public.addr.region
    IS 'State,  Province,  County or Land  Province  County or Land';

COMMENT ON COLUMN public.addr.street
    IS 'Street number,  PO box or RD and street name  PO box or RD and street name';    

-- Table: public.customer

-- DROP TABLE public.customer;

CREATE TABLE public.customer
(
    rptasof timestamptz NOT NULL,
    custgroup character varying(20) COLLATE pg_catalog."default" NOT NULL,
    custnbr character varying(20) COLLATE pg_catalog."default" NOT NULL,
    partyid character varying(42) COLLATE pg_catalog."default" NOT NULL,
    _class character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    contactpref smallint,
    cntry character varying(2) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    folderid character varying(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    name character varying(80) COLLATE pg_catalog."default" NOT NULL,
    preferaddrid character varying(42) COLLATE pg_catalog."default" NOT NULL,
    preferemailid smallint,
    preferphoneid smallint,
    taxid character varying(11) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    "isOrg" boolean NOT NULL DEFAULT false,
    CONSTRAINT customer_pkey PRIMARY KEY (rptasof, custgroup, custnbr),
    CONSTRAINT customer_contactpref_chk CHECK (contactpref >= 0),
    CONSTRAINT customer_preferemailid_chk CHECK (preferemailid >= 0),
    CONSTRAINT customer_preferphoneid_chk CHECK (preferphoneid >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.customer
    OWNER to postgres;

COMMENT ON COLUMN public.customer.rptasof
    IS 'The date the table data changed';

COMMENT ON COLUMN public.customer.custgroup
    IS 'Customer group';

COMMENT ON COLUMN public.customer.custnbr
    IS 'The unique customer identifier within a customer type';

COMMENT ON COLUMN public.customer.partyid
    IS 'Unique Party identifier';

COMMENT ON COLUMN public.customer._class
    IS 'The class of the party';

COMMENT ON COLUMN public.customer.contactpref
    IS 'The mthd of contact preference';

COMMENT ON COLUMN public.customer.cntry
    IS 'Country of residence or registration ISO 3166-2';

COMMENT ON COLUMN public.customer.folderid
    IS 'Partys documents and attachs root folder Id';

COMMENT ON COLUMN public.customer.name
    IS 'Formatted full name of party';

COMMENT ON COLUMN public.customer.preferaddrid
    IS 'Preferred addr identifier';

COMMENT ON COLUMN public.customer.preferemailid
    IS 'Preferred email identifier';

COMMENT ON COLUMN public.customer.preferphoneid
    IS 'Preferred phone number identifier';

COMMENT ON COLUMN public.customer.taxid
    IS 'US taxid or social security number';
    
-- Table: public.hold

-- DROP TABLE public.hold;

CREATE TABLE public.hold
(
    rptasof timestamptz NOT NULL,
    _id character varying(42) COLLATE pg_catalog."default" NOT NULL,
    acctgroup integer,
    authref character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    canceldtm timestamptz DEFAULT NULL,
    dur character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    enddtm timestamptz DEFAULT NULL,
    holdamt numeric(16,2) DEFAULT NULL::numeric,
    holdtype smallint,
    holdinterval character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    note text COLLATE pg_catalog."default",
    posnid character varying(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    posnref character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    reason character varying(10) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    slices jsonb,
    startdtm timestamptz DEFAULT NULL,
    CONSTRAINT hold_pkey PRIMARY KEY (rptasof, _id),
    CONSTRAINT "hold_acctGroup_chk" CHECK (acctgroup >= 0),
    CONSTRAINT "hold_holdType_chk" CHECK (holdtype >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.hold
    OWNER to postgres;

COMMENT ON COLUMN public.hold.rptasof
    IS 'The date the table data changed';

COMMENT ON COLUMN public.hold._id
    IS 'Unique hold identifier';

COMMENT ON COLUMN public.hold.acctgroup
    IS 'Account Group code';

COMMENT ON COLUMN public.hold.authref
    IS 'External reference for authorization hold';

COMMENT ON COLUMN public.hold.canceldtm
    IS 'Date and time hold was cancelled';

COMMENT ON COLUMN public.hold.dur
    IS 'Duration of the hold determines endDt';

COMMENT ON COLUMN public.hold.enddtm
    IS 'Date and time hold will expire - default 10/15/2114-23:59';

COMMENT ON COLUMN public.hold.holdamt
    IS 'Amount to hold  default to entry.trnAmt';

COMMENT ON COLUMN public.hold.holdtype
    IS 'The hold type code';

COMMENT ON COLUMN public.hold.holdinterval
    IS 'Duration of a slice interval if slices (e.g.  (1D)';

COMMENT ON COLUMN public.hold.note
    IS 'Free form accompanying note';

COMMENT ON COLUMN public.hold.posnid
    IS 'Unique position identifier';

COMMENT ON COLUMN public.hold.posnref
    IS 'The unique position identifier within an acctGroup';

COMMENT ON COLUMN public.hold.reason
    IS 'The reason code for why hold was placed';

COMMENT ON COLUMN public.hold.slices
    IS 'Slice amt';

COMMENT ON COLUMN public.hold.startdtm
    IS 'Date and time hold will start - default immediately';
    


-- Table: public.orders

-- DROP TABLE public.orders;

CREATE TABLE public.orders
(
    _id character varying(42) COLLATE pg_catalog."default" NOT NULL,
    benenetamt numeric(16,2) DEFAULT NULL::numeric,
    cancelby json,
    canceldtm timestamptz DEFAULT NULL,
    chkedby json,
    counterparty json NOT NULL,
    createby json,
    createdtm timestamptz DEFAULT NULL,
    intermedfi json,
    logref character varying(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    network character varying(12) COLLATE pg_catalog."default" NOT NULL,
    orderamt numeric(16,2) NOT NULL,
    orderdtm timestamptz NOT NULL,
    orderinfo text COLLATE pg_catalog."default",
    ordersrc smallint,
    orderstatus smallint,
    ordertotamt numeric(16,2) NOT NULL,
    ordertype smallint NOT NULL,
    originsrc smallint,
    originator json NOT NULL,
    posnid character varying(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    procdt timestamptz DEFAULT NULL,
    receiverfee json,
    receiverfi json,
    RemainRetry smallint NOT NULL,
    senderfee json,
    senderfi json,
    threshholdamt numeric(16,2) DEFAULT NULL::numeric,
    verifydtm timestamptz DEFAULT NULL,
    rptasof date NOT NULL,
    recur jsonb,
    CONSTRAINT order_pkey PRIMARY KEY (_id),
    CONSTRAINT orders_remainretries_chk CHECK (remainretry >= 0),
    CONSTRAINT order_ordersrc_chk CHECK (ordersrc >= 0),
    CONSTRAINT order_orderstatus_chk CHECK (orderstatus >= 0),
    CONSTRAINT order_ordertype_chk CHECK (ordertype >= 0),
    CONSTRAINT order_originsrc_chk CHECK (originsrc >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.orders
    OWNER to postgres;

COMMENT ON COLUMN public.orders._id
    IS 'Unique order identifier';

COMMENT ON COLUMN public.orders.benenetamt
    IS 'Beneficiary customer total settled amt (sent amt - receiver fees)';

COMMENT ON COLUMN public.orders.cancelby
    IS 'Order canceled by';

COMMENT ON COLUMN public.orders.canceldtm
    IS 'Order canceled on datetime';

COMMENT ON COLUMN public.orders.chkedby
    IS 'Order verified by (i.e., chker)';

COMMENT ON COLUMN public.orders.counterparty
    IS 'The counterparty of the order';

COMMENT ON COLUMN public.orders.createby
    IS 'Order created by (i.e., maker)';

COMMENT ON COLUMN public.orders.createdtm
    IS 'Order created on date';

COMMENT ON COLUMN public.orders.intermedfi
    IS 'Sending Fi to receiver Fi intermediate institution';

COMMENT ON COLUMN public.orders.logref
    IS 'Order create log reference';

COMMENT ON COLUMN public.orders.network
    IS 'Payment network type';

COMMENT ON COLUMN public.orders.orderamt
    IS 'The amt of the order, net to trnsfer to receiver';

COMMENT ON COLUMN public.orders.orderdtm
    IS 'Order scheduled to be proced on datetime';

COMMENT ON COLUMN public.orders.orderinfo
    IS 'Originator to beneficiary information';

COMMENT ON COLUMN public.orders.ordersrc
    IS 'The src that originated the order';

COMMENT ON COLUMN public.orders.orderstatus
    IS 'The status of the order';

COMMENT ON COLUMN public.orders.ordertotamt
    IS 'Ordering customer total settled amt, order amt plus fees';

COMMENT ON COLUMN public.orders.ordertype
    IS 'The type of order';

COMMENT ON COLUMN public.orders.originsrc
    IS 'The origination src by which the order is placed (e.g. web or telephone)';

COMMENT ON COLUMN public.orders.originator
    IS 'The party that originated the order';

COMMENT ON COLUMN public.orders.posnid
    IS 'Related Position Id';

COMMENT ON COLUMN public.orders.procdt
    IS 'Order actually proced on datetime';

COMMENT ON COLUMN public.orders.receiverfee
    IS 'Total fees charged by receiving institution';

COMMENT ON COLUMN public.orders.receiverfi
    IS 'Receiving institution correspondent bank';

COMMENT ON COLUMN public.orders.remainretry
    IS 'Number of retry attempts remain';

COMMENT ON COLUMN public.orders.senderfee
    IS 'Total fees charged by sending institution';

COMMENT ON COLUMN public.orders.senderfi
    IS 'Sending institution correspondent bank';

COMMENT ON COLUMN public.orders.threshholdamt
    IS 'Amount used to determine bal for threshold trnsfer';

COMMENT ON COLUMN public.orders.verifydtm
    IS 'Order verified on datetime';

COMMENT ON COLUMN public.orders.rptasof
    IS 'The date the table data changed';
    
-- Table: public.organizations

-- DROP TABLE public.organizations;

CREATE TABLE public.organizations
(
    rptasof timestamptz NOT NULL,
    _id character varying(42) COLLATE pg_catalog."default" NOT NULL,
    dba character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    dbaname character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    description character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    dunsnbr bigint,
    emaildomain character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    estdate date,
    isgovtown boolean,
    isintrntl boolean,
    ispubliclyheld boolean,
    issmallbusiness boolean,
    istaxexempt boolean,
    legalform smallint,
    monthfiscalyrend smallint,
    nbremployed smallint,
    primarybankid character varying(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    region character varying(2) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    taxexempttype smallint,
    tradename character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    websiteurl character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    CONSTRAINT organizations_pkey PRIMARY KEY (rptasof, _id),
    CONSTRAINT organizations_dunsnbr_chk CHECK (dunsnbr >= 0),
    CONSTRAINT organizations_legalform_chk CHECK (legalform >= 0),
    CONSTRAINT organizations_monthfiscalyrend_chk CHECK (monthfiscalyrend >= 0),
    CONSTRAINT organizations_nbremployed_chk CHECK (nbremployed >= 0),
    CONSTRAINT organizations_taxexempttype_chk CHECK (taxexempttype >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.organizations
    OWNER to postgres;

COMMENT ON COLUMN public.organizations.rptasof
    IS 'The date the table data changed';

COMMENT ON COLUMN public.organizations._id
    IS 'Unique Party identifier';

COMMENT ON COLUMN public.organizations.dba
    IS 'DBA or trade name';

COMMENT ON COLUMN public.organizations.dbaname
    IS 'Doing business as name';

COMMENT ON COLUMN public.organizations.description
    IS 'Description of the organization';

COMMENT ON COLUMN public.organizations.dunsnbr
    IS 'A unique nine-digit number assigned to the company by Dun & Bradstreet  if applicable';

COMMENT ON COLUMN public.organizations.emaildomain
    IS 'Principal email domain';

COMMENT ON COLUMN public.organizations.estdate
    IS 'The organizations date of establishment';

COMMENT ON COLUMN public.organizations.isgovtown
    IS 'Indictaes whether the organization a government-owned entity';

COMMENT ON COLUMN public.organizations.isintrntl
    IS 'Indicates whether the orginization is international';

COMMENT ON COLUMN public.organizations.ispubliclyheld
    IS 'Indicates whether the organiziation is publicly held';

COMMENT ON COLUMN public.organizations.issmallbusiness
    IS 'Indicates whether the organization is classified a small business';

COMMENT ON COLUMN public.organizations.istaxexempt
    IS 'Indicates if the organization is tax-exempt';

COMMENT ON COLUMN public.organizations.legalform
    IS 'Legal form of organization';

COMMENT ON COLUMN public.organizations.monthfiscalyrend
    IS 'The month of organizations fiscal year end date';

COMMENT ON COLUMN public.organizations.nbremployed
    IS 'Number of persons employed';

COMMENT ON COLUMN public.organizations.primarybankid
    IS 'The bank with which the organization has the majority of its financial dealings';

COMMENT ON COLUMN public.organizations.region
    IS 'The state or region of registration';

COMMENT ON COLUMN public.organizations.taxexempttype
    IS 'The tax exempt entity type';

COMMENT ON COLUMN public.organizations.tradename
    IS 'The organizations trade name';

COMMENT ON COLUMN public.organizations.websiteurl
    IS 'The organizations home page';    

-- Table: public.persons

-- DROP TABLE public.persons;

CREATE TABLE public.persons
(
    rptasof timestamptz NOT NULL,
    _id character(42) COLLATE pg_catalog."default" NOT NULL,
    agebracket smallint,
    aliases jsonb,
    alternatelanguage character varying(20) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    birthdate date,
    citizencntry character varying(2) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    deathdate date,
    education smallint,
    employmentstatus smallint,
    ethnicity smallint,
    familiarname character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    firstname character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    gender smallint,
    govtid jsonb,
    incbracket smallint,
    lastname character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    maidenname character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    maritalstatus smallint,
    middlename character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    militarystatus smallint,
    mogrossinc numeric(16,2) DEFAULT NULL::numeric,
    mothersmaidenname character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    nbrinhhold smallint,
    occupation smallint,
    preferredlanguage character varying(20) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    prefix character varying(20) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    primaryemployerid character(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    residencystatus smallint,
    spouse character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    studenttype smallint,
    suffix character varying(20) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    webaddr character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    CONSTRAINT persons_pkey PRIMARY KEY (rptasof, _id),
    CONSTRAINT persons_agebracket_chk CHECK (agebracket >= 0),
    CONSTRAINT persons_education_chk CHECK (education >= 0),
    CONSTRAINT persons_employmentstatus_chk CHECK (employmentstatus >= 0),
    CONSTRAINT persons_ethnicity_chk CHECK (ethnicity >= 0),
    CONSTRAINT persons_gender_chk CHECK (gender >= 0),
    CONSTRAINT persons_incbracket_chk CHECK (incbracket >= 0),
    CONSTRAINT persons_maritalstatus_chk CHECK (maritalstatus >= 0),
    CONSTRAINT persons_militarystatus_chk CHECK (militarystatus >= 0),
    CONSTRAINT persons_nbrinhhold_chk CHECK (nbrinhhold >= 0),
    CONSTRAINT persons_occupation_chk CHECK (occupation >= 0),
    CONSTRAINT persons_residencystatus_chk CHECK (residencystatus >= 0),
    CONSTRAINT persons_studenttype_chk CHECK (studenttype >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.persons
    OWNER to postgres;

COMMENT ON COLUMN public.persons.rptasof
    IS 'The date the table data changed';

COMMENT ON COLUMN public.persons._id
    IS 'Unique Party identifier';

COMMENT ON COLUMN public.persons.agebracket
    IS 'A group of people having approximately the same age (range)';

COMMENT ON COLUMN public.persons.aliases
    IS 'Alias name';

COMMENT ON COLUMN public.persons.alternatelanguage
    IS 'Alternate contact language IETF RFC 5646';

COMMENT ON COLUMN public.persons.birthdate
    IS 'The Person’s date of birth';

COMMENT ON COLUMN public.persons.citizencntry
    IS 'Country of which the person is a citizen ISO 3166-2';

COMMENT ON COLUMN public.persons.deathdate
    IS 'The Person’s date of death';

COMMENT ON COLUMN public.persons.education
    IS 'The highest education level achieved';

COMMENT ON COLUMN public.persons.employmentstatus
    IS 'Employment Status code';

COMMENT ON COLUMN public.persons.ethnicity
    IS 'The person’s race or ethnic origin';

COMMENT ON COLUMN public.persons.familiarname
    IS 'Familiar name for the person';

COMMENT ON COLUMN public.persons.firstname
    IS 'The person’s first name';

COMMENT ON COLUMN public.persons.gender
    IS 'The Person’s gender';

COMMENT ON COLUMN public.persons.govtid
    IS 'Government issued identification documents';

COMMENT ON COLUMN public.persons.incbracket
    IS 'Income range of person';

COMMENT ON COLUMN public.persons.lastname
    IS 'The person’s last name';

COMMENT ON COLUMN public.persons.maidenname
    IS 'The person’s maiden name if applicable';

COMMENT ON COLUMN public.persons.maritalstatus
    IS 'The person’s marital status';

COMMENT ON COLUMN public.persons.middlename
    IS 'The person’s middle name';

COMMENT ON COLUMN public.persons.militarystatus
    IS 'The person’s military status (i.e  active duty  veteran)';

COMMENT ON COLUMN public.persons.mogrossinc
    IS 'The monthly income earned by the person';

COMMENT ON COLUMN public.persons.mothersmaidenname
    IS 'The maiden name of the person’s mother';

COMMENT ON COLUMN public.persons.nbrinhhold
    IS 'The number of occupants in the person’s household';

COMMENT ON COLUMN public.persons.occupation
    IS 'The person’s occupational cat code';

COMMENT ON COLUMN public.persons.preferredlanguage
    IS 'Preferred contact language IETF RFC 5646';

COMMENT ON COLUMN public.persons.prefix
    IS 'Honorific prefix';

COMMENT ON COLUMN public.persons.primaryemployerid
    IS 'The Person’s current primary employer';

COMMENT ON COLUMN public.persons.residencystatus
    IS 'Residency Status';

COMMENT ON COLUMN public.persons.spouse
    IS 'The name of the Person’s spouse if applicable';

COMMENT ON COLUMN public.persons.studenttype
    IS 'Person’s current student status';

COMMENT ON COLUMN public.persons.suffix
    IS 'Honorific suffix (e.g.  MD  DDS';

COMMENT ON COLUMN public.persons.webaddr
    IS 'Person’s individual website';
    
-- Table: public.positions

-- DROP TABLE public.positions;

CREATE TABLE public.positions
(
    rptasof timestamptz NOT NULL,
    _class character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    _cdt timestamptz DEFAULT NULL,
    _ddt timestamptz DEFAULT NULL,
    _id character varying(42) COLLATE pg_catalog."default" NOT NULL,
    _asofdt timestamptz DEFAULT NULL,
    _udt timestamptz DEFAULT NULL,
    acctgroup integer NOT NULL,
    acctnbr character varying(20) COLLATE pg_catalog."default" NOT NULL,
    bal numeric(16,2) NOT NULL,
    glbal numeric(16,2),
    closedtm timestamptz DEFAULT NULL,
    createlogref character varying(42) COLLATE pg_catalog."default" ,
    name character varying(40) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    opendtm timestamptz NOT NULL,
    posnref character varying(30) COLLATE pg_catalog."default" NOT NULL,
    seqnbr integer NOT NULL,
    authavailbal numeric(16,2) DEFAULT NULL::numeric,
    authodamt numeric(16,2) DEFAULT NULL::numeric,
    availbal numeric(16,2) DEFAULT NULL::numeric,
    collectedbal numeric(16,2) DEFAULT NULL::numeric,
    company integer DEFAULT 0,
    components jsonb,
    ccycode character varying(3) COLLATE pg_catalog."default" NOT NULL DEFAULT 'USD'::character varying,
    deptid integer NOT NULL DEFAULT 0,
    flags text COLLATE pg_catalog."default",
    fundexpdtm timestamptz DEFAULT NULL,
    glcat smallint NOT NULL,
    glsetcode character varying(20) COLLATE pg_catalog."default" NOT NULL,
    pledgedbal numeric(16,2) DEFAULT NULL::numeric,
    prodname character varying(30) COLLATE pg_catalog."default" NOT NULL,
    sweepavailbal numeric(16,2) DEFAULT NULL::numeric,
    vertical integer NOT NULL DEFAULT 0,
    accumtodtm timestamptz,
    accrcalctm character varying(255) COLLATE pg_catalog."default" DEFAULT '11:59'::character varying,
    acrintbal numeric(16,5) DEFAULT NULL::numeric,
    accrminbal numeric(16,2) DEFAULT NULL::numeric,
    adjterm character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    apy numeric(16,5) DEFAULT NULL::numeric,
    apye numeric(16,5) DEFAULT NULL::numeric,
    balopt smallint DEFAULT 0,
    calcmthd smallint,
    componentname character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    dayslstpost bigint,
    daysnxtpost bigint,
    disbmtopt smallint,
    index jsonb,
    intdisbmtinstr jsonb,
    is1099exempt boolean DEFAULT false,
    iscompounddly boolean,
    iswthfed boolean NOT NULL DEFAULT false,
    iswthstate boolean NOT NULL DEFAULT false,
    lastpostdtm timestamptz,
    nomrate numeric(16,5) DEFAULT NULL::numeric,
    nextpostdtm timestamptz,
    postfreq character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    promodtl jsonb,
    promoexpdtm timestamptz DEFAULT NULL,
    sumaccrbal numeric(16,5) DEFAULT NULL::numeric,
    sumintpd numeric(16,2) DEFAULT NULL::numeric,
    sumwthfed numeric(16,2) DEFAULT NULL::numeric,
    sumwthstate numeric(16,2) DEFAULT NULL::numeric,
    version_int integer,
    CONSTRAINT position_pkey PRIMARY KEY (rptasof, _id),
    CONSTRAINT position_acctgroup_chk CHECK (acctgroup >= 0),
    CONSTRAINT position_company_chk CHECK (company >= 0),
    CONSTRAINT position_deptid_chk CHECK (deptid >= 0),
    CONSTRAINT position_glcat_chk CHECK (glcat >= 0),
    CONSTRAINT position_seqnbr_chk CHECK (seqnbr >= 0),
    CONSTRAINT positionint_balopt_chk CHECK (balopt >= 0),
    CONSTRAINT positionint_calcmthd_chk CHECK (calcmthd >= 0),
    CONSTRAINT positionint_disbmtopt_chk CHECK (disbmtopt >= 0),
    CONSTRAINT positionint_version_chk CHECK (version_int >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.positions
    OWNER to postgres;

COMMENT ON COLUMN public.positions.rptasof
    IS 'The date the table data changed';

COMMENT ON COLUMN public.positions._class
    IS 'The class of the position';

COMMENT ON COLUMN public.positions._cdt
    IS 'Create Time Stamp';

COMMENT ON COLUMN public.positions._ddt
    IS 'Delete Time Stamp';

COMMENT ON COLUMN public.positions._id
    IS 'Unique position identifier';

COMMENT ON COLUMN public.positions._asofdt
    IS 'AsOf Time Stamp';

COMMENT ON COLUMN public.positions._udt
    IS 'Update Time Stamp';

COMMENT ON COLUMN public.positions.acctgroup
    IS 'Account Group code';

COMMENT ON COLUMN public.positions.acctnbr
    IS 'The unique account identifier within an acctGroup';

COMMENT ON COLUMN public.positions.bal
    IS 'Current bal or quantity of the position';

COMMENT ON COLUMN public.positions.glbal
    IS 'Current bal or quantity of the position by gl journal date';

COMMENT ON COLUMN public.positions.closedtm
    IS 'Datetime position closed for use';

COMMENT ON COLUMN public.positions.createlogref
    IS 'Position created log references';

COMMENT ON COLUMN public.positions.name
    IS 'Unique position name within an account';

COMMENT ON COLUMN public.positions.opendtm
    IS 'Datetime position opened for use';

COMMENT ON COLUMN public.positions.seqnbr
    IS 'Transaction sequence number in position';

COMMENT ON COLUMN public.positions.authavailbal
    IS 'Available bal plus the authd overdraft amt';

COMMENT ON COLUMN public.positions.authodamt
    IS 'Lowest ledger bal on account before considered NSF';

COMMENT ON COLUMN public.positions.availbal
    IS 'Available bal on position ledgerBal - active monetary holds';

COMMENT ON COLUMN public.positions.collectedbal
    IS 'Balance that has been settled through banks clearing system';

COMMENT ON COLUMN public.positions.company
    IS 'Company reported';

COMMENT ON COLUMN public.positions.components
    IS 'List of components used by the product';

COMMENT ON COLUMN public.positions.ccycode
    IS 'Currency code ISO 4217';

COMMENT ON COLUMN public.positions.deptid
    IS 'Balancing department or cost center Id';

COMMENT ON COLUMN public.positions.flags
    IS 'Process condition flags for holds  restricts  stops';

COMMENT ON COLUMN public.positions.fundexpdtm
    IS 'Date-time by which position must be funded';

COMMENT ON COLUMN public.positions.glcat
    IS 'GL cat code';

COMMENT ON COLUMN public.positions.glsetcode
    IS 'GL account numbers set code';

COMMENT ON COLUMN public.positions.pledgedbal
    IS 'Pledged initial funding bal';

COMMENT ON COLUMN public.positions.prodname
    IS 'Positions product';

COMMENT ON COLUMN public.positions.sweepavailbal
    IS 'Currently available to be trnsferred from other accounts to prevent NSF';

COMMENT ON COLUMN public.positions.vertical
    IS 'Vertical reported';

COMMENT ON COLUMN public.positions.accumtodtm
    IS 'Accrued interest accumulated through datetime';

COMMENT ON COLUMN public.positions.accrcalctm
    IS 'Cutoff time for accrual calculation';

COMMENT ON COLUMN public.positions.accrminbal
    IS 'Minimum bal to accrue';

COMMENT ON COLUMN public.positions.adjterm
    IS 'Term where rate can be adjusted and replaced if higher';

COMMENT ON COLUMN public.positions.balopt
    IS 'Balance used to calculate accrual';

COMMENT ON COLUMN public.positions.calcmthd
    IS 'Interest accrual calculation mthd';

COMMENT ON COLUMN public.positions.componentname
    IS 'Interest component name';

COMMENT ON COLUMN public.positions.disbmtopt
    IS 'Interest disbursement option';

COMMENT ON COLUMN public.positions.index
    IS 'Indexed rate properties and limits';

COMMENT ON COLUMN public.positions.is1099exempt
    IS 'If exempt do not create a 1099-Int for the position';

COMMENT ON COLUMN public.positions.iscompounddly
    IS 'Flag indicates daily interest compounding at accrual cutoff';

COMMENT ON COLUMN public.positions.iswthfed
    IS 'Is subject to federal withholding';

COMMENT ON COLUMN public.positions.iswthstate
    IS 'Is subject to state withholding';

COMMENT ON COLUMN public.positions.lastpostdtm
    IS 'Date interest was last posted';

COMMENT ON COLUMN public.positions.nomrate
    IS 'Current nominal interest rate';

COMMENT ON COLUMN public.positions.nextpostdtm
    IS 'Date interest next posted';

COMMENT ON COLUMN public.positions.postfreq
    IS 'Interest posting freq';

COMMENT ON COLUMN public.positions.promodtl
    IS 'Promotional rate properties and limits';

COMMENT ON COLUMN public.positions.promoexpdtm
    IS 'Date promotional interest rate expires and position reverts to standard rate';

COMMENT ON COLUMN public.positions.sumaccrbal
    IS 'Sum accrued interest bal';

COMMENT ON COLUMN public.positions.sumintpd
    IS 'Sum of interest paid on position';

COMMENT ON COLUMN public.positions.sumwthfed
    IS 'Sum of federal withholding on position';

COMMENT ON COLUMN public.positions.sumwthstate
    IS 'Sum of state withholding on position';

COMMENT ON COLUMN public.positions.version_int
    IS 'Interest component version';
    
-- Table: public.positiongl

-- DROP TABLE public.positiongl;

CREATE TABLE public.positiongl
(
    rptasof timestamptz NOT NULL,
    _asofdt timestamptz DEFAULT NULL,
    _cdt timestamptz DEFAULT NULL,
    _ddt timestamptz DEFAULT NULL,
    _id character varying(42) COLLATE pg_catalog."default" NOT NULL,
    _udt timestamptz DEFAULT NULL,
    _class character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    company integer DEFAULT 0,
    ccycode character varying(3) COLLATE pg_catalog."default" NOT NULL DEFAULT 'USD'::character varying,
    deptid integer NOT NULL DEFAULT 0,
    glcat smallint NOT NULL,
    vertical integer NOT NULL DEFAULT 0,
    acctgroup integer NOT NULL,
    acctnbr character varying(20) COLLATE pg_catalog."default" NOT NULL,
    bal numeric(16,2) NOT NULL,
    closedtm timestamptz DEFAULT NULL,
    createlogref character varying(42) COLLATE pg_catalog."default",
    name character varying(40) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    opendtm timestamptz NOT NULL,
    posnref character varying(30) COLLATE pg_catalog."default" NOT NULL,
    seqnbr integer NOT NULL,
    CONSTRAINT positiongl_pkey PRIMARY KEY (rptasof, _id),
    CONSTRAINT positiongl_acctgroup_chk CHECK (acctgroup >= 0),
    CONSTRAINT positiongl_company_chk CHECK (company >= 0),
    CONSTRAINT positiongl_deptid_chk CHECK (deptid >= 0),
    CONSTRAINT positiongl_glcat_chk CHECK (glcat >= 0),
    CONSTRAINT positiongl_seqnbr_chk CHECK (seqnbr >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.positiongl
    OWNER to postgres;

COMMENT ON COLUMN public.positiongl.rptasof
    IS 'The date the table data changed';

COMMENT ON COLUMN public.positiongl._asofdt
    IS 'AsOf Time Stamp';

COMMENT ON COLUMN public.positiongl._cdt
    IS 'Create Time Stamp';

COMMENT ON COLUMN public.positiongl._ddt
    IS 'Delete Time Stamp';

COMMENT ON COLUMN public.positiongl._id
    IS 'Unique position identifier';

COMMENT ON COLUMN public.positiongl._udt
    IS 'Update Time Stamp';

COMMENT ON COLUMN public.positiongl._class
    IS 'The class of the posn';

COMMENT ON COLUMN public.positiongl.company
    IS 'Company reported';

COMMENT ON COLUMN public.positiongl.ccycode
    IS 'Currency code';

COMMENT ON COLUMN public.positiongl.deptid
    IS 'Balancing department or cost center Id';

COMMENT ON COLUMN public.positiongl.glcat
    IS 'GL cat code';

COMMENT ON COLUMN public.positiongl.vertical
    IS 'Vertical reported';

COMMENT ON COLUMN public.positiongl.acctnbr
    IS 'The unique account identifier within an acctGroup';

COMMENT ON COLUMN public.positiongl.bal
    IS 'Current bal or quantity of the position';

COMMENT ON COLUMN public.positiongl.closedtm
    IS 'Datetime position closed for use';

COMMENT ON COLUMN public.positiongl.createlogref
    IS 'Position created log references';

COMMENT ON COLUMN public.positiongl.name
    IS 'Unique position name within an account';

COMMENT ON COLUMN public.positiongl.opendtm
    IS 'Datetime position opened for use';

COMMENT ON COLUMN public.positiongl.posnref
    IS 'The unique position identifier within an acctGroup';

COMMENT ON COLUMN public.positiongl.seqnbr
    IS 'Transaction sequence number in position';

    
-- Table: public.positiontd

-- DROP TABLE public.positiontd;

CREATE TABLE public.positiontd
(
    rptasof timestamptz NOT NULL,
    _cts timestamptz DEFAULT NULL,
    _dts timestamptz DEFAULT NULL,
    _id character varying(42) COLLATE pg_catalog."default" NOT NULL,
    _uts timestamptz DEFAULT NULL,
    componentname character varying(30) COLLATE pg_catalog."default" NOT NULL,
    crtermext character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    earlydrpen smallint,
    expcrgracedtm timestamptz DEFAULT NULL,
    expdrgracedtm timestamptz DEFAULT NULL,
    initterm character varying(30) COLLATE pg_catalog."default" NOT NULL,
    intmatrix character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    intrate numeric(16,5) DEFAULT NULL::numeric,
    lastrolldtm timestamptz DEFAULT NULL,
    matdisbmtinstr jsonb,
    maturitydtm timestamptz NOT NULL,
    maturityopt smallint,
    notice character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    noticedtm timestamptz DEFAULT NULL,
    origrolldtm timestamptz DEFAULT NULL,
    penmatrix character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    rateschedmatrix character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    rollcnt smallint DEFAULT 0,
    rollcrgrace character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    rolldrgraceadj smallint,
    rollgracepd character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    rollgracerate character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    rollprod character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    term character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    version integer NOT NULL,
    CONSTRAINT positiontd_pkey PRIMARY KEY (rptasof, _id),
    CONSTRAINT positiontd_earlydrpen_chk CHECK (earlydrpen >= 0),
    CONSTRAINT positiontd_maturityopt_chk CHECK (maturityopt >= 0),
    CONSTRAINT positiontd_rollcnt_chk CHECK (rollcnt >= 0),
    CONSTRAINT positiontd_rolldrgraceadj_chk CHECK (rolldrgraceadj >= 0),
    CONSTRAINT positiontd_version_chk CHECK (version >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.positiontd
    OWNER to postgres;

COMMENT ON COLUMN public.positiontd.rptasof
    IS 'The date the table data changed';

COMMENT ON COLUMN public.positiontd._cts
    IS 'Create Time Stamp';

COMMENT ON COLUMN public.positiontd._dts
    IS 'Delete Time Stamp';

COMMENT ON COLUMN public.positiontd._id
    IS 'Unique position identifier';

COMMENT ON COLUMN public.positiontd._uts
    IS 'Update Time Stamp';

COMMENT ON COLUMN public.positiontd.componentname
    IS 'Term component name';

COMMENT ON COLUMN public.positiontd.crtermext
    IS 'Extension to the maturity date when credits are made outside the rollover credit grace period';

COMMENT ON COLUMN public.positiontd.earlydrpen
    IS 'Method used to calculate an early withdrawal penalty';

COMMENT ON COLUMN public.positiontd.expcrgracedtm
    IS 'Credit expiration date and time for the current term';

COMMENT ON COLUMN public.positiontd.expdrgracedtm
    IS 'Debit expiration date and time for the current term';

COMMENT ON COLUMN public.positiontd.initterm
    IS 'Initial term';

COMMENT ON COLUMN public.positiontd.intmatrix
    IS 'Matrix used to determine interest rate';

COMMENT ON COLUMN public.positiontd.intrate
    IS 'Fixed interest rate';

COMMENT ON COLUMN public.positiontd.lastrolldtm
    IS 'Date and time the position last rolled over';

COMMENT ON COLUMN public.positiontd.maturitydtm
    IS 'Date and time the position will mature';

COMMENT ON COLUMN public.positiontd.maturityopt
    IS 'Maturity option';

COMMENT ON COLUMN public.positiontd.notice
    IS 'Notification period prior to maturity';

COMMENT ON COLUMN public.positiontd.noticedtm
    IS 'Date and time of next maturity notification';

COMMENT ON COLUMN public.positiontd.origrolldtm
    IS 'Date and time the position first rolled over';

COMMENT ON COLUMN public.positiontd.penmatrix
    IS 'Provides values used in early withdrawal penalty calculation';

COMMENT ON COLUMN public.positiontd.rateschedmatrix
    IS 'Matrix used to determine term';

COMMENT ON COLUMN public.positiontd.rollcnt
    IS 'Number of times the position has rolled over';

COMMENT ON COLUMN public.positiontd.rollcrgrace
    IS 'Period after rollover where deposits can be made without extending the term';

COMMENT ON COLUMN public.positiontd.rolldrgraceadj
    IS 'Adjustment to accrued interest on funds withdrawn during grace period';

COMMENT ON COLUMN public.positiontd.rollgracepd
    IS 'Period after rollover when withdrawals can be made without penalty';

COMMENT ON COLUMN public.positiontd.rollgracerate
    IS 'Matrix used to determine accrual adjustment rate for withdrawals during debit grace period';

COMMENT ON COLUMN public.positiontd.rollprod
    IS 'Product the term deposit rolling over rolls into';

COMMENT ON COLUMN public.positiontd.term
    IS 'Term assigned to position';

COMMENT ON COLUMN public.positiontd.version
    IS 'Term component version';
    

-- Table: public.product

-- DROP TABLE public.product;

CREATE TABLE public.product
(
    rptasof timestamptz NOT NULL,
    ifxaccttype character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    avlenddtmm timestamptz DEFAULT NULL,
    avlstartdtmm timestamptz DEFAULT NULL,
    components jsonb,
    ccycode character varying(3) COLLATE pg_catalog."default" DEFAULT 'USD'::character varying,
    description character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    fundterm character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    glcat smallint,
    glsetcode character varying(20) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    isfedexempt boolean,
    isregd boolean,
    isstateexempt boolean,
    logref character varying(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    prodgroup character varying(10) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    prodsubtype character varying(10) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    prodtype character varying(10) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    stmtfreq character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    version integer,
    CONSTRAINT product_pkey PRIMARY KEY (rptasof, name),
    CONSTRAINT product_version_chk CHECK (version >= 0),
    CONSTRAINT product_glcat_chk CHECK (glcat >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.product
    OWNER to postgres;

COMMENT ON COLUMN public.product.rptasof
    IS 'The date the table data changed';

COMMENT ON COLUMN public.product.ifxaccttype
    IS 'Assigns account to a generally recognized industry standard cat';

COMMENT ON COLUMN public.product.avlenddtmm
    IS 'Date and time product is no longer offered and new positions cannot be opened';

COMMENT ON COLUMN public.product.avlstartdtmm
    IS 'Date and time product is first offered and new positions may be opened';

COMMENT ON COLUMN public.product.components
    IS 'Position components list segmented into positions<component> classes';

COMMENT ON COLUMN public.product.ccycode
    IS 'Currency code';

COMMENT ON COLUMN public.product.description
    IS 'Product type description';

COMMENT ON COLUMN public.product.fundterm
    IS 'Window beginning at position opening during which position must be funded';

COMMENT ON COLUMN public.product.glcat
    IS 'GL cat code';

COMMENT ON COLUMN public.product.glsetcode
    IS 'General ledger accounts used for reporting';

COMMENT ON COLUMN public.product.isfedexempt
    IS 'Is exempt from federal withholding';

COMMENT ON COLUMN public.product.isregd
    IS 'Indicates whether or not product positions are subject to Regulation D';

COMMENT ON COLUMN public.product.isstateexempt
    IS 'Is exempt from state withholding';

COMMENT ON COLUMN public.product.logref
    IS 'Product created log reference';

COMMENT ON COLUMN public.product.name
    IS 'Product name';

COMMENT ON COLUMN public.product.prodgroup
    IS 'Product group name';

COMMENT ON COLUMN public.product.prodsubtype
    IS 'The product sub-type within prodType';

COMMENT ON COLUMN public.product.prodtype
    IS 'Product type name';

COMMENT ON COLUMN public.product.stmtfreq
    IS 'Default freq to create a position statement';

COMMENT ON COLUMN public.product.version
    IS 'Product type version';
    

-- Table: public.restrict

-- DROP TABLE public.restrict;

CREATE TABLE public.restrict
(
    rptasof timestamptz NOT NULL,
    _id character varying(42) COLLATE pg_catalog."default" NOT NULL,
    acctgroup integer,
    acctnbr character varying(20) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    canceldtm timestamptz DEFAULT NULL,
    doc jsonb,
    enddtm timestamptz DEFAULT NULL,
    level smallint,
    note text COLLATE pg_catalog."default",
    partyid character varying(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    posnid character varying(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    restrictcode smallint,
    startdtm timestamptz DEFAULT NULL,
    CONSTRAINT restrict_pkey PRIMARY KEY (rptasof, _id),
    CONSTRAINT restrict_acctgroup_chk CHECK (acctgroup >= 0),
    CONSTRAINT restrict_level_chk CHECK (level >= 0),
    CONSTRAINT restrict_restrictcode_chk CHECK (restrictcode >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.restrict
    OWNER to postgres;

COMMENT ON COLUMN public.restrict.rptasof
    IS 'The date the table data changed';

COMMENT ON COLUMN public.restrict._id
    IS 'Unique Restriction identifier';

COMMENT ON COLUMN public.restrict.acctgroup
    IS 'Account Group code';

COMMENT ON COLUMN public.restrict.acctnbr
    IS 'The unique account identifier within an acctGroup';

COMMENT ON COLUMN public.restrict.canceldtm
    IS 'Date and time Restriction was cancelled';

COMMENT ON COLUMN public.restrict.doc
    IS 'Documents to support the restrict placement';

COMMENT ON COLUMN public.restrict.enddtm
    IS 'Date and time Restriction will expire  default 10/15/2114-23:59';

COMMENT ON COLUMN public.restrict.level
    IS 'The level at which the restrict being placed';

COMMENT ON COLUMN public.restrict.note
    IS 'Free form accompanying note';

COMMENT ON COLUMN public.restrict.partyid
    IS 'Unique Party identifier';

COMMENT ON COLUMN public.restrict.posnid
    IS 'Restriction placed on position';

COMMENT ON COLUMN public.restrict.restrictcode
    IS 'The Restriction type code';

COMMENT ON COLUMN public.restrict.startdtm
    IS 'Date and time Restriction will start  default immediately';


-- Table: public.trncodes

-- DROP TABLE public.trncodes;

CREATE TABLE public.trncodes
(
    rptasof timestamptz NOT NULL,
    networkexcl jsonb,
    networkincl character varying(20) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    description character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    isaccumdtl boolean,
    maxentry smallint,
    roleexcl jsonb,
    roleincl character varying(20) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    statgroups jsonb,
    trncode character varying(20) COLLATE pg_catalog."default" NOT NULL,
    trninputs character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    CONSTRAINT trncodes_pkey PRIMARY KEY (rptasof, trncode),
    CONSTRAINT trncodes_maxentry_chk CHECK (maxentry >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.trncodes
    OWNER to postgres;

COMMENT ON COLUMN public.trncodes.rptasof
    IS 'The date the table data changed';

COMMENT ON COLUMN public.trncodes.networkexcl
    IS 'A list of network names';

COMMENT ON COLUMN public.trncodes.networkincl
    IS 'Network name';

COMMENT ON COLUMN public.trncodes.description
    IS 'Transaction code description';

COMMENT ON COLUMN public.trncodes.maxentry
    IS 'If defined  maximum number of dtl entries that are allowed within a trncode instance';

COMMENT ON COLUMN public.trncodes.roleexcl
    IS 'A list of role codes excluded from using the trncode';

COMMENT ON COLUMN public.trncodes.roleincl
    IS 'Role code allowed to use trncode';

COMMENT ON COLUMN public.trncodes.trncode
    IS 'Transaction Code';
    
-- Table: public.trnentries

-- DROP TABLE public.trnentries;

CREATE TABLE public.trnentries
(
    _id character varying(42) COLLATE pg_catalog."default" NOT NULL,
    _ix integer NOT NULL,
    acctgroup integer NOT NULL,
    acctnbr character varying(20) COLLATE pg_catalog."default" NOT NULL,
    addhold jsonb,
    amt numeric(16,2) NOT NULL,
    assetclass bigint DEFAULT 1,
    assetid character varying(12) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    auth jsonb,
    chkitem jsonb,
    comment character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    company integer DEFAULT 0,
    ccycode character varying(3) COLLATE pg_catalog."default" DEFAULT 'USD'::character varying,
    deptid integer NOT NULL DEFAULT 0,
    exch jsonb,
    gldist jsonb,
    glsetcode character varying(20) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    iscontact boolean,
    isdr boolean,
    passbook jsonb,
    posnid character varying(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    posnref character varying(30) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    removehold jsonb,
    rtnbr character varying(40) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    seqnbr bigint,
    src character varying(60) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    trace character varying(40) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    vertical integer NOT NULL DEFAULT 0,
    CONSTRAINT trnentries_pkey PRIMARY KEY (_id, _ix),
    CONSTRAINT trnentries_deptid_chk CHECK (deptid >= 0),
    CONSTRAINT trnentries_company_chk CHECK (company >= 0),
    CONSTRAINT trnentries_assetclass_chk CHECK (assetclass >= 0),
    CONSTRAINT trnentries_acctgroup_chk CHECK (acctgroup >= 0),
    CONSTRAINT trnentries__ix_chk CHECK (_ix >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.trnentries
    OWNER to postgres;

COMMENT ON COLUMN public.trnentries._id
    IS 'Unique Transaction identifier';

COMMENT ON COLUMN public.trnentries.acctgroup
    IS 'Account Group code';

COMMENT ON COLUMN public.trnentries.acctnbr
    IS 'The unique account identifier within an acctGroup';

COMMENT ON COLUMN public.trnentries.amt
    IS 'Amount or quantity of asset exchd';

COMMENT ON COLUMN public.trnentries.assetclass
    IS 'The asset class of the position';

COMMENT ON COLUMN public.trnentries.assetid
    IS 'Asset identifier within the asset class';

COMMENT ON COLUMN public.trnentries.comment
    IS 'Short trnsaction comment';

COMMENT ON COLUMN public.trnentries.company
    IS 'Company reported';

COMMENT ON COLUMN public.trnentries.ccycode
    IS 'Currency code alias {assetClass:1  assetId: curCd}';

COMMENT ON COLUMN public.trnentries.deptid
    IS 'Balancing department or cost center Id';

COMMENT ON COLUMN public.trnentries.glsetcode
    IS 'GL account numbers set code';

COMMENT ON COLUMN public.trnentries.iscontact
    IS 'Update customer contact indicator';

COMMENT ON COLUMN public.trnentries.isdr
    IS 'Is a debit entry to position';

COMMENT ON COLUMN public.trnentries.posnid
    IS 'Unique position identifier is FK to posn PK';

COMMENT ON COLUMN public.trnentries.posnref
    IS 'The unique position identifier within an acctGroup';

COMMENT ON COLUMN public.trnentries.rtnbr
    IS 'The RT number on a deposited chk item';

COMMENT ON COLUMN public.trnentries.seqnbr
    IS 'Record  row or database sequence number';

COMMENT ON COLUMN public.trnentries.src
    IS 'Customer attributed src of funds for AML analysis';

COMMENT ON COLUMN public.trnentries.trace
    IS 'The unique trnsaction identifier within the src';

COMMENT ON COLUMN public.trnentries.vertical
    IS 'Vertical reported';

-- Index: idx_trnentries

-- DROP INDEX public.idx_trnentries;

CREATE UNIQUE INDEX idx_trnentries
    ON public.trnentries USING btree
    (posnid COLLATE pg_catalog."default", _id COLLATE pg_catalog."default", _ix)
    TABLESPACE pg_default;
    


-- Table: public.trnset

-- DROP TABLE public.trnset;

CREATE TABLE public.trnset
(
    _id character varying(42) COLLATE pg_catalog."default" NOT NULL,
    trndtm timestamp with time zone,
    attachs jsonb,
    batchid character varying(20) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    bill jsonb,
    network character varying(20) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    effectdtm timestamp with time zone,
    eft jsonb,
    gljrnldate timestamp with time zone,
    logref character varying(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    mode smallint,
    note text COLLATE pg_catalog."default",
    pmtorder jsonb,
    otherproperties jsonb,
    reverse character varying(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    reversedby character varying(42) COLLATE pg_catalog."default" DEFAULT NULL::bpchar,
    settledtm timestamp with time zone,
    sttn jsonb,
    tags jsonb,
    template jsonb,
    trncode character varying(20) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    workitem jsonb,
    CONSTRAINT trnset_pkey PRIMARY KEY (_id),
    CONSTRAINT trnset_mode_chk CHECK (mode >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.trnset
    OWNER to postgres;

COMMENT ON COLUMN public.trnset._id
    IS 'Unique Transaction identifier';

COMMENT ON COLUMN public.trnset.trndtm
    IS 'date time portion of the _id tguid';

COMMENT ON COLUMN public.trnset.attachs
    IS 'URI References to attached documents and images';

COMMENT ON COLUMN public.trnset.batchid
    IS 'For a batch src the object that contains batch dtl';

COMMENT ON COLUMN public.trnset.bill
    IS 'Bill or invoice dtl object';

COMMENT ON COLUMN public.trnset.network
    IS 'The posting network of this msg';

COMMENT ON COLUMN public.trnset.effectdtm
    IS 'The effective date of the trnsaction for account procing  can be backdate or future';

COMMENT ON COLUMN public.trnset.eft
    IS 'Detail information accompanying an EFT ISO8583 trnsaction';

COMMENT ON COLUMN public.trnset.gljrnldate
    IS 'The GL journal date this trnsaction entry is postting on';

COMMENT ON COLUMN public.trnset.logref
    IS 'Unique msg log identifier';

COMMENT ON COLUMN public.trnset.mode
    IS 'The host procing mode';

COMMENT ON COLUMN public.trnset.note
    IS 'Detailed free form trnsaction notes';

COMMENT ON COLUMN public.trnset.pmtorder
    IS 'Payment collection or trnsfer order dtl';

COMMENT ON COLUMN public.trnset.otherproperties
    IS 'Array of additional properties in name:value object pairs';

COMMENT ON COLUMN public.trnset.reverse
    IS 'Transaction Id to reverse in position history';

COMMENT ON COLUMN public.trnset.settledtm
    IS 'The settlement or value date of this trnsaction';

COMMENT ON COLUMN public.trnset.sttn
    IS 'Originating sttn or terminal dtl object';

COMMENT ON COLUMN public.trnset.tags
    IS 'tag name';

COMMENT ON COLUMN public.trnset.template
    IS 'Template object to initialize trnsaction entries';

COMMENT ON COLUMN public.trnset.trncode
    IS 'The Finxact trnsaction code';

COMMENT ON COLUMN public.trnset.workitem
    IS 'Workflow case dtl';

-- Index: trnset_gljrnldate

-- DROP INDEX public.trnset_gljrnldate;

CREATE UNIQUE INDEX trnset_gljrnldate
    ON public.trnset USING btree
    (gljrnldate, _id COLLATE pg_catalog."default")
    TABLESPACE pg_default;

COMMENT ON INDEX public.trnset_gljrnldate
    IS 'Lists trnset entries by gljrnldates';


-- Table: public.trnstats

-- DROP TABLE public.trnstats;

CREATE TABLE public.trnstats
(
    rptasof timestamptz NOT NULL,
    _id character varying(42) COLLATE pg_catalog."default" NOT NULL,
    accumtodtm timestamptz DEFAULT NULL,
    datetype bigint NOT NULL DEFAULT 0,
    perioddtm timestamptz NOT NULL,
    statgroup character varying(20) COLLATE pg_catalog."default" NOT NULL,
    totamtcr numeric(16,2) DEFAULT NULL::numeric,
    totamtdr numeric(16,2) DEFAULT NULL::numeric,
    totcntcr integer,
    totcntdr integer,
    CONSTRAINT trnstats_pkey PRIMARY KEY (rptasof, _id, statgroup, datetype, perioddtm),
    CONSTRAINT trnstats_datetype_chk CHECK (datetype >= 0),
    CONSTRAINT trnstats_totcntcr_chk CHECK (totcntcr >= 0),
    CONSTRAINT trnstats_totcntdr_chk CHECK (totcntdr >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.trnstats
    OWNER to postgres;

COMMENT ON COLUMN public.trnstats.rptasof
    IS 'The date the table data changed';

COMMENT ON COLUMN public.trnstats._id
    IS 'Position identifier';

COMMENT ON COLUMN public.trnstats.accumtodtm
    IS 'Statistics accumulated to high-water';

COMMENT ON COLUMN public.trnstats.datetype
    IS 'Date type to accumulate on';

COMMENT ON COLUMN public.trnstats.perioddtm
    IS 'The datetime period accumulated to';

COMMENT ON COLUMN public.trnstats.statgroup
    IS 'Group name the statistics are accumulating to';

COMMENT ON COLUMN public.trnstats.totamtcr
    IS 'Total Credit amt';

COMMENT ON COLUMN public.trnstats.totamtdr
    IS 'Total Debit amt';

COMMENT ON COLUMN public.trnstats.totcntcr
    IS 'Total Credit count';

COMMENT ON COLUMN public.trnstats.totcntdr
    IS 'Total Debit count';


-- Table: public.trnstatsgroup

-- DROP TABLE public.trnstatsgroup;

CREATE TABLE public.trnstatsgroup
(
    rptasof timestamptz NOT NULL,
    accumcr boolean,
    accumdr boolean,
    datetypes jsonb,
    description character varying(255) COLLATE pg_catalog."default" DEFAULT NULL::character varying,
    "precision" bigint DEFAULT 4,
    statgroup character varying(20) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT trnstatsgroup_pkey PRIMARY KEY (rptasof, statgroup),
    CONSTRAINT trnstatsgroup_precision_chk CHECK ("precision" >= 0)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.trnstatsgroup
    OWNER to postgres;

COMMENT ON COLUMN public.trnstatsgroup.rptasof
    IS 'The date the table data changed';

COMMENT ON COLUMN public.trnstatsgroup.accumcr
    IS 'Flag to accumulate credit trnsactions';

COMMENT ON COLUMN public.trnstatsgroup.accumdr
    IS 'Flag to accumulate debit trnsactions';

COMMENT ON COLUMN public.trnstatsgroup.datetypes
    IS 'Date type to accumulate on';

COMMENT ON COLUMN public.trnstatsgroup.description
    IS 'Accumulation group description';

COMMENT ON COLUMN public.trnstatsgroup."precision"
    IS 'Duration between accumulation points';

COMMENT ON COLUMN public.trnstatsgroup.statgroup
    IS 'Group name the statistics are accumulating to';

CREATE TABLE GL_BAL_INFO (
    glDate DATE not NULL,
    regionId integer NOT NULL,
    deptId integer NOT NULL,
    acctNum character varying(20)  NOT NULL,
    acctTitle character varying(255) NOT NULL,
    posnRef character varying(30) NOT NULL,
    glCat smallint NOT NULL,
    balance numeric(16,2) NOT NULL,
    runTotal numeric(16,2) NOT NULL,
    totCntCr integer DEFAULT 0,
    totCntDr integer DEFAULT 0,
    totAmtCr numeric(16,2) NOT NULL,
    totAmtDr numeric(16,2) NOT NULL,
    CONSTRAINT GL_BAL_INFO_pk PRIMARY KEY (glDate, posnRef) 
);


 CREATE TABLE reports (
  _id  character varying(42) NOT NULL,
  name character varying(20) DEFAULT NULL,
  description character varying(60) DEFAULT NULL,
  function_name character varying(60) DEFAULT NULL,
  CONSTRAINT reportDef_pk PRIMARY KEY (_id)
);



Create TABLE report_section (
  _id  character varying(42) NOT NULL,
  name character varying(20) NOT NULL,
  display_order SMALLINT  NOT NULL  check (display_order>= 0),
  description character varying(45) DEFAULT NULL,
  detail_cursor character varying(42),
  summary_cursor character varying(42),
  format_definition jsonb,
  CONSTRAINT reportTable_pk PRIMARY KEY (_id, name)
);

CREATE TABLE report_input (
  _id  character varying(42) NOT NULL,
  name character varying(20) NOT NULL,
  param_order  smallint  NOT NULL  check (param_order >= 0),
  value_type character varying(45) NOT NULL,
  is_required bool DEFAULT true,
  CONSTRAINT  reportPram_pk PRIMARY KEY (_id, name)
);
ALTER TABLE report_input ADD FOREIGN KEY ("_id") REFERENCES reports ("_id");
ALTER TABLE report_section ADD FOREIGN KEY ("_id") REFERENCES reports ("_id");



CREATE TABLE etl_import (
    _id serial NOT NULL,
     rptasof timestamp without time zone NOT NULL,
     rundate timestamp without time zone NOT NULL,
     CONSTRAINT elt_import PRIMARY KEY (_id)
);

--
-- TOC entry 285 (class 1255 OID 20706)
-- Name: f_fmt(text, character, integer, integer, character, character); Type: FUNCTION; Schema: public; Owner: postgres
--

-- FUNCTION: public.f_fmt(text, character, integer, integer, character, character)

-- DROP FUNCTION public.f_fmt(text, character, integer, integer, character, character);

CREATE OR REPLACE FUNCTION public.f_fmt(
	inputstring text,
	inputformat character,
	slength integer,
	decprec integer,
	padchar character DEFAULT ''::bpchar,
	justify character DEFAULT 'L'::bpchar)
    RETURNS text
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

declare 

    decpat text = substring('0000000000', 1, decprec);       -- The to_char decimal pattern
    fmt character(1) = upper(inputformat);                   -- T (text), $ (currency), D (date), C (time)
    numfmt text;
    numlen smallint = (slength - decprec - 1);               -- The length of the integer portion of a number input
    str text;

begin

	if inputstring is not null then
		str = trim(both from inputstring, ' ');             -- Strip spaces from both ends
	end if;
	
    if fmt = 'T' then
		if inputstring is null then
			str = '';
		end if;
		if upper(inputstring) = 'NULL' then
			str = '';
		end if;

        str = substring(str, 1, slength);                    -- Truncate string to fit
	
    elseif fmt = '$' then
		if inputstring is null then
			str = '0';
		end if;

        numfmt = '999G999G999G999D' || decpat;				 -- Format numeric with two decimal places and comma as a thousands separater
        str = to_char(str::numeric, numfmt);
		str = trim(both from str, ' ');						 -- Remove padding that may have been added by to_char
		
    elseif fmt = 'D' then
		if inputstring is null then
			str = '';
		end if;

		if str <> ''
        	then str = to_char(str::date,'DDMONYYYY');		 -- Format the string as a date
		end if;
		
    elseif fmt = 'C' then
        str = to_char(str::timestamp, 'HH24:MI:SS');		 -- Format the string as time
	
	elseif fmt = 'B' then
		if inputstring is null then
			str = 'F';
		elseif inputstring = '' then
			str = 'F';
		end if;

		if (upper(str) = 'TRUE' or upper(str) = 'T' or str = '1') then
			str = 'Y';
		elseif (upper(str) = 'FALSE' or upper(str) = 'F' or str = '0' or upper(str) = 'NULL') then
			str = 'N';
		else str = ' ';
		end if;
		
    else
        str = str;

    end if;
	
	if padchar <> '' then							-- Do we pad?
		if upper(justify) = 'L' then						 -- If we left justify then we pad the right.
												str = rpad(str, slength, padchar);
		else												 -- If we right justify then we pad the left.
												str = lpad(str, slength, padchar);
		end if;
	end if;
	
    return str;
	
END;

$BODY$;

ALTER FUNCTION public.f_fmt(text, character, integer, integer, character, character)
    OWNER TO postgres;


-- FUNCTION: public.f_tz(timestamp with time zone, text)

-- DROP FUNCTION public.f_tz(timestamp with time zone, text);

CREATE OR REPLACE FUNCTION public.f_tz(
	inputtime timestamp with time zone,
	inputtz text DEFAULT ''::text)
    RETURNS timestamp without time zone
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

declare 
	defaulttz text = current_setting('TIMEZONE');

begin
	
	/*	Desc:	Accepts a timezone and date/time, returns a timezone resolved date/time.
		By:		Chuck Hardy
		Date:	06/15/2018
	*/
	
	if inputtz = '' then
		
		/* This is needed for accounts that do not have a TZ specified.
		   Also, this is the stand-in until we implement an institutional
		   time zone.
		*/
		inputtz = defaulttz;
		
	-- This is temporary until we resolve TZ handling.
	else inputtz = 'America/New_York';
	
	end if;
	
    return timezone(inputtz, inputtime);
	
END;

$BODY$;

ALTER FUNCTION public.f_tz(timestamp with time zone, text)
    OWNER TO postgres;

COMMENT ON FUNCTION public.f_tz(timestamp with time zone, text)
    IS 'Accepts a datetime value and a timezone.  Returns the time adjusted by the timezone.';

COMMIT;