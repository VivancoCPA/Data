USE [ONL_MX_TRAFIGURA]
GO
/****** Object:  ONLIMS StoredProcedure [dbo].[QS_Reception_ContractChange]    Script Date: 24/01/2025 20:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[QS_Reception_ContractChange]
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

SELECT distinct i.WHSE_ID,
      [CreatedDate]
      ,[OLValue]
      ,[WMSValue]
	  ,[WMSType]
	 ,JobId
	 , Reference
	-- c.ClientId
	---,c.Name
  FROM [ONL_MX_TRAFIGURA].[dbo].[TFG_WMS_AUDIT] a, 
	[ONL_MX_TRAFIGURA].[dbo].[OL_HEAD] J,  
	[ONL_MX_TRAFIGURA].[dbo].[OLT_CLIENT] c,
	[ONL_MX_TRAFIGURA].[dbo].[OL_SAMPLE] s,
	[ONL_MX_TRAFIGURA].[dbo].[TFG_DL_INBOUND] i
  where a.WMSValue is not null
  and isnull(a.Archived,0) =0 --no se incluyen Archivados
  and a.auditType='ContractNumber' --solo assigments
  and a.JobCode = J.JobCode
  and j.JobType IN (0, 1)
  and j.ClientCode = c.ClientCode
  and c.ClientId in (2, 4 )---TRAFMEX y TRFPTE
  and s.JobCode = j.JobCode
  and  i.TRKNUM = s.SampleId
  and i.TRNTYP <> 'D' --no Eliminados.
  and [WMSValue] <>'' --pendientes de realocar
  and [WMSValue] <> [OLValue] -- cuando el cambio surge por reference
  and [CreatedDate] between @idIniDate and @idFinDate


END
