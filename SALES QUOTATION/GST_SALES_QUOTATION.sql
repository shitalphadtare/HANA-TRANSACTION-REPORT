
/****************Created by: SHITAL*****************/
/***********LAST UPDATED:09-03-2018 12:36PM  BY:SHITAL*************/

/********************electrocare SALES QUOTATION***********************/
IF EXISTS (SELECT NAME FROM SYSOBJECTS WHERE NAME='GST_SALES_QUOTATION')
DROP VIEW GST_SALES_QUOTATION
GO

CREATE VIEW GST_SALES_QUOTATION
AS

SELECT QUT."DocEntry" AS "Docentry", QUT."DocNum" AS "Docnum", QUT."DocCur", QUT."DocDate" AS "Docdate", 
NM1."SeriesName" AS "Docseries", QUT."DocDueDate" AS "Valid Date", 
(CASE WHEN nm1."BeginStr" IS NULL THEN IFNULL(NM1."BeginStr", n'') ELSE IFNULL(NM1."BeginStr", n'') END || '/' || 
RTRIM(LTRIM(CAST(QUT."DocNum" AS char(20)))) || '/' || (CASE WHEN nm1."EndStr" IS NULL THEN IFNULL(NM1."EndStr", n'') ELSE 
(IFNULL(NM1."EndStr", n'')) END)) AS "Invoice No", QUT."NumAtCard" AS "RefNo", NM11."SeriesName" AS "ordseries", 
QUT."NumAtCard" AS "OrdNo", QUT."U_BPRefDt" AS "OrdDate", DLN."DocNum" AS "Challan No", DLN."DocDate" AS "Challan Date", 
QUT."PayToCode" AS "BuyerName", QUT."Address" AS "BuyerAdd", QUT."ShipToCode" AS "DeilName", QUT."Address2" AS "DelAdd", 
LCT."Block", LCT."Street", WHS."StreetNo", LCT."Building", LCT."City", LCT."Location", LCT."Country", LCT."ZipCode",
 LCT."GSTRegnNo" AS "LocationGSTNO", GTY."GSTType" AS "LocationGSTType", (CASE WHEN QUT."ExcRefDate" IS NULL THEN cast(QUT."DocTime" as varchar)
 ELSE QUT."ExcRefDate" END) AS "Supply Time", CST."Name" AS "Supply place", CASE WHEN SLP."SlpName" = '-No Sales Employee-' 
 THEN '' ELSE SLP."SlpName" END AS "SalesPrsn", SLP."Mobil" AS "salesmob", SLP."Email" AS "SalesEmail", 
 CPR."Name" AS "ContactPerson", CPR."Cellolar" AS "ContactMob", CPR."E_MailL" AS "ContactMail", 
 (SELECT "Name" FROM OCST WHERE "Code" = QT12."StateS" AND "Country" = QT12."CountryS") AS "Delplaceofsupply", 
 CPR."E_MailL" AS "CnctPrsnEmail", (SELECT CRD1."GSTRegnNo" FROM CRD1 INNER JOIN OCRD ON OCRD."CardCode" = CRD1."CardCode" 
 WHERE OCRD."CardCode" = QUT."CardCode" AND CRD1."AdresType" = 'S' AND QUT."ShipToCode" = CRD1."Address") AS "ShipToGSTCode", 
 GTY1."GSTType" AS "ShipToGSTType", (SELECT "GSTCode" FROM OCST WHERE "Code" = QT12."StateS" AND "Country" = QT12."CountryS") 
 AS "ShipToStateCode", (SELECT "Name" FROM OCST WHERE "Code" = QT12."StateB" AND "Country" = QT12."CountryB") AS "BillToState", 
 (SELECT "GSTCode" FROM OCST WHERE "Code" = QT12."StateB" AND "Country" = QT12."CountryB") AS "BillToStateCode", 
 (SELECT GTY1."GSTType" FROM CRD1 CD1 LEFT OUTER JOIN OGTY GTY1 ON CD1."GSTType" = GTY1."AbsEntry" 
 WHERE CD1."CardCode" = QUT."CardCode" AND cd1."Address" = QUT."PayToCode" AND CD1."AdresType" = 'B') AS "BillToGSTType", 
 (SELECT DISTINCT CRD1."GSTRegnNo" FROM CRD1 INNER JOIN OCRD ON OCRD."CardCode" = CRD1."CardCode" 
 WHERE OCRD."CardCode" = QUT."CardCode" AND CRD1."AdresType" = 'B' AND QUT."PayToCode" = CRD1."Address") AS "BillToGSTCode", 
 (SELECT DISTINCT "TaxId0" FROM CRD7 WHERE QUT."CardCode" = "CardCode" AND QUT."ShipToCode" = CRD7."Address" AND "AddrType" = 's')
  AS "shipPANNo", (SELECT DISTINCT CD7."TaxId0" FROM CRD7 cd7 WHERE QUT."CardCode" = CD7."CardCode" AND 
  QUT."ShipToCode" = cd7."Address" AND CD7."AddrType" = 's') AS "bILLPANNo", cpr."Title", cst."GSTCode", RR1."LineNum", 
  RR1."ItemCode", RR1."Dscription", (CASE WHEN ITM."ItemClass" = 1 THEN (SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = 
  (CASE WHEN RR1."HsnEntry" IS NULL THEN ITM."SACEntry" ELSE rr1."HsnEntry" END)) WHEN ITM."ItemClass" = 2 THEN 
  (SELECT "ChapterID" FROM OCHP WHERE "AbsEntry" = (CASE WHEN RR1."HsnEntry" IS NULL THEN ITM."ChapterID" ELSE rr1."HsnEntry" END))
   ELSE '' END) AS "HSN Code", (SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = RR1."SacEntry") AS "Service_SAC_Code", 
   RR1."Quantity", RR1."unitMsr", RR1."PriceBefDi", RR1."DiscPrcnt", (RR1."Quantity" * RR1."PriceBefDi") AS "TotalAmt", 
   ((RR1."PriceBefDi" - RR1."Price") * RR1."Quantity") AS "ItmDiscAmt", ((CASE WHEN OCRN."CurrCode" = 'INR' THEN RR1."LineTotal" 
   ELSE RR1."TotalFrgn" END) * (QUT."DiscPrcnt" / 100)) AS "DocDiscAmt", CASE WHEN QUT."DiscPrcnt" = 0 THEN 
   ((RR1."PriceBefDi" - RR1."Price") * RR1."Quantity") ELSE ((CASE WHEN OCRN."CurrCode" = 'INR' THEN RR1."LineTotal" 
   ELSE RR1."TotalFrgn" END) * (QUT."DiscPrcnt" / 100)) END AS "DiscAmt", RR1."Price", CASE WHEN OCRN."CurrCode" = 'INR' 
   THEN RR1."LineTotal" ELSE RR1."TotalFrgn" END AS "LineTotal", CASE WHEN OCRN."CurrCode" = 'INR' THEN 
   (CASE WHEN QUT."DiscPrcnt" = 0 THEN RR1."LineTotal" ELSE (RR1."LineTotal" - (RR1."LineTotal" * QUT."DiscPrcnt" / 100)) END) 
   ELSE (CASE WHEN QUT."DiscPrcnt" = 0 THEN RR1."TotalFrgn" ELSE (RR1."TotalFrgn" - (RR1."TotalFrgn" * QUT."DiscPrcnt" / 100)) END)
    END AS "Total", CASE WHEN RR1."AssblValue" = 0 THEN (CASE WHEN QUT."DiscPrcnt" = 0 THEN (CASE WHEN OCRN."CurrCode" = 'INR' 
    THEN RR1."LineTotal" ELSE RR1."TotalFrgn" END) ELSE ((CASE WHEN OCRN."CurrCode" = 'INR' THEN RR1."LineTotal" ELSE 
    RR1."TotalFrgn" END) - ((CASE WHEN OCRN."CurrCode" = 'INR' THEN RR1."LineTotal" ELSE RR1."TotalFrgn" END) * 
    QUT."DiscPrcnt" / 100)) END) ELSE (RR1."AssblValue" * RR1."Quantity") END AS "TotalAsseble", CGST."TaxRate" AS "CGSTRate",
     CASE WHEN OCRN."CurrCode" = 'INR' THEN CGST."TaxSum" ELSE CGST."TaxSumFrgn" END AS "CGST", SGST."TaxRate" AS "SGSTRate", 
     CASE WHEN OCRN."CurrCode" = 'INR' THEN SGST."TaxSum" ELSE SGST."TaxSumFrgn" END AS "SGST", IGST."TaxRate" AS "IGSTRate", 
     CASE WHEN OCRN."CurrCode" = 'INR' THEN IGST."TaxSum" ELSE IGST."TaxSumFrgn" END AS "IGST", QUT."DocTotal", 
     CASE WHEN OCRN."CurrCode" = 'INR' THEN QUT."RoundDif" ELSE QUT."RoundDifFC" END AS "RoundDif", OCRN."CurrName" 
     AS "Currencyname", OCRN."F100Name" AS "Hundredthname", OCT."PymntGroup" AS "Payment Terms", QUT."Comments" AS "Remark", 
     QUT."Header" AS "Opening Remark", QUT."Footer" AS "Closing Remark", shp."TrnspName", qut."U_Terms_Del" AS "Delivery", 
     rr1."U_ItemDesc2" 
     
     FROM OQUT QUT 
     INNER JOIN QUT1 RR1 ON RR1."DocEntry" = QUT."DocEntry" 
     INNER JOIN NNM1 NM1 ON QUT."Series" = NM1."Series" 
     INNER JOIN OSLP SLP ON QUT."SlpCode" = SLP."SlpCode" 
     LEFT OUTER JOIN OWHS WHS ON RR1."WhsCode" = WHS."WhsCode" 
     LEFT OUTER JOIN OLCT LCT ON RR1."LocCode" = LCT."Code" 
     LEFT OUTER JOIN OGTY GTY ON LCT."GSTType" = GTY."AbsEntry" 
     LEFT OUTER JOIN OCST CST ON LCT."State" = CST."Code" AND LCT."Country" = CST."Country" 
     LEFT OUTER JOIN RDR1 RD1 ON RR1."DocEntry" = RD1."BaseEntry" AND RR1."LineNum" = RD1."BaseLine" AND RR1."ObjType" = RD1."BaseType" 
     LEFT OUTER JOIN ORDR RDR ON RDR."DocEntry" = RR1."DocEntry" 
     LEFT OUTER JOIN DLN1 DN1 ON RD1."DocEntry" = DN1."BaseEntry" AND RD1."LineNum" = DN1."BaseLine" AND RD1."ObjType" = DN1."BaseType" 
     LEFT OUTER JOIN ODLN DLN ON DLN."DocEntry" = DN1."DocEntry" 
     LEFT OUTER JOIN QUT1 QUT1 ON DN1."BaseEntry" = QUT1."DocEntry" AND DN1."BaseLine" = QUT1."LineNum" 
     LEFT OUTER JOIN OQUT OQUT ON QUT1."DocEntry" = OQUT."DocEntry" 
     LEFT OUTER JOIN OCRN ON QUT."DocCur" = OCRN."CurrCode" 
     LEFT OUTER JOIN OCTG OCT ON QUT."GroupNum" = OCT."GroupNum" 
     LEFT OUTER JOIN CRD1 CD1 ON CD1."CardCode" = QUT."CardCode" AND CD1."AdresType" = 'S' AND QUT."ShipToCode" = CD1."Address" 
     LEFT OUTER JOIN QUT12 QT12 ON QT12."DocEntry" = QUT."DocEntry" 
     LEFT OUTER JOIN OCST CST1 ON CST1."Code" = QT12."StateS" AND CST1."Country" = QT12."CountryS" 
     LEFT OUTER JOIN OGTY GTY1 ON CD1."GSTType" = GTY1."AbsEntry" 
     LEFT OUTER JOIN OCPR CPR ON QUT."CardCode" = CPR."CardCode" AND QUT."CntctCode" = CPR."CntctCode" 
     LEFT OUTER JOIN OITM ITM ON ITM."ItemCode" = RR1."ItemCode" 
     LEFT OUTER JOIN NNM1 NM11 ON OQUT."Series" = NM11."Series" 
     LEFT OUTER JOIN QUT4 CGST ON RR1."DocEntry" = CGST."DocEntry" AND RR1."LineNum" = CGST."LineNum" AND CGST."staType" IN (-100) AND CGST."RelateType" = 1 
     LEFT OUTER JOIN QUT4 SGST ON RR1."DocEntry" = SGST."DocEntry" AND RR1."LineNum" = SGST."LineNum" AND SGST."staType" IN (-110) AND SGST."RelateType" = 1 
     LEFT OUTER JOIN QUT4 IGST ON RR1."DocEntry" = IGST."DocEntry" AND RR1."LineNum" = IGST."LineNum" AND IGST."staType" IN (-120) AND IGST."RelateType" = 1 
     LEFT OUTER JOIN OSHP shp ON qut."TrnspCode" = shp."TrnspCode";


