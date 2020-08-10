
/****************Created by: SHITAL*****************/
/***********LAST UPDATED:03-12-2017 15:40PM  BY:SHITAL*************/

/******************** AAKASH GST_DEBIT_NOTE **********************/
IF EXISTS (SELECT NAME FROM SYSOBJECTS WHERE NAME='GST_DEBIT_NOTE')
DROP VIEW GST_DEBIT_NOTE
GO

CREATE VIEW GST_DEBIT_NOTE
AS

SELECT RPC."DocEntry" AS "Docentry", RPC."DocNum" AS "Docnum", 
RPC."DocCur", RPC."DocDate" AS "Docdate", 
RPC."NumAtCard" AS "RefNo", NM1."SeriesName" AS "Docseries", 
(CASE WHEN nm1."BeginStr" IS NULL THEN IFNULL(NM1."BeginStr", n'') 
ELSE IFNULL(NM1."BeginStr", n'') END || RTRIM(LTRIM(CAST(RPC."DocNum" AS char(20)))) 
|| (CASE WHEN nm1."EndStr" IS NULL THEN IFNULL(NM1."EndStr", n'') 
ELSE (IFNULL(NM1."EndStr", n'')) END)) AS "Invoice No", 
RPC."NumAtCard" AS "OrdNo", RPC."U_BPRefDt" AS "OrdDate", 
RPC."PayToCode" AS "BuyerName", RPC."Address" AS "BuyerAdd", 
RPC."ShipToCode" AS "DeilName", RPC."Address2" AS "DelAdd", 
LCT."Block", LCT."Street", WHS."StreetNo", LCT."Building", LCT."City", LCT."Location", 
OCR."Name" AS "Country", OCS."Name" AS "State", LCT."ZipCode", LCT."GSTRegnNo" AS "LocationGSTNO", 
GTY."GSTType" AS "LocationGSTType", 
(CASE WHEN RPC."ExcRefDate" IS NULL THEN cast(RPC."DocTime" as varchar) ELSE RPC."ExcRefDate" END) AS "Supply Time", 
CST."Name" AS "Supply place", cst."GSTCode", CASE WHEN SLP."SlpName" = '-No Sales Employee-' THEN '' ELSE
 SLP."SlpName" END AS "SalesPrsn", SLP."Mobil" AS "salesmob", SLP."Email" AS "SalesEmail",
  CPR."Name" AS "SalesName", CPR."Cellolar" AS "Smob", CPR."E_MailL" AS "Smail", 
  (SELECT "Name" FROM ocst WHERE "Code" = RC12."StateS" AND "Country" = RC12."CountryS") AS "Delplaceofsupply",
   CPR."E_MailL" AS "CnctPrsnEmail", 
   (SELECT crd1."GSTRegnNo" FROM crd1 INNER JOIN ocrd ON ocrd."CardCode" = crd1."CardCode"
    WHERE ocrd."CardCode" = RPC."CardCode" AND crd1."AdresType" = 'S' AND RPC."ShipToCode" = crd1."Address") AS "ShipToGSTCode", 
    GTY1."GSTType" AS "ShipToGSTType", 
    (SELECT "GSTCode" FROM OCST WHERE "Code" = RC12."StateS" AND "Country" = RC12."CountryS") AS "ShipToStateCode", 
    (SELECT "Name" FROM ocst WHERE "Code" = RC12."StateB" AND "Country" = RC12."CountryB") AS "BillToState", 
    (SELECT "GSTCode" FROM OCST WHERE "Code" = RC12."StateB" AND "Country" = RC12."CountryB") AS "BillToStateCode", 
    (SELECT GTY1."GSTType" FROM CRD1 CD1 LEFT OUTER JOIN OGTY GTY1 ON CD1."GSTType" = GTY1."AbsEntry" 
    WHERE CD1."CardCode" = RPC."CardCode" AND cd1."Address" = RPC."PayToCode" AND CD1."AdresType" = 'B') AS "BillToGSTType", 
    (SELECT DISTINCT crd1."GSTRegnNo" FROM crd1 INNER JOIN ocrd ON ocrd."CardCode" = crd1."CardCode" 
    WHERE ocrd."CardCode" = RPC."CardCode" AND crd1."AdresType" = 'B' AND RPC."PayToCode" = crd1."Address") AS "BillToGSTCode", 
    (SELECT DISTINCT "TaxId0" FROM CRD7 WHERE RPC."CardCode" = "CardCode" AND RPC."ShipToCode" = crd7."Address" 
    AND "AddrType" = 's') AS "shipPANNo", (SELECT DISTINCT CD7."TaxId0" FROM CRD7 cd7 WHERE RPC."CardCode" = CD7."CardCode"
     AND RPC."ShipToCode" = cd7."Address" AND CD7."AddrType" = 's') AS "bILLPANNo", CPR."Name" AS "ContactPerson", 
     CPR."Cellolar" AS "ContactMob", CPR."E_MailL" AS "ContactMail", cpr."Title", RN1."LineNum", RN1."ItemCode",
      RN1."Dscription", 
      (CASE WHEN ITM."ItemClass" = 1 THEN (SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = 
      (CASE WHEN RN1."HsnEntry" IS NULL THEN ITM."SACEntry" ELSE rn1."HsnEntry" END)) WHEN ITM."ItemClass" = 2 THEN 
      (SELECT "ChapterID" FROM ochp WHERE "AbsEntry" = 
      (CASE WHEN RN1."HsnEntry" IS NULL THEN ITM."ChapterID" ELSE rn1."HsnEntry" END)) ELSE '' END) AS "HSN Code", 
      (SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = RN1."SacEntry") AS "Service_SAC_Code", RN1."Quantity", 
      RN1."unitMsr", RN1."PriceBefDi", RN1."DiscPrcnt", (RN1."Quantity" * RN1."PriceBefDi") AS "TotalAmt", 
      ((RN1."PriceBefDi" - RN1."Price") * RN1."Quantity") AS "ItmDiscAmt", CASE WHEN ocrn."CurrCode" = 'INR'
       THEN (RN1."LineTotal" * (RPC."DiscPrcnt" / 100)) ELSE (RN1."TotalFrgn" * (RPC."DiscPrcnt" / 100)) END AS "DocDiscAmt", 
       CASE WHEN RPC."DiscPrcnt" = 0 THEN ((RN1."PriceBefDi" - RN1."Price") * RN1."Quantity") 
       ELSE ((CASE WHEN OCRN."CurrCode" = 'INR' THEN RN1."LineTotal" ELSE RN1."TotalFrgn" END)
        * (RPC."DiscPrcnt" / 100)) END AS "DiscAmt", RN1."Price", 
        CASE WHEN ocrn."CurrCode" = 'INR' THEN RN1."LineTotal" ELSE RN1."TotalFrgn" END AS "LineTotal", 
        CASE WHEN OCRN."CurrCode" = 'INR' THEN (CASE WHEN RPC."DiscPrcnt" = 0 
        THEN RN1."LineTotal" ELSE (RN1."LineTotal" - (RN1."LineTotal" * RPC."DiscPrcnt" / 100)) END) 
        ELSE (CASE WHEN RPC."DiscPrcnt" = 0 THEN RN1."TotalFrgn" ELSE (RN1."TotalFrgn" - (RN1."TotalFrgn" * RPC."DiscPrcnt" / 100)) END) END AS "Total", 
        CASE WHEN RN1."AssblValue" = 0 THEN (CASE WHEN RPC."DiscPrcnt" = 0 THEN 
        (CASE WHEN ocrn."CurrCode" = 'INR' THEN RN1."LineTotal" ELSE RN1."TotalFrgn" END) 
        ELSE ((CASE WHEN ocrn."CurrCode" = 'INR' THEN RN1."LineTotal" ELSE RN1."TotalFrgn" END)
- ((CASE WHEN ocrn."CurrCode" = 'INR' THEN RN1."LineTotal" ELSE RN1."TotalFrgn" END)
 * RPC."DiscPrcnt" / 100)) END) ELSE (RN1."AssblValue" * RN1."Quantity") END AS "TotalAsseble", 
 CGST."TaxRate" AS "CGSTRate", 
 CASE WHEN OCRN."CurrCode" = 'INR' THEN CGST."TaxSum" ELSE CGST."TaxSumFrgn" END AS "CGST", 
 SGST."TaxRate" AS "SGSTRate", 
 CASE WHEN OCRN."CurrCode" = 'INR' THEN SGST."TaxSum" ELSE SGST."TaxSumFrgn" END AS "SGST", 
 IGST."TaxRate" AS "IGSTRate", 
 CASE WHEN OCRN."CurrCode" = 'INR' THEN IGST."TaxSum" ELSE IGST."TaxSumFrgn" END AS "IGST", 
 RPC."DocTotal", 
 CASE WHEN OCRN."CurrCode" = 'INR' THEN RPC."RoundDif" ELSE RPC."RoundDifFC" END AS "RoundDif", 
 OCRN."CurrName" AS "Currencyname", OCRN."F100Name" AS "Hundredthname", 
 OCT."PymntGroup" AS "Payment Terms", RPC."Comments" AS "Remark", RPC."Header" AS "Opening Remark", 
 RPC."Footer" AS "Closing Remark", T5."SeriesName" || '/' || CAST(inv."DocNum" AS char(20)) AS "Invoice No1", 
   inv."DocDate" AS "invDocdate" 
 
 FROM ORPC RPC 
 INNER JOIN RPC1 RN1 ON RN1."DocEntry" = RPC."DocEntry" 
 LEFT OUTER JOIN NNM1 NM1 ON RPC."Series" = NM1."Series" 
 LEFT OUTER JOIN OSLP SLP ON RPC."SlpCode" = SLP."SlpCode" 
 LEFT OUTER JOIN pch1 I1 ON I1."DocEntry" = RN1."BaseEntry" AND RN1."BaseLine" = I1."LineNum" 
 LEFT OUTER JOIN opch inv ON inv."DocEntry" = I1."DocEntry" 
 LEFT OUTER JOIN NNM1 T5 ON inv."Series" = T5."Series" 
 LEFT OUTER JOIN OWHS WHS ON RN1."WhsCode" = WHS."WhsCode" 
 LEFT OUTER JOIN OLCT LCT ON RN1."LocCode" = LCT."Code" 
 LEFT OUTER JOIN OCRY OCR ON LCT."Country" = OCR."Code" 
 LEFT OUTER JOIN OCST OCS ON LCT."State" = OCS."Code" AND LCT."Country" = OCS."Country" 
 LEFT OUTER JOIN OGTY GTY ON LCT."GSTType" = GTY."AbsEntry" 
 LEFT OUTER JOIN OCST CST ON LCT."State" = CST."Code" AND LCT."Country" = CST."Country" 
 LEFT OUTER JOIN OCRN ON RPC."DocCur" = OCRN."CurrCode" 
 LEFT OUTER JOIN OCTG OCT ON RPC."GroupNum" = OCT."GroupNum" 
 LEFT OUTER JOIN CRD1 CD1 ON CD1."CardCode" = RPC."CardCode" AND CD1."AdresType" = 'S' AND RPC."ShipToCode" = CD1."Address" 
 LEFT OUTER JOIN RPC12 RC12 ON RC12."DocEntry" = RPC."DocEntry" 
 LEFT OUTER JOIN OCST CST1 ON CST1."Code" = RC12."StateS" AND CST1."Country" = RC12."CountryS" 
 LEFT OUTER JOIN OGTY GTY1 ON CD1."GSTType" = GTY1."AbsEntry" 
 LEFT OUTER JOIN OCPR CPR ON RPC."CardCode" = CPR."CardCode" AND RPC."CntctCode" = CPR."CntctCode" 
 LEFT OUTER JOIN OITM ITM ON ITM."ItemCode" = RN1."ItemCode"
 LEFT OUTER JOIN RPC4 CGST ON RN1."DocEntry" = CGST."DocEntry" AND RN1."LineNum" = CGST."LineNum" AND CGST."staType" IN (-100) AND CGST."RelateType" = 1 
 LEFT OUTER JOIN RPC4 SGST ON RN1."DocEntry" = SGST."DocEntry" AND RN1."LineNum" = SGST."LineNum" AND SGST."staType" IN (-110) AND SGST."RelateType" = 1 
 LEFT OUTER JOIN RPC4 IGST ON RN1."DocEntry" = IGST."DocEntry" AND RN1."LineNum" = IGST."LineNum" AND IGST."staType" IN (-120) AND IGST."RelateType" = 1;


