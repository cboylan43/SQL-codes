use ADPPCTU2012

-- tempory script for add to baseline

declare curAdd cursor for 
		SELECT     TNumber, OldSerial, OldPCModel
		FROM         zAddToBaseline
		Where Added is null
declare @Tnum as varchar(6)
declare @SN as varchar (64)
declare @Model as varchar (100)
DECLARE	@return_value int

Open curAdd
fetch next from curAdd
into @Tnum, @SN,@Model

While @@fetch_status = 0
	Begin

	EXEC	@return_value = [dbo].[_001_AddToBaselineInsertComputerID]
			@AddToBaselineUser = @Tnum,
			@AddToBaselineComputer = @SN,
			@AddToBaselineComputerModel = @Model

	SELECT	'Return Value' = @return_value

	Update  zAddToBaseline
	Set added = @return_value
	Where OldSerial = @SN
	
	If @return_value =1
		Update  zAddToBaseline
		Set ComputerID = Computer.ComputerID
		From zAddToBaseline LEFT OUTER JOIN
                      Computer ON zAddToBaseline.OldSerial = Computer.SerialNumber
		Where Computer.SerialNumber=@SN


	fetch next from curAdd
	into @Tnum, @SN,@Model
	End


close curAdd
deallocate curAdd

-- Third step from job process  - add to history

declare @atbID as int
Declare @CID as int
Declare @Aid as int
declare curTemp cursor for
	SELECT    AddToBaseLineID, TNumber, OldSerial, OldPCModel, Added,ComputerID
	FROM         zAddToBaseline
	Where added = 1
	

Open CurTemp
Fetch Next From curTemp 
Into @atbID,@Tnum,@SN,@model,@aid,@CID


While @@Fetch_Status = 0
Begin
-- Move records to history table
Insert into zAddToBaselineHistory ( AddToBaseLineID, TNumber, OldSerial, OldPCModel, Added,ComputerID)
Values (@atbID,@Tnum,@SN,@model,@aid,@CID)


Fetch Next From curTemp 
Into @atbID,@Tnum,@SN,@model,@aid,@CID
End

Close curTemp
Deallocate curTemp

Delete from  zAddToBaseline
Where added = 1


