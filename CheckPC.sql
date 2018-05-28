USE [ADPPCTU2012]

-- =============================================
-- Author: Chris Boylan
-- Create date: 8/13/12
-- Description:	A quick script to check on  a user to make sure they have all the needed fields in the 4 required table
-- Used for trouble shooting and does have a way to create a new MigrationComputerRegistration entry if needed.
-- =============================================
	-- Add the parameters for the stored procedure here
@SN Varchar(100) = 'CND0013V5L'

As
Begin
set nocount on;

-- declare @SN as varchar (100)
declare @CID as int
Declare @mgid as int
declare @UID as int
declare @fixMCR as int

Select @fixMCR = 0
-- set @Sn = 'CND0013V5L'

Select @CID = ComputerID
From Computer
Where SerialNumber = @SN

SELECT    Tablename = 'Computer',ComputerID, ComputerMigrationStatusID, UserID, TNumber, ScopeComment, Notes, Computer.LocationID, SiteID,  IsBaseLineItem, Computer.MigrationUnitID,mu.MigrationUnit
FROM         Computer join MigrationUnit as Mu on Computer.MigrationUnitID = Mu.MigrationUnitID
WHERE     (SerialNumber = @SN)

Select Tablename = 'Current Hardware',DeviceName,LoginName,ComputerType
From CurrentHardware
Where ComputerID =@CID

Select Tablename = 'UserComputer', UserID, ComputerID, UserComputer.MigrationGroupID,mg.MigrationGroup
From UserComputer Join Migrationgroup as MG on UserComputer.MigrationGroupID = Mg.MigrationgroupID
Where ComputerID =@CID

Select @uid =UserID,@mgid=MigrationGroupID
From UserComputer 
Where ComputerID =@CID

Select Tablename = 'MigrationComputerRegistration',MigrationGroupID	, ComputerId, ConsumerChosenModelID	, OrderedModelID, ConsumerChosenOSID, OrderedOSID, SewpedAsUser, EmailSendToUser
		, ManagerUserID, ManagerID
From MigrationComputerRegistration
Where ComputerID= @CID

Select Tablename = 'User', AccountStatus, UserID, LastName, oldaccount, emaillanguageID
From [User]
Where Userid = @uid

Select Tablename = 'MailQueue', MailMessageID, LanguageID
From MailQueue
Where ComputerID =@CID



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

