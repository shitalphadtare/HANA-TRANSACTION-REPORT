
alter view JOURNAL_ENTRY
AS
SELECT T0."AcctCode",
 CASE WHEN T0."Segment_0" <> '' THEN T0."Segment_0" || '-' || T0."Segment_1" ELSE T0."AcctCode" END AS "AcctCode1",
 T0."AcctName",
'INR' AS "Currency",
  T2."RefDate" AS "Date1", 
  (CASE WHEN T2."TransType" = 46 THEN IFNULL(T1."Debit", 0) 
		WHEN T2."TransType" = 24 THEN IFNULL(T1."Debit", 0)
		WHEN T2."TransType" = 13 THEN IFNULL(T1."Debit", 0) 
		WHEN T2."TransType" = 18 THEN IFNULL(T1."Debit", 0)
		WHEN T2."TransType" = 14 THEN IFNULL(T1."Debit", 0) 
		WHEN T2."TransType" = 19 THEN IFNULL(T1."Debit", 0)
		WHEN T2."TransType" = 30 THEN IFNULL(T1."Debit", 0) else '' END) AS "Debit", 
(CASE WHEN T2."TransType" = 46 THEN IFNULL(T1."Credit", 0)
	  WHEN T2."TransType" = 24 THEN IFNULL(T1."Credit", 0) 
	  WHEN T2."TransType" = 13 THEN IFNULL(T1."Credit", 0)
	  WHEN T2."TransType" = 18 THEN IFNULL(T1."Credit", 0)
	  WHEN T2."TransType" = 14 THEN IFNULL(T1."Credit", 0)
	  WHEN T2."TransType" = 19 THEN IFNULL(T1."Credit", 0)
	  WHEN T2."TransType" = 30 THEN IFNULL(T1."Credit", 0) else '' END) AS "Credit",
	  T1."TransId", 
	  T2."TransType", 
(CASE WHEN T2."TransType" = 46 THEN "T5"."SeriesName" || '/' || CAST(T4."DocNum" AS char) 
	  WHEN T2."TransType" = 24 THEN "T7"."SeriesName" || '/' || CAST(T6."DocNum" AS char) 
	  WHEN T2."TransType" = 13 THEN "A2"."SeriesName" || '/' || CAST(A1."DocNum" AS char) 
	  WHEN T2."TransType" = 18 THEN "A4"."SeriesName" || '/' || CAST(A3."DocNum" AS char) 
	  WHEN T2."TransType" = 14 THEN "C2"."SeriesName" || '/' || CAST(C1."DocNum" AS char) 
	  WHEN T2."TransType" = 19 THEN "C4"."SeriesName" || '/' || CAST(C3."DocNum" AS char) 
	  WHEN T2."TransType" = 30 THEN T10."SeriesName" || '/' || CAST(T2."Number" AS char) END) AS "Document No",
(CASE WHEN T2."TransType" = 30 THEN 'Journal Entry' 
	  WHEN T2."TransType" = 140000009 THEN 'Outgoing Ex Invoice' 
	  WHEN T2."TransType" = 24 THEN 'Incoming Payment' 
	  WHEN T2."TransType" = 13 THEN 'A/R Invoice' 
	  WHEN T2."TransType" = 18 THEN 'A/P Invoice' 
	  WHEN T2."TransType" = 14 THEN 'A/R Credit Memo' 
	  WHEN T2."TransType" = 19 THEN 'A/P Credit Memo' 
	  ELSE 'Outgoing Payment' END) AS "Transction Name", 
CASE WHEN t2."TransType" <> 30 THEN 
	(CASE WHEN T3."Segment_0" <> '' THEN T3."Segment_0" 
		  WHEN T3."AcctCode" IS NULL OR T3."AcctCode" = '' AND T3."Segment_0" IS NULL 
		  THEN (CASE WHEN T2."TransType" = 46 THEN T4."CardCode" 
		             WHEN T2."TransType" = 24 THEN T6."CardCode" 
					 WHEN T2."TransType" = 13 THEN A1."CardCode" 
					 WHEN T2."TransType" = 18 THEN A3."CardCode"  
					 WHEN T2."TransType" = 14 THEN C1."CardCode" 
					 WHEN T2."TransType" = 19 THEN C3."CardCode"  END) 
					 ELSE T3."AcctCode" || '' END) ELSE T2."Memo" END AS "BP/GL Code", 
(CASE WHEN T2."TransType" = 46 THEN T4."Comments" 
	  WHEN T2."TransType" = 24 THEN T6."Comments" 
	  WHEN T2."TransType" = 13 THEN A1."Comments" 
	  WHEN T2."TransType" = 18 THEN A3."Comments" 
	  WHEN T2."TransType" = 14 THEN C1."Comments" 
	  WHEN T2."TransType" = 19 THEN C3."Comments" END) AS "Remarks", 
CASE WHEN T2."TransType" IN (46,24) THEN ('Ch No.' || 
		(CASE WHEN T2."TransType" = 46 THEN CAST("T8"."CheckNum" AS char) 
				   WHEN T2."TransType" = 24 THEN CAST(T9."CheckNum" AS char)  END) ) 
				   WHEN T2."TransType" = 13 THEN A1."NumAtCard" 
				   WHEN T2."TransType" = 18 THEN A3."NumAtCard" 
				   WHEN T2."TransType" = 14 THEN C1."NumAtCard" 
				   WHEN T2."TransType" = 19 THEN C3."NumAtCard" END AS "Cheque No/BP Ref", 
