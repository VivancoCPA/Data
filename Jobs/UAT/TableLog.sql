USE [TruckWeigh]
GO
CREATE TABLE [dbo].[ExportCvsLog] (
    idLog int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    idCompanyCode varchar(5),
	TypeFile varchar(2) NOT NULL,
    FileName varchar(255),
    UpdateDate datetime
)
GO
USE [ONL_PE_TRAFIGURA]
GO
CREATE TABLE [dbo].[ExportCvsLog] (
    idLog int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    idCompanyCode varchar(5),
	TypeFile varchar(2) NOT NULL,
    FileName varchar(255),
    UpdateDate datetime
)
GO
USE [ONL_MX_TRAFIGURA]
GO
CREATE TABLE [dbo].[ExportCvsLog] (
    idLog int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    idCompanyCode varchar(5),
	TypeFile varchar(2) NOT NULL,
    FileName varchar(255),
    UpdateDate datetime
)

GO
USE [ONL_CL_TRAFIGURA]
GO
CREATE TABLE [dbo].[ExportCvsLog] (
    idLog int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
    idCompanyCode varchar(5),
	TypeFile varchar(2) NOT NULL,
    FileName varchar(255),
    UpdateDate datetime
)

GO

