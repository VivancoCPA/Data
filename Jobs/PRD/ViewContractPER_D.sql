USE [ONL_PE_TRAFIGURA]
GO
/****** Object:  ONLIMS StoredProcedure [dbo].[QS_Dispatch_ContractChange]    Script Date: 24/01/2025 20:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QS_Dispatch_ContractChange]
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
SET @IdTruckDate = DATEADD(DAY,-1,DATEADD (MONTH  , 0 , @IdCurrent )) --testing purpose -6 isnted of CERO
SET @idIniDate = CONVERT(varchar,@IdTruckDate,112)
SET @idFinDate = CONVERT(varchar,DATEADD (day , 1 , @IdTruckDate ),112)

SET @idIniDate = dateadd(day,-7,dateadd(week, datediff(week, 0, @idFinDate), 0)) --truncar a inicio smeana
SET @idFinDate =  dateadd(week, datediff(week, 0, @idFinDate), 0) --truncar a fin smeana

  SELECT distinct @as_WHID as WHSE_ID,
      [CreatedDate]
      ,[OLValue]
      ,[WMSValue]
	  ,[WMSType]
	 ,JobId
	 , Reference
	 --c.ClientId
	--,c.Name
  FROM [ONL_PE_TRAFIGURA].[dbo].[TFG_WMS_AUDIT] a, 
	[ONL_PE_TRAFIGURA].[dbo].[OL_HEAD] J,  
	[ONL_PE_TRAFIGURA].[dbo].[OLT_CLIENT] c,
	[ONL_PE_TRAFIGURA].[dbo].[OL_SAMPLE] s,
	[ONL_PE_TRAFIGURA].[dbo].[TFG_DL_OUTBOUND] o
  where a.WMSValue is not null
  and isnull(a.Archived,0) =0 --no se incluyen Archivados
  and a.auditType='ContractNumber' --solo assigments
  and a.JobCode = J.JobCode
  and j.JobType IN (0, 1)
  and j.ClientCode = c.ClientCode
  and c.ClientId in (19 )---TRAFPERU
  and s.JobCode = j.JobCode
  and  o.OUTBOUND_SHIPMENT = s.SampleId 
  and o.TRNTYP <> 'D' --no Eliminados.
  and [WMSValue] <>'' --pendientes de realocar
  and [WMSValue] <> [OLValue] -- cuando el cambio surge por reference
  and [CreatedDate] between @idIniDate and @idFinDate
END