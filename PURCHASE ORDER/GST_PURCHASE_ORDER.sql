
/****************Created by: SHITAL*****************/
/***********LAST UPDATED:090718 13:33 PM  BY:SHITAL*************/

/********************WILLOW PURCHASE ORDER***********************/
IF EXISTS (SELECT NAME FROM SYSOBJECTS WHERE NAME='GST_PURCHASE_ORDER')
DROP VIEW GST_PURCHASE_ORDER
GO
									
CREATE VIEW GST_PURCHASE_ORDER
AS
SELECT POR."DocEntry" AS "Docentry", POR."DocNum" AS "Docnum", POR."DocCur", NM1."SeriesName" AS "Docseries", 
POR."DocDate" AS "Docdate", 
(CASE WHEN nm1."BeginStr" IS NULL THEN IFNULL(NM1."BeginStr", n'') ELSE IFNULL(NM1."BeginStr", n'') END || 
RTRIM(LTRIM(CAST(POR."DocNum" AS char(20)))) || (CASE WHEN nm1."EndStr" IS NULL THEN IFNULL(NM1."EndStr", n'') ELSE 
(IFNULL(NM1."EndStr", n'')) END)) AS "Purchase No", POR."CardName" AS "VName", POR."Address" AS "VendorAdd", 
CPR."Name" AS "V_CNCTP_N", cpr."Cellolar" AS "V_mobileNo", CPR."E_MailL" AS "V_CnctP_E", "VShipFrom"."Block", 
"VShipFrom"."Building", "VShipFrom"."Street", "VShipFrom"."City", "VShipFrom"."ZipCode", 
(SELECT DISTINCT "Name" FROM OCRY WHERE "Code" = "VShipFrom"."Country") AS "country", 
"VShipFrom"."StreetNo" AS "Street No_Vendor", 
(SELECT DISTINCT "Name" FROM OCST WHERE "Code" = "VShipFrom"."State" AND "VShipFrom1"."Country" = OCST."Country") AS "STATE_Vendor", 
"VShipFrom1"."GSTRegnNo" AS "VShipGSTNo", GTY2."GSTType" AS "VShipGSTType", POR."NumAtCard" AS "SupRefNo", '' AS "SupDate", 
 (SELECT
	 distinct (Cast(OPRQ."DocNum" AS CHAR(7))) 
	FROM OPRQ 
	inner join POR1 on OPRQ."DocEntry"=POR1."BaseEntry" 
	and POR1."DocEntry"=POR."DocEntry" 
	left outer join NNM1 on NNM1."Series"=OPRQ."Series" ) "PR No" ,
	 (SELECT
	 Distinct TO_VARCHAR(OPRQ."DocDate",
	 'DD-MM-YYYY') 
	FROM OPRQ 
	inner join POR1 on OPRQ."DocEntry"=POR1."BaseEntry" 
	where POR1."DocEntry" =POR."DocEntry") "PR Date",
