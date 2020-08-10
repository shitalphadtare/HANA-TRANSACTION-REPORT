
/****************Created by: SHITAL*****************/
/***********LAST UPDATED:09-07-18 15:40PM  BY:SHITAL*************/

/******************** WIILOW credit NOTE **********************/
IF EXISTS (SELECT NAME FROM SYSOBJECTS WHERE NAME='GST_CREDIT_NOTE')
DROP VIEW GST_CREDIT_NOTE
GO

CREATE VIEW GST_CREDIT_NOTE
AS
SELECT RIN."DocEntry" AS "Docentry",
 RIN."DocNum" AS "Docnum",
RIN."DocCur", 
RIN."DocDate" AS "Docdate", RIN."NumAtCard" AS "RefNo",
NM1."SeriesName" AS "Docseries",
(CASE WHEN nm1."BeginStr" IS NULL THEN IFNULL(NM1."BeginStr", N'') ELSE IFNULL(NM1."BeginStr", N'') END || RTRIM(LTRIM(CAST(RIN."DocNum" AS char(20)))) || (CASE WHEN nm1."EndStr" IS NULL THEN IFNULL(NM1."EndStr", N'') ELSE (IFNULL(NM1."EndStr", N'')) END)) AS "Invoice No", 
NM11."SeriesName" AS "ordseries", RIN."NumAtCard" AS "OrdNo", RIN."U_BPRefDt" AS "OrdDate", T4."SeriesName" || '/' || CAST(DLN."DocNum" AS varchar) AS "Challan No", DLN."DocDate" AS "Challan Date", RIN."PayToCode" AS "BuyerName",
 RIN."Address" AS "BuyerAdd", RIN."ShipToCode" AS "DeilName", RIN."Address2" AS "DelAdd", 
 LCT."Block", LCT."Street", WHS."StreetNo", LCT."Building", LCT."City", LCT."Location", 
 OCR."Name" AS "Country", OCS."Name" AS "STATE", LCT."ZipCode", LCT."GSTRegnNo" AS "LocationGSTNO", GTY."GSTType" AS "LocationGSTType", 
(CASE WHEN RIN."ExcRefDate" IS NULL THEN cast(RIN."DocTime" as varchar) ELSE RIN."ExcRefDate" END) AS "Supply Time",
CST."Name" AS "Supply place", cst."GSTCode",
CASE WHEN SLP."SlpName" = '-No Sales Employee-' THEN '' ELSE SLP."SlpName" END AS "SalesPrsn",
SLP."Mobil" AS "salesmob", SLP."Email" AS "SalesEmail", CPR."Name" AS "Salesname", CPR."Cellolar" AS "Smob", 
CPR."E_MailL" AS "Smail", 
       (SELECT "Name" FROM ocst WHERE "Code" = RN12."StateS" AND "Country" = RN12."CountryS") AS "Delplaceofsupply",
        CPR."E_MailL" AS "CnctPrsnEmail", 
        (SELECT crd1."GSTRegnNo" FROM crd1 INNER JOIN ocrd 
        		ON ocrd."CardCode" = crd1."CardCode" 
        		WHERE ocrd."CardCode" = RIN."CardCode" AND crd1."AdresType" = 'S' 
        		AND RIN."ShipToCode" = crd1."Address") AS "ShipToGSTCode", GTY1."GSTType" AS "ShipToGSTType", 
