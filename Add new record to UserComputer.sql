use adppctu2012
-- Change MigrationGroupID to match new site group ID

declare @CID as int
declare @uID as int
Declare @mgID as int

declare curtemp cursor for
	SELECT     Computer.ComputerID, Computer.UserID
	FROM         Computer LEFT OUTER JOIN
						  UserComputer ON Computer.ComputerID = UserComputer.ComputerID
	WHERE     (UserComputer.MigrationGroupID IS NULL) -- AND (Computer.LocationID = 1313)

Open curtemp
fetch from curtemp
into @cid,@uid
-- Hard coded Migraiton Group - it was easier since this is a one off
Select @mgid = 5987

While @@fetch_status = 0
Begin

--print @uid
-- Insert the new entry
Insert into UserComputer (UserID,ComputerID,MigrationGroupID)
Values (@uid,@cid,@mgid)

fetch from curtemp
into @cid,@uid
End

Close curtemp
deallocate curtemp

