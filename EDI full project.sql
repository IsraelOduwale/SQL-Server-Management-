-- =============================================
-- Author:		Israel Oduwale
-- Create date: 12-18-2025
-- Description:	This code is to create and run analysis on the tables in the EDi full Project
-- Revise Date: 12-18-2025
-- Version:		v2.0
-- =============================================


--Enterprise Encounter & EDI Operations Dashboard
-- Folder path:C:\Users\sunka\Documents\Emade Consulting IT Training\Enterprise Encounter & EDI Operations Dashboard

--Create dev database & schemas
-- Create DEV database
IF DB_ID('Emade_EDI_Dev') IS NULL
    CREATE DATABASE Emade_EDI_Dev;
GO

USE Emade_EDI_Dev;
GO

-- Create schemas if they don't exist
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'EDIFECSProcess')
    EXEC('CREATE SCHEMA EDIFECSProcess');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'MedEx')
    EXEC('CREATE SCHEMA MedEx');
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'CMS')
    EXEC('CREATE SCHEMA CMS');
GO

--Create source tables
--2.1 EDIFECS inbound / outbound (we’ll reuse structure)
USE Emade_EDI_Dev;
GO

IF OBJECT_ID('EDIFECSProcess.EDIFECSFileControlMaster','U') IS NOT NULL
    DROP TABLE EDIFECSProcess.EDIFECSFileControlMaster;
GO

CREATE TABLE EDIFECSProcess.EDIFECSFileControlMaster
(
      EDIFECSFileControlMasterKey INT IDENTITY(1,1) PRIMARY KEY
    , OriginalFileName            VARCHAR(200)   NOT NULL
    , FileID                      VARCHAR(100)   NOT NULL
    , TradingPartnerId            INT            NOT NULL
    , TradingPartnerShortName     VARCHAR(100)   NOT NULL
    , FileType                    VARCHAR(20)    NOT NULL     -- 837I, 837P, etc.
    , Direction                   CHAR(3)        NOT NULL     -- 'IN' or 'OUT'
    , EDIFECSStatus               VARCHAR(50)    NOT NULL     -- Successful, Error, etc.
    , EDIFECSStartDateTime        DATETIME2(0)   NOT NULL
    , EDIFECSEndDateTime          DATETIME2(0)   NULL
    , InsertedTimeStamp           DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME()
    , OutboundDataStagingStatus   VARCHAR(50)    NULL
    , OutboundDataStagingStartTime DATETIME2(0)  NULL
    , OutboundStagingEndTime      DATETIME2(0)   NULL
    , OutboundEDIFECSFileID       VARCHAR(100)   NULL
    , DHCSFileName                VARCHAR(200)   NULL
    , StagingLoadStatus           VARCHAR(50)    NULL
);
GO


IF OBJECT_ID('MedEx.EDIFECSFileControlMaster','U') IS NOT NULL
    DROP TABLE MedEx.EDIFECSFileControlMaster;
GO

CREATE TABLE MedEx.EDIFECSFileControlMaster
(
      EDIFECSFileControlMasterKey INT IDENTITY(1,1) PRIMARY KEY
    , OriginalFileName            VARCHAR(200)   NOT NULL
    , FileID                      VARCHAR(100)   NOT NULL
    , TradingPartnerId            INT            NOT NULL
    , TradingPartnerShortName     VARCHAR(100)   NOT NULL
    , FileType                    VARCHAR(20)    NOT NULL
    , Direction                   CHAR(3)        NOT NULL
    , EDIFECSStatus               VARCHAR(50)    NOT NULL
    , EDIFECSStartDateTime        DATETIME2(0)   NOT NULL
    , EDIFECSEndDateTime          DATETIME2(0)   NULL
    , InsertedTimeStamp           DATETIME2(0)   NOT NULL DEFAULT SYSUTCDATETIME()
    , OutboundDataStagingStatus   VARCHAR(50)    NULL
    , OutboundDataStagingStartTime DATETIME2(0)  NULL
    , OutboundStagingEndTime      DATETIME2(0)   NULL
    , OutboundEDIFECSFileID       VARCHAR(100)   NULL
    , DHCSFileName                VARCHAR(200)   NULL
    , StagingLoadStatus           VARCHAR(50)    NULL
);
GO

