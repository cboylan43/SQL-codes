use adppctu2012

declare @mgid as int
declare @MG as varchar(255)
declare @OMG as int
declare @locID as int
declare @sourceID as int
declare @SH as varchar(100)
declare @newLocID as int
declare @newSh as varchar (255)
declare curTemp	cursor for
	SELECT   MigrationGroup.MigrationGroupID
			, MigrationGroup.MigrationGroup
			, MigrationGroup.OwnerMigrationGroupID
			, MigrationGroup.LocationID
			--, Location.Location
			, MigrationGroup.SourceID
			, MigrationGroup.SourceHierarchy
	FROM         MigrationGroup INNER JOIN
						  Location ON MigrationGroup.LocationID = Location.LocationID AND MigrationGroup.MigrationGroup <> Location.Location
	WHERE     (NOT (MigrationGroup.Source IS NULL)) AND (MigrationGroup.Source = 'Location')
--	where MigrationGroup.MigrationGroupID = 5993
	

Open curtemp
fetch from curTemp 
Into @MGID,@MG,@OMG, @locID, @sourceID, @SH

While @@fetch_Status = 0
Begin
print @omg
-- get new data for updating existing records
SELECT    @newlocID = LocationID,@newSH = SourceHierarchy
FROM         MigrationGroup
WHERE     (MigrationGroupID = @OMG) 

-- create new hierarchy for a location
select @newSH = @newSh + '.'+cast(@newlocID as varchar(20))
print @MG + ' -- '+@sh + ' -- '+ @newsh

-- need to update SourceID with newLocID
-- SourceHierachy with newSH + newlocID
-- Location ID with newlocID
update MigrationGroup
Set SourceID=@newLocID, SourceHierarchy = @newSH, LocationID=@newLocID
Where MigrationGroupID = @MGID







fetch from curTemp 
Into @MGID, @MG,@OMG, @locID, @sourceID, @SH

End

Close curTemp
deallocate curTemp