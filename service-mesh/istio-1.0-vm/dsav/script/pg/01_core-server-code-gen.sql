\c zbch_trn_db
SET TIME ZONE 'UTC';
BEGIN;


-- Creating Table acct
DROP TABLE IF EXISTS "acct";
CREATE TABLE "acct" (
    "_Class" varchar(255)   DEFAULT NULL,
    "acctGroup" integer  NOT NULL  check ("acctGroup" >= 0),
    "acctNbr" varchar(20)   NOT NULL ,
    "acctTitle" varchar(255)   NOT NULL ,
    "closeDtm" timestamptz  DEFAULT NULL,
    "desc" varchar(255)   DEFAULT NULL,
    "openDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("acctGroup", "acctNbr")
); 
COMMENT ON COLUMN "acct"."_Class" IS 'The class of the acct';
COMMENT ON COLUMN "acct"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "acct"."acctNbr" IS 'The unique account identifier within an acctGroup';
COMMENT ON COLUMN "acct"."acctTitle" IS 'The account title';
COMMENT ON COLUMN "acct"."closeDtm" IS 'Date the account was closed';
COMMENT ON COLUMN "acct"."desc" IS 'Account description';
COMMENT ON COLUMN "acct"."openDtm" IS 'Date the account was opened';


-- Creating Table acctGroup
DROP TABLE IF EXISTS "acctGroup";
CREATE TABLE "acctGroup" (
    "acctGroup" integer  NOT NULL  check ("acctGroup" >= 0),
    "desc" varchar(255)   NOT NULL ,
    "isAccumGL" boolean  NOT NULL  DEFAULT false,
    "isChkPosn" boolean  NOT NULL ,
    "isRtPosnUpd" boolean  NOT NULL ,
    "posnClass" varchar(255)   NOT NULL ,
    "posnDelim" jsonb  DEFAULT NULL,
    "posnFixed" jsonb  DEFAULT NULL,
    
    PRIMARY KEY ("acctGroup")
); 
COMMENT ON COLUMN "acctGroup"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "acctGroup"."desc" IS 'Account type description';
COMMENT ON COLUMN "acctGroup"."isAccumGL" IS 'Determines if type accumulates to GL';
COMMENT ON COLUMN "acctGroup"."isChkPosn" IS 'Flag determines whether to check position balances for sufficient funds';
COMMENT ON COLUMN "acctGroup"."isRtPosnUpd" IS 'Flag determines whether position is updated real-time in transaction scope';
COMMENT ON COLUMN "acctGroup"."posnClass" IS 'Position Classes for Account Group';
COMMENT ON COLUMN "acctGroup"."posnDelim" IS 'The field name (property) at this index';
COMMENT ON COLUMN "acctGroup"."posnFixed" IS 'Composite fixed length position key definition';


-- Creating Table acct_bk
DROP TABLE IF EXISTS "acct_bk";
CREATE TABLE "acct_bk" (
    "acctGroup" integer  NOT NULL  check ("acctGroup" >= 0),
    "acctNbr" varchar(20)   NOT NULL ,
    "broker" jsonb  DEFAULT NULL,
    "folderId" varchar(42)  DEFAULT NULL,
    "isBrokered" boolean  NOT NULL ,
    "lastStmtDtm" timestamptz  DEFAULT NULL,
    "nextStmtDtm" timestamptz  DEFAULT NULL,
    "stmtFreq" varchar(255)   DEFAULT NULL,
    "tcDtl" jsonb  DEFAULT NULL,
    "tmZone" varchar(3)   NOT NULL ,
    
    PRIMARY KEY ("acctGroup", "acctNbr")
); 
COMMENT ON COLUMN "acct_bk"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "acct_bk"."acctNbr" IS 'The unique account identifier within an acctGroup';
COMMENT ON COLUMN "acct_bk"."broker" IS 'Broker originating the account';
COMMENT ON COLUMN "acct_bk"."folderId" IS 'Documents and attachments folder Id';
COMMENT ON COLUMN "acct_bk"."isBrokered" IS 'Indicates whether or not the account was originated by a broker';
COMMENT ON COLUMN "acct_bk"."lastStmtDtm" IS 'Last statement creation date-time';
COMMENT ON COLUMN "acct_bk"."nextStmtDtm" IS 'Next statement creation date-time';
COMMENT ON COLUMN "acct_bk"."stmtFreq" IS 'Default frequency to create a statement';
COMMENT ON COLUMN "acct_bk"."tcDtl" IS 'Version and date of the term and conditions signed by the account owner(s)';
COMMENT ON COLUMN "acct_bk"."tmZone" IS 'Time zone assigned to account for daily processing window';


-- Creating Table accumTrnLimits
DROP TABLE IF EXISTS "accumTrnLimits";
CREATE TABLE "accumTrnLimits" (
    "_Id" varchar(42)  NOT NULL ,
    "crAmt" decimal(16,2)   DEFAULT NULL,
    "crCnt" smallint  DEFAULT NULL check ("crCnt" >= 0),
    "drAmt" decimal(16,2)   DEFAULT NULL,
    "drCnt" smallint  DEFAULT NULL check ("drCnt" >= 0),
    "name" varchar(20)   DEFAULT NULL,
    "period" varchar(255)   DEFAULT NULL,
    "startDtm" timestamptz  DEFAULT NULL,
    "statGroup" varchar(20)   DEFAULT NULL,
    "totAmt" decimal(16,2)   DEFAULT NULL,
    "totCnt" smallint  DEFAULT NULL check ("totCnt" >= 0),
    "violationAct" jsonb  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "accumTrnLimits"."_Id" IS 'Unique accumulated limit identifier';
COMMENT ON COLUMN "accumTrnLimits"."crAmt" IS 'Maximum amount of all credit transactions allowed for the period';
COMMENT ON COLUMN "accumTrnLimits"."crCnt" IS 'Maximum number of credit transactions allowed for the period';
COMMENT ON COLUMN "accumTrnLimits"."drAmt" IS 'Maximum amount of all debit transactions allowed for the period';
COMMENT ON COLUMN "accumTrnLimits"."drCnt" IS 'Maximum number of debit transactions allowed for the period';
COMMENT ON COLUMN "accumTrnLimits"."name" IS 'Name of limit being tracked';
COMMENT ON COLUMN "accumTrnLimits"."period" IS 'Defines the period used to determine whether or not the limit is exceeded';
COMMENT ON COLUMN "accumTrnLimits"."startDtm" IS 'Start date used to calculate current period';
COMMENT ON COLUMN "accumTrnLimits"."statGroup" IS 'Bucket for accumulated amounts and counts';
COMMENT ON COLUMN "accumTrnLimits"."totAmt" IS 'Total amount of absolute debit amount and credit amount for period';
COMMENT ON COLUMN "accumTrnLimits"."totCnt" IS 'Maximum number of transactions allowed for the period';
COMMENT ON COLUMN "accumTrnLimits"."violationAct" IS '';


-- Creating Table accumTrnLimitsViolationFee
DROP TABLE IF EXISTS "accumTrnLimitsViolationFee";
CREATE TABLE "accumTrnLimitsViolationFee" (
    "_Id" varchar(42)  NOT NULL ,
    "assessAt" smallint  DEFAULT 1 check ("assessAt" >= 0),
    "desc" varchar(255)   DEFAULT NULL,
    "feeAmt" decimal(16,2)   DEFAULT NULL,
    "feeMatrix" varchar(30)   DEFAULT NULL,
    "feeMaxAmt" decimal(16,2)   DEFAULT NULL,
    "feeMinAmt" decimal(16,2)   DEFAULT NULL,
    "feePct" decimal(16,5)   DEFAULT NULL,
    "name" varchar(20)   DEFAULT NULL,
    "nsfFeeBal" smallint  DEFAULT 1 check ("nsfFeeBal" >= 0),
    "trnCode" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "accumTrnLimitsViolationFee"."_Id" IS 'Unique accumulated limit identifier';
COMMENT ON COLUMN "accumTrnLimitsViolationFee"."assessAt" IS 'Defines when fee is assessed';
COMMENT ON COLUMN "accumTrnLimitsViolationFee"."desc" IS 'Fee description';
COMMENT ON COLUMN "accumTrnLimitsViolationFee"."feeAmt" IS 'The fixed fee amount to assess to position';
COMMENT ON COLUMN "accumTrnLimitsViolationFee"."feeMatrix" IS 'Matrix used to determine the fee';
COMMENT ON COLUMN "accumTrnLimitsViolationFee"."feeMaxAmt" IS 'The maximum fee to charge to position per transaction';
COMMENT ON COLUMN "accumTrnLimitsViolationFee"."feeMinAmt" IS 'The minimum fee to charge to position, per transaction';
COMMENT ON COLUMN "accumTrnLimitsViolationFee"."feePct" IS 'Percentage applied to amount to calculate fee';
COMMENT ON COLUMN "accumTrnLimitsViolationFee"."name" IS 'Fee name';
COMMENT ON COLUMN "accumTrnLimitsViolationFee"."nsfFeeBal" IS 'Fee handling when position ledger balance is less than fee amount';
COMMENT ON COLUMN "accumTrnLimitsViolationFee"."trnCode" IS 'Transaction code used to post the fee';


-- Creating Table accumTrnLimitsViolationFeeLimits
DROP TABLE IF EXISTS "accumTrnLimitsViolationFeeLimits";
CREATE TABLE "accumTrnLimitsViolationFeeLimits" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "feeMaxAmt" decimal(16,2)   DEFAULT NULL,
    "feeMaxCnt" smallint  DEFAULT NULL check ("feeMaxCnt" >= 0),
    "freq" varchar(255)   DEFAULT NULL,
    "startDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "accumTrnLimitsViolationFeeLimits"."_Id" IS 'Unique accumulated limit identifier';
COMMENT ON COLUMN "accumTrnLimitsViolationFeeLimits"."_Ix" IS '_Ix for Field feeLimits';
COMMENT ON COLUMN "accumTrnLimitsViolationFeeLimits"."feeMaxAmt" IS 'Maximum total fee amount that may be assessed for the period';
COMMENT ON COLUMN "accumTrnLimitsViolationFeeLimits"."feeMaxCnt" IS 'Maximum total count of fees that may be assessed for period';
COMMENT ON COLUMN "accumTrnLimitsViolationFeeLimits"."freq" IS 'Defines the period used to determine whether or not fees exceed maximum allowable';
COMMENT ON COLUMN "accumTrnLimitsViolationFeeLimits"."startDtm" IS 'Start date used to calculate current period';


-- Creating Table addr
DROP TABLE IF EXISTS "addr";
CREATE TABLE "addr" (
    "_Id" varchar(42)  NOT NULL ,
    "city" varchar(40)   DEFAULT NULL,
    "cntry" varchar(2)   DEFAULT NULL,
    "geoLoc" jsonb  DEFAULT NULL,
    "postCode" varchar(9)   DEFAULT NULL,
    "premise" varchar(30)   DEFAULT NULL,
    "region" varchar(2)   DEFAULT NULL,
    "street" text  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "addr"."_Id" IS 'The unique address identifier';
COMMENT ON COLUMN "addr"."city" IS 'Address city';
COMMENT ON COLUMN "addr"."cntry" IS 'Address country';
COMMENT ON COLUMN "addr"."geoLoc" IS 'Fixed geographic location of address';
COMMENT ON COLUMN "addr"."postCode" IS 'The address postal code';
COMMENT ON COLUMN "addr"."premise" IS 'Name location or building name';
COMMENT ON COLUMN "addr"."region" IS 'State, Province, County or Land';
COMMENT ON COLUMN "addr"."street" IS 'Street number, PO box or RD and street name';


-- Creating Table assetCatalogue
DROP TABLE IF EXISTS "assetCatalogue";
CREATE TABLE "assetCatalogue" (
    "assetClass" smallint  NOT NULL  DEFAULT 1 check ("assetClass" >= 0),
    "assetId" varchar(12)   NOT NULL ,
    "desc" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("assetClass", "assetId")
); 
COMMENT ON COLUMN "assetCatalogue"."assetClass" IS 'The asset class of the position';
COMMENT ON COLUMN "assetCatalogue"."assetId" IS 'Asset identifier within the asset class';
COMMENT ON COLUMN "assetCatalogue"."desc" IS 'Asset description';


-- Creating Table bankparam
DROP TABLE IF EXISTS "bankparam";
CREATE TABLE "bankparam" (
    "_Id" varchar(42)  NOT NULL ,
    "calendar" varchar(30)   DEFAULT NULL,
    "pageTrnCnt" integer  DEFAULT NULL check ("pageTrnCnt" >= 0),
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "bankparam"."_Id" IS 'Information about the bank';
COMMENT ON COLUMN "bankparam"."calendar" IS 'Business calendar assoicated with the financial institution';
COMMENT ON COLUMN "bankparam"."pageTrnCnt" IS 'Maximum transactions on a page';


-- Creating Table bankparamPenRate
DROP TABLE IF EXISTS "bankparamPenRate";
CREATE TABLE "bankparamPenRate" (
    "_Id" varchar(42)  NOT NULL ,
    "indexName" varchar(255)   DEFAULT NULL,
    "isBlended" boolean  DEFAULT NULL,
    "maxRate" decimal(16,5)   DEFAULT NULL,
    "minRate" decimal(16,5)   DEFAULT NULL,
    "offSet" varchar(255)   DEFAULT NULL,
    "round" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "bankparamPenRate"."_Id" IS 'Information about the bank';
COMMENT ON COLUMN "bankparamPenRate"."indexName" IS 'Index matrix name';
COMMENT ON COLUMN "bankparamPenRate"."isBlended" IS 'Is blended rate if true, highest tier applies if fales';
COMMENT ON COLUMN "bankparamPenRate"."maxRate" IS 'Maximum nominal rate ceiling';
COMMENT ON COLUMN "bankparamPenRate"."minRate" IS 'Minimum nominal rate floor';
COMMENT ON COLUMN "bankparamPenRate"."offSet" IS 'Rate offset expression [+|- value]';
COMMENT ON COLUMN "bankparamPenRate"."round" IS 'Rate rounding expression [U|D fraction|decimal]';


-- Creating Table batch
DROP TABLE IF EXISTS "batch";
CREATE TABLE "batch" (
    "_Id" varchar(42)  NOT NULL ,
    "confirmedBy" jsonb  DEFAULT NULL,
    "createBy" jsonb  DEFAULT NULL,
    "createDtm" timestamptz  DEFAULT NULL,
    "effectDtm" timestamptz  DEFAULT NULL,
    "endDtm" timestamptz  DEFAULT NULL,
    "network" varchar(20)   DEFAULT NULL,
    "note" text  DEFAULT NULL,
    "parameters" jsonb  DEFAULT NULL,
    "resource" varchar(255)   DEFAULT NULL,
    "schedDtm" timestamptz  DEFAULT NULL,
    "startDtm" timestamptz  DEFAULT NULL,
    "totCnt" int  DEFAULT NULL check ("totCnt" >= 0),
    "totCrAmt" decimal(16,2)   DEFAULT NULL,
    "totCrCnt" int  DEFAULT NULL check ("totCrCnt" >= 0),
    "totDrAmt" decimal(16,2)   DEFAULT NULL,
    "totDrCnt" int  DEFAULT NULL check ("totDrCnt" >= 0),
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "batch"."_Id" IS 'Unique batch identifier';
COMMENT ON COLUMN "batch"."confirmedBy" IS 'Batch confirmed by';
COMMENT ON COLUMN "batch"."createBy" IS 'Batch created by';
COMMENT ON COLUMN "batch"."createDtm" IS 'Batch created on date';
COMMENT ON COLUMN "batch"."effectDtm" IS 'Effective date of batch';
COMMENT ON COLUMN "batch"."endDtm" IS 'Datetime batch ended or closed';
COMMENT ON COLUMN "batch"."network" IS 'Batch network source name';
COMMENT ON COLUMN "batch"."note" IS 'Free form notes';
COMMENT ON COLUMN "batch"."parameters" IS 'Snapshot network configuration parameters';
COMMENT ON COLUMN "batch"."resource" IS 'Name and path of source of input to or output from batch posting';
COMMENT ON COLUMN "batch"."schedDtm" IS 'Datetime batch scheduled to start';
COMMENT ON COLUMN "batch"."startDtm" IS 'Datetime batch started or opened';
COMMENT ON COLUMN "batch"."totCnt" IS 'Batch total record count';
COMMENT ON COLUMN "batch"."totCrAmt" IS 'Batch total credit amount';
COMMENT ON COLUMN "batch"."totCrCnt" IS 'Batch total credits count';
COMMENT ON COLUMN "batch"."totDrAmt" IS 'Batch total debit amount';
COMMENT ON COLUMN "batch"."totDrCnt" IS 'Batch total debits count';


-- Creating Table batchDtl
DROP TABLE IF EXISTS "batchDtl";
CREATE TABLE "batchDtl" (
    "_Id" varchar(42)  NOT NULL ,
    "attachments" jsonb  DEFAULT NULL,
    "batchId" varchar(20)   DEFAULT NULL,
    "bill" jsonb  DEFAULT NULL,
    "effectDtm" timestamptz  DEFAULT NULL,
    "eft" jsonb  DEFAULT NULL,
    "glJrnlDate" date  DEFAULT NULL,
    "logRef" varchar(42)  DEFAULT NULL,
    "mode" smallint  DEFAULT NULL check ("mode" >= 0),
    "network" varchar(20)   DEFAULT NULL,
    "note" text  DEFAULT NULL,
    "order" jsonb  DEFAULT NULL,
    "otherProperties" jsonb  DEFAULT NULL,
    "reverse" varchar(42)  DEFAULT NULL,
    "reversedby" varchar(42)  DEFAULT NULL,
    "settleDtm" timestamptz  DEFAULT NULL,
    "sttn" jsonb  DEFAULT NULL,
    "tags" jsonb  DEFAULT NULL,
    "template" jsonb  DEFAULT NULL,
    "trnCode" varchar(20)   DEFAULT NULL,
    "workItem" jsonb  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "batchDtl"."_Id" IS 'Unique batch identifier';
COMMENT ON COLUMN "batchDtl"."attachments" IS 'URI References to attached documents and images';
COMMENT ON COLUMN "batchDtl"."batchId" IS 'For a batch source the object that contains batch detail';
COMMENT ON COLUMN "batchDtl"."bill" IS 'Bill or invoice detail object';
COMMENT ON COLUMN "batchDtl"."effectDtm" IS 'The effective date of the transaction for account processing, can be backdate or future';
COMMENT ON COLUMN "batchDtl"."eft" IS 'Detail information accompanying an EFT ISO8583 transaction';
COMMENT ON COLUMN "batchDtl"."glJrnlDate" IS 'The GL journal date this transaction entry is postting on';
COMMENT ON COLUMN "batchDtl"."logRef" IS 'Unique message log identifier';
COMMENT ON COLUMN "batchDtl"."mode" IS 'The host processing mode';
COMMENT ON COLUMN "batchDtl"."network" IS 'The posting network of this message';
COMMENT ON COLUMN "batchDtl"."note" IS 'Detailed free form transaction notes';
COMMENT ON COLUMN "batchDtl"."order" IS 'Payment, collection or transfer order detail';
COMMENT ON COLUMN "batchDtl"."otherProperties" IS 'Array of additional properties in name:value object pairs';
COMMENT ON COLUMN "batchDtl"."reverse" IS 'Transaction Id to reverse in position history';
COMMENT ON COLUMN "batchDtl"."reversedby" IS 'Transaction ID that reversed this transaction';
COMMENT ON COLUMN "batchDtl"."settleDtm" IS 'The settlement or value date of this transaction';
COMMENT ON COLUMN "batchDtl"."sttn" IS 'Originating station or terminal detail object';
COMMENT ON COLUMN "batchDtl"."tags" IS 'tag name';
COMMENT ON COLUMN "batchDtl"."template" IS 'Template object to initialize transaction entries';
COMMENT ON COLUMN "batchDtl"."trnCode" IS 'The Finxact transaction code';
COMMENT ON COLUMN "batchDtl"."workItem" IS 'Workflow case detail';


-- Creating Table batchDtlEntries
DROP TABLE IF EXISTS "batchDtlEntries";
CREATE TABLE "batchDtlEntries" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "acctGroup" integer  NOT NULL  check ("acctGroup" >= 0),
    "acctNbr" varchar(20)   NOT NULL ,
    "amt" decimal(16,2)   NOT NULL ,
    "assetClass" bigint  DEFAULT 1 check ("assetClass" >= 0),
    "assetId" varchar(12)   DEFAULT NULL,
    "ccyCode" varchar(3)   DEFAULT 'USD',
    "comment" varchar(60)   DEFAULT NULL,
    "company" integer  DEFAULT 0 check ("company" >= 0),
    "deptId" integer  DEFAULT 0 check ("deptId" >= 0),
    "glSetCode" varchar(20)   DEFAULT NULL,
    "isContact" boolean  DEFAULT NULL,
    "isDr" boolean  DEFAULT NULL,
    "posnId" varchar(42)  DEFAULT NULL,
    "posnRef" varchar(30)   DEFAULT NULL,
    "rAndtNbr" varchar(40)   DEFAULT NULL,
    "seqNbr" bigint  DEFAULT NULL,
    "src" varchar(60)   DEFAULT NULL,
    "trace" varchar(40)   DEFAULT NULL,
    "vertical" int  DEFAULT 0,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "batchDtlEntries"."_Id" IS 'Unique batch identifier';
COMMENT ON COLUMN "batchDtlEntries"."_Ix" IS '_Ix for Field entries';
COMMENT ON COLUMN "batchDtlEntries"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "batchDtlEntries"."acctNbr" IS 'The unique account identifier within an acctGroup';
COMMENT ON COLUMN "batchDtlEntries"."amt" IS 'Amount or quantity of asset exchanged';
COMMENT ON COLUMN "batchDtlEntries"."assetClass" IS 'The asset class of the position';
COMMENT ON COLUMN "batchDtlEntries"."assetId" IS 'Asset identifier within the asset class';
COMMENT ON COLUMN "batchDtlEntries"."ccyCode" IS 'Currency code alias {assetClass:1, assetId: curCd}';
COMMENT ON COLUMN "batchDtlEntries"."comment" IS 'Short transaction comment';
COMMENT ON COLUMN "batchDtlEntries"."company" IS 'Company reported';
COMMENT ON COLUMN "batchDtlEntries"."deptId" IS 'Balancing department or cost center Id';
COMMENT ON COLUMN "batchDtlEntries"."glSetCode" IS 'GL account numbers set code';
COMMENT ON COLUMN "batchDtlEntries"."isContact" IS 'Update customer contact indicator';
COMMENT ON COLUMN "batchDtlEntries"."isDr" IS 'Is a debit entry to position';
COMMENT ON COLUMN "batchDtlEntries"."posnId" IS 'Unique position identifier is FK to posn PK';
COMMENT ON COLUMN "batchDtlEntries"."posnRef" IS 'The unique position identifier within an acctGroup';
COMMENT ON COLUMN "batchDtlEntries"."rAndtNbr" IS 'The RT number on a deposited check item';
COMMENT ON COLUMN "batchDtlEntries"."seqNbr" IS 'Record, row or database sequence number';
COMMENT ON COLUMN "batchDtlEntries"."src" IS 'Customer attributed source of funds for AML analysis';
COMMENT ON COLUMN "batchDtlEntries"."trace" IS 'The unique transaction identifier within the source';
COMMENT ON COLUMN "batchDtlEntries"."vertical" IS 'Vertical reported';


-- Creating Table batchDtlEntriesAddHold
DROP TABLE IF EXISTS "batchDtlEntriesAddHold";
CREATE TABLE "batchDtlEntriesAddHold" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "acctGroup" integer  DEFAULT NULL check ("acctGroup" >= 0),
    "authRef" varchar(30)   DEFAULT NULL,
    "cancelDtm" timestamptz  DEFAULT NULL,
    "dur" varchar(255)   DEFAULT NULL,
    "endDtm" timestamptz  DEFAULT NULL,
    "holdAmt" decimal(16,2)   DEFAULT NULL,
    "holdType" smallint  DEFAULT NULL check ("holdType" >= 0),
    "interval" varchar(255)   DEFAULT NULL,
    "note" text  DEFAULT NULL,
    "posnId" varchar(42)  DEFAULT NULL,
    "posnRef" varchar(30)   DEFAULT NULL,
    "reason" varchar(10)   DEFAULT NULL,
    "slices" jsonb  DEFAULT NULL,
    "startDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "batchDtlEntriesAddHold"."_Id" IS 'Unique batch identifier';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."_Ix" IS '_Ix for Field entries';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."authRef" IS 'External reference for authorization hold';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."cancelDtm" IS 'Date and time hold was cancelled';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."dur" IS 'Duration of the hold determines endDt';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."endDtm" IS 'Date and time hold will expire, default 10/15/2114-23:59';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."holdAmt" IS 'Amount to hold, default to entry.tranAmt';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."holdType" IS 'The hold type code';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."interval" IS 'Duration of a slice interval if slices (e.g., (1D)';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."note" IS 'Free form accompanying note';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."posnId" IS 'Unique position identifier';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."posnRef" IS 'The unique position identifier within an acctGroup';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."reason" IS 'The reason code for why hold was placed';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."slices" IS 'Slice amount';
COMMENT ON COLUMN "batchDtlEntriesAddHold"."startDtm" IS 'Date and time hold will start, default immediately';


-- Creating Table batchDtlEntriesAuth
DROP TABLE IF EXISTS "batchDtlEntriesAuth";
CREATE TABLE "batchDtlEntriesAuth" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "exceptions" jsonb  DEFAULT NULL,
    "isAuthAll" boolean  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "batchDtlEntriesAuth"."_Id" IS 'Unique batch identifier';
COMMENT ON COLUMN "batchDtlEntriesAuth"."_Ix" IS '_Ix for Field entries';
COMMENT ON COLUMN "batchDtlEntriesAuth"."exceptions" IS 'Exception authorization';
COMMENT ON COLUMN "batchDtlEntriesAuth"."isAuthAll" IS 'if true, authorize all exceptions on this item';


-- Creating Table batchDtlEntriesChk
DROP TABLE IF EXISTS "batchDtlEntriesChk";
CREATE TABLE "batchDtlEntriesChk" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "chkNbr" int  NOT NULL  check ("chkNbr" >= 0),
    "imgUri" varchar(255)   DEFAULT NULL,
    "issueDate" date  DEFAULT NULL,
    "payee" varchar(60)   DEFAULT NULL,
    "sprayNbr" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "batchDtlEntriesChk"."_Id" IS 'Unique batch identifier';
COMMENT ON COLUMN "batchDtlEntriesChk"."_Ix" IS '_Ix for Field entries';
COMMENT ON COLUMN "batchDtlEntriesChk"."chkNbr" IS 'Check number';
COMMENT ON COLUMN "batchDtlEntriesChk"."imgUri" IS 'Check image identifier URI';
COMMENT ON COLUMN "batchDtlEntriesChk"."issueDate" IS 'Issued date';
COMMENT ON COLUMN "batchDtlEntriesChk"."payee" IS 'Pay to the order of';
COMMENT ON COLUMN "batchDtlEntriesChk"."sprayNbr" IS 'Inclearing item reference number';


-- Creating Table batchDtlEntriesExch
DROP TABLE IF EXISTS "batchDtlEntriesExch";
CREATE TABLE "batchDtlEntriesExch" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "baseAmt" decimal(16,2)   DEFAULT NULL,
    "costRate" decimal(16,5)   DEFAULT NULL,
    "exchRate" decimal(16,5)   NOT NULL ,
    "isMultiply" boolean  DEFAULT true,
    "marginCode" varchar(3)   DEFAULT NULL,
    "treasRef" varchar(30)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "batchDtlEntriesExch"."_Id" IS 'Unique batch identifier';
COMMENT ON COLUMN "batchDtlEntriesExch"."_Ix" IS '_Ix for Field entries';
COMMENT ON COLUMN "batchDtlEntriesExch"."baseAmt" IS 'Cost or price of exchange in base currency';
COMMENT ON COLUMN "batchDtlEntriesExch"."costRate" IS 'Cost rate to base currency';
COMMENT ON COLUMN "batchDtlEntriesExch"."exchRate" IS 'Buy/Sell rate';
COMMENT ON COLUMN "batchDtlEntriesExch"."isMultiply" IS 'Multiply transaction amount*rate to get base equivalent';
COMMENT ON COLUMN "batchDtlEntriesExch"."marginCode" IS 'The customer code used to determine rate margin';
COMMENT ON COLUMN "batchDtlEntriesExch"."treasRef" IS 'Treasury authorization reference';


-- Creating Table batchDtlEntriesGlDist
DROP TABLE IF EXISTS "batchDtlEntriesGlDist";
CREATE TABLE "batchDtlEntriesGlDist" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "accrFee" decimal(16,2)   DEFAULT NULL,
    "accrInt" decimal(16,2)   DEFAULT NULL,
    "avlInt" decimal(16,2)   DEFAULT NULL,
    "ledger" decimal(16,2)   DEFAULT NULL,
    "negAccr" decimal(16,2)   DEFAULT NULL,
    "wthFed" decimal(16,2)   DEFAULT NULL,
    "wthState" decimal(16,2)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "batchDtlEntriesGlDist"."_Id" IS 'Unique batch identifier';
COMMENT ON COLUMN "batchDtlEntriesGlDist"."_Ix" IS '_Ix for Field entries';
COMMENT ON COLUMN "batchDtlEntriesGlDist"."accrFee" IS 'Post to accrued fee on the position';
COMMENT ON COLUMN "batchDtlEntriesGlDist"."accrInt" IS 'Post to accrued interest balance on the position';
COMMENT ON COLUMN "batchDtlEntriesGlDist"."avlInt" IS 'Post to available interest on the position';
COMMENT ON COLUMN "batchDtlEntriesGlDist"."ledger" IS 'Post to ledger balance on the position';
COMMENT ON COLUMN "batchDtlEntriesGlDist"."negAccr" IS 'Post to negative accrued interest on the position';
COMMENT ON COLUMN "batchDtlEntriesGlDist"."wthFed" IS 'Post to federal backup withholding on the position';
COMMENT ON COLUMN "batchDtlEntriesGlDist"."wthState" IS 'Post to state or region withholding on the position';


-- Creating Table batchDtlEntriesPassbook
DROP TABLE IF EXISTS "batchDtlEntriesPassbook";
CREATE TABLE "batchDtlEntriesPassbook" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "bookBal" decimal(16,2)   NOT NULL ,
    "bookNbr" varchar(20)   NOT NULL ,
    "isNobook" boolean  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "batchDtlEntriesPassbook"."_Id" IS 'Unique batch identifier';
COMMENT ON COLUMN "batchDtlEntriesPassbook"."_Ix" IS '_Ix for Field entries';
COMMENT ON COLUMN "batchDtlEntriesPassbook"."bookBal" IS 'The last balance printed on the passbook';
COMMENT ON COLUMN "batchDtlEntriesPassbook"."bookNbr" IS 'Passbook Number';
COMMENT ON COLUMN "batchDtlEntriesPassbook"."isNobook" IS 'Is a nobook transaction';


-- Creating Table batchDtlEntriesRemoveHold
DROP TABLE IF EXISTS "batchDtlEntriesRemoveHold";
CREATE TABLE "batchDtlEntriesRemoveHold" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "acctGroup" integer  DEFAULT NULL check ("acctGroup" >= 0),
    "authRef" varchar(30)   DEFAULT NULL,
    "cancelDtm" timestamptz  DEFAULT NULL,
    "dur" varchar(255)   DEFAULT NULL,
    "endDtm" timestamptz  DEFAULT NULL,
    "holdAmt" decimal(16,2)   DEFAULT NULL,
    "holdType" smallint  DEFAULT NULL check ("holdType" >= 0),
    "interval" varchar(255)   DEFAULT NULL,
    "note" text  DEFAULT NULL,
    "posnId" varchar(42)  DEFAULT NULL,
    "posnRef" varchar(30)   DEFAULT NULL,
    "reason" varchar(10)   DEFAULT NULL,
    "slices" jsonb  DEFAULT NULL,
    "startDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."_Id" IS 'Unique batch identifier';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."_Ix" IS '_Ix for Field entries';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."authRef" IS 'External reference for authorization hold';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."cancelDtm" IS 'Date and time hold was cancelled';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."dur" IS 'Duration of the hold determines endDt';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."endDtm" IS 'Date and time hold will expire, default 10/15/2114-23:59';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."holdAmt" IS 'Amount to hold, default to entry.tranAmt';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."holdType" IS 'The hold type code';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."interval" IS 'Duration of a slice interval if slices (e.g., (1D)';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."note" IS 'Free form accompanying note';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."posnId" IS 'Unique position identifier';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."posnRef" IS 'The unique position identifier within an acctGroup';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."reason" IS 'The reason code for why hold was placed';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."slices" IS 'Slice amount';
COMMENT ON COLUMN "batchDtlEntriesRemoveHold"."startDtm" IS 'Date and time hold will start, default immediately';


-- Creating Table bill
DROP TABLE IF EXISTS "bill";
CREATE TABLE "bill" (
    "billDate" date  DEFAULT NULL,
    "billFromDate" date  DEFAULT NULL,
    "billId" varchar(42)  NOT NULL ,
    "billImg" varchar(255)   DEFAULT NULL,
    "billToDate" date  DEFAULT NULL,
    "contractId" varchar(30)   DEFAULT NULL,
    "crAmt" decimal(16,2)   DEFAULT NULL,
    "custId" varchar(30)   DEFAULT NULL,
    "custTitle" varchar(60)   DEFAULT NULL,
    "dscntAmt" decimal(16,2)   DEFAULT NULL,
    "dueAmt" decimal(16,2)   DEFAULT NULL,
    "finChrgAmt" decimal(16,2)   DEFAULT NULL,
    "grossAmt" decimal(16,2)   DEFAULT NULL,
    "insureAmt" decimal(16,2)   DEFAULT NULL,
    "invId" varchar(30)   DEFAULT NULL,
    "jobId" varchar(30)   DEFAULT NULL,
    "minPmtDue" decimal(16,2)   DEFAULT NULL,
    "note" text  DEFAULT NULL,
    "orderDtm" timestamptz  DEFAULT NULL,
    "orderId" varchar(255)   DEFAULT NULL,
    "partyId" varchar(42)  NOT NULL ,
    "pastDueAmt" decimal(16,2)   DEFAULT NULL,
    "pmtDueDate" date  DEFAULT NULL,
    "shipAmt" decimal(16,2)   DEFAULT NULL,
    "stmtImg" varchar(255)   DEFAULT NULL,
    "storeId" varchar(30)   DEFAULT NULL,
    "taxAmt" decimal(16,2)   DEFAULT NULL,
    
    PRIMARY KEY ("partyId", "billId")
); 
COMMENT ON COLUMN "bill"."billDate" IS 'The date bill was issued';
COMMENT ON COLUMN "bill"."billFromDate" IS 'The beginning of the billing period';
COMMENT ON COLUMN "bill"."billId" IS 'Unique Bill identifier';
COMMENT ON COLUMN "bill"."billImg" IS 'The bill image URI';
COMMENT ON COLUMN "bill"."billToDate" IS 'The end of the billing period';
COMMENT ON COLUMN "bill"."contractId" IS 'Contract or master services agreement identifier';
COMMENT ON COLUMN "bill"."crAmt" IS 'Total deposits, payments and credits previously applied';
COMMENT ON COLUMN "bill"."custId" IS 'Customer account at merchant';
COMMENT ON COLUMN "bill"."custTitle" IS 'Customer account title or name at merchant';
COMMENT ON COLUMN "bill"."dscntAmt" IS 'Total discount amount';
COMMENT ON COLUMN "bill"."dueAmt" IS 'Payment amount due balance';
COMMENT ON COLUMN "bill"."finChrgAmt" IS 'Finance charge amount';
COMMENT ON COLUMN "bill"."grossAmt" IS 'Gross bill/invoice amount';
COMMENT ON COLUMN "bill"."insureAmt" IS 'Total insurance amount';
COMMENT ON COLUMN "bill"."invId" IS 'Merchant bill/invoice identifier';
COMMENT ON COLUMN "bill"."jobId" IS 'Job number or reference';
COMMENT ON COLUMN "bill"."minPmtDue" IS 'Minimum payment amount due';
COMMENT ON COLUMN "bill"."note" IS 'Free form bill note';
COMMENT ON COLUMN "bill"."orderDtm" IS 'The order date';
COMMENT ON COLUMN "bill"."orderId" IS 'Purchase Order identifier';
COMMENT ON COLUMN "bill"."partyId" IS 'Unique Party identifier';
COMMENT ON COLUMN "bill"."pastDueAmt" IS 'Total past due amount';
COMMENT ON COLUMN "bill"."pmtDueDate" IS 'The payment due date';
COMMENT ON COLUMN "bill"."shipAmt" IS 'Total shipping amount';
COMMENT ON COLUMN "bill"."stmtImg" IS 'Electronic statement URL';
COMMENT ON COLUMN "bill"."storeId" IS 'The store identifier';
COMMENT ON COLUMN "bill"."taxAmt" IS 'Total tax amount';


-- Creating Table billCustAddr
DROP TABLE IF EXISTS "billCustAddr";
CREATE TABLE "billCustAddr" (
    "billId" varchar(42)  NOT NULL ,
    "city" varchar(40)   DEFAULT NULL,
    "cntry" varchar(2)   DEFAULT NULL,
    "geoLoc" jsonb  DEFAULT NULL,
    "partyId" varchar(42)  NOT NULL ,
    "postCode" varchar(9)   DEFAULT NULL,
    "premise" varchar(30)   DEFAULT NULL,
    "region" varchar(2)   DEFAULT NULL,
    "street" text  DEFAULT NULL,
    
    PRIMARY KEY ("partyId", "billId")
); 
COMMENT ON COLUMN "billCustAddr"."billId" IS 'Unique Bill identifier';
COMMENT ON COLUMN "billCustAddr"."city" IS 'Address city';
COMMENT ON COLUMN "billCustAddr"."cntry" IS 'Address country';
COMMENT ON COLUMN "billCustAddr"."geoLoc" IS 'Fixed geographic location of address';
COMMENT ON COLUMN "billCustAddr"."partyId" IS 'Unique Party identifier';
COMMENT ON COLUMN "billCustAddr"."postCode" IS 'The address postal code';
COMMENT ON COLUMN "billCustAddr"."premise" IS 'Name location or building name';
COMMENT ON COLUMN "billCustAddr"."region" IS 'State, Province, County or Land';
COMMENT ON COLUMN "billCustAddr"."street" IS 'Street number, PO box or RD and street name';


-- Creating Table billDtl
DROP TABLE IF EXISTS "billDtl";
CREATE TABLE "billDtl" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "billId" varchar(42)  NOT NULL ,
    "catCode" varchar(20)   DEFAULT NULL,
    "cost" decimal(16,2)   DEFAULT NULL,
    "description" varchar(60)   DEFAULT NULL,
    "dscntAmt" decimal(16,2)   DEFAULT NULL,
    "dscntPct" smallint  DEFAULT NULL check ("dscntPct" >= 0),
    "extendAmt" decimal(16,2)   DEFAULT NULL,
    "isNonTax" boolean  DEFAULT NULL,
    "itemImg" varchar(255)   DEFAULT NULL,
    "partId" varchar(20)   DEFAULT NULL,
    "partyId" varchar(42)  NOT NULL ,
    "qtyFill" bigint  DEFAULT NULL check ("qtyFill" >= 0),
    "qtyOrder" bigint  DEFAULT NULL,
    
    PRIMARY KEY ("partyId", "billId", "_Ix")
); 
COMMENT ON COLUMN "billDtl"."_Ix" IS '_Ix for Field dtl';
COMMENT ON COLUMN "billDtl"."billId" IS 'Unique Bill identifier';
COMMENT ON COLUMN "billDtl"."catCode" IS 'Category code';
COMMENT ON COLUMN "billDtl"."cost" IS 'Cost per one unit item';
COMMENT ON COLUMN "billDtl"."description" IS 'Line item description';
COMMENT ON COLUMN "billDtl"."dscntAmt" IS 'Discount amount per unit item';
COMMENT ON COLUMN "billDtl"."dscntPct" IS 'Discount percentage';
COMMENT ON COLUMN "billDtl"."extendAmt" IS 'Total amount for line - extended';
COMMENT ON COLUMN "billDtl"."isNonTax" IS 'Is non-taxable item';
COMMENT ON COLUMN "billDtl"."itemImg" IS 'Item image URL';
COMMENT ON COLUMN "billDtl"."partId" IS 'Part Number or Id (SKU) ordered';
COMMENT ON COLUMN "billDtl"."partyId" IS 'Unique Party identifier';
COMMENT ON COLUMN "billDtl"."qtyFill" IS 'Quantity fulfilled';
COMMENT ON COLUMN "billDtl"."qtyOrder" IS 'Quantity ordered';


-- Creating Table billMerch
DROP TABLE IF EXISTS "billMerch";
CREATE TABLE "billMerch" (
    "billId" varchar(42)  NOT NULL ,
    "cat" bigint  DEFAULT NULL,
    "cntry" varchar(2)   DEFAULT NULL,
    "contactPref" smallint  DEFAULT NULL check ("contactPref" >= 0),
    "folderId" varchar(42)  DEFAULT NULL,
    "name" varchar(80)   NOT NULL ,
    "networkId" bigint  DEFAULT NULL,
    "partyId" varchar(42)  NOT NULL ,
    "preferAddrId" varchar(42)  DEFAULT NULL,
    "preferEmailId" smallint  DEFAULT NULL check ("preferEmailId" >= 0),
    "preferPhoneId" smallint  DEFAULT NULL check ("preferPhoneId" >= 0),
    "taxid" varchar(11)   DEFAULT NULL,
    
    PRIMARY KEY ("partyId", "billId")
); 
COMMENT ON COLUMN "billMerch"."billId" IS 'Unique Bill identifier';
COMMENT ON COLUMN "billMerch"."cat" IS 'Merchant Category Code (MCC)';
COMMENT ON COLUMN "billMerch"."cntry" IS 'Country of residence or registration ISO 3166-2';
COMMENT ON COLUMN "billMerch"."contactPref" IS 'The method of contact preference';
COMMENT ON COLUMN "billMerch"."folderId" IS 'Partys documents and attachments root folder Id';
COMMENT ON COLUMN "billMerch"."name" IS 'Formatted full name of party';
COMMENT ON COLUMN "billMerch"."networkId" IS 'Merchant network identifier';
COMMENT ON COLUMN "billMerch"."partyId" IS 'Unique Party identifier';
COMMENT ON COLUMN "billMerch"."preferAddrId" IS 'Preferred address identifier';
COMMENT ON COLUMN "billMerch"."preferEmailId" IS 'Preferred email identifier';
COMMENT ON COLUMN "billMerch"."preferPhoneId" IS 'Preferred phone number identifier';
COMMENT ON COLUMN "billMerch"."taxid" IS 'US taxid or social security number';


-- Creating Table billMerchAddrs
DROP TABLE IF EXISTS "billMerchAddrs";
CREATE TABLE "billMerchAddrs" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "addrId" varchar(42)  NOT NULL ,
    "addrType" smallint  NOT NULL  check ("addrType" >= 0),
    "billId" varchar(42)  NOT NULL ,
    "label" varchar(30)   DEFAULT NULL,
    "partyId" varchar(42)  NOT NULL ,
    "priority" smallint  DEFAULT NULL check ("priority" >= 0),
    "validFromDtm" timestamptz  DEFAULT NULL,
    "validToDtm" timestamptz  DEFAULT NULL,
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("partyId", "billId", "_Ix")
); 
COMMENT ON COLUMN "billMerchAddrs"."_Ix" IS '_Ix for Field addrs';
COMMENT ON COLUMN "billMerchAddrs"."addrId" IS 'The address Id';
COMMENT ON COLUMN "billMerchAddrs"."addrType" IS 'The type of address';
COMMENT ON COLUMN "billMerchAddrs"."billId" IS 'Unique Bill identifier';
COMMENT ON COLUMN "billMerchAddrs"."label" IS 'The label of this address';
COMMENT ON COLUMN "billMerchAddrs"."partyId" IS 'Unique Party identifier';
COMMENT ON COLUMN "billMerchAddrs"."priority" IS 'Listing sort priority';
COMMENT ON COLUMN "billMerchAddrs"."validFromDtm" IS 'Address is valid from date';
COMMENT ON COLUMN "billMerchAddrs"."validToDtm" IS 'Address is valid to date';
COMMENT ON COLUMN "billMerchAddrs"."verifyDtm" IS 'Date address was last verified';


-- Creating Table billMerchEmails
DROP TABLE IF EXISTS "billMerchEmails";
CREATE TABLE "billMerchEmails" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "billId" varchar(42)  NOT NULL ,
    "data" varchar(255)   NOT NULL ,
    "emailType" smallint  NOT NULL  check ("emailType" >= 0),
    "label" varchar(30)   DEFAULT NULL,
    "partyId" varchar(42)  NOT NULL ,
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("partyId", "billId", "_Ix")
); 
COMMENT ON COLUMN "billMerchEmails"."_Ix" IS '_Ix for Field emails';
COMMENT ON COLUMN "billMerchEmails"."billId" IS 'Unique Bill identifier';
COMMENT ON COLUMN "billMerchEmails"."data" IS 'The email address';
COMMENT ON COLUMN "billMerchEmails"."emailType" IS 'Email type';
COMMENT ON COLUMN "billMerchEmails"."label" IS 'Label';
COMMENT ON COLUMN "billMerchEmails"."partyId" IS 'Unique Party identifier';
COMMENT ON COLUMN "billMerchEmails"."verifyDtm" IS 'Date email was last verified';


-- Creating Table billMerchPhones
DROP TABLE IF EXISTS "billMerchPhones";
CREATE TABLE "billMerchPhones" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "billId" varchar(42)  NOT NULL ,
    "data" varchar(20)   NOT NULL ,
    "label" varchar(30)   DEFAULT NULL,
    "partyId" varchar(42)  NOT NULL ,
    "phoneType" smallint  NOT NULL  check ("phoneType" >= 0),
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("partyId", "billId", "_Ix")
); 
COMMENT ON COLUMN "billMerchPhones"."_Ix" IS '_Ix for Field phones';
COMMENT ON COLUMN "billMerchPhones"."billId" IS 'Unique Bill identifier';
COMMENT ON COLUMN "billMerchPhones"."data" IS 'Phone number';
COMMENT ON COLUMN "billMerchPhones"."label" IS 'Label';
COMMENT ON COLUMN "billMerchPhones"."partyId" IS 'Unique Party identifier';
COMMENT ON COLUMN "billMerchPhones"."phoneType" IS 'Phone type';
COMMENT ON COLUMN "billMerchPhones"."verifyDtm" IS 'Date phone was last verified';


-- Creating Table calendar
DROP TABLE IF EXISTS "calendar";
CREATE TABLE "calendar" (
    "holidays" jsonb  DEFAULT NULL,
    "name" varchar(30)   NOT NULL ,
    "tmZone" varchar(3)   DEFAULT NULL,
    
    PRIMARY KEY ("name")
); 
COMMENT ON COLUMN "calendar"."holidays" IS 'Recognized holidays and hours of operation';
COMMENT ON COLUMN "calendar"."name" IS 'Calendar name';
COMMENT ON COLUMN "calendar"."tmZone" IS 'Time zone for daily and holiday hours';


-- Creating Table calendarBusinessDays
DROP TABLE IF EXISTS "calendarBusinessDays";
CREATE TABLE "calendarBusinessDays" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "closeTm" varchar(255)   DEFAULT NULL,
    "dayOfWk" smallint  DEFAULT NULL check ("dayOfWk" >= 0),
    "isAllDay" boolean  DEFAULT NULL,
    "name" varchar(30)   NOT NULL ,
    "openTm" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("name", "_Ix")
); 
COMMENT ON COLUMN "calendarBusinessDays"."_Ix" IS '_Ix for Field businessDays';
COMMENT ON COLUMN "calendarBusinessDays"."closeTm" IS 'Close of business';
COMMENT ON COLUMN "calendarBusinessDays"."dayOfWk" IS 'Day of week';
COMMENT ON COLUMN "calendarBusinessDays"."isAllDay" IS 'Open all day';
COMMENT ON COLUMN "calendarBusinessDays"."name" IS 'Calendar name';
COMMENT ON COLUMN "calendarBusinessDays"."openTm" IS 'Open of business';


-- Creating Table calendarRefCalendar
DROP TABLE IF EXISTS "calendarRefCalendar";
CREATE TABLE "calendarRefCalendar" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "name" varchar(30)   NOT NULL ,
    "refCalendarName" varchar(30)   DEFAULT NULL,
    
    PRIMARY KEY ("name", "_Ix")
); 
COMMENT ON COLUMN "calendarRefCalendar"."_Ix" IS '_Ix for Field refCalendar';
COMMENT ON COLUMN "calendarRefCalendar"."name" IS 'Calendar name';
COMMENT ON COLUMN "calendarRefCalendar"."refCalendarName" IS 'Referenced Calendar name';


-- Creating Table channel
DROP TABLE IF EXISTS "channel";
CREATE TABLE "channel" (
    "channel" varchar(20)   NOT NULL ,
    "desc" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("channel")
); 
COMMENT ON COLUMN "channel"."channel" IS 'The name of the channel';
COMMENT ON COLUMN "channel"."desc" IS 'The channel description';


-- Creating Table cntry
DROP TABLE IF EXISTS "cntry";
CREATE TABLE "cntry" (
    "cntryName" varchar(60)   DEFAULT NULL,
    "isoAlpha2" varchar(2)   NOT NULL ,
    "isoAlpha3" varchar(3)   DEFAULT NULL,
    "isoNumeric" integer  DEFAULT NULL check ("isoNumeric" >= 0),
    
    PRIMARY KEY ("isoAlpha2")
); 
COMMENT ON COLUMN "cntry"."cntryName" IS 'English name of country';
COMMENT ON COLUMN "cntry"."isoAlpha2" IS 'ISO Alpha-2 Code';
COMMENT ON COLUMN "cntry"."isoAlpha3" IS 'ISO Alpha-3 Code';
COMMENT ON COLUMN "cntry"."isoNumeric" IS 'ISO Numeric Code';


-- Creating Table cntryRegion
DROP TABLE IF EXISTS "cntryRegion";
CREATE TABLE "cntryRegion" (
    "cntry" varchar(2)   NOT NULL ,
    "region" varchar(2)   NOT NULL ,
    
    PRIMARY KEY ("cntry", "region")
); 
COMMENT ON COLUMN "cntryRegion"."cntry" IS 'ISO Alpha-2 Code';
COMMENT ON COLUMN "cntryRegion"."region" IS 'State / Region code';


-- Creating Table componentFees
DROP TABLE IF EXISTS "componentFees";
CREATE TABLE "componentFees" (
    "componentName" varchar(30)   NOT NULL ,
    "earningsAnalysis" smallint  DEFAULT NULL check ("earningsAnalysis" >= 0),
    "feeItems" jsonb  DEFAULT NULL,
    "posnFeeMax" decimal(16,2)   DEFAULT NULL,
    "posnFeeMin" decimal(16,2)   DEFAULT NULL,
    "svcChrgFreq" varchar(255)   DEFAULT NULL,
    "trnFees" jsonb  DEFAULT NULL,
    "version" integer  NOT NULL  check ("version" >= 0),
    
    PRIMARY KEY ("componentName", "version")
); 
COMMENT ON COLUMN "componentFees"."componentName" IS 'Fees component name';
COMMENT ON COLUMN "componentFees"."earningsAnalysis" IS 'Earnings analysis usage option';
COMMENT ON COLUMN "componentFees"."feeItems" IS 'Individual fee items associated with the plan';
COMMENT ON COLUMN "componentFees"."posnFeeMax" IS 'The maximum fee to charge to position';
COMMENT ON COLUMN "componentFees"."posnFeeMin" IS 'The minimum fee to charge to position';
COMMENT ON COLUMN "componentFees"."svcChrgFreq" IS 'Defines the service charge period and posting datefor cycled and accumulated fees';
COMMENT ON COLUMN "componentFees"."trnFees" IS 'Fees for individual transactions';
COMMENT ON COLUMN "componentFees"."version" IS 'Fees component version';


-- Creating Table componentInt
DROP TABLE IF EXISTS "componentInt";
CREATE TABLE "componentInt" (
    "accrMinBal" decimal(16,2)   DEFAULT NULL,
    "adjTerm" varchar(255)   DEFAULT NULL,
    "balOpt" smallint  DEFAULT 0 check ("balOpt" >= 0),
    "calcMthd" smallint  DEFAULT NULL check ("calcMthd" >= 0),
    "componentName" varchar(30)   NOT NULL ,
    "disbmtOpt" smallint  DEFAULT NULL check ("disbmtOpt" >= 0),
    "index" jsonb  DEFAULT NULL,
    "isCompoundDly" boolean  DEFAULT NULL,
    "nomRate" decimal(16,5)   DEFAULT NULL,
    "postFreq" varchar(255)   DEFAULT NULL,
    "promoDtl" jsonb  DEFAULT NULL,
    "version" integer  NOT NULL  check ("version" >= 0),
    
    PRIMARY KEY ("componentName", "version")
); 
COMMENT ON COLUMN "componentInt"."accrMinBal" IS 'Minimum balance to accrue';
COMMENT ON COLUMN "componentInt"."adjTerm" IS 'Term where rate can be adjusted and replaced if higher';
COMMENT ON COLUMN "componentInt"."balOpt" IS 'Balance used to calculate accrual';
COMMENT ON COLUMN "componentInt"."calcMthd" IS 'Interest accrual calculation method';
COMMENT ON COLUMN "componentInt"."componentName" IS 'Interest component name';
COMMENT ON COLUMN "componentInt"."disbmtOpt" IS 'Interest disbursement option';
COMMENT ON COLUMN "componentInt"."index" IS 'Indexed rate properties and limits';
COMMENT ON COLUMN "componentInt"."isCompoundDly" IS 'Flag indicates daily interest compounding at accrual cutoff';
COMMENT ON COLUMN "componentInt"."nomRate" IS 'Current nominal interest rate';
COMMENT ON COLUMN "componentInt"."postFreq" IS 'Interest posting frequency';
COMMENT ON COLUMN "componentInt"."promoDtl" IS 'Promotional rate properties and limits';
COMMENT ON COLUMN "componentInt"."version" IS 'Interest component version';


-- Creating Table componentLimits
DROP TABLE IF EXISTS "componentLimits";
CREATE TABLE "componentLimits" (
    "accumTrnLimits" jsonb  DEFAULT NULL,
    "componentName" varchar(30)   NOT NULL ,
    "deminimisAmt" decimal(16,2)   DEFAULT NULL,
    "maxPosnBal" decimal(16,2)   DEFAULT NULL,
    "minPosnBal" decimal(16,2)   DEFAULT NULL,
    "minToOpen" decimal(16,2)   DEFAULT NULL,
    "perTrnLimits" jsonb  DEFAULT NULL,
    "restrictCr" boolean  DEFAULT NULL,
    "restrictCrFundExp" boolean  DEFAULT NULL,
    "restrictDr" boolean  DEFAULT NULL,
    "version" integer  NOT NULL  check ("version" >= 0),
    
    PRIMARY KEY ("componentName", "version")
); 
COMMENT ON COLUMN "componentLimits"."accumTrnLimits" IS 'Limits on groups of transactions by period';
COMMENT ON COLUMN "componentLimits"."componentName" IS 'Limits component name';
COMMENT ON COLUMN "componentLimits"."deminimisAmt" IS 'Insignificant amount which the position may be negative before it is considered overdrawn';
COMMENT ON COLUMN "componentLimits"."maxPosnBal" IS 'Maximum allowable position balance';
COMMENT ON COLUMN "componentLimits"."minPosnBal" IS 'Minimum allowable position balance';
COMMENT ON COLUMN "componentLimits"."minToOpen" IS 'Minimum deposit amount that must be met to open the position';
COMMENT ON COLUMN "componentLimits"."perTrnLimits" IS 'Limits on single transactions';
COMMENT ON COLUMN "componentLimits"."restrictCr" IS 'Restrict all credits to position except during a grace period';
COMMENT ON COLUMN "componentLimits"."restrictCrFundExp" IS 'Restrict all credits after the funding expiration date';
COMMENT ON COLUMN "componentLimits"."restrictDr" IS 'Restrict all debits to position';
COMMENT ON COLUMN "componentLimits"."version" IS 'Limits component version';


-- Creating Table componentTd
DROP TABLE IF EXISTS "componentTd";
CREATE TABLE "componentTd" (
    "componentName" varchar(30)   NOT NULL ,
    "crTermExt" varchar(255)   DEFAULT NULL,
    "earlyDrPen" smallint  DEFAULT NULL check ("earlyDrPen" >= 0),
    "intMatrix" varchar(255)   DEFAULT NULL,
    "intRate" decimal(16,5)   DEFAULT NULL,
    "maturityOpt" smallint  DEFAULT NULL check ("maturityOpt" >= 0),
    "notice" varchar(255)   DEFAULT NULL,
    "penMatrix" varchar(255)   DEFAULT NULL,
    "rateSchedMatrix" varchar(255)   DEFAULT NULL,
    "rollCrGrace" varchar(255)   DEFAULT NULL,
    "rollDrGraceAdj" smallint  DEFAULT NULL check ("rollDrGraceAdj" >= 0),
    "rollGracePd" varchar(255)   DEFAULT NULL,
    "rollGraceRate" varchar(255)   DEFAULT NULL,
    "rollProd" varchar(255)   DEFAULT NULL,
    "term" varchar(255)   DEFAULT NULL,
    "version" integer  NOT NULL  check ("version" >= 0),
    
    PRIMARY KEY ("componentName", "version")
); 
COMMENT ON COLUMN "componentTd"."componentName" IS 'Term component name';
COMMENT ON COLUMN "componentTd"."crTermExt" IS 'Extension to the maturity date when credits are made outside the rollover credit grace period';
COMMENT ON COLUMN "componentTd"."earlyDrPen" IS 'Method used to calculate an early withdrawal penalty';
COMMENT ON COLUMN "componentTd"."intMatrix" IS 'Matrix used to determine interest rate';
COMMENT ON COLUMN "componentTd"."intRate" IS 'Fixed interest rate';
COMMENT ON COLUMN "componentTd"."maturityOpt" IS 'Maturity option';
COMMENT ON COLUMN "componentTd"."notice" IS 'Notification period prior to maturity';
COMMENT ON COLUMN "componentTd"."penMatrix" IS 'Provides values used in early withdrawal penalty calculation';
COMMENT ON COLUMN "componentTd"."rateSchedMatrix" IS 'Matrix used to determine term';
COMMENT ON COLUMN "componentTd"."rollCrGrace" IS 'Period after rollover where deposits can be made without extending the term';
COMMENT ON COLUMN "componentTd"."rollDrGraceAdj" IS 'Adjustment to accrued interest on funds withdrawn during grace period';
COMMENT ON COLUMN "componentTd"."rollGracePd" IS 'Period after rollover when withdrawals can be made without penalty';
COMMENT ON COLUMN "componentTd"."rollGraceRate" IS 'Matrix used to determine accrual adjustment rate for withdrawals during debit grace period';
COMMENT ON COLUMN "componentTd"."rollProd" IS 'Product the term deposit rolling over rolls into';
COMMENT ON COLUMN "componentTd"."term" IS 'Term assigned to position';
COMMENT ON COLUMN "componentTd"."version" IS 'Term component version';


-- Creating Table configPosnEvents
DROP TABLE IF EXISTS "configPosnEvents";
CREATE TABLE "configPosnEvents" (
    "acctGroup" integer  NOT NULL  check ("acctGroup" >= 0),
    "eventType" varchar(40)   NOT NULL ,
    "function" varchar(60)   DEFAULT NULL,
    "trigger" jsonb  DEFAULT NULL,
    
    PRIMARY KEY ("acctGroup", "eventType")
); 
COMMENT ON COLUMN "configPosnEvents"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "configPosnEvents"."eventType" IS 'Unique event type';
COMMENT ON COLUMN "configPosnEvents"."function" IS 'The event handler function name';
COMMENT ON COLUMN "configPosnEvents"."trigger" IS 'Property that is watched by unhandled registered events';


-- Creating Table configSystemAcct
DROP TABLE IF EXISTS "configSystemAcct";
CREATE TABLE "configSystemAcct" (
    "acctGroup" integer  DEFAULT NULL check ("acctGroup" >= 0),
    "acctName" varchar(20)   NOT NULL ,
    "acctNbr" varchar(20)   DEFAULT NULL,
    "desc" varchar(80)   DEFAULT NULL,
    "posnRef" varchar(30)   DEFAULT NULL,
    
    PRIMARY KEY ("acctName")
); 
COMMENT ON COLUMN "configSystemAcct"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "configSystemAcct"."acctName" IS 'The name of the system account';
COMMENT ON COLUMN "configSystemAcct"."acctNbr" IS 'The unique account identifier within an acctGroup';
COMMENT ON COLUMN "configSystemAcct"."desc" IS 'Description of the system account';
COMMENT ON COLUMN "configSystemAcct"."posnRef" IS 'The unique position identifier within an acctGroup';


-- Creating Table counterparty
DROP TABLE IF EXISTS "counterparty";
CREATE TABLE "counterparty" (
    "_Id" varchar(42)  NOT NULL ,
    "acctBranch" varchar(20)   DEFAULT NULL,
    "acctGroup" integer  DEFAULT NULL check ("acctGroup" >= 0),
    "acctNbr" varchar(20)   DEFAULT NULL,
    "acctTitle" varchar(80)   DEFAULT NULL,
    "custId" varchar(20)   DEFAULT NULL,
    "ifxAcctType" varchar(255)   DEFAULT NULL,
    "reference" varchar(40)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "counterparty"."_Id" IS 'Bank Identifier';
COMMENT ON COLUMN "counterparty"."acctBranch" IS 'Counter party account branch in finInst';
COMMENT ON COLUMN "counterparty"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "counterparty"."acctNbr" IS 'The unique account identifier within a type';
COMMENT ON COLUMN "counterparty"."acctTitle" IS 'Counter party account title in finInst';
COMMENT ON COLUMN "counterparty"."custId" IS 'Counter party Id in finInst';
COMMENT ON COLUMN "counterparty"."ifxAcctType" IS 'Assigns account to a generally recognized industry standard category';
COMMENT ON COLUMN "counterparty"."reference" IS 'Counter party transaction reference';


-- Creating Table device
DROP TABLE IF EXISTS "device";
CREATE TABLE "device" (
    "_Id" varchar(42)  NOT NULL ,
    "bootOs" varchar(40)   DEFAULT NULL,
    "description" varchar(255)   DEFAULT NULL,
    "devHash" varchar(255)   DEFAULT NULL,
    "devType" bigint  DEFAULT NULL,
    "didType" varchar(20)   DEFAULT NULL,
    "didVal" varchar(255)   DEFAULT NULL,
    "ip" varchar(255)   DEFAULT NULL,
    "isMobile" boolean  DEFAULT NULL,
    "ispIp" varchar(255)   DEFAULT NULL,
    "make" varchar(60)   DEFAULT NULL,
    "model" varchar(60)   DEFAULT NULL,
    "network" varchar(60)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "device"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "device"."bootOs" IS 'The boot operating system and version running on the device';
COMMENT ON COLUMN "device"."description" IS 'Device description';
COMMENT ON COLUMN "device"."devHash" IS 'The device concatenated configuration hash';
COMMENT ON COLUMN "device"."devType" IS 'Device type';
COMMENT ON COLUMN "device"."didType" IS 'The device identifier type, e.g., UDID';
COMMENT ON COLUMN "device"."didVal" IS 'The electronic device identifier value';
COMMENT ON COLUMN "device"."ip" IS 'The registered or last home Ip of the device';
COMMENT ON COLUMN "device"."isMobile" IS 'The device is mobile versus fixed';
COMMENT ON COLUMN "device"."ispIp" IS 'The IP address of the ISP the device is using as a proxy server';
COMMENT ON COLUMN "device"."make" IS 'Device manufacturer';
COMMENT ON COLUMN "device"."model" IS 'Device model';
COMMENT ON COLUMN "device"."network" IS 'Network carrier';


-- Creating Table domain
DROP TABLE IF EXISTS "domain";
CREATE TABLE "domain" (
    "_Id" varchar(42)  NOT NULL ,
    "createDtm" timestamptz  DEFAULT NULL,
    "desc" varchar(255)   DEFAULT NULL,
    "expDtm" timestamptz  DEFAULT NULL,
    "isMultiRole" boolean  DEFAULT NULL,
    "loginUrl" varchar(255)   DEFAULT NULL,
    "name" varchar(60)   DEFAULT NULL,
    "startDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "domain"."_Id" IS 'Domain unique identifier';
COMMENT ON COLUMN "domain"."createDtm" IS 'Domain created on date';
COMMENT ON COLUMN "domain"."desc" IS 'Domain description';
COMMENT ON COLUMN "domain"."expDtm" IS 'Domain expires on date';
COMMENT ON COLUMN "domain"."isMultiRole" IS 'A user can have multiple roles in this domain';
COMMENT ON COLUMN "domain"."loginUrl" IS 'URL of login page';
COMMENT ON COLUMN "domain"."name" IS 'Domain unique name';
COMMENT ON COLUMN "domain"."startDtm" IS 'Domain valid from date';


-- Creating Table effectDateHist
DROP TABLE IF EXISTS "effectDateHist";
CREATE TABLE "effectDateHist" (
    "effectDtm" timestamptz  NOT NULL ,
    "posnBal" decimal(16,2)   NOT NULL ,
    "posnId" varchar(42)  NOT NULL ,
    
    PRIMARY KEY ("posnId", "effectDtm")
); 
COMMENT ON COLUMN "effectDateHist"."effectDtm" IS 'Effective date time of the transaction';
COMMENT ON COLUMN "effectDateHist"."posnBal" IS 'Balance after the transaction as of the effective-date';
COMMENT ON COLUMN "effectDateHist"."posnId" IS 'Unique position identifier';


-- Creating Table eventCtxt
DROP TABLE IF EXISTS "eventCtxt";
CREATE TABLE "eventCtxt" (
    "bpId" varchar(42)  DEFAULT NULL,
    "createDtm" timestamptz  DEFAULT NULL,
    "eventId" varchar(42)  NOT NULL ,
    "eventType" varchar(20)   DEFAULT NULL,
    "hasErr" boolean  DEFAULT NULL,
    "hostOrigin" text   DEFAULT NULL,
    "msgDirection" smallint  NOT NULL  check ("msgDirection" >= 0),
    "name" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("eventId", "msgDirection")
); 
COMMENT ON COLUMN "eventCtxt"."bpId" IS 'Identifier of the process that created the message';
COMMENT ON COLUMN "eventCtxt"."createDtm" IS 'The event was created on';
COMMENT ON COLUMN "eventCtxt"."eventId" IS 'Event Message correlation id';
COMMENT ON COLUMN "eventCtxt"."eventType" IS 'The event type';
COMMENT ON COLUMN "eventCtxt"."hasErr" IS 'boolean flag indicates if event failed';
COMMENT ON COLUMN "eventCtxt"."hostOrigin" IS 'Host name of event origin';
COMMENT ON COLUMN "eventCtxt"."msgDirection" IS 'Describes if the message is outbound 1, or inbound 2';
COMMENT ON COLUMN "eventCtxt"."name" IS 'The event name';


-- Creating Table eventCtxtErrInfo
DROP TABLE IF EXISTS "eventCtxtErrInfo";
CREATE TABLE "eventCtxtErrInfo" (
    "errors" jsonb  DEFAULT NULL,
    "eventId" varchar(42)  NOT NULL ,
    "msgDirection" smallint  NOT NULL  check ("msgDirection" >= 0),
    "retryCnt" int  DEFAULT NULL,
    
    PRIMARY KEY ("eventId", "msgDirection")
); 
COMMENT ON COLUMN "eventCtxtErrInfo"."errors" IS '';
COMMENT ON COLUMN "eventCtxtErrInfo"."eventId" IS 'Event Message correlation id';
COMMENT ON COLUMN "eventCtxtErrInfo"."msgDirection" IS 'Describes if the message is outbound 1, or inbound 2';
COMMENT ON COLUMN "eventCtxtErrInfo"."retryCnt" IS 'number of times the message was delivered';


-- Creating Table except
DROP TABLE IF EXISTS "except";
CREATE TABLE "except" (
    "_Id" varchar(42)  NOT NULL ,
    "desc" varchar(80)   DEFAULT NULL,
    "exceptDtm" timestamptz  DEFAULT NULL,
    "exceptName" varchar(255)   DEFAULT NULL,
    "notes" text  DEFAULT NULL,
    "procName" varchar(40)   DEFAULT NULL,
    "trnEntrySeq" int  DEFAULT NULL check ("trnEntrySeq" >= 0),
    "trnId" varchar(42)  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "except"."_Id" IS 'Unique Identifier for this exception reference';
COMMENT ON COLUMN "except"."desc" IS 'Exception description';
COMMENT ON COLUMN "except"."exceptDtm" IS 'The date and time that the exception occurred';
COMMENT ON COLUMN "except"."exceptName" IS 'A short name of the exception being logged';
COMMENT ON COLUMN "except"."notes" IS 'Exception notes containing additional detail';
COMMENT ON COLUMN "except"."procName" IS 'The name of the process that generated the exception';
COMMENT ON COLUMN "except"."trnEntrySeq" IS 'Transaction entry sequence';
COMMENT ON COLUMN "except"."trnId" IS 'Transaction identifier';


-- Creating Table exceptKeyValues
DROP TABLE IF EXISTS "exceptKeyValues";
CREATE TABLE "exceptKeyValues" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "key" varchar(30)   DEFAULT NULL,
    "val" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "exceptKeyValues"."_Id" IS 'Unique Identifier for this exception reference';
COMMENT ON COLUMN "exceptKeyValues"."_Ix" IS '_Ix for Field keyValues';
COMMENT ON COLUMN "exceptKeyValues"."key" IS 'Key describing the data for this pairing';
COMMENT ON COLUMN "exceptKeyValues"."val" IS 'Value associated with key';


-- Creating Table exceptRules
DROP TABLE IF EXISTS "exceptRules";
CREATE TABLE "exceptRules" (
    "code" varchar(40)   NOT NULL ,
    "operExcl" jsonb  DEFAULT NULL,
    "operIncl" jsonb  DEFAULT NULL,
    "operRoleExcl" jsonb  DEFAULT NULL,
    "operRoleIncl" jsonb  DEFAULT NULL,
    "prodBkIncl" jsonb  DEFAULT NULL,
    "prodGroupIncl" jsonb  DEFAULT NULL,
    "prodSubTypeIncl" jsonb  DEFAULT NULL,
    "prodTypeIncl" jsonb  DEFAULT NULL,
    "trnCodeExcl" jsonb  DEFAULT NULL,
    "trnCodeIncl" jsonb  DEFAULT NULL,
    "trnRoleExcl" jsonb  DEFAULT NULL,
    "trnRoleIncl" jsonb  DEFAULT NULL,
    
    PRIMARY KEY ("code")
); 
COMMENT ON COLUMN "exceptRules"."code" IS 'Name of a defined set of rules for recognizing and handling exceptions';
COMMENT ON COLUMN "exceptRules"."operExcl" IS 'Operation name';
COMMENT ON COLUMN "exceptRules"."operIncl" IS 'Operation name';
COMMENT ON COLUMN "exceptRules"."operRoleExcl" IS 'User role';
COMMENT ON COLUMN "exceptRules"."operRoleIncl" IS 'User role';
COMMENT ON COLUMN "exceptRules"."prodBkIncl" IS 'Name of applicable products';
COMMENT ON COLUMN "exceptRules"."prodGroupIncl" IS 'Name of applicable product group';
COMMENT ON COLUMN "exceptRules"."prodSubTypeIncl" IS 'Name of applicable product sub-type';
COMMENT ON COLUMN "exceptRules"."prodTypeIncl" IS 'Name of applicable product type';
COMMENT ON COLUMN "exceptRules"."trnCodeExcl" IS 'Transaction code';
COMMENT ON COLUMN "exceptRules"."trnCodeIncl" IS 'Transaction code';
COMMENT ON COLUMN "exceptRules"."trnRoleExcl" IS 'User role';
COMMENT ON COLUMN "exceptRules"."trnRoleIncl" IS 'User role';


-- Creating Table feeCalcDtl
DROP TABLE IF EXISTS "feeCalcDtl";
CREATE TABLE "feeCalcDtl" (
    "_Id" varchar(42)  NOT NULL ,
    "assessAt" smallint  DEFAULT 1 check ("assessAt" >= 0),
    "desc" varchar(255)   DEFAULT NULL,
    "feeAmt" decimal(16,2)   DEFAULT NULL,
    "feeMatrix" varchar(30)   DEFAULT NULL,
    "feeMaxAmt" decimal(16,2)   DEFAULT NULL,
    "feeMinAmt" decimal(16,2)   DEFAULT NULL,
    "feePct" decimal(16,5)   DEFAULT NULL,
    "name" varchar(20)   DEFAULT NULL,
    "nsfFeeBal" smallint  DEFAULT 1 check ("nsfFeeBal" >= 0),
    "trnCode" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "feeCalcDtl"."_Id" IS 'Unique fee calculation identifier';
COMMENT ON COLUMN "feeCalcDtl"."assessAt" IS 'Defines when fee is assessed';
COMMENT ON COLUMN "feeCalcDtl"."desc" IS 'Fee description';
COMMENT ON COLUMN "feeCalcDtl"."feeAmt" IS 'The fixed fee amount to assess to position';
COMMENT ON COLUMN "feeCalcDtl"."feeMatrix" IS 'Matrix used to determine the fee';
COMMENT ON COLUMN "feeCalcDtl"."feeMaxAmt" IS 'The maximum fee to charge to position per transaction';
COMMENT ON COLUMN "feeCalcDtl"."feeMinAmt" IS 'The minimum fee to charge to position, per transaction';
COMMENT ON COLUMN "feeCalcDtl"."feePct" IS 'Percentage applied to amount to calculate fee';
COMMENT ON COLUMN "feeCalcDtl"."name" IS 'Fee name';
COMMENT ON COLUMN "feeCalcDtl"."nsfFeeBal" IS 'Fee handling when position ledger balance is less than fee amount';
COMMENT ON COLUMN "feeCalcDtl"."trnCode" IS 'Transaction code used to post the fee';


-- Creating Table feeCalcDtlFeeLimits
DROP TABLE IF EXISTS "feeCalcDtlFeeLimits";
CREATE TABLE "feeCalcDtlFeeLimits" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "feeMaxAmt" decimal(16,2)   DEFAULT NULL,
    "feeMaxCnt" smallint  DEFAULT NULL check ("feeMaxCnt" >= 0),
    "freq" varchar(255)   DEFAULT NULL,
    "startDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "feeCalcDtlFeeLimits"."_Id" IS 'Unique fee calculation identifier';
COMMENT ON COLUMN "feeCalcDtlFeeLimits"."_Ix" IS '_Ix for Field feeLimits';
COMMENT ON COLUMN "feeCalcDtlFeeLimits"."feeMaxAmt" IS 'Maximum total fee amount that may be assessed for the period';
COMMENT ON COLUMN "feeCalcDtlFeeLimits"."feeMaxCnt" IS 'Maximum total count of fees that may be assessed for period';
COMMENT ON COLUMN "feeCalcDtlFeeLimits"."freq" IS 'Defines the period used to determine whether or not fees exceed maximum allowable';
COMMENT ON COLUMN "feeCalcDtlFeeLimits"."startDtm" IS 'Start date used to calculate current period';


-- Creating Table folder
DROP TABLE IF EXISTS "folder";
CREATE TABLE "folder" (
    "_Id" varchar(42)  NOT NULL ,
    "desc" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "folder"."_Id" IS 'Unique folder identifier';
COMMENT ON COLUMN "folder"."desc" IS 'Folder description';


-- Creating Table folderAttachments
DROP TABLE IF EXISTS "folderAttachments";
CREATE TABLE "folderAttachments" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "createDtm" timestamptz  DEFAULT NULL,
    "desc" varchar(255)   DEFAULT NULL,
    "itemType" smallint  DEFAULT NULL check ("itemType" >= 0),
    "name" varchar(30)   DEFAULT NULL,
    "uri" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "folderAttachments"."_Id" IS 'Unique folder identifier';
COMMENT ON COLUMN "folderAttachments"."_Ix" IS '_Ix for Field attachments';
COMMENT ON COLUMN "folderAttachments"."createDtm" IS 'The date the attachment was created';
COMMENT ON COLUMN "folderAttachments"."desc" IS 'The description of the attached item';
COMMENT ON COLUMN "folderAttachments"."itemType" IS 'The type of the attached item';
COMMENT ON COLUMN "folderAttachments"."name" IS 'The name of the attached item';
COMMENT ON COLUMN "folderAttachments"."uri" IS 'The URI for the attached item';


-- Creating Table folderAttachmentsCreateBy
DROP TABLE IF EXISTS "folderAttachmentsCreateBy";
CREATE TABLE "folderAttachmentsCreateBy" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "cntry" varchar(2)   DEFAULT NULL,
    "contactPref" smallint  DEFAULT NULL check ("contactPref" >= 0),
    "folderId" varchar(42)  DEFAULT NULL,
    "name" varchar(80)   NOT NULL ,
    "preferAddrId" varchar(42)  DEFAULT NULL,
    "preferEmailId" smallint  DEFAULT NULL check ("preferEmailId" >= 0),
    "preferPhoneId" smallint  DEFAULT NULL check ("preferPhoneId" >= 0),
    "taxid" varchar(11)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "folderAttachmentsCreateBy"."_Id" IS 'Unique folder identifier';
COMMENT ON COLUMN "folderAttachmentsCreateBy"."_Ix" IS '_Ix for Field attachments';
COMMENT ON COLUMN "folderAttachmentsCreateBy"."cntry" IS 'Country of residence or registration ISO 3166-2';
COMMENT ON COLUMN "folderAttachmentsCreateBy"."contactPref" IS 'The method of contact preference';
COMMENT ON COLUMN "folderAttachmentsCreateBy"."folderId" IS 'Partys documents and attachments root folder Id';
COMMENT ON COLUMN "folderAttachmentsCreateBy"."name" IS 'Formatted full name of party';
COMMENT ON COLUMN "folderAttachmentsCreateBy"."preferAddrId" IS 'Preferred address identifier';
COMMENT ON COLUMN "folderAttachmentsCreateBy"."preferEmailId" IS 'Preferred email identifier';
COMMENT ON COLUMN "folderAttachmentsCreateBy"."preferPhoneId" IS 'Preferred phone number identifier';
COMMENT ON COLUMN "folderAttachmentsCreateBy"."taxid" IS 'US taxid or social security number';


-- Creating Table folderAttachmentsCreateByAddrs
DROP TABLE IF EXISTS "folderAttachmentsCreateByAddrs";
CREATE TABLE "folderAttachmentsCreateByAddrs" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "_Ix1" int  NOT NULL  check ("_Ix1" >= 0),
    "addrId" varchar(42)  NOT NULL ,
    "addrType" smallint  NOT NULL  check ("addrType" >= 0),
    "label" varchar(30)   DEFAULT NULL,
    "priority" smallint  DEFAULT NULL check ("priority" >= 0),
    "validFromDtm" timestamptz  DEFAULT NULL,
    "validToDtm" timestamptz  DEFAULT NULL,
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix", "_Ix1")
); 
COMMENT ON COLUMN "folderAttachmentsCreateByAddrs"."_Id" IS 'Unique folder identifier';
COMMENT ON COLUMN "folderAttachmentsCreateByAddrs"."_Ix" IS '_Ix for Field attachments';
COMMENT ON COLUMN "folderAttachmentsCreateByAddrs"."_Ix1" IS '_Ix for Field addrs';
COMMENT ON COLUMN "folderAttachmentsCreateByAddrs"."addrId" IS 'The address Id';
COMMENT ON COLUMN "folderAttachmentsCreateByAddrs"."addrType" IS 'The type of address';
COMMENT ON COLUMN "folderAttachmentsCreateByAddrs"."label" IS 'The label of this address';
COMMENT ON COLUMN "folderAttachmentsCreateByAddrs"."priority" IS 'Listing sort priority';
COMMENT ON COLUMN "folderAttachmentsCreateByAddrs"."validFromDtm" IS 'Address is valid from date';
COMMENT ON COLUMN "folderAttachmentsCreateByAddrs"."validToDtm" IS 'Address is valid to date';
COMMENT ON COLUMN "folderAttachmentsCreateByAddrs"."verifyDtm" IS 'Date address was last verified';


-- Creating Table folderAttachmentsCreateByEmails
DROP TABLE IF EXISTS "folderAttachmentsCreateByEmails";
CREATE TABLE "folderAttachmentsCreateByEmails" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "_Ix1" int  NOT NULL  check ("_Ix1" >= 0),
    "data" varchar(255)   NOT NULL ,
    "emailType" smallint  NOT NULL  check ("emailType" >= 0),
    "label" varchar(30)   DEFAULT NULL,
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix", "_Ix1")
); 
COMMENT ON COLUMN "folderAttachmentsCreateByEmails"."_Id" IS 'Unique folder identifier';
COMMENT ON COLUMN "folderAttachmentsCreateByEmails"."_Ix" IS '_Ix for Field attachments';
COMMENT ON COLUMN "folderAttachmentsCreateByEmails"."_Ix1" IS '_Ix for Field emails';
COMMENT ON COLUMN "folderAttachmentsCreateByEmails"."data" IS 'The email address';
COMMENT ON COLUMN "folderAttachmentsCreateByEmails"."emailType" IS 'Email type';
COMMENT ON COLUMN "folderAttachmentsCreateByEmails"."label" IS 'Label';
COMMENT ON COLUMN "folderAttachmentsCreateByEmails"."verifyDtm" IS 'Date email was last verified';


-- Creating Table folderAttachmentsCreateByPhones
DROP TABLE IF EXISTS "folderAttachmentsCreateByPhones";
CREATE TABLE "folderAttachmentsCreateByPhones" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "_Ix1" int  NOT NULL  check ("_Ix1" >= 0),
    "data" varchar(20)   NOT NULL ,
    "label" varchar(30)   DEFAULT NULL,
    "phoneType" smallint  NOT NULL  check ("phoneType" >= 0),
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix", "_Ix1")
); 
COMMENT ON COLUMN "folderAttachmentsCreateByPhones"."_Id" IS 'Unique folder identifier';
COMMENT ON COLUMN "folderAttachmentsCreateByPhones"."_Ix" IS '_Ix for Field attachments';
COMMENT ON COLUMN "folderAttachmentsCreateByPhones"."_Ix1" IS '_Ix for Field phones';
COMMENT ON COLUMN "folderAttachmentsCreateByPhones"."data" IS 'Phone number';
COMMENT ON COLUMN "folderAttachmentsCreateByPhones"."label" IS 'Label';
COMMENT ON COLUMN "folderAttachmentsCreateByPhones"."phoneType" IS 'Phone type';
COMMENT ON COLUMN "folderAttachmentsCreateByPhones"."verifyDtm" IS 'Date phone was last verified';


-- Creating Table glAccrLog
DROP TABLE IF EXISTS "glAccrLog";
CREATE TABLE "glAccrLog" (
    "glAccrToDtm" timestamptz  DEFAULT NULL,
    "glSetCode" varchar(20)   NOT NULL ,
    
    PRIMARY KEY ("glSetCode")
); 
COMMENT ON COLUMN "glAccrLog"."glAccrToDtm" IS 'The date and time of the last GL accrual end date';
COMMENT ON COLUMN "glAccrLog"."glSetCode" IS 'GL account numbers set code';


-- Creating Table glAccumLog
DROP TABLE IF EXISTS "glAccumLog";
CREATE TABLE "glAccumLog" (
    "_Id" varchar(42)  NOT NULL ,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "glAccumLog"."_Id" IS 'Unique Transaction identifier';


-- Creating Table glSet
DROP TABLE IF EXISTS "glSet";
CREATE TABLE "glSet" (
    "accrFeeAcct" varchar(20)   DEFAULT NULL,
    "accrIntAcct" varchar(20)   DEFAULT NULL,
    "acctGroup" integer  DEFAULT NULL check ("acctGroup" >= 0),
    "avlIntAcct" varchar(20)   DEFAULT NULL,
    "desc" varchar(255)   DEFAULT NULL,
    "feeIncAcct" varchar(20)   DEFAULT NULL,
    "glSetCode" varchar(20)   NOT NULL ,
    "intExpAcct" varchar(20)   DEFAULT NULL,
    "ledgerAcct" varchar(20)   DEFAULT NULL,
    "negIntAcct" varchar(20)   DEFAULT NULL,
    "penIncAcct" varchar(20)   DEFAULT NULL,
    "wthFedAcct" varchar(20)   DEFAULT NULL,
    "wthStateAcct" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("glSetCode")
); 
COMMENT ON COLUMN "glSet"."accrFeeAcct" IS 'The account number used for accrued fees balance';
COMMENT ON COLUMN "glSet"."accrIntAcct" IS 'The account number used for the accrued interest balance';
COMMENT ON COLUMN "glSet"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "glSet"."avlIntAcct" IS 'The account number used for the available interest balance';
COMMENT ON COLUMN "glSet"."desc" IS 'Account type description';
COMMENT ON COLUMN "glSet"."feeIncAcct" IS 'General ledger acount number for fees and services income';
COMMENT ON COLUMN "glSet"."glSetCode" IS 'GL account numbers set code';
COMMENT ON COLUMN "glSet"."intExpAcct" IS 'The account number used for the interest expense balance';
COMMENT ON COLUMN "glSet"."ledgerAcct" IS 'The account number used for the ledger or principal balance';
COMMENT ON COLUMN "glSet"."negIntAcct" IS 'The account number used for negative interest accrued balance';
COMMENT ON COLUMN "glSet"."penIncAcct" IS 'General ledger account number for penalty income';
COMMENT ON COLUMN "glSet"."wthFedAcct" IS 'The account number used for federal withholding balance';
COMMENT ON COLUMN "glSet"."wthStateAcct" IS 'The account number used for state withholding balance';


-- Creating Table hold
DROP TABLE IF EXISTS "hold";
CREATE TABLE "hold" (
    "_Id" varchar(42)  NOT NULL ,
    "acctGroup" integer  DEFAULT NULL check ("acctGroup" >= 0),
    "authRef" varchar(30)   DEFAULT NULL,
    "cancelDtm" timestamptz  DEFAULT NULL,
    "dur" varchar(255)   DEFAULT NULL,
    "endDtm" timestamptz  DEFAULT NULL,
    "holdAmt" decimal(16,2)   DEFAULT NULL,
    "holdType" smallint  DEFAULT NULL check ("holdType" >= 0),
    "interval" varchar(255)   DEFAULT NULL,
    "note" text  DEFAULT NULL,
    "posnId" varchar(42)  DEFAULT NULL,
    "posnRef" varchar(30)   DEFAULT NULL,
    "reason" varchar(10)   DEFAULT NULL,
    "slices" jsonb  DEFAULT NULL,
    "startDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "hold"."_Id" IS 'Unique hold identifier';
COMMENT ON COLUMN "hold"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "hold"."authRef" IS 'External reference for authorization hold';
COMMENT ON COLUMN "hold"."cancelDtm" IS 'Date and time hold was cancelled';
COMMENT ON COLUMN "hold"."dur" IS 'Duration of the hold determines endDt';
COMMENT ON COLUMN "hold"."endDtm" IS 'Date and time hold will expire, default 10/15/2114-23:59';
COMMENT ON COLUMN "hold"."holdAmt" IS 'Amount to hold, default to entry.tranAmt';
COMMENT ON COLUMN "hold"."holdType" IS 'The hold type code';
COMMENT ON COLUMN "hold"."interval" IS 'Duration of a slice interval if slices (e.g., (1D)';
COMMENT ON COLUMN "hold"."note" IS 'Free form accompanying note';
COMMENT ON COLUMN "hold"."posnId" IS 'Unique position identifier';
COMMENT ON COLUMN "hold"."posnRef" IS 'The unique position identifier within an acctGroup';
COMMENT ON COLUMN "hold"."reason" IS 'The reason code for why hold was placed';
COMMENT ON COLUMN "hold"."slices" IS 'Slice amount';
COMMENT ON COLUMN "hold"."startDtm" IS 'Date and time hold will start, default immediately';


-- Creating Table logRequest
DROP TABLE IF EXISTS "logRequest";
CREATE TABLE "logRequest" (
    "_Id" varchar(42)  NOT NULL ,
    "body" text  DEFAULT NULL,
    "ipAddr" varchar(20)   DEFAULT NULL,
    "logDtm" timestamptz  DEFAULT NULL,
    "mthd" varchar(20)   DEFAULT NULL,
    "url" varchar(255)   DEFAULT NULL,
    "userId" varchar(30)   DEFAULT NULL,
    "userRoles" jsonb  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logRequest"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logRequest"."body" IS 'Message body';
COMMENT ON COLUMN "logRequest"."ipAddr" IS 'IP address where the request originated';
COMMENT ON COLUMN "logRequest"."logDtm" IS 'The date and time of the log entry';
COMMENT ON COLUMN "logRequest"."mthd" IS 'The HTTP verb i.e. put, post, etc';
COMMENT ON COLUMN "logRequest"."url" IS 'The URL that was called by the user';
COMMENT ON COLUMN "logRequest"."userId" IS 'User identifier on the user that generated the message';
COMMENT ON COLUMN "logRequest"."userRoles" IS 'Role value';


-- Creating Table logRequestHdr
DROP TABLE IF EXISTS "logRequestHdr";
CREATE TABLE "logRequestHdr" (
    "_Id" varchar(42)  NOT NULL ,
    "cookie" varchar(255)   DEFAULT NULL,
    "format" varchar(255)   DEFAULT NULL,
    "http" text  DEFAULT NULL,
    "isRetry" boolean  DEFAULT NULL,
    "language" varchar(255)   DEFAULT NULL,
    "timestamp" bigint  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logRequestHdr"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logRequestHdr"."cookie" IS 'The client cookie';
COMMENT ON COLUMN "logRequestHdr"."format" IS 'The format and version of the message, used to map to code tables and additional properties, also for legacy compatibility';
COMMENT ON COLUMN "logRequestHdr"."http" IS 'HTTP Header information pass through';
COMMENT ON COLUMN "logRequestHdr"."isRetry" IS 'Message is a retry request';
COMMENT ON COLUMN "logRequestHdr"."language" IS 'The IETF Client language tag';
COMMENT ON COLUMN "logRequestHdr"."timestamp" IS 'Request originated on local timestamp';


-- Creating Table logRequestHdrAgent
DROP TABLE IF EXISTS "logRequestHdrAgent";
CREATE TABLE "logRequestHdrAgent" (
    "_Id" varchar(42)  NOT NULL ,
    "app" varchar(255)   DEFAULT NULL,
    "browser" varchar(255)   DEFAULT NULL,
    "osType" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logRequestHdrAgent"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logRequestHdrAgent"."app" IS 'The client application name and version';
COMMENT ON COLUMN "logRequestHdrAgent"."browser" IS 'The client browser and version';
COMMENT ON COLUMN "logRequestHdrAgent"."osType" IS 'The client operating system and version';


-- Creating Table logRequestHdrDevice
DROP TABLE IF EXISTS "logRequestHdrDevice";
CREATE TABLE "logRequestHdrDevice" (
    "_Id" varchar(42)  NOT NULL ,
    "bootOs" varchar(40)   DEFAULT NULL,
    "description" varchar(255)   DEFAULT NULL,
    "devHash" varchar(255)   DEFAULT NULL,
    "devType" bigint  DEFAULT NULL,
    "didType" varchar(20)   DEFAULT NULL,
    "didVal" varchar(255)   DEFAULT NULL,
    "ip" varchar(255)   DEFAULT NULL,
    "isMobile" boolean  DEFAULT NULL,
    "ispIp" varchar(255)   DEFAULT NULL,
    "make" varchar(60)   DEFAULT NULL,
    "model" varchar(60)   DEFAULT NULL,
    "network" varchar(60)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logRequestHdrDevice"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logRequestHdrDevice"."bootOs" IS 'The boot operating system and version running on the device';
COMMENT ON COLUMN "logRequestHdrDevice"."description" IS 'Device description';
COMMENT ON COLUMN "logRequestHdrDevice"."devHash" IS 'The device concatenated configuration hash';
COMMENT ON COLUMN "logRequestHdrDevice"."devType" IS 'Device type';
COMMENT ON COLUMN "logRequestHdrDevice"."didType" IS 'The device identifier type, e.g., UDID';
COMMENT ON COLUMN "logRequestHdrDevice"."didVal" IS 'The electronic device identifier value';
COMMENT ON COLUMN "logRequestHdrDevice"."ip" IS 'The registered or last home Ip of the device';
COMMENT ON COLUMN "logRequestHdrDevice"."isMobile" IS 'The device is mobile versus fixed';
COMMENT ON COLUMN "logRequestHdrDevice"."ispIp" IS 'The IP address of the ISP the device is using as a proxy server';
COMMENT ON COLUMN "logRequestHdrDevice"."make" IS 'Device manufacturer';
COMMENT ON COLUMN "logRequestHdrDevice"."model" IS 'Device model';
COMMENT ON COLUMN "logRequestHdrDevice"."network" IS 'Network carrier';


-- Creating Table logRequestHdrIdentity
DROP TABLE IF EXISTS "logRequestHdrIdentity";
CREATE TABLE "logRequestHdrIdentity" (
    "_Id" varchar(42)  NOT NULL ,
    "isSession" boolean  DEFAULT NULL,
    "login" varchar(255)   DEFAULT NULL,
    "loginPwd" varchar(255)   DEFAULT NULL,
    "sessId" bigint  DEFAULT NULL,
    "sessPwd" varchar(255)   DEFAULT NULL,
    "tenantId" bigint  DEFAULT NULL,
    "token" varchar(255)   DEFAULT NULL,
    "tokenPwd" varchar(255)   DEFAULT NULL,
    "userId" varchar(255)   DEFAULT NULL,
    "userPwd" varchar(255)   DEFAULT NULL,
    "userRoles" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logRequestHdrIdentity"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logRequestHdrIdentity"."isSession" IS 'Flag to initiate persistent and return session Id';
COMMENT ON COLUMN "logRequestHdrIdentity"."login" IS 'The client login';
COMMENT ON COLUMN "logRequestHdrIdentity"."loginPwd" IS 'The user login password';
COMMENT ON COLUMN "logRequestHdrIdentity"."sessId" IS 'The persistent session identifier, if connected';
COMMENT ON COLUMN "logRequestHdrIdentity"."sessPwd" IS 'The password assigned by to this persistent session';
COMMENT ON COLUMN "logRequestHdrIdentity"."tenantId" IS 'The unique tenant identifier';
COMMENT ON COLUMN "logRequestHdrIdentity"."token" IS 'The peristent token to re-establish an authenticated user';
COMMENT ON COLUMN "logRequestHdrIdentity"."tokenPwd" IS 'The password assigned by the password authority to this token';
COMMENT ON COLUMN "logRequestHdrIdentity"."userId" IS 'The User Id in the server system';
COMMENT ON COLUMN "logRequestHdrIdentity"."userPwd" IS 'The user login password';
COMMENT ON COLUMN "logRequestHdrIdentity"."userRoles" IS 'A user role';


-- Creating Table logRequestHdrLocale
DROP TABLE IF EXISTS "logRequestHdrLocale";
CREATE TABLE "logRequestHdrLocale" (
    "_Id" varchar(42)  NOT NULL ,
    "city" varchar(40)   DEFAULT NULL,
    "cntry" varchar(2)   DEFAULT NULL,
    "geoLoc" jsonb  DEFAULT NULL,
    "postCode" varchar(9)   DEFAULT NULL,
    "premise" varchar(30)   DEFAULT NULL,
    "region" varchar(2)   DEFAULT NULL,
    "street" text  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logRequestHdrLocale"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logRequestHdrLocale"."city" IS 'Address city';
COMMENT ON COLUMN "logRequestHdrLocale"."cntry" IS 'Address country';
COMMENT ON COLUMN "logRequestHdrLocale"."geoLoc" IS 'Fixed geographic location of address';
COMMENT ON COLUMN "logRequestHdrLocale"."postCode" IS 'The address postal code';
COMMENT ON COLUMN "logRequestHdrLocale"."premise" IS 'Name location or building name';
COMMENT ON COLUMN "logRequestHdrLocale"."region" IS 'State, Province, County or Land';
COMMENT ON COLUMN "logRequestHdrLocale"."street" IS 'Street number, PO box or RD and street name';


-- Creating Table logRequestHdrMsgLogs
DROP TABLE IF EXISTS "logRequestHdrMsgLogs";
CREATE TABLE "logRequestHdrMsgLogs" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "ref" varchar(255)   DEFAULT NULL,
    "resource" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "logRequestHdrMsgLogs"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logRequestHdrMsgLogs"."_Ix" IS '_Ix for Field msgLogs';
COMMENT ON COLUMN "logRequestHdrMsgLogs"."ref" IS 'Foreign log reference';
COMMENT ON COLUMN "logRequestHdrMsgLogs"."resource" IS 'Logging resource name';


-- Creating Table logRequestHdrWorkItem
DROP TABLE IF EXISTS "logRequestHdrWorkItem";
CREATE TABLE "logRequestHdrWorkItem" (
    "_Id" varchar(42)  NOT NULL ,
    "activity" varchar(20)   DEFAULT NULL,
    "appId" varchar(20)   DEFAULT NULL,
    "caseId" varchar(20)   DEFAULT NULL,
    "caseType" varchar(20)   DEFAULT NULL,
    "note" text  DEFAULT NULL,
    "openDtm" timestamptz  DEFAULT NULL,
    "status" varchar(20)   DEFAULT NULL,
    "step" varchar(20)   DEFAULT NULL,
    "task" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logRequestHdrWorkItem"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logRequestHdrWorkItem"."activity" IS 'The case activity';
COMMENT ON COLUMN "logRequestHdrWorkItem"."appId" IS 'The case application identifier';
COMMENT ON COLUMN "logRequestHdrWorkItem"."caseId" IS 'Unique case identifier within apppId';
COMMENT ON COLUMN "logRequestHdrWorkItem"."caseType" IS 'The case type';
COMMENT ON COLUMN "logRequestHdrWorkItem"."note" IS 'Free text case note';
COMMENT ON COLUMN "logRequestHdrWorkItem"."openDtm" IS 'When case was opened';
COMMENT ON COLUMN "logRequestHdrWorkItem"."status" IS 'The case status';
COMMENT ON COLUMN "logRequestHdrWorkItem"."step" IS 'The case step within task';
COMMENT ON COLUMN "logRequestHdrWorkItem"."task" IS 'The case task';


-- Creating Table logResponse
DROP TABLE IF EXISTS "logResponse";
CREATE TABLE "logResponse" (
    "_Id" varchar(42)  NOT NULL ,
    "body" text  DEFAULT NULL,
    "userId" varchar(30)   DEFAULT NULL,
    "userRoles" jsonb  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logResponse"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logResponse"."body" IS 'Message body';
COMMENT ON COLUMN "logResponse"."userId" IS 'User identifier on the user that generated the message';
COMMENT ON COLUMN "logResponse"."userRoles" IS 'Role value';


-- Creating Table logResponseHdr
DROP TABLE IF EXISTS "logResponseHdr";
CREATE TABLE "logResponseHdr" (
    "_Id" varchar(42)  NOT NULL ,
    "cookie" varchar(255)   DEFAULT NULL,
    "format" varchar(255)   DEFAULT NULL,
    "http" text  DEFAULT NULL,
    "isRetry" boolean  DEFAULT NULL,
    "language" varchar(255)   DEFAULT NULL,
    "timestamp" bigint  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logResponseHdr"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logResponseHdr"."cookie" IS 'The client cookie';
COMMENT ON COLUMN "logResponseHdr"."format" IS 'The format and version of the message, used to map to code tables and additional properties, also for legacy compatibility';
COMMENT ON COLUMN "logResponseHdr"."http" IS 'HTTP Header information pass through';
COMMENT ON COLUMN "logResponseHdr"."isRetry" IS 'Message is a retry request';
COMMENT ON COLUMN "logResponseHdr"."language" IS 'The IETF Client language tag';
COMMENT ON COLUMN "logResponseHdr"."timestamp" IS 'Request originated on local timestamp';


-- Creating Table logResponseHdrAgent
DROP TABLE IF EXISTS "logResponseHdrAgent";
CREATE TABLE "logResponseHdrAgent" (
    "_Id" varchar(42)  NOT NULL ,
    "app" varchar(255)   DEFAULT NULL,
    "browser" varchar(255)   DEFAULT NULL,
    "osType" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logResponseHdrAgent"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logResponseHdrAgent"."app" IS 'The client application name and version';
COMMENT ON COLUMN "logResponseHdrAgent"."browser" IS 'The client browser and version';
COMMENT ON COLUMN "logResponseHdrAgent"."osType" IS 'The client operating system and version';


-- Creating Table logResponseHdrDevice
DROP TABLE IF EXISTS "logResponseHdrDevice";
CREATE TABLE "logResponseHdrDevice" (
    "_Id" varchar(42)  NOT NULL ,
    "bootOs" varchar(40)   DEFAULT NULL,
    "description" varchar(255)   DEFAULT NULL,
    "devHash" varchar(255)   DEFAULT NULL,
    "devType" bigint  DEFAULT NULL,
    "didType" varchar(20)   DEFAULT NULL,
    "didVal" varchar(255)   DEFAULT NULL,
    "ip" varchar(255)   DEFAULT NULL,
    "isMobile" boolean  DEFAULT NULL,
    "ispIp" varchar(255)   DEFAULT NULL,
    "make" varchar(60)   DEFAULT NULL,
    "model" varchar(60)   DEFAULT NULL,
    "network" varchar(60)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logResponseHdrDevice"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logResponseHdrDevice"."bootOs" IS 'The boot operating system and version running on the device';
COMMENT ON COLUMN "logResponseHdrDevice"."description" IS 'Device description';
COMMENT ON COLUMN "logResponseHdrDevice"."devHash" IS 'The device concatenated configuration hash';
COMMENT ON COLUMN "logResponseHdrDevice"."devType" IS 'Device type';
COMMENT ON COLUMN "logResponseHdrDevice"."didType" IS 'The device identifier type, e.g., UDID';
COMMENT ON COLUMN "logResponseHdrDevice"."didVal" IS 'The electronic device identifier value';
COMMENT ON COLUMN "logResponseHdrDevice"."ip" IS 'The registered or last home Ip of the device';
COMMENT ON COLUMN "logResponseHdrDevice"."isMobile" IS 'The device is mobile versus fixed';
COMMENT ON COLUMN "logResponseHdrDevice"."ispIp" IS 'The IP address of the ISP the device is using as a proxy server';
COMMENT ON COLUMN "logResponseHdrDevice"."make" IS 'Device manufacturer';
COMMENT ON COLUMN "logResponseHdrDevice"."model" IS 'Device model';
COMMENT ON COLUMN "logResponseHdrDevice"."network" IS 'Network carrier';


-- Creating Table logResponseHdrIdentity
DROP TABLE IF EXISTS "logResponseHdrIdentity";
CREATE TABLE "logResponseHdrIdentity" (
    "_Id" varchar(42)  NOT NULL ,
    "isSession" boolean  DEFAULT NULL,
    "login" varchar(255)   DEFAULT NULL,
    "loginPwd" varchar(255)   DEFAULT NULL,
    "sessId" bigint  DEFAULT NULL,
    "sessPwd" varchar(255)   DEFAULT NULL,
    "tenantId" bigint  DEFAULT NULL,
    "token" varchar(255)   DEFAULT NULL,
    "tokenPwd" varchar(255)   DEFAULT NULL,
    "userId" varchar(255)   DEFAULT NULL,
    "userPwd" varchar(255)   DEFAULT NULL,
    "userRoles" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logResponseHdrIdentity"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logResponseHdrIdentity"."isSession" IS 'Flag to initiate persistent and return session Id';
COMMENT ON COLUMN "logResponseHdrIdentity"."login" IS 'The client login';
COMMENT ON COLUMN "logResponseHdrIdentity"."loginPwd" IS 'The user login password';
COMMENT ON COLUMN "logResponseHdrIdentity"."sessId" IS 'The persistent session identifier, if connected';
COMMENT ON COLUMN "logResponseHdrIdentity"."sessPwd" IS 'The password assigned by to this persistent session';
COMMENT ON COLUMN "logResponseHdrIdentity"."tenantId" IS 'The unique tenant identifier';
COMMENT ON COLUMN "logResponseHdrIdentity"."token" IS 'The peristent token to re-establish an authenticated user';
COMMENT ON COLUMN "logResponseHdrIdentity"."tokenPwd" IS 'The password assigned by the password authority to this token';
COMMENT ON COLUMN "logResponseHdrIdentity"."userId" IS 'The User Id in the server system';
COMMENT ON COLUMN "logResponseHdrIdentity"."userPwd" IS 'The user login password';
COMMENT ON COLUMN "logResponseHdrIdentity"."userRoles" IS 'A user role';


-- Creating Table logResponseHdrLocale
DROP TABLE IF EXISTS "logResponseHdrLocale";
CREATE TABLE "logResponseHdrLocale" (
    "_Id" varchar(42)  NOT NULL ,
    "city" varchar(40)   DEFAULT NULL,
    "cntry" varchar(2)   DEFAULT NULL,
    "geoLoc" jsonb  DEFAULT NULL,
    "postCode" varchar(9)   DEFAULT NULL,
    "premise" varchar(30)   DEFAULT NULL,
    "region" varchar(2)   DEFAULT NULL,
    "street" text  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logResponseHdrLocale"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logResponseHdrLocale"."city" IS 'Address city';
COMMENT ON COLUMN "logResponseHdrLocale"."cntry" IS 'Address country';
COMMENT ON COLUMN "logResponseHdrLocale"."geoLoc" IS 'Fixed geographic location of address';
COMMENT ON COLUMN "logResponseHdrLocale"."postCode" IS 'The address postal code';
COMMENT ON COLUMN "logResponseHdrLocale"."premise" IS 'Name location or building name';
COMMENT ON COLUMN "logResponseHdrLocale"."region" IS 'State, Province, County or Land';
COMMENT ON COLUMN "logResponseHdrLocale"."street" IS 'Street number, PO box or RD and street name';


-- Creating Table logResponseHdrMsgLogs
DROP TABLE IF EXISTS "logResponseHdrMsgLogs";
CREATE TABLE "logResponseHdrMsgLogs" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "ref" varchar(255)   DEFAULT NULL,
    "resource" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "logResponseHdrMsgLogs"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logResponseHdrMsgLogs"."_Ix" IS '_Ix for Field msgLogs';
COMMENT ON COLUMN "logResponseHdrMsgLogs"."ref" IS 'Foreign log reference';
COMMENT ON COLUMN "logResponseHdrMsgLogs"."resource" IS 'Logging resource name';


-- Creating Table logResponseHdrWorkItem
DROP TABLE IF EXISTS "logResponseHdrWorkItem";
CREATE TABLE "logResponseHdrWorkItem" (
    "_Id" varchar(42)  NOT NULL ,
    "activity" varchar(20)   DEFAULT NULL,
    "appId" varchar(20)   DEFAULT NULL,
    "caseId" varchar(20)   DEFAULT NULL,
    "caseType" varchar(20)   DEFAULT NULL,
    "note" text  DEFAULT NULL,
    "openDtm" timestamptz  DEFAULT NULL,
    "status" varchar(20)   DEFAULT NULL,
    "step" varchar(20)   DEFAULT NULL,
    "task" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "logResponseHdrWorkItem"."_Id" IS 'Unique Identifier for this log reference';
COMMENT ON COLUMN "logResponseHdrWorkItem"."activity" IS 'The case activity';
COMMENT ON COLUMN "logResponseHdrWorkItem"."appId" IS 'The case application identifier';
COMMENT ON COLUMN "logResponseHdrWorkItem"."caseId" IS 'Unique case identifier within apppId';
COMMENT ON COLUMN "logResponseHdrWorkItem"."caseType" IS 'The case type';
COMMENT ON COLUMN "logResponseHdrWorkItem"."note" IS 'Free text case note';
COMMENT ON COLUMN "logResponseHdrWorkItem"."openDtm" IS 'When case was opened';
COMMENT ON COLUMN "logResponseHdrWorkItem"."status" IS 'The case status';
COMMENT ON COLUMN "logResponseHdrWorkItem"."step" IS 'The case step within task';
COMMENT ON COLUMN "logResponseHdrWorkItem"."task" IS 'The case task';


-- Creating Table login
DROP TABLE IF EXISTS "login";
CREATE TABLE "login" (
    "createDtm" timestamptz  NOT NULL ,
    "domainId" varchar(42)  NOT NULL ,
    "expDtm" timestamptz  DEFAULT NULL,
    "isNotify" boolean  DEFAULT NULL,
    "login" varchar(100)   NOT NULL ,
    "partyId" varchar(42)  NOT NULL ,
    "userId" varchar(40)   NOT NULL ,
    
    PRIMARY KEY ("domainId", "login")
); 
COMMENT ON COLUMN "login"."createDtm" IS 'Login created on date';
COMMENT ON COLUMN "login"."domainId" IS 'Domain unique identifier';
COMMENT ON COLUMN "login"."expDtm" IS 'Login expires on date';
COMMENT ON COLUMN "login"."isNotify" IS 'Login triggers notify event';
COMMENT ON COLUMN "login"."login" IS 'Unique login within a domain';
COMMENT ON COLUMN "login"."partyId" IS 'Party associated with login';
COMMENT ON COLUMN "login"."userId" IS 'User associated with login';


-- Creating Table loginBiometrics
DROP TABLE IF EXISTS "loginBiometrics";
CREATE TABLE "loginBiometrics" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "createDtm" timestamptz  DEFAULT NULL,
    "domainId" varchar(42)  NOT NULL ,
    "login" varchar(100)   NOT NULL ,
    "option" smallint  DEFAULT NULL check ("option" >= 0),
    "val" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("domainId", "login", "_Ix")
); 
COMMENT ON COLUMN "loginBiometrics"."_Ix" IS '_Ix for Field biometrics';
COMMENT ON COLUMN "loginBiometrics"."createDtm" IS 'Created on date';
COMMENT ON COLUMN "loginBiometrics"."domainId" IS 'Domain unique identifier';
COMMENT ON COLUMN "loginBiometrics"."login" IS 'Unique login within a domain';
COMMENT ON COLUMN "loginBiometrics"."option" IS 'Biometric option';
COMMENT ON COLUMN "loginBiometrics"."val" IS 'Biometric value';


-- Creating Table loginKbaStatics
DROP TABLE IF EXISTS "loginKbaStatics";
CREATE TABLE "loginKbaStatics" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "answer" varchar(255)   DEFAULT NULL,
    "createDtm" timestamptz  DEFAULT NULL,
    "domainId" varchar(42)  NOT NULL ,
    "login" varchar(100)   NOT NULL ,
    "questionId" varchar(255)   DEFAULT NULL,
    "questionText" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("domainId", "login", "_Ix")
); 
COMMENT ON COLUMN "loginKbaStatics"."_Ix" IS '_Ix for Field kbaStatics';
COMMENT ON COLUMN "loginKbaStatics"."answer" IS 'Answer';
COMMENT ON COLUMN "loginKbaStatics"."createDtm" IS 'Created on date';
COMMENT ON COLUMN "loginKbaStatics"."domainId" IS 'Domain unique identifier';
COMMENT ON COLUMN "loginKbaStatics"."login" IS 'Unique login within a domain';
COMMENT ON COLUMN "loginKbaStatics"."questionId" IS 'Question Id in table';
COMMENT ON COLUMN "loginKbaStatics"."questionText" IS 'Question text';


-- Creating Table loginSecrets
DROP TABLE IF EXISTS "loginSecrets";
CREATE TABLE "loginSecrets" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "chngDtm" timestamptz  DEFAULT NULL,
    "domainId" varchar(42)  NOT NULL ,
    "expDtm" timestamptz  DEFAULT NULL,
    "isExp" boolean  DEFAULT NULL,
    "isOneUse" boolean  DEFAULT NULL,
    "login" varchar(100)   NOT NULL ,
    "secretType" smallint  DEFAULT NULL check ("secretType" >= 0),
    "val" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("domainId", "login", "_Ix")
); 
COMMENT ON COLUMN "loginSecrets"."_Ix" IS '_Ix for Field secrets';
COMMENT ON COLUMN "loginSecrets"."chngDtm" IS 'Secret last changed on date';
COMMENT ON COLUMN "loginSecrets"."domainId" IS 'Domain unique identifier';
COMMENT ON COLUMN "loginSecrets"."expDtm" IS 'Secret expires on date';
COMMENT ON COLUMN "loginSecrets"."isExp" IS 'Secret is expired';
COMMENT ON COLUMN "loginSecrets"."isOneUse" IS 'Single use only';
COMMENT ON COLUMN "loginSecrets"."login" IS 'Unique login within a domain';
COMMENT ON COLUMN "loginSecrets"."secretType" IS 'Secret option';
COMMENT ON COLUMN "loginSecrets"."val" IS 'Encrypted value';


-- Creating Table loginActivity
DROP TABLE IF EXISTS "loginActivity";
CREATE TABLE "loginActivity" (
    "domainId" varchar(42)  NOT NULL ,
    "eventDtm" timestamptz  NOT NULL ,
    "logId" varchar(42)  NOT NULL ,
    "login" varchar(100)   NOT NULL ,
    "seq" bigint  NOT NULL  check ("seq" >= 0),
    "status" smallint  NOT NULL  check ("status" >= 0),
    
    PRIMARY KEY ("domainId", "login", "seq")
); 
COMMENT ON COLUMN "loginActivity"."domainId" IS 'Domain unique identifier';
COMMENT ON COLUMN "loginActivity"."eventDtm" IS 'Login attempted on date';
COMMENT ON COLUMN "loginActivity"."logId" IS 'Message log id';
COMMENT ON COLUMN "loginActivity"."login" IS 'Unique login within a domain';
COMMENT ON COLUMN "loginActivity"."seq" IS 'Login sequence';
COMMENT ON COLUMN "loginActivity"."status" IS 'Login attempt status';


-- Creating Table loginHist
DROP TABLE IF EXISTS "loginHist";
CREATE TABLE "loginHist" (
    "domainId" varchar(42)  NOT NULL ,
    "eventDtm" timestamptz  NOT NULL ,
    "logId" varchar(42)  DEFAULT NULL,
    "login" varchar(100)   NOT NULL ,
    "oldVal" varchar(255)   NOT NULL ,
    "secretType" smallint  NOT NULL  check ("secretType" >= 0),
    "seq" bigint  NOT NULL  check ("seq" >= 0),
    
    PRIMARY KEY ("domainId", "login", "seq")
); 
COMMENT ON COLUMN "loginHist"."domainId" IS 'Domain unique identifier';
COMMENT ON COLUMN "loginHist"."eventDtm" IS 'Login attempted on date';
COMMENT ON COLUMN "loginHist"."logId" IS 'Message log id';
COMMENT ON COLUMN "loginHist"."login" IS 'Unique login within a domain';
COMMENT ON COLUMN "loginHist"."oldVal" IS 'Encrypted value';
COMMENT ON COLUMN "loginHist"."secretType" IS 'Secret option';
COMMENT ON COLUMN "loginHist"."seq" IS 'Login sequence';


-- Creating Table matrix
DROP TABLE IF EXISTS "matrix";
CREATE TABLE "matrix" (
    "dimKey" varchar(255)   NOT NULL ,
    "name" varchar(20)   NOT NULL ,
    "val" varchar(255)   DEFAULT NULL,
    "validFromDtm" timestamptz  NOT NULL ,
    "validToDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("name", "validFromDtm", "dimKey")
); 
COMMENT ON COLUMN "matrix"."dimKey" IS 'N-dimensional string key, delimiter separated';
COMMENT ON COLUMN "matrix"."name" IS 'Name of the matrix';
COMMENT ON COLUMN "matrix"."val" IS 'Value associated with key';
COMMENT ON COLUMN "matrix"."validFromDtm" IS 'The first time that this data is in effect';
COMMENT ON COLUMN "matrix"."validToDtm" IS 'The time that this data is no longer in effect';


-- Creating Table matrixType
DROP TABLE IF EXISTS "matrixType";
CREATE TABLE "matrixType" (
    "desc" varchar(255)   DEFAULT NULL,
    "dimensions" jsonb  DEFAULT NULL,
    "isBlended" boolean  DEFAULT NULL,
    "name" varchar(20)   NOT NULL ,
    "valFmt" varchar(255)   DEFAULT NULL,
    "valType" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("name")
); 
COMMENT ON COLUMN "matrixType"."desc" IS 'Description of the index or matrix';
COMMENT ON COLUMN "matrixType"."dimensions" IS 'Hierarchical properties of a matrix with one or more dimensions';
COMMENT ON COLUMN "matrixType"."isBlended" IS 'Indicates whether tiered rate is incremental or blended';
COMMENT ON COLUMN "matrixType"."name" IS 'Name of the index or matrix';
COMMENT ON COLUMN "matrixType"."valFmt" IS 'The JSON format of the value';
COMMENT ON COLUMN "matrixType"."valType" IS 'The serialized JSON type of the value assigned to key';


-- Creating Table merch
DROP TABLE IF EXISTS "merch";
CREATE TABLE "merch" (
    "_Id" varchar(42)  NOT NULL ,
    "cat" bigint  DEFAULT NULL,
    "networkId" bigint  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "merch"."_Id" IS 'Unique Party identifier';
COMMENT ON COLUMN "merch"."cat" IS 'Merchant Category Code (MCC)';
COMMENT ON COLUMN "merch"."networkId" IS 'Merchant network identifier';


-- Creating Table network
DROP TABLE IF EXISTS "network";
CREATE TABLE "network" (
    "calendar" varchar(30)   DEFAULT NULL,
    "contacts" jsonb  DEFAULT NULL,
    "desc" varchar(255)   DEFAULT NULL,
    "destination" varchar(42)  DEFAULT NULL,
    "extCrAccts" smallint  DEFAULT 1 check ("extCrAccts" >= 0),
    "extDrAccts" smallint  DEFAULT 1 check ("extDrAccts" >= 0),
    "inputPath" varchar(255)   DEFAULT NULL,
    "isAmlChk" boolean  DEFAULT NULL,
    "isAutoReturn" boolean  DEFAULT NULL,
    "isChkNbr" boolean  DEFAULT NULL,
    "isChkValid" boolean  DEFAULT NULL,
    "isDrBalGrace" boolean  DEFAULT NULL,
    "isFraudChk" boolean  DEFAULT NULL,
    "isInteractive" boolean  DEFAULT NULL,
    "isNegPay" boolean  DEFAULT NULL,
    "isNsfOptIn" boolean  DEFAULT NULL,
    "isOrderVerifyReqd" boolean  DEFAULT NULL,
    "isPosPay" boolean  DEFAULT NULL,
    "isReturnFundsAvl" boolean  DEFAULT NULL,
    "isStoreForward" boolean  DEFAULT NULL,
    "maxRetry" smallint  DEFAULT 0 check ("maxRetry" >= 0),
    "network" varchar(20)   NOT NULL ,
    "nsfPost" smallint  DEFAULT 1 check ("nsfPost" >= 0),
    "odSweep" smallint  DEFAULT 1 check ("odSweep" >= 0),
    "outputPath" varchar(255)   DEFAULT NULL,
    "pageTrnCnt" integer  DEFAULT NULL check ("pageTrnCnt" >= 0),
    "paging" smallint  DEFAULT 1 check ("paging" >= 0),
    "partyId" varchar(42)  DEFAULT NULL,
    "postOrder" smallint  DEFAULT 1 check ("postOrder" >= 0),
    "retryFreq" varchar(255)   DEFAULT NULL,
    "returnDecideTm" varchar(255)   DEFAULT NULL,
    "submitTm" varchar(255)   DEFAULT NULL,
    "trnCode" jsonb  DEFAULT NULL,
    "userRole" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("network")
); 
COMMENT ON COLUMN "network"."calendar" IS 'Business calendar for the network';
COMMENT ON COLUMN "network"."contacts" IS 'Network contacts';
COMMENT ON COLUMN "network"."desc" IS 'The network description';
COMMENT ON COLUMN "network"."destination" IS 'Information about the destination financial institution';
COMMENT ON COLUMN "network"."extCrAccts" IS 'External account credit transaction status';
COMMENT ON COLUMN "network"."extDrAccts" IS 'External account debit transaction status';
COMMENT ON COLUMN "network"."inputPath" IS 'Input location for batch files';
COMMENT ON COLUMN "network"."isAmlChk" IS 'Evaluate transactions from this network against AML rules';
COMMENT ON COLUMN "network"."isAutoReturn" IS 'Automatically create the return item file at the expiration of the return item cutoff if review is not complete';
COMMENT ON COLUMN "network"."isChkNbr" IS 'Indicates whether or not a check number must be present as part of the transaction message';
COMMENT ON COLUMN "network"."isChkValid" IS 'Validate check number is issued to party and available';
COMMENT ON COLUMN "network"."isDrBalGrace" IS 'Indicates whether or not debit balance grace period is applied to NSF items for this network';
COMMENT ON COLUMN "network"."isFraudChk" IS 'Evaluate transactions from this network against fraud rules';
COMMENT ON COLUMN "network"."isInteractive" IS 'Is an interactive (on-line) network';
COMMENT ON COLUMN "network"."isNegPay" IS 'Transactions may be subject to negative pay (pay or hold)';
COMMENT ON COLUMN "network"."isNsfOptIn" IS 'Indicates whether or not the accounts opt-in designation applies for this network';
COMMENT ON COLUMN "network"."isOrderVerifyReqd" IS 'Order needs to be verified';
COMMENT ON COLUMN "network"."isPosPay" IS 'Transactions may be subject to positive pay';
COMMENT ON COLUMN "network"."isReturnFundsAvl" IS 'Indicates whether or not a returnable item''s funds are available to pay an item presented that isn''t returnable';
COMMENT ON COLUMN "network"."isStoreForward" IS 'Supports store and forward processing';
COMMENT ON COLUMN "network"."maxRetry" IS 'Maximum number of times to try to process an outgoing payment';
COMMENT ON COLUMN "network"."network" IS 'The name of the network';
COMMENT ON COLUMN "network"."nsfPost" IS 'Indicates how transactions should be handled when there are not sufficient funds available';
COMMENT ON COLUMN "network"."odSweep" IS 'Indicates when overdraft sweep should occur if sufficient funds are not available';
COMMENT ON COLUMN "network"."outputPath" IS 'Output location for batch files';
COMMENT ON COLUMN "network"."pageTrnCnt" IS 'Maximum transactions on a page';
COMMENT ON COLUMN "network"."paging" IS 'Defines how batch transactions will be grouped for posting';
COMMENT ON COLUMN "network"."partyId" IS 'Network institutional party Id';
COMMENT ON COLUMN "network"."postOrder" IS 'Indicates the posting order of batch transactions within a position';
COMMENT ON COLUMN "network"."retryFreq" IS 'Frequency to retry processing of outgoing items on account with NSF balance';
COMMENT ON COLUMN "network"."returnDecideTm" IS 'The latest time of day a decision can be made to pay or return an item';
COMMENT ON COLUMN "network"."submitTm" IS 'The scheduled time for submitting return items to the network';
COMMENT ON COLUMN "network"."trnCode" IS 'Network posting processes linked tranCodes';
COMMENT ON COLUMN "network"."userRole" IS 'Authorization role for override decisioning';


-- Creating Table order
DROP TABLE IF EXISTS "order";
CREATE TABLE "order" (
    "_Id" varchar(42)  NOT NULL ,
    "beneNetAmt" decimal(16,2)   DEFAULT NULL,
    "cancelBy" jsonb  DEFAULT NULL,
    "cancelDtm" timestamptz  DEFAULT NULL,
    "cancelReason" varchar(255)   DEFAULT NULL,
    "checkedBy" jsonb  DEFAULT NULL,
    "counterParty" jsonb  NOT NULL ,
    "createBy" jsonb  DEFAULT NULL,
    "createDtm" timestamptz  DEFAULT NULL,
    "intermedFi" jsonb  DEFAULT NULL,
    "logRef" varchar(42)  DEFAULT NULL,
    "network" varchar(12)   NOT NULL ,
    "orderAmt" decimal(16,2)   NOT NULL ,
    "orderDtm" timestamptz  NOT NULL ,
    "orderInfo" text  DEFAULT NULL,
    "orderSrc" smallint  DEFAULT NULL check ("orderSrc" >= 0),
    "orderStatus" smallint  DEFAULT NULL check ("orderStatus" >= 0),
    "orderTotAmt" decimal(16,2)   NOT NULL ,
    "orderType" smallint  NOT NULL  check ("orderType" >= 0),
    "originSrc" smallint  DEFAULT NULL check ("originSrc" >= 0),
    "originator" jsonb  NOT NULL ,
    "posnId" varchar(42)  DEFAULT NULL,
    "procDtm" timestamptz  DEFAULT NULL,
    "receiverFee" jsonb  DEFAULT NULL,
    "receiverFi" jsonb  DEFAULT NULL,
    "remainRetry" smallint  NOT NULL  check ("remainRetry" >= 0),
    "senderFee" jsonb  DEFAULT NULL,
    "senderFi" jsonb  DEFAULT NULL,
    "threshholdAmt" decimal(16,2)   DEFAULT NULL,
    "trnId" varchar(42)  DEFAULT NULL,
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "order"."_Id" IS 'Unique order identifier';
COMMENT ON COLUMN "order"."beneNetAmt" IS 'Beneficiary customer total settled amount (sent amount - receiver fees)';
COMMENT ON COLUMN "order"."cancelBy" IS 'Order canceled by';
COMMENT ON COLUMN "order"."cancelDtm" IS 'Order canceled on datetime';
COMMENT ON COLUMN "order"."cancelReason" IS 'Reason the order was canceled';
COMMENT ON COLUMN "order"."checkedBy" IS 'Order verified by (i.e., checker)';
COMMENT ON COLUMN "order"."counterParty" IS 'The counterparty of the order';
COMMENT ON COLUMN "order"."createBy" IS 'Order created by (i.e., maker)';
COMMENT ON COLUMN "order"."createDtm" IS 'Order created on date';
COMMENT ON COLUMN "order"."intermedFi" IS 'Sending Fi to receiver Fi intermediate institution';
COMMENT ON COLUMN "order"."logRef" IS 'Order create log reference';
COMMENT ON COLUMN "order"."network" IS 'Payment network type';
COMMENT ON COLUMN "order"."orderAmt" IS 'The amount of the order, net to transfer to receiver';
COMMENT ON COLUMN "order"."orderDtm" IS 'Order scheduled to be processed on datetime';
COMMENT ON COLUMN "order"."orderInfo" IS 'Originator to beneficiary information';
COMMENT ON COLUMN "order"."orderSrc" IS 'The source that originated the order';
COMMENT ON COLUMN "order"."orderStatus" IS 'The status of the order';
COMMENT ON COLUMN "order"."orderTotAmt" IS 'Ordering customer total settled amount, order amount plus fees';
COMMENT ON COLUMN "order"."orderType" IS 'The type of order';
COMMENT ON COLUMN "order"."originSrc" IS 'The origination source by which the order is placed (e.g. web or telephone)';
COMMENT ON COLUMN "order"."originator" IS 'The party that originated the order';
COMMENT ON COLUMN "order"."posnId" IS 'Related Position Id';
COMMENT ON COLUMN "order"."procDtm" IS 'Order actually processed on datetime';
COMMENT ON COLUMN "order"."receiverFee" IS 'Total fees charged by receiving institution';
COMMENT ON COLUMN "order"."receiverFi" IS 'Receiving institution correspondent bank';
COMMENT ON COLUMN "order"."remainRetry" IS 'Number of retry attempts remaining';
COMMENT ON COLUMN "order"."senderFee" IS 'Total fees charged by sending institution';
COMMENT ON COLUMN "order"."senderFi" IS 'Sending institution correspondent bank';
COMMENT ON COLUMN "order"."threshholdAmt" IS 'Amount used to determine balance for threshold transfer';
COMMENT ON COLUMN "order"."trnId" IS 'Unique Transaction identifier';
COMMENT ON COLUMN "order"."verifyDtm" IS 'Order verified on datetime';


-- Creating Table orderNotify
DROP TABLE IF EXISTS "orderNotify";
CREATE TABLE "orderNotify" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "cntry" varchar(2)   DEFAULT NULL,
    "contactPref" smallint  DEFAULT NULL check ("contactPref" >= 0),
    "folderId" varchar(42)  DEFAULT NULL,
    "name" varchar(80)   NOT NULL ,
    "preferAddrId" varchar(42)  DEFAULT NULL,
    "preferEmailId" smallint  DEFAULT NULL check ("preferEmailId" >= 0),
    "preferPhoneId" smallint  DEFAULT NULL check ("preferPhoneId" >= 0),
    "taxid" varchar(11)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "orderNotify"."_Id" IS 'Unique order identifier';
COMMENT ON COLUMN "orderNotify"."_Ix" IS '_Ix for Field notify';
COMMENT ON COLUMN "orderNotify"."cntry" IS 'Country of residence or registration ISO 3166-2';
COMMENT ON COLUMN "orderNotify"."contactPref" IS 'The method of contact preference';
COMMENT ON COLUMN "orderNotify"."folderId" IS 'Partys documents and attachments root folder Id';
COMMENT ON COLUMN "orderNotify"."name" IS 'Formatted full name of party';
COMMENT ON COLUMN "orderNotify"."preferAddrId" IS 'Preferred address identifier';
COMMENT ON COLUMN "orderNotify"."preferEmailId" IS 'Preferred email identifier';
COMMENT ON COLUMN "orderNotify"."preferPhoneId" IS 'Preferred phone number identifier';
COMMENT ON COLUMN "orderNotify"."taxid" IS 'US taxid or social security number';


-- Creating Table orderNotifyAddrs
DROP TABLE IF EXISTS "orderNotifyAddrs";
CREATE TABLE "orderNotifyAddrs" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "_Ix1" int  NOT NULL  check ("_Ix1" >= 0),
    "addrId" varchar(42)  NOT NULL ,
    "addrType" smallint  NOT NULL  check ("addrType" >= 0),
    "label" varchar(30)   DEFAULT NULL,
    "priority" smallint  DEFAULT NULL check ("priority" >= 0),
    "validFromDtm" timestamptz  DEFAULT NULL,
    "validToDtm" timestamptz  DEFAULT NULL,
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix", "_Ix1")
); 
COMMENT ON COLUMN "orderNotifyAddrs"."_Id" IS 'Unique order identifier';
COMMENT ON COLUMN "orderNotifyAddrs"."_Ix" IS '_Ix for Field notify';
COMMENT ON COLUMN "orderNotifyAddrs"."_Ix1" IS '_Ix for Field addrs';
COMMENT ON COLUMN "orderNotifyAddrs"."addrId" IS 'The address Id';
COMMENT ON COLUMN "orderNotifyAddrs"."addrType" IS 'The type of address';
COMMENT ON COLUMN "orderNotifyAddrs"."label" IS 'The label of this address';
COMMENT ON COLUMN "orderNotifyAddrs"."priority" IS 'Listing sort priority';
COMMENT ON COLUMN "orderNotifyAddrs"."validFromDtm" IS 'Address is valid from date';
COMMENT ON COLUMN "orderNotifyAddrs"."validToDtm" IS 'Address is valid to date';
COMMENT ON COLUMN "orderNotifyAddrs"."verifyDtm" IS 'Date address was last verified';


-- Creating Table orderNotifyEmails
DROP TABLE IF EXISTS "orderNotifyEmails";
CREATE TABLE "orderNotifyEmails" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "_Ix1" int  NOT NULL  check ("_Ix1" >= 0),
    "data" varchar(255)   NOT NULL ,
    "emailType" smallint  NOT NULL  check ("emailType" >= 0),
    "label" varchar(30)   DEFAULT NULL,
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix", "_Ix1")
); 
COMMENT ON COLUMN "orderNotifyEmails"."_Id" IS 'Unique order identifier';
COMMENT ON COLUMN "orderNotifyEmails"."_Ix" IS '_Ix for Field notify';
COMMENT ON COLUMN "orderNotifyEmails"."_Ix1" IS '_Ix for Field emails';
COMMENT ON COLUMN "orderNotifyEmails"."data" IS 'The email address';
COMMENT ON COLUMN "orderNotifyEmails"."emailType" IS 'Email type';
COMMENT ON COLUMN "orderNotifyEmails"."label" IS 'Label';
COMMENT ON COLUMN "orderNotifyEmails"."verifyDtm" IS 'Date email was last verified';


-- Creating Table orderNotifyPhones
DROP TABLE IF EXISTS "orderNotifyPhones";
CREATE TABLE "orderNotifyPhones" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "_Ix1" int  NOT NULL  check ("_Ix1" >= 0),
    "data" varchar(20)   NOT NULL ,
    "label" varchar(30)   DEFAULT NULL,
    "phoneType" smallint  NOT NULL  check ("phoneType" >= 0),
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix", "_Ix1")
); 
COMMENT ON COLUMN "orderNotifyPhones"."_Id" IS 'Unique order identifier';
COMMENT ON COLUMN "orderNotifyPhones"."_Ix" IS '_Ix for Field notify';
COMMENT ON COLUMN "orderNotifyPhones"."_Ix1" IS '_Ix for Field phones';
COMMENT ON COLUMN "orderNotifyPhones"."data" IS 'Phone number';
COMMENT ON COLUMN "orderNotifyPhones"."label" IS 'Label';
COMMENT ON COLUMN "orderNotifyPhones"."phoneType" IS 'Phone type';
COMMENT ON COLUMN "orderNotifyPhones"."verifyDtm" IS 'Date phone was last verified';


-- Creating Table orderRecur
DROP TABLE IF EXISTS "orderRecur";
CREATE TABLE "orderRecur" (
    "_Id" varchar(42)  NOT NULL ,
    "cnt" smallint  DEFAULT NULL check ("cnt" >= 0),
    "expDtm" timestamptz  DEFAULT NULL,
    "freq" varchar(255)   NOT NULL ,
    "lastDtm" timestamptz  DEFAULT NULL,
    "nextDtm" timestamptz  DEFAULT NULL,
    "remain" smallint  DEFAULT NULL check ("remain" >= 0),
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "orderRecur"."_Id" IS 'Unique order identifier';
COMMENT ON COLUMN "orderRecur"."cnt" IS 'Current number of times order has executed';
COMMENT ON COLUMN "orderRecur"."expDtm" IS 'The latest date a recurring order transaction can occur';
COMMENT ON COLUMN "orderRecur"."freq" IS 'Frequency that recurring order executes';
COMMENT ON COLUMN "orderRecur"."lastDtm" IS 'The last date recurring order was executed';
COMMENT ON COLUMN "orderRecur"."nextDtm" IS 'The next date recurring order will executed';
COMMENT ON COLUMN "orderRecur"."remain" IS 'Remaining number of time order will be executed';


-- Creating Table orderCalendar
DROP TABLE IF EXISTS "orderCalendar";
CREATE TABLE "orderCalendar" (
    "_Id" varchar(42)  NOT NULL ,
    "orderId" varchar(42)  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "orderCalendar"."_Id" IS 'Unique Position Calendar identifier';
COMMENT ON COLUMN "orderCalendar"."orderId" IS 'Unique order identifier';


-- Creating Table party
DROP TABLE IF EXISTS "party";
CREATE TABLE "party" (
    "_Class" varchar(255)   DEFAULT NULL,
    "_Id" varchar(42)  NOT NULL ,
    "cntry" varchar(2)   DEFAULT NULL,
    "contactPref" smallint  DEFAULT NULL check ("contactPref" >= 0),
    "folderId" varchar(42)  DEFAULT NULL,
    "name" varchar(80)   NOT NULL ,
    "preferAddrId" varchar(42)  DEFAULT NULL,
    "preferEmailId" smallint  DEFAULT NULL check ("preferEmailId" >= 0),
    "preferPhoneId" smallint  DEFAULT NULL check ("preferPhoneId" >= 0),
    "taxid" varchar(11)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "party"."_Class" IS 'The class of the party';
COMMENT ON COLUMN "party"."_Id" IS 'Unique Party identifier';
COMMENT ON COLUMN "party"."cntry" IS 'Country of residence or registration ISO 3166-2';
COMMENT ON COLUMN "party"."contactPref" IS 'The method of contact preference';
COMMENT ON COLUMN "party"."folderId" IS 'Partys documents and attachments root folder Id';
COMMENT ON COLUMN "party"."name" IS 'Formatted full name of party';
COMMENT ON COLUMN "party"."preferAddrId" IS 'Preferred address identifier';
COMMENT ON COLUMN "party"."preferEmailId" IS 'Preferred email identifier';
COMMENT ON COLUMN "party"."preferPhoneId" IS 'Preferred phone number identifier';
COMMENT ON COLUMN "party"."taxid" IS 'US taxid or social security number';


-- Creating Table partyAddrs
DROP TABLE IF EXISTS "partyAddrs";
CREATE TABLE "partyAddrs" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "addrId" varchar(42)  NOT NULL ,
    "addrType" smallint  NOT NULL  check ("addrType" >= 0),
    "label" varchar(30)   DEFAULT NULL,
    "priority" smallint  DEFAULT NULL check ("priority" >= 0),
    "validFromDtm" timestamptz  DEFAULT NULL,
    "validToDtm" timestamptz  DEFAULT NULL,
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "partyAddrs"."_Id" IS 'Unique Party identifier';
COMMENT ON COLUMN "partyAddrs"."_Ix" IS '_Ix for Field addrs';
COMMENT ON COLUMN "partyAddrs"."addrId" IS 'The address Id';
COMMENT ON COLUMN "partyAddrs"."addrType" IS 'The type of address';
COMMENT ON COLUMN "partyAddrs"."label" IS 'The label of this address';
COMMENT ON COLUMN "partyAddrs"."priority" IS 'Listing sort priority';
COMMENT ON COLUMN "partyAddrs"."validFromDtm" IS 'Address is valid from date';
COMMENT ON COLUMN "partyAddrs"."validToDtm" IS 'Address is valid to date';
COMMENT ON COLUMN "partyAddrs"."verifyDtm" IS 'Date address was last verified';


-- Creating Table partyEmails
DROP TABLE IF EXISTS "partyEmails";
CREATE TABLE "partyEmails" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "data" varchar(255)   NOT NULL ,
    "emailType" smallint  NOT NULL  check ("emailType" >= 0),
    "label" varchar(30)   DEFAULT NULL,
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "partyEmails"."_Id" IS 'Unique Party identifier';
COMMENT ON COLUMN "partyEmails"."_Ix" IS '_Ix for Field emails';
COMMENT ON COLUMN "partyEmails"."data" IS 'The email address';
COMMENT ON COLUMN "partyEmails"."emailType" IS 'Email type';
COMMENT ON COLUMN "partyEmails"."label" IS 'Label';
COMMENT ON COLUMN "partyEmails"."verifyDtm" IS 'Date email was last verified';


-- Creating Table partyPhones
DROP TABLE IF EXISTS "partyPhones";
CREATE TABLE "partyPhones" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "data" varchar(20)   NOT NULL ,
    "label" varchar(30)   DEFAULT NULL,
    "phoneType" smallint  NOT NULL  check ("phoneType" >= 0),
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "partyPhones"."_Id" IS 'Unique Party identifier';
COMMENT ON COLUMN "partyPhones"."_Ix" IS '_Ix for Field phones';
COMMENT ON COLUMN "partyPhones"."data" IS 'Phone number';
COMMENT ON COLUMN "partyPhones"."label" IS 'Label';
COMMENT ON COLUMN "partyPhones"."phoneType" IS 'Phone type';
COMMENT ON COLUMN "partyPhones"."verifyDtm" IS 'Date phone was last verified';


-- Creating Table partyCrRept
DROP TABLE IF EXISTS "partyCrRept";
CREATE TABLE "partyCrRept" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" integer  NOT NULL  check ("_Ix" >= 0),
    "agency" smallint  NOT NULL  check ("agency" >= 0),
    "attach" varchar(255)   DEFAULT NULL,
    "lastDate" date  NOT NULL ,
    "nextDate" date  DEFAULT NULL,
    "score" integer  NOT NULL  check ("score" >= 0),
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "partyCrRept"."_Id" IS 'Foreign key to party';
COMMENT ON COLUMN "partyCrRept"."_Ix" IS 'Sequence number';
COMMENT ON COLUMN "partyCrRept"."agency" IS 'Credit Reporting Agency';
COMMENT ON COLUMN "partyCrRept"."attach" IS 'Credit report enclosure reference';
COMMENT ON COLUMN "partyCrRept"."lastDate" IS 'Date the last financial statement was due';
COMMENT ON COLUMN "partyCrRept"."nextDate" IS 'Date the next financial statement is due';
COMMENT ON COLUMN "partyCrRept"."score" IS 'Credit report score';


-- Creating Table partyFinRept
DROP TABLE IF EXISTS "partyFinRept";
CREATE TABLE "partyFinRept" (
    "_Id" varchar(42)  NOT NULL ,
    "fiscalYrEnd" smallint  DEFAULT NULL check ("fiscalYrEnd" >= 0),
    "isAnnual" boolean  NOT NULL ,
    "isMo" boolean  NOT NULL ,
    "isQtr" boolean  NOT NULL ,
    "isReqd" boolean  NOT NULL ,
    "lastDate" date  NOT NULL ,
    "nextDate" date  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "partyFinRept"."_Id" IS 'Foreign key to party';
COMMENT ON COLUMN "partyFinRept"."fiscalYrEnd" IS 'Month of fiscal year-end';
COMMENT ON COLUMN "partyFinRept"."isAnnual" IS 'Annual statement required';
COMMENT ON COLUMN "partyFinRept"."isMo" IS 'Monthly statement required';
COMMENT ON COLUMN "partyFinRept"."isQtr" IS 'Quarterly statement required';
COMMENT ON COLUMN "partyFinRept"."isReqd" IS 'Indicates whether financial statement is required';
COMMENT ON COLUMN "partyFinRept"."lastDate" IS 'Date the last financial statement was due';
COMMENT ON COLUMN "partyFinRept"."nextDate" IS 'Date the next financial statement is due';


-- Creating Table partyFinReptStmts
DROP TABLE IF EXISTS "partyFinReptStmts";
CREATE TABLE "partyFinReptStmts" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "acquiredDtm" timestamptz  DEFAULT NULL,
    "attachments" varchar(255)   NOT NULL ,
    "period" varchar(7)   NOT NULL ,
    "stmtDtm" timestamptz  NOT NULL ,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "partyFinReptStmts"."_Id" IS 'Foreign key to party';
COMMENT ON COLUMN "partyFinReptStmts"."_Ix" IS '_Ix for Field stmts';
COMMENT ON COLUMN "partyFinReptStmts"."acquiredDtm" IS 'Statement acquired on date';
COMMENT ON COLUMN "partyFinReptStmts"."attachments" IS 'Statement enclosure reference';
COMMENT ON COLUMN "partyFinReptStmts"."period" IS 'Statement reporting period';
COMMENT ON COLUMN "partyFinReptStmts"."stmtDtm" IS 'Reporting period cutoff date';


-- Creating Table partyGroup
DROP TABLE IF EXISTS "partyGroup";
CREATE TABLE "partyGroup" (
    "desc" varchar(255)   DEFAULT NULL,
    "groupId" varchar(30)   NOT NULL ,
    "groupOwnerId" varchar(42)  DEFAULT NULL,
    "groupType" smallint  DEFAULT NULL check ("groupType" >= 0),
    "name" varchar(60)   DEFAULT NULL,
    
    PRIMARY KEY ("groupId")
); 
COMMENT ON COLUMN "partyGroup"."desc" IS 'Group description';
COMMENT ON COLUMN "partyGroup"."groupId" IS 'Unique PartyGroup identifier';
COMMENT ON COLUMN "partyGroup"."groupOwnerId" IS 'Party that owns the group';
COMMENT ON COLUMN "partyGroup"."groupType" IS 'Group type code';
COMMENT ON COLUMN "partyGroup"."name" IS 'Group name';


-- Creating Table partyGroupParties
DROP TABLE IF EXISTS "partyGroupParties";
CREATE TABLE "partyGroupParties" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "endDtm" timestamptz  DEFAULT NULL,
    "groupId" varchar(30)   NOT NULL ,
    "memberId" varchar(80)   DEFAULT NULL,
    "partyId" varchar(42)  DEFAULT NULL,
    "partyTitle" varchar(80)   DEFAULT NULL,
    "roleCode" smallint  DEFAULT NULL check ("roleCode" >= 0),
    "startDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("groupId", "_Ix")
); 
COMMENT ON COLUMN "partyGroupParties"."_Ix" IS '_Ix for Field parties';
COMMENT ON COLUMN "partyGroupParties"."endDtm" IS 'The date the party was expired from the group';
COMMENT ON COLUMN "partyGroupParties"."groupId" IS 'Unique PartyGroup identifier';
COMMENT ON COLUMN "partyGroupParties"."memberId" IS 'The memeber Id of Party within group';
COMMENT ON COLUMN "partyGroupParties"."partyId" IS 'Party within group';
COMMENT ON COLUMN "partyGroupParties"."partyTitle" IS 'The title of Party within group';
COMMENT ON COLUMN "partyGroupParties"."roleCode" IS 'The partys role in the group';
COMMENT ON COLUMN "partyGroupParties"."startDtm" IS 'The date the party was added to group';


-- Creating Table partyGroupSubGroups
DROP TABLE IF EXISTS "partyGroupSubGroups";
CREATE TABLE "partyGroupSubGroups" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "endDtm" timestamptz  DEFAULT NULL,
    "groupId" varchar(30)   NOT NULL ,
    "groupTitle" varchar(80)   DEFAULT NULL,
    "startDtm" timestamptz  DEFAULT NULL,
    "subGroupId" varchar(42)  DEFAULT NULL,
    
    PRIMARY KEY ("groupId", "_Ix")
); 
COMMENT ON COLUMN "partyGroupSubGroups"."_Ix" IS '_Ix for Field subGroups';
COMMENT ON COLUMN "partyGroupSubGroups"."endDtm" IS 'The date the sub-group was expired from the group';
COMMENT ON COLUMN "partyGroupSubGroups"."groupId" IS 'Unique PartyGroup identifier';
COMMENT ON COLUMN "partyGroupSubGroups"."groupTitle" IS 'The title of sub-group within group';
COMMENT ON COLUMN "partyGroupSubGroups"."startDtm" IS 'The date the sub-group was added to group';
COMMENT ON COLUMN "partyGroupSubGroups"."subGroupId" IS 'Sub-group within group';


-- Creating Table partyGroupAcct
DROP TABLE IF EXISTS "partyGroupAcct";
CREATE TABLE "partyGroupAcct" (
    "groupId" varchar(42)  NOT NULL ,
    "memberId" varchar(40)   NOT NULL ,
    
    PRIMARY KEY ("groupId", "memberId")
); 
COMMENT ON COLUMN "partyGroupAcct"."groupId" IS 'Party group containing member accounts';
COMMENT ON COLUMN "partyGroupAcct"."memberId" IS 'The member id of the party within group (a.k.a. customerId, employeeId)';


-- Creating Table partyGroupAcctAccounts
DROP TABLE IF EXISTS "partyGroupAcctAccounts";
CREATE TABLE "partyGroupAcctAccounts" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "acctGroup" integer  DEFAULT NULL check ("acctGroup" >= 0),
    "acctName" varchar(255)   DEFAULT NULL,
    "acctNbr" varchar(20)   DEFAULT NULL,
    "groupId" varchar(42)  NOT NULL ,
    "memberId" varchar(40)   NOT NULL ,
    "ownerCode" smallint  DEFAULT NULL check ("ownerCode" >= 0),
    
    PRIMARY KEY ("groupId", "memberId", "_Ix")
); 
COMMENT ON COLUMN "partyGroupAcctAccounts"."_Ix" IS '_Ix for Field accounts';
COMMENT ON COLUMN "partyGroupAcctAccounts"."acctGroup" IS 'Account group code';
COMMENT ON COLUMN "partyGroupAcctAccounts"."acctName" IS 'The unique name for this account for the customer';
COMMENT ON COLUMN "partyGroupAcctAccounts"."acctNbr" IS 'The unique account identifier within an acctGroup';
COMMENT ON COLUMN "partyGroupAcctAccounts"."groupId" IS 'Party group containing member accounts';
COMMENT ON COLUMN "partyGroupAcctAccounts"."memberId" IS 'The member id of the party within group (a.k.a. customerId, employeeId)';
COMMENT ON COLUMN "partyGroupAcctAccounts"."ownerCode" IS 'Code that defines account ownership relationship';


-- Creating Table party_organization
DROP TABLE IF EXISTS "party_organization";
CREATE TABLE "party_organization" (
    "_Class" varchar(255)   DEFAULT NULL,
    "_Id" varchar(42)  NOT NULL ,
    "dba" varchar(60)   DEFAULT NULL,
    "dbaName" varchar(60)   DEFAULT NULL,
    "desc" varchar(255)   DEFAULT NULL,
    "dunsNbr" bigint  DEFAULT NULL check ("dunsNbr" >= 0),
    "emailDomain" varchar(60)   DEFAULT NULL,
    "estDate" date  DEFAULT NULL,
    "isGovtOwn" boolean  DEFAULT NULL,
    "isIntrntl" boolean  DEFAULT NULL,
    "isPubliclyHeld" boolean  DEFAULT NULL,
    "isSmallBusiness" boolean  DEFAULT NULL,
    "isTaxExempt" boolean  DEFAULT NULL,
    "legalForm" smallint  DEFAULT NULL check ("legalForm" >= 0),
    "moFiscalYrEnd" smallint  DEFAULT NULL check ("moFiscalYrEnd" >= 0),
    "nbrEmployed" smallint  DEFAULT NULL check ("nbrEmployed" >= 0),
    "primaryBankId" varchar(42)  DEFAULT NULL,
    "region" varchar(2)   DEFAULT NULL,
    "taxExemptType" smallint  DEFAULT NULL check ("taxExemptType" >= 0),
    "tradeName" varchar(60)   DEFAULT NULL,
    "webSiteURL" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "party_organization"."_Class" IS 'The class of the party_organization';
COMMENT ON COLUMN "party_organization"."_Id" IS 'Unique Party identifier';
COMMENT ON COLUMN "party_organization"."dba" IS 'DBA or trade name';
COMMENT ON COLUMN "party_organization"."dbaName" IS 'Doing business as name';
COMMENT ON COLUMN "party_organization"."desc" IS 'Description of the organization';
COMMENT ON COLUMN "party_organization"."dunsNbr" IS 'A unique nine-digit number assigned to the company by Dun & Bradstreet, if applicable';
COMMENT ON COLUMN "party_organization"."emailDomain" IS 'Principal email domain';
COMMENT ON COLUMN "party_organization"."estDate" IS 'The organization''s date of establishment';
COMMENT ON COLUMN "party_organization"."isGovtOwn" IS 'Indictaes whether the organization a government-owned entity';
COMMENT ON COLUMN "party_organization"."isIntrntl" IS 'Indicates whether the orginization is international';
COMMENT ON COLUMN "party_organization"."isPubliclyHeld" IS 'Indicates whether the organiziation is publicly held';
COMMENT ON COLUMN "party_organization"."isSmallBusiness" IS 'Indicates whether the organization is classified a small business';
COMMENT ON COLUMN "party_organization"."isTaxExempt" IS 'Indicates if the organization is tax-exempt';
COMMENT ON COLUMN "party_organization"."legalForm" IS 'Legal form of organization';
COMMENT ON COLUMN "party_organization"."moFiscalYrEnd" IS 'The month of organization''s fiscal year end date';
COMMENT ON COLUMN "party_organization"."nbrEmployed" IS 'Number of persons employed';
COMMENT ON COLUMN "party_organization"."primaryBankId" IS 'The bank with which the organization has the majority of its financial dealings';
COMMENT ON COLUMN "party_organization"."region" IS 'The state or region of registration';
COMMENT ON COLUMN "party_organization"."taxExemptType" IS 'The tax exempt entity type';
COMMENT ON COLUMN "party_organization"."tradeName" IS 'The organization''s trade name';
COMMENT ON COLUMN "party_organization"."webSiteURL" IS 'The organization''s home page';


-- Creating Table party_organization_fininst
DROP TABLE IF EXISTS "party_organization_fininst";
CREATE TABLE "party_organization_fininst" (
    "_Id" varchar(42)  NOT NULL ,
    "finInstAba" bigint  DEFAULT NULL,
    "finInstBic" varchar(30)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "party_organization_fininst"."_Id" IS 'Unique Party identifier';
COMMENT ON COLUMN "party_organization_fininst"."finInstAba" IS 'Bank ABA routing number (US only)';
COMMENT ON COLUMN "party_organization_fininst"."finInstBic" IS 'Bank SWIFT BIC identifier';


-- Creating Table party_person
DROP TABLE IF EXISTS "party_person";
CREATE TABLE "party_person" (
    "_Id" varchar(42)  NOT NULL ,
    "ageBracket" smallint  DEFAULT NULL check ("ageBracket" >= 0),
    "aliases" jsonb  DEFAULT NULL,
    "alternateLanguage" varchar(20)   DEFAULT NULL,
    "birthDate" date  DEFAULT NULL,
    "citizenCntry" varchar(2)   DEFAULT NULL,
    "deathDate" date  DEFAULT NULL,
    "education" smallint  DEFAULT NULL check ("education" >= 0),
    "employmentStatus" smallint  DEFAULT NULL check ("employmentStatus" >= 0),
    "ethnicity" smallint  DEFAULT NULL check ("ethnicity" >= 0),
    "familiarName" varchar(60)   DEFAULT NULL,
    "firstName" varchar(60)   DEFAULT NULL,
    "gender" smallint  DEFAULT NULL check ("gender" >= 0),
    "govtId" jsonb  DEFAULT NULL,
    "incBracket" smallint  DEFAULT NULL check ("incBracket" >= 0),
    "lastName" varchar(60)   DEFAULT NULL,
    "maidenName" varchar(60)   DEFAULT NULL,
    "maritalStatus" smallint  DEFAULT NULL check ("maritalStatus" >= 0),
    "middleName" varchar(60)   DEFAULT NULL,
    "militaryStatus" smallint  DEFAULT NULL check ("militaryStatus" >= 0),
    "moGrossInc" decimal(16,2)   DEFAULT NULL,
    "mothersMaidenName" varchar(60)   DEFAULT NULL,
    "nbrInHhold" smallint  DEFAULT NULL check ("nbrInHhold" >= 0),
    "occupation" smallint  DEFAULT NULL check ("occupation" >= 0),
    "preferredLanguage" varchar(20)   DEFAULT NULL,
    "prefix" varchar(20)   DEFAULT NULL,
    "primaryEmployerId" varchar(42)  DEFAULT NULL,
    "residencyStatus" smallint  DEFAULT NULL check ("residencyStatus" >= 0),
    "spouse" varchar(60)   DEFAULT NULL,
    "studentType" smallint  DEFAULT NULL check ("studentType" >= 0),
    "suffix" varchar(20)   DEFAULT NULL,
    "webAddr" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "party_person"."_Id" IS 'Unique Party identifier';
COMMENT ON COLUMN "party_person"."ageBracket" IS 'A group of people having approximately the same age (range)';
COMMENT ON COLUMN "party_person"."aliases" IS 'Alias name';
COMMENT ON COLUMN "party_person"."alternateLanguage" IS 'Alternate contact language IETF RFC 5646';
COMMENT ON COLUMN "party_person"."birthDate" IS 'The Person’s date of birth';
COMMENT ON COLUMN "party_person"."citizenCntry" IS 'Country of which the person is a citizen ISO 3166-2';
COMMENT ON COLUMN "party_person"."deathDate" IS 'The Person’s date of death';
COMMENT ON COLUMN "party_person"."education" IS 'The highest education level achieved';
COMMENT ON COLUMN "party_person"."employmentStatus" IS 'Employment Status code';
COMMENT ON COLUMN "party_person"."ethnicity" IS 'The person’s race or ethnic origin';
COMMENT ON COLUMN "party_person"."familiarName" IS 'Familiar name for the person';
COMMENT ON COLUMN "party_person"."firstName" IS 'The person’s first name';
COMMENT ON COLUMN "party_person"."gender" IS 'The Person’s gender';
COMMENT ON COLUMN "party_person"."govtId" IS 'Government issued identification documents';
COMMENT ON COLUMN "party_person"."incBracket" IS 'Income range of person';
COMMENT ON COLUMN "party_person"."lastName" IS 'The person’s last name';
COMMENT ON COLUMN "party_person"."maidenName" IS 'The person’s maiden name if applicable';
COMMENT ON COLUMN "party_person"."maritalStatus" IS 'The person’s marital status';
COMMENT ON COLUMN "party_person"."middleName" IS 'The person’s middle name';
COMMENT ON COLUMN "party_person"."militaryStatus" IS 'The person’s military status (i.e, active duty, veteran)';
COMMENT ON COLUMN "party_person"."moGrossInc" IS 'The monthly income earned by the person';
COMMENT ON COLUMN "party_person"."mothersMaidenName" IS 'The maiden name of the person’s mother';
COMMENT ON COLUMN "party_person"."nbrInHhold" IS 'The number of occupants in the person’s household';
COMMENT ON COLUMN "party_person"."occupation" IS 'The person’s occupational category code';
COMMENT ON COLUMN "party_person"."preferredLanguage" IS 'Preferred contact language IETF RFC 5646';
COMMENT ON COLUMN "party_person"."prefix" IS 'Honorific prefix';
COMMENT ON COLUMN "party_person"."primaryEmployerId" IS 'The Person’s current primary employer';
COMMENT ON COLUMN "party_person"."residencyStatus" IS 'Residency Status';
COMMENT ON COLUMN "party_person"."spouse" IS 'The name of the Person’s spouse if applicable';
COMMENT ON COLUMN "party_person"."studentType" IS 'Person’s current student status';
COMMENT ON COLUMN "party_person"."suffix" IS 'Honorific suffix (e.g., MD, DDS, II)';
COMMENT ON COLUMN "party_person"."webAddr" IS 'Person’s individual website';


-- Creating Table posn
DROP TABLE IF EXISTS "posn";
CREATE TABLE "posn" (
    "_Class" varchar(255)   DEFAULT NULL,
    "_Id" varchar(42)  NOT NULL ,
    "_asOfDt" timestamptz  DEFAULT NULL,
    "_cDt" timestamptz  DEFAULT NULL,
    "_dDt" timestamptz  DEFAULT NULL,
    "_uDt" timestamptz  DEFAULT NULL,
    "acctGroup" integer  NOT NULL  check ("acctGroup" >= 0),
    "acctNbr" varchar(20)   NOT NULL ,
    "bal" decimal(16,2)   NOT NULL ,
    "closeDtm" timestamptz  DEFAULT NULL,
    "createLogRef" varchar(42)  NOT NULL ,
    "logRef" varchar(42)  DEFAULT NULL,
    "name" varchar(40)   DEFAULT NULL,
    "openDtm" timestamptz  NOT NULL ,
    "posnRef" varchar(30)   NOT NULL ,
    "seqNbr" int  NOT NULL  check ("seqNbr" >= 0),
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "posn"."_Class" IS 'The class of the posn';
COMMENT ON COLUMN "posn"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn"."_asOfDt" IS 'AsOf Time Stamp';
COMMENT ON COLUMN "posn"."_cDt" IS 'Create Time Stamp';
COMMENT ON COLUMN "posn"."_dDt" IS 'Delete Time Stamp';
COMMENT ON COLUMN "posn"."_uDt" IS 'Update Time Stamp';
COMMENT ON COLUMN "posn"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "posn"."acctNbr" IS 'The unique account identifier within an acctGroup';
COMMENT ON COLUMN "posn"."bal" IS 'Current balance or quantity of the position';
COMMENT ON COLUMN "posn"."closeDtm" IS 'Datetime position closed for use';
COMMENT ON COLUMN "posn"."createLogRef" IS 'Position created log references';
COMMENT ON COLUMN "posn"."logRef" IS 'LogId of action that resulted in change';
COMMENT ON COLUMN "posn"."name" IS 'Unique position name within an account';
COMMENT ON COLUMN "posn"."openDtm" IS 'Datetime position opened for use';
COMMENT ON COLUMN "posn"."posnRef" IS 'The unique position identifier within an acctGroup';
COMMENT ON COLUMN "posn"."seqNbr" IS 'Transaction sequence number in position';


-- Creating Table posn_hist
DROP TABLE IF EXISTS "posn_hist";
CREATE TABLE "posn_hist" (
    "_Id" varchar(42)  NOT NULL ,
    "_isDel" boolean  DEFAULT NULL,
    "_isExc" boolean  DEFAULT NULL,
    "_pList" jsonb  DEFAULT NULL,
    "_ts" timestamptz  DEFAULT NULL,
    "_vList" jsonb  DEFAULT NULL,
    "_vn" varchar(42)  NOT NULL ,
    "bal" decimal(16,2)   NOT NULL ,
    "logRef" varchar(42)  DEFAULT NULL,
    "seqNbr" int  NOT NULL  check ("seqNbr" >= 0),
    "trnEntry" jsonb  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_vn")
); 
COMMENT ON COLUMN "posn_hist"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_hist"."_isDel" IS '';
COMMENT ON COLUMN "posn_hist"."_isExc" IS '';
COMMENT ON COLUMN "posn_hist"."_pList" IS '';
COMMENT ON COLUMN "posn_hist"."_ts" IS '';
COMMENT ON COLUMN "posn_hist"."_vList" IS '';
COMMENT ON COLUMN "posn_hist"."_vn" IS '';
COMMENT ON COLUMN "posn_hist"."bal" IS 'Current balance or quantity of the position';
COMMENT ON COLUMN "posn_hist"."logRef" IS '';
COMMENT ON COLUMN "posn_hist"."seqNbr" IS 'Transaction sequence number in position';
COMMENT ON COLUMN "posn_hist"."trnEntry" IS 'Context Field for Key trnEntry';


-- Creating Table posnCalendar
DROP TABLE IF EXISTS "posnCalendar";
CREATE TABLE "posnCalendar" (
    "_Class" varchar(255)   DEFAULT NULL,
    "_Id" varchar(42)  NOT NULL ,
    "cancelDtm" timestamptz  DEFAULT NULL,
    "eventCtxtId" varchar(255)   DEFAULT NULL,
    "eventType" varchar(20)   DEFAULT NULL,
    "handledDtm" timestamptz  DEFAULT NULL,
    "isScheduled" boolean  DEFAULT NULL,
    "name" varchar(20)   DEFAULT NULL,
    "posnId" varchar(42)  DEFAULT NULL,
    "schedDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "posnCalendar"."_Class" IS 'The class of the posnCalendar';
COMMENT ON COLUMN "posnCalendar"."_Id" IS 'Unique Position Calendar identifier';
COMMENT ON COLUMN "posnCalendar"."cancelDtm" IS 'If cancelled, the datetime the event was cancelled';
COMMENT ON COLUMN "posnCalendar"."eventCtxtId" IS 'The Event Context Identifier of the event msg that handled the event';
COMMENT ON COLUMN "posnCalendar"."eventType" IS 'The event type';
COMMENT ON COLUMN "posnCalendar"."handledDtm" IS 'The event was handled on';
COMMENT ON COLUMN "posnCalendar"."isScheduled" IS 'Flag determines whether the event has been scheduled';
COMMENT ON COLUMN "posnCalendar"."name" IS 'The event name';
COMMENT ON COLUMN "posnCalendar"."posnId" IS 'Unique position identifier';
COMMENT ON COLUMN "posnCalendar"."schedDtm" IS 'Event schedule datetime, determined when the event should occur';


-- Creating Table posnGlExtractDtl
DROP TABLE IF EXISTS "posnGlExtractDtl";
CREATE TABLE "posnGlExtractDtl" (
    "accumToDtm" timestamptz  DEFAULT NULL,
    "comment" varchar(60)   DEFAULT NULL,
    "extractAmtCr" decimal(16,2)   DEFAULT NULL,
    "extractAmtDr" decimal(16,2)   DEFAULT NULL,
    "extractCntCr" int  DEFAULT NULL check ("extractCntCr" >= 0),
    "extractCntDr" int  DEFAULT NULL check ("extractCntDr" >= 0),
    "glDate" date  NOT NULL ,
    "glSetCode" varchar(20)   NOT NULL ,
    "posnId" varchar(42)  NOT NULL ,
    "trnId" varchar(42)  NOT NULL ,
    "trnSeq" bigint  NOT NULL  check ("trnSeq" >= 0),
    
    PRIMARY KEY ("posnId", "glDate", "glSetCode", "trnId", "trnSeq")
); 
COMMENT ON COLUMN "posnGlExtractDtl"."accumToDtm" IS 'Statistics accumulated to high-water';
COMMENT ON COLUMN "posnGlExtractDtl"."comment" IS 'Short transaction comment';
COMMENT ON COLUMN "posnGlExtractDtl"."extractAmtCr" IS 'Total Credit amount to date for GL extract';
COMMENT ON COLUMN "posnGlExtractDtl"."extractAmtDr" IS 'Total Debit amount to date for GL extract';
COMMENT ON COLUMN "posnGlExtractDtl"."extractCntCr" IS 'Total Credit count to date for GL extract';
COMMENT ON COLUMN "posnGlExtractDtl"."extractCntDr" IS 'Total Debit count to date for GL extract';
COMMENT ON COLUMN "posnGlExtractDtl"."glDate" IS 'GL journal date transaction is posted on';
COMMENT ON COLUMN "posnGlExtractDtl"."glSetCode" IS 'General ledger acccounts used for reporting';
COMMENT ON COLUMN "posnGlExtractDtl"."posnId" IS 'Position identifier';
COMMENT ON COLUMN "posnGlExtractDtl"."trnId" IS 'Unique Transaction identifier';
COMMENT ON COLUMN "posnGlExtractDtl"."trnSeq" IS 'Transaction entry sequence';


-- Creating Table posnGlExtractSum
DROP TABLE IF EXISTS "posnGlExtractSum";
CREATE TABLE "posnGlExtractSum" (
    "accumToDtm" timestamptz  DEFAULT NULL,
    "extractAmtCr" decimal(16,2)   DEFAULT NULL,
    "extractAmtDr" decimal(16,2)   DEFAULT NULL,
    "extractCntCr" int  DEFAULT NULL check ("extractCntCr" >= 0),
    "extractCntDr" int  DEFAULT NULL check ("extractCntDr" >= 0),
    "glDate" date  NOT NULL ,
    "glSetCode" varchar(20)   NOT NULL ,
    "posnId" varchar(42)  NOT NULL ,
    "trnCode" varchar(20)   NOT NULL ,
    
    PRIMARY KEY ("posnId", "glDate", "trnCode", "glSetCode")
); 
COMMENT ON COLUMN "posnGlExtractSum"."accumToDtm" IS 'Statistics accumulated to high-water';
COMMENT ON COLUMN "posnGlExtractSum"."extractAmtCr" IS 'Total Credit amount to date for GL extract';
COMMENT ON COLUMN "posnGlExtractSum"."extractAmtDr" IS 'Total Debit amount to date for GL extract';
COMMENT ON COLUMN "posnGlExtractSum"."extractCntCr" IS 'Total Credit count to date for GL extract';
COMMENT ON COLUMN "posnGlExtractSum"."extractCntDr" IS 'Total Debit count to date for GL extract';
COMMENT ON COLUMN "posnGlExtractSum"."glDate" IS 'GL journal date transaction is posted on';
COMMENT ON COLUMN "posnGlExtractSum"."glSetCode" IS 'General ledger acccounts used for reporting';
COMMENT ON COLUMN "posnGlExtractSum"."posnId" IS 'Position identifier';
COMMENT ON COLUMN "posnGlExtractSum"."trnCode" IS 'The Finxact transaction code';


-- Creating Table posnGlSum
DROP TABLE IF EXISTS "posnGlSum";
CREATE TABLE "posnGlSum" (
    "accumToDtm" timestamptz  DEFAULT NULL,
    "glBal" decimal(16,2)   DEFAULT NULL,
    "glDate" date  NOT NULL ,
    "posnId" varchar(42)  NOT NULL ,
    "totAmtCr" decimal(16,2)   DEFAULT NULL,
    "totAmtDr" decimal(16,2)   DEFAULT NULL,
    "totCntCr" int  DEFAULT NULL check ("totCntCr" >= 0),
    "totCntDr" int  DEFAULT NULL check ("totCntDr" >= 0),
    
    PRIMARY KEY ("posnId", "glDate")
); 
COMMENT ON COLUMN "posnGlSum"."accumToDtm" IS 'Statistics accumulated to high-water';
COMMENT ON COLUMN "posnGlSum"."glBal" IS 'Current balance or quantity of the position by gl journal date';
COMMENT ON COLUMN "posnGlSum"."glDate" IS 'GL journal date transaction is posted on';
COMMENT ON COLUMN "posnGlSum"."posnId" IS 'Position identifier';
COMMENT ON COLUMN "posnGlSum"."totAmtCr" IS 'Total Credit amount to date';
COMMENT ON COLUMN "posnGlSum"."totAmtDr" IS 'Total Debit amount to date';
COMMENT ON COLUMN "posnGlSum"."totCntCr" IS 'Total Credit count to date';
COMMENT ON COLUMN "posnGlSum"."totCntDr" IS 'Total Debit count to date';


-- Creating Table posn_bk
DROP TABLE IF EXISTS "posn_bk";
CREATE TABLE "posn_bk" (
    "_Id" varchar(42)  NOT NULL ,
    "_asOfDt" timestamptz  DEFAULT NULL,
    "_cDt" timestamptz  DEFAULT NULL,
    "_dDt" timestamptz  DEFAULT NULL,
    "_uDt" timestamptz  DEFAULT NULL,
    "ccyCode" varchar(3)   NOT NULL  DEFAULT 'USD',
    "company" integer  DEFAULT 0 check ("company" >= 0),
    "components" jsonb  DEFAULT NULL,
    "deptId" integer  DEFAULT 0 check ("deptId" >= 0),
    "flags" jsonb  DEFAULT NULL,
    "fundExpDtm" timestamptz  DEFAULT NULL,
    "glCat" smallint  NOT NULL  check ("glCat" >= 0),
    "glSetCode" varchar(20)   NOT NULL ,
    "logRef" varchar(42)  DEFAULT NULL,
    "pledgedBal" decimal(16,2)   DEFAULT NULL,
    "prodName" varchar(30)   NOT NULL ,
    "vertical" int  DEFAULT 0,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "posn_bk"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bk"."_asOfDt" IS 'AsOf Time Stamp';
COMMENT ON COLUMN "posn_bk"."_cDt" IS 'Create Time Stamp';
COMMENT ON COLUMN "posn_bk"."_dDt" IS 'Delete Time Stamp';
COMMENT ON COLUMN "posn_bk"."_uDt" IS 'Update Time Stamp';
COMMENT ON COLUMN "posn_bk"."ccyCode" IS 'Currency code ISO 4217';
COMMENT ON COLUMN "posn_bk"."company" IS 'Company reported';
COMMENT ON COLUMN "posn_bk"."components" IS 'List of components used by the product';
COMMENT ON COLUMN "posn_bk"."deptId" IS 'Balancing department or cost center Id';
COMMENT ON COLUMN "posn_bk"."flags" IS 'Process condition flags for holds, restricts, stops, etc.';
COMMENT ON COLUMN "posn_bk"."fundExpDtm" IS 'Date-time by which position must be funded';
COMMENT ON COLUMN "posn_bk"."glCat" IS 'GL category code';
COMMENT ON COLUMN "posn_bk"."glSetCode" IS 'GL account numbers set code';
COMMENT ON COLUMN "posn_bk"."logRef" IS 'LogId of action that resulted in change';
COMMENT ON COLUMN "posn_bk"."pledgedBal" IS 'Pledged initial funding balance';
COMMENT ON COLUMN "posn_bk"."prodName" IS 'Position''s product';
COMMENT ON COLUMN "posn_bk"."vertical" IS 'Vertical reported';


-- Creating Table posn_bk_hist
DROP TABLE IF EXISTS "posn_bk_hist";
CREATE TABLE "posn_bk_hist" (
    "_Id" varchar(42)  NOT NULL ,
    "_isDel" boolean  DEFAULT NULL,
    "_isExc" boolean  DEFAULT NULL,
    "_pList" jsonb  DEFAULT NULL,
    "_ts" timestamptz  DEFAULT NULL,
    "_vList" jsonb  DEFAULT NULL,
    "_vn" varchar(42)  NOT NULL ,
    "logRef" varchar(42)  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_vn")
); 
COMMENT ON COLUMN "posn_bk_hist"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bk_hist"."_isDel" IS '';
COMMENT ON COLUMN "posn_bk_hist"."_isExc" IS '';
COMMENT ON COLUMN "posn_bk_hist"."_pList" IS '';
COMMENT ON COLUMN "posn_bk_hist"."_ts" IS '';
COMMENT ON COLUMN "posn_bk_hist"."_vList" IS '';
COMMENT ON COLUMN "posn_bk_hist"."_vn" IS '';
COMMENT ON COLUMN "posn_bk_hist"."logRef" IS '';


-- Creating Table posn_bkCalendar
DROP TABLE IF EXISTS "posn_bkCalendar";
CREATE TABLE "posn_bkCalendar" (
    "_Id" varchar(42)  NOT NULL ,
    "acctGroup" integer  DEFAULT NULL check ("acctGroup" >= 0),
    "cancelDtm" timestamptz  DEFAULT NULL,
    "eventCtxtId" varchar(255)   DEFAULT NULL,
    "eventType" varchar(20)   DEFAULT NULL,
    "handledDtm" timestamptz  DEFAULT NULL,
    "isScheduled" boolean  DEFAULT NULL,
    "name" varchar(20)   DEFAULT NULL,
    "posnId" varchar(42)  DEFAULT NULL,
    "posnRef" varchar(30)   DEFAULT NULL,
    "schedDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "posn_bkCalendar"."_Id" IS 'Unique Position Calendar identifier';
COMMENT ON COLUMN "posn_bkCalendar"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "posn_bkCalendar"."cancelDtm" IS 'If cancelled, the datetime the event was cancelled';
COMMENT ON COLUMN "posn_bkCalendar"."eventCtxtId" IS 'The Event Context Identifier of the event msg that handled the event';
COMMENT ON COLUMN "posn_bkCalendar"."eventType" IS 'The event type';
COMMENT ON COLUMN "posn_bkCalendar"."handledDtm" IS 'The event was handled on';
COMMENT ON COLUMN "posn_bkCalendar"."isScheduled" IS 'Flag determines whether the event has been scheduled';
COMMENT ON COLUMN "posn_bkCalendar"."name" IS 'The event name';
COMMENT ON COLUMN "posn_bkCalendar"."posnId" IS 'Foreign Key to Position _Id';
COMMENT ON COLUMN "posn_bkCalendar"."posnRef" IS 'The unique position identifier within an acctGroup';
COMMENT ON COLUMN "posn_bkCalendar"."schedDtm" IS 'Event schedule datetime, determined when the event should occur';


-- Creating Table posn_bkFee
DROP TABLE IF EXISTS "posn_bkFee";
CREATE TABLE "posn_bkFee" (
    "_Id" varchar(42)  NOT NULL ,
    "_asOfDt" timestamptz  DEFAULT NULL,
    "_cDt" timestamptz  DEFAULT NULL,
    "_dDt" timestamptz  DEFAULT NULL,
    "_uDt" timestamptz  DEFAULT NULL,
    "componentName" varchar(30)   DEFAULT NULL,
    "earnings" decimal(16,2)   DEFAULT NULL,
    "logRef" varchar(42)  DEFAULT NULL,
    "nextChrgDtm" timestamptz  DEFAULT NULL,
    "sumForfeited" decimal(16,2)   DEFAULT NULL,
    "version" integer  DEFAULT NULL check ("version" >= 0),
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "posn_bkFee"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkFee"."_asOfDt" IS 'AsOf Time Stamp';
COMMENT ON COLUMN "posn_bkFee"."_cDt" IS 'Create Time Stamp';
COMMENT ON COLUMN "posn_bkFee"."_dDt" IS 'Delete Time Stamp';
COMMENT ON COLUMN "posn_bkFee"."_uDt" IS 'Update Time Stamp';
COMMENT ON COLUMN "posn_bkFee"."componentName" IS 'Fee component used by the position';
COMMENT ON COLUMN "posn_bkFee"."earnings" IS 'Current earnings available to offset fees assessed';
COMMENT ON COLUMN "posn_bkFee"."logRef" IS 'LogId of action that resulted in change';
COMMENT ON COLUMN "posn_bkFee"."nextChrgDtm" IS 'Date cycled service charges next collected';
COMMENT ON COLUMN "posn_bkFee"."sumForfeited" IS 'Sum of unused earnings forfeited';
COMMENT ON COLUMN "posn_bkFee"."version" IS 'Version of fee component used by the position';


-- Creating Table posn_bkFeeCollectFrom
DROP TABLE IF EXISTS "posn_bkFeeCollectFrom";
CREATE TABLE "posn_bkFeeCollectFrom" (
    "_Id" varchar(42)  NOT NULL ,
    "beneNetAmt" decimal(16,2)   DEFAULT NULL,
    "cancelBy" jsonb  DEFAULT NULL,
    "cancelDtm" timestamptz  DEFAULT NULL,
    "cancelReason" varchar(255)   DEFAULT NULL,
    "checkedBy" jsonb  DEFAULT NULL,
    "counterParty" jsonb  NOT NULL ,
    "createBy" jsonb  DEFAULT NULL,
    "createDtm" timestamptz  DEFAULT NULL,
    "intermedFi" jsonb  DEFAULT NULL,
    "logRef" varchar(42)  DEFAULT NULL,
    "network" varchar(12)   NOT NULL ,
    "orderAmt" decimal(16,2)   NOT NULL ,
    "orderDtm" timestamptz  NOT NULL ,
    "orderInfo" text  DEFAULT NULL,
    "orderSrc" smallint  DEFAULT NULL check ("orderSrc" >= 0),
    "orderStatus" smallint  DEFAULT NULL check ("orderStatus" >= 0),
    "orderTotAmt" decimal(16,2)   NOT NULL ,
    "orderType" smallint  NOT NULL  check ("orderType" >= 0),
    "originSrc" smallint  DEFAULT NULL check ("originSrc" >= 0),
    "originator" jsonb  NOT NULL ,
    "posnId" varchar(42)  DEFAULT NULL,
    "procDtm" timestamptz  DEFAULT NULL,
    "receiverFee" jsonb  DEFAULT NULL,
    "receiverFi" jsonb  DEFAULT NULL,
    "remainRetry" smallint  NOT NULL  check ("remainRetry" >= 0),
    "senderFee" jsonb  DEFAULT NULL,
    "senderFi" jsonb  DEFAULT NULL,
    "threshholdAmt" decimal(16,2)   DEFAULT NULL,
    "trnId" varchar(42)  DEFAULT NULL,
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."beneNetAmt" IS 'Beneficiary customer total settled amount (sent amount - receiver fees)';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."cancelBy" IS 'Order canceled by';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."cancelDtm" IS 'Order canceled on datetime';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."cancelReason" IS 'Reason the order was canceled';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."checkedBy" IS 'Order verified by (i.e., checker)';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."counterParty" IS 'The counterparty of the order';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."createBy" IS 'Order created by (i.e., maker)';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."createDtm" IS 'Order created on date';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."intermedFi" IS 'Sending Fi to receiver Fi intermediate institution';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."logRef" IS 'Order create log reference';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."network" IS 'Payment network type';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."orderAmt" IS 'The amount of the order, net to transfer to receiver';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."orderDtm" IS 'Order scheduled to be processed on datetime';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."orderInfo" IS 'Originator to beneficiary information';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."orderSrc" IS 'The source that originated the order';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."orderStatus" IS 'The status of the order';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."orderTotAmt" IS 'Ordering customer total settled amount, order amount plus fees';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."orderType" IS 'The type of order';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."originSrc" IS 'The origination source by which the order is placed (e.g. web or telephone)';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."originator" IS 'The party that originated the order';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."posnId" IS 'Related Position Id';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."procDtm" IS 'Order actually processed on datetime';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."receiverFee" IS 'Total fees charged by receiving institution';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."receiverFi" IS 'Receiving institution correspondent bank';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."remainRetry" IS 'Number of retry attempts remaining';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."senderFee" IS 'Total fees charged by sending institution';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."senderFi" IS 'Sending institution correspondent bank';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."threshholdAmt" IS 'Amount used to determine balance for threshold transfer';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."trnId" IS 'Unique Transaction identifier';
COMMENT ON COLUMN "posn_bkFeeCollectFrom"."verifyDtm" IS 'Order verified on datetime';


-- Creating Table posn_bkFeeCollectFromNotify
DROP TABLE IF EXISTS "posn_bkFeeCollectFromNotify";
CREATE TABLE "posn_bkFeeCollectFromNotify" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "cntry" varchar(2)   DEFAULT NULL,
    "contactPref" smallint  DEFAULT NULL check ("contactPref" >= 0),
    "folderId" varchar(42)  DEFAULT NULL,
    "name" varchar(80)   NOT NULL ,
    "preferAddrId" varchar(42)  DEFAULT NULL,
    "preferEmailId" smallint  DEFAULT NULL check ("preferEmailId" >= 0),
    "preferPhoneId" smallint  DEFAULT NULL check ("preferPhoneId" >= 0),
    "taxid" varchar(11)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "posn_bkFeeCollectFromNotify"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotify"."_Ix" IS '_Ix for Field notify';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotify"."cntry" IS 'Country of residence or registration ISO 3166-2';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotify"."contactPref" IS 'The method of contact preference';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotify"."folderId" IS 'Partys documents and attachments root folder Id';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotify"."name" IS 'Formatted full name of party';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotify"."preferAddrId" IS 'Preferred address identifier';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotify"."preferEmailId" IS 'Preferred email identifier';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotify"."preferPhoneId" IS 'Preferred phone number identifier';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotify"."taxid" IS 'US taxid or social security number';


-- Creating Table posn_bkFeeCollectFromNotifyAddrs
DROP TABLE IF EXISTS "posn_bkFeeCollectFromNotifyAddrs";
CREATE TABLE "posn_bkFeeCollectFromNotifyAddrs" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "_Ix1" int  NOT NULL  check ("_Ix1" >= 0),
    "addrId" varchar(42)  NOT NULL ,
    "addrType" smallint  NOT NULL  check ("addrType" >= 0),
    "label" varchar(30)   DEFAULT NULL,
    "priority" smallint  DEFAULT NULL check ("priority" >= 0),
    "validFromDtm" timestamptz  DEFAULT NULL,
    "validToDtm" timestamptz  DEFAULT NULL,
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix", "_Ix1")
); 
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyAddrs"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyAddrs"."_Ix" IS '_Ix for Field notify';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyAddrs"."_Ix1" IS '_Ix for Field addrs';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyAddrs"."addrId" IS 'The address Id';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyAddrs"."addrType" IS 'The type of address';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyAddrs"."label" IS 'The label of this address';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyAddrs"."priority" IS 'Listing sort priority';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyAddrs"."validFromDtm" IS 'Address is valid from date';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyAddrs"."validToDtm" IS 'Address is valid to date';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyAddrs"."verifyDtm" IS 'Date address was last verified';


-- Creating Table posn_bkFeeCollectFromNotifyEmails
DROP TABLE IF EXISTS "posn_bkFeeCollectFromNotifyEmails";
CREATE TABLE "posn_bkFeeCollectFromNotifyEmails" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "_Ix1" int  NOT NULL  check ("_Ix1" >= 0),
    "data" varchar(255)   NOT NULL ,
    "emailType" smallint  NOT NULL  check ("emailType" >= 0),
    "label" varchar(30)   DEFAULT NULL,
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix", "_Ix1")
); 
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyEmails"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyEmails"."_Ix" IS '_Ix for Field notify';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyEmails"."_Ix1" IS '_Ix for Field emails';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyEmails"."data" IS 'The email address';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyEmails"."emailType" IS 'Email type';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyEmails"."label" IS 'Label';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyEmails"."verifyDtm" IS 'Date email was last verified';


-- Creating Table posn_bkFeeCollectFromNotifyPhones
DROP TABLE IF EXISTS "posn_bkFeeCollectFromNotifyPhones";
CREATE TABLE "posn_bkFeeCollectFromNotifyPhones" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "_Ix1" int  NOT NULL  check ("_Ix1" >= 0),
    "data" varchar(20)   NOT NULL ,
    "label" varchar(30)   DEFAULT NULL,
    "phoneType" smallint  NOT NULL  check ("phoneType" >= 0),
    "verifyDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix", "_Ix1")
); 
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyPhones"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyPhones"."_Ix" IS '_Ix for Field notify';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyPhones"."_Ix1" IS '_Ix for Field phones';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyPhones"."data" IS 'Phone number';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyPhones"."label" IS 'Label';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyPhones"."phoneType" IS 'Phone type';
COMMENT ON COLUMN "posn_bkFeeCollectFromNotifyPhones"."verifyDtm" IS 'Date phone was last verified';


-- Creating Table posn_bkFeeCollectFromRecur
DROP TABLE IF EXISTS "posn_bkFeeCollectFromRecur";
CREATE TABLE "posn_bkFeeCollectFromRecur" (
    "_Id" varchar(42)  NOT NULL ,
    "cnt" smallint  DEFAULT NULL check ("cnt" >= 0),
    "expDtm" timestamptz  DEFAULT NULL,
    "freq" varchar(255)   NOT NULL ,
    "lastDtm" timestamptz  DEFAULT NULL,
    "nextDtm" timestamptz  DEFAULT NULL,
    "remain" smallint  DEFAULT NULL check ("remain" >= 0),
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "posn_bkFeeCollectFromRecur"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkFeeCollectFromRecur"."cnt" IS 'Current number of times order has executed';
COMMENT ON COLUMN "posn_bkFeeCollectFromRecur"."expDtm" IS 'The latest date a recurring order transaction can occur';
COMMENT ON COLUMN "posn_bkFeeCollectFromRecur"."freq" IS 'Frequency that recurring order executes';
COMMENT ON COLUMN "posn_bkFeeCollectFromRecur"."lastDtm" IS 'The last date recurring order was executed';
COMMENT ON COLUMN "posn_bkFeeCollectFromRecur"."nextDtm" IS 'The next date recurring order will executed';
COMMENT ON COLUMN "posn_bkFeeCollectFromRecur"."remain" IS 'Remaining number of time order will be executed';


-- Creating Table posn_bkFee_hist
DROP TABLE IF EXISTS "posn_bkFee_hist";
CREATE TABLE "posn_bkFee_hist" (
    "_Id" varchar(42)  NOT NULL ,
    "_isDel" boolean  DEFAULT NULL,
    "_isExc" boolean  DEFAULT NULL,
    "_pList" jsonb  DEFAULT NULL,
    "_ts" timestamptz  DEFAULT NULL,
    "_vList" jsonb  DEFAULT NULL,
    "_vn" varchar(42)  NOT NULL ,
    "earnings" decimal(16,2)   DEFAULT NULL,
    "logRef" varchar(42)  DEFAULT NULL,
    "sumForfeited" decimal(16,2)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_vn")
); 
COMMENT ON COLUMN "posn_bkFee_hist"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkFee_hist"."_isDel" IS '';
COMMENT ON COLUMN "posn_bkFee_hist"."_isExc" IS '';
COMMENT ON COLUMN "posn_bkFee_hist"."_pList" IS '';
COMMENT ON COLUMN "posn_bkFee_hist"."_ts" IS '';
COMMENT ON COLUMN "posn_bkFee_hist"."_vList" IS '';
COMMENT ON COLUMN "posn_bkFee_hist"."_vn" IS '';
COMMENT ON COLUMN "posn_bkFee_hist"."earnings" IS 'Current earnings available to offset fees assessed';
COMMENT ON COLUMN "posn_bkFee_hist"."logRef" IS '';
COMMENT ON COLUMN "posn_bkFee_hist"."sumForfeited" IS 'Sum of unused earnings forfeited';


-- Creating Table posn_bkFeesPd
DROP TABLE IF EXISTS "posn_bkFeesPd";
CREATE TABLE "posn_bkFeesPd" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "cntFee" integer  DEFAULT NULL check ("cntFee" >= 0),
    "sumFee" decimal(16,2)   DEFAULT NULL,
    "trnCode" varchar(255)   DEFAULT NULL,
    "waivedAmt" decimal(16,2)   DEFAULT NULL,
    "waivedCnt" integer  DEFAULT NULL check ("waivedCnt" >= 0),
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "posn_bkFeesPd"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkFeesPd"."_Ix" IS '_Ix for Field feesPd';
COMMENT ON COLUMN "posn_bkFeesPd"."cntFee" IS 'Count fees assessed';
COMMENT ON COLUMN "posn_bkFeesPd"."sumFee" IS 'Sum fees assessed';
COMMENT ON COLUMN "posn_bkFeesPd"."trnCode" IS 'Transaction code used to post the fees';
COMMENT ON COLUMN "posn_bkFeesPd"."waivedAmt" IS 'Sum fees waived';
COMMENT ON COLUMN "posn_bkFeesPd"."waivedCnt" IS 'Count fees waived';


-- Creating Table posn_bkInt
DROP TABLE IF EXISTS "posn_bkInt";
CREATE TABLE "posn_bkInt" (
    "_Id" varchar(42)  NOT NULL ,
    "_asOfDt" timestamptz  DEFAULT NULL,
    "_cDt" timestamptz  DEFAULT NULL,
    "_dDt" timestamptz  DEFAULT NULL,
    "_uDt" timestamptz  DEFAULT NULL,
    "accrCalcTm" varchar(255)   DEFAULT '11:59',
    "accrMinBal" decimal(16,2)   DEFAULT NULL,
    "accumToDtm" timestamptz  NOT NULL ,
    "adjTerm" varchar(255)   DEFAULT NULL,
    "balOpt" smallint  DEFAULT 0 check ("balOpt" >= 0),
    "calcMthd" smallint  DEFAULT NULL check ("calcMthd" >= 0),
    "componentName" varchar(30)   NOT NULL ,
    "disbmtOpt" smallint  DEFAULT NULL check ("disbmtOpt" >= 0),
    "index" jsonb  DEFAULT NULL,
    "intDisbmtInstr" jsonb  DEFAULT NULL,
    "is1099Exempt" boolean  DEFAULT false,
    "isCompoundDly" boolean  DEFAULT NULL,
    "isWthFed" boolean  NOT NULL  DEFAULT false,
    "isWthState" boolean  NOT NULL  DEFAULT false,
    "lastPostDtm" timestamptz  DEFAULT NULL,
    "logRef" varchar(42)  DEFAULT NULL,
    "nextPostDtm" timestamptz  NOT NULL ,
    "nomRate" decimal(16,5)   DEFAULT NULL,
    "postFreq" varchar(255)   DEFAULT NULL,
    "promoDtl" jsonb  DEFAULT NULL,
    "promoExpDtm" timestamptz  DEFAULT NULL,
    "sumAccrBal" decimal(16,5)   DEFAULT NULL,
    "sumIntPd" decimal(16,2)   DEFAULT NULL,
    "sumWthFed" decimal(16,2)   DEFAULT NULL,
    "sumWthState" decimal(16,2)   DEFAULT NULL,
    "version" integer  NOT NULL  check ("version" >= 0),
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "posn_bkInt"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkInt"."_asOfDt" IS 'AsOf Time Stamp';
COMMENT ON COLUMN "posn_bkInt"."_cDt" IS 'Create Time Stamp';
COMMENT ON COLUMN "posn_bkInt"."_dDt" IS 'Delete Time Stamp';
COMMENT ON COLUMN "posn_bkInt"."_uDt" IS 'Update Time Stamp';
COMMENT ON COLUMN "posn_bkInt"."accrCalcTm" IS 'Cutoff time for accrual calculation';
COMMENT ON COLUMN "posn_bkInt"."accrMinBal" IS 'Minimum balance to accrue';
COMMENT ON COLUMN "posn_bkInt"."accumToDtm" IS 'Accrued interest accumulated through datetime';
COMMENT ON COLUMN "posn_bkInt"."adjTerm" IS 'Term where rate can be adjusted and replaced if higher';
COMMENT ON COLUMN "posn_bkInt"."balOpt" IS 'Balance used to calculate accrual';
COMMENT ON COLUMN "posn_bkInt"."calcMthd" IS 'Interest accrual calculation method';
COMMENT ON COLUMN "posn_bkInt"."componentName" IS 'Interest component name';
COMMENT ON COLUMN "posn_bkInt"."disbmtOpt" IS 'Interest disbursement option';
COMMENT ON COLUMN "posn_bkInt"."index" IS 'Indexed rate properties and limits';
COMMENT ON COLUMN "posn_bkInt"."intDisbmtInstr" IS 'Customer instructions for interest payments not capitalized';
COMMENT ON COLUMN "posn_bkInt"."is1099Exempt" IS 'If exempt do not create a 1099-Int for the position';
COMMENT ON COLUMN "posn_bkInt"."isCompoundDly" IS 'Flag indicates daily interest compounding at accrual cutoff';
COMMENT ON COLUMN "posn_bkInt"."isWthFed" IS 'Is subject to federal withholding';
COMMENT ON COLUMN "posn_bkInt"."isWthState" IS 'Is subject to state withholding';
COMMENT ON COLUMN "posn_bkInt"."lastPostDtm" IS 'Date interest was last posted';
COMMENT ON COLUMN "posn_bkInt"."logRef" IS 'LogId of action that resulted in change';
COMMENT ON COLUMN "posn_bkInt"."nextPostDtm" IS 'Date interest next posted';
COMMENT ON COLUMN "posn_bkInt"."nomRate" IS 'Current nominal interest rate';
COMMENT ON COLUMN "posn_bkInt"."postFreq" IS 'Interest posting frequency';
COMMENT ON COLUMN "posn_bkInt"."promoDtl" IS 'Promotional rate properties and limits';
COMMENT ON COLUMN "posn_bkInt"."promoExpDtm" IS 'Date promotional interest rate expires and position reverts to standard rate';
COMMENT ON COLUMN "posn_bkInt"."sumAccrBal" IS 'Sum accrued interest balance';
COMMENT ON COLUMN "posn_bkInt"."sumIntPd" IS 'Sum of interest paid on position';
COMMENT ON COLUMN "posn_bkInt"."sumWthFed" IS 'Sum of federal withholding on position';
COMMENT ON COLUMN "posn_bkInt"."sumWthState" IS 'Sum of state withholding on position';
COMMENT ON COLUMN "posn_bkInt"."version" IS 'Interest component version';


-- Creating Table posn_bkInt_hist
DROP TABLE IF EXISTS "posn_bkInt_hist";
CREATE TABLE "posn_bkInt_hist" (
    "_Id" varchar(42)  NOT NULL ,
    "_isDel" boolean  DEFAULT NULL,
    "_isExc" boolean  DEFAULT NULL,
    "_pList" jsonb  DEFAULT NULL,
    "_ts" timestamptz  DEFAULT NULL,
    "_vList" jsonb  DEFAULT NULL,
    "_vn" varchar(42)  NOT NULL ,
    "accumToDtm" timestamptz  NOT NULL ,
    "lastPostDtm" timestamptz  DEFAULT NULL,
    "logRef" varchar(42)  DEFAULT NULL,
    "nextPostDtm" timestamptz  NOT NULL ,
    "nomRate" decimal(16,5)   DEFAULT NULL,
    "promoExpDtm" timestamptz  DEFAULT NULL,
    "sumAccrBal" decimal(16,5)   DEFAULT NULL,
    "sumIntPd" decimal(16,2)   DEFAULT NULL,
    "sumWthFed" decimal(16,2)   DEFAULT NULL,
    "sumWthState" decimal(16,2)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_vn")
); 
COMMENT ON COLUMN "posn_bkInt_hist"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkInt_hist"."_isDel" IS '';
COMMENT ON COLUMN "posn_bkInt_hist"."_isExc" IS '';
COMMENT ON COLUMN "posn_bkInt_hist"."_pList" IS '';
COMMENT ON COLUMN "posn_bkInt_hist"."_ts" IS '';
COMMENT ON COLUMN "posn_bkInt_hist"."_vList" IS '';
COMMENT ON COLUMN "posn_bkInt_hist"."_vn" IS '';
COMMENT ON COLUMN "posn_bkInt_hist"."accumToDtm" IS 'Accrued interest accumulated through datetime';
COMMENT ON COLUMN "posn_bkInt_hist"."lastPostDtm" IS 'Date interest was last posted';
COMMENT ON COLUMN "posn_bkInt_hist"."logRef" IS '';
COMMENT ON COLUMN "posn_bkInt_hist"."nextPostDtm" IS 'Date interest next posted';
COMMENT ON COLUMN "posn_bkInt_hist"."nomRate" IS 'Current nominal interest rate';
COMMENT ON COLUMN "posn_bkInt_hist"."promoExpDtm" IS 'Date promotional interest rate expires and position reverts to standard rate';
COMMENT ON COLUMN "posn_bkInt_hist"."sumAccrBal" IS 'Sum accrued interest balance';
COMMENT ON COLUMN "posn_bkInt_hist"."sumIntPd" IS 'Sum of interest paid on position';
COMMENT ON COLUMN "posn_bkInt_hist"."sumWthFed" IS 'Sum of federal withholding on position';
COMMENT ON COLUMN "posn_bkInt_hist"."sumWthState" IS 'Sum of state withholding on position';


-- Creating Table posn_bkLimits
DROP TABLE IF EXISTS "posn_bkLimits";
CREATE TABLE "posn_bkLimits" (
    "_Id" varchar(42)  NOT NULL ,
    "_asOfDt" timestamptz  DEFAULT NULL,
    "_cDt" timestamptz  DEFAULT NULL,
    "_dDt" timestamptz  DEFAULT NULL,
    "_uDt" timestamptz  DEFAULT NULL,
    "accumTrnLimits" jsonb  DEFAULT NULL,
    "componentName" varchar(30)   NOT NULL ,
    "deminimisAmt" decimal(16,2)   DEFAULT NULL,
    "logRef" varchar(42)  DEFAULT NULL,
    "maxPosnBal" decimal(16,2)   DEFAULT NULL,
    "minPosnBal" decimal(16,2)   DEFAULT NULL,
    "minToOpen" decimal(16,2)   DEFAULT NULL,
    "perTrnLimits" jsonb  DEFAULT NULL,
    "restrictCr" boolean  DEFAULT NULL,
    "restrictCrFundExp" boolean  DEFAULT NULL,
    "restrictDr" boolean  DEFAULT NULL,
    "version" integer  NOT NULL  check ("version" >= 0),
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "posn_bkLimits"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkLimits"."_asOfDt" IS 'AsOf Time Stamp';
COMMENT ON COLUMN "posn_bkLimits"."_cDt" IS 'Create Time Stamp';
COMMENT ON COLUMN "posn_bkLimits"."_dDt" IS 'Delete Time Stamp';
COMMENT ON COLUMN "posn_bkLimits"."_uDt" IS 'Update Time Stamp';
COMMENT ON COLUMN "posn_bkLimits"."accumTrnLimits" IS 'Limits on groups of transactions by period';
COMMENT ON COLUMN "posn_bkLimits"."componentName" IS 'Limits component name';
COMMENT ON COLUMN "posn_bkLimits"."deminimisAmt" IS 'Insignificant amount which the position may be negative before it is considered overdrawn';
COMMENT ON COLUMN "posn_bkLimits"."logRef" IS 'LogId of action that resulted in change';
COMMENT ON COLUMN "posn_bkLimits"."maxPosnBal" IS 'Maximum allowable position balance';
COMMENT ON COLUMN "posn_bkLimits"."minPosnBal" IS 'Minimum allowable position balance';
COMMENT ON COLUMN "posn_bkLimits"."minToOpen" IS 'Minimum deposit amount that must be met to open the position';
COMMENT ON COLUMN "posn_bkLimits"."perTrnLimits" IS 'Limits on single transactions';
COMMENT ON COLUMN "posn_bkLimits"."restrictCr" IS 'Restrict all credits to position except during a grace period';
COMMENT ON COLUMN "posn_bkLimits"."restrictCrFundExp" IS 'Restrict all credits after the funding expiration date';
COMMENT ON COLUMN "posn_bkLimits"."restrictDr" IS 'Restrict all debits to position';
COMMENT ON COLUMN "posn_bkLimits"."version" IS 'Limits component version';


-- Creating Table posn_bkLimits_hist
DROP TABLE IF EXISTS "posn_bkLimits_hist";
CREATE TABLE "posn_bkLimits_hist" (
    "_Id" varchar(42)  NOT NULL ,
    "_isDel" boolean  DEFAULT NULL,
    "_isExc" boolean  DEFAULT NULL,
    "_pList" jsonb  DEFAULT NULL,
    "_ts" timestamptz  DEFAULT NULL,
    "_vList" jsonb  DEFAULT NULL,
    "_vn" varchar(42)  NOT NULL ,
    "deminimisAmt" decimal(16,2)   DEFAULT NULL,
    "logRef" varchar(42)  DEFAULT NULL,
    "maxPosnBal" decimal(16,2)   DEFAULT NULL,
    "minPosnBal" decimal(16,2)   DEFAULT NULL,
    "minToOpen" decimal(16,2)   DEFAULT NULL,
    "restrictCr" boolean  DEFAULT NULL,
    "restrictCrFundExp" boolean  DEFAULT NULL,
    "restrictDr" boolean  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_vn")
); 
COMMENT ON COLUMN "posn_bkLimits_hist"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkLimits_hist"."_isDel" IS '';
COMMENT ON COLUMN "posn_bkLimits_hist"."_isExc" IS '';
COMMENT ON COLUMN "posn_bkLimits_hist"."_pList" IS '';
COMMENT ON COLUMN "posn_bkLimits_hist"."_ts" IS '';
COMMENT ON COLUMN "posn_bkLimits_hist"."_vList" IS '';
COMMENT ON COLUMN "posn_bkLimits_hist"."_vn" IS '';
COMMENT ON COLUMN "posn_bkLimits_hist"."deminimisAmt" IS 'Insignificant amount which the position may be negative before it is considered overdrawn';
COMMENT ON COLUMN "posn_bkLimits_hist"."logRef" IS '';
COMMENT ON COLUMN "posn_bkLimits_hist"."maxPosnBal" IS 'Maximum allowable position balance';
COMMENT ON COLUMN "posn_bkLimits_hist"."minPosnBal" IS 'Minimum allowable position balance';
COMMENT ON COLUMN "posn_bkLimits_hist"."minToOpen" IS 'Minimum deposit amount that must be met to open the position';
COMMENT ON COLUMN "posn_bkLimits_hist"."restrictCr" IS 'Restrict all credits to position except during a grace period';
COMMENT ON COLUMN "posn_bkLimits_hist"."restrictCrFundExp" IS 'Restrict all credits after the funding expiration date';
COMMENT ON COLUMN "posn_bkLimits_hist"."restrictDr" IS 'Restrict all debits to position';


-- Creating Table posn_bkNsf
DROP TABLE IF EXISTS "posn_bkNsf";
CREATE TABLE "posn_bkNsf" (
    "_Id" varchar(42)  NOT NULL ,
    "isOptIn" boolean  NOT NULL  DEFAULT false,
    "negLimit" decimal(16,2)   DEFAULT 0,
    "nsfCnt" int  DEFAULT NULL,
    "nsfFee" decimal(16,2)   DEFAULT NULL,
    "returnCnt" int  DEFAULT NULL,
    "returnFee" decimal(16,2)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "posn_bkNsf"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkNsf"."isOptIn" IS 'Flag whether to overdraft and pay';
COMMENT ON COLUMN "posn_bkNsf"."negLimit" IS 'Negative balance limit allowed before return';
COMMENT ON COLUMN "posn_bkNsf"."nsfCnt" IS 'Number of time NSF total count';
COMMENT ON COLUMN "posn_bkNsf"."nsfFee" IS 'Cumulative NSF fee amount';
COMMENT ON COLUMN "posn_bkNsf"."returnCnt" IS 'Number of time returned total count';
COMMENT ON COLUMN "posn_bkNsf"."returnFee" IS 'Cumulative NSF returned amount';


-- Creating Table posn_bkTd
DROP TABLE IF EXISTS "posn_bkTd";
CREATE TABLE "posn_bkTd" (
    "_Id" varchar(42)  NOT NULL ,
    "_asOfDt" timestamptz  DEFAULT NULL,
    "_cDt" timestamptz  DEFAULT NULL,
    "_dDt" timestamptz  DEFAULT NULL,
    "_uDt" timestamptz  DEFAULT NULL,
    "componentName" varchar(30)   NOT NULL ,
    "crTermExt" varchar(255)   DEFAULT NULL,
    "earlyDrPen" smallint  DEFAULT NULL check ("earlyDrPen" >= 0),
    "expCrGraceDtm" timestamptz  DEFAULT NULL,
    "expDrGraceDtm" timestamptz  DEFAULT NULL,
    "initTerm" varchar(255)   NOT NULL ,
    "intMatrix" varchar(255)   DEFAULT NULL,
    "intRate" decimal(16,5)   DEFAULT NULL,
    "lastRollDtm" timestamptz  DEFAULT NULL,
    "logRef" varchar(42)  DEFAULT NULL,
    "matDisbmtInstr" jsonb  DEFAULT NULL,
    "maturityDtm" timestamptz  NOT NULL ,
    "maturityOpt" smallint  DEFAULT NULL check ("maturityOpt" >= 0),
    "notice" varchar(255)   DEFAULT NULL,
    "noticeDtm" timestamptz  DEFAULT NULL,
    "origRollDtm" timestamptz  DEFAULT NULL,
    "penMatrix" varchar(255)   DEFAULT NULL,
    "rateSchedMatrix" varchar(255)   DEFAULT NULL,
    "rollCnt" smallint  DEFAULT 0 check ("rollCnt" >= 0),
    "rollCrGrace" varchar(255)   DEFAULT NULL,
    "rollDrGraceAdj" smallint  DEFAULT NULL check ("rollDrGraceAdj" >= 0),
    "rollGracePd" varchar(255)   DEFAULT NULL,
    "rollGraceRate" varchar(255)   DEFAULT NULL,
    "rollProd" varchar(255)   DEFAULT NULL,
    "term" varchar(255)   DEFAULT NULL,
    "version" integer  NOT NULL  check ("version" >= 0),
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "posn_bkTd"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkTd"."_asOfDt" IS 'AsOf Time Stamp';
COMMENT ON COLUMN "posn_bkTd"."_cDt" IS 'Create Time Stamp';
COMMENT ON COLUMN "posn_bkTd"."_dDt" IS 'Delete Time Stamp';
COMMENT ON COLUMN "posn_bkTd"."_uDt" IS 'Update Time Stamp';
COMMENT ON COLUMN "posn_bkTd"."componentName" IS 'Term component name';
COMMENT ON COLUMN "posn_bkTd"."crTermExt" IS 'Extension to the maturity date when credits are made outside the rollover credit grace period';
COMMENT ON COLUMN "posn_bkTd"."earlyDrPen" IS 'Method used to calculate an early withdrawal penalty';
COMMENT ON COLUMN "posn_bkTd"."expCrGraceDtm" IS 'Credit expiration date and time for the current term';
COMMENT ON COLUMN "posn_bkTd"."expDrGraceDtm" IS 'Debit expiration date and time for the current term';
COMMENT ON COLUMN "posn_bkTd"."initTerm" IS 'Initial term';
COMMENT ON COLUMN "posn_bkTd"."intMatrix" IS 'Matrix used to determine interest rate';
COMMENT ON COLUMN "posn_bkTd"."intRate" IS 'Fixed interest rate';
COMMENT ON COLUMN "posn_bkTd"."lastRollDtm" IS 'Date and time the position last rolled over';
COMMENT ON COLUMN "posn_bkTd"."logRef" IS 'LogId of action that resulted in change';
COMMENT ON COLUMN "posn_bkTd"."matDisbmtInstr" IS 'Customer instructions for payment of principal and interest not capitalized at maturity';
COMMENT ON COLUMN "posn_bkTd"."maturityDtm" IS 'Date and time the position will mature';
COMMENT ON COLUMN "posn_bkTd"."maturityOpt" IS 'Maturity option';
COMMENT ON COLUMN "posn_bkTd"."notice" IS 'Notification period prior to maturity';
COMMENT ON COLUMN "posn_bkTd"."noticeDtm" IS 'Date and time of next maturity notification';
COMMENT ON COLUMN "posn_bkTd"."origRollDtm" IS 'Date and time the position first rolled over';
COMMENT ON COLUMN "posn_bkTd"."penMatrix" IS 'Provides values used in early withdrawal penalty calculation';
COMMENT ON COLUMN "posn_bkTd"."rateSchedMatrix" IS 'Matrix used to determine term';
COMMENT ON COLUMN "posn_bkTd"."rollCnt" IS 'Number of times the position has rolled over';
COMMENT ON COLUMN "posn_bkTd"."rollCrGrace" IS 'Period after rollover where deposits can be made without extending the term';
COMMENT ON COLUMN "posn_bkTd"."rollDrGraceAdj" IS 'Adjustment to accrued interest on funds withdrawn during grace period';
COMMENT ON COLUMN "posn_bkTd"."rollGracePd" IS 'Period after rollover when withdrawals can be made without penalty';
COMMENT ON COLUMN "posn_bkTd"."rollGraceRate" IS 'Matrix used to determine accrual adjustment rate for withdrawals during debit grace period';
COMMENT ON COLUMN "posn_bkTd"."rollProd" IS 'Product the term deposit rolling over rolls into';
COMMENT ON COLUMN "posn_bkTd"."term" IS 'Term assigned to position';
COMMENT ON COLUMN "posn_bkTd"."version" IS 'Term component version';


-- Creating Table posn_bkTd_hist
DROP TABLE IF EXISTS "posn_bkTd_hist";
CREATE TABLE "posn_bkTd_hist" (
    "_Id" varchar(42)  NOT NULL ,
    "_isDel" boolean  DEFAULT NULL,
    "_isExc" boolean  DEFAULT NULL,
    "_pList" jsonb  DEFAULT NULL,
    "_ts" timestamptz  DEFAULT NULL,
    "_vList" jsonb  DEFAULT NULL,
    "_vn" varchar(42)  NOT NULL ,
    "expCrGraceDtm" timestamptz  DEFAULT NULL,
    "expDrGraceDtm" timestamptz  DEFAULT NULL,
    "lastRollDtm" timestamptz  DEFAULT NULL,
    "logRef" varchar(42)  DEFAULT NULL,
    "maturityDtm" timestamptz  NOT NULL ,
    "rollCnt" smallint  DEFAULT 0 check ("rollCnt" >= 0),
    
    PRIMARY KEY ("_Id", "_vn")
); 
COMMENT ON COLUMN "posn_bkTd_hist"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_bkTd_hist"."_isDel" IS '';
COMMENT ON COLUMN "posn_bkTd_hist"."_isExc" IS '';
COMMENT ON COLUMN "posn_bkTd_hist"."_pList" IS '';
COMMENT ON COLUMN "posn_bkTd_hist"."_ts" IS '';
COMMENT ON COLUMN "posn_bkTd_hist"."_vList" IS '';
COMMENT ON COLUMN "posn_bkTd_hist"."_vn" IS '';
COMMENT ON COLUMN "posn_bkTd_hist"."expCrGraceDtm" IS 'Credit expiration date and time for the current term';
COMMENT ON COLUMN "posn_bkTd_hist"."expDrGraceDtm" IS 'Debit expiration date and time for the current term';
COMMENT ON COLUMN "posn_bkTd_hist"."lastRollDtm" IS 'Date and time the position last rolled over';
COMMENT ON COLUMN "posn_bkTd_hist"."logRef" IS '';
COMMENT ON COLUMN "posn_bkTd_hist"."maturityDtm" IS 'Date and time the position will mature';
COMMENT ON COLUMN "posn_bkTd_hist"."rollCnt" IS 'Number of times the position has rolled over';


-- Creating Table posn_gl
DROP TABLE IF EXISTS "posn_gl";
CREATE TABLE "posn_gl" (
    "_Id" varchar(42)  NOT NULL ,
    "_asOfDt" timestamptz  DEFAULT NULL,
    "_cDt" timestamptz  DEFAULT NULL,
    "_dDt" timestamptz  DEFAULT NULL,
    "_uDt" timestamptz  DEFAULT NULL,
    "ccyCode" varchar(3)   NOT NULL  DEFAULT 'USD',
    "company" integer  DEFAULT 0 check ("company" >= 0),
    "deptId" integer  DEFAULT 0 check ("deptId" >= 0),
    "glCat" smallint  NOT NULL  check ("glCat" >= 0),
    "logRef" varchar(42)  DEFAULT NULL,
    "vertical" int  DEFAULT 0,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "posn_gl"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_gl"."_asOfDt" IS 'AsOf Time Stamp';
COMMENT ON COLUMN "posn_gl"."_cDt" IS 'Create Time Stamp';
COMMENT ON COLUMN "posn_gl"."_dDt" IS 'Delete Time Stamp';
COMMENT ON COLUMN "posn_gl"."_uDt" IS 'Update Time Stamp';
COMMENT ON COLUMN "posn_gl"."ccyCode" IS 'Currency code';
COMMENT ON COLUMN "posn_gl"."company" IS 'Company reported';
COMMENT ON COLUMN "posn_gl"."deptId" IS 'Balancing department or cost center Id';
COMMENT ON COLUMN "posn_gl"."glCat" IS 'GL category code';
COMMENT ON COLUMN "posn_gl"."logRef" IS 'LogId of action that resulted in change';
COMMENT ON COLUMN "posn_gl"."vertical" IS 'Vertical reported';


-- Creating Table posn_gl_hist
DROP TABLE IF EXISTS "posn_gl_hist";
CREATE TABLE "posn_gl_hist" (
    "_Id" varchar(42)  NOT NULL ,
    "_isDel" boolean  DEFAULT NULL,
    "_isExc" boolean  DEFAULT NULL,
    "_pList" jsonb  DEFAULT NULL,
    "_ts" timestamptz  DEFAULT NULL,
    "_vList" jsonb  DEFAULT NULL,
    "_vn" varchar(42)  NOT NULL ,
    "logRef" varchar(42)  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_vn")
); 
COMMENT ON COLUMN "posn_gl_hist"."_Id" IS 'Unique position identifier';
COMMENT ON COLUMN "posn_gl_hist"."_isDel" IS '';
COMMENT ON COLUMN "posn_gl_hist"."_isExc" IS '';
COMMENT ON COLUMN "posn_gl_hist"."_pList" IS '';
COMMENT ON COLUMN "posn_gl_hist"."_ts" IS '';
COMMENT ON COLUMN "posn_gl_hist"."_vList" IS '';
COMMENT ON COLUMN "posn_gl_hist"."_vn" IS '';
COMMENT ON COLUMN "posn_gl_hist"."logRef" IS '';


-- Creating Table prodGroup
DROP TABLE IF EXISTS "prodGroup";
CREATE TABLE "prodGroup" (
    "accrCalcTm" varchar(255)   DEFAULT NULL,
    "desc" varchar(30)   DEFAULT NULL,
    "drBalGrace" varchar(255)   DEFAULT NULL,
    "glCat" smallint  DEFAULT NULL check ("glCat" >= 0),
    "glSetCode" varchar(20)   DEFAULT NULL,
    "isRegD" boolean  DEFAULT NULL,
    "prodGroup" varchar(10)   NOT NULL ,
    "prodSubType" varchar(10)   NOT NULL ,
    "prodType" varchar(10)   NOT NULL ,
    "rollGraceRate" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("prodType", "prodSubType", "prodGroup")
); 
COMMENT ON COLUMN "prodGroup"."accrCalcTm" IS 'Time of day used to determine position balance for calculating interest';
COMMENT ON COLUMN "prodGroup"."desc" IS 'Product group description';
COMMENT ON COLUMN "prodGroup"."drBalGrace" IS 'Time of day the debit balance grace period ends';
COMMENT ON COLUMN "prodGroup"."glCat" IS 'GL category code';
COMMENT ON COLUMN "prodGroup"."glSetCode" IS 'General ledger acccounts used for reporting';
COMMENT ON COLUMN "prodGroup"."isRegD" IS 'Indicates whether or not product positions are subject to Regulation D';
COMMENT ON COLUMN "prodGroup"."prodGroup" IS 'The product group (level 3) within prodType and prodSubType';
COMMENT ON COLUMN "prodGroup"."prodSubType" IS 'The sub-type classification  (level 2) within prodType';
COMMENT ON COLUMN "prodGroup"."prodType" IS 'The product class in prodType (e.g., deposits, loans)';
COMMENT ON COLUMN "prodGroup"."rollGraceRate" IS 'Matrix used to determine accrual adjustment rate for withdrawals during debit grace period';


-- Creating Table prodSubType
DROP TABLE IF EXISTS "prodSubType";
CREATE TABLE "prodSubType" (
    "accrCalcTm" varchar(255)   DEFAULT NULL,
    "desc" varchar(255)   DEFAULT NULL,
    "drBalGrace" varchar(255)   DEFAULT NULL,
    "glSetCode" varchar(20)   DEFAULT NULL,
    "isRegD" boolean  DEFAULT NULL,
    "prodSubType" varchar(10)   NOT NULL ,
    "prodType" varchar(10)   NOT NULL ,
    "stmtFreq" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("prodType", "prodSubType")
); 
COMMENT ON COLUMN "prodSubType"."accrCalcTm" IS 'Time of day used to determine position balance for calcuting interest';
COMMENT ON COLUMN "prodSubType"."desc" IS 'Product sub-type description';
COMMENT ON COLUMN "prodSubType"."drBalGrace" IS 'Time of day the debit balance grace period ends';
COMMENT ON COLUMN "prodSubType"."glSetCode" IS 'General ledger acccounts used for reporting';
COMMENT ON COLUMN "prodSubType"."isRegD" IS 'Indicates whether or not product positions are subject to Regulation D';
COMMENT ON COLUMN "prodSubType"."prodSubType" IS 'The product subtype (level 2) within prodType';
COMMENT ON COLUMN "prodSubType"."prodType" IS 'The product type in prodType (e.g., deposits, loans, etc.)';
COMMENT ON COLUMN "prodSubType"."stmtFreq" IS 'Default frequency to create a position statement';


-- Creating Table prodType
DROP TABLE IF EXISTS "prodType";
CREATE TABLE "prodType" (
    "desc" varchar(20)   DEFAULT NULL,
    "prodType" varchar(10)   NOT NULL ,
    
    PRIMARY KEY ("prodType")
); 
COMMENT ON COLUMN "prodType"."desc" IS 'Product type description';
COMMENT ON COLUMN "prodType"."prodType" IS 'First level product type roll up';


-- Creating Table prod_bk
DROP TABLE IF EXISTS "prod_bk";
CREATE TABLE "prod_bk" (
    "avlEndDtm" timestamptz  DEFAULT NULL,
    "avlStartDtm" timestamptz  DEFAULT NULL,
    "ccyCode" varchar(3)   DEFAULT 'USD',
    "components" jsonb  DEFAULT NULL,
    "desc" varchar(255)   DEFAULT NULL,
    "fundTerm" varchar(255)   DEFAULT NULL,
    "glCat" smallint  DEFAULT NULL check ("glCat" >= 0),
    "glSetCode" varchar(20)   DEFAULT NULL,
    "ifxAcctType" varchar(255)   DEFAULT NULL,
    "isFedExempt" boolean  DEFAULT NULL,
    "isRegD" boolean  DEFAULT NULL,
    "isStateExempt" boolean  DEFAULT NULL,
    "logRef" varchar(42)  DEFAULT NULL,
    "name" varchar(30)   NOT NULL ,
    "prodGroup" varchar(10)   DEFAULT NULL,
    "prodSubType" varchar(10)   DEFAULT NULL,
    "prodType" varchar(10)   DEFAULT NULL,
    "stmtFreq" varchar(255)   DEFAULT NULL,
    "version" integer  DEFAULT NULL check ("version" >= 0),
    
    PRIMARY KEY ("name")
); 
COMMENT ON COLUMN "prod_bk"."avlEndDtm" IS 'Date and time product is no longer offered and new positions cannot be opened';
COMMENT ON COLUMN "prod_bk"."avlStartDtm" IS 'Date and time product is first offered and new positions may be opened';
COMMENT ON COLUMN "prod_bk"."ccyCode" IS 'Currency code';
COMMENT ON COLUMN "prod_bk"."components" IS 'Position components list segmented into posn_bk<component> classes';
COMMENT ON COLUMN "prod_bk"."desc" IS 'Product type description';
COMMENT ON COLUMN "prod_bk"."fundTerm" IS 'Window beginning at position opening during which position must be funded';
COMMENT ON COLUMN "prod_bk"."glCat" IS 'GL category code';
COMMENT ON COLUMN "prod_bk"."glSetCode" IS 'General ledger acccounts used for reporting';
COMMENT ON COLUMN "prod_bk"."ifxAcctType" IS 'Assigns account to a generally recognized industry standard category';
COMMENT ON COLUMN "prod_bk"."isFedExempt" IS 'Is exempt from federal withholding';
COMMENT ON COLUMN "prod_bk"."isRegD" IS 'Indicates whether or not product positions are subject to Regulation D';
COMMENT ON COLUMN "prod_bk"."isStateExempt" IS 'Is exempt from state withholding';
COMMENT ON COLUMN "prod_bk"."logRef" IS 'Product created log reference';
COMMENT ON COLUMN "prod_bk"."name" IS 'Product name';
COMMENT ON COLUMN "prod_bk"."prodGroup" IS 'Product group name';
COMMENT ON COLUMN "prod_bk"."prodSubType" IS 'The product sub-type within prodType';
COMMENT ON COLUMN "prod_bk"."prodType" IS 'Product type name';
COMMENT ON COLUMN "prod_bk"."stmtFreq" IS 'Default frequency to create a position statement';
COMMENT ON COLUMN "prod_bk"."version" IS 'Product type version';


-- Creating Table restrict
DROP TABLE IF EXISTS "restrict";
CREATE TABLE "restrict" (
    "_Id" varchar(42)  NOT NULL ,
    "acctGroup" integer  DEFAULT NULL check ("acctGroup" >= 0),
    "acctNbr" varchar(20)   DEFAULT NULL,
    "cancelDtm" timestamptz  DEFAULT NULL,
    "doc" jsonb  DEFAULT NULL,
    "endDtm" timestamptz  DEFAULT NULL,
    "level" smallint  DEFAULT NULL check ("level" >= 0),
    "note" text  DEFAULT NULL,
    "partyId" varchar(42)  DEFAULT NULL,
    "posnId" varchar(42)  DEFAULT NULL,
    "restrictCode" smallint  DEFAULT NULL check ("restrictCode" >= 0),
    "startDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "restrict"."_Id" IS 'Unique Restriction identifier';
COMMENT ON COLUMN "restrict"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "restrict"."acctNbr" IS 'The unique account identifier within an acctGroup';
COMMENT ON COLUMN "restrict"."cancelDtm" IS 'Date and time Restriction was cancelled';
COMMENT ON COLUMN "restrict"."doc" IS 'Documents to support the restriction placement';
COMMENT ON COLUMN "restrict"."endDtm" IS 'Date and time Restriction will expire, default 10/15/2114-23:59';
COMMENT ON COLUMN "restrict"."level" IS 'The level at which the restriction being placed';
COMMENT ON COLUMN "restrict"."note" IS 'Free form accompanying note';
COMMENT ON COLUMN "restrict"."partyId" IS 'Unique Party identifier';
COMMENT ON COLUMN "restrict"."posnId" IS 'Restriction placed on position';
COMMENT ON COLUMN "restrict"."restrictCode" IS 'The Restriction type code';
COMMENT ON COLUMN "restrict"."startDtm" IS 'Date and time Restriction will start, default immediately';


-- Creating Table restrictReason
DROP TABLE IF EXISTS "restrictReason";
CREATE TABLE "restrictReason" (
    "desc" varchar(255)   NOT NULL ,
    "operRoleIncl" varchar(20)   DEFAULT NULL,
    "prodGroupIncl" varchar(10)   DEFAULT NULL,
    "prodSubTypeIncl" varchar(10)   DEFAULT NULL,
    "prodTypeIncl" varchar(10)   DEFAULT NULL,
    "reason" smallint  NOT NULL  check ("reason" >= 0),
    "validEntities" jsonb  NOT NULL ,
    
    PRIMARY KEY ("reason")
); 
COMMENT ON COLUMN "restrictReason"."desc" IS 'Restriction reason description';
COMMENT ON COLUMN "restrictReason"."operRoleIncl" IS 'User role';
COMMENT ON COLUMN "restrictReason"."prodGroupIncl" IS 'Name of product group for which reason is valid';
COMMENT ON COLUMN "restrictReason"."prodSubTypeIncl" IS 'Name of product sub-type for which reason is valid';
COMMENT ON COLUMN "restrictReason"."prodTypeIncl" IS 'Name of product type for which reason is valid';
COMMENT ON COLUMN "restrictReason"."reason" IS 'The restriction reason code number';
COMMENT ON COLUMN "restrictReason"."validEntities" IS '';


-- Creating Table restrictReasonOperExcl
DROP TABLE IF EXISTS "restrictReasonOperExcl";
CREATE TABLE "restrictReasonOperExcl" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "operation" varchar(20)   DEFAULT NULL,
    "reason" smallint  NOT NULL  check ("reason" >= 0),
    
    PRIMARY KEY ("reason", "_Ix")
); 
COMMENT ON COLUMN "restrictReasonOperExcl"."_Ix" IS '_Ix for Field operExcl';
COMMENT ON COLUMN "restrictReasonOperExcl"."operation" IS 'Operations, e.g., APIs, functions';
COMMENT ON COLUMN "restrictReasonOperExcl"."reason" IS 'The restriction reason code number';


-- Creating Table restrictReasonOperIncl
DROP TABLE IF EXISTS "restrictReasonOperIncl";
CREATE TABLE "restrictReasonOperIncl" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "operation" varchar(20)   DEFAULT NULL,
    "reason" smallint  NOT NULL  check ("reason" >= 0),
    
    PRIMARY KEY ("reason", "_Ix")
); 
COMMENT ON COLUMN "restrictReasonOperIncl"."_Ix" IS '_Ix for Field operIncl';
COMMENT ON COLUMN "restrictReasonOperIncl"."operation" IS 'Operations, e.g., APIs, functions';
COMMENT ON COLUMN "restrictReasonOperIncl"."reason" IS 'The restriction reason code number';


-- Creating Table restrictReasonOperRoleExcl
DROP TABLE IF EXISTS "restrictReasonOperRoleExcl";
CREATE TABLE "restrictReasonOperRoleExcl" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "reason" smallint  NOT NULL  check ("reason" >= 0),
    "role" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("reason", "_Ix")
); 
COMMENT ON COLUMN "restrictReasonOperRoleExcl"."_Ix" IS '_Ix for Field operRoleExcl';
COMMENT ON COLUMN "restrictReasonOperRoleExcl"."reason" IS 'The restriction reason code number';
COMMENT ON COLUMN "restrictReasonOperRoleExcl"."role" IS 'User role';


-- Creating Table restrictReasonTrnCodeExcl
DROP TABLE IF EXISTS "restrictReasonTrnCodeExcl";
CREATE TABLE "restrictReasonTrnCodeExcl" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "reason" smallint  NOT NULL  check ("reason" >= 0),
    "trnCode" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("reason", "_Ix")
); 
COMMENT ON COLUMN "restrictReasonTrnCodeExcl"."_Ix" IS '_Ix for Field trnCodeExcl';
COMMENT ON COLUMN "restrictReasonTrnCodeExcl"."reason" IS 'The restriction reason code number';
COMMENT ON COLUMN "restrictReasonTrnCodeExcl"."trnCode" IS 'Transaction code';


-- Creating Table restrictReasonTrnCodeIncl
DROP TABLE IF EXISTS "restrictReasonTrnCodeIncl";
CREATE TABLE "restrictReasonTrnCodeIncl" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "reason" smallint  NOT NULL  check ("reason" >= 0),
    "trnCode" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("reason", "_Ix")
); 
COMMENT ON COLUMN "restrictReasonTrnCodeIncl"."_Ix" IS '_Ix for Field trnCodeIncl';
COMMENT ON COLUMN "restrictReasonTrnCodeIncl"."reason" IS 'The restriction reason code number';
COMMENT ON COLUMN "restrictReasonTrnCodeIncl"."trnCode" IS 'Transaction code';


-- Creating Table restrictReasonTrnCodeRoleExcl
DROP TABLE IF EXISTS "restrictReasonTrnCodeRoleExcl";
CREATE TABLE "restrictReasonTrnCodeRoleExcl" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "reason" smallint  NOT NULL  check ("reason" >= 0),
    "role" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("reason", "_Ix")
); 
COMMENT ON COLUMN "restrictReasonTrnCodeRoleExcl"."_Ix" IS '_Ix for Field trnCodeRoleExcl';
COMMENT ON COLUMN "restrictReasonTrnCodeRoleExcl"."reason" IS 'The restriction reason code number';
COMMENT ON COLUMN "restrictReasonTrnCodeRoleExcl"."role" IS 'User role';


-- Creating Table restrictReasonTrnCodeRoleIncl
DROP TABLE IF EXISTS "restrictReasonTrnCodeRoleIncl";
CREATE TABLE "restrictReasonTrnCodeRoleIncl" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "reason" smallint  NOT NULL  check ("reason" >= 0),
    "role" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("reason", "_Ix")
); 
COMMENT ON COLUMN "restrictReasonTrnCodeRoleIncl"."_Ix" IS '_Ix for Field trnCodeRoleIncl';
COMMENT ON COLUMN "restrictReasonTrnCodeRoleIncl"."reason" IS 'The restriction reason code number';
COMMENT ON COLUMN "restrictReasonTrnCodeRoleIncl"."role" IS 'User role';


-- Creating Table retryLog
DROP TABLE IF EXISTS "retryLog";
CREATE TABLE "retryLog" (
    "_Id" varchar(42)  NOT NULL ,
    "failCode" varchar(12)   DEFAULT NULL,
    "note" text  DEFAULT NULL,
    "procDtm" timestamptz  DEFAULT NULL,
    "retryDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "retryLog"."_Id" IS 'Unique retry identifier';
COMMENT ON COLUMN "retryLog"."failCode" IS 'Code for reason order process failed';
COMMENT ON COLUMN "retryLog"."note" IS 'reason order failed explanation';
COMMENT ON COLUMN "retryLog"."procDtm" IS 'Order processed on date';
COMMENT ON COLUMN "retryLog"."retryDtm" IS 'Next order retry date';


-- Creating Table role
DROP TABLE IF EXISTS "role";
CREATE TABLE "role" (
    "desc" varchar(255)   DEFAULT NULL,
    "userRole" varchar(20)   NOT NULL ,
    
    PRIMARY KEY ("userRole")
); 
COMMENT ON COLUMN "role"."desc" IS 'User Role Description';
COMMENT ON COLUMN "role"."userRole" IS 'User Role Name';


-- Creating Table rolePermission
DROP TABLE IF EXISTS "rolePermission";
CREATE TABLE "rolePermission" (
    "isPermit" boolean  DEFAULT NULL,
    "operation" varchar(255)   NOT NULL ,
    "userRole" varchar(20)   NOT NULL ,
    
    PRIMARY KEY ("userRole", "operation")
); 
COMMENT ON COLUMN "rolePermission"."isPermit" IS 'Role is permitted to perform operation';
COMMENT ON COLUMN "rolePermission"."operation" IS 'Role';
COMMENT ON COLUMN "rolePermission"."userRole" IS 'User Role Description';


-- Creating Table systemCalendar
DROP TABLE IF EXISTS "systemCalendar";
CREATE TABLE "systemCalendar" (
    "_Id" varchar(42)  NOT NULL ,
    "eventFreq" varchar(255)   DEFAULT NULL,
    "eventType" varchar(20)   DEFAULT NULL,
    "isScheduled" boolean  DEFAULT NULL,
    "name" varchar(20)   DEFAULT NULL,
    "nextSchedDtm" timestamptz  DEFAULT NULL,
    "prevSchedDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "systemCalendar"."_Id" IS 'Unique System Event indetifier';
COMMENT ON COLUMN "systemCalendar"."eventFreq" IS 'System Event frequency';
COMMENT ON COLUMN "systemCalendar"."eventType" IS 'The event type';
COMMENT ON COLUMN "systemCalendar"."isScheduled" IS 'Flag determines whether the event is in process';
COMMENT ON COLUMN "systemCalendar"."name" IS 'The event name';
COMMENT ON COLUMN "systemCalendar"."nextSchedDtm" IS 'Next Schedule Date';
COMMENT ON COLUMN "systemCalendar"."prevSchedDtm" IS 'Previous Schedule Dt';


-- Creating Table systemCalendarArgs
DROP TABLE IF EXISTS "systemCalendarArgs";
CREATE TABLE "systemCalendarArgs" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "key" varchar(30)   DEFAULT NULL,
    "val" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "systemCalendarArgs"."_Id" IS 'Unique System Event indetifier';
COMMENT ON COLUMN "systemCalendarArgs"."_Ix" IS '_Ix for Field args';
COMMENT ON COLUMN "systemCalendarArgs"."key" IS 'Key describing the data for this pairing';
COMMENT ON COLUMN "systemCalendarArgs"."val" IS 'Value associated with key';


-- Creating Table tmZones
DROP TABLE IF EXISTS "tmZones";
CREATE TABLE "tmZones" (
    "tzAbbrev" varchar(3)   NOT NULL ,
    "tzName" varchar(40)   DEFAULT NULL,
    
    PRIMARY KEY ("tzAbbrev")
); 
COMMENT ON COLUMN "tmZones"."tzAbbrev" IS 'Time zone abbreviation';
COMMENT ON COLUMN "tmZones"."tzName" IS 'Time zone name';


-- Creating Table trn
DROP TABLE IF EXISTS "trn";
CREATE TABLE "trn" (
    "_Id" varchar(42)  NOT NULL ,
    "attachments" jsonb  DEFAULT NULL,
    "batchId" varchar(20)   DEFAULT NULL,
    "bill" jsonb  DEFAULT NULL,
    "effectDtm" timestamptz  DEFAULT NULL,
    "eft" jsonb  DEFAULT NULL,
    "glJrnlDate" date  DEFAULT NULL,
    "logRef" varchar(42)  DEFAULT NULL,
    "mode" smallint  DEFAULT NULL check ("mode" >= 0),
    "network" varchar(20)   DEFAULT NULL,
    "note" text  DEFAULT NULL,
    "order" jsonb  DEFAULT NULL,
    "otherProperties" jsonb  DEFAULT NULL,
    "reverse" varchar(42)  DEFAULT NULL,
    "reversedby" varchar(42)  DEFAULT NULL,
    "settleDtm" timestamptz  DEFAULT NULL,
    "sttn" jsonb  DEFAULT NULL,
    "tags" jsonb  DEFAULT NULL,
    "template" jsonb  DEFAULT NULL,
    "trnCode" varchar(20)   DEFAULT NULL,
    "workItem" jsonb  DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "trn"."_Id" IS 'Unique Transaction identifier';
COMMENT ON COLUMN "trn"."attachments" IS 'URI References to attached documents and images';
COMMENT ON COLUMN "trn"."batchId" IS 'For a batch source the object that contains batch detail';
COMMENT ON COLUMN "trn"."bill" IS 'Bill or invoice detail object';
COMMENT ON COLUMN "trn"."effectDtm" IS 'The effective date of the transaction for account processing, can be backdate or future';
COMMENT ON COLUMN "trn"."eft" IS 'Detail information accompanying an EFT ISO8583 transaction';
COMMENT ON COLUMN "trn"."glJrnlDate" IS 'The GL journal date this transaction entry is postting on';
COMMENT ON COLUMN "trn"."logRef" IS 'Unique message log identifier';
COMMENT ON COLUMN "trn"."mode" IS 'The host processing mode';
COMMENT ON COLUMN "trn"."network" IS 'The posting network of this message';
COMMENT ON COLUMN "trn"."note" IS 'Detailed free form transaction notes';
COMMENT ON COLUMN "trn"."order" IS 'Payment, collection or transfer order detail';
COMMENT ON COLUMN "trn"."otherProperties" IS 'Array of additional properties in name:value object pairs';
COMMENT ON COLUMN "trn"."reverse" IS 'Transaction Id to reverse in position history';
COMMENT ON COLUMN "trn"."reversedby" IS 'Transaction ID that reversed this transaction';
COMMENT ON COLUMN "trn"."settleDtm" IS 'The settlement or value date of this transaction';
COMMENT ON COLUMN "trn"."sttn" IS 'Originating station or terminal detail object';
COMMENT ON COLUMN "trn"."tags" IS 'tag name';
COMMENT ON COLUMN "trn"."template" IS 'Template object to initialize transaction entries';
COMMENT ON COLUMN "trn"."trnCode" IS 'The Finxact transaction code';
COMMENT ON COLUMN "trn"."workItem" IS 'Workflow case detail';


-- Creating Table trnEntries
DROP TABLE IF EXISTS "trnEntries";
CREATE TABLE "trnEntries" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "acctGroup" integer  NOT NULL  check ("acctGroup" >= 0),
    "acctNbr" varchar(20)   NOT NULL ,
    "addHold" jsonb  DEFAULT NULL,
    "amt" decimal(16,2)   NOT NULL ,
    "assetClass" bigint  DEFAULT 1 check ("assetClass" >= 0),
    "assetId" varchar(12)   DEFAULT NULL,
    "auth" jsonb  DEFAULT NULL,
    "ccyCode" varchar(3)   DEFAULT 'USD',
    "chk" jsonb  DEFAULT NULL,
    "comment" varchar(60)   DEFAULT NULL,
    "company" integer  DEFAULT 0 check ("company" >= 0),
    "deptId" integer  DEFAULT 0 check ("deptId" >= 0),
    "exch" jsonb  DEFAULT NULL,
    "glDist" jsonb  DEFAULT NULL,
    "glSetCode" varchar(20)   DEFAULT NULL,
    "isContact" boolean  DEFAULT NULL,
    "isDr" boolean  DEFAULT NULL,
    "passbook" jsonb  DEFAULT NULL,
    "posnId" varchar(42)  DEFAULT NULL,
    "posnRef" varchar(30)   DEFAULT NULL,
    "rAndtNbr" varchar(40)   DEFAULT NULL,
    "removeHold" jsonb  DEFAULT NULL,
    "seqNbr" bigint  DEFAULT NULL,
    "src" varchar(60)   DEFAULT NULL,
    "trace" varchar(40)   DEFAULT NULL,
    "vertical" int  DEFAULT 0,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "trnEntries"."_Id" IS 'Unique Transaction identifier';
COMMENT ON COLUMN "trnEntries"."_Ix" IS '_Ix for Field entries';
COMMENT ON COLUMN "trnEntries"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "trnEntries"."acctNbr" IS 'The unique account identifier within an acctGroup';
COMMENT ON COLUMN "trnEntries"."addHold" IS 'Add a hold record';
COMMENT ON COLUMN "trnEntries"."amt" IS 'Amount or quantity of asset exchanged';
COMMENT ON COLUMN "trnEntries"."assetClass" IS 'The asset class of the position';
COMMENT ON COLUMN "trnEntries"."assetId" IS 'Asset identifier within the asset class';
COMMENT ON COLUMN "trnEntries"."auth" IS 'Transaction authorization detail';
COMMENT ON COLUMN "trnEntries"."ccyCode" IS 'Currency code alias {assetClass:1, assetId: curCd}';
COMMENT ON COLUMN "trnEntries"."chk" IS 'Check paid detail';
COMMENT ON COLUMN "trnEntries"."comment" IS 'Short transaction comment';
COMMENT ON COLUMN "trnEntries"."company" IS 'Company reported';
COMMENT ON COLUMN "trnEntries"."deptId" IS 'Balancing department or cost center Id';
COMMENT ON COLUMN "trnEntries"."exch" IS 'Exchange detail';
COMMENT ON COLUMN "trnEntries"."glDist" IS 'Allocate amount to GL category';
COMMENT ON COLUMN "trnEntries"."glSetCode" IS 'GL account numbers set code';
COMMENT ON COLUMN "trnEntries"."isContact" IS 'Update customer contact indicator';
COMMENT ON COLUMN "trnEntries"."isDr" IS 'Is a debit entry to position';
COMMENT ON COLUMN "trnEntries"."passbook" IS 'Passbook detail';
COMMENT ON COLUMN "trnEntries"."posnId" IS 'Unique position identifier is FK to posn PK';
COMMENT ON COLUMN "trnEntries"."posnRef" IS 'The unique position identifier within an acctGroup';
COMMENT ON COLUMN "trnEntries"."rAndtNbr" IS 'The RT number on a deposited check item';
COMMENT ON COLUMN "trnEntries"."removeHold" IS 'Remove a hold record';
COMMENT ON COLUMN "trnEntries"."seqNbr" IS 'Record, row or database sequence number';
COMMENT ON COLUMN "trnEntries"."src" IS 'Customer attributed source of funds for AML analysis';
COMMENT ON COLUMN "trnEntries"."trace" IS 'The unique transaction identifier within the source';
COMMENT ON COLUMN "trnEntries"."vertical" IS 'Vertical reported';


-- Creating Table trnCode
DROP TABLE IF EXISTS "trnCode";
CREATE TABLE "trnCode" (
    "desc" varchar(255)   DEFAULT NULL,
    "isAccumDtl" boolean  DEFAULT NULL,
    "maxEntry" smallint  DEFAULT NULL check ("maxEntry" >= 0),
    "networkExcl" jsonb  DEFAULT NULL,
    "networkIncl" jsonb  DEFAULT NULL,
    "roleExcl" jsonb  DEFAULT NULL,
    "roleIncl" jsonb  DEFAULT NULL,
    "statGroups" jsonb  DEFAULT NULL,
    "trnCode" varchar(20)   NOT NULL ,
    "trnInputs" varchar(255)   DEFAULT NULL,
    
    PRIMARY KEY ("trnCode")
); 
COMMENT ON COLUMN "trnCode"."desc" IS 'Transaction code description';
COMMENT ON COLUMN "trnCode"."isAccumDtl" IS 'A flag that determines if the transaction detail accumulates in summary or in detail';
COMMENT ON COLUMN "trnCode"."maxEntry" IS 'If defined, maximum number of detail entries that are allowed within a trancode instance';
COMMENT ON COLUMN "trnCode"."networkExcl" IS 'network name';
COMMENT ON COLUMN "trnCode"."networkIncl" IS 'Channnel name';
COMMENT ON COLUMN "trnCode"."roleExcl" IS 'Role code excluded to use trancode';
COMMENT ON COLUMN "trnCode"."roleIncl" IS 'Role code allowed to use trancode';
COMMENT ON COLUMN "trnCode"."statGroups" IS 'Group name the statistics are accumulating to';
COMMENT ON COLUMN "trnCode"."trnCode" IS 'Transaction Code';
COMMENT ON COLUMN "trnCode"."trnInputs" IS 'Property name expected in tran';


-- Creating Table trnCodeEntries
DROP TABLE IF EXISTS "trnCodeEntries";
CREATE TABLE "trnCodeEntries" (
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "acctGroup" integer  DEFAULT NULL check ("acctGroup" >= 0),
    "acctNbr" varchar(255)   DEFAULT NULL,
    "addHold" jsonb  DEFAULT NULL,
    "assetClass" varchar(255)   DEFAULT 1,
    "assetId" varchar(255)   DEFAULT NULL,
    "ccyCode" varchar(255)   DEFAULT NULL,
    "comment" varchar(255)   DEFAULT NULL,
    "company" integer  DEFAULT 0 check ("company" >= 0),
    "conFilter" varchar(255)   DEFAULT NULL,
    "deptId" integer  DEFAULT 0 check ("deptId" >= 0),
    "entryInputs" jsonb  DEFAULT NULL,
    "entryName" varchar(20)   DEFAULT NULL,
    "glDist" jsonb  DEFAULT NULL,
    "immutableDflt" varchar(255)   DEFAULT NULL,
    "isContact" varchar(255)   DEFAULT NULL,
    "isDr" varchar(255)   DEFAULT NULL,
    "note" varchar(255)   DEFAULT NULL,
    "posnId" varchar(255)   DEFAULT NULL,
    "removeHold" jsonb  DEFAULT NULL,
    "trnAmt" varchar(255)   DEFAULT NULL,
    "trnCode" varchar(20)   NOT NULL ,
    "vertical" int  DEFAULT 0,
    
    PRIMARY KEY ("trnCode", "_Ix")
); 
COMMENT ON COLUMN "trnCodeEntries"."_Ix" IS '_Ix for Field entries';
COMMENT ON COLUMN "trnCodeEntries"."acctGroup" IS 'Account Group code';
COMMENT ON COLUMN "trnCodeEntries"."acctNbr" IS 'The unique account identifier within an acctGroup';
COMMENT ON COLUMN "trnCodeEntries"."addHold" IS 'Add a hold record';
COMMENT ON COLUMN "trnCodeEntries"."assetClass" IS 'The asset class of the position';
COMMENT ON COLUMN "trnCodeEntries"."assetId" IS 'Unique code or identifier within an assetClass';
COMMENT ON COLUMN "trnCodeEntries"."ccyCode" IS 'ISO 4217 Currency code if assetClass is Cash';
COMMENT ON COLUMN "trnCodeEntries"."comment" IS 'Short transaction comment';
COMMENT ON COLUMN "trnCodeEntries"."company" IS 'Company reported';
COMMENT ON COLUMN "trnCodeEntries"."conFilter" IS 'Expression to evaluate at runtime whether to construct this transaction entry';
COMMENT ON COLUMN "trnCodeEntries"."deptId" IS 'Balancing department or cost center Id';
COMMENT ON COLUMN "trnCodeEntries"."entryInputs" IS 'Property name expected in the tran.entry';
COMMENT ON COLUMN "trnCodeEntries"."entryName" IS 'Unique name identifier for this index of the entries array';
COMMENT ON COLUMN "trnCodeEntries"."glDist" IS 'Allocate amount to GL category';
COMMENT ON COLUMN "trnCodeEntries"."immutableDflt" IS 'Property name that cannot be overwritten from template';
COMMENT ON COLUMN "trnCodeEntries"."isContact" IS 'Update customer contact indicator';
COMMENT ON COLUMN "trnCodeEntries"."isDr" IS 'Is a debit entry to position';
COMMENT ON COLUMN "trnCodeEntries"."note" IS 'Detailed transaction notes';
COMMENT ON COLUMN "trnCodeEntries"."posnId" IS 'Unique position identifier - instance specific';
COMMENT ON COLUMN "trnCodeEntries"."removeHold" IS 'Remove a hold record';
COMMENT ON COLUMN "trnCodeEntries"."trnAmt" IS 'Transaction amount';
COMMENT ON COLUMN "trnCodeEntries"."trnCode" IS 'Transaction Code';
COMMENT ON COLUMN "trnCodeEntries"."vertical" IS 'Vertical reported';


-- Creating Table trnLimits
DROP TABLE IF EXISTS "trnLimits";
CREATE TABLE "trnLimits" (
    "_Id" varchar(42)  NOT NULL ,
    "increCrAmt" decimal(16,2)   DEFAULT NULL,
    "increDrAmt" decimal(16,2)   DEFAULT NULL,
    "maxCrAmt" decimal(16,2)   DEFAULT NULL,
    "maxDrAmt" decimal(16,2)   DEFAULT NULL,
    "minCrAmt" decimal(16,2)   DEFAULT NULL,
    "minDrAmt" decimal(16,2)   DEFAULT NULL,
    "name" varchar(20)   DEFAULT NULL,
    "violationAct" smallint  DEFAULT NULL check ("violationAct" >= 0),
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "trnLimits"."_Id" IS 'Unique per transaction limit identifier';
COMMENT ON COLUMN "trnLimits"."increCrAmt" IS 'Transaction credit amount must be a multiple of this incremental amount';
COMMENT ON COLUMN "trnLimits"."increDrAmt" IS 'Transaction debit amount must be a multiple of this incremental amount';
COMMENT ON COLUMN "trnLimits"."maxCrAmt" IS 'Maximum per transaction credit amount allowed';
COMMENT ON COLUMN "trnLimits"."maxDrAmt" IS 'Maximum per transaction debit amount allowed';
COMMENT ON COLUMN "trnLimits"."minCrAmt" IS 'Minimum per transaction credit amount allowed';
COMMENT ON COLUMN "trnLimits"."minDrAmt" IS 'Minimum per transaction debit amount allowed';
COMMENT ON COLUMN "trnLimits"."name" IS 'Minimums, maximums, and incremental amounts applied per transaction';
COMMENT ON COLUMN "trnLimits"."violationAct" IS '';


-- Creating Table trnLimitsViolationFee
DROP TABLE IF EXISTS "trnLimitsViolationFee";
CREATE TABLE "trnLimitsViolationFee" (
    "_Id" varchar(42)  NOT NULL ,
    "assessAt" smallint  DEFAULT 1 check ("assessAt" >= 0),
    "desc" varchar(255)   DEFAULT NULL,
    "feeAmt" decimal(16,2)   DEFAULT NULL,
    "feeMatrix" varchar(30)   DEFAULT NULL,
    "feeMaxAmt" decimal(16,2)   DEFAULT NULL,
    "feeMinAmt" decimal(16,2)   DEFAULT NULL,
    "feePct" decimal(16,5)   DEFAULT NULL,
    "name" varchar(20)   DEFAULT NULL,
    "nsfFeeBal" smallint  DEFAULT 1 check ("nsfFeeBal" >= 0),
    "trnCode" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "trnLimitsViolationFee"."_Id" IS 'Unique per transaction limit identifier';
COMMENT ON COLUMN "trnLimitsViolationFee"."assessAt" IS 'Defines when fee is assessed';
COMMENT ON COLUMN "trnLimitsViolationFee"."desc" IS 'Fee description';
COMMENT ON COLUMN "trnLimitsViolationFee"."feeAmt" IS 'The fixed fee amount to assess to position';
COMMENT ON COLUMN "trnLimitsViolationFee"."feeMatrix" IS 'Matrix used to determine the fee';
COMMENT ON COLUMN "trnLimitsViolationFee"."feeMaxAmt" IS 'The maximum fee to charge to position per transaction';
COMMENT ON COLUMN "trnLimitsViolationFee"."feeMinAmt" IS 'The minimum fee to charge to position, per transaction';
COMMENT ON COLUMN "trnLimitsViolationFee"."feePct" IS 'Percentage applied to amount to calculate fee';
COMMENT ON COLUMN "trnLimitsViolationFee"."name" IS 'Fee name';
COMMENT ON COLUMN "trnLimitsViolationFee"."nsfFeeBal" IS 'Fee handling when position ledger balance is less than fee amount';
COMMENT ON COLUMN "trnLimitsViolationFee"."trnCode" IS 'Transaction code used to post the fee';


-- Creating Table trnLimitsViolationFeeLimits
DROP TABLE IF EXISTS "trnLimitsViolationFeeLimits";
CREATE TABLE "trnLimitsViolationFeeLimits" (
    "_Id" varchar(42)  NOT NULL ,
    "_Ix" int  NOT NULL  check ("_Ix" >= 0),
    "feeMaxAmt" decimal(16,2)   DEFAULT NULL,
    "feeMaxCnt" smallint  DEFAULT NULL check ("feeMaxCnt" >= 0),
    "freq" varchar(255)   DEFAULT NULL,
    "startDtm" timestamptz  DEFAULT NULL,
    
    PRIMARY KEY ("_Id", "_Ix")
); 
COMMENT ON COLUMN "trnLimitsViolationFeeLimits"."_Id" IS 'Unique per transaction limit identifier';
COMMENT ON COLUMN "trnLimitsViolationFeeLimits"."_Ix" IS '_Ix for Field feeLimits';
COMMENT ON COLUMN "trnLimitsViolationFeeLimits"."feeMaxAmt" IS 'Maximum total fee amount that may be assessed for the period';
COMMENT ON COLUMN "trnLimitsViolationFeeLimits"."feeMaxCnt" IS 'Maximum total count of fees that may be assessed for period';
COMMENT ON COLUMN "trnLimitsViolationFeeLimits"."freq" IS 'Defines the period used to determine whether or not fees exceed maximum allowable';
COMMENT ON COLUMN "trnLimitsViolationFeeLimits"."startDtm" IS 'Start date used to calculate current period';


-- Creating Table trnStats
DROP TABLE IF EXISTS "trnStats";
CREATE TABLE "trnStats" (
    "_Id" varchar(42)  NOT NULL ,
    "accumToDtm" timestamptz  DEFAULT NULL,
    "dateType" bigint  NOT NULL  DEFAULT 0 check ("dateType" >= 0),
    "periodDtm" timestamptz  NOT NULL ,
    "statGroup" varchar(20)   NOT NULL ,
    "totAmtCr" decimal(16,2)   DEFAULT NULL,
    "totAmtDr" decimal(16,2)   DEFAULT NULL,
    "totCntCr" int  DEFAULT NULL check ("totCntCr" >= 0),
    "totCntDr" int  DEFAULT NULL check ("totCntDr" >= 0),
    
    PRIMARY KEY ("_Id", "statGroup", "dateType", "periodDtm")
); 
COMMENT ON COLUMN "trnStats"."_Id" IS 'Position identifier';
COMMENT ON COLUMN "trnStats"."accumToDtm" IS 'Statistics accumulated to high-water';
COMMENT ON COLUMN "trnStats"."dateType" IS 'Date type to accumulate on';
COMMENT ON COLUMN "trnStats"."periodDtm" IS 'The datetime period accumulated to';
COMMENT ON COLUMN "trnStats"."statGroup" IS 'Group name the statistics are accumulating to';
COMMENT ON COLUMN "trnStats"."totAmtCr" IS 'Total Credit amount';
COMMENT ON COLUMN "trnStats"."totAmtDr" IS 'Total Debit amount';
COMMENT ON COLUMN "trnStats"."totCntCr" IS 'Total Credit count';
COMMENT ON COLUMN "trnStats"."totCntDr" IS 'Total Debit count';


-- Creating Table trnStatsGroup
DROP TABLE IF EXISTS "trnStatsGroup";
CREATE TABLE "trnStatsGroup" (
    "accumCr" boolean  DEFAULT NULL,
    "accumDr" boolean  DEFAULT NULL,
    "dateTypes" jsonb  DEFAULT NULL,
    "desc" varchar(255)   DEFAULT NULL,
    "precision" bigint  DEFAULT 4 check ("precision" >= 0),
    "statGroup" varchar(20)   NOT NULL ,
    
    PRIMARY KEY ("statGroup")
); 
COMMENT ON COLUMN "trnStatsGroup"."accumCr" IS 'Flag to accumulate credit transactions';
COMMENT ON COLUMN "trnStatsGroup"."accumDr" IS 'Flag to accumulate debit transactions';
COMMENT ON COLUMN "trnStatsGroup"."dateTypes" IS 'Date type to accumulate on';
COMMENT ON COLUMN "trnStatsGroup"."desc" IS 'Accumulation group description';
COMMENT ON COLUMN "trnStatsGroup"."precision" IS 'Duration between accumulation points';
COMMENT ON COLUMN "trnStatsGroup"."statGroup" IS 'Group name the statistics are accumulating to';


-- Creating Table user
DROP TABLE IF EXISTS "user";
CREATE TABLE "user" (
    "allowedRoles" varchar(20)   DEFAULT NULL,
    "createDtm" timestamptz  DEFAULT NULL,
    "dfltRoles" varchar(20)   DEFAULT NULL,
    "domainId" varchar(42)  NOT NULL ,
    "expDtm" timestamptz  DEFAULT NULL,
    "isProxy" boolean  DEFAULT NULL,
    "isSystem" boolean  DEFAULT NULL,
    "partyId" varchar(42)  DEFAULT NULL,
    "startDtm" timestamptz  NOT NULL ,
    "userId" varchar(40)   NOT NULL ,
    "userName" varchar(80)   NOT NULL ,
    
    PRIMARY KEY ("domainId", "userId")
); 
COMMENT ON COLUMN "user"."allowedRoles" IS 'Role';
COMMENT ON COLUMN "user"."createDtm" IS 'User created on date';
COMMENT ON COLUMN "user"."dfltRoles" IS 'Role';
COMMENT ON COLUMN "user"."domainId" IS 'Unique domain identifier';
COMMENT ON COLUMN "user"."expDtm" IS 'User expires on date';
COMMENT ON COLUMN "user"."isProxy" IS 'User is proxy user';
COMMENT ON COLUMN "user"."isSystem" IS 'User is a system process';
COMMENT ON COLUMN "user"."partyId" IS 'Party within group';
COMMENT ON COLUMN "user"."startDtm" IS 'User valid from date';
COMMENT ON COLUMN "user"."userId" IS 'Unique user identifier within a domain';
COMMENT ON COLUMN "user"."userName" IS 'User name within a domain';


-- Creating Table workItem
DROP TABLE IF EXISTS "workItem";
CREATE TABLE "workItem" (
    "_Id" varchar(42)  NOT NULL ,
    "activity" varchar(20)   DEFAULT NULL,
    "appId" varchar(20)   DEFAULT NULL,
    "caseId" varchar(20)   DEFAULT NULL,
    "caseType" varchar(20)   DEFAULT NULL,
    "note" text  DEFAULT NULL,
    "openDtm" timestamptz  DEFAULT NULL,
    "status" varchar(20)   DEFAULT NULL,
    "step" varchar(20)   DEFAULT NULL,
    "task" varchar(20)   DEFAULT NULL,
    
    PRIMARY KEY ("_Id")
); 
COMMENT ON COLUMN "workItem"."_Id" IS 'The case identifier';
COMMENT ON COLUMN "workItem"."activity" IS 'The case activity';
COMMENT ON COLUMN "workItem"."appId" IS 'The case application identifier';
COMMENT ON COLUMN "workItem"."caseId" IS 'Unique case identifier within apppId';
COMMENT ON COLUMN "workItem"."caseType" IS 'The case type';
COMMENT ON COLUMN "workItem"."note" IS 'Free text case note';
COMMENT ON COLUMN "workItem"."openDtm" IS 'When case was opened';
COMMENT ON COLUMN "workItem"."status" IS 'The case status';
COMMENT ON COLUMN "workItem"."step" IS 'The case step within task';
COMMENT ON COLUMN "workItem"."task" IS 'The case task';


CREATE INDEX "batch_network" on "batch" ("network" ); 
CREATE INDEX "billMerchAddrs_addrType" on "billMerchAddrs" ("addrType" ); 
CREATE INDEX "billMerchEmails_email" on "billMerchEmails" ("data" ); 
CREATE INDEX "billMerchPhones_phoneNbr" on "billMerchPhones" ("data" ); 
CREATE UNIQUE INDEX "domain_domainName" on "domain" ("name" ); 
CREATE INDEX "except_exceptDtm" on "except" ("exceptDtm" ); 
CREATE INDEX "except_procName" on "except" ("procName" ); 
CREATE INDEX "folderAttachmentsCreateByAddrs_addrType" on "folderAttachmentsCreateByAddrs" ("addrType" ); 
CREATE INDEX "folderAttachmentsCreateByEmails_email" on "folderAttachmentsCreateByEmails" ("data" ); 
CREATE INDEX "folderAttachmentsCreateByPhones_phoneNbr" on "folderAttachmentsCreateByPhones" ("data" ); 
CREATE INDEX "hold_holdExpire" on "hold" ("posnId" ,"endDtm" ,"_Id" ); 
CREATE UNIQUE INDEX "logRequestHdrWorkItem_appIdCaseId" on "logRequestHdrWorkItem" ("appId" ,"caseId" ); 
CREATE UNIQUE INDEX "logResponseHdrWorkItem_appIdCaseId" on "logResponseHdrWorkItem" ("appId" ,"caseId" ); 
CREATE INDEX "orderNotifyAddrs_addrType" on "orderNotifyAddrs" ("addrType" ); 
CREATE INDEX "orderNotifyEmails_email" on "orderNotifyEmails" ("data" ); 
CREATE INDEX "orderNotifyPhones_phoneNbr" on "orderNotifyPhones" ("data" ); 
CREATE INDEX "partyAddrs_addrType" on "partyAddrs" ("addrType" ); 
CREATE INDEX "partyEmails_email" on "partyEmails" ("data" ); 
CREATE INDEX "partyPhones_phoneNbr" on "partyPhones" ("data" ); 
CREATE INDEX "partyGroup_name" on "partyGroup" ("name" ); 
CREATE INDEX "partyGroup_groupOwner" on "partyGroup" ("groupOwnerId" ); 
CREATE INDEX "partyGroupParties_memberId" on "partyGroupParties" ("memberId" ); 
CREATE INDEX "party_organization_dbaName" on "party_organization" ("dba" ); 
CREATE INDEX "party_organization_dunsNbr" on "party_organization" ("dunsNbr" ); 
CREATE INDEX "party_person_lastFirstName" on "party_person" ("lastName" ,"firstName" ); 
CREATE UNIQUE INDEX "posn_acctGroupPosnRef" on "posn" ("acctGroup" ,"posnRef" ); 
CREATE INDEX "posn_acctGroupAcctNbr" on "posn" ("acctGroup" ,"acctNbr" ); 
CREATE INDEX "posn_bkFeeCollectFromNotifyAddrs_addrType" on "posn_bkFeeCollectFromNotifyAddrs" ("addrType" ); 
CREATE INDEX "posn_bkFeeCollectFromNotifyEmails_email" on "posn_bkFeeCollectFromNotifyEmails" ("data" ); 
CREATE INDEX "posn_bkFeeCollectFromNotifyPhones_phoneNbr" on "posn_bkFeeCollectFromNotifyPhones" ("data" ); 
CREATE INDEX "prodGroup_prodTypeProdSubType" on "prodGroup" ("prodType" ,"prodSubType" ); 
CREATE INDEX "prodSubType_ixprodType" on "prodSubType" ("prodType" ); 
CREATE INDEX "systemCalendar_nextSchedDtm" on "systemCalendar" ("nextSchedDtm" ); 
CREATE UNIQUE INDEX "workItem_appIdCaseId" on "workItem" ("appId" ,"caseId" ); 
ALTER TABLE "acct" ADD FOREIGN KEY ("acctGroup") REFERENCES "acctGroup" ("acctGroup");
ALTER TABLE "acct_bk" ADD FOREIGN KEY ("folderId") REFERENCES "folder" ("_Id");
ALTER TABLE "acct_bk" ADD FOREIGN KEY ("tmZone") REFERENCES "tmZones" ("tzAbbrev");
ALTER TABLE "acct_bk" ADD FOREIGN KEY ("acctGroup","acctNbr") REFERENCES "acct" ("acctGroup","acctNbr");
ALTER TABLE "accumTrnLimits" ADD FOREIGN KEY ("statGroup") REFERENCES "trnStatsGroup" ("statGroup");
ALTER TABLE "accumTrnLimitsViolationFee" ADD FOREIGN KEY ("trnCode") REFERENCES "trnCode" ("trnCode");
ALTER TABLE "accumTrnLimitsViolationFee" ADD FOREIGN KEY ("_Id") REFERENCES "accumTrnLimits" ("_Id");
ALTER TABLE "accumTrnLimitsViolationFeeLimits" ADD FOREIGN KEY ("_Id") REFERENCES "accumTrnLimitsViolationFee" ("_Id");
ALTER TABLE "addr" ADD FOREIGN KEY ("cntry") REFERENCES "cntry" ("isoAlpha2");
ALTER TABLE "addr" ADD FOREIGN KEY ("cntry","region") REFERENCES "cntryRegion" ("cntry","region");
ALTER TABLE "bankparam" ADD FOREIGN KEY ("calendar") REFERENCES "calendar" ("name");
ALTER TABLE "bankparam" ADD FOREIGN KEY ("_Id") REFERENCES "party_organization_fininst" ("_Id");
ALTER TABLE "bankparamPenRate" ADD FOREIGN KEY ("_Id") REFERENCES "bankparam" ("_Id");
ALTER TABLE "batch" ADD FOREIGN KEY ("network") REFERENCES "network" ("network");
ALTER TABLE "batchDtl" ADD FOREIGN KEY ("_Id") REFERENCES "batch" ("_Id");
ALTER TABLE "batchDtl" ADD FOREIGN KEY ("batchId") REFERENCES "batch" ("_Id");
ALTER TABLE "batchDtl" ADD FOREIGN KEY ("network") REFERENCES "network" ("network");
ALTER TABLE "batchDtl" ADD FOREIGN KEY ("trnCode") REFERENCES "trnCode" ("trnCode");
ALTER TABLE "batchDtlEntries" ADD FOREIGN KEY ("posnId") REFERENCES "posn" ("_Id");
ALTER TABLE "batchDtlEntries" ADD FOREIGN KEY ("_Id") REFERENCES "batchDtl" ("_Id");
ALTER TABLE "batchDtlEntriesAddHold" ADD FOREIGN KEY ("posnId") REFERENCES "posn" ("_Id");
ALTER TABLE "batchDtlEntriesAddHold" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "batchDtlEntries" ("_Id","_Ix");
ALTER TABLE "batchDtlEntriesAuth" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "batchDtlEntries" ("_Id","_Ix");
ALTER TABLE "batchDtlEntriesChk" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "batchDtlEntries" ("_Id","_Ix");
ALTER TABLE "batchDtlEntriesExch" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "batchDtlEntries" ("_Id","_Ix");
ALTER TABLE "batchDtlEntriesGlDist" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "batchDtlEntries" ("_Id","_Ix");
ALTER TABLE "batchDtlEntriesPassbook" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "batchDtlEntries" ("_Id","_Ix");
ALTER TABLE "batchDtlEntriesRemoveHold" ADD FOREIGN KEY ("posnId") REFERENCES "posn" ("_Id");
ALTER TABLE "batchDtlEntriesRemoveHold" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "batchDtlEntries" ("_Id","_Ix");
ALTER TABLE "bill" ADD FOREIGN KEY ("partyId") REFERENCES "party" ("_Id");
ALTER TABLE "billCustAddr" ADD FOREIGN KEY ("cntry") REFERENCES "cntry" ("isoAlpha2");
ALTER TABLE "billCustAddr" ADD FOREIGN KEY ("cntry","region") REFERENCES "cntryRegion" ("cntry","region");
ALTER TABLE "billCustAddr" ADD FOREIGN KEY ("partyId","billId") REFERENCES "bill" ("partyId","billId");
ALTER TABLE "billDtl" ADD FOREIGN KEY ("partyId","billId") REFERENCES "bill" ("partyId","billId");
ALTER TABLE "billMerch" ADD FOREIGN KEY ("partyId","billId") REFERENCES "bill" ("partyId","billId");
ALTER TABLE "billMerch" ADD FOREIGN KEY ("preferAddrId") REFERENCES "addr" ("_Id");
ALTER TABLE "billMerch" ADD FOREIGN KEY ("cntry") REFERENCES "cntry" ("isoAlpha2");
ALTER TABLE "billMerch" ADD FOREIGN KEY ("folderId") REFERENCES "folder" ("_Id");
ALTER TABLE "billMerchAddrs" ADD FOREIGN KEY ("addrId") REFERENCES "addr" ("_Id");
ALTER TABLE "billMerchAddrs" ADD FOREIGN KEY ("partyId","billId") REFERENCES "billMerch" ("partyId","billId");
ALTER TABLE "billMerchEmails" ADD FOREIGN KEY ("partyId","billId") REFERENCES "billMerch" ("partyId","billId");
ALTER TABLE "billMerchPhones" ADD FOREIGN KEY ("partyId","billId") REFERENCES "billMerch" ("partyId","billId");
ALTER TABLE "calendarBusinessDays" ADD FOREIGN KEY ("name") REFERENCES "calendar" ("name");
ALTER TABLE "calendarRefCalendar" ADD FOREIGN KEY ("name") REFERENCES "calendar" ("name");
ALTER TABLE "cntryRegion" ADD FOREIGN KEY ("cntry") REFERENCES "cntry" ("isoAlpha2");
ALTER TABLE "configPosnEvents" ADD FOREIGN KEY ("acctGroup") REFERENCES "acctGroup" ("acctGroup");
ALTER TABLE "configSystemAcct" ADD FOREIGN KEY ("acctGroup") REFERENCES "acctGroup" ("acctGroup");
ALTER TABLE "configSystemAcct" ADD FOREIGN KEY ("acctGroup","acctNbr") REFERENCES "acct" ("acctGroup","acctNbr");
ALTER TABLE "counterparty" ADD FOREIGN KEY ("_Id") REFERENCES "party" ("_Id");
ALTER TABLE "eventCtxtErrInfo" ADD FOREIGN KEY ("eventId","msgDirection") REFERENCES "eventCtxt" ("eventId","msgDirection");
ALTER TABLE "except" ADD FOREIGN KEY ("trnId") REFERENCES "trn" ("_Id");
ALTER TABLE "exceptKeyValues" ADD FOREIGN KEY ("_Id") REFERENCES "except" ("_Id");
ALTER TABLE "feeCalcDtl" ADD FOREIGN KEY ("trnCode") REFERENCES "trnCode" ("trnCode");
ALTER TABLE "feeCalcDtlFeeLimits" ADD FOREIGN KEY ("_Id") REFERENCES "feeCalcDtl" ("_Id");
ALTER TABLE "folderAttachments" ADD FOREIGN KEY ("_Id") REFERENCES "folder" ("_Id");
ALTER TABLE "folderAttachmentsCreateBy" ADD FOREIGN KEY ("preferAddrId") REFERENCES "addr" ("_Id");
ALTER TABLE "folderAttachmentsCreateBy" ADD FOREIGN KEY ("cntry") REFERENCES "cntry" ("isoAlpha2");
ALTER TABLE "folderAttachmentsCreateBy" ADD FOREIGN KEY ("folderId") REFERENCES "folder" ("_Id");
ALTER TABLE "folderAttachmentsCreateBy" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "folderAttachments" ("_Id","_Ix");
ALTER TABLE "folderAttachmentsCreateByAddrs" ADD FOREIGN KEY ("addrId") REFERENCES "addr" ("_Id");
ALTER TABLE "folderAttachmentsCreateByAddrs" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "folderAttachmentsCreateBy" ("_Id","_Ix");
ALTER TABLE "folderAttachmentsCreateByEmails" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "folderAttachmentsCreateBy" ("_Id","_Ix");
ALTER TABLE "folderAttachmentsCreateByPhones" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "folderAttachmentsCreateBy" ("_Id","_Ix");
ALTER TABLE "glSet" ADD FOREIGN KEY ("acctGroup","ledgerAcct") REFERENCES "acct" ("acctGroup","acctNbr");
ALTER TABLE "glSet" ADD FOREIGN KEY ("acctGroup","accrIntAcct") REFERENCES "acct" ("acctGroup","acctNbr");
ALTER TABLE "glSet" ADD FOREIGN KEY ("acctGroup","avlIntAcct") REFERENCES "acct" ("acctGroup","acctNbr");
ALTER TABLE "glSet" ADD FOREIGN KEY ("acctGroup","negIntAcct") REFERENCES "acct" ("acctGroup","acctNbr");
ALTER TABLE "glSet" ADD FOREIGN KEY ("acctGroup","accrFeeAcct") REFERENCES "acct" ("acctGroup","acctNbr");
ALTER TABLE "glSet" ADD FOREIGN KEY ("acctGroup","wthFedAcct") REFERENCES "acct" ("acctGroup","acctNbr");
ALTER TABLE "glSet" ADD FOREIGN KEY ("acctGroup","wthStateAcct") REFERENCES "acct" ("acctGroup","acctNbr");
ALTER TABLE "hold" ADD FOREIGN KEY ("posnId") REFERENCES "posn" ("_Id");
ALTER TABLE "logRequestHdr" ADD FOREIGN KEY ("_Id") REFERENCES "logRequest" ("_Id");
ALTER TABLE "logRequestHdrAgent" ADD FOREIGN KEY ("_Id") REFERENCES "logRequestHdr" ("_Id");
ALTER TABLE "logRequestHdrDevice" ADD FOREIGN KEY ("_Id") REFERENCES "logRequestHdr" ("_Id");
ALTER TABLE "logRequestHdrIdentity" ADD FOREIGN KEY ("_Id") REFERENCES "logRequestHdr" ("_Id");
ALTER TABLE "logRequestHdrLocale" ADD FOREIGN KEY ("cntry") REFERENCES "cntry" ("isoAlpha2");
ALTER TABLE "logRequestHdrLocale" ADD FOREIGN KEY ("cntry","region") REFERENCES "cntryRegion" ("cntry","region");
ALTER TABLE "logRequestHdrLocale" ADD FOREIGN KEY ("_Id") REFERENCES "logRequestHdr" ("_Id");
ALTER TABLE "logRequestHdrMsgLogs" ADD FOREIGN KEY ("_Id") REFERENCES "logRequestHdr" ("_Id");
ALTER TABLE "logRequestHdrWorkItem" ADD FOREIGN KEY ("_Id") REFERENCES "logRequestHdr" ("_Id");
ALTER TABLE "logResponseHdr" ADD FOREIGN KEY ("_Id") REFERENCES "logResponse" ("_Id");
ALTER TABLE "logResponseHdrAgent" ADD FOREIGN KEY ("_Id") REFERENCES "logResponseHdr" ("_Id");
ALTER TABLE "logResponseHdrDevice" ADD FOREIGN KEY ("_Id") REFERENCES "logResponseHdr" ("_Id");
ALTER TABLE "logResponseHdrIdentity" ADD FOREIGN KEY ("_Id") REFERENCES "logResponseHdr" ("_Id");
ALTER TABLE "logResponseHdrLocale" ADD FOREIGN KEY ("cntry") REFERENCES "cntry" ("isoAlpha2");
ALTER TABLE "logResponseHdrLocale" ADD FOREIGN KEY ("cntry","region") REFERENCES "cntryRegion" ("cntry","region");
ALTER TABLE "logResponseHdrLocale" ADD FOREIGN KEY ("_Id") REFERENCES "logResponseHdr" ("_Id");
ALTER TABLE "logResponseHdrMsgLogs" ADD FOREIGN KEY ("_Id") REFERENCES "logResponseHdr" ("_Id");
ALTER TABLE "logResponseHdrWorkItem" ADD FOREIGN KEY ("_Id") REFERENCES "logResponseHdr" ("_Id");
ALTER TABLE "login" ADD FOREIGN KEY ("domainId") REFERENCES "domain" ("_Id");
ALTER TABLE "login" ADD FOREIGN KEY ("partyId") REFERENCES "party" ("_Id");
ALTER TABLE "login" ADD FOREIGN KEY ("domainId","userId") REFERENCES "user" ("domainId","userId");
ALTER TABLE "loginBiometrics" ADD FOREIGN KEY ("domainId","login") REFERENCES "login" ("domainId","login");
ALTER TABLE "loginKbaStatics" ADD FOREIGN KEY ("domainId","login") REFERENCES "login" ("domainId","login");
ALTER TABLE "loginSecrets" ADD FOREIGN KEY ("domainId","login") REFERENCES "login" ("domainId","login");
ALTER TABLE "matrix" ADD FOREIGN KEY ("name") REFERENCES "matrixType" ("name");
ALTER TABLE "merch" ADD FOREIGN KEY ("_Id") REFERENCES "party" ("_Id");
ALTER TABLE "network" ADD FOREIGN KEY ("partyId") REFERENCES "party" ("_Id");
ALTER TABLE "network" ADD FOREIGN KEY ("destination") REFERENCES "party_organization_fininst" ("_Id");
ALTER TABLE "order" ADD FOREIGN KEY ("posnId") REFERENCES "posn" ("_Id");
ALTER TABLE "orderNotify" ADD FOREIGN KEY ("preferAddrId") REFERENCES "addr" ("_Id");
ALTER TABLE "orderNotify" ADD FOREIGN KEY ("cntry") REFERENCES "cntry" ("isoAlpha2");
ALTER TABLE "orderNotify" ADD FOREIGN KEY ("folderId") REFERENCES "folder" ("_Id");
ALTER TABLE "orderNotify" ADD FOREIGN KEY ("_Id") REFERENCES "order" ("_Id");
ALTER TABLE "orderNotifyAddrs" ADD FOREIGN KEY ("addrId") REFERENCES "addr" ("_Id");
ALTER TABLE "orderNotifyAddrs" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "orderNotify" ("_Id","_Ix");
ALTER TABLE "orderNotifyEmails" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "orderNotify" ("_Id","_Ix");
ALTER TABLE "orderNotifyPhones" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "orderNotify" ("_Id","_Ix");
ALTER TABLE "orderRecur" ADD FOREIGN KEY ("_Id") REFERENCES "order" ("_Id");
ALTER TABLE "orderCalendar" ADD FOREIGN KEY ("orderId") REFERENCES "order" ("_Id");
ALTER TABLE "orderCalendar" ADD FOREIGN KEY ("_Id") REFERENCES "posnCalendar" ("_Id");
ALTER TABLE "party" ADD FOREIGN KEY ("preferAddrId") REFERENCES "addr" ("_Id");
ALTER TABLE "party" ADD FOREIGN KEY ("cntry") REFERENCES "cntry" ("isoAlpha2");
ALTER TABLE "party" ADD FOREIGN KEY ("folderId") REFERENCES "folder" ("_Id");
ALTER TABLE "partyAddrs" ADD FOREIGN KEY ("addrId") REFERENCES "addr" ("_Id");
ALTER TABLE "partyAddrs" ADD FOREIGN KEY ("_Id") REFERENCES "party" ("_Id");
ALTER TABLE "partyEmails" ADD FOREIGN KEY ("_Id") REFERENCES "party" ("_Id");
ALTER TABLE "partyPhones" ADD FOREIGN KEY ("_Id") REFERENCES "party" ("_Id");
ALTER TABLE "partyCrRept" ADD FOREIGN KEY ("_Id") REFERENCES "party" ("_Id");
ALTER TABLE "partyFinRept" ADD FOREIGN KEY ("_Id") REFERENCES "party" ("_Id");
ALTER TABLE "partyFinReptStmts" ADD FOREIGN KEY ("_Id") REFERENCES "partyFinRept" ("_Id");
ALTER TABLE "partyGroup" ADD FOREIGN KEY ("groupOwnerId") REFERENCES "party" ("_Id");
ALTER TABLE "partyGroupParties" ADD FOREIGN KEY ("groupId") REFERENCES "partyGroup" ("groupId");
ALTER TABLE "partyGroupParties" ADD FOREIGN KEY ("partyId") REFERENCES "party" ("_Id");
ALTER TABLE "partyGroupSubGroups" ADD FOREIGN KEY ("groupId") REFERENCES "partyGroup" ("groupId");
ALTER TABLE "partyGroupSubGroups" ADD FOREIGN KEY ("subGroupId") REFERENCES "partyGroup" ("groupId");
ALTER TABLE "partyGroupAcct" ADD FOREIGN KEY ("groupId") REFERENCES "partyGroup" ("groupId");
ALTER TABLE "partyGroupAcctAccounts" ADD FOREIGN KEY ("acctGroup","acctNbr") REFERENCES "acct" ("acctGroup","acctNbr");
ALTER TABLE "partyGroupAcctAccounts" ADD FOREIGN KEY ("groupId","memberId") REFERENCES "partyGroupAcct" ("groupId","memberId");
ALTER TABLE "party_organization" ADD FOREIGN KEY ("primaryBankId") REFERENCES "party" ("_Id");
ALTER TABLE "party_organization" ADD FOREIGN KEY ("_Id") REFERENCES "party" ("_Id");
ALTER TABLE "party_organization_fininst" ADD FOREIGN KEY ("_Id") REFERENCES "party_organization" ("_Id");
ALTER TABLE "party_person" ADD FOREIGN KEY ("primaryEmployerId") REFERENCES "party" ("_Id");
ALTER TABLE "party_person" ADD FOREIGN KEY ("citizenCntry") REFERENCES "cntry" ("isoAlpha2");
ALTER TABLE "party_person" ADD FOREIGN KEY ("_Id") REFERENCES "party" ("_Id");
ALTER TABLE "posn" ADD FOREIGN KEY ("acctGroup","acctNbr") REFERENCES "acct" ("acctGroup","acctNbr");
ALTER TABLE "posnCalendar" ADD FOREIGN KEY ("posnId") REFERENCES "posn" ("_Id");
ALTER TABLE "posn_bk" ADD FOREIGN KEY ("glSetCode") REFERENCES "glSet" ("glSetCode");
ALTER TABLE "posn_bk" ADD FOREIGN KEY ("prodName") REFERENCES "prod_bk" ("name");
ALTER TABLE "posn_bk" ADD FOREIGN KEY ("_Id") REFERENCES "posn" ("_Id");
ALTER TABLE "posn_bkCalendar" ADD FOREIGN KEY ("posnId") REFERENCES "posn_bk" ("_Id");
ALTER TABLE "posn_bkFee" ADD FOREIGN KEY ("_Id") REFERENCES "posn_bk" ("_Id");
ALTER TABLE "posn_bkFee" ADD FOREIGN KEY ("componentName","version") REFERENCES "componentFees" ("componentName","version");
ALTER TABLE "posn_bkFeeCollectFrom" ADD FOREIGN KEY ("posnId") REFERENCES "posn" ("_Id");
ALTER TABLE "posn_bkFeeCollectFrom" ADD FOREIGN KEY ("_Id") REFERENCES "posn_bkFee" ("_Id");
ALTER TABLE "posn_bkFeeCollectFromNotify" ADD FOREIGN KEY ("preferAddrId") REFERENCES "addr" ("_Id");
ALTER TABLE "posn_bkFeeCollectFromNotify" ADD FOREIGN KEY ("cntry") REFERENCES "cntry" ("isoAlpha2");
ALTER TABLE "posn_bkFeeCollectFromNotify" ADD FOREIGN KEY ("folderId") REFERENCES "folder" ("_Id");
ALTER TABLE "posn_bkFeeCollectFromNotify" ADD FOREIGN KEY ("_Id") REFERENCES "posn_bkFeeCollectFrom" ("_Id");
ALTER TABLE "posn_bkFeeCollectFromNotifyAddrs" ADD FOREIGN KEY ("addrId") REFERENCES "addr" ("_Id");
ALTER TABLE "posn_bkFeeCollectFromNotifyAddrs" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "posn_bkFeeCollectFromNotify" ("_Id","_Ix");
ALTER TABLE "posn_bkFeeCollectFromNotifyEmails" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "posn_bkFeeCollectFromNotify" ("_Id","_Ix");
ALTER TABLE "posn_bkFeeCollectFromNotifyPhones" ADD FOREIGN KEY ("_Id","_Ix") REFERENCES "posn_bkFeeCollectFromNotify" ("_Id","_Ix");
ALTER TABLE "posn_bkFeeCollectFromRecur" ADD FOREIGN KEY ("_Id") REFERENCES "posn_bkFeeCollectFrom" ("_Id");
ALTER TABLE "posn_bkFeesPd" ADD FOREIGN KEY ("_Id") REFERENCES "posn_bkFee" ("_Id");
ALTER TABLE "posn_bkInt" ADD FOREIGN KEY ("_Id") REFERENCES "posn_bk" ("_Id");
ALTER TABLE "posn_bkLimits" ADD FOREIGN KEY ("_Id") REFERENCES "posn_bk" ("_Id");
ALTER TABLE "posn_bkNsf" ADD FOREIGN KEY ("_Id") REFERENCES "posn_bk" ("_Id");
ALTER TABLE "posn_bkTd" ADD FOREIGN KEY ("_Id") REFERENCES "posn_bk" ("_Id");
ALTER TABLE "posn_gl" ADD FOREIGN KEY ("_Id") REFERENCES "posn" ("_Id");
ALTER TABLE "prodGroup" ADD FOREIGN KEY ("prodType") REFERENCES "prodType" ("prodType");
ALTER TABLE "prodGroup" ADD FOREIGN KEY ("prodType","prodSubType") REFERENCES "prodSubType" ("prodType","prodSubType");
ALTER TABLE "prodGroup" ADD FOREIGN KEY ("glSetCode") REFERENCES "glSet" ("glSetCode");
ALTER TABLE "prodSubType" ADD FOREIGN KEY ("prodType") REFERENCES "prodType" ("prodType");
ALTER TABLE "prodSubType" ADD FOREIGN KEY ("glSetCode") REFERENCES "glSet" ("glSetCode");
ALTER TABLE "prod_bk" ADD FOREIGN KEY ("prodType") REFERENCES "prodType" ("prodType");
ALTER TABLE "prod_bk" ADD FOREIGN KEY ("prodType","prodSubType") REFERENCES "prodSubType" ("prodType","prodSubType");
ALTER TABLE "prod_bk" ADD FOREIGN KEY ("prodType","prodSubType","prodGroup") REFERENCES "prodGroup" ("prodType","prodSubType","prodGroup");
ALTER TABLE "prod_bk" ADD FOREIGN KEY ("glSetCode") REFERENCES "glSet" ("glSetCode");
ALTER TABLE "restrict" ADD FOREIGN KEY ("restrictCode") REFERENCES "restrictReason" ("reason");
ALTER TABLE "restrict" ADD FOREIGN KEY ("acctGroup","acctNbr") REFERENCES "acct" ("acctGroup","acctNbr");
ALTER TABLE "restrict" ADD FOREIGN KEY ("posnId") REFERENCES "posn" ("_Id");
ALTER TABLE "restrictReasonOperExcl" ADD FOREIGN KEY ("reason") REFERENCES "restrictReason" ("reason");
ALTER TABLE "restrictReasonOperIncl" ADD FOREIGN KEY ("reason") REFERENCES "restrictReason" ("reason");
ALTER TABLE "restrictReasonOperRoleExcl" ADD FOREIGN KEY ("reason") REFERENCES "restrictReason" ("reason");
ALTER TABLE "restrictReasonTrnCodeExcl" ADD FOREIGN KEY ("reason") REFERENCES "restrictReason" ("reason");
ALTER TABLE "restrictReasonTrnCodeIncl" ADD FOREIGN KEY ("reason") REFERENCES "restrictReason" ("reason");
ALTER TABLE "restrictReasonTrnCodeRoleExcl" ADD FOREIGN KEY ("reason") REFERENCES "restrictReason" ("reason");
ALTER TABLE "restrictReasonTrnCodeRoleIncl" ADD FOREIGN KEY ("reason") REFERENCES "restrictReason" ("reason");
ALTER TABLE "rolePermission" ADD FOREIGN KEY ("userRole") REFERENCES "role" ("userRole");
ALTER TABLE "systemCalendarArgs" ADD FOREIGN KEY ("_Id") REFERENCES "systemCalendar" ("_Id");
ALTER TABLE "trn" ADD FOREIGN KEY ("batchId") REFERENCES "batch" ("_Id");
ALTER TABLE "trn" ADD FOREIGN KEY ("network") REFERENCES "network" ("network");
ALTER TABLE "trn" ADD FOREIGN KEY ("trnCode") REFERENCES "trnCode" ("trnCode");
ALTER TABLE "trnEntries" ADD FOREIGN KEY ("posnId") REFERENCES "posn" ("_Id");
ALTER TABLE "trnEntries" ADD FOREIGN KEY ("_Id") REFERENCES "trn" ("_Id");
ALTER TABLE "trnCodeEntries" ADD FOREIGN KEY ("trnCode") REFERENCES "trnCode" ("trnCode");
ALTER TABLE "trnLimitsViolationFee" ADD FOREIGN KEY ("trnCode") REFERENCES "trnCode" ("trnCode");
ALTER TABLE "trnLimitsViolationFee" ADD FOREIGN KEY ("_Id") REFERENCES "trnLimits" ("_Id");
ALTER TABLE "trnLimitsViolationFeeLimits" ADD FOREIGN KEY ("_Id") REFERENCES "trnLimitsViolationFee" ("_Id");
ALTER TABLE "trnStats" ADD FOREIGN KEY ("_Id") REFERENCES "posn_bk" ("_Id");
ALTER TABLE "trnStats" ADD FOREIGN KEY ("statGroup") REFERENCES "trnStatsGroup" ("statGroup");
ALTER TABLE "user" ADD FOREIGN KEY ("domainId") REFERENCES "domain" ("_Id");
ALTER TABLE "user" ADD FOREIGN KEY ("partyId") REFERENCES "party" ("_Id");
END;
