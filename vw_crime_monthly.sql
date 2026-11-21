USE [CrimesDB]
GO

/****** Object:  View [dbo].[vw_crime_monthly]    Script Date: 11/21/2026 10:02:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_crime_monthly] AS
SELECT c.[MONTH],
       p.LOCAL_AUTHORITY AS local_authority,
       c.CRIME_TYPE,
       COUNT(*) AS crimes
FROM vw_crime_clean c
JOIN population_staging p
  ON c.LSOA_CODE = p.LSOA_CODE
GROUP BY c.[MONTH], p.LOCAL_AUTHORITY, c.CRIME_TYPE;
GO


