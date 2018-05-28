use adppctu2012

-- variables and constants
Declare @CID as int
Declare @SN as varchar(255)
Declare @MGID as int
Declare @uid as int
Declare @MUID as int
Declare @Rid as int
Declare @EvalID as int
Declare @MailCode as varchar(255)
Declare @MMID as int

Select @Rid = 3, @EvalID = null
Select @SN ='CNU1471174'
--Select @MailCode ='NG+ PCTU-2'
Select @MailCode ='SS PCTU-9'
--   this does not work 


--  If you have the Computer ID use this and the other Select statement
--Declare curtemp cursor for
--			Select SerialNumber
--			From Computer
--			Where (ComputerID ='235594') or
--			(ComputerID ='235731') or
--			(ComputerID ='235733') or
--			(ComputerID ='270352') or
--			(ComputerID ='270962') or
--			(ComputerID ='272253') or
--			(ComputerID ='282601')

-- Just have Serial Numbers? Use this one.
Declare curtemp cursor for
Select ComputerID
From Computer
Where (serialnumber = 'cnu1471174' ) 


Open curtemp
Fetch next from curtemp into @sn
While @@fetch_status=0
Begin

-- start mail queue add code
--Select @CID=ComputerID, @uid = USERID, @MUID = MigrationUnitID
--From Computer
--Where SerialNumber = @SN

Select @CID=ComputerID, @uid = USERID, @MUID = MigrationUnitID
From Computer
Where ComputerID = @sn

SELECT    @MGid = MigrationGroupID
FROM         MigrationUnit
WHERE     (MigrationUnitID = @MUID)

Select @MMID ='1103'

Insert into MailQueue (
ComputerID,
UserID,
MigrationUnitID,
MigrationGroupID,
ResourceTypeID,
EvalID,
MailMessageID,
AdditionalParam)
Values(
@CId,
@UID,
@MUID,
@MGID,
@RID,
@EvalID,
@MMID,
'')
-- end mail queue add code
Fetch next from curtemp into @sn

End
close curtemp
deallocate curtemp