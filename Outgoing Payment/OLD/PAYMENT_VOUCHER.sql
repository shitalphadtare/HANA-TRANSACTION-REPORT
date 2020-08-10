IF EXISTS (SELECT NAME FROM SYSOBJECTS WHERE NAME='PAYMENT_VOUCHER')
DROP VIEW PAYMENT_VOUCHER
GO


Create VIEW PAYMENT_VOUCHER
AS

SELECT OVPM."DocNum", OVPM."DocEntry", 
CASE WHEN OVPM."Series" = -1 THEN 'Manual' ELSE NNM1."SeriesName" END || '/' || CAST(OVPM."DocNum" AS varchar(20)) AS "VoucherNo", 
OVPM."DocDate", OVPM."Address", 
CASE WHEN OVPM."DocCurr" = 'INR' THEN OVPM."CashSum" ELSE OVPM."CashSumFC" END AS "CashSum", 
CASE WHEN OVPM."DocCurr" = 'INR' THEN OVPM."CheckSum" ELSE OVPM."CheckSumFC" END AS "CheckSum", 
CASE WHEN OVPM."DocCurr" = 'INR' THEN OVPM."TrsfrSum" ELSE OVPM."TrsfrSumFC" END AS "Bnksum", 
OVPM."TrsfrRef" AS "BnkTrsFrRef", OVPM."TrsfrDate" AS "BnkTrsFrDt", ACT2."FormatCode" AS "BnkTrsFrAcct", 
ACT2."AcctName" AS "BankNm", ACT3."FormatCode" AS "CashAct", ACT3."FormatCode" AS "CashActCode", 
ACT3."AcctName" AS "CashName", OACT."FormatCode" AS "Account", VPM4."AcctName", VPM4."Project", 
(SELECT "PrjName" FROM OPRJ WHERE "PrjCode" = VPM4."Project") AS "ProjectName", 
NULL AS "EmpName", OVPM."CardName", VPM4."Descrip", 
CASE WHEN OVPM."DocCurr" = 'INR' THEN VPM4."SumApplied" ELSE VPM4."AppliedFC" END AS "SumApplied",
 vpm1."CheckNum", (SELECT "BankName" FROM ODSC WHERE vpm1."BankCode" = ODSC."BankCode") AS "BankName", 
 vpm1."DueDate" AS "ChqDate", vpm1."CheckAct", vpm1."CheckSum" AS "CheckAmt", 
 OACT."FormatCode" AS "ActCode", OCRN."CurrCode", OCRN."F100Name" AS "HUNDRETH NAME", 
 OCRN."CurrName" AS "CURRENCY NAME", OVPM."Comments", 
 (CASE WHEN OVPM."DocCurr" = 'INR' THEN OVPM."BcgSum" ELSE OVPM."BcgSumFC" END) AS "Bank Charges" 
 
 FROM OVPM 
 LEFT OUTER JOIN (SELECT "DocNum", "CheckNum", "CheckAct", "DueDate", "CheckSum", "BankCode" 
 FROM VPM1 WHERE "LineID" = 0) AS vpm1 ON OVPM."DocEntry" = vpm1."DocNum" 
 
 LEFT OUTER JOIN VPM4 ON OVPM."DocEntry" = VPM4."DocNum" 
 LEFT OUTER JOIN OACT ON VPM4."AcctCode" = OACT."AcctCode" 
 LEFT OUTER JOIN NNM1 ON OVPM."Series" = NNM1."Series" 
 LEFT OUTER JOIN OACT ACT2 ON OVPM."TrsfrAcct" = ACT2."AcctCode" 
 LEFT OUTER JOIN OACT ACT3 ON OVPM."CashAcct" = ACT3."AcctCode" 
 LEFT OUTER JOIN OCRN ON OVPM."DocCurr" = OCRN."CurrCode";