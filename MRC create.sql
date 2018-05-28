use adppctu2012
--- create MCR table
SELECT     [MigrationComputerRegistrationTEST
_1].*
FROM         ComputerTEST LEFT OUTER JOIN
                      MigrationGroupTEST ON ComputerTEST.LocationID = MigrationGroupTEST.LocationID LEFT OUTER JOIN
                      [MigrationComputerRegistrationTEST
] AS [MigrationComputerRegistrationTEST
_1] ON 
                      ComputerTEST.ComputerID = [MigrationComputerRegistrationTEST
_1].ComputerID