Use ADPPCTU2012

-- Script to Add a new Site.  This adds an entry to the Site table, 
--location table and the Migration group
-- Written by Chris 8/28/12
-- Updates - 1/27/14 - CJB - you have to run the script twice then up the location due to FK contraints
--update MigrationGroup
--set OwnerMigrationGroupID = <Site migration group>
--from MigrationGroup mg
--where mg.MigrationGroupID = <location migration group>


Set 
Declare @SName as varchar(200)
Declare @LName as varchar(200)
Declare @MGname as varchar(200)
Declare @CName as varchar(200)
Declare @Rid as int -- Region ID
Declare @CID as int -- Country ID
Declare @Sid as int -- Site ID
Declare @lic as int -- Location ID
Declare @SH as varchar (200) -- Source Hierachy
Declare @MGID as int -- OwnerMigraitonGroup

-- Enter the Data
Select @SName = 'LAGOS AGBARA PLANT'
Select @CName = 'Nigeria'

-- Get the IDs
SELECT     @Cid = CountryID, @Rid = RegionID
FROM         Country
WHERE     (Country = @Cname)

Print 'Country ID = ' + cast(@Cid as varchar(40))

-- Add to Site Table
IF (Select Top 1 SiteID
From Site
Where [Site] = @SName) is Null
Begin
	Insert Into Site (
		[Site],
		Description,
		CountryID,
		CreateDate,
		LastUpdateDate )
	Select
		@SName,
		@SName,
		@Cid,
		GetDate(),
		GetDate()
End
Select @Sid = SiteID
From Site
Where [Site] = @SName

Select *
From Site
Where [Site] = @SName
-- Insert into Migraiton group after Site Add 
If (Select MigrationGroupID From MigrationGroup Where Source = 'Site' ANd SourceID = @sid) is Null
Begin
	-- Need to find two variables - OwnerMigration Group and SourceHierarchy
	-- hieracrhy set
	Select @SH = Cast(@rid as varchar(12))+'.'+Cast(@cid as varchar(12))+'.'+Cast(@sid as varchar(12))
	Print @SH
	-- OwnerMigraitonGroup
	Select @MGID = MigrationGroupID
	From MigrationGroup
	Where SourceID = @CID and Source ='Country'
	Print @MGID


		INSERT INTO MigrationGroup (                      
			Source
			, Description
			, DefDeployType
			, CreateDate
			, LastUpdateDate
			, MigrationGroup
			, LocationID
			,SourceID
			,SourceHierarchy
			,OwnerMigrationGroupID
			)
		SELECT     
			'Site' 
			, 'Site'
			, 'S'
			, GETDATE() AS Expr4
			, GETDATE() AS Expr3
			, @SName
			, @SID
			, @sID as eSID
			, @SH
			, @MGID
			
Select @SH = Null
Select @MGID = Null

End

-- Add to Location Table
IF (Select Top 1 LocationID
From Location
Where [Location] = @Sname) is Null
Begin
	Insert into Location(
		[Location],
		Description,
		TimeZoneID,
		SiteID,
		CountryID,
		CreateDate,
		LastUpdateDate )
	Select
	@SName,
	@Sname,
	21,
	@Sid,
	@Cid,
	GetDate(),
	GetDate()
End

Select *
From Location
Where [Location] = @Sname

Select @lic = LocationID
From Location
Where [Location] = @Sname

-- Insert into Migraiton group after Location Add 
If (Select MigrationGroupID From MigrationGroup Where Source='Location' and LocationID = @lic) is Null
Begin
	-- Need to find two variables - OwnerMigration Group and SourceHierarchy
	-- hieracrhy set
	Select @SH = Cast(@rid as varchar(12))+'.'+Cast(@cid as varchar(12))+'.'+Cast(@sid as varchar(12))+'.'+Cast(@lic as varchar(12))
	Print @SH
	-- OwnerMigraitonGroup
	Select @MGID = MigrationGroupID
	From MigrationGroup
	Where SourceID = @SID and Source ='Site'
	Print @MGID


		INSERT INTO MigrationGroup (                      
			Source
			, Description
			, DefDeployType
			, CreateDate
			, LastUpdateDate
			, MigrationGroup
			, LocationID
			,SourceID
			,SourceHierarchy
			,OwnerMigrationGroupID
			)
		SELECT     
			'Location' 
			, 'Location'
			, 'S'
			, GETDATE() AS Expr4
			, GETDATE() AS Expr3
			, @Sname
			, @LIc
			, @LIc as eSID
			, @SH
			, @MGID
			
		
End















