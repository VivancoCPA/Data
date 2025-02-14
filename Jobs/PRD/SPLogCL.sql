USE [ONL_PE_TRAFIGURA]
GO
/****** Object:  StoredProcedure [dbo].[QS_AuditLogExportFile]    Script Date: 08/02/2025 21:16:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QS_AuditLogExportFile]
@as_WHID VARCHAR(5),
@IdType VARCHAR(2),
@FileName VARCHAR(255)
AS
DECLARE @TimeZone INT = -300
DECLARE @Error varchar(MAX) 
BEGIN TRAN
BEGIN TRY
	SET @Error = ''

	if @as_WHID = 'IMX' 
		set  @TimeZone = -360

	BEGIN
		SET NOCOUNT ON
		SET NOCOUNT OFF
	
		INSERT INTO ExportCvsLog(idCompanyCode, TypeFile, FileName, UpdateDate)
		VALUES (@as_WHID, @IdType, @FileName,   DATEADD(MINUTE,@TimeZone, GETUTCDATE()))
		
	END
	
    BEGIN
        COMMIT TRAN
    END

END TRY
BEGIN CATCH
    ROLLBACK TRAN
    SET @Error = CONCAT('Línea N°', ERROR_LINE(), ': ', ERROR_MESSAGE())
END CATCH