--2.2 Trigger tables (CMS & MedEx)
IF OBJECT_ID('CMS.TriggerFileHolder','U') IS NOT NULL
    DROP TABLE CMS.TriggerFileHolder;
GO

CREATE TABLE CMS.TriggerFileHolder
(
      TriggerFileHolderKey    INT IDENTITY(1,1) PRIMARY KEY
    , FileType                VARCHAR(20)    NOT NULL
    , FileID                  VARCHAR(100)   NOT NULL
    , InsertedTimeStamp       DATETIME2(0)   NOT NULL
    , DeletedFlag             BIT            NOT NULL DEFAULT 0
    , FileIDUsedStatus        VARCHAR(10)    NULL         -- NULL = not reconciled, 'Y' = reconciled
    , TradingPartnerID        INT            NOT NULL
    , TradingPartnerShortName VARCHAR(100)   NOT NULL
    , TriggerCreatedTimeStamp DATETIME2(0)   NULL         -- NULL = not sent to EDIFECS
);
GO

IF OBJECT_ID('MedEx.TriggerFileHolder','U') IS NOT NULL
    DROP TABLE MedEx.TriggerFileHolder;
GO

CREATE TABLE MedEx.TriggerFileHolder
(
      TriggerFileHolderKey    INT IDENTITY(1,1) PRIMARY KEY
    , FileType                VARCHAR(20)    NOT NULL
    , FileID                  VARCHAR(100)   NOT NULL
    , InsertedTimeStamp       DATETIME2(0)   NOT NULL
    , DeletedFlag             BIT            NOT NULL DEFAULT 0
    , FileIDUsedStatus        VARCHAR(10)    NULL
    , TradingPartnerID        INT            NOT NULL
    , TradingPartnerShortName VARCHAR(100)   NOT NULL
    , TriggerCreatedTimeStamp DATETIME2(0)   NULL
);
GO

--3.1 Inbound sample rows (EDIFECSProcess)
USE Emade_EDI_Dev;
GO

-- Inbound files (EDIFECSProcess)
TRUNCATE TABLE EDIFECSProcess.EDIFECSFileControlMaster;

INSERT INTO EDIFECSProcess.EDIFECSFileControlMaster
(
  OriginalFileName, FileID, TradingPartnerId, TradingPartnerShortName,
  FileType, Direction, EDIFECSStatus,
  EDIFECSStartDateTime, EDIFECSEndDateTime
)
VALUES
('TP1_837I_20250101.dat', 'IN001', 1, 'Partner One', '837I', 'IN', 'Successful',
 '2025-01-01T08:00:00', '2025-01-01T08:12:00'),  -- 12 min (<=30)
('TP1_837I_20250101_err.dat', 'IN002', 1, 'Partner One', '837I', 'IN', 'Error',
 '2025-01-01T09:00:00', '2025-01-01T09:45:00'),  -- 45 min (>30, <=60)
('TP2_837P_20250102.dat', 'IN003', 2, 'Partner Two', '837P', 'IN', 'Successful',
 '2025-01-02T07:30:00', '2025-01-02T08:50:00'),  -- 80 min (>60)
('TP3_837I_20250103.dat', 'IN004', 3, 'Partner Three', '837I', 'IN', 'Successful',
 '2025-01-03T10:00:00', NULL);                    -- in progress (no end)
GO


--3.2 Outbound sample rows (MedEx)
TRUNCATE TABLE MedEx.EDIFECSFileControlMaster;

