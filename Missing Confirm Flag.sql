Use ADPPCTU2012

SELECT     TOP (200) MigrationComputerRegistration.MigrationComputerRegistrationID, MigrationComputerRegistration.ComputerID, 
                      MigrationComputerRegistration.MigrationGroupID, MigrationComputerRegistration.ConsumerChosenModelID, MigrationComputerRegistration.ConsumerChosenOSID, 
                      MigrationComputerRegistration.IsConfirmed, Computer.SerialNumber, MigrationGroup.MigrationGroup, Computer.ComputerMigrationStatusID, 
                      MigrationUnit.MigrationUnit, MigrationComputerRegistration.OrderedModelID, MigrationComputerRegistration.OrderedOSID
FROM         MigrationComputerRegistration INNER JOIN
                      Computer ON MigrationComputerRegistration.ComputerID = Computer.ComputerID INNER JOIN
                      MigrationGroup ON MigrationComputerRegistration.MigrationGroupID = MigrationGroup.MigrationGroupID INNER JOIN
                      MigrationUnit ON Computer.MigrationUnitID = MigrationUnit.MigrationUnitID AND MigrationGroup.MigrationGroupID = MigrationUnit.MigrationGroupID
WHERE     (MigrationComputerRegistration.IsConfirmed = 0) AND (NOT (MigrationComputerRegistration.ConsumerChosenModelID IS NULL)) AND 
                      (NOT (MigrationComputerRegistration.ConsumerChosenOSID IS NULL)) AND (Computer.ComputerMigrationStatusID < 4)