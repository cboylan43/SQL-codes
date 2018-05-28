Use ADPPCTU2012	

-- update usercomputer table to match what is shown in the Computer table

declare @UCID as int
Declare @LocID as int
declare @MGID as int
declare curTemp cursor for
	SELECT     UserComputer.UserComputerID, Computer.LocationID
	FROM         UserComputer INNER JOIN
						  Computer ON UserComputer.ComputerID = Computer.ComputerID INNER JOIN
						  MigrationGroup ON UserComputer.MigrationGroupID = MigrationGroup.MigrationGroupID AND Computer.LocationID <> MigrationGroup.LocationID INNER JOIN
						  Location ON Computer.LocationID = Location.LocationID
	--Where UserComputer.UserComputerID = 266707
Open curtemp
fetch next from curtemp into @UCID,@LocID

while @@fetch_status = 0
Begin

SELECT    @MGID = MigrationGroupID
FROM         MigrationGroup
WHERE     (LocationID = @LocID) AND (Source = 'Location')

Update UserComputer
Set UserComputer.MigrationGroupID = @mgID
Where UserComputer.UserComputerID = @UCID

fetch next from curtemp into @UCID,@LocID
End

close curtemp
deallocate curtemp