INSERT INTO MedEx.EDIFECSFileControlMaster
(
  OriginalFileName, FileID, TradingPartnerId, TradingPartnerShortName,
  FileType, Direction, EDIFECSStatus,
  EDIFECSStartDateTime, EDIFECSEndDateTime,
  OutboundDataStagingStatus, OutboundDataStagingStartTime, OutboundStagingEndTime,
  OutboundEDIFECSFileID, DHCSFileName, StagingLoadStatus
)
VALUES
('TP1_837I_OUT_20250101.dat', 'OUT001', 1, 'Partner One', '837I', 'OUT', 'Successful',
 '2025-01-01T11:00:00', '2025-01-01T11:20:00',
 'Completed', '2025-01-01T10:45:00', '2025-01-01T10:55:00',
 'OEDF001', 'DHCS_TP1_20250101.txt', 'Success'),
('TP2_837P_OUT_20250101.dat', 'OUT002', 2, 'Partner Two', '837P', 'OUT', 'Successful',
 '2025-01-01T12:00:00', '2025-01-01T13:30:00',
 'Completed', '2025-01-01T11:30:00', '2025-01-01T12:10:00',
 'OEDF002', 'DHCS_TP2_20250101.txt', 'Success'),
('TP3_837I_OUT_20250102.dat', 'OUT003', 3, 'Partner Three', '837I', 'OUT', 'Error',
 '2025-01-02T09:00:00', NULL,
 'In Progress', '2025-01-02T08:30:00', NULL,
 'OEDF003', 'DHCS_TP3_20250102.txt', 'InProgress');
GO

--3.3 Trigger sample rows (CMS & MedEx)
TRUNCATE TABLE CMS.TriggerFileHolder;
TRUNCATE TABLE MedEx.TriggerFileHolder;

-- CMS triggers
INSERT INTO CMS.TriggerFileHolder
(
 FileType, FileID, InsertedTimeStamp, DeletedFlag,
 FileIDUsedStatus, TradingPartnerID, TradingPartnerShortName,
 TriggerCreatedTimeStamp
)
VALUES
('837I', 'TRG001', '2025-01-01T07:50:00', 0, 'Y', 1, 'Partner One', '2025-01-01T07:55:00'),  -- Reconciled
('837I', 'TRG002', '2025-01-01T08:10:00', 0, NULL, 1, 'Partner One', '2025-01-01T08:20:00'), -- Sent – Not Reconciled
('837P', 'TRG003', '2025-01-02T09:00:00', 0, NULL, 2, 'Partner Two', NULL);                 -- Not Sent

-- MedEx triggers
INSERT INTO MedEx.TriggerFileHolder
(
 FileType, FileID, InsertedTimeStamp, DeletedFlag,
 FileIDUsedStatus, TradingPartnerID, TradingPartnerShortName,
 TriggerCreatedTimeStamp
)
VALUES
('837I', 'TRG101', '2025-01-01T06:50:00', 0, 'Y', 1, 'Partner One', '2025-01-01T06:55:00'),
('837P', 'TRG102', '2025-01-03T10:00:00', 0, NULL, 3, 'Partner Three', '2025-01-03T10:05:00');
GO


IF OBJECT_ID('dbo.vw_EDIFECS_InboundFiles','V') IS NOT NULL
    DROP VIEW dbo.vw_EDIFECS_InboundFiles;
GO

