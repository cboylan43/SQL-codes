use adppctu2012
-- Change MigrationGroupID to match new site group ID

declare @UCID as int
declare @SiteID as int
Declare @mgID as int

declare curtemp cursor for
	SELECT     UserComputer.UserComputerID, Site.SiteID
	FROM         UserComputer INNER JOIN
						  Computer ON UserComputer.ComputerID = Computer.ComputerID INNER JOIN
						  Site ON Computer.SiteID = Site.SiteID INNER JOIN
						  MigrationGroup ON UserComputer.MigrationGroupID = MigrationGroup.MigrationGroupID AND Site.Site <> MigrationGroup.MigrationGroup
	WHERE     (NOT (MigrationGroup.Source IS NULL)) AND (NOT (MigrationGroup.MigrationGroup = N'ADP ADMIN ADDTOBASELINE2011')) 

Open curtemp
fetch from curtemp
into @ucid,@siteid

While @@fetch_status = 0
Begin
Select @mgID = MigrationGroupID
From MigrationGroup
Where Source='Location' and SourceID=@SiteID

print cast(@UCID as char(10)) + ' Change to  ' + cast(@MGID as char (10))
Update userComputer
Set  MigrationGroupID =@MGID
Where UserComputerID = @UCID


fetch from curtemp
into @ucid,@siteid
End

Close curtemp
deallocate curtemp

