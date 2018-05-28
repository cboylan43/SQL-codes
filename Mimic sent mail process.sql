use adppctu2012

insert into Mail
(ComputerID, MigrationUnitID, UserID, MailMessageID,  ResourceTypeID )

(SELECT ComputerID, MigrationUnitID, UserID, MailMessageID, ResourceTypeID
FROM         MailQueue
--where Held = 0 
where ComputerID = 414411 and MailMessageID = 881)

delete MailQueue
from MailQueue
--where Held = 0
where ComputerID = 414411 and MailMessageID = 881

--delete Mail
--from Mail
--where MigrationUnitID = 44761