--4.1 Inbound view
CREATE VIEW dbo.vw_EDIFECS_InboundFiles
AS
SELECT
      E.EDIFECSFileControlMasterKey      AS FileControlKey
    , E.OriginalFileName
    , E.FileID
    , E.TradingPartnerId
    , E.TradingPartnerShortName
    , E.FileType
    , E.Direction
    , E.EDIFECSStatus
    , E.EDIFECSStartDateTime
    , E.EDIFECSEndDateTime
    , CAST(E.EDIFECSStartDateTime AS date) AS StartDate
    , CAST(E.EDIFECSEndDateTime   AS date) AS EndDate
    , E.InsertedTimeStamp

    , DATEDIFF(MINUTE, E.EDIFECSStartDateTime,
               ISNULL(E.EDIFECSEndDateTime, SYSUTCDATETIME())) AS MinutesDur
    , DATEDIFF(SECOND, E.EDIFECSStartDateTime,
               ISNULL(E.EDIFECSEndDateTime, SYSUTCDATETIME())) AS SecondsDur

    , CASE
          WHEN DATEDIFF(MINUTE, E.EDIFECSStartDateTime,
                        ISNULL(E.EDIFECSEndDateTime, SYSUTCDATETIME())) <= 30
              THEN N'? 30 min'
          WHEN DATEDIFF(MINUTE, E.EDIFECSStartDateTime,
                        ISNULL(E.EDIFECSEndDateTime, SYSUTCDATETIME())) <= 60
              THEN N'31–60 min'
          ELSE N'> 60 min'
      END AS SLABand30_60
FROM EDIFECSProcess.EDIFECSFileControlMaster E
WHERE E.Direction = 'IN';
GO


IF OBJECT_ID('dbo.vw_EDIFECS_OutboundFiles','V') IS NOT NULL
    DROP VIEW dbo.vw_EDIFECS_OutboundFiles;
GO

--4.2 Outbound view
CREATE VIEW dbo.vw_EDIFECS_OutboundFiles
AS
SELECT
      E.EDIFECSFileControlMasterKey      AS FileControlKey
    , E.OriginalFileName
    , E.FileID
    , E.TradingPartnerId
    , E.TradingPartnerShortName
    , E.FileType
    , E.Direction
    , E.EDIFECSStatus
    , E.EDIFECSStartDateTime
    , E.EDIFECSEndDateTime
    , CAST(E.EDIFECSStartDateTime AS date) AS StartDate
    , CAST(E.EDIFECSEndDateTime   AS date) AS EndDate

    , E.OutboundDataStagingStatus
    , E.OutboundDataStagingStartTime
    , E.OutboundStagingEndTime
    , E.OutboundEDIFECSFileID
    , E.DHCSFileName
    , E.InsertedTimeStamp
    , E.StagingLoadStatus

    , DATEDIFF(MINUTE, E.EDIFECSStartDateTime,
               ISNULL(E.EDIFECSEndDateTime, SYSUTCDATETIME())) AS MinutesDur
    , DATEDIFF(SECOND, E.EDIFECSStartDateTime,
               ISNULL(E.EDIFECSEndDateTime, SYSUTCDATETIME())) AS SecondsDur

    , CASE
          WHEN E.OutboundDataStagingStartTime IS NOT NULL
           AND E.OutboundStagingEndTime      IS NOT NULL
          THEN DATEDIFF(
                   MINUTE,
                   E.OutboundDataStagingStartTime,
                   E.OutboundStagingEndTime
               )
          ELSE NULL
      END AS StagingMinutesDur

    , CASE
          WHEN DATEDIFF(MINUTE, E.EDIFECSStartDateTime,
                        ISNULL(E.EDIFECSEndDateTime, SYSUTCDATETIME())) <= 30
              THEN N'? 30 min'
          WHEN DATEDIFF(MINUTE, E.EDIFECSStartDateTime,
                        ISNULL(E.EDIFECSEndDateTime, SYSUTCDATETIME())) <= 60
              THEN N'31–60 min'
          ELSE N'> 60 min'
      END AS SLABand30_60
FROM MedEx.EDIFECSFileControlMaster E
WHERE E.Direction = 'OUT';
GO

--4.3 Trigger views (CMS & MedEx + combined)
IF OBJECT_ID('dbo.vw_TriggerFiles_CMS','V') IS NOT NULL
    DROP VIEW dbo.vw_TriggerFiles_CMS;
GO

CREATE VIEW dbo.vw_TriggerFiles_CMS
AS
SELECT
      T.FileType
    , T.FileID
    , T.InsertedTimeStamp
    , CAST(T.InsertedTimeStamp AS date) AS InsertedDate
    , T.DeletedFlag
    , T.FileIDUsedStatus
    , T.TradingPartnerID
    , T.TradingPartnerShortName
    , T.TriggerCreatedTimeStamp
    , 'CMS' AS SourceSystem
    , CASE
          WHEN T.TriggerCreatedTimeStamp IS NULL
              THEN 'Not Sent to EDIFECS'
          WHEN T.FileIDUsedStatus IS NULL
               AND T.TriggerCreatedTimeStamp IS NOT NULL
              THEN 'Sent – Not Reconciled'
          ELSE 'Reconciled'
      END AS TriggerStatus
FROM CMS.TriggerFileHolder T;
GO

IF OBJECT_ID('dbo.vw_TriggerFiles_MedEx','V') IS NOT NULL
    DROP VIEW dbo.vw_TriggerFiles_MedEx;
GO

CREATE VIEW dbo.vw_TriggerFiles_MedEx
AS
SELECT
      T.FileType
    , T.FileID
    , T.InsertedTimeStamp
    , CAST(T.InsertedTimeStamp AS date) AS InsertedDate
    , T.DeletedFlag
    , T.FileIDUsedStatus
    , T.TradingPartnerID
    , T.TradingPartnerShortName
    , T.TriggerCreatedTimeStamp
    , 'MedEx' AS SourceSystem
    , CASE
          WHEN T.TriggerCreatedTimeStamp IS NULL
              THEN 'Not Sent to EDIFECS'
          WHEN T.FileIDUsedStatus IS NULL
               AND T.TriggerCreatedTimeStamp IS NOT NULL
              THEN 'Sent – Not Reconciled'
          ELSE 'Reconciled'
      END AS TriggerStatus
FROM MedEx.TriggerFileHolder T;
GO

-- Optional combined view for Power BI
IF OBJECT_ID('dbo.vw_TriggerFiles_All','V') IS NOT NULL
    DROP VIEW dbo.vw_TriggerFiles_All;
GO

CREATE VIEW dbo.vw_TriggerFiles_All
AS
SELECT * FROM dbo.vw_TriggerFiles_CMS
UNION ALL
SELECT * FROM dbo.vw_TriggerFiles_MedEx;
GO

--(Optional) Date dimension for dev
IF OBJECT_ID('dbo.DimDate','U') IS NOT NULL
    DROP TABLE dbo.DimDate;
GO

CREATE TABLE dbo.DimDate
(
    DateKey      INT        NOT NULL PRIMARY KEY,
    [Date]       DATE       NOT NULL,
    [Year]       INT        NOT NULL,
    [Month]      TINYINT    NOT NULL,
    MonthName    VARCHAR(20) NOT NULL,
    YearMonth    CHAR(7)    NOT NULL
);
GO

DECLARE @d DATE = '2025-01-01';
WHILE @d <= '2025-01-31'
BEGIN
    INSERT INTO dbo.DimDate (DateKey, [Date], [Year], [Month], MonthName, YearMonth)
    VALUES (CONVERT(INT, FORMAT(@d,'yyyyMMdd')), @d, YEAR(@d), MONTH(@d), DATENAME(MONTH,@d), FORMAT(@d,'yyyy-MM'));
    SET @d = DATEADD(DAY, 1, @d);
END;
GO

