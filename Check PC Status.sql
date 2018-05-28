use ADPPCTU2012

-- Check PC record to make sure all required tables have entries per Add to Baseline process
-- user PC serial number
set nocount on
declare @SN as varchar (100)
declare @CID as int
Declare @mgid as int
declare @UID as int
declare @fixMCR as int
declare @fixuser as int
declare @fixAudit as int

Select @fixMCR =0 -- 1 to create new record, 2 to remove previous order information
set @fixuser =0 -- 1 to fix Account status of user, 2 to fix email language of User, 3 to fix email langauge of override user, 4 to change UserComputer table to match override
-- 5 - change Computer UsedID ot match Usercomouter table - fixes user name at the end of End user site
Select @fixAudit = 0

set @Sn = 'CZC1386W1V'

Select @CID = ComputerID
From Computer
Where SerialNumber = @SN

Select @uid =UserID,@mgid=MigrationGroupID
From UserComputer 
Where ComputerID =@CID

If @fixuser =1
Begin
	update [user]
	set AccountStatus =0
	from [user]
	where userID = @uid
End
If @fixuser =2
Begin
	update [user]
	set RegionalLanguageID = 140, EmailLanguageID = 140
	from [user]
	where userID = @uid
End

If @fixuser =3
Begin
	update [user]
	set RegionalLanguageID = 140 , EmailLanguageID = 140
	from [User] u 
	left outer join MigrationComputerRegistration mcr on u.UserID = mcr.EmailSendToUser
	where mcr.ComputerID = @CID
End


If @fixMCR = 1
Begin
	Set NoCount off
	Print 'Fix me'
	INSERT INTO	MigrationComputerRegistration 
			( MigrationGroupID
			, ComputerId
			, ConsumerChosenModelID
			, OrderedModelID
			, ConsumerChosenOSID
			, OrderedOSID
			, SewpedAsUser
			--, EmailSendToUser
			
			)
	VALUES
			( 
			  @MGID
			, @CID
			, NULL --@ComputerSystemID
			, NULL --0
			, NULL --1
			, NULL --0
			, @UID
			--, @UID
			)			
End

if @fixAudit =1
Begin
	 Delete ComputerAudit
	 FROM ComputerAudit WHERE ComputerID =@cid
End


--change user name to over ride info
-- if original user has status of 2, email may not get created
if @fixuser = 4 
Begin
	update UserComputer
	set UserID =
	(
	select mcr.EmailSendToUser
	from MigrationComputerRegistration mcr
	where mcr.ComputerID = @CID
	)
	from UserComputer
	where ComputerID = @CID
End


If @fixMCR = 2
Begin
	Update MigrationComputerRegistration
	set ConsumerChosenModelID =null, ConsumerChosenOSID = null, IsConfirmed =0
	from MigrationComputerRegistration
	where ComputerID = @CID
End

SELECT    serialnumber,ComputerID, ComputerMigrationStatusID, UserID, TNumber, ScopeComment, Notes, Computer.LocationID,ExcludedDate,DeploymentDate,CompletedDate, SiteID,  IsBaseLineItem, Computer.MigrationUnitID,mu.MigrationUnit
		,ProductBandId, PeriodID,LanguageID
FROM         Computer 
left outer join MigrationUnit as Mu on Computer.MigrationUnitID = Mu.MigrationUnitID
WHERE     (SerialNumber = @SN)

Select 'CurrentHardware' as xTable, DeviceName,LoginName,ComputerType, systemserial, systemname, PlatformType
From CurrentHardware
Where ComputerID =@CID

Select 'UserComputer' as xTable, UserID, ComputerID, UserComputer.MigrationGroupID,mg.MigrationGroup
From UserComputer Join Migrationgroup as MG on UserComputer.MigrationGroupID = Mg.MigrationgroupID
Where ComputerID =@CID


Select 'MCR' as xTable,MigrationGroupID	, ComputerId, ConsumerChosenModelID	, ConsumerChosenOSID, IsConfirmed, SewpedAsUser, EmailSendToUser
		, ManagerUserID, ManagerID
From MigrationComputerRegistration
Where ComputerID= @CID

select 'User' as xTable, FirstName,LastName,OldAccount,ID,AccountStatus,userid, emailaddress, RegionalLanguageID, EmailLanguageID
from [user]
where userID = @uid

select 'Override user' as xTable,FirstName,LastName,OldAccount,ID,AccountStatus,userid, emailaddress, RegionalLanguageID, EmailLanguageID
from [User] u 
left outer join MigrationComputerRegistration mcr on u.UserID = mcr.EmailSendToUser
where mcr.ComputerID = @CID

SELECT * FROM ComputerAudit WHERE ComputerID =@cid  AND AuditCodeID = 98  -- if anything results show here, email will not get created

select * from Mail where mail.ComputerID = @CID

select * from MailQueue where MailQueue.ComputerID = @CID

select s.*
from SelfService s
left outer join MigrationComputerRegistration m  on s.MigrationComputerRegistrationID = m.MigrationComputerRegistrationID
where m.ComputerID = @CID


If @fixuser =1
Begin
	update [user]
	set AccountStatus =0
	from [user]
	where userID = @uid
End
If @fixuser =2
Begin
	update [user]
	set RegionalLanguageID = 140, EmailLanguageID = 140
	from [user]
	where userID = @uid
End

If @fixuser =3
Begin
	update [user]
	set RegionalLanguageID = 140 , EmailLanguageID = 140
	from [User] u 
	left outer join MigrationComputerRegistration mcr on u.UserID = mcr.EmailSendToUser
	where mcr.ComputerID = @CID
End


If @fixMCR = 1
Begin
	Set NoCount off
	Print 'Fix me'
	INSERT INTO	MigrationComputerRegistration 
			( MigrationGroupID
			, ComputerId
			, ConsumerChosenModelID
			, OrderedModelID
			, ConsumerChosenOSID
			, OrderedOSID
			, SewpedAsUser
			--, EmailSendToUser
			
			)
	VALUES
			( 
			  @MGID
			, @CID
			, NULL --@ComputerSystemID
			, NULL --0
			, NULL --1
			, NULL --0
			, @UID
			--, @UID
			)			
End

if @fixAudit =1
Begin
	 Delete ComputerAudit
	 FROM ComputerAudit WHERE ComputerID =@cid
End


--change user name to over ride info
-- if original user has status of 2, email may not get created
if @fixuser = 4 
Begin
	update UserComputer
	set UserID =
	(
	select mcr.EmailSendToUser
	from MigrationComputerRegistration mcr
	where mcr.ComputerID = @CID
	)
	from UserComputer
	where ComputerID = @CID
	
	
End

if @fixuser = 5
Begin
	-- update computer reocrd to reflect user id from user computer table
	update Computer
	set UserID = @UID
	from Computer
	where ComputerID = @CID
End

If @fixMCR = 2
Begin
	Update MigrationComputerRegistration
	set ConsumerChosenModelID =null, ConsumerChosenOSID = null, IsConfirmed =0
	from MigrationComputerRegistration
	where ComputerID = @CID
End






