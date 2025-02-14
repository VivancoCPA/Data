USE [ONL_MX_TRAFIGURA]
GO
/****** Object:  ONLIMS StoredProcedure [dbo].[QS_Dispatch_Trucks]    Script Date: 24/01/2025 20:13:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
SET @IdTruckDate = DATEADD(DAY,-1,DATEADD (MONTH  , 0 , @IdCurrent )) --testing purpose -6 instead of ZEro
SET @idIniDate = CONVERT(varchar,@IdTruckDate,112)
SET @idFinDate = CONVERT(varchar,DATEADD (day , 1 , @IdTruckDate ),112)

SELECT      	@as_WHID as [WHSE_ID],
		S.SampleId, 
		H.Reference AS [Lot_Number], 
		E.ProductId AS Commodity, 
		L.WMT as NetWeight,
		s.SampleTm AS LeaveDate, 
		D.QualityId AS Quality, 
		B.ContractNumber
FROM            dbo.OL_HEAD AS H INNER JOIN
                         dbo.OL_SAMPLE AS S ON S.JobCode = H.JobCode INNER JOIN
                         dbo.OL_TEST AS T ON T.JobCode = H.JobCode INNER JOIN
                         dbo.OL_RESULTS AS R ON R.JobCode = H.JobCode AND R.TestCode = T.TestCode AND R.SampleCode = S.SampleCode LEFT OUTER JOIN
                         dbo.OLT_CLIENT AS C ON C.ClientCode = H.ClientCode LEFT OUTER JOIN
                         dbo.TFG_JOB_HEAD AS B ON B.JobCode = S.JobCode LEFT OUTER JOIN
                         dbo.TFG_LT_QUALITY AS D ON D.QualityCode = B.QualityCode LEFT OUTER JOIN
                         dbo.TFG_LT_PRODUCT AS E ON E.ProductCode = B.ProductCode LEFT OUTER JOIN
                         --dbo.TFG_DL_INBOUND AS F ON F.TRKNUM = S.SampleId LEFT OUTER JOIN
			 dbo.TFG_DL_OUTBOUND AS L ON L.OUTBOUND_SHIPMENT = S.SampleId LEFT OUTER JOIN
                         dbo.TFG_LT_ANALYSIS_BASIS AS G ON G.AnalysisBasisCode = B.AnalysisBasisCode LEFT OUTER JOIN
                         dbo.OLT_AREA AS A ON A.AreaCode = H.AreaCode
WHERE       (A.AreaId IS NOT NULL) AND (H.JobType IN (0, 1)) AND (T.Valid = 1)
and s.SampleTm  between @idIniDate and @idFinDate
and l.CLIENT_ID is not null
and L.WMT is not null --- Pesos NETo

End