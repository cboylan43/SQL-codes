use adppctu2012
SELECT DISTINCT Computer.ComputerID, UserComputer.UserID, [User].EmailLanguageID, Computer.MigrationUnitID, MigrationUnit.MigrationGroupID, Division.Division, ISNULL(Division.CustomMailRequired, 0) AS CustomMailRequired, [User].UserID  
FROM  Computer With (NoLock) Inner Join Location L With (NoLock) on Computer.LocationID = L.LocationID  Inner Join TimeZone TZ With (NoLock) on TZ.TimeZoneID = L.TimeZoneID  LEFT OUTER JOIN MigrationUnit With (NoLock) ON Computer.MigrationUnitID = MigrationUnit.MigrationUnitID  Left Outer Join MigrationComputerRegistration MCR on MCR.ComputerID = Computer.ComputerID  Inner Join MigrationDurDay MMD on MMD.MigrationDurDayID = MigrationUnit.MigrationDurDayID  Inner Join MailBatchMessages MBM on MBM.MailmessageID = '1123' And MMD.MigrationDurDayID = MBM.MigrationDurDayID  Inner Join MailMessage MM on MM.MailMessageID = '1123' And MM.LanguageID = '140'  LEFT OUTER JOIN  CurrentHardware With (NoLock) ON Computer.ComputerID = CurrentHardware.ComputerID   Inner Join MigrationGroup MG on MG.MigrationGroupID = MigrationUnit.MigrationGroupID LEFT OUTER JOIN UserComputer With (NoLock) ON Computer.ComputerID = UserComputer.ComputerID LEFT OUTER JOIN  [User] With (NoLock) ON UserComputer.UserID = [User].UserID LEFT OUTER JOIN  Division RIGHT OUTER JOIN  Department With (NoLock) ON Division.DivisionID = Department.DivisionID ON [User].DepartmentID = Department.DepartmentID  

WHERE  
((DeploymentDate >= '10/31/2012 12:00:00 AM' And dbo.convertdatetojulian(GetDate()) >= dbo.convertdatetojulian(dbo.udf_Timezone_Conversion(TZ.Abbreviation, 'EST', Convert(DateTime,Convert(Varchar(10),DBO.GetMigrationDateAdjusted2(-99,Computer.DeploymentDate), 101) + ' ' + '12:00:00 AM'),0))   
Or  (MBM.DateRequired = 'False' And dbo.convertdatetojulian(GetDate()) >= dbo.convertdatetojulian(dbo.udf_Timezone_Conversion(TZ.Abbreviation, 'EST', Convert(DateTime,Convert(Varchar(10),DBO.GetMigrationDateAdjusted2(-99,MG.PlanMigrationStartDate), 101) + ' ' + '12:00:00 AM'),0))   
Or  (MM.ReminderEmail = 1 and (dbo.convertdatetojulian(MG.FirstReminderEmail) =  dbo.convertdatetojulian(GetDate()) And Computer.DeploymentDate Is NULL))   
Or  (MM.ReminderEmail = 1 and (dbo.convertdatetojulian(MG.SecondReminderEmail) = dbo.convertdatetojulian(GetDate()) And Computer.DeploymentDate Is NULL)) )) 
 And IsNull(Computer.ExcludedDate,'')=''  
And ((MM.ReminderEmail = 1 And dbo.ConvertDateToJulian(MG.PlanCompleteDate) >= dbo.ConvertDateToJulian(GetDate()) ) or  (MM.ReminderEmail = 0)) 
And ((MM.ReminderEmail = 1 and IsNull(Computer.DeploymentDate,'') = '' ) 
or      (MM.ReminderEmail = 0 ))  And ((MM.MailCode = 'PCTU-6' and IsNull(Computer.CompletedDate,'') <> '' ) 
or      (MM.MailCode <> 'PCTU-6' and IsNull(Computer.CompletedDate,'') = '' ))  
And ((IsNull(Computer.DeploymentDate,'') <> IsNull(Computer.CompletedDate,'') ) 
Or  (IsNull(Computer.DeploymentDate,'') = '' Or IsNull(Computer.CompletedDate,'') = '' ))  
AND (Computer.HoldDate IS NULL) AND (UserComputer.UserID IS NOT NULL)  )
AND (NOT EXISTS (SELECT MailQueueID, UserID, MailMessageID FROM MailQueue   WHERE (UserID = [User].UserID) AND (ComputerID = Computer.ComputerID) AND (MailMessageID = 1123)))