/**
You can point Power BI to Emade_EDI_Dev

Use the views:
dbo.vw_EDIFECS_InboundFiles
dbo.vw_EDIFECS_OutboundFiles
dbo.vw_TriggerFiles_All (or CMS/MedEx separately)
dbo.DimDate

1?? Power BI Model Spec (for Emade_EDI_Dev)
1. Tables to Import

From the Emade_EDI_Dev database:

Fact-style views

dbo.vw_EDIFECS_InboundFiles ? FactInbound

dbo.vw_EDIFECS_OutboundFiles ? FactOutbound

dbo.vw_TriggerFiles_All ? FactTrigger

Dimensions

dbo.DimDate ? DimDate

(Optional later) a DimTradingPartner view/table if you want a clean partner dimension

In Power BI, you can rename them to:

FactInbound, FactOutbound, FactTrigger, DimDate.

2. Relationships (Model view)

Create these relationships:

DimDate[Date] ? FactInbound[StartDate] (1-to-many, single direction)

DimDate[Date] ? FactOutbound[StartDate] (1-to-many, single direction)

DimDate[Date] ? FactTrigger[InsertedDate] (1-to-many, single direction)

If you add a partner dimension later:

DimTradingPartner[TradingPartnerId] ? FactInbound[TradingPartnerId]

DimTradingPartner[TradingPartnerId] ? FactOutbound[TradingPartnerId]

DimTradingPartner[TradingPartnerID] ? FactTrigger[TradingPartnerID]

Disable auto date/time in Power BI (Options ? Current File ? Data Load).
**/

/**
3. Core Measures to Define (in a “Measures” table)

You can create a dedicated Measures table:

Measures = DATATABLE("Name", STRING, {{"placeholder"}})


Then delete the placeholder column and start adding measures there.

3.1 Volume measures
Inbound Files Count :=
COUNTROWS ( FactInbound )

Outbound Files Count :=
COUNTROWS ( FactOutbound )

Trigger Files Count :=
COUNTROWS ( FactTrigger )

3.2 Success / Error
Inbound Successful Files :=
CALCULATE (
    [Inbound Files Count],
    FactInbound[EDIFECSStatus] = "Successful"
)

Inbound Error Files :=
[Inbound Files Count] - [Inbound Successful Files]

Outbound Successful Files :=
CALCULATE (
    [Outbound Files Count],
    FactOutbound[EDIFECSStatus] = "Successful"
)

Outbound Error Files :=
[Outbound Files Count] - [Outbound Successful Files]

3.3 Processing time & SLA
Avg Inbound Processing Minutes :=
AVERAGE ( FactInbound[MinutesDur] )

Avg Outbound Processing Minutes :=
AVERAGE ( FactOutbound[MinutesDur] )

Avg Outbound Staging Minutes :=
AVERAGE ( FactOutbound[StagingMinutesDur] )

Inbound ? 30 min :=
CALCULATE (
    [Inbound Files Count],
    FactInbound[MinutesDur] <= 30
)

Inbound ? 60 min :=
CALCULATE (
    [Inbound Files Count],
    FactInbound[MinutesDur] <= 60
)

Outbound ? 30 min :=
CALCULATE (
    [Outbound Files Count],
    FactOutbound[MinutesDur] <= 30
)

Outbound ? 60 min :=
CALCULATE (
    [Outbound Files Count],
    FactOutbound[MinutesDur] <= 60
)

Inbound SLA30 Compliance % :=
DIVIDE ( [Inbound ? 30 min], [Inbound Files Count] )

Inbound SLA60 Compliance % :=
DIVIDE ( [Inbound ? 60 min], [Inbound Files Count] )

Outbound SLA30 Compliance % :=
DIVIDE ( [Outbound ? 30 min], [Outbound Files Count] )

Outbound SLA60 Compliance % :=
DIVIDE ( [Outbound ? 60 min], [Outbound Files Count] )

Inbound Files In Progress :=
CALCULATE (
    [Inbound Files Count],
    ISBLANK ( FactInbound[EDIFECSEndDateTime] )
)

Outbound Files In Progress :=
CALCULATE (
    [Outbound Files Count],
    ISBLANK ( FactOutbound[EDIFECSEndDateTime] )
)

3.4 Trigger measures
Triggers Not Sent :=
CALCULATE (
    [Trigger Files Count],
    FactTrigger[TriggerStatus] = "Not Sent to EDIFECS"
)

Triggers Sent – Not Reconciled :=
CALCULATE (
    [Trigger Files Count],
    FactTrigger[TriggerStatus] = "Sent – Not Reconciled"
)

Triggers Reconciled :=
CALCULATE (
    [Trigger Files Count],
    FactTrigger[TriggerStatus] = "Reconciled"
)

Triggers Open (Not Sent or Not Reconciled) :=
[Triggers Not Sent] + [Triggers Sent – Not Reconciled]

Triggers Reconciled % :=
DIVIDE ( [Triggers Reconciled], [Trigger Files Count] )


**/

