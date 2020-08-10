
/****************Created by: SHITAL*****************/
/***********LAST UPDATED:090718 13:33 PM  BY:SHITAL*************/

/********************WILLOW PURCHASE ORDER***********************/
IF EXISTS (SELECT NAME FROM SYSOBJECTS WHERE NAME='GST_GOODS_RECEIPT')
DROP VIEW GST_GOODS_RECEIPT
GO
									
CREATE VIEW GST_GOODS_RECEIPT
AS
SELECT PDN."DocEntry" AS "Docentry", PDN."DocNum" AS "Docnum", PDN."DocCur", NM1."SeriesName" AS "Docseries", 
PDN."DocDate" AS "Docdate", 
(CASE WHEN nm1."BeginStr" IS NULL THEN IFNULL(NM1."BeginStr", n'') ELSE IFNULL(NM1."BeginStr", n'') END || 
RTRIM(LTRIM(CAST(PDN."DocNum" AS char(20)))) || (CASE WHEN nm1."EndStr" IS NULL THEN IFNULL(NM1."EndStr", n'') ELSE 
(IFNULL(NM1."EndStr", n'')) END)) AS "Purchase No", PDN."CardName" AS "VName", PDN."Address" AS "VendorAdd", 
CPR."Name" AS "V_CNCTP_N", cpr."Cellolar" AS "V_mobileNo", CPR."E_MailL" AS "V_CnctP_E", "VShipFrom"."Block", 
"VShipFrom"."Building", "VShipFrom"."Street", "VShipFrom"."City", "VShipFrom"."ZipCode", 
(SELECT DISTINCT "Name" FROM OCRY WHERE "Code" = "VShipFrom"."Country") AS "country", 
"VShipFrom"."StreetNo" AS "Street No_Vendor", 
(SELECT DISTINCT "Name" FROM OCST WHERE "Code" = "VShipFrom"."State" AND "VShipFrom1"."Country" = OCST."Country") AS "STATE_Vendor", 
"VShipFrom1"."GSTRegnNo" AS "VShipGSTNo", GTY2."GSTType" AS "VShipGSTType", PDN."NumAtCard" AS "SupRefNo", '' AS "SupDate", 
 (SELECT
	 distinct (Cast(OPOR."DocNum" AS CHAR(7))) 
	FROM OPOR 
	inner join PDN1 on OPOR."DocEntry"=PDN1."BaseEntry" 
	and PDN1."DocEntry"=PDN."DocEntry" 
	left outer join NNM1 on NNM1."Series"=OPOR."Series" ) "PR No" ,
	 (SELECT
	 Distinct TO_VARCHAR(OPOR."DocDate",
	 'DD-MM-YYYY') 
	FROM OPOR 
	inner join PDN1 on OPOR."DocEntry"=PDN1."BaseEntry" 
	where PDN1."DocEntry" =PDN."DocEntry") "PR Date",
PDN."DocDueDate" AS "DeliDate", SHP."TrnspName" AS "Deli_Mode", PDN."Address2" AS "Deli_Addr", LCT."GSTRegnNo" AS "Deli_GST", 
GTY."GSTType" AS "Deli_GSTType", PDN."PayToCode" AS "BuyerName", PDN."ShipToCode" AS "DeilName",
 CASE WHEN SLP."SlpName" = '-No Sales Employee-' THEN '' ELSE SLP."SlpName" END AS "SalesPrsn", SLP."Mobil" AS "salesmob", 
 SLP."Email" AS "SalesEmail", CPR."E_MailL" AS "CnctPrsnEmail", PN1."LineNum", PN1."ItemCode", PN1."Dscription", 
 (CASE WHEN ITM."ItemClass" = 1 THEN (SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = 
 (CASE WHEN PN1."HsnEntry" IS NULL THEN ITM."SACEntry" ELSE PN1."HsnEntry" END)) WHEN ITM."ItemClass" = 2 THEN 
 (SELECT "ChapterID" FROM OCHP WHERE "AbsEntry" = (CASE WHEN PN1."HsnEntry" IS NULL THEN ITM."ChapterID" ELSE PN1."HsnEntry" END))
  ELSE '' END) AS "HSN Code", (SELECT "ServCode" FROM OSAC WHERE "AbsEntry" = PN1."SacEntry") AS "Service_SAC_Code", 
  PN1."Quantity", PN1."unitMsr", PN1."PriceBefDi", PN1."DiscPrcnt", (PN1."Quantity" * PN1."PriceBefDi") AS "TotalAmt", 
  ((PN1."PriceBefDi" - PN1."Price") * PN1."Quantity") AS "ItmDiscAmt", 
  ((CASE WHEN OCRN."CurrCode" = 'INR' THEN PN1."LineTotal" ELSE PN1."TotalFrgn" END) * (PDN."DiscPrcnt" / 100)) AS "DocDiscAmt", 
  CASE WHEN PDN."DiscPrcnt" = 0 THEN ((PN1."PriceBefDi" - PN1."Price") * PN1."Quantity") ELSE 
  ((CASE WHEN OCRN."CurrCode" = 'INR' THEN PN1."LineTotal" ELSE PN1."TotalFrgn" END) * (PDN."DiscPrcnt" / 100)) END AS "DiscAmt", 
  PN1."Price", CASE WHEN OCRN."CurrCode" = 'INR' THEN PN1."LineTotal" ELSE PN1."TotalFrgn" END AS "LineTotal", 
  CASE WHEN OCRN."CurrCode" = 'INR' THEN (CASE WHEN PDN."DiscPrcnt" = 0 THEN PN1."LineTotal" ELSE (PN1."LineTotal" - 
  (PN1."LineTotal" * PDN."DiscPrcnt" / 100)) END) ELSE (CASE WHEN PDN."DiscPrcnt" = 0 THEN PN1."TotalFrgn" ELSE 
  (PN1."TotalFrgn" - (PN1."TotalFrgn" * PDN."DiscPrcnt" / 100)) END) END AS "Total", CASE WHEN PN1."AssblValue" = 0 THEN 
  (CASE WHEN PDN."DiscPrcnt" = 0 THEN (CASE WHEN OCRN."CurrCode" = 'INR' THEN PN1."LineTotal" ELSE PN1."TotalFrgn" END) ELSE 
  ((CASE WHEN OCRN."CurrCode" = 'INR' THEN PN1."LineTotal" ELSE PN1."TotalFrgn" END) - ((CASE WHEN OCRN."CurrCode" = 'INR' THEN 
  PN1."LineTotal" ELSE PN1."TotalFrgn" END) * PDN."DiscPrcnt" / 100)) END) ELSE (PN1."AssblValue" * PN1."Quantity") END AS "TotalAsseble", 
  CGST."TaxRate" AS "CGSTRate", CASE WHEN OCRN."CurrCode" = 'INR' THEN CGST."TaxSum" ELSE CGST."TaxSumFrgn" END AS "CGST", 
  SGST."TaxRate" AS "SGSTRate", CASE WHEN OCRN."CurrCode" = 'INR' THEN SGST."TaxSum" ELSE SGST."TaxSumFrgn" END AS "SGST", 
  IGST."TaxRate" AS "IGSTRate", CASE WHEN OCRN."CurrCode" = 'INR' THEN IGST."TaxSum" ELSE IGST."TaxSumFrgn" END AS "IGST", 
  PDN."DocTotal", CASE WHEN OCRN."CurrCode" = 'INR' THEN PDN."RoundDif" ELSE PDN."RoundDifFC" END AS "RoundDif", 
  OCRN."CurrName" AS "Currencyname", OCRN."F100Name" AS "Hundredthname", OCT."PymntGroup" AS "Payment Terms", 
  PDN."Comments" AS "Remark", PDN."Header" AS "Opening Remark", PDN."Footer" AS "Closing Remark", PRJ."PrjName" AS "PrjName", 
  PN1."ShipDate" AS "ShipDate", PDN."U_OCNo" AS "U_OC_No", CPR."Cellolar", 
  CASE WHEN PDN."U_Terms_Del" IS NULL OR PDN."U_Terms_Del" = '' THEN '' ELSE PDN."U_Terms_Del" END AS "Delivery", 
  CASE WHEN PDN."U_Terms_Pay" IS NULL OR PDN."U_Terms_Pay" = '' THEN '' ELSE PDN."U_Terms_Pay" END AS "Payment", 
  CASE WHEN PDN."U_Terms_Insp" IS NULL OR PDN."U_Terms_Insp" = '' THEN '' ELSE PDN."U_Terms_Insp" END AS "Ispection", 
  CASE WHEN PDN."U_Terms_Price" IS NULL OR PDN."U_Terms_Price" = '' THEN '' ELSE PDN."U_Terms_Price" END AS "Terms_Price", 
  CASE WHEN PDN."U_Terms_PackInst" IS NULL OR PDN."U_Terms_PackInst" = '' THEN '' ELSE PDN."U_Terms_PackInst" END AS "Packing Instruction", 
  CASE WHEN PDN."U_Terms_Insu" IS NULL OR PDN."U_Terms_Insu" = '' THEN '' ELSE PDN."U_Terms_Insu" END AS "Insurance", 
  CASE WHEN PDN."U_Terms_Frt" IS NULL OR PDN."U_Terms_Frt" = '' THEN '' ELSE PDN."U_Terms_Frt" END AS "Freight", 
  CASE WHEN PDN."U_Terms_PNF" IS NULL OR PDN."U_Terms_PNF" = '' THEN '' ELSE PDN."U_Terms_PNF" END AS "P & N", PDN."U_BPRefDt", 
  PN1."ShipDate" AS "DueOn", PDN."U_Terms_Del" 
  
  FROM OPDN PDN 
  INNER JOIN PDN1 PN1 ON PN1."DocEntry" = PDN."DocEntry" 
  INNER JOIN NNM1 NM1 ON PDN."Series" = NM1."Series" 
  LEFT OUTER JOIN OCRD CRD ON PDN."CardCode" = crd."CardCode" 
  LEFT OUTER JOIN (SELECT * FROM CRD1) AS "VShipFrom" ON "VShipFrom"."Address" = PDN."ShipToCode" AND
   "VShipFrom"."CardCode" = PDN."CardCode" AND "VShipFrom"."AdresType" = 'S' 
   
   LEFT OUTER JOIN (SELECT * FROM CRD1) AS "VShipFrom1" ON "VShipFrom1"."Address" = CRD."ShipToDef" AND 
   "VShipFrom1"."CardCode" = PDN."CardCode" AND "VShipFrom1"."AdresType" = 'S' 
   
   LEFT OUTER JOIN OGTY GTY2 ON "VShipFrom1"."GSTType" = GTY2."AbsEntry" 
   INNER JOIN OSLP SLP ON PDN."SlpCode" = SLP."SlpCode" 
   LEFT OUTER JOIN OSHP SHP ON SHP."TrnspCode" = PDN."TrnspCode" 
   LEFT OUTER JOIN OLCT LCT ON PN1."LocCode" = LCT."Code" 
   LEFT OUTER JOIN OGTY GTY ON LCT."GSTType" = GTY."AbsEntry" 
   LEFT OUTER JOIN OCRN ON PDN."DocCur" = OCRN."CurrCode" 
   LEFT OUTER JOIN OCTG OCT ON PDN."GroupNum" = OCT."GroupNum" 
   LEFT OUTER JOIN PDN12 PN12 ON PN12."DocEntry" = PDN."DocEntry" 
   LEFT OUTER JOIN OCST CST1 ON CST1."Code" = PN12."StateS" AND CST1."Country" = PN12."CountryS" 
   LEFT OUTER JOIN OCPR CPR ON PDN."CardCode" = CPR."CardCode" AND PDN."CntctCode" = CPR."CntctCode" 
   LEFT OUTER JOIN OITM ITM ON ITM."ItemCode" = PN1."ItemCode" 
   LEFT OUTER JOIN PDN4 CGST ON PN1."DocEntry" = CGST."DocEntry" AND PN1."LineNum" = CGST."LineNum" AND CGST."staType" IN (-100) AND CGST."RelateType" = 1 
   LEFT OUTER JOIN PDN4 SGST ON PN1."DocEntry" = SGST."DocEntry" AND PN1."LineNum" = SGST."LineNum" AND SGST."staType" IN (-110) AND SGST."RelateType" = 1 
   LEFT OUTER JOIN PDN4 IGST ON PN1."DocEntry" = IGST."DocEntry" AND PN1."LineNum" = IGST."LineNum" AND IGST."staType" IN (-120) AND IGST."RelateType" = 1 
   LEFT OUTER JOIN OPRJ PRJ ON PRJ."PrjCode" = PDN."Project";


