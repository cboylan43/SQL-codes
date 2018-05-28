Use Adppctu2012


create table #UserMCR(
Userid int,
MCRID int)

Insert into #UserMCR
SELECT     Computer.UserID, MigrationComputerRegistration.MigrationComputerRegistrationID
FROM         MigrationUnit INNER JOIN
                      Computer ON MigrationUnit.MigrationUnitID = Computer.MigrationUnitID INNER JOIN
                      MigrationComputerRegistration ON Computer.ComputerID = MigrationComputerRegistration.ComputerID AND 
                      Computer.ComputerID = MigrationComputerRegistration.ComputerID
WHERE     (MigrationUnit.MigrationUnitID = 42666)

update MigrationComputerRegistration
Set EmailSendToUser = #UserMCR.Userid
From #USerMCR Join MigrationComputerRegistration on #UserMCR.MCRID = MigrationComputerRegistration.MigrationComputerRegistrationID
Where MigrationComputerRegistration.EmailSendToUser is null


drop table #USerMCR