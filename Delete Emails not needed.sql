use ADPPCTU2012

-- Cleaning up the email queue
-- Chris Boylan 

Declare @intmqclean as int	
Declare @intinfo	AS INT

Set @intmqclean = 0 -- 1 to remove emails, 2 remove PCTU-4, 3 clear errorlog of SMTP error
set @intinfo = 1 -- 0 do nothing, 1 report on held = 0

if @intmqclean = 0
Begin
-- Remove emails for PCs already completed except for the survey emails ('NG+ PCTU-7%')
	SELECT     MailQueue.MailQueueID, Computer.ComputerMigrationStatusID, Computer.SerialNumber, Computer.SerialNumberOverride, MailMessage.MailCode
	FROM         MailQueue INNER JOIN
						  Computer ON MailQueue.ComputerID = Computer.ComputerID INNER JOIN
						  MailMessage ON MailQueue.MailMessageID = MailMessage.MailMessageID
	WHERE     ((Computer.ComputerMigrationStatusID = 4) AND (NOT (MailMessage.MailCode LIKE 'NG+ PCTU-7%')))
			or (Computer.ComputerMigrationStatusID = 1)
			Or (Computer.ComputerMigrationStatusID > 4)
End
if @intmqclean = 1
Begin
-- Remove emails for PCs already completed except for the survey emails ('NG+ PCTU-7%')
	Delete MailQueue
	FROM         MailQueue INNER JOIN
						  Computer ON MailQueue.ComputerID = Computer.ComputerID INNER JOIN
						  MailMessage ON MailQueue.MailMessageID = MailMessage.MailMessageID
	WHERE     ((Computer.ComputerMigrationStatusID = 4) AND (NOT (MailMessage.MailCode LIKE 'NG+ PCTU-7%')))
			or (Computer.ComputerMigrationStatusID = 1)
			Or (Computer.ComputerMigrationStatusID > 4)
End

if @intmqclean = 2
Begin
-- remove PCTU-4 emails
DELETE FROM MailQueue
from MailQueue
where mailmessageid = 839
End

if @intinfo = 1
Begin
-- show mail queue released
	select c.SerialNumber, mq.*
	from MailQueue mq
	left outer join Computer c on mq.ComputerID = c.ComputerID
	where mq.Held= 0
end

if @intmqclean = 3
Begin
-- remove delete error log messages
DELETE FROM ErrorLog
from errorlog e
where e.Message = 'smtpgw.pg.com - SMTP server not available'
End