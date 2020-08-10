IF EXISTS (SELECT NAME FROM SYSOBJECTS WHERE NAME='PACKING_LIST')
DROP VIEW PACKING_LIST
GO


CREATE VIEW PACKING_LIST
AS

SELECT Oi."DocEntry", Oi."DocNum", Oi."DocDate", 
(CASE WHEN Oi."U_InvoiceNo" IS NULL THEN 
(ivnm."SeriesName" || '/' || CAST(Oi."DocNum" AS char(20))) ELSE Oi."U_InvoiceNo" END) AS "Invoice No", 
Oi."NumAtCard" AS "BuyerRefNo", 
oi."U_BpRefDT" AS "BuyerRefDate", 
Oi.U_OTHEREF AS "OtherRef", 
Oi."DocRate", 
Oi."DocDueDate", Oi."CardCode", Oi."CardName", Oi."ShipToCode" AS "Consignee", 
Oi."Address2" AS "ConSigneeAdd", Oi."PayToCode" AS "BuyerCode", Oi."Address" AS "BuyerAdd", 
Crd7."ECCNo", Crd7."CERange", Crd7."CEDivis", Crd7."CEComRate", DLN12."TaxId11" AS "TinNo", 
DLN12."TaxId2" AS "LstNo", DLN12."TaxId2" AS "No", Oi."U_Final_Dest" AS "FinalDestination",
Oi."U_Place_Receipt" AS "Place Of receipt", Oi."U_Pre_Carriage" AS "PreCarriage", Oi."U_Vessel_No" AS "VessalNo", 
Oi."U_Cnt_Final_Dest" AS "FDestCountry", Oi."U_Port_Load" AS "LoadPort", Oi."U_Port_Dish" AS "DischargePort",
 Oi."U_Terms_Del" AS "DelTerms", Oi."U_Terms_Pay" AS "PayTerms", Oi."U_VolWt" AS "VolumWt", iv7."U_PkgNum" AS "WoodenPallet", 
 iv7."U_PkgSizeMt" AS "PackageSizeMtr", iv7."U_PkgSizeIn" AS "PackageSizeInch", iv7."U_NumOutBox" AS "OuterBoxNo", 
 iv7."U_OutBoxDim" AS "OuterBoxDia", iv7."U_NumInBox" AS "InnerBoxNo", iv7."U_InBoxDim" AS "IneerBoxDia", 
 ot."ItemName" AS "Description", ot."SWeight1" AS "WeightValue", t2."UnitDisply" AS "WeightUOM", 
 (CASE WHEN t2."UnitDisply" = 'g' THEN ot."SWeight1" ELSE (CASE WHEN t2."UnitDisply" = 'kg' THEN ot."SWeight1" * 1000 
 ELSE ot."SWeight1" / 1000 END) END) AS "Item Weight", iv8."Quantity", iv7."U_GrossWt" AS "GrossWt", 
 ot."InvntryUom" AS "UnitMstr", IFNULL(Oi."TotalExpns", 0) AS "TotalExpns", IFNULL(Oi."DiscSum", 0) AS "DiscSum",
  Oi."Comments", Oi."Footer" AS "Terms", OCRN."DocCurrCod", OCRN."CurrName" AS "Currencyname", OCRN."F100Name" AS "Hundredthname",
   ot.U_DRG_NO AS "Item DRG_No", iv7."U_QtyPerPkg" AS "QtyPerBOx", 
   (CASE WHEN (oi."U_No_Of_Pkgs") IS NULL THEN (SELECT COUNT(DISTINCT (("U_PkgNum"))) FROM DLN7 WHERE "DocEntry" = oi."DocEntry") 
   ELSE oi."U_No_Of_Pkgs" END) AS "GroupCount", 
   (SELECT "Street" FROM OLCT WHERE "Code" = (SELECT DISTINCT "LocCode" FROM DLN1 WHERE "DocEntry" = oi."DocEntry")) AS "Street", 
   (SELECT "Block" FROM OLCT WHERE "Code" = (SELECT DISTINCT "LocCode" FROM DLN1 WHERE "DocEntry" = oi."DocEntry")) AS "Block", 
   (SELECT "Building" FROM OLCT WHERE "Code" = (SELECT DISTINCT "LocCode" FROM DLN1 WHERE "DocEntry" = oi."DocEntry")) AS "Building",
    (SELECT "Location" FROM OLCT WHERE "Code" = (SELECT DISTINCT "LocCode" FROM DLN1 WHERE "DocEntry" = oi."DocEntry")) AS "Location",
     (SELECT "City" FROM OLCT WHERE "Code" = (SELECT DISTINCT "LocCode" FROM DLN1 WHERE "DocEntry" = oi."DocEntry")) AS "City", 
     (SELECT "ZipCode" FROM OLCT WHERE "Code" = (SELECT DISTINCT "LocCode" FROM DLN1 WHERE "DocEntry" = oi."DocEntry")) AS "Zipcode",
      oi."U_Pkg_Type" AS "PkgType" 
      
      
      FROM ODLN Oi LEFT OUTER JOIN NNM1 nm ON Oi."Series" = nm."Series" 
      LEFT OUTER JOIN OCRN ON Oi."DocCur" = OCRN."CurrCode" 
      INNER JOIN DLN8 iv8 ON Oi."DocEntry" = iv8."DocEntry" 
      LEFT OUTER JOIN (SELECT DISTINCT OINV."Series", INV1."BaseType", OINV."DocEntry", OINV."DocNum" FROM OINV 
      INNER JOIN INV1 ON OINV."DocEntry" = INV1."DocEntry") AS inv1 ON oi."DocEntry" = inv1."DocEntry" AND inv1."BaseType" = 15 
      
      LEFT OUTER JOIN NNM1 ivnm ON ivnm."Series" = inv1."Series" 
      INNER JOIN DLN7 iv7 ON iv7."DocEntry" = oi."DocEntry" AND iv7."PackageNum" = iv8."PackageNum" 
      LEFT OUTER JOIN OITM ot ON iv8."ItemCode" = ot."ItemCode" 
      LEFT OUTER JOIN OWGT t2 ON ot."SWght1Unit" = t2."UnitCode" 
      LEFT OUTER JOIN DLN12 ON Oi."DocEntry" = DLN12."DocEntry" 
      LEFT OUTER JOIN (SELECT "CardCode", "Address", "TaxId0", "TaxId1", "TaxId2", "TaxId3", "TaxId4", "TaxId5", "TaxId6", 
      "TaxId7", "TaxId8", "TaxId9", "CNAEId", "TaxId10", "TaxId11", "AddrType", "ECCNo", "CERegNo", "CERange", "CEDivis", 
      "CEComRate", "LogInstanc", "SefazDate", "TaxId12", "TaxId13" 
      FROM CRD7 CRD7_1 WHERE ("AddrType" = 'S')) AS Crd7 ON Oi."CardCode" = Crd7."CardCode" AND Oi."ShipToCode" = Crd7."Address" 
      LEFT OUTER JOIN OCRD Oc ON Oi."CardCode" = Oc."CardCode" WHERE Oi."ObjType" = 15;


GO


