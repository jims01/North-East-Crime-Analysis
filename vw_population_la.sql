USE [CrimesDB]
GO

/****** Object:  View [dbo].[vw_population_la]    Script Date: 11/21/2026 10:02:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  create view [dbo].[vw_population_la] AS 
    SELECT LOCAL_AUTHORITY AS local_authority, SUM([POPULATION]) AS [population]
    FROM population_staging
    GROUP BY LOCAL_AUTHORITY
    
GO


