USE [TruckWeigh]
GO
/****** Object: SCALE StoredProcedure [dbo].[QS_Reception_Trucks]    Script Date: 24/01/2025 20:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QS_Reception_Trucks]
@as_WHID VARCHAR(5)
as
DECLARE @IdCurrent DATE
DECLARE @IdTruckDate DATE
DECLARE @idIniDate DATE
DECLARE @idFinDate DATE
DECLARE @TimeZone INT = -300
Begin

if @as_WHID = 'IMX' 
	set  @TimeZone = -400

SET @IdCurrent =  DATEADD(MINUTE,@TimeZone, GETUTCDATE())
SET @IdTruckDate = DATEADD(DAY,-1,DATEADD (MONTH  , 0 , @IdCurrent )) --testing purpose -6 instead of ZEro
SET @idIniDate = CONVERT(varchar,@IdTruckDate,112)
SET @idFinDate = CONVERT(varchar,DATEADD (day , 1 , @IdTruckDate ),112)

SELECT [WarehouseCode] as Warehouse
,[IDINBOUND]
,x.PO_NUM as Supplier_waybill
,[LotNumber] as Lot_number
,[ClientCode] as Client_Code
 ,NumberGuideWaybill as Waybill
 ,[SupplierNumber] as Supplier
  ,[ItemNumber] as Product
   ,[Quality]
  ,[NetWeight] as Net_Weight
, DATEADD(MINUTE,-300, [OutputDate]) as Leaving_date
  FROM [Weighing] w, [UC_MASTER_RECEIPT_FWD] x
  where [WarehouseCode] = @as_WHID
  and w.IDINBOUND = x.TRKNUM
 and DATEADD(MINUTE,-300, [OutputDate]) between @idIniDate and @idFinDate
 and w.DeletedFlag = 0
END