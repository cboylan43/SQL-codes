use adpPCTU2012

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
			@AddToBaselineComputerModel = @Model,
			@AddToBaselinePeriodID = 7,
			@DEBUG = 1
	--		,@AddToBaselineLocationID = 88
	--, @AddToBaselineMigrationGroupID = 6663
	--, @AddToBaselineMigrationUnitID =44096

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