POR."DocDueDate" AS "DeliDate", SHP."TrnspName" AS "Deli_Mode", POR."Address2" AS "Deli_Addr", LCT."GSTRegnNo" AS "Deli_GST", 
GTY."GSTType" AS "Deli_GSTType", POR."PayToCode" AS "BuyerName", POR."ShipToCode" AS "DeilName",
 CASE WHEN SLP."SlpName" = '-No Sales Employee-' THEN '' ELSE SLP."SlpName" END AS "SalesPrsn", SLP."Mobil" AS "salesmob", 
 SLP."Email" AS "SalesEmail", CPR."E_MailL" AS "CnctPrsnEmail", PR1."LineNum", PR1."ItemCode", PR1."Dscription", 
 (CASE WHEN ITM."ItemClass" = 1 THEN (SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = 
 (CASE WHEN PR1."HsnEntry" IS NULL THEN ITM."SACEntry" ELSE PR1."HsnEntry" END)) WHEN ITM."ItemClass" = 2 THEN 
 (SELECT "ChapterID" FROM OCHP WHERE "AbsEntry" = (CASE WHEN PR1."HsnEntry" IS NULL THEN ITM."ChapterID" ELSE PR1."HsnEntry" END))
  ELSE '' END) AS "HSN Code", (SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = PR1."SacEntry") AS "Service_SAC_Code", 
  PR1."Quantity", PR1."unitMsr", PR1."PriceBefDi", PR1."DiscPrcnt", (PR1."Quantity" * PR1."PriceBefDi") AS "TotalAmt", 
  ((PR1."PriceBefDi" - PR1."Price") * PR1."Quantity") AS "ItmDiscAmt", 
  ((CASE WHEN OCRN."CurrCode" = 'INR' THEN PR1."LineTotal" ELSE PR1."TotalFrgn" END) * (POR."DiscPrcnt" / 100)) AS "DocDiscAmt", 
  CASE WHEN POR."DiscPrcnt" = 0 THEN ((PR1."PriceBefDi" - PR1."Price") * PR1."Quantity") ELSE 
  ((CASE WHEN OCRN."CurrCode" = 'INR' THEN PR1."LineTotal" ELSE PR1."TotalFrgn" END) * (POR."DiscPrcnt" / 100)) END AS "DiscAmt", 
  PR1."Price", CASE WHEN OCRN."CurrCode" = 'INR' THEN PR1."LineTotal" ELSE PR1."TotalFrgn" END AS "LineTotal", 
  CASE WHEN OCRN."CurrCode" = 'INR' THEN (CASE WHEN POR."DiscPrcnt" = 0 THEN PR1."LineTotal" ELSE (PR1."LineTotal" - 
  (PR1."LineTotal" * POR."DiscPrcnt" / 100)) END) ELSE (CASE WHEN POR."DiscPrcnt" = 0 THEN PR1."TotalFrgn" ELSE 
  (PR1."TotalFrgn" - (PR1."TotalFrgn" * POR."DiscPrcnt" / 100)) END) END AS "Total", CASE WHEN PR1."AssblValue" = 0 THEN 
  (CASE WHEN POR."DiscPrcnt" = 0 THEN (CASE WHEN OCRN."CurrCode" = 'INR' THEN PR1."LineTotal" ELSE PR1."TotalFrgn" END) ELSE 
  ((CASE WHEN OCRN."CurrCode" = 'INR' THEN PR1."LineTotal" ELSE PR1."TotalFrgn" END) - ((CASE WHEN OCRN."CurrCode" = 'INR' THEN 
  PR1."LineTotal" ELSE PR1."TotalFrgn" END) * POR."DiscPrcnt" / 100)) END) ELSE (PR1."AssblValue" * PR1."Quantity") END AS "TotalAsseble", 
  CGST."TaxRate" AS "CGSTRate", CASE WHEN OCRN."CurrCode" = 'INR' THEN CGST."TaxSum" ELSE CGST."TaxSumFrgn" END AS "CGST", 
  SGST."TaxRate" AS "SGSTRate", CASE WHEN OCRN."CurrCode" = 'INR' THEN SGST."TaxSum" ELSE SGST."TaxSumFrgn" END AS "SGST", 
  IGST."TaxRate" AS "IGSTRate", CASE WHEN OCRN."CurrCode" = 'INR' THEN IGST."TaxSum" ELSE IGST."TaxSumFrgn" END AS "IGST", 
  POR."DocTotal", CASE WHEN OCRN."CurrCode" = 'INR' THEN POR."RoundDif" ELSE POR."RoundDifFC" END AS "RoundDif", 
  OCRN."CurrName" AS "Currencyname", OCRN."F100Name" AS "Hundredthname", OCT."PymntGroup" AS "Payment Terms", 
  POR."Comments" AS "Remark", POR."Header" AS "Opening Remark", POR."Footer" AS "Closing Remark", PRJ."PrjName" AS "PrjName", 
  PR1."ShipDate" AS "ShipDate", POR."U_OCNo" AS "U_OC_No", CPR."Cellolar", 
  CASE WHEN POR."U_Terms_Del" IS NULL OR POR."U_Terms_Del" = '' THEN '' ELSE POR."U_Terms_Del" END AS "Delivery", 
  CASE WHEN POR."U_Terms_Pay" IS NULL OR POR."U_Terms_Pay" = '' THEN '' ELSE POR."U_Terms_Pay" END AS "Payment", 
  CASE WHEN POR."U_Terms_Insp" IS NULL OR POR."U_Terms_Insp" = '' THEN '' ELSE POR."U_Terms_Insp" END AS "Ispection", 
  CASE WHEN POR."U_Terms_Price" IS NULL OR POR."U_Terms_Price" = '' THEN '' ELSE POR."U_Terms_Price" END AS "Terms_Price", 
  CASE WHEN POR."U_Terms_PackInst" IS NULL OR POR."U_Terms_PackInst" = '' THEN '' ELSE POR."U_Terms_PackInst" END AS "Packing Instruction", 
  CASE WHEN POR."U_Terms_Insu" IS NULL OR POR."U_Terms_Insu" = '' THEN '' ELSE POR."U_Terms_Insu" END AS "Insurance", 
  CASE WHEN POR."U_Terms_Frt" IS NULL OR POR."U_Terms_Frt" = '' THEN '' ELSE POR."U_Terms_Frt" END AS "Freight", 
  CASE WHEN POR."U_Terms_PNF" IS NULL OR POR."U_Terms_PNF" = '' THEN '' ELSE POR."U_Terms_PNF" END AS "P & N", POR."U_BPRefDt", 
  PR1."ShipDate" AS "DueOn", Por."U_Terms_Del" 
  
  FROM OPOR POR 
  INNER JOIN POR1 PR1 ON PR1."DocEntry" = POR."DocEntry" 
  INNER JOIN NNM1 NM1 ON POR."Series" = NM1."Series" 
  LEFT OUTER JOIN OCRD CRD ON por."CardCode" = crd."CardCode" 
  LEFT OUTER JOIN (SELECT * FROM CRD1) AS "VShipFrom" ON "VShipFrom"."Address" = por."ShipToCode" AND
   "VShipFrom"."CardCode" = POR."CardCode" AND "VShipFrom"."AdresType" = 'S' 
   
   LEFT OUTER JOIN (SELECT * FROM CRD1) AS "VShipFrom1" ON "VShipFrom1"."Address" = CRD."ShipToDef" AND 
   "VShipFrom1"."CardCode" = POR."CardCode" AND "VShipFrom1"."AdresType" = 'S' 
   
   LEFT OUTER JOIN OGTY GTY2 ON "VShipFrom1"."GSTType" = GTY2."AbsEntry" 
   INNER JOIN OSLP SLP ON POR."SlpCode" = SLP."SlpCode" 
   LEFT OUTER JOIN OSHP SHP ON SHP."TrnspCode" = POR."TrnspCode" 
   LEFT OUTER JOIN OLCT LCT ON PR1."LocCode" = LCT."Code" 
   LEFT OUTER JOIN OGTY GTY ON LCT."GSTType" = GTY."AbsEntry" 
   LEFT OUTER JOIN OCRN ON POR."DocCur" = OCRN."CurrCode" 
   LEFT OUTER JOIN OCTG OCT ON POR."GroupNum" = OCT."GroupNum" 
   LEFT OUTER JOIN POR12 PR12 ON PR12."DocEntry" = POR."DocEntry" 
   LEFT OUTER JOIN OCST CST1 ON CST1."Code" = PR12."StateS" AND CST1."Country" = PR12."CountryS" 
   LEFT OUTER JOIN OCPR CPR ON POR."CardCode" = CPR."CardCode" AND POR."CntctCode" = CPR."CntctCode" 
   LEFT OUTER JOIN OITM ITM ON ITM."ItemCode" = PR1."ItemCode" 
   LEFT OUTER JOIN POR4 CGST ON PR1."DocEntry" = CGST."DocEntry" AND PR1."LineNum" = CGST."LineNum" AND CGST."staType" IN (-100) AND CGST."RelateType" = 1 
   LEFT OUTER JOIN POR4 SGST ON PR1."DocEntry" = SGST."DocEntry" AND PR1."LineNum" = SGST."LineNum" AND SGST."staType" IN (-110) AND SGST."RelateType" = 1 
   LEFT OUTER JOIN POR4 IGST ON PR1."DocEntry" = IGST."DocEntry" AND PR1."LineNum" = IGST."LineNum" AND IGST."staType" IN (-120) AND IGST."RelateType" = 1 
   LEFT OUTER JOIN OPRJ PRJ ON PRJ."PrjCode" = POR."Project";


