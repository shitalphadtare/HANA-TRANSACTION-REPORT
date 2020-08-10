/*****************************WILLOW******************************************/


IF EXISTS (SELECT NAME FROM SYSOBJECTS WHERE NAME='PAYMENT_VOUCHER_CHEQUE')
DROP VIEW PAYMENT_VOUCHER_CHEQUE
GO



create VIEW PAYMENT_VOUCHER_CHEQUE
AS

SELECT ACT."FormatCode" AS "ActCode", 
CASE WHEN VPM1."AcctNum" IS NULL THEN ACT."FormatCode" ELSE VPM1."AcctNum" END AS "AcctNumber", * 

FROM (SELECT "DocNum", "AcctNum", "CheckNum" AS "checknum", "CheckAct", "DueDate" AS "duedate", 
"CheckSum" AS "CheckAmt", "BankCode" FROM VPM1) AS vpm1 

LEFT OUTER JOIN (SELECT "BankCode" AS "BankCode1", "BankName" FROM ODSC) AS odsc ON vpm1."BankCode" = odsc."BankCode1" 
LEFT OUTER JOIN OACT ACT ON VPM1."CheckAct" = ACT."AcctCode";	
		



GO


