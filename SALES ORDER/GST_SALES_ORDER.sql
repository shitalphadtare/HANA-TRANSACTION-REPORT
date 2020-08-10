
/****************Created by: SHITAL*****************/
/***********LAST UPDATED:22-12-2017 12:36PM  BY:SHITAL*************/

/********************SHREE SALES ORDER***********************/
IF EXISTS (SELECT NAME FROM SYSOBJECTS WHERE NAME='GST_SALES_ORDER')
DROP VIEW GST_SALES_ORDER
GO

CREATE VIEW GST_SALES_ORDER
AS

SELECT RDR."DocEntry" AS "Docentry", RDR."DocNum" AS "Docnum", RDR."DocCur", RDR."DocDate" AS "Docdate",
 NM1."SeriesName" AS "Docseries", (CASE WHEN nm1."BeginStr" IS NULL THEN IFNULL(NM1."BeginStr", n'') 
 ELSE IFNULL(NM1."BeginStr", n'') END || RTRIM(LTRIM(CAST(RDR."DocNum" AS char(20)))) || 
 (CASE WHEN nm1."EndStr" IS NULL THEN IFNULL(NM1."EndStr", n'') ELSE (IFNULL(NM1."EndStr", n'')) END)) AS "Invoice No",
  RDR."NumAtCard" AS "RefNo", NM11."SeriesName" AS "ordseries", RDR."NumAtCard" AS "OrdNo", RDR."U_BPRefDt" AS "OrdDate", 
  DLN."DocNum" AS "Challan No", DLN."DocDate" AS "Challan Date", RDR."PayToCode" AS "BuyerName", RDR."Address" AS "BuyerAdd", 
  RDR."ShipToCode" AS "DeilName", RDR."Address2" AS "DelAdd", LCT."Block", LCT."Street", WHS."StreetNo", LCT."Building",
   LCT."City", LCT."Location", LCT."Country", LCT."ZipCode", LCT."GSTRegnNo" AS "LocationGSTNO", GTY."GSTType" AS "LocationGSTType"
   , (CASE WHEN RDR."ExcRefDate" IS NULL THEN cast(RDR."DocTime" as varchar) ELSE RDR."ExcRefDate" END) AS "Supply Time", 
   CST."Name" AS "Supply place", CASE WHEN SLP."SlpName" = '-No Sales Employee-' THEN '' ELSE SLP."SlpName" END AS "SalesPrsn", 
   SLP."Mobil" AS "salesmob", SLP."Email" AS "SalesEmail", CPR."Name" AS "ContactPerson", CPR."Cellolar" AS "ContactMob", 
   CPR."E_MailL" AS "ContactMail", (SELECT "Name" FROM OCST WHERE "Code" = RR12."StateS" AND "Country" = RR12."CountryS") 
   AS "Delplaceofsupply", CPR."E_MailL" AS "CnctPrsnEmail", 
   (SELECT CRD1."GSTRegnNo" FROM CRD1 INNER JOIN OCRD ON OCRD."CardCode" = CRD1."CardCode"
    WHERE OCRD."CardCode" = RDR."CardCode" AND CRD1."AdresType" = 'S' AND RDR."ShipToCode" = CRD1."Address") AS "ShipToGSTCode",
     GTY1."GSTType" AS "ShipToGSTType", (SELECT "GSTCode" FROM OCST WHERE "Code" = RR12."StateS" AND "Country" = RR12."CountryS") 
     AS "ShipToStateCode", (SELECT "Name" FROM OCST WHERE "Code" = RR12."StateB" AND "Country" = RR12."CountryB") AS "BillToState",
      (SELECT "GSTCode" FROM OCST WHERE "Code" = RR12."StateB" AND "Country" = RR12."CountryB") AS "BillToStateCode", 
      (SELECT GTY1."GSTType" FROM CRD1 CD1 LEFT OUTER JOIN OGTY GTY1 ON CD1."GSTType" = GTY1."AbsEntry"
       WHERE CD1."CardCode" = RDR."CardCode" AND cd1."Address" = RDR."PayToCode" AND CD1."AdresType" = 'B') AS "BillToGSTType", 
       (SELECT DISTINCT CRD1."GSTRegnNo" FROM CRD1 INNER JOIN OCRD ON OCRD."CardCode" = CRD1."CardCode" WHERE OCRD."CardCode" = 
       RDR."CardCode" AND CRD1."AdresType" = 'B' AND RDR."PayToCode" = CRD1."Address") AS "BillToGSTCode", 
       (SELECT DISTINCT "TaxId0" FROM CRD7 WHERE RDR."CardCode" = "CardCode" AND RDR."ShipToCode" = CRD7."Address" AND "AddrType" = 's') AS "shipPANNo", 
       (SELECT DISTINCT CD7."TaxId0" FROM CRD7 cd7 WHERE RDR."CardCode" = CD7."CardCode" AND RDR."ShipToCode" = cd7."Address" 
       AND CD7."AddrType" = 's') AS "bILLPANNo", RR1."LineNum", RR1."ItemCode", RR1."Dscription", 
       (CASE WHEN ITM."ItemClass" = 1 THEN (SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = (CASE WHEN RR1."HsnEntry" IS NULL 
       THEN ITM."SACEntry" ELSE RR1."HsnEntry" END)) WHEN ITM."ItemClass" = 2 THEN 
       (SELECT "ChapterID" FROM OCHP WHERE "AbsEntry" = (CASE WHEN RR1."HsnEntry" IS NULL THEN ITM."ChapterID" ELSE 
       RR1."HsnEntry" END)) ELSE '' END) AS "HSN Code", (SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = RR1."SacEntry") 
       AS "Service_SAC_Code", RR1."Quantity", RR1."unitMsr", RR1."PriceBefDi", RR1."DiscPrcnt", (RR1."Quantity" * RR1."PriceBefDi")
        AS "TotalAmt", ((RR1."PriceBefDi" - RR1."Price") * RR1."Quantity") AS "ItmDiscAmt", ((CASE WHEN OCRN."CurrCode" = 'INR' 
        THEN RR1."LineTotal" ELSE RR1."TotalFrgn" END) * (RDR."DiscPrcnt" / 100)) AS "DocDiscAmt", CASE WHEN RDR."DiscPrcnt" = 0 
         THEN ((RR1."PriceBefDi" - RR1."Price") * RR1."Quantity") ELSE ((CASE WHEN OCRN."CurrCode" = 'INR' THEN RR1."LineTotal"
ELSE RR1."TotalFrgn" END) * (RDR."DiscPrcnt" / 100)) END AS "DiscAmt", RR1."Price", CASE WHEN OCRN."CurrCode" = 'INR' 
THEN RR1."LineTotal" ELSE RR1."TotalFrgn" END AS "LineTotal", CASE WHEN OCRN."CurrCode" = 'INR' THEN 
(CASE WHEN RDR."DiscPrcnt" = 0 THEN RR1."LineTotal" ELSE (RR1."LineTotal" - (RR1."LineTotal" * RDR."DiscPrcnt" / 100)) 
END) ELSE (CASE WHEN RDR."DiscPrcnt" = 0 THEN RR1."TotalFrgn" ELSE (RR1."TotalFrgn" - (RR1."TotalFrgn" * RDR."DiscPrcnt" 
/ 100)) END) END AS "Total", CASE WHEN RR1."AssblValue" = 0 THEN (CASE WHEN RDR."DiscPrcnt" = 0 THEN 
(CASE WHEN OCRN."CurrCode" = 'INR' THEN RR1."LineTotal" ELSE RR1."TotalFrgn" END) ELSE ((CASE WHEN OCRN."CurrCode" = 'INR'
 THEN RR1."LineTotal" ELSE RR1."TotalFrgn" END) - ((CASE WHEN OCRN."CurrCode" = 'INR' THEN RR1."LineTotal" ELSE 
 RR1."TotalFrgn" END) * RDR."DiscPrcnt" / 100)) END) ELSE (RR1."AssblValue" * RR1."Quantity") END AS "TotalAsseble", 
 CGST."TaxRate" AS "CGSTRate", CASE WHEN OCRN."CurrCode" = 'INR' THEN CGST."TaxSum" ELSE CGST."TaxSumFrgn" END AS "CGST",
  SGST."TaxRate" AS "SGSTRate", CASE WHEN OCRN."CurrCode" = 'INR' THEN SGST."TaxSum" ELSE SGST."TaxSumFrgn" END AS "SGST",
   IGST."TaxRate" AS "IGSTRate", CASE WHEN OCRN."CurrCode" = 'INR' THEN IGST."TaxSum" ELSE IGST."TaxSumFrgn" END AS "IGST", RDR."DocTotal", 
   CASE WHEN OCRN."CurrCode" = 'INR' THEN RDR."RoundDif" ELSE RDR."RoundDifFC" END AS "RoundDif",
    OCRN."CurrName" AS "Currencyname", OCRN."F100Name" AS "Hundredthname", OCT."PymntGroup" AS "Payment Terms", 
    RDR."Comments" AS "Remark", RDR."Header" AS "Opening Remark", RDR."Footer" AS "Closing Remark"
    
     FROM ORDR RDR 
     INNER JOIN RDR1 RR1 ON RR1."DocEntry" = RDR."DocEntry" 
     INNER JOIN NNM1 NM1 ON RDR."Series" = NM1."Series" 
     INNER JOIN OSLP SLP ON RDR."SlpCode" = SLP."SlpCode" 
     LEFT OUTER JOIN OWHS WHS ON RR1."WhsCode" = WHS."WhsCode" 
     LEFT OUTER JOIN OLCT LCT ON RR1."LocCode" = LCT."Code" 
     LEFT OUTER JOIN OGTY GTY ON LCT."GSTType" = GTY."AbsEntry" 
     LEFT OUTER JOIN OCST CST ON LCT."State" = CST."Code" AND LCT."Country" = CST."Country" 
     LEFT OUTER JOIN DLN1 DN1 ON RR1."DocEntry" = DN1."BaseEntry" AND RR1."LineNum" = DN1."BaseLine" AND RR1."ObjType" = DN1."BaseType" 
     LEFT OUTER JOIN ODLN DLN ON DLN."DocEntry" = DN1."DocEntry" 
     LEFT OUTER JOIN RDR1 RDR1 ON DN1."BaseEntry" = RDR1."DocEntry" AND DN1."BaseLine" = RDR1."LineNum" 
     LEFT OUTER JOIN ORDR ORDR ON RDR1."DocEntry" = ORDR."DocEntry" 
     LEFT OUTER JOIN OCRN ON RDR."DocCur" = OCRN."CurrCode" 
     LEFT OUTER JOIN OCTG OCT ON RDR."GroupNum" = OCT."GroupNum" 
     LEFT OUTER JOIN CRD1 CD1 ON CD1."CardCode" = RDR."CardCode" AND CD1."AdresType" = 'S' AND RDR."ShipToCode" = CD1."Address" 
     LEFT OUTER JOIN RDR12 RR12 ON RR12."DocEntry" = RDR."DocEntry" 
     LEFT OUTER JOIN OCST CST1 ON CST1."Code" = RR12."BpStateCod" AND CST1."Country" = RR12."CountryS" 
     LEFT OUTER JOIN OGTY GTY1 ON CD1."GSTType" = GTY1."AbsEntry" 
     LEFT OUTER JOIN OCPR CPR ON RDR."CardCode" = CPR."CardCode" AND RDR."CntctCode" = CPR."CntctCode" 
     LEFT OUTER JOIN OITM ITM ON ITM."ItemCode" = RR1."ItemCode" 
     LEFT OUTER JOIN NNM1 NM11 ON ORDR."Series" = NM11."Series" 
     LEFT OUTER JOIN RDR4 CGST ON RR1."DocEntry" = CGST."DocEntry" AND RR1."LineNum" = CGST."LineNum" AND CGST."staType" IN (-100) AND CGST."RelateType" = 1 
     LEFT OUTER JOIN RDR4 SGST ON RR1."DocEntry" = SGST."DocEntry" AND RR1."LineNum" = SGST."LineNum" AND SGST."staType" IN (-110) AND SGST."RelateType" = 1 
     LEFT OUTER JOIN RDR4 IGST ON RR1."DocEntry" = IGST."DocEntry" AND RR1."LineNum" = IGST."LineNum" AND IGST."staType" IN (-120) AND IGST."RelateType" = 1;