--Enterprise Encounter & EDI Operations Dashboard

/**
Expand Test Data (More Partners, More Edge Cases)

The current sample is good for a smoke test. Below is extra SQL to:

Add more partners (4 & 5)

Add more dates (multiple days)

Add explicit edge cases:

Many fast files (?30)

Many medium (31–60)

Many slow (>60)

Extra in-progress and error rows

More trigger patterns
**/
--2.1 Extra inbound test data


USE Emade_EDI_Dev;
GO

INSERT INTO EDIFECSProcess.EDIFECSFileControlMaster
(
  OriginalFileName, FileID, TradingPartnerId, TradingPartnerShortName,
  FileType, Direction, EDIFECSStatus,
  EDIFECSStartDateTime, EDIFECSEndDateTime
)
VALUES
-- Partner 4: mostly good, fast files
('TP4_837I_20250105_01.dat', 'IN101', 4, 'Partner Four', '837I', 'IN', 'Successful',
 '2025-01-05T08:00:00', '2025-01-05T08:10:00'), -- 10 min
('TP4_837I_20250105_02.dat', 'IN102', 4, 'Partner Four', '837I', 'IN', 'Successful',
 '2025-01-05T09:00:00', '2025-01-05T09:20:00'), -- 20 min
('TP4_837I_20250105_03.dat', 'IN103', 4, 'Partner Four', '837I', 'IN', 'Successful',
 '2025-01-05T09:30:00', '2025-01-05T09:55:00'), -- 25 min

-- Partner 5: mostly SLA >60 to show a bad partner
('TP5_837P_20250106_01.dat', 'IN201', 5, 'Partner Five', '837P', 'IN', 'Successful',
 '2025-01-06T10:00:00', '2025-01-06T11:30:00'), -- 90 min
('TP5_837P_20250106_02.dat', 'IN202', 5, 'Partner Five', '837P', 'IN', 'Error',
 '2025-01-06T11:00:00', '2025-01-06T12:20:00'), -- 80 min
('TP5_837P_20250106_03.dat', 'IN203', 5, 'Partner Five', '837P', 'IN', 'Successful',
 '2025-01-06T13:00:00', NULL), -- in progress
-- More Partner 2 data across multiple days
('TP2_837P_20250103.dat', 'IN301', 2, 'Partner Two', '837P', 'IN', 'Successful', '2025-01-03T07:00:00', '2025-01-03T07:40:00'), -- 40 min
('TP2_837P_20250104.dat', 'IN302', 2, 'Partner Two', '837P', 'IN', 'Successful', '2025-01-04T07:00:00', '2025-01-04T08:10:00'); -- 70 min
GO

--2.2 Extra outbound test data
INSERT INTO MedEx.EDIFECSFileControlMaster
(
  OriginalFileName, FileID, TradingPartnerId, TradingPartnerShortName,
  FileType, Direction, EDIFECSStatus,
  EDIFECSStartDateTime, EDIFECSEndDateTime,
  OutboundDataStagingStatus, OutboundDataStagingStartTime, OutboundStagingEndTime,
  OutboundEDIFECSFileID, DHCSFileName, StagingLoadStatus
)
VALUES
-- Partner 4: good SLA
('TP4_837I_OUT_20250105_01.dat', 'OUT101', 4, 'Partner Four', '837I', 'OUT', 'Successful',
 '2025-01-05T12:00:00', '2025-01-05T12:20:00',
 'Completed', '2025-01-05T11:30:00', '2025-01-05T11:45:00',
 'OEDF101', 'DHCS_TP4_20250105.txt', 'Success'),

