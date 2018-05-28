use adppctu2012

--Script to add mail to the queue based on SN and Mail Code
-- CAUTION - not all email codes are distinct


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
--Select @SN ='CNU1471174'
--Select @MailCode ='SS PCTU-9'
Select @SN ='2UA8250FSN'
Select @MailCode ='NG+ PCTU-5'
-- Get ComputerID from Serial
Select @CID=ComputerID, @uid = USERID, @MUID = MigrationUnitID
From Computer
Where SerialNumber = @SN

--update - check for email override
Select @uid = (isnull (MigrationComputerRegistration.EmailSendToUser,@uid))
From MigrationComputerRegistration
Where MigrationComputerRegistration.ComputerID=@CID

SELECT    @MGid = MigrationGroupID
FROM         MigrationUnit
WHERE     (MigrationUnitID = @MUID)

Select @MMID = MailMessageID
From MailMessage
Where MailCode = @Mailcode And LanguageID = '140'

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


