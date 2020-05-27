IF NOT EXISTS (SELECT SCHEMA_ID FROM sys.schemas WHERE [name] = 'nifi')
BEGIN
	EXEC('CREATE SCHEMA [nifi]')
END
GO

IF OBJECT_ID(N'devlebsqldwdb.nifi.STATE') IS NOT NULL DROP TABLE [nifi].[STATE]

/*
The only table required for Nifi metadata & orchestration. Only Nifi will read & update it
[DATABASE_NAME] - is required for choosing DBCP Connection Pool for querying data and for building ingestion path to ADLS
[TABLE_NAME] - is required for querying source systems
[DATABASE_NAME].[TABLE_NAME] should be equal to [audit].[JOB_LOG].[JOB_NAME] column
[INGESTION_TYPE] - enum, can be FULL_SNAPSHOT, INCREMENTAL_TIMESTAMP, INCREMENTAL_VALUE
[INCREMENTAL_COLUMN_NAME] - column name by which the daily/hourly incremental load will happen
[PARTITION_COLUMN_NAME] - column by which to partition historical ingestion for number-based incremental tables
[WATERMARK] - max ingested value of [INCREMENTAL_COLUMN_NAME]
[PROCESSED_DATE] - max datetime when ingestion happened for particular table
*/
CREATE TABLE [nifi].[STATE]
(
    [ID] [smallint] NOT NULL,
    [DATABASE_NAME] [varchar](64) NOT NULL,
    [TABLE_NAME] [varchar](124) NOT NULL,
    [INGESTION_TYPE] [varchar](32) NOT NULL,
    [INCREMENTAL_COLUMN_NAME] [varchar](124) NULL,
    [PARTITION_COLUMN_NAME] [varchar](124) NULL,
    [WATERMARK] [bigint] NULL,
    [PROCESSED_DATE] [varchar](32) NULL
)
GO


-- AX
INSERT INTO [nifi].[STATE] VALUES (1, 'AX', 'BOM', 'FULL_SNAPSHOT', NULL, NULL, NULL, '2020-05-24')
INSERT INTO [nifi].[STATE] VALUES (2, 'AX', 'BOMVERSION', 'FULL_SNAPSHOT', NULL, NULL, NULL, '2020-05-24')
INSERT INTO [nifi].[STATE] VALUES (3, 'AX', 'CustInvoiceTable', 'INCREMENTAL_TIMESTAMP', 'MODIFIEDDATETIME', NULL, NULL, '2020-05-24')
INSERT INTO [nifi].[STATE] VALUES (4, 'AX', 'CustInvoiceJour', 'INCREMENTAL_VALUE', 'RECID', NULL, 5645142000, '2020-05-24')
-- CRM
INSERT INTO [nifi].[STATE] VALUES (5, 'CRM', 'product', 'FULL_SNAPSHOT', NULL, NULL, NULL, '2020-05-24')
GO



CREATE SCHEMA [audit]
GO

IF OBJECT_ID(N'devlebsqldwdb.audit.AUDIT_ON_START') IS NOT NULL DROP PROCEDURE [audit].[AUDIT_ON_START]
GO

IF OBJECT_ID(N'devlebsqldwdb.audit.AUDIT_ON_COMPLETE') IS NOT NULL DROP PROCEDURE [audit].[AUDIT_ON_COMPLETE]
GO

IF OBJECT_ID(N'devlebsqldwdb.audit.AUDIT_ON_FAIL') IS NOT NULL DROP PROCEDURE [audit].[AUDIT_ON_FAIL]
GO

CREATE PROCEDURE [audit].[AUDIT_ON_START]
	@job_name AS varchar(200),
	@country_code AS varchar(10),
	@job_log_id AS varchar(50),
    @job_processlog_id AS varchar(50),
    @etl_user AS varchar(50)
AS
BEGIN
	SELECT * FROM [nifi].[STATE]
END
GO


CREATE PROCEDURE [audit].[AUDIT_ON_COMPLETE]
	@job_name AS varchar(200),
	@country_code AS varchar(10),
	@job_log_id AS varchar(50),
	@job_processlog_id AS varchar(50)
AS
BEGIN
	SELECT * FROM [nifi].[STATE]
END
GO

CREATE PROCEDURE [audit].[AUDIT_ON_FAIL]
	@job_name AS varchar(200),
	@country_code AS varchar(10),
	@job_log_id AS varchar(50),
	@job_processlog_id AS varchar(50),
    @error_desc AS varchar(max)
AS
BEGIN
    SELECT * FROM [nifi].[STATE]
END
GO