-- Partner 5: slow staging and processing
('TP5_837P_OUT_20250106_01.dat', 'OUT201', 5, 'Partner Five', '837P', 'OUT', 'Successful',
 '2025-01-06T14:00:00', '2025-01-06T15:30:00',  -- 90 min
 'Completed', '2025-01-06T13:00:00', '2025-01-06T13:50:00', -- 50 min staging
 'OEDF201', 'DHCS_TP5_20250106.txt', 'Success'),

('TP5_837P_OUT_20250106_02.dat', 'OUT202', 5, 'Partner Five', '837P', 'OUT', 'Error',
 '2025-01-06T16:00:00', NULL,
 'In Progress', '2025-01-06T15:10:00', NULL,
 'OEDF202', 'DHCS_TP5_20250106_b.txt', 'InProgress');
GO

--2.3 Extra triggers (more combinations)
-- More CMS triggers
INSERT INTO CMS.TriggerFileHolder
(
 FileType, FileID, InsertedTimeStamp, DeletedFlag,
 FileIDUsedStatus, TradingPartnerID, TradingPartnerShortName,
 TriggerCreatedTimeStamp
)
VALUES
('837I', 'TRG004', '2025-01-05T07:40:00', 0, 'Y', 4, 'Partner Four', '2025-01-05T07:45:00'),
('837P', 'TRG005', '2025-01-06T09:50:00', 0, NULL, 5, 'Partner Five', '2025-01-06T10:20:00'),
('837P', 'TRG006', '2025-01-06T10:05:00', 0, NULL, 5, 'Partner Five', NULL);

-- More MedEx triggers
INSERT INTO MedEx.TriggerFileHolder
(
 FileType, FileID, InsertedTimeStamp, DeletedFlag,
 FileIDUsedStatus, TradingPartnerID, TradingPartnerShortName,
 TriggerCreatedTimeStamp
)
VALUES
('837I', 'TRG103', '2025-01-05T06:30:00', 0, 'Y', 4, 'Partner Four', '2025-01-05T06:35:00'),
('837P', 'TRG104', '2025-01-06T11:00:00', 0, NULL, 5, 'Partner Five', '2025-01-06T11:10:00');
GO

/**
More Synthetic Data Patterns (for Stress Testing)

If you want to simulate more volume and patterns without hand-coding every row, here’s a simple pattern generator.

**/
--2.1 Create a Numbers/Tally Table (DEV helper)
USE Emade_EDI_Dev;
GO

IF OBJECT_ID('dbo.Numbers','U') IS NOT NULL
    DROP TABLE dbo.Numbers;
GO

CREATE TABLE dbo.Numbers (N INT NOT NULL PRIMARY KEY);
WITH cte AS (
    SELECT 1 AS N
    UNION ALL
    SELECT N+1 FROM cte WHERE N < 500
)
INSERT INTO dbo.Numbers (N)
SELECT N FROM cte
OPTION (MAXRECURSION 500);
GO


/**
Now in Power BI DEV you’ll see:

A “good” partner (Partner Four) with mostly green SLA metrics.

A “problem” partner (Partner Five) with many >60 min and error cases.

Mixed status triggers across Not Sent, Sent – Not Reconciled, Reconciled.

Enough dates for trend charts (1st–6th Jan 2025).

**/


select * from [EDIFECSProcess].[EDIFECSFileControlMaster]
select * from [MedEx].[EDIFECSFileControlMaster]
select * from [MedEx].[TriggerFileHolder]
select * from [dbo].[DimDate]


select * from [dbo].[vw_EDIFECS_InboundFiles]
select * from [dbo].[vw_EDIFECS_OutboundFiles]
select * from [dbo].[vw_TriggerFiles_All]
select * from [dbo].[vw_TriggerFiles_CMS]
select * from [dbo].[vw_TriggerFiles_MedEx]


select * from [MedEx].[EDIFECSFileControlMaster]
select * from [dbo].[vw_EDIFECS_OutboundFiles]