--AND (NOT EXISTS (SELECT UserID FROM Mail WHERE (UserID = [User].UserID)  AND (MigrationUnit.MigrationGroupID IS NOT NULL)  AND (ComputerID = Computer.ComputerID) AND (MailMessageID = 1123) And MM.ReminderEmail = 0)
--  AND  [User].AccountStatus = '0'  

--AND ((NOT EXISTS (SELECT ComputerID FROM ComputerAudit WHERE ComputerID = [UserComputer].ComputerID AND AuditCodeID = 98)) Or MCR.EmailSendToUser Is Not NULL)  

--AND ([User].EmailLanguageID = 140)  
--AND ([User].EmailAddress <> 'Unknown@pg.com'))  
--And NOT EXISTS
--(SELECT UserID 
--FROM Mail m1 Inner Join MailMessage MM on MM.MailMessageID = M1.MailMessageID    
--Where (([User].UserID = M1.UserID and  Computer.ComputerID = M1.ComputerID And M1.MailMessageID = '1123' And MM.ReminderEmail = 0)      
--Or ([User].UserID = M1.UserID and  Computer.ComputerID = M1.ComputerID And M1.MailMessageID = '1123' And MM.ReminderEmail = 0 )    
-- Or ([User].UserID = M1.UserID and  Computer.ComputerID = M1.ComputerID And M1.MailMessageID = '1123' And MM.ReminderEmail = 1 And       (dbo.convertdatetojulian(GetDate()) <> dbo.convertdatetojulian(MG.FirstReminderEmail) 
--And (dbo.convertdatetojulian(GetDate()) <> dbo.convertdatetojulian(MG.SecondReminderEmail) )) 
--Or ([User].UserID = M1.UserID and  Computer.ComputerID = M1.ComputerID And M1.MailMessageID = '1123' 
--And MM.ReminderEmail = 1 And             (dbo.convertdatetojulian(M1.CreateDate) >= dbo.convertdatetojulian(MG.FirstReminderEmail) 
--And dbo.convertdatetojulian(M1.CreateDate) >= dbo.convertdatetojulian(GetDate())) 
--or         dbo.convertdatetojulian(M1.CreateDate) >= dbo.convertdatetojulian(MG.SecondReminderEmail) 
--And dbo.convertdatetojulian(M1.CreateDate) >= dbo.convertdatetojulian(GetDate()))        )))     
--And MG.PlanMigrationStartDate <> '1900-01-01 00:00:00.000') AND (MigrationUnit.MigrationDurDayID = '149') 









--((DeploymentDate >= '10/31/2012 12:00:00 AM' And dbo.convertdatetojulian(GetDate()) >= dbo.convertdatetojulian(dbo.udf_Timezone_Conversion(TZ.Abbreviation, 'EST', Convert(DateTime,Convert(Varchar(10),DBO.GetMigrationDateAdjusted2(-99,Computer.DeploymentDate), 101) + ' ' + '12:00:00 AM'),0))
--   Or  (MBM.DateRequired = 'False' And dbo.convertdatetojulian(GetDate()) >= dbo.convertdatetojulian(dbo.udf_Timezone_Conversion(TZ.Abbreviation, 'EST', Convert(DateTime,Convert(Varchar(10),DBO.GetMigrationDateAdjusted2(-99,MG.PlanMigrationStartDate), 101) + ' ' + '12:00:00 AM'),0))   
--Or  (MM.ReminderEmail = 1 and (dbo.convertdatetojulian(MG.FirstReminderEmail) =  dbo.convertdatetojulian(GetDate()) And Computer.DeploymentDate Is NULL))   
--Or  (MM.ReminderEmail = 1 and (dbo.convertdatetojulian(MG.SecondReminderEmail) = dbo.convertdatetojulian(GetDate()) And Computer.DeploymentDate Is NULL))     ))  
--And IsNull(Computer.ExcludedDate,'')=''  And ((MM.ReminderEmail = 1 And dbo.ConvertDateToJulian(MG.PlanCompleteDate) >= dbo.ConvertDateToJulian(GetDate()) ) 
--or       (MM.ReminderEmail = 0)) And ((MM.ReminderEmail = 1 and IsNull(Computer.DeploymentDate,'') = '' ) or            (MM.ReminderEmail = 0 ))  
--And ((MM.MailCode = 'PCTU-6' and IsNull(Computer.CompletedDate,'') <> '' ) or            (MM.MailCode <> 'PCTU-6' and IsNull(Computer.CompletedDate,'') = '' ))  
--And ((IsNull(Computer.DeploymentDate,'') <> IsNull(Computer.CompletedDate,'') ) Or        (IsNull(Computer.DeploymentDate,'') = '' Or IsNull(Computer.CompletedDate,'') = '' ))  
--AND (Computer.HoldDate IS NULL) AND (UserComputer.UserID IS NOT NULL)  AND (NOT EXISTS (SELECT MailQueueID, UserID, MailMessageID FROM MailQueue   WHERE (UserID = [User].UserID) 
--AND (ComputerID = Computer.ComputerID) AND (MailMessageID = 1123)))  AND (NOT EXISTS (SELECT UserID FROM Mail WHERE (UserID = [User].UserID)  AND (MigrationUnit.MigrationGroupID IS NOT NULL)  
--AND (ComputerID = Computer.ComputerID) AND (MailMessageID = 1123) And MM.ReminderEmail = 0)  AND  [User].AccountStatus = '0'  
--AND ((NOT EXISTS (SELECT ComputerID FROM ComputerAudit WHERE ComputerID = [UserComputer].ComputerID AND AuditCodeID = 98)) 
--Or MCR.EmailSendToUser Is Not NULL)  AND ([User].EmailLanguageID = 140)  AND ([User].EmailAddress <> 'Unknown@pg.com'))  
--And NOT EXISTS(SELECT UserID FROM Mail m1 Inner Join MailMessage MM on MM.MailMessageID = M1.MailMessageID     
--Where (([User].UserID = M1.UserID and  Computer.ComputerID = M1.ComputerID And M1.MailMessageID = '1123' And MM.ReminderEmail = 0)      
--Or ([User].UserID = M1.UserID and
--  Computer.ComputerID = M1.ComputerID 
--And M1.MailMessageID = '1123' 
--And MM.ReminderEmail = 0 ))))