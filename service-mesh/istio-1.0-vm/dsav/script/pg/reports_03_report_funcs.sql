--
-- Name: 
--    reports_03_report_funcs.sql
-- Purpose: 
--  Defines stored procedures that are used to to define report output for report writer
--
-- \c core_reports specifies to which database to use in pgsql
\c core_reports
BEGIN;


-- FUNCTION: public.f_reversetrnid(character varying)

-- DROP FUNCTION public.f_reversetrnid(character varying);

CREATE OR REPLACE FUNCTION public.f_reversetrnid(
	thisid character varying)
    RETURNS text
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

Declare
	trnid text;

begin

    SELECT x.tsrevby into trnid
    FROM (
		SELECT DISTINCT trnset._id AS trnid, trnset.reverse AS trnrev, ts._id AS tsrevby, ts.reverse AS tsrev
        FROM trnset
        JOIN trnset ts ON ts.reverse::text = trnset._id::text
		) x
    WHERE x.trnid::text = thisid::text
    ;
	
	return trnid
	;

END;

$BODY$;

ALTER FUNCTION public.f_reversetrnid(character varying)
    OWNER TO postgres;

COMMENT ON FUNCTION public.f_reversetrnid(character varying)
    IS 'Returns the trnsaction ID f';



--
-- TOC entry 290 (class 1255 OID 16401)
-- Name: f_restrictcurrentexists(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_restrictcurrentexists(positionid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

declare 
	currentrest boolean;

BEGIN
	
	SELECT
		(
		case when f_restrictNumCurrent(positionid) > 0 then TRUE
		else FALSE
		end
		) into currentrest
	FROM restrict;
	return currentrest;
	
END

$$;


ALTER FUNCTION public.f_restrictcurrentexists(positionid character varying) OWNER TO postgres;


--
-- TOC entry 287 (class 1255 OID 16402)
-- Name: f_restrictnumcurrent(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_restrictnumcurrent(positionid character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

declare 
	cnt bigint;

BEGIN
	
	SELECT count(*) into cnt  
	FROM restrict
	WHERE restrict._Id = positionid and
		(
		restrict.endDt is null or
		restrict.endDt > current_Date
		);
	return cnt;

END

$$;


ALTER FUNCTION public.f_restrictnumcurrent(positionid character varying) OWNER TO postgres;


--
-- TOC entry 286 (class 1255 OID 16398)
-- Name: f_holdnumcurrent(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_holdnumcurrent(positionid character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$

declare 
	cnt bigint;

BEGIN
	
	SELECT count(*) into cnt  
	FROM vt_hold
	WHERE vt_hold._Id = positionid and
		(
		vt_hold.endDt is null or
		vt_hold.endDt > current_Date
		);
	return cnt;
END

$$;


ALTER FUNCTION public.f_holdnumcurrent(positionid character varying) OWNER TO postgres;
--
-- TOC entry 267 (class 1255 OID 16397)
-- Name: f_holdcurrentexists(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_holdcurrentexists(positionid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

declare 
	currenthold boolean;

BEGIN
	
	SELECT
		(
		case when f_holdNumCurrent(positionid) > 0 then 1
		else 0
		end
		) into currenthold
	FROM hold
	where _id = positionid;
	
	return currenthold;

END

$$;


ALTER FUNCTION public.f_holdcurrentexists(positionid character varying) OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 16400)
-- Name: f_positionisclosed(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_positionisclosed(closedate date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

declare 

	closed boolean;

begin

if closedate is null 
	then closed := False;
	else closed := True;
end if;

return closed;

end;

$$;


ALTER FUNCTION public.f_positionisclosed(closedate date) OWNER TO postgres;

--
-- TOC entry 3456 (class 0 OID 0)
-- Dependencies: 278
-- Name: FUNCTION f_positionisclosed(closedate date); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.f_positionisclosed(closedate date) IS 'Returns true if the position''s closed date is not null; false if the closed date is null.

Created By: Chuck Hardy
           Date: 04/13/2018';

--
-- TOC entry 276 (class 1255 OID 16395)
-- Name: f_accountisclosed(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_accountisclosed(accountgroup character varying, accountnum character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$

declare 

	pclosed integer;
	popen integer;

begin

select count(_id) into pclosed 
from vt_positions 
where acctgroup = accountgroup and 
	acctnbr = accountnum and 
	f_positionisclosed(positions.closedtm) = true
	;
	
select count(_id) into popen 
from positions 
where acctgroup = accountgroup and 
	acctnbr = accountnum and 
	f_positionisclosed(positions.closedtm) = false
	;

select closed = (pclosed > 0 and pclosed = popen);

return closed;

end;

$$;


ALTER FUNCTION public.f_accountisclosed(accountgroup character varying, accountnum character varying) OWNER TO postgres;

--
-- TOC entry 3453 (class 0 OID 0)
-- Dependencies: 276
-- Name: FUNCTION f_accountisclosed(accountgroup character varying, accountnum character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.f_accountisclosed(accountgroup character varying, accountnum character varying) IS 'Returns true if all positions are closed; false if at least one position is still open.

Created By: Chuck Hardy
           Date: 04/13/2018';






--
-- TOC entry 292 (class 1255 OID 16396)
-- Name: f_fxreport_test_functions(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_fxreport_test_functions() RETURNS boolean
    LANGUAGE sql
    AS $$

select _id,public.f_positionisclosed(positions.closedtm::date) from positions;
select * from public.f_holdcurrentexists('123');
select * from public.f_holdnumcurrent('123');
select * from public.f_restrictnumcurrent('123');
select * from public.f_restrictcurrentexists('123');


$$;


ALTER FUNCTION public.f_fxreport_test_functions() OWNER TO postgres;



--
-- TOC entry 3454 (class 0 OID 0)
-- Dependencies: 267
-- Name: FUNCTION f_holdcurrentexists(positionid character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.f_holdcurrentexists(positionid character varying) IS 'Returns True if there is an active hold.  "Active" is a hold with an expiration date in the future or a null expiration date.

Created By: Chuck Hardy
          Date: 04/11/2018';




--
-- TOC entry 3455 (class 0 OID 0)
-- Dependencies: 286
-- Name: FUNCTION f_holdnumcurrent(positionid character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.f_holdnumcurrent(positionid character varying) IS 'Returns the number of open holds.  An "open" hold is one with an expiration date in the future or a null expiration date.

Created by: Chuck Hardy
          Date: 04/11/2018';


--
-- TOC entry 265 (class 1255 OID 19975)
-- Name: f_nextprocdate(character varying, date, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_nextprocdate(tablename character varying, effdate date, whereclause text DEFAULT ''::text) RETURNS date
    LANGUAGE plpgsql
    AS $_$

declare 
	outdate date;

begin

	if whereclause <> '' then
		select whereclause = ' and ' || whereclause;
	end if;

	execute format('SELECT max(procdate) FROM $1 WHERE procdate <= $2' || quote_ident(whereclause))
   	INTO outdate
	USING tablename, effdate, whereclause;

	return outdate;

end;

$_$;


ALTER FUNCTION public.f_nextprocdate(tablename character varying, effdate date, whereclause text) OWNER TO postgres;





--
-- TOC entry 3457 (class 0 OID 0)
-- Dependencies: 290
-- Name: FUNCTION f_restrictcurrentexists(positionid character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.f_restrictcurrentexists(positionid character varying) IS 'Returns True if there is an active restrict.  "Active" is a restrict with an expiration date in the future or a null expiration date.

Created By: Chuck Hardy
          Date: 04/12/2018';



--
-- TOC entry 3458 (class 0 OID 0)
-- Dependencies: 287
-- Name: FUNCTION f_restrictnumcurrent(positionid character varying); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.f_restrictnumcurrent(positionid character varying) IS 'Returns the number of open restricts.  An "open" restrict is one with an expiration date in the future or a null expiration date.

Created by: Chuck Hardy
          Date: 04/12/2018';


--
-- TOC entry 283 (class 1255 OID 20047)
-- Name: f_table_comment(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_table_comment(tablename character varying, schemaname character varying DEFAULT NULL::character varying) RETURNS text
    LANGUAGE sql
    AS $_$

    SELECT obj_description((CASE 
       WHEN strpos($1, '.')>0 THEN $1
       WHEN $2 IS NULL THEN 'public.'||$1
       ELSE $2||'.'||$1
            END)::regclass, 'pg_class');
 

$_$;


ALTER FUNCTION public.f_table_comment(tablename character varying, schemaname character varying) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 21618)
-- Name: fr_run_bal_2(date); Type: FUNCTION; Schema: public; Owner: postgres
--

-- FUNCTION: public.fr_run_bal_2(date)

-- DROP FUNCTION public.fr_run_bal_2(date);

CREATE OR REPLACE FUNCTION public.fr_run_bal_2(
	procdate date DEFAULT CURRENT_DATE)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	declare
		detailcursor refcursor := 'detail';
		nullval text;
	
	BEGIN
	    OPEN detailcursor FOR 
		
		with bal_2 as (
			
			select		-- Select dtl data
				'D'::text AS "RTYPE",
				f_fmt(vr_bal_2.rptasof::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_bal_2.posnref::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				f_fmt(vr_bal_2.accttitle::text, 'T'::character(1), 25, 0, ''::character(1), 'L'::character(1)) AS "Title",
				f_fmt(vr_bal_2.prodname::text, 'T'::character(1), 5, 0, ''::character(1), 'L'::character(1)) AS "Prod",
				f_fmt(vr_bal_2.glsetcode::text, 'T'::character(1), 14, 0, ''::character(1), 'L'::character(1)) AS "GL Set",
				f_fmt(vr_bal_2.deptid::text, 'T'::character(1), 5, 0, ''::character(1), 'R'::character(1)) AS "Dept",
				f_fmt(vr_bal_2.vertical::text, 'T'::character(1), 5, 0, ''::character(1), 'R'::character(1)) AS "Vert",
				f_fmt(vr_bal_2.ccycode::text, 'T'::character(1), 4, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(vr_bal_2.bal::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Balance",
				f_fmt(vr_bal_2.availbal::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Avail Bal",
				f_fmt(vr_bal_2.glbal::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "GL Balance",
				f_fmt(vr_bal_2.opendtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Date Opened",
				f_fmt(vr_bal_2.isbrokered::text, 'B'::character(1), 2, 0, ''::character(1), 'L'::character(1)) AS "Is Broker",
				f_fmt(vr_bal_2.nomrate::text, '$'::character(1), 9, 5, ''::character(1), 'R'::character(1)) AS "Int Rate",
				f_fmt(vr_bal_2.index_nextreviewdt::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Next Rate Chng",
				f_fmt(vr_bal_2.apye::text, '$'::character(1), 9, 5, ''::character(1), 'R'::character(1)) AS "Stmt APYE",
				f_fmt(vr_bal_2.acrintbal::text, '$'::character(1), 14, 5, ''::character(1), 'R'::character(1)) AS "ACR Bal",
				f_fmt(vr_bal_2.lastpostdtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Int Last Pd",
				f_fmt(vr_bal_2.nextpostdtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Nxt Pd Dt",
				f_fmt(vr_bal_2.sumintpd::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Int Pd YTD",
				f_fmt(vr_bal_2.sumwthfed::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Fed Withheld",
				f_fmt(vr_bal_2.sumwthstate::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "St Withhheld",
				f_fmt(vr_bal_2.ishold::text, 'B'::character(1), 2, 0, ''::character(1), 'L'::character(1)) AS "Hold",
				f_fmt(vr_bal_2.isrestrict::text, 'B'::character(1), 2, 0, ''::character(1), 'L'::character(1)) AS "Rest",
				f_fmt(vr_bal_2.isstop::text, 'B'::character(1), 2, 0, ''::character(1), 'L'::character(1)) AS "Stop"
			FROM vr_bal_2
			where vr_bal_2.rptasof::date = procdate
			
		union all
			
			SELECT		-- Select data subtotals by product
				'G'::text AS "RTYPE",
				f_fmt(vr_bal_2.rptasof::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(count(vr_bal_2.posnref)::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				''::text AS "Title",
				f_fmt(vr_bal_2.prodname::text, 'T'::character(1), 5, 0, ''::character(1), 'L'::character(1)) AS "Prod",
				f_fmt(vr_bal_2.glsetcode::text, 'T'::character(1), 14, 0, ''::character(1), 'L'::character(1)) AS "GL Set",
				''::text AS "Dept",
				''::text AS "Vert",
  				''::text AS "CrCd",
				f_fmt(sum(vr_bal_2.bal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Balance",
				f_fmt(sum(vr_bal_2.availbal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Avail Bal",
				f_fmt(sum(vr_bal_2.glbal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "GL Balance",
				''::text AS "Date Opened",
				''::text AS "Is Broker",
				''::text AS "Int Rate",
				''::text AS "Next Rate Chng",
				''::text AS "Stmt APYE",
				f_fmt(sum(vr_bal_2.acrintbal)::text, '$'::character(1), 14, 5, ''::character(1), 'R'::character(1)) AS "ACR Bal",
				''::text AS "Int Last Pd",
				''::text AS "Nxt Pd Dt",
				f_fmt(sum(vr_bal_2.sumintpd)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Int Pd YTD",
			    f_fmt(sum(vr_bal_2.sumwthfed)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Fed Withheld",
			    f_fmt(sum(vr_bal_2.sumwthstate)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "St Withhheld",
				''::text AS "Hold",
				''::text AS "Rest",
				''::text AS "Stop"
			FROM vr_bal_2
			where vr_bal_2.rptasof::date = procdate
			GROUP BY vr_bal_2.rptasof, vr_bal_2.prodname, vr_bal_2.glsetcode
		)
		
		(	-- List the dtls, subtotaled by product
			select *
			from bal_2
			order by bal_2."Run Date", bal_2."Prod", bal_2."GL Set", bal_2."RTYPE", bal_2."Position" nulls last
		)
		
		union all
		
		SELECT 		-- Lay in the report totals at the end
			'T'::text AS "RTYPE",
			f_fmt(vr_bal_2.rptasof::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
			f_fmt(count(vr_bal_2.posnref)::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
			''::text AS "Title",
			''::text AS "Prod",
			''::text AS "GL Set",
			''::text AS "Dept",
			''::text AS "Vert",
  			''::text AS "CrCd",
			f_fmt(sum(vr_bal_2.bal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Balance",
			f_fmt(sum(vr_bal_2.availbal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Avail Bal",
			f_fmt(sum(vr_bal_2.glbal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "GL Balance",
			''::text AS "Date Opened",
			''::text AS "Is Broker",
			''::text AS "Int Rate",
			''::text AS "Next Rate Chng",
			''::text AS "Stmt APYE",
			f_fmt(sum(vr_bal_2.acrintbal)::text, '$'::character(1), 14, 5, ''::character(1), 'R'::character(1)) AS "ACR Bal",
			''::text AS "Int Last Pd",
			''::text AS "Nxt Pd Dt",
			f_fmt(sum(vr_bal_2.sumintpd)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Int Pd YTD",
			f_fmt(sum(vr_bal_2.sumwthfed)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Fed Withheld",
			f_fmt(sum(vr_bal_2.sumwthstate)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "St Withhheld",
			''::text AS "Hold",
			''::text AS "Rest",
			''::text AS "Stop"
		FROM vr_bal_2
		where vr_bal_2.rptasof::date = procdate
		GROUP BY vr_bal_2.rptasof
		;
		
    RETURN next detailcursor;

    END



$BODY$;

ALTER FUNCTION public.fr_run_bal_2(date)
    OWNER TO postgres;

COMMENT ON FUNCTION public.fr_run_bal_2(date)
    IS 'Lists all customer position bals by product for an accounting day.';

--
-- TOC entry 3459 (class 0 OID 0)
-- Dependencies: 264
-- Name: FUNCTION fr_run_bal_2(procdate date); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.fr_run_bal_2(procdate date) IS 'Lists all customer position bals by product for an accounting day.';


--
-- TOC entry 291 (class 1255 OID 21112)
-- Name: fr_run_bal_2a(date); Type: FUNCTION; Schema: public; Owner: postgres
--

-- FUNCTION: public.fr_run_bal_2a(date)

-- DROP FUNCTION public.fr_run_bal_2a(date);

CREATE OR REPLACE FUNCTION public.fr_run_bal_2a(
	procdate date DEFAULT CURRENT_DATE)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$


	declare
		detailcursor refcursor := 'detail';
		nullval text;
	
    BEGIN
	    OPEN detailcursor FOR 
		
		with bal_2a as (
			select		-- Select dtl data
				'D'::text AS "RTYPE",
				f_fmt(vr_bal_2a.rptasof::date::text, 'D'::character(1), 9, 0, ' '::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_bal_2a.gltype::text, 'T'::character(1), 1, 0, ''::character(1), 'L'::character(1)) AS "Cat",
				f_fmt(vr_bal_2a.posnref::text, 'T'::character(1), 24, 0, ' '::character(1), 'R'::character(1)) AS "Account",
				f_fmt(vr_bal_2a.name::text, 'T'::character(1), 40, 0, ' '::character(1), 'L'::character(1)) AS "Name",
				f_fmt(vr_bal_2a.ccycode::text, 'T'::character(1), 4, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(vr_bal_2a.bal::text, '$'::character(1), 20, 2, ' '::character(1), 'R'::character(1)) AS "Balance"
			FROM vr_bal_2a
			where vr_bal_2a.rptasof::date = procdate

		union all
			SELECT		-- Group totals
				'G'::text AS "RTYPE",
				f_fmt(vr_bal_2a.rptasof::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_bal_2a.gltype::text, 'T'::character(1), 1, 0, ''::character(1), 'L'::character(1)) AS "Cat",
				f_fmt(vr_bal_2a.posnref::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Account",
				nullval::text AS "Name",
				f_fmt(vr_bal_2a.ccycode::text, 'T'::character(1), 4, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(sum(vr_bal_2a.bal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Balance"
			FROM vr_bal_2a
			where vr_bal_2a.rptasof::date = procdate
			GROUP BY vr_bal_2a.rptasof, vr_bal_2a.gltype, vr_bal_2a.ccycode, vr_bal_2a.posnref

		union all

			SELECT 		-- Totals
				'T'::text AS "RTYPE",
				f_fmt(vr_bal_2a.rptasof::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_bal_2a.gltype::text, 'T'::character(1), 1, 0, ''::character(1), 'L'::character(1)) AS "Cat",
				nullval::text AS "Account",
				nullval::text AS "Name",
				f_fmt(vr_bal_2a.ccycode::text, 'T'::character(1), 4, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(sum(vr_bal_2a.bal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Balance"
			FROM vr_bal_2a
			where vr_bal_2a.rptasof::date = procdate
			GROUP BY vr_bal_2a.rptasof, vr_bal_2a.gltype, vr_bal_2a.ccycode
		)

		(	-- List the dtls, subtotaled and totaled
			select * 
			from bal_2a
			order by 
				CASE
					WHEN (bal_2a."Cat" = 'A') THEN 1
					WHEN (bal_2a."Cat" = 'L') THEN 2
					WHEN (bal_2a."Cat" = 'C') THEN 3
					WHEN (bal_2a."Cat" = 'R') THEN 4
					WHEN (bal_2a."Cat" = 'E') THEN 5
					ELSE 0
    			END,
				bal_2a."Account" asc nulls last, bal_2a."RTYPE"
		)
		
		;

    RETURN next detailcursor;

    END;


$BODY$;

ALTER FUNCTION public.fr_run_bal_2a(date)
    OWNER TO postgres;

COMMENT ON FUNCTION public.fr_run_bal_2a(date)
    IS 'Lists all GL transactions for an accounting day';


-- FUNCTION: public.fr_run_bal_5(date)

-- DROP FUNCTION public.fr_run_bal_5(date);

CREATE OR REPLACE FUNCTION public.fr_run_bal_5(
	procdate date DEFAULT CURRENT_DATE)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	declare
		detailcursor refcursor := 'detail';
		nullval text;
	
    BEGIN
	    OPEN detailcursor FOR 
		
		with bal_5 as (
			
			select		-- Select dtl data
				'D'::text AS "RTYPE",
				f_fmt((vr_bal_5.trndtm::date)::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_bal_5.posnref::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				f_fmt(vr_bal_5.prodname::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Product",
				f_fmt(vr_bal_5.ccycode::text, 'T'::character(1), 4, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(vr_bal_5.trncode::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Transaction Code",
				f_fmt(vr_bal_5.effectdtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Eff Date",
				f_fmt(vr_bal_5.gljrnldate::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "GL Date",
				f_fmt(vr_bal_5.network::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Network",
				f_fmt(vr_bal_5.batchid::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Batch ID",
				f_fmt(vr_bal_5.reverse::text, 'T'::character(1), 22, 0, ''::character(1), 'L'::character(1)) AS "Reverse",
				f_fmt(vr_bal_5.reversedby::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Reversed By",
				f_fmt(vr_bal_5.mode::text, 'T'::character(1), 5, 0, ''::character(1), 'L'::character(1)) AS "Processing Mode",
				f_fmt(vr_bal_5.logref::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Message Log Ref",
				f_fmt(vr_bal_5.dramount::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Dr Amount",
				f_fmt(vr_bal_5.cramount::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Cr Amount"
				from vr_bal_5
				where vr_bal_5.trndtm::date = procdate and vr_bal_5.rptasof::date = procdate
																					
		union all
																					
			SELECT		-- Select data subtotals by product
				'G'::text AS "RTYPE",
				f_fmt((vr_bal_5.trndtm::date)::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_bal_5.posnref::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				f_fmt(vr_bal_5.prodname::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Product",
				f_fmt(vr_bal_5.ccycode::text, 'T'::character(1), 4, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(vr_bal_5.trncode::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Transaction Code",
				''::text AS "Eff Date",
				''::text AS "GL Date",
				''::text AS "Network",
				''::text AS "Batch ID",
				''::text AS "Reverse",
				''::text AS "Reversed By",
				''::text AS "Processing Mode",
				''::text AS "Message Log Ref",
				f_fmt(sum(vr_bal_5.dramount::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Dr Amount",
				f_fmt(sum(vr_bal_5.cramount::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Cr Amount"
				from vr_bal_5
				where vr_bal_5.trndtm::date = procdate and vr_bal_5.rptasof::date = procdate
				GROUP BY vr_bal_5.trndtm::date, vr_bal_5.prodname, vr_bal_5.posnref, vr_bal_5.ccycode, vr_bal_5.trncode
				order by "Run Date", "Product", "Position", "Transaction Code", "RTYPE"	
		)

		(	-- List the dtls, subtotaled by product
			select * 
			from bal_5
			
			union all
		
			SELECT 		-- Lay in the report totals at the end
				'T'::text AS "RTYPE",
				'Total:' AS "Run Date",
				nullval::text AS "Position",
				nullval::text AS "Product",
				nullval::text AS "CrCd",
				nullval::text AS "Transaction Code",
				''::text AS "Eff Date",
				''::text AS "GL Date",
				''::text AS "Network",
				''::text AS "Batch ID",
				''::text AS "Reverse",
				''::text AS "Reversed By",
				''::text AS "Processing Mode",
				''::text AS "Message Log Ref",
				f_fmt(sum(vr_bal_5.dramount::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Dr Amount",
				f_fmt(sum(vr_bal_5.cramount::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Cr Amount"
				FROM vr_bal_5
				where vr_bal_5.trndtm::date = procdate and vr_bal_5.rptasof::date = procdate
		)
		
		;

    RETURN next detailcursor;

    END;



$BODY$;

ALTER FUNCTION public.fr_run_bal_5(date)
    OWNER TO postgres;

COMMENT ON FUNCTION public.fr_run_bal_5(date)
    IS 'Lists all customer transactions for an accounting day';



--
-- TOC entry 3461 (class 0 OID 0)
-- Dependencies: 275
-- Name: FUNCTION fr_run_bal_5(procdate date); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.fr_run_bal_5(procdate date) IS 'Lists all customer transactions for an accounting day';


--
-- TOC entry 282 (class 1255 OID 21617)
-- Name: fr_run_bal_6(date); Type: FUNCTION; Schema: public; Owner: postgres
--

-- FUNCTION: public.fr_run_bal_6(date)

-- FUNCTION: public.fr_run_bal_6(date)

-- DROP FUNCTION public.fr_run_bal_6(date);

CREATE OR REPLACE FUNCTION public.fr_run_bal_6(
	procdate date DEFAULT CURRENT_DATE)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$



declare
	detailcursor refcursor := 'detail';
	nullval text;
	
BEGIN
	 OPEN detailcursor FOR 
		
	with bal_6 as (
		select
		-- Select dtl data
		'D'::text AS "RTYPE",
		f_fmt(vr_bal_6.acctnbr::text, 'T'::character(1), 14, 0, ''::character(1),'R'::character(1)) AS "Account Number",
		f_fmt(vr_bal_6.posnref::text, 'T'::character(1), 13, 0, ''::character(1),'R'::character(1)) AS "Position",
		f_fmt(vr_bal_6.ccycode::text, 'T'::character(1), 4, 0, ''::character(1),'L'::character(1)) AS "CrCd",
		f_fmt(vr_bal_6.trncode::text, 'T'::character(1), 12, 0, ''::character(1),'L'::character(1)) AS "Transaction Code",
		f_fmt(vr_bal_6.gljrnldate::date::text, 'D'::character(1), 9, 0, ''::character(1),'R'::character(1)) AS "GL Date",
		f_fmt(vr_bal_6.effectdtm::date::text, 'D'::character(1), 9, 0, ''::character(1),'R'::character(1)) AS "Eff Date",
		f_fmt(vr_bal_6.dramount::text, '$'::character(1), 14, 2, ''::character(1),'R'::character(1)) AS "Dr Amount",
		f_fmt(vr_bal_6.cramount::text, '$'::character(1), 14, 2, ''::character(1),'R'::character(1)) AS "Cr Amount",
		f_fmt(vr_bal_6._id::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Id",
		f_fmt(vr_bal_6.reverse::text, 'T'::character(1), 22, 0, ''::character(1),'L'::character(1)) AS "Reverse",
		f_fmt(vr_bal_6.reversedby::text, 'T'::character(1), 22, 0, ''::character(1),'L'::character(1)) AS "Reversed By",
		f_fmt(vr_bal_6.network::text, 'T'::character(1), 20, 0, ''::character(1),'L'::character(1)) AS "Network",
		f_fmt(vr_bal_6.batchid::text, 'T'::character(1), 20, 0, ''::character(1),'L'::character(1)) AS "Batch ID"
	FROM vr_bal_6
	where vr_bal_6.trndtm::date = procdate and vr_bal_6.rptasof::date = procdate

	union all
	SELECT
		'G'::text AS "RTYPE",
		f_fmt(vr_bal_6.acctnbr::text, 'T'::character(1), 14, 0, ''::character(1),'R'::character(1)) AS "Account Number",
		f_fmt(vr_bal_6.posnref::text, 'T'::character(1), 13, 0, ''::character(1),'R'::character(1)) AS "Position",
		''::text AS "CrCd",
		''::text AS "Transaction Code",
		f_fmt(vr_bal_6.gljrnldate::date::text, 'D'::character(1), 9, 0, ''::character(1),'R'::character(1)) AS "GL Date",
		''::text AS "Eff Date",
		f_fmt(sum(vr_bal_6.dramount)::text, '$'::character(1), 14, 2, ''::character(1),'R'::character(1)) AS "Dr Amount",
		f_fmt(sum(vr_bal_6.cramount)::text, '$'::character(1), 14, 2, ''::character(1),'R'::character(1)) AS "Cr Amount",
		''::text AS "Id",
		''::text AS "Reverse",
		''::text AS "Reversed By",
		''::text AS "Network",
		''::text AS "Batch ID"
	FROM vr_bal_6
	where vr_bal_6.trndtm::date = procdate and vr_bal_6.rptasof::date = procdate
	GROUP BY vr_bal_6.gljrnldate::date, vr_bal_6.acctnbr, vr_bal_6.posnref
	)

	(
	select * from bal_6
	order by bal_6."GL Date", bal_6."Account Number" nulls last, bal_6."Position" nulls last, bal_6."RTYPE"
	);


 RETURN next detailcursor;

 END;



$BODY$;

ALTER FUNCTION public.fr_run_bal_6(date)
    OWNER TO postgres;

COMMENT ON FUNCTION public.fr_run_bal_6(date)
    IS 'Lists all GL transactions for an accounting day';

--
-- TOC entry 272 (class 1255 OID 22629)
-- Name: fr_run_dep_4(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

-- FUNCTION: public.fr_run_dep_4(date, date)

-- DROP FUNCTION public.fr_run_dep_4(date, date);

CREATE OR REPLACE FUNCTION public.fr_run_dep_4(
	frprocdate date DEFAULT CURRENT_DATE,
	toprocdate date DEFAULT CURRENT_DATE)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	declare
		detailcursor refcursor := 'detail';
		nullval text;
	
    BEGIN
	    OPEN detailcursor FOR 
		
		with dep_4 as (
			
			select		-- Select dtl data
				'D'::text AS "RTYPE",
				f_fmt(vr_dep_4.trndtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_dep_4.posnref::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				f_fmt(vr_dep_4.prodname::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Product",
				f_fmt(vr_dep_4.ifxaccttype::text, 'T'::character(1), 3, 0, ''::character(1), 'L'::character(1)) AS "Product Type",
				f_fmt(vr_dep_4.glsetcode::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "GL Set Code",
				f_fmt(vr_dep_4.ccycode::text, 'T'::character(1), 4, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(vr_dep_4.trncode::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Transaction Code",
				f_fmt(vr_dep_4.effectdtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Eff Date",
				f_fmt(vr_dep_4.gljrnldate::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "GL Date",
				f_fmt(vr_dep_4.lastpostdtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Lst Post Dt",
				f_fmt(vr_dep_4.nextpostdtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Nxt Post Dt",
				f_fmt(vr_dep_4.nomrate::text, '$'::character(1), 9, 5, ''::character(1), 'R'::character(1)) AS "Nom Rate",
				f_fmt(vr_dep_4.index_indexname::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Index",
				f_fmt(vr_dep_4.index_reviewfreq::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Review Freq",
				f_fmt(vr_dep_4.index_nextreviewdt::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Nxt Rev Dt",
				f_fmt(vr_dep_4.apye::text, '$'::character(1), 9, 5, ''::character(1), 'R'::character(1)) AS "APYE",
				f_fmt(vr_dep_4.promoexpdtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Promo Ex Dt",
				f_fmt(vr_dep_4.intdisbmtinstr_acctnbr::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Ext AcctNbr",
				f_fmt(vr_dep_4.intdisbmtinstr_accttitle::text, 'T'::character(1), 25, 0, ''::character(1), 'L'::character(1)) AS "Ext Title",
				f_fmt(vr_dep_4.counterparty_fininst::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Ext Inst",
				f_fmt(vr_dep_4.network::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Network",
				f_fmt(vr_dep_4.batchid::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Batch ID",
				f_fmt(vr_dep_4._id::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Id",
				f_fmt(vr_dep_4.reverse::text, 'T'::character(1), 22, 0, ''::character(1), 'L'::character(1)) AS "Reverse",
				f_fmt(vr_dep_4.reversedby::text, 'T'::character(1), 22, 0, ''::character(1), 'L'::character(1)) AS "Reversed By",
				f_fmt(vr_dep_4.mode::text, 'T'::character(1), 5, 0, ''::character(1), 'L'::character(1)) AS "Processing Mode",
				f_fmt(vr_dep_4.logref::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Message Log Ref",
				f_fmt(vr_dep_4.dramount::text, '$'::character(1), 14, 2, ''::character(1),'R'::character(1)) AS "Dr Amount",
				f_fmt(vr_dep_4.cramount::text, '$'::character(1), 14, 2, ''::character(1),'R'::character(1)) AS "Cr Amount"
				from vr_dep_4
				where (vr_dep_4.gljrnldate::date between frprocdate and (toprocdate - interval '1 days')) and vr_dep_4.rptasof::date = toprocdate
																					
		union all

			SELECT		-- Select data totals by product
				'G'::text AS "RTYPE",
				''::text AS "Run Date",
				f_fmt(count(vr_dep_4.amt)::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Position",
				f_fmt(vr_dep_4.prodname::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Product",
				nullval::text as "Product Type",
				f_fmt(vr_dep_4.glsetcode::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "GL Set Code",
				''::text AS "CrCd",
				''::text AS "Transaction Code",
				''::text AS "Eff Date",
				f_fmt(vr_dep_4.gljrnldate::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "GL Date",
				''::text AS "Lst Post Dt",
				''::text AS "Nxt Post Dt",
				''::text AS "Nom Rate",
				''::text AS "Index",
				''::text AS "Review Freq",
				''::text AS "Nxt Rev Dt",
				''::text AS "APYE",
				''::text AS "Promo Ex Dt",
				''::text AS "Ext AcctNbr",
				''::text AS "Ext Title",
				''::text AS "Ext Inst",
				''::text AS "Network",
				''::text AS "Batch ID",
				''::text AS "Id",
				''::text AS "Reverse",
				''::text AS "Reversed By",
				''::text AS "Processing Mode",
				''::text AS "Message Log Ref",
				f_fmt(sum(vr_dep_4.dramount)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Dr Amount",
				f_fmt(sum(vr_dep_4.cramount)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Cr Amount"
				from vr_dep_4
				where (vr_dep_4.gljrnldate::date between frprocdate and (toprocdate - interval '1 days')) and vr_dep_4.rptasof::date = toprocdate
				GROUP BY vr_dep_4.gljrnldate::date, vr_dep_4.prodname, vr_dep_4.glsetcode
		
		union all
		
			SELECT 		-- Lay in the report totals at the end
				'T'::text AS "RTYPE",
				''::text AS "Run Date",
				f_fmt(count(vr_dep_4.amt)::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Position",
				nullval::text AS "Product",
				nullval::text as "Product Type",
				nullval::text AS "GL Set Code",
				''::text AS "CrCd",
				''::text AS "Transaction Code",
				''::text AS "Eff Date",
				f_fmt(vr_dep_4.gljrnldate::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "GL Date",
				''::text AS "Lst Post Dt",
				''::text AS "Nxt Post Dt",
				''::text AS "Nom Rate",
				''::text AS "Index",
				''::text AS "Review Freq",
				''::text AS "Nxt Rev Dt",
				''::text AS "APYE",
				''::text AS "Promo Ex Dt",
				''::text AS "Ext AcctNbr",
				''::text AS "Ext Title",
				''::text AS "Ext Inst",
				''::text AS "Network",
				''::text AS "Batch ID",
				''::text AS "Id",
				''::text AS "Reverse",
				''::text AS "Reversed By",
				''::text AS "Processing Mode",
				''::text AS "Message Log Ref",
				f_fmt(sum(vr_dep_4.dramount)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Dr Amount",
				f_fmt(sum(vr_dep_4.cramount)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Cr Amount"
				from vr_dep_4
				where (vr_dep_4.gljrnldate::date between frprocdate and (toprocdate - interval '1 days')) and vr_dep_4.rptasof::date = toprocdate
				GROUP BY vr_dep_4.gljrnldate::date
		)

		(	-- List the dtls, subtotaled by product
			select * 
			from dep_4
			order by dep_4."GL Date", dep_4."GL Set Code" nulls last, dep_4."RTYPE"
		)
		;

    RETURN next detailcursor;

    END;


$BODY$;

ALTER FUNCTION public.fr_run_dep_4(date, date)
    OWNER TO postgres;

COMMENT ON FUNCTION public.fr_run_dep_4(date, date)
    IS 'Lists all customer interest posting credit transactions for an accounting day';


-- FUNCTION: public.fr_run_dep_5(date, date)

-- DROP FUNCTION public.fr_run_dep_5(date, date);

CREATE OR REPLACE FUNCTION public.fr_run_dep_5(
	frprocdate date DEFAULT CURRENT_DATE,
	toprocdate date DEFAULT CURRENT_DATE)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	declare
		detailcursor refcursor := 'detail';
		nullval text;
	
    BEGIN
	    OPEN detailcursor FOR 
		
		with dep_5 as (
			
			select		-- Select dtl data
				'D'::text AS "RTYPE",
				f_fmt(vr_dep_5.rptasof::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_dep_5.posnid::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				f_fmt(vr_dep_5.accttitle::text, 'T'::character(1), 25, 0, ''::character(1), 'L'::character(1)) AS "Title",
				f_fmt(vr_dep_5.network::text, 'T'::character(1), 10, 0, ''::character(1), 'L'::character(1)) AS "Network",
				f_fmt(vr_dep_5.ordertype::text, 'T'::character(3), 3, 0, ''::character(3), 'R'::character(3)) AS "Order Type",
				f_fmt(vr_dep_5.ordersrc::text, 'T'::character(7), 7, 0, ''::character(7), 'R'::character(7)) AS "Order Source",
				f_fmt(vr_dep_5.orderdtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Order Date",
				f_fmt(vr_dep_5.verifydtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Verify Date",
				f_fmt(vr_dep_5.chkedby_name::text, 'T'::character(1), 14, 0, ''::character(1), 'R'::character(1)) AS "Check By",
				f_fmt(vr_dep_5.originsrc::text, 'T'::character(3), 3, 0, ''::character(3), 'R'::character(3)) AS "Origin Source",
				f_fmt(vr_dep_5.originator_name::text, 'T'::character(1), 14, 0, ''::character(1), 'R'::character(1)) AS "Originate By",
				f_fmt(vr_dep_5.createdtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Create Date",
				f_fmt(vr_dep_5.createby_name::text, 'T'::character(1), 14, 0, ''::character(1), 'R'::character(1)) AS "Create By",
				f_fmt(vr_dep_5.counterparty_accttitle::text, 'T'::character(1), 25, 0, ''::character(1), 'L'::character(1)) AS "Counterparty Title",
				f_fmt(vr_dep_5.counterparty_acctnbr::text, 'T'::character(1), 14, 0, ''::character(1), 'R'::character(1)) AS "Counterparty Acctnbr",
				f_fmt(vr_dep_5.orderstatus::text, 'T'::character(6), 6, 0, ''::character(6), 'R'::character(6)) AS "Order Status",
				f_fmt(vr_dep_5.recur_freq::text, 'T'::character(1), 10, 0, ''::character(1), 'L'::character(1)) AS "Frequency",
				f_fmt(vr_dep_5.recur_expdtm::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Expire Dt",
				f_fmt(vr_dep_5.recur_lastdtm::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Last Dt",
				f_fmt(vr_dep_5.recur_nextdtm::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Next Dt",
				f_fmt(vr_dep_5.recur_count::text, '$'::character(1), 3, 0, ''::character(1), 'R'::character(1)) AS "Count",
				f_fmt(vr_dep_5.recur_remain::text, '$'::character(1), 3, 0, ''::character(1), 'R'::character(1)) AS "Remaining",
				f_fmt(vr_dep_5.orderamt::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "OrderAmount",
				f_fmt(vr_dep_5.threshholdamt::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Threshhold Amt",
				f_fmt(vr_dep_5.availbal::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Avail Bal",
				f_fmt(vr_dep_5.bal::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Balance"
				from vr_dep_5
				where vr_dep_5.rptasof::date between frprocdate and toprocdate
																					
		union all
																					
			SELECT		-- Select data subtotals by product
				'G'::text AS "RTYPE",
				f_fmt(vr_dep_5.rptasof::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				''::text AS "Position",
				''::text AS "Title",
				f_fmt(vr_dep_5.network::text, 'T'::character(1), 10, 0, ''::character(1), 'L'::character(1)) AS "Network",
				f_fmt(vr_dep_5.ordertype::text, 'T'::character(3), 3, 0, ''::character(3), 'R'::character(3)) AS "Order Type",
				''::text AS "Order Source",
				''::text AS "Order Date",
				''::text AS "Verify Date",
				''::text AS "Check By",
				''::text AS "Origin Source",
				''::text AS "Originate By",
				''::text AS "Create Date",
				''::text AS "Create By",
				''::text AS "Counterparty Title",
				''::text AS "Counterparty Acctnbr",
				f_fmt(vr_dep_5.orderstatus::text, 'T'::character(6), 6, 0, ''::character(6), 'R'::character(6)) AS "Order Status",
				f_fmt(count(vr_dep_5.orderamt)::text, '$'::character(1), 14, 0, ''::character(1), 'R'::character(1)) AS "Frequency",
				''::text AS "Expire Dt",
				''::text AS "Last Dt",
				''::text AS "Next Dt",
				''::text AS "Count",
				''::text AS "Remaining",
				f_fmt(sum(vr_dep_5.orderamt)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "OrderAmount",
				''::text AS "Threshhold Amt",
				''::text AS "Avail Bal",
				''::text AS "Balance"
				from vr_dep_5
				where vr_dep_5.rptasof::date between frprocdate and toprocdate
				GROUP BY 2, 5, 6, 17
				ORDER BY 2, 5, 6, 17, 1
		)

		(	-- List the dtls, subtotaled by product
			select * 
			from dep_5
			union all
			
		
			SELECT 		-- Lay in the report totals at the end
				'T'::text AS "RTYPE",
				'total:' AS "Run Date",
				''::text AS "Position",
				''::text AS "Title",
				''::text AS "Network",
				''::text AS "Order Type",
				''::text AS "Order Source",
				''::text AS "Order Date",
				''::text AS "Verify Date",
				''::text AS "Check By",
				''::text AS "Origin Source",
				''::text AS "Originate By",
				''::text AS "Create Date",
				''::text AS "Create By",
				''::text AS "Counterparty Title",
				''::text AS "Counterparty Acctnbr",
				''::text AS "Order Status",
				f_fmt(count(vr_dep_5.orderamt)::text, '$'::character(1), 14, 0, ''::character(1), 'R'::character(1)) AS "Frequency",
				''::text AS "Expire Dt",
				''::text AS "Last Dt",
				''::text AS "Next Dt",
				''::text AS "Count",
				''::text AS "Remaining",
				''::text AS "OrderAmount",
				''::text AS "Threshhold Amt",
				''::text AS "Avail Bal",
				''::text AS "Balance"
				from vr_dep_5
				where vr_dep_5.rptasof::date between frprocdate and toprocdate
		);

    RETURN next detailcursor;

    END;

$BODY$;

ALTER FUNCTION public.fr_run_dep_5(date, date)
    OWNER TO postgres;

COMMENT ON FUNCTION public.fr_run_dep_5(date, date)
    IS 'Lists all pending customer transactions';



-- FUNCTION: public.fr_run_sav_10(date)

-- DROP FUNCTION public.fr_run_sav_10(date);

CREATE OR REPLACE FUNCTION public.fr_run_sav_10(
	procdate date DEFAULT CURRENT_DATE)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	declare
		detailcursor refcursor := 'detail';
		nullval text;
	
    BEGIN
	    OPEN detailcursor FOR 
		
		with sav_10 as (
			
			select		-- Select dtl data
				'D'::text AS "RTYPE",
				f_fmt(vr_sav_10._id::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Id",
				f_fmt(vr_sav_10.trndtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_sav_10.acctnbr::text, 'T'::character(1), 14, 0, ''::character(1), 'R'::character(1)) AS "Account Number",
				f_fmt(vr_sav_10.posnref::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				f_fmt(vr_sav_10.prodname::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Product",
				f_fmt(vr_sav_10.ccycode::text, 'T'::character(1), 4, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(vr_sav_10.trncode::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Transaction Code",
				f_fmt(vr_sav_10.effectdtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Eff Date",
				f_fmt(vr_sav_10.gljrnldate::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "GL Date",
				f_fmt(vr_sav_10.reverse::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Reverse",
				f_fmt(vr_sav_10.reversedby::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Reversed By",
				case when f_fmt(vr_sav_10.isdr::text, 'B'::character(1), 1, 0, ''::character(1), 'L'::character(1)) = 'Y'
					then f_fmt(vr_sav_10.amt::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1))
					else ''
				end AS "Dr Amount",
				case when f_fmt(vr_sav_10.isdr::text, 'B'::character(1), 1, 0, ''::character(1), 'L'::character(1)) = 'N'
					then f_fmt(vr_sav_10.amt::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1))
					else ''
				end AS "Cr Amount",
				f_fmt(vr_sav_10.authall::text, 'B'::character(1), 1, 0, ''::character(1), 'L'::character(1)) AS "AuthAll",
				f_fmt(vr_sav_10.except_code::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "ExCode",
				f_fmt(vr_sav_10.except_reason::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Reason",
				f_fmt(vr_sav_10.logref::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Log Ref",
				f_fmt(vr_sav_10.except_note::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Note",
				f_fmt(vr_sav_10.network::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Network",
				f_fmt(vr_sav_10.mode::text, 'T'::character(1), 5, 0, ''::character(1), 'L'::character(1)) AS "Processing Mode",
				f_fmt(vr_sav_10.batchid::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Batch ID"
				from vr_sav_10
				where vr_sav_10.trndtm::date = procdate and vr_sav_10.rptasof::date = procdate
																					
		union all

			SELECT		-- Select data totals by product
				'G'::text AS "RTYPE",
				''::text AS "Id",
				f_fmt(vr_sav_10.trndtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				''::text AS "Account Number",
				f_fmt(count(vr_sav_10.except_code)::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Position",
				f_fmt(vr_sav_10.prodname::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Product",
				''::text AS "CrCd",
				''::text AS "Transaction Code",
				''::text AS "Eff Date",
				''::text AS "GL Date",
				''::text AS "Reverse",
				''::text AS "Reversed By",
				''::text AS "Dr Amount",
				''::text AS "Cr Amount",
				''::text AS "AuthAll",
				''::text AS "ExCode",
				''::text AS "Reason",
				''::text AS "Log Ref",
				''::text AS "Note",
				''::text AS "Network",
				''::text AS "Processing Mode",
				''::text AS "Batch ID"
				from vr_sav_10
				where vr_sav_10.trndtm::date = procdate and vr_sav_10.rptasof::date = procdate
				GROUP BY vr_sav_10.trndtm::date, vr_sav_10.prodname
		
		union all
		
			SELECT 		-- Lay in the report totals at the end
				'T'::text AS "RTYPE",
				''::text AS "Id",
				f_fmt(vr_sav_10.trndtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				''::text AS "Account Number",
				f_fmt(count(vr_sav_10.except_code)::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Position",
				nullval::text AS "Product",
				''::text AS "CrCd",
				''::text AS "Transaction Code",
				''::text AS "Eff Date",
				''::text AS "GL Date",
				''::text AS "Reverse",
				''::text AS "Reversed By",
				''::text AS "Dr Amount",
				''::text AS "Cr Amount",
				''::text AS "AuthAll",
				''::text AS "ExCode",
				''::text AS "Reason",
				''::text AS "Log Ref",
				''::text AS "Note",
				''::text AS "Network",
				''::text AS "Processing Mode",
				''::text AS "Batch ID"
				from vr_sav_10
				where vr_sav_10.trndtm::date = procdate and vr_sav_10.rptasof::date = procdate
				GROUP BY vr_sav_10.trndtm::date
		)

		(	-- List the dtls, subtotaled by product
			select * 
			from sav_10
			order by sav_10."Run Date", sav_10."Product", sav_10."RTYPE"
		)
		;

    RETURN next detailcursor;

    END;


$BODY$;

ALTER FUNCTION public.fr_run_sav_10(date)
    OWNER TO postgres;

COMMENT ON FUNCTION public.fr_run_sav_10(date)
    IS 'Lists all customer transactions excepts for an accounting day';


-- FUNCTION: public.fr_run_sav_10a(date)

-- DROP FUNCTION public.fr_run_sav_10a(date);

CREATE OR REPLACE FUNCTION public.fr_run_sav_10a(
	procdate date DEFAULT CURRENT_DATE)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	declare
		detailcursor refcursor := 'detail';
		nullval text;
	
    BEGIN
	    OPEN detailcursor FOR 
		
		with sav_10 as (
			
			select		-- Select dtl data
				'D'::text AS "RTYPE",
				f_fmt(vr_sav_10a.trndtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "ProcessDt",
				f_fmt(vr_sav_10a.gljrnldate::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "GL Date",
				f_fmt(vr_sav_10a.effectdtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Eff Date",
				f_fmt(vr_sav_10a._id::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Id",
				f_fmt(vr_sav_10a.trncode::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Transaction Code",
				f_fmt(vr_sav_10a.posnref::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				f_fmt(vr_sav_10a.dramount::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Dr Amount",
				f_fmt(vr_sav_10a.cramount::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Cr Amount",
				f_fmt(vr_sav_10a.ccycode::text, 'T'::character(1), 4, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(vr_sav_10a.reverse::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Reverse",
				f_fmt(vr_sav_10a.reversedby::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Reversed By",
				f_fmt(vr_sav_10a.prodname::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Product",
				f_fmt(vr_sav_10a.glsetcode::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "GLSetCode",
				f_fmt(vr_sav_10a.network::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Network",
				f_fmt(vr_sav_10a.batchid::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Batch ID",
				f_fmt(vr_sav_10a.logref::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Log Ref",
				f_fmt(vr_sav_10a.gldist_ledger::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Ledger",
				f_fmt(vr_sav_10a.gldist_accrint::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Acr Int",
				f_fmt(vr_sav_10a.gldist_avlint::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Avail Int",
				f_fmt(vr_sav_10a.gldist_negaccr::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Neg Acr",
				f_fmt(vr_sav_10a.gldist_accrfee::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Acr Fee",
				f_fmt(vr_sav_10a.gldist_wthstate::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "State With",
				f_fmt(vr_sav_10a.gldist_wthfed::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Fed With"
				from vr_sav_10a
				where vr_sav_10a.trndtm::date = procdate and vr_sav_10a.rptasof::date = procdate
																					
		union all

			SELECT		-- Select data totals by product
				'G'::text AS "RTYPE",
				f_fmt(vr_sav_10a.trndtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "ProcessDt",
				''::text AS "GL Date",
				''::text AS "Eff Date",
				''::text AS "Id",
				f_fmt(vr_sav_10a.trncode::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Transaction Code",
				f_fmt(count(vr_sav_10a.trndtm)::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Position",
				f_fmt(sum(vr_sav_10a.dramount::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Dr Amount",
				f_fmt(sum(vr_sav_10a.cramount::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Cr Amount",
				''::text AS "CrCd",
				''::text AS "Reverse",
				''::text AS "Reversed By",
				''::text AS "Product",
				f_fmt(vr_sav_10a.glsetcode::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "GLSetCode",
				''::text AS "Network",
				''::text AS "Batch ID",
				''::text AS "Log Ref",
				f_fmt(sum(vr_sav_10a.gldist_ledger::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Ledger",
				f_fmt(sum(vr_sav_10a.gldist_accrint::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Acr Int",
				f_fmt(sum(vr_sav_10a.gldist_avlint::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Avail Int",
				f_fmt(sum(vr_sav_10a.gldist_negaccr::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Neg Acr",
				f_fmt(sum(vr_sav_10a.gldist_accrfee::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Acr Fee",
				f_fmt(sum(vr_sav_10a.gldist_wthstate::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "State With",
				f_fmt(sum(vr_sav_10a.gldist_wthfed::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Fed With"
				from vr_sav_10a
				where vr_sav_10a.trndtm::date = procdate and vr_sav_10a.rptasof::date = procdate
				GROUP BY vr_sav_10a.trndtm::date, vr_sav_10a.glsetcode, vr_sav_10a.trncode
		
		union all
		
			SELECT 		-- Lay in the report totals at the end
				'T'::text AS "RTYPE",
				f_fmt(vr_sav_10a.trndtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "ProcessDt",
				''::text AS "GL Date",
				''::text AS "Eff Date",
				''::text AS "Id",
				nullval::text AS "Transaction Code",
				f_fmt(count(vr_sav_10a.rptasof)::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Position",
				f_fmt(sum(vr_sav_10a.dramount::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Dr Amount",
				f_fmt(sum(vr_sav_10a.cramount::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Cr Amount",
				''::text AS "CrCd",
				''::text AS "Reverse",
				''::text AS "Reversed By",
				''::text AS "Product",
				f_fmt(vr_sav_10a.glsetcode::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "GLSetCode",
				''::text AS "Network",
				''::text AS "Batch ID",
				''::text AS "Log Ref",
				f_fmt(sum(vr_sav_10a.gldist_ledger::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Ledger",
				f_fmt(sum(vr_sav_10a.gldist_accrint::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Acr Int",
				f_fmt(sum(vr_sav_10a.gldist_avlint::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Avail Int",
				f_fmt(sum(vr_sav_10a.gldist_negaccr::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Neg Acr",
				f_fmt(sum(vr_sav_10a.gldist_accrfee::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Acr Fee",
				f_fmt(sum(vr_sav_10a.gldist_wthstate::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "State With",
				f_fmt(sum(vr_sav_10a.gldist_wthfed::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Fed With"
				from vr_sav_10a
				where vr_sav_10a.trndtm::date = procdate and vr_sav_10a.rptasof::date = procdate
				GROUP BY vr_sav_10a.trndtm::date, vr_sav_10a.glsetcode
		)

		(	-- List the dtls, subtotaled by product
			select * 
			from sav_10
			order by sav_10."ProcessDt", sav_10."GLSetCode" nulls last, sav_10."Transaction Code" nulls last, sav_10."RTYPE"
		)
		;

    RETURN next detailcursor;

    END;


$BODY$;

ALTER FUNCTION public.fr_run_sav_10a(date)
    OWNER TO postgres;

COMMENT ON FUNCTION public.fr_run_sav_10a(date)
    IS 'Lists the details of all customer transactions for an accounting day';

--
-- TOC entry 280 (class 1255 OID 22425)
-- Name: fr_run_sav_11(date); Type: FUNCTION; Schema: public; Owner: postgres
--

-- FUNCTION: public.fr_run_sav_11(date)

-- DROP FUNCTION public.fr_run_sav_11(date);

CREATE OR REPLACE FUNCTION public.fr_run_sav_11(
	procdate date DEFAULT CURRENT_DATE)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$



	declare
		detailcursor refcursor := 'detail';
		nullval text;
	
	BEGIN
	    OPEN detailcursor FOR 
		
		with sav_11 as (
			
			select		-- Select dtl data
				'D'::text AS "RTYPE",
				f_fmt(vr_sav_11.rptasof::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_sav_11.posnref::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				f_fmt(vr_sav_11.accttitle::text, 'T'::character(1), 25, 0, ''::character(1), 'L'::character(1)) AS "Title",
				f_fmt(vr_sav_11.prodname::text, 'T'::character(1), 5, 0, ''::character(1), 'L'::character(1)) AS "Prod",
				f_fmt(vr_sav_11.glsetcode::text, 'T'::character(1), 14, 0, ''::character(1), 'L'::character(1)) AS "GL Set",
				f_fmt(vr_sav_11.deptid::text, 'T'::character(1), 5, 0, ''::character(1), 'R'::character(1)) AS "Dept",
				f_fmt(vr_sav_11.vertical::text, 'T'::character(1), 5, 0, ''::character(1), 'R'::character(1)) AS "Vert",
				f_fmt(vr_sav_11.ccycode::text, 'T'::character(1), 4, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(vr_sav_11.bal::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Balance",
				f_fmt(vr_sav_11.availbal::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Avail Bal",
				f_fmt(vr_sav_11.glbal::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "GL Bal",
				f_fmt(vr_sav_11.opendtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Date Opened",
				f_fmt(vr_sav_11.isbrokered::text, 'B'::character(1), 2, 0, ''::character(1), 'L'::character(1)) AS "Is Broker",
				f_fmt(vr_sav_11.nomrate::text, '$'::character(1), 9, 5, ''::character(1), 'R'::character(1)) AS "Int Rate",
				f_fmt(vr_sav_11.apye::text, '$'::character(1), 9, 5, ''::character(1), 'R'::character(1)) AS "APYE",
				f_fmt(vr_sav_11.nextpostdtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Nxt Pd Dt",
				f_fmt(vr_sav_11.acrintbal::text, '$'::character(1), 14, 5, ''::character(1), 'R'::character(1)) AS "ACR Earned",
				f_fmt(vr_sav_11.sumintpd::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Int Paid",
				f_fmt(vr_sav_11.sumwthfed::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Fed Withheld",
				f_fmt(vr_sav_11.sumwthstate::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "St Withhheld",
				f_fmt(vr_sav_11.ishold::text, 'B'::character(1), 2, 0, ''::character(1), 'L'::character(1)) AS "Hold",
				f_fmt(vr_sav_11.isrestrict::text, 'B'::character(1), 2, 0, ''::character(1), 'L'::character(1)) AS "Rest",
				f_fmt(vr_sav_11.isstop::text, 'B'::character(1), 2, 0, ''::character(1), 'L'::character(1)) AS "Stop"
			FROM vr_sav_11
			where vr_sav_11.rptasof::date = procdate
			
		union all
			
			SELECT		-- Select data subtotals by product
				'G'::text AS "RTYPE",
				f_fmt(vr_sav_11.rptasof::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(count(vr_sav_11.posnref)::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				''::text AS "Title",
				f_fmt(vr_sav_11.prodname::text, 'T'::character(1), 5, 0, ''::character(1), 'L'::character(1)) AS "Prod",
				f_fmt(vr_sav_11.glsetcode::text, 'T'::character(1), 14, 0, ''::character(1), 'L'::character(1)) AS "GL Set",
				''::text AS "Dept",
				''::text AS "Vert",
  				''::text AS "CrCd",
				f_fmt(sum(vr_sav_11.bal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Balance",
				f_fmt(sum(vr_sav_11.availbal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Avail Bal",
				f_fmt(sum(vr_sav_11.glbal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "GL Bal",
				''::text AS "Date Opened",
				''::text AS "Is Broker",
				''::text AS "Int Rate",
				''::text AS "APYE",
				''::text AS "Nxt Pd Dt",
				f_fmt(sum(vr_sav_11.acrintbal)::text, '$'::character(1), 14, 5, ''::character(1), 'R'::character(1)) AS "ACR Earned",
				f_fmt(sum(vr_sav_11.sumintpd)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Int Paid",
				f_fmt(sum(vr_sav_11.sumwthfed)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Fed Withheld",
				f_fmt(sum(vr_sav_11.sumwthstate)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "St Withhheld",
				''::text AS "Hold",
				''::text AS "Rest",
				''::text AS "Stop"
			FROM vr_sav_11
			where vr_sav_11.rptasof::date = procdate
			GROUP BY vr_sav_11.rptasof, vr_sav_11.prodname, vr_sav_11.glsetcode
		)
		
		(	-- List the dtls, subtotaled by product
			select *
			from sav_11
			order by sav_11."Run Date", sav_11."Prod", sav_11."GL Set", sav_11."RTYPE"
		)
		
		union all
		
		SELECT 		-- Lay in the report totals at the end
			'T'::text AS "RTYPE",
			f_fmt(vr_sav_11.rptasof::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
			f_fmt(count(vr_sav_11.posnref)::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
			''::text AS "Title",
			''::text AS "Prod",
			''::text AS "GL Set",
			''::text AS "Dept",
			''::text AS "Vert",
  			''::text AS "CrCd",
			f_fmt(sum(vr_sav_11.bal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Balance",
			f_fmt(sum(vr_sav_11.availbal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Avail Bal",
			f_fmt(sum(vr_sav_11.glbal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "GL Bal",
			''::text AS "Date Opened",
			''::text AS "Is Broker",
			''::text AS "Int Rate",
			''::text AS "APYE",
			''::text AS "Nxt Pd Dt",
			f_fmt(sum(vr_sav_11.acrintbal)::text, '$'::character(1), 14, 5, ''::character(1), 'R'::character(1)) AS "ACR Earned",
			f_fmt(sum(vr_sav_11.sumintpd)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Int Paid",
			f_fmt(sum(vr_sav_11.sumwthfed)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Fed Withheld",
			f_fmt(sum(vr_sav_11.sumwthstate)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "St Withhheld",
			''::text AS "Hold",
			''::text AS "Rest",
			''::text AS "Stop"
		FROM vr_sav_11
		where vr_sav_11.rptasof::date = procdate
		GROUP BY vr_sav_11.rptasof::date
		;
		
    RETURN next detailcursor;

    END


$BODY$;

ALTER FUNCTION public.fr_run_sav_11(date)
    OWNER TO postgres;

COMMENT ON FUNCTION public.fr_run_sav_11(date)
    IS 'Lists all customer position bals by product for an accounting day.';

--
-- TOC entry 288 (class 1255 OID 22558)
-- Name: fr_run_sav_2(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

-- FUNCTION: public.fr_run_sav_2(date, date)

-- DROP FUNCTION public.fr_run_sav_2(date, date);

CREATE OR REPLACE FUNCTION public.fr_run_sav_2(
	frprocdate date DEFAULT CURRENT_DATE,
	toprocdate date DEFAULT CURRENT_DATE)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	declare
		detailcursor refcursor := 'detail';
		nullval text;
	
    BEGIN
	    OPEN detailcursor FOR 
		
		with sav_2 as (
			
			select		-- Select dtl data
				'D'::text AS "RTYPE",
				f_fmt(vr_sav_2.trndtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_sav_2.posnref::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				f_fmt(vr_sav_2.accttitle::text, 'T'::character(1), 25, 0, ''::character(1), 'L'::character(1)) AS "Title",
				f_fmt(vr_sav_2.prodname::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Product",
				f_fmt(vr_sav_2.ccycode::text, 'T'::character(1), 4, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(vr_sav_2.trncode::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Transaction Code",
				f_fmt(vr_sav_2.trndesc::text, 'T'::character(1), 25, 0, ''::character(1), 'L'::character(1)) AS "Description",
				f_fmt(vr_sav_2.network::text, 'T'::character(1), 25, 0, ''::character(1), 'L'::character(1)) AS "Network",
				f_fmt(vr_sav_2._id::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Id",
				f_fmt(vr_sav_2.reverse::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Reverse",
				f_fmt(vr_sav_2.reversedby::text, 'T'::character(1), 42, 0, ''::character(1), 'L'::character(1)) AS "Reversed By",
				f_fmt(vr_sav_2.amt::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Amount"
				from vr_sav_2
				where vr_sav_2.trndtm::date between frprocdate and toprocdate and vr_sav_2.rptasof::date = toprocdate
																					
		union all
																					
			SELECT		-- Select data subtotals by product
				'G'::text AS "RTYPE",
				f_fmt(vr_sav_2.trndtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_sav_2.posnref::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				''::text AS "Title",
				''::text AS "Product",
				f_fmt(count(vr_sav_2.amt)::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(vr_sav_2.trncode::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Transaction Code",
				''::text AS "Description",
				''::text AS "Network",
				''::text AS "Id",
				f_fmt(count(vr_sav_2.reverse)::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Reverse",
				''::text AS "Reversed By",
				''::text AS "Amount"
				from vr_sav_2
				where vr_sav_2.trndtm::date between frprocdate and toprocdate and vr_sav_2.rptasof::date = toprocdate
				GROUP BY vr_sav_2.trndtm::date, vr_sav_2.posnref, vr_sav_2.trncode
		
		union all
		
			SELECT 		-- Lay in the report totals at the end
				'T'::text AS "RTYPE",
				f_fmt(vr_sav_2.trndtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_sav_2.posnref::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				''::text AS "Title",
				''::text AS "Product",
				f_fmt(count(vr_sav_2.amt)::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				nullval::text AS "Transaction Code",
				''::text AS "Description",
				''::text AS "Network",
				''::text AS "Id",
				f_fmt(count(vr_sav_2.reverse)::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Reverse",
				''::text AS "Reversed By",
				''::text AS "Amount"
				from vr_sav_2
				where vr_sav_2.trndtm::date between frprocdate and toprocdate and vr_sav_2.rptasof::date = toprocdate
				GROUP BY vr_sav_2.trndtm::date, vr_sav_2.posnref
		)

		(	-- List the dtls, subtotaled by product
			select * 
			from sav_2
			order by sav_2."Run Date", sav_2."Position" nulls last, sav_2."Transaction Code" nulls last, sav_2."RTYPE"
		)
		;

    RETURN next detailcursor;

    END;

$BODY$;

ALTER FUNCTION public.fr_run_sav_2(date, date)
    OWNER TO postgres;

COMMENT ON FUNCTION public.fr_run_sav_2(date, date)
    IS 'Lists all customer transactions that could be considered for Reg D';


-- FUNCTION: public.fr_run_sav_6(date, date)

-- DROP FUNCTION public.fr_run_sav_6(date, date);

CREATE OR REPLACE FUNCTION public.fr_run_sav_6(
	fropendate date DEFAULT CURRENT_DATE,
	toopendate date DEFAULT CURRENT_DATE,
	procdate date DEFAULT CURRENT_DATE)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	declare
		detailcursor refcursor := 'detail';
		nullval text;
	
	BEGIN
	    OPEN detailcursor FOR 
		
		with sav_6 as (
			
			select		-- Select dtl data
				'D'::text AS "RTYPE",
				f_fmt(vr_sav_6.opendtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Date Open",
				f_fmt(vr_sav_6.prodname::text, 'T'::character(1), 5, 0, ''::character(1), 'L'::character(1)) AS "Prod",
				f_fmt(vr_sav_6.ifxaccttype::text, 'T'::character(1), 5, 0, ''::character(1), 'L'::character(1)) AS "Prod Type",
				f_fmt(vr_sav_6.glsetcode::text, 'T'::character(1), 14, 0, ''::character(1), 'L'::character(1)) AS "GL Set",
				f_fmt(vr_sav_6.deptid::text, 'T'::character(1), 5, 0, ''::character(1), 'R'::character(1)) AS "Dept",
				f_fmt(vr_sav_6.vertical::text, 'T'::character(1), 5, 0, ''::character(1), 'R'::character(1)) AS "Vert",
				f_fmt(vr_sav_6.posnref::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				f_fmt(vr_sav_6.ccycode::text, 'T'::character(1), 4, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(vr_sav_6.accttitle::text, 'T'::character(1), 25, 0, ''::character(1), 'L'::character(1)) AS "Title",
				f_fmt(vr_sav_6.isbrokered::text, 'B'::character(1), 2, 0, ''::character(1), 'L'::character(1)) AS "Brokered",
				f_fmt(vr_sav_6.nomrate::text, '$'::character(1), 9, 5, ''::character(1), 'R'::character(1)) AS "Int Rate",
				f_fmt(vr_sav_6.pledgedbal::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Pledged Balance",
			    f_fmt(vr_sav_6.fundexpdtm::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Funding Expiration",
				f_fmt(vr_sav_6.availbal::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Avail Bal",
				f_fmt(vr_sav_6.bal::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Balance"
			FROM vr_sav_6
			where vr_sav_6.opendtm::date between fropendate and toopendate and vr_sav_6.rptasof::date = procdate
			
		union all
			
			SELECT		-- Select data subtotals by product
				'G'::text AS "RTYPE",
				f_fmt(vr_sav_6.opendtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Date Open",
				f_fmt(vr_sav_6.prodname::text, 'T'::character(1), 5, 0, ''::character(1), 'L'::character(1)) AS "Prod",
				''::text AS "Prod Type",
				f_fmt(vr_sav_6.glsetcode::text, 'T'::character(1), 14, 0, ''::character(1), 'L'::character(1)) AS "GL Set",
				''::text AS "Dept",
				''::text AS "Vert",
				count(vr_sav_6.posnref)::text  AS "Position",
  				''::text AS "CrCd",
				''::text AS "Title",
				''::text AS "Brokered",
				''::text AS "Int Rate",
				f_fmt(sum(vr_sav_6.pledgedbal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Pledged Balance",
			    ''::text AS "Funding Expiration",
				f_fmt(sum(vr_sav_6.availbal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1))AS "Avail Bal",
				f_fmt(sum(vr_sav_6.bal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Balance"
			FROM vr_sav_6
			where vr_sav_6.opendtm::date between fropendate and toopendate and vr_sav_6.rptasof::date = procdate
			GROUP BY vr_sav_6.opendtm, vr_sav_6.prodname, vr_sav_6.glsetcode

		union all
		
			SELECT 		-- Lay in the report totals at the end
				'T'::text AS "RTYPE",
				f_fmt(vr_sav_6.opendtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Date Open",
				nullval::text AS "Prod",
				''::text AS "Prod Type",
				nullval::text AS "GL Set",
				''::text AS "Dept",
				''::text AS "Vert",
				count(vr_sav_6.posnref)::text AS "Position",
  				''::text AS "CrCd",
				''::text AS "Title",
				''::text AS "Brokered",
				''::text AS "Int Rate",
				f_fmt(sum(vr_sav_6.pledgedbal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Pledged Balance",
			    ''::text AS "Funding Expiration",
				f_fmt(sum(vr_sav_6.availbal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1))AS "Avail Bal",
				f_fmt(sum(vr_sav_6.bal)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Balance"
			FROM vr_sav_6
			where vr_sav_6.opendtm::date between fropendate and toopendate and vr_sav_6.rptasof::date = procdate
			GROUP BY vr_sav_6.opendtm
		)
		
		(	-- List the dtls, subtotaled by product
			select *
			from sav_6
			order by sav_6."Date Open", sav_6."Prod" nulls last, sav_6."GL Set" nulls last, sav_6."RTYPE"
		)
		;
		
    RETURN next detailcursor;

    END


$BODY$;

ALTER FUNCTION public.fr_run_sav_6(date, date, date)
    OWNER TO postgres;

COMMENT ON FUNCTION public.fr_run_sav_6(date, date, date)
    IS 'Lists all customer position bals by product for an accounting day.';




--
-- TOC entry 281 (class 1255 OID 22409)
-- Name: fr_run_trns_4(date); Type: FUNCTION; Schema: public; Owner: postgres
--

-- FUNCTION: public.fr_run_trns_4(date)

-- DROP FUNCTION public.fr_run_trns_4(date);

CREATE OR REPLACE FUNCTION public.fr_run_trns_4(
	procdate date DEFAULT CURRENT_DATE)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	declare
		detailcursor refcursor := 'detail';
		nullval text;
	
    BEGIN
	    OPEN detailcursor FOR 
		
		with trns_4 as (
			
			select		-- Select dtl data
				'D'::text AS "RTYPE",
				f_fmt(vr_trns_4.trndtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				f_fmt(vr_trns_4.posnref::text, 'T'::character(1), 13, 0, ''::character(1), 'R'::character(1)) AS "Position",
				f_fmt(vr_trns_4.prodname::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Product",
				f_fmt(vr_trns_4.ccycode::text, 'T'::character(1), 4, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				f_fmt(vr_trns_4.trncode::text, 'T'::character(1), 12, 0, ''::character(1), 'L'::character(1)) AS "Transaction Code",
				f_fmt(vr_trns_4.effectdtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Eff Date",
				f_fmt(vr_trns_4.gljrnldate::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "GL Date",
				f_fmt(vr_trns_4.network::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Network",
				f_fmt(vr_trns_4.batchid::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Batch ID",
				f_fmt(vr_trns_4.reverse::text, 'T'::character(1), 22, 0, ''::character(1), 'L'::character(1)) AS "Reverse",
				f_fmt(vr_trns_4.reversedby::text, 'T'::character(1), 22, 0, ''::character(1), 'L'::character(1)) AS "Reversed By",
				f_fmt(vr_trns_4.mode::text, 'T'::character(1), 5, 0, ''::character(1), 'L'::character(1)) AS "Processing Mode",
				f_fmt(vr_trns_4.logref::text, 'T'::character(1), 20, 0, ''::character(1), 'L'::character(1)) AS "Message Log Ref",
				f_fmt(vr_trns_4.dramount::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Dr Amount",
				f_fmt(vr_trns_4.cramount::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Cr Amount"
				from vr_trns_4
				where vr_trns_4.trndtm::date = procdate and vr_trns_4.rptasof::date = procdate 
																					
		union all

			SELECT		-- Select data totals by product
				'G'::text AS "RTYPE",
				f_fmt(vr_trns_4.trndtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				nullval::text AS "Position",
				f_fmt(vr_trns_4.prodname::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "Product",
				f_fmt(count(vr_trns_4.amt)::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				''::text AS "Transaction Code",
				''::text AS "Eff Date",
				''::text AS "GL Date",
				''::text AS "Network",
				''::text AS "Batch ID",
				''::text AS "Reverse",
				''::text AS "Reversed By",
				''::text AS "Processing Mode",
				''::text AS "Message Log Ref",
				f_fmt(sum(vr_trns_4.dramount::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Dr Amount",
				f_fmt(sum(vr_trns_4.cramount::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Cr Amount"
				from vr_trns_4
				where vr_trns_4.trndtm::date = procdate and vr_trns_4.rptasof::date = procdate
				GROUP BY vr_trns_4.trndtm::date, vr_trns_4.prodname
		
		union all
		
			SELECT 		-- Lay in the report totals at the end
				'T'::text AS "RTYPE",
				f_fmt(vr_trns_4.trndtm::date::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) AS "Run Date",
				nullval::text AS "Position",
				nullval::text AS "Product",
				f_fmt(count(vr_trns_4.amt)::text, 'T'::character(1), 15, 0, ''::character(1), 'L'::character(1)) AS "CrCd",
				''::text AS "Transaction Code",
				''::text AS "Eff Date",
				''::text AS "GL Date",
				''::text AS "Network",
				''::text AS "Batch ID",
				''::text AS "Reverse",
				''::text AS "Reversed By",
				''::text AS "Processing Mode",
				''::text AS "Message Log Ref",
				f_fmt(sum(vr_trns_4.dramount::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Dr Amount",
				f_fmt(sum(vr_trns_4.cramount::numeric)::text, '$'::character(1), 14, 2, ''::character(1), 'R'::character(1)) AS "Cr Amount"
				from vr_trns_4
				where vr_trns_4.trndtm::date = procdate and vr_trns_4.rptasof::date = procdate
				GROUP BY vr_trns_4.trndtm::date
		)

		(	-- List the dtls, subtotaled by product
			select * 
			from trns_4
			order by trns_4."Run Date", trns_4."Product" nulls last, trns_4."Position" nulls last, trns_4."RTYPE"
		)
		;

    RETURN next detailcursor;

    END;


$BODY$;

ALTER FUNCTION public.fr_run_trns_4(date)
    OWNER TO postgres;

COMMENT ON FUNCTION public.fr_run_trns_4(date)
    IS 'Lists all manually posted customer transactions for an accounting day';

--
-- TOC entry 268 (class 1255 OID 16404)
-- Name: ftr_institution_coredb_up(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ftr_institution_coredb_up() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (NEW.coredb not in (select database from v_database_list)) THEN
        RAISE NOTICE 'Invalid Database Name';
    END IF;
 
    RETURN null;
END;

$$;


ALTER FUNCTION public.ftr_institution_coredb_up() OWNER TO postgres;

-- FUNCTION: public.fr_run_trns_4(date)

-- DROP FUNCTION public.fr_run_trns_4(date);

CREATE OR REPLACE FUNCTION public.fr_run_gl_bal(
	procdate date DEFAULT CURRENT_DATE)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	declare
		detailcursor refcursor := 'detail';
		nullval text;
	
    BEGIN
	    OPEN detailcursor FOR 
		
		with gl_bal as (
			
			select		-- Select dtl data
				'D'::text AS "RTYPE",
				f_fmt(glDate::text, 'D'::character(1), 9, 0, ''::character(1), 'R'::character(1)) as "GL Date",
                regionid::text as "Region ID",
				deptid::text as "Dept ID",
				acctnum::text as "Acct Number",
				accttitle as "Acct Title",
				glcat::text as "GL Category",
				balance as "Balance",
				totcntcr::text as "Total Cr Cnt",
				totcntdr::text as "Total Dr Cnt",
				totamtcr as "Total Cr Amt",
				totamtdr as "Total Dr Amt"																						
				from gl_bal_info
				where glDate = procdate
																					
		union all
			SELECT		-- Select data totals by product
				'G'::text AS "RTYPE",
				''::text as "GL Date",
                regionid::text as "Region ID",
				deptid::text as "Dept ID",
				'' as "Acct Number",
				'' as "Acct Title",
				'' as "GL Category",
				sum(runtotal) as "Balance",
				'' as "Total Cr Cnt",
				'' as "Total Dr Cnt",
				sum(totamtcr) as "Total Cr Amt",
				sum(totamtdr) as "Total Dr Amt"																						
				from gl_bal_info
				where glDate = procdate 
				GROUP BY 3, 4
		)

		(	-- List the dtls, subtotaled by product
			select * 
			from gl_bal
			order by 3, 4, 1
		);

    RETURN next detailcursor;

    END;

$BODY$;

ALTER FUNCTION public.fr_run_gl_bal(date)
    OWNER TO postgres;

COMMIT;
