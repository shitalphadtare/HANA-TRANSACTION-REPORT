
/****************Created by: SHITAL*****************/
/***********LAST UPDATED:090718 15:40PM  BY:SHITAL*************/

/********************WILLOW proforma invoice***********************/
IF EXISTS (SELECT NAME FROM SYSOBJECTS WHERE NAME='GST_PROFORMA_INVOICE')
DROP VIEW GST_PROFORMA_INVOICE
GO

CREATE VIEW GST_PROFORMA_INVOICE
AS

SELECT DPI."DocEntry" AS "Docentry", DPI."DocNum" AS "Docnum", DPI."DocCur", DPI."DocDate" AS "Docdate",
 DPI."NumAtCard" AS "RefNo", NM1."SeriesName" AS "Docseries", 
 (CASE WHEN nm1."BeginStr" IS NULL THEN IFNULL(NM1."BeginStr", n'') ELSE IFNULL(NM1."BeginStr", n'') END ||
  RTRIM(LTRIM(CAST(DPI."DocNum" AS char(20)))) || (CASE WHEN nm1."EndStr" IS NULL THEN IFNULL(NM1."EndStr", n'') 
  ELSE (IFNULL(NM1."EndStr", n'')) END)) AS "Invoice No", NM11."SeriesName" AS "ordseries", DPI."NumAtCard" AS "OrdNo", 
  DPI."U_BPRefDt" AS "OrdDate", DLN."DocNum" AS "Challan No", DLN."DocDate" AS "Challan Date", DPI."PayToCode" AS "BuyerName", 
  DPI."Address" AS "BuyerAdd", DPI."ShipToCode" AS "DeilName", DPI."Address2" AS "DelAdd", LCT."Block", LCT."Street", 
  WHS."StreetNo", LCT."Building", LCT."City", LCT."Location", LCT."Country", LCT."ZipCode", LCT."GSTRegnNo" AS "LocationGSTNO", 
  GTY."GSTType" AS "LocationGSTType", 
  (CASE WHEN DPI."ExcRefDate" IS NULL THEN cast(DPI."DocTime" as varchar) ELSE DPI."ExcRefDate" END) AS "Supply Time", 
  CST."Name" AS "Supply place", CASE WHEN SLP."SlpName" = '-No Sales Employee-' THEN '' ELSE SLP."SlpName" END AS "SalesPrsn",
   SLP."Mobil" AS "salesmob", SLP."Email" AS "SalesEmail", CPR."Name" AS "Salesname", CPR."Cellolar" AS "Smob", 
   CPR."E_MailL" AS "Smail", 
   (SELECT "Name" FROM OCST WHERE "Code" = IV12."StateS" AND "Country" = iv12."CountryS") AS "Delplaceofsupply", 
   CPR."E_MailL" AS "CnctPrsnEmail", 
   (SELECT CRD1."GSTRegnNo" FROM CRD1 INNER JOIN OCRD ON OCRD."CardCode" = CRD1."CardCode" 
   WHERE OCRD."CardCode" = DPI."CardCode" AND CRD1."AdresType" = 'S' AND DPI."ShipToCode" = CRD1."Address") AS "ShipToGSTCode", 
   (SELECT GTY1."GSTType" FROM CRD1 CD1 LEFT OUTER JOIN OGTY GTY1 ON CD1."GSTType" = GTY1."AbsEntry"
    WHERE CD1."CardCode" = DPI."CardCode" AND cd1."Address" = DPI."ShipToCode" AND CD1."AdresType" = 'S') AS "ShipToGSTType", 
    (SELECT "GSTCode" FROM OCST WHERE "Code" = IV12."BpStateCod" AND "Country" = iv12."CountryS") AS "ShipToStateCode", 
    (SELECT DISTINCT CRD1."GSTRegnNo" FROM CRD1 INNER JOIN OCRD ON OCRD."CardCode" = CRD1."CardCode" 
    WHERE OCRD."CardCode" = DPI."CardCode" AND CRD1."AdresType" = 'B' AND DPI."PayToCode" = CRD1."Address") AS "BillToGSTCode", 
    (SELECT GTY1."GSTType" FROM CRD1 CD1 LEFT OUTER JOIN OGTY GTY1 ON CD1."GSTType" = GTY1."AbsEntry" 
    WHERE CD1."CardCode" = DPI."CardCode" AND cd1."Address" = DPI."PayToCode" AND CD1."AdresType" = 'S') AS "BillToGSTType", 
    (SELECT "Name" FROM OCST WHERE "Code" = IV12."StateB" AND "Country" = iv12."CountryB") AS "BillToState", 
    (SELECT "GSTCode" FROM OCST WHERE "Code" = IV12."StateB" AND "Country" = iv12."CountryB") AS "BillToStateCode", 
    (SELECT DISTINCT "TaxId0" FROM CRD7 WHERE DPI."CardCode" = "CardCode" AND "Address" = DPI."ShipToCode" AND "AddrType" = 'S') 
    AS "shipPANNo", (SELECT DISTINCT CD7."TaxId0" FROM CRD7 cd7 WHERE DPI."CardCode" = CD7."CardCode" AND 
    CD7."Address" = DPI."PayToCode" AND "AddrType" = 'S') AS "bILLPANNo", IV1."LineNum", IV1."ItemCode", IV1."Dscription", 
    (CASE WHEN ITM."ItemClass" = 1 THEN (SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = 
    (CASE WHEN IV1."HsnEntry" IS NULL THEN ITM."SACEntry" ELSE IV1."HsnEntry" END)) WHEN ITM."ItemClass" = 2 THEN 
    (SELECT "ChapterID" FROM OCHP WHERE "AbsEntry" = (CASE WHEN IV1."HsnEntry" IS NULL THEN ITM."ChapterID" ELSE IV1."HsnEntry" END))
     ELSE '' END) AS "HSN Code", (SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = IV1."SacEntry") AS "Service_SAC_Code",
      IV1."Quantity", IV1."unitMsr", IV1."PriceBefDi", IV1."DiscPrcnt", 
      (IV1."Quantity" * IV1."PriceBefDi") AS "TotalAmt", ((IV1."PriceBefDi" - IV1."Price") * IV1."Quantity") AS "ItmDiscAmt", 
      CASE WHEN OCRN."CurrCode" = 'INR' THEN (IV1."LineTotal" * (DPI."DiscPrcnt" / 100)) ELSE (IV1."TotalFrgn" * 
      (DPI."DiscPrcnt" / 100)) END AS "DocDiscAmt", CASE WHEN DPI."DiscPrcnt" = 0 THEN ((IV1."PriceBefDi" - IV1."Price") * 
      IV1."Quantity") ELSE ((CASE WHEN OCRN."CurrCode" = 'INR' THEN IV1."LineTotal" ELSE IV1."TotalFrgn" END) * 
      (DPI."DiscPrcnt" / 100)) END AS "DiscAmt", IV1."Price", CASE WHEN OCRN."CurrCode" = 'INR' THEN IV1."LineTotal" 
      ELSE IV1."TotalFrgn" END AS "LineTotal", CASE WHEN OCRN."CurrCode" = 'INR' THEN (CASE WHEN DPI."DiscPrcnt" = 0 THEN 
      IV1."LineTotal" ELSE (IV1."LineTotal" - (IV1."LineTotal" * DPI."DiscPrcnt" / 100)) END) ELSE 
      (CASE WHEN DPI."DiscPrcnt" = 0 THEN IV1."TotalFrgn" ELSE (IV1."TotalFrgn" - (IV1."TotalFrgn" * DPI."DiscPrcnt" / 100)) END)
       END AS "Total", 
       CASE WHEN IV1."AssblValue" = 0 THEN (CASE WHEN DPI."DiscPrcnt" = 0 THEN (CASE WHEN OCRN."CurrCode" = 'INR' 
       THEN IV1."LineTotal" ELSE IV1."TotalFrgn" END) ELSE ((CASE WHEN OCRN."CurrCode" = 'INR' THEN IV1."LineTotal"
        ELSE IV1."TotalFrgn" END) - ((CASE WHEN OCRN."CurrCode" = 'INR' THEN IV1."LineTotal" ELSE IV1."TotalFrgn" END) 
        * DPI."DiscPrcnt" / 100)) END) ELSE (IV1."AssblValue" * IV1."Quantity") END AS "TotalAsseble", CGST."TaxRate" AS "CGSTRate", 
        CASE WHEN OCRN."CurrCode" = 'INR' THEN CGST."TaxSum" ELSE CGST."TaxSumFrgn" END AS "CGST", SGST."TaxRate" AS "SGSTRate", 
        CASE WHEN OCRN."CurrCode" = 'INR' THEN SGST."TaxSum" ELSE SGST."TaxSumFrgn" END AS "SGST", IGST."TaxRate" AS "IGSTRate", 
        CASE WHEN OCRN."CurrCode" = 'INR' THEN IGST."TaxSum" ELSE IGST."TaxSumFrgn" END AS "IGST", DPI."DocTotal", 
        CASE WHEN OCRN."CurrCode" = 'INR' THEN DPI."RoundDif" ELSE DPI."RoundDifFC" END AS "RoundDif", 
        OCRN."CurrName" AS "Currencyname", OCRN."F100Name" AS "Hundredthname", OCT."PymntGroup" AS "Payment Terms", 
        DPI."Comments" AS "Remark", DPI."Header" AS "Opening Remark", DPI."Footer" AS "Closing Remark" 
        
        FROM ODPI DPI INNER JOIN DPI1 IV1 ON IV1."DocEntry" = DPI."DocEntry" 
        LEFT OUTER JOIN NNM1 NM1 ON DPI."Series" = NM1."Series" 
        LEFT OUTER JOIN OSLP SLP ON DPI."SlpCode" = SLP."SlpCode" 
        LEFT OUTER JOIN OWHS WHS ON IV1."WhsCode" = WHS."WhsCode" 
        LEFT OUTER JOIN OLCT LCT ON IV1."LocCode" = LCT."Code" 
        LEFT OUTER JOIN OGTY GTY ON LCT."GSTType" = GTY."AbsEntry" 
        LEFT OUTER JOIN OCST CST ON LCT."State" = CST."Code" AND LCT."Country" = CST."Country" 
        LEFT OUTER JOIN DLN1 DN1 ON IV1."BaseEntry" = DN1."DocEntry" AND IV1."BaseLine" = DN1."LineNum" AND IV1."BaseType" = DN1."ObjType" 
        LEFT OUTER JOIN ODLN DLN ON DLN."DocEntry" = DN1."DocEntry" 
        LEFT OUTER JOIN RDR1 RR1 ON DN1."BaseEntry" = RR1."DocEntry" AND DN1."BaseLine" = RR1."LineNum" 
        LEFT OUTER JOIN ORDR RDR ON RR1."DocEntry" = RDR."DocEntry" 
        LEFT OUTER JOIN OCRN ON DPI."DocCur" = OCRN."CurrCode" 
        LEFT OUTER JOIN OCTG OCT ON DPI."GroupNum" = OCT."GroupNum" 
        LEFT OUTER JOIN OSHP SHP ON SHP."TrnspCode" = DPI."TrnspCode" 
        LEFT OUTER JOIN CRD1 CD1 ON CD1."CardCode" = DPI."CardCode" AND CD1."AdresType" = 'S' AND dpi."ShipToCode" = cd1."Address" 
        LEFT OUTER JOIN DPI12 IV12 ON IV12."DocEntry" = DPI."DocEntry" 
        LEFT OUTER JOIN OCPR CPR ON DPI."CardCode" = CPR."CardCode" AND DPI."CntctCode" = CPR."CntctCode" 
        LEFT OUTER JOIN OITM ITM ON ITM."ItemCode" = IV1."ItemCode" 
        LEFT OUTER JOIN NNM1 NM11 ON RDR."Series" = NM11."Series" 
        LEFT OUTER JOIN DPI4 CGST ON IV1."DocEntry" = CGST."DocEntry" AND IV1."LineNum" = CGST."LineNum" AND CGST."staType" IN (-100) AND CGST."RelateType" = 1 
        LEFT OUTER JOIN DPI4 SGST ON IV1."DocEntry" = SGST."DocEntry" AND IV1."LineNum" = SGST."LineNum" AND SGST."staType" IN (-110) AND SGST."RelateType" = 1 
        LEFT OUTER JOIN DPI4 IGST ON IV1."DocEntry" = IGST."DocEntry" AND IV1."LineNum" = IGST."LineNum" AND IGST."staType" IN (-120) AND IGST."RelateType" = 1;



go


