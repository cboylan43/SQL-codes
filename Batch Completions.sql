USE [ADPPCTU2012]
GO

declare @oldSN as NVARCHAR(100) 
Declare	@NewSN as NVARCHAR(100) 
Declare	@NewModel  as Nvarchar(100)
DECLARE	@return_value int
Declare curAdd cursor for 
	select oldserial,
		newserial,
		newmodel
	From zxtblPCCompletedImport
	Where [status] is null

Open curAdd
fetch next from curAdd
into @oldSN, @NewSN,@NewModel

While @@fetch_status = 0
	Begin

		EXEC	@return_value = [dbo].[Process_ManualCompletions]
				@oldSerial = @oldSN,
				@NewSerial = @newSN,
				@strModel =  @NewModel

		SELECT	'Return Value' = @return_value

		update zxtblPCCompletedImport
		set [Status] = @return_value
		where OldSerial = @oldSN
		
		fetch next from curAdd
		into @oldSN, @NewSN,@NewModel
	End

close curAdd
deallocate curAdd

GO