(SELECT "GSTCode" FROM OCST WHERE "Code" = RN12."StateS" AND "Country" = RN12."CountryS") AS "ShipToStateCode",
 (SELECT "Name" FROM ocst WHERE "Code" = RN12."StateB" AND "Country" = RN12."CountryB") AS "BillToState", 
 (SELECT "GSTCode" FROM OCST WHERE "Code" = RN12."StateB" AND "Country" = RN12."CountryB") AS "BillToStateCode", 
 (SELECT GTY1."GSTType" FROM CRD1 CD1 
 LEFT OUTER JOIN OGTY GTY1 ON CD1."GSTType" = GTY1."AbsEntry" 
 WHERE CD1."CardCode" = RIN."CardCode" AND cd1."Address" = RIN."PayToCode" 
 AND CD1."AdresType" = 'B') AS "BillToGSTType",
  (SELECT DISTINCT crd1."GSTRegnNo" FROM crd1
  INNER JOIN ocrd ON ocrd."CardCode" = crd1."CardCode" 
  WHERE ocrd."CardCode" = RIN."CardCode" AND crd1."AdresType" = 'B' AND 
  RIN."PayToCode" = crd1."Address") AS "BillToGSTCode", 
  (SELECT DISTINCT "TaxId0" FROM CRD7 WHERE RIN."CardCode" = "CardCode" 
  AND RIN."ShipToCode" = crd7."Address" AND "AddrType" = 's') AS "shipPANNo", 
  (SELECT DISTINCT CD7."TaxId0" FROM CRD7 cd7 
  WHERE RIN."CardCode" = CD7."CardCode" AND RIN."ShipToCode" = cd7."Address" 
  AND CD7."AddrType" = 's') AS "bILLPANNo", 
  CPR."Name" AS "ContactPerson", CPR."Cellolar" AS "ContactMob",
   CPR."E_MailL" AS "ContactMail", cpr."Title", 
   RN1."LineNum", RN1."ItemCode", RN1."Dscription", 
   (CASE WHEN ITM."ItemClass" = 1 THEN (SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = 
    	(CASE WHEN RN1."HsnEntry" IS NULL THEN ITM."SACEntry" ELSE rn1."HsnEntry" END)) 
    	WHEN ITM."ItemClass" = 2 THEN 
    	(SELECT "ChapterID" FROM ochp WHERE "AbsEntry" = 
    	(CASE WHEN RN1."HsnEntry" IS NULL THEN ITM."ChapterID" ELSE rn1."HsnEntry" END)) ELSE '' END) AS "HSN Code", 
    	(SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = RN1."SacEntry") AS "Service_SAC_Code", 
    	RN1."Quantity", RN1."unitMsr", RN1."PriceBefDi", RN1."DiscPrcnt", 
    	(RN1."Quantity" * RN1."PriceBefDi") AS "TotalAmt", 
    	((RN1."PriceBefDi" - RN1."Price") * RN1."Quantity") AS "ItmDiscAmt", 
    	CASE WHEN ocrn."CurrCode" = 'INR' THEN (RN1."LineTotal" * (RIN."DiscPrcnt" / 100)) 
    	ELSE (RN1."TotalFrgn" * (RIN."DiscPrcnt" / 100)) END AS "DocDiscAmt", 
    	CASE WHEN RIN."DiscPrcnt" = 0 THEN ((RN1."PriceBefDi" - RN1."Price") * RN1."Quantity")
    	 ELSE ((CASE WHEN OCRN."CurrCode" = 'INR' THEN RN1."LineTotal" ELSE RN1."TotalFrgn" END) * (RIN."DiscPrcnt" / 100)) END AS "DiscAmt", 
    	 RN1."Price",
    	  CASE WHEN ocrn."CurrCode" = 'INR' THEN RN1."LineTotal" ELSE RN1."TotalFrgn" END AS "LineTotal", 
    	  CASE WHEN OCRN."CurrCode" = 'INR' THEN (CASE WHEN RIN."DiscPrcnt" = 0 THEN RN1."LineTotal" ELSE 
    	  (RN1."LineTotal" - (RN1."LineTotal" * RIN."DiscPrcnt" / 100)) END)
    	   ELSE (CASE WHEN RIN."DiscPrcnt" = 0 THEN RN1."TotalFrgn" 
    	   ELSE (RN1."TotalFrgn" - (RN1."TotalFrgn" * RIN."DiscPrcnt" / 100)) END) END AS "Total", 
    	   CASE WHEN RN1."AssblValue" = 0 THEN (CASE WHEN RIN."DiscPrcnt" = 0 THEN 
    	   (CASE WHEN ocrn."CurrCode" = 'INR' THEN RN1."LineTotal" ELSE RN1."TotalFrgn" END) ELSE 
    	   ((CASE WHEN ocrn."CurrCode" = 'INR' THEN RN1."LineTotal" ELSE RN1."TotalFrgn" END) - 
    	   ((CASE WHEN ocrn."CurrCode" = 'INR' THEN RN1."LineTotal" ELSE RN1."TotalFrgn" END) * RIN."DiscPrcnt" / 100)) END) 
    	   ELSE (RN1."AssblValue" * RN1."Quantity") END AS "TotalAsseble",
    	    CGST."TaxRate" AS "CGSTRate",
    	    CASE WHEN OCRN."CurrCode" = 'INR' THEN CGST."TaxSum" ELSE CGST."TaxSumFrgn" END AS "CGST",
    	     SGST."TaxRate" AS "SGSTRate", 
    	     CASE WHEN OCRN."CurrCode" = 'INR' THEN SGST."TaxSum" ELSE SGST."TaxSumFrgn" END AS "SGST", 
    	     IGST."TaxRate" AS "IGSTRate", 
    	     CASE WHEN OCRN."CurrCode" = 'INR' THEN IGST."TaxSum" ELSE IGST."TaxSumFrgn" END AS "IGST", 
    	     RIN."DocTotal", 
    	     CASE WHEN OCRN."CurrCode" = 'INR' THEN RIN."RoundDif" ELSE RIN."RoundDifFC" END AS "RoundDif", 
    	     OCRN."CurrName" AS "Currencyname", 
    	     OCRN."F100Name" AS "Hundredthname", 
    	     OCT."PymntGroup" AS "Payment Terms", 
    	     RIN."Comments" AS "Remark", 
    	     RIN."Header" AS "Opening Remark", 
    	     RIN."Footer" AS "Closing Remark", 
    	     T5."SeriesName" || '/' || CAST(inv."DocNum" AS char(20)) AS "Invoice No1", 
    	     inv."DocDate" AS "invDocdate" 
    	     
    	     FROM ORIN RIN 
    	     INNER JOIN RIN1 RN1 ON RN1."DocEntry" = RIN."DocEntry" 
    	     INNER JOIN NNM1 NM1 ON RIN."Series" = NM1."Series" 
    	     INNER JOIN OSLP SLP ON RIN."SlpCode" = SLP."SlpCode" 
    	     LEFT OUTER JOIN INV1 I1 ON I1."DocEntry" = RN1."BaseEntry" AND RN1."BaseLine" = I1."LineNum" 
    	     LEFT OUTER JOIN OINV inv ON inv."DocEntry" = I1."DocEntry" 
    	     LEFT OUTER JOIN NNM1 T5 ON inv."Series" = T5."Series" 
    	     LEFT OUTER JOIN OWHS WHS ON RN1."WhsCode" = WHS."WhsCode" 
    	     LEFT OUTER JOIN OLCT LCT ON RN1."LocCode" = LCT."Code" 
    	     LEFT OUTER JOIN OCRY OCR ON LCT."Country" = OCR."Code" 
    	     LEFT OUTER JOIN OCST OCS ON LCT."State" = OCS."Code" AND LCT."Country" = OCS."Country" 
    	     LEFT OUTER JOIN OGTY GTY ON LCT."GSTType" = GTY."AbsEntry" 
    	     LEFT OUTER JOIN OCST CST ON LCT."State" = CST."Code" AND LCT."Country" = CST."Country" 
    	     LEFT OUTER JOIN DLN1 DN1 ON DN1."DocEntry" = I1."BaseEntry" AND I1."BaseLine" = DN1."LineNum" 
    	     LEFT OUTER JOIN ODLN DLN ON DN1."DocEntry" = DLN."DocEntry" 
    	     LEFT OUTER JOIN NNM1 T4 ON T4."Series" = DLN."Series" 
    	     LEFT OUTER JOIN RDR1 RR1 ON DN1."BaseEntry" = RR1."DocEntry" AND DN1."BaseLine" = RR1."LineNum" 
    	     LEFT OUTER JOIN ORDR RDR ON RR1."DocEntry" = RDR."DocEntry" 
    	     LEFT OUTER JOIN OCRN ON RIN."DocCur" = OCRN."CurrCode" 
    	     LEFT OUTER JOIN OCTG OCT ON RIN."GroupNum" = OCT."GroupNum" 
    	     LEFT OUTER JOIN CRD1 CD1 ON CD1."CardCode" = RIN."CardCode" AND CD1."AdresType" = 'S' AND RIN."ShipToCode" = CD1."Address" 
    	     LEFT OUTER JOIN RIN12 RN12 ON RN12."DocEntry" = RIN."DocEntry" 
    	     LEFT OUTER JOIN OCST CST1 ON CST1."Code" = RN12."BpStateCod" AND CST1."Country" = RN12."CountryS" 
    	     LEFT OUTER JOIN OGTY GTY1 ON CD1."GSTType" = GTY1."AbsEntry" 
    	     LEFT OUTER JOIN OCPR CPR ON RIN."CardCode" = CPR."CardCode" AND RIN."CntctCode" = CPR."CntctCode" 
    	     LEFT OUTER JOIN OITM ITM ON ITM."ItemCode" = RN1."ItemCode" 
    	     LEFT OUTER JOIN NNM1 NM11 ON RDR."Series" = NM11."Series" 
    	     LEFT OUTER JOIN RIN4 CGST ON RN1."DocEntry" = CGST."DocEntry" AND RN1."LineNum" = CGST."LineNum" AND CGST."staType" IN (-100) AND CGST."RelateType" = 1 
    	     LEFT OUTER JOIN RIN4 SGST ON RN1."DocEntry" = SGST."DocEntry" AND RN1."LineNum" = SGST."LineNum" AND SGST."staType" IN (-110) AND SGST."RelateType" = 1 
    	     LEFT OUTER JOIN RIN4 IGST ON RN1."DocEntry" = IGST."DocEntry" AND RN1."LineNum" = IGST."LineNum" AND IGST."staType" IN (-120) AND IGST."RelateType" = 1;

  