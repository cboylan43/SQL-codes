Use ADPPCTU2012

-- create temp table
create table #ManagerList(
Tnum  varchar (6),
UserID int,
Tman  varchar (6),
ManID Int,
Mion varchar (200),
CID int)


Insert into #ManagerList (Tnum,Tman)
SELECT     [T Number], SUBSTRING(Manager, CHARINDEX('=', Manager) + 1, CHARINDEX(',', Manager) - CHARINDEX('=', Manager) - 1) AS Tman
FROM         LDAPUsers
WHERE     (SUBSTRING(Manager, CHARINDEX('=', Manager) + 1, CHARINDEX(',', Manager) - CHARINDEX('=', Manager) - 1) IS NOT NULL)


Update #ManagerList
Set ManID = [User].UserID, Mion =  SUBSTRING(EmailAddress, 0, CHARINDEX('@', EmailAddress))
From #Managerlist Join [User] on #ManagerList.Tman = [user].ID

Update #ManagerList
Set UserID = [User].UserID
From #Managerlist Join [User] on #ManagerList.Tnum = [user].ID

Update #ManagerList
Set Cid = UserComputer.ComputerID
From #Managerlist Join [UserComputer] on #ManagerList.UserID =[UserComputer].UserID

Select *
From #ManagerList
Where UserID is not null and CID is not null

Update MigrationComputerRegistration
Set ManagerUserID = [#ManagerList].ManID, ManagerID = [#ManagerList].Mion
From #Managerlist Join MigrationComputerRegistration on #Managerlist.CID = MigrationComputerRegistration.ComputerID
Where (MigrationComputerRegistration.ManagerID is null)


drop table #ManagerList