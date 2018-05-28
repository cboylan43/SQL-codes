use adppctu2012

-- add migrationUnits to baseline load
-- assumes blank MU table and accurate information on MigrationGroup table

declare @MUname as varchar(255)
declare @tracking  as varchar(255)
declare @MGID as int
declare @locationID as int
declare @language as int 
declare @ShowConfirm as bit 
declare @ComputerChoice as bit 
declare @OSChoice as bit 
declare @pricingMatrix as bit 
declare @StartDate as datetime --default 6/16/2011 12:50:06 PM
declare @Enddate as datetime 
declare @description as varchar(255)
declare @DurdayID as int

select @language = 1
select @ShowConfirm = 1 
select @ComputerChoice = 1
select @OSChoice = 1 
select @pricingMatrix = 1


declare curLocation cursor for
	SELECT     MigrationGroupID, LocationID, MigrationGroup
	FROM         MigrationGroup
	WHERE     (Description = 'location') 

open curLocation
fetch next from curLocation

into @MGID,@locationID,@MUname
While @@fetch_status = 0
	Begin
	select @tracking = 'Base' + cast(@locationID as varchar(100))
	select @description = @MUName
	-- insert into table
	insert into [ADPPCTU2012].[dbo].[MigrationUnit]
	(
	[MigrationUnit] 
	,[TrackingNum]
	,[MigrationGroupID]
	,[LocationID]
	,[LanguageID]
	,[ShowConfirmationText]
	,[ShowComputerChoice]
	,[ShowOSChoice]
	,[PricingMatrix]
	,[Description]
	,[DefDeployType]
	,CreateDate
	,LastUpdateDate
	)
	Select
	@MUname
	,@tracking
	,@MGID
	,@locationID
	,@language
	,@ShowConfirm
	,@ComputerChoice
	,@OSChoice
	,@pricingMatrix
	,@description
	,4
	,getdate()
	,getdate()


	fetch next from curLocation
	into @MGID,@locationID,@MUname

	End


close curlocation
deallocate curlocation