T2."RefDate" AS "Date2", 
 OA."Name" AS "Segment", 
 t1."ProfitCode", 
 t1."Project", 
 CASE WHEN t2."TransType" <> 30 THEN (
 CASE WHEN T3."Segment_0" <> '' THEN T3."AcctName" 
	  WHEN T3."AcctCode" IS NULL OR T3."AcctCode" = '' AND T3."Segment_0" IS NULL THEN 
	  (CASE WHEN T2."TransType" = 46 THEN T4."CardName" 
	        WHEN T2."TransType" = 24 THEN T6."CardName" 
			WHEN T2."TransType" = 13 THEN A1."CardName" 
			WHEN T2."TransType" = 18 THEN A3."CardName" 
			WHEN T2."TransType" = 14 THEN C1."CardName" 
			WHEN T2."TransType" = 19 THEN C3."CardName" END) ELSE T3."AcctCode" || '' END) ELSE T2."Memo" END AS "Acctname1",
			t2."Number",
			t2."Ref1" ,
			t2."Memo",
			t10."SeriesName",
			T1."ShortName",
			T0."Segment_0",
			T0."Segment_1",
			T0."Segment_2",
			T0."Segment_3"
FROM OACT T0 
INNER JOIN JDT1 T1 ON T1."Account" = T0."AcctCode" 
			LEFT OUTER JOIN OACT T3 ON T1."ShortName" = T3."AcctCode" 
			LEFT OUTER JOIN OASC OA ON T0."Segment_1" = OA."Code" 
			INNER JOIN OJDT T2 ON T1."TransId" = T2."TransId" AND T2."TransType" IN (30,140000009,24,46,13,18,14,19) 
			LEFT OUTER JOIN (SELECT W1."Series", W1."SeriesName", W2."TransId" 
			                 FROM NNM1 W1 
							 INNER JOIN OJDT W2 ON W1."Series" = W2."Series") AS "T10" ON "T10"."Series" = T2."Series" AND T2."TransId" = "T10"."TransId" 
		    LEFT OUTER JOIN OVPM T4 ON T4."DocNum" = (CASE WHEN T1."TransType" = 46 THEN T1."BaseRef" ELSE NULL END) AND T1."RefDate" = T4."DocDate" 
			LEFT OUTER JOIN (SELECT W1."Series", "SeriesName", W2."DocNum" FROM NNM1 W1 INNER JOIN OVPM W2 ON W1."Series" = W2."Series") AS "T5" ON T4."Series" = "T5"."Series" AND T4."DocNum" = "T5"."DocNum" 
			LEFT OUTER JOIN (SELECT "CheckNum", "DocNum" FROM VPM1) AS "T8" ON "T8"."DocNum" = T4."DocEntry" 
			LEFT OUTER JOIN (SELECT "Descrip", "DocNum", "LineId" FROM VPM4) AS "T11" ON "T11"."DocNum" = T4."DocEntry" AND "T11"."LineId" = 0 
			LEFT OUTER JOIN ORCT T6 ON T6."DocNum" = (CASE WHEN T1."TransType" = 24 THEN T1."BaseRef" ELSE NULL END) AND T1."RefDate" = T6."DocDate" 
			LEFT OUTER JOIN (SELECT W1."Series", "SeriesName", W2."DocNum" FROM NNM1 W1 
							INNER JOIN ORCT W2 ON W1."Series" = W2."Series") AS "T7" ON T6."Series" = "T7"."Series" AND T6."DocNum" = "T7"."DocNum" 
			LEFT OUTER JOIN (SELECT "CheckNum", "DocNum" FROM RCT1) AS T9 ON T9."DocNum" = T6."DocEntry" 
			LEFT OUTER JOIN (SELECT "Descrip", "DocNum", "LineId" FROM RCT4) AS "T12" ON "T12"."DocNum" = T6."DocEntry" AND "T12"."LineId" = 0 
			LEFT OUTER JOIN OINV A1 ON A1."DocNum" = (CASE WHEN T1."TransType" = 13 THEN T1."BaseRef" ELSE NULL END) AND T1."RefDate" = A1."DocDate" 
			LEFT OUTER JOIN (SELECT W1."Series", "SeriesName", W2."DocNum" FROM NNM1 W1 
								INNER JOIN OINV W2 ON W1."Series" = W2."Series") AS "A2" ON A1."Series" = "A2"."Series" AND A1."DocNum" = "A2"."DocNum" 
			LEFT OUTER JOIN OPCH A3 ON A3."DocNum" = (CASE WHEN T1."TransType" = 18 THEN T1."BaseRef" ELSE NULL END) AND T1."RefDate" = A3."DocDate" 
			LEFT OUTER JOIN (SELECT W1."Series", "SeriesName", W2."DocNum" FROM NNM1 W1 INNER JOIN OPCH W2 ON W1."Series" = W2."Series")
							AS "A4" ON A3."Series" = "A4"."Series" AND A3."DocNum" = "A4"."DocNum" 
			LEFT OUTER JOIN ORIN C1 ON C1."DocNum" = (CASE WHEN T1."TransType" = 14 THEN T1."BaseRef" ELSE NULL END) AND T1."RefDate" = C1."DocDate" 
			LEFT OUTER JOIN (SELECT W1."Series", "SeriesName", W2."DocNum" FROM NNM1 W1 INNER JOIN ORIN W2 ON W1."Series" = W2."Series") AS "C2" ON C1."Series" = "C2"."Series" AND C1."DocNum" = "C2"."DocNum" 
			LEFT OUTER JOIN ORPC C3 ON C3."DocNum" = (CASE WHEN T1."TransType" = 19 THEN T1."BaseRef" ELSE NULL END) AND T1."RefDate" = C3."DocDate" 
			LEFT OUTER JOIN (SELECT W1."Series", "SeriesName", W2."DocNum" FROM NNM1 W1 INNER JOIN ORPC W2 ON W1."Series" = W2."Series") AS "C4" ON C3."Series" = "C4"."Series" AND C3."DocNum" = "C4"."DocNum";
go