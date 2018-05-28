Use adppCTU2012
set nocount on
--  script to add emails to mail queue

declare curTemp cursor for 
	SELECT     MigrationUnitID, UserID, ComputerID, 1124 AS MailMessID, 2 AS ResourceTypeID, 6500 AS MGID
	FROM         Computer
	WHERE     (MigrationUnitID = 43650)
declare @muid as int
declare @uid as int
declare @cid as int
declare @mailID as int
declare @resID as int
declare @mgid as int



-- read initial value in
Open Curtemp

Fetch next from curtemp
into @muid,@uid,@cid,@mailid,@resID,@mgid

While @@fetch_status = 0
Begin

insert into MailQueue
	(MigrationUnitID,
	 UserID,
	 ComputerID,
	 MailMessageID,
	 ResourceTypeID,
	 MigrationGroupID)
Values
	(@muid,
	@uid,
	@cid,
	@mailID,
	@resID,
	@mgid)



		

	Fetch next from curtemp
	into @muid,@uid,@cid,@mailid,@resID,@mgid
End

close curtemp
deallocate curtemp
