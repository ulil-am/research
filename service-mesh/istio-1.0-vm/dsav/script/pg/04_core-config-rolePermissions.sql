--
-- Name: 
--    04_core-config-rolePermissions.sql
-- Purpose: 
--    This file stores all core API entitlements for the "developer" 
--    userRole.  The 02_dev_role_permissions file contains all model 
--    API entitlements for the "developer" role, is system generated,
--    and should not be added here.
-- \c zbch_trn_db specifies to which database to use in pgsql

\c zbch_trn_db

BEGIN;

INSERT INTO public."rolePermission" ("isPermit","operation","userRole") VALUES 
(true,'ach_CreateFile','developer'),
(true,'altAcrAmt','developer'),
(true,'calcNextDt','developer'),
(true,'cancelOrder','developer'),
(true,'cancelRecSeriesOrder','developer'),
(true,'cancelRecSingleOrder','developer'),
(true,'closeAcctBk','developer'),
(true,'closePosnBk','developer'),
(true,'createAcctBk','developer'),
(true,'createFiles','developer'),
(true,'enterOrder','developer'),
(true,'findPosnHist','developer'),
(true,'getAcctBk','developer'),
(true,'getFile','developer'),
(true,'glBalancingGlSum','developer'),
(true,'glBalancingPosnBal','developer'),
(true,'glExtract','developer'),
(true,'listFiles','developer'),
(true,'listTrans','developer'),
(true,'modifyHold','developer'),
(true,'modifyOrder','developer'),
(true,'placeHold','developer'),
(true,'postTrans','developer'),
(true,'rollover','developer'),
(true,'listReports','developer'),
(true,'getReport','developer'),
(true,'runReport','developer'),
(true,'calcADB','developer'),
(true,'calcAPYE','developer');
END;



