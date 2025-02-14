USE [TruckWeigh]
GO
CREATE PROCEDURE [dbo].[QS_Dispatch_Trucks]
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
SET @IdTruckDate = DATEADD(DAY,-1,DATEADD (MONTH  , -6 , @IdCurrent )) --testing purpose -6 instead of ZEro
SET @idIniDate = CONVERT(varchar,@IdTruckDate,112)
SET @idFinDate = CONVERT(varchar,DATEADD (day , 1 , @IdTruckDate ),112)

SELECT  [WarehouseCode] as Warehouse,
      [TruckId] as oo_Truck_id
,[IDOUTBOUND] as Outbound
,[ClientCode] as Client_Code
,Lot as Lot_Dispatch
 ,[GuideNumber] as Waybill
  ,[ItemNumber] as Product
   ,[Quality]
,[NetWeight] as Net_Weight,
DATEADD(MINUTE,-300, [OutputDate]) as Leaving_date
  FROM [dbo].[Weighing] w,[dbo].[UC_PICK_TO_SCALE] d
  where WarehouseCode =@as_WHID
  and DATEADD(MINUTE,-300, [OutputDate]) between @idIniDate  and @idFinDate
  and w.[IDOUTBOUND] = d.ORDNUM
  ---and [OutputDate] is not null
  and w.DeletedFlag = 0
END

  