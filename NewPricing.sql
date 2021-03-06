USE [ADPPCTU2012]
GO
/****** Object:  StoredProcedure [dbo].[Process_ComputerSystem_PriceByComputerSystemIDTEST]    Script Date: 05/16/2012 15:33:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		aaron.gregory@hp.com
-- Edited: Chris.Boylan@hp.com
-- Create date: 3/28/2011 2:34:21 PM
-- Description:	get AdditionalPrice by the ComputerSystemID.
-- Edit Notes:
-- 06/04/2011 2:34:21 PM		get product price from ProductBand
-- 06/05/2011					added ability to detect if additional parameters exist and add them
-- 05/16/2012		Adding logic to pick the price based on the product band
-- DynamicSQL:					AddParameter=ComputerID
-- =============================================
ALTER PROCEDURE [dbo].[Process_ComputerSystem_PriceByComputerSystemIDTEST] 
	-- Add the parameters for the stored procedure here
	@ComputerSystemID AS INT = 0
,	@ComputerID AS INT = 0
,	@UpdateAdditionalPrice AS VARCHAR(255) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Local variables
	DECLARE @MigrationUnitID AS INT
	DECLARE @PricingMatrix AS INT
	DECLARE @OldProductBandID AS INT
	DECLARE @OldProductValue AS FLOAT
	DECLARE @NewProductPrice AS FLOAT
	--Added for new code
	DECLARE @NewProductBandID AS INT



	-- default values
	SET @PricingMatrix = 1 -- TURN ON PRICING MATRIX
--	SET @PricingMatrix = 0 -- TURN OFF PRICING MATRIX
	SET @OldProductValue = 0
	SET @NewProductPrice = 0
	--Added for new code
	SET @NewProductBandID = 0


	-- Exit if not a valid ComputerSystemID
	IF @ComputerSystemID = 0
           BEGIN
            RETURN 0
           END

--	New Code starts here
-- Get the Product Band for the new system from the ComputerSystem table
	SELECT @NewProductBandID =  [ComputerSystem].[ProductBandID]
	FROM ComputerSystem 
	WHERE ComputerSystem.ComputerSystemID = @ComputerSystemID
--Get the probuct band for the current PC
IF (@ComputerID>0)
	BEGIN			
		SELECT		TOP 1 @OldProductBandID = ISNULL(ComputerSystem.ProductBandID,1)
		FROM		CurrentHardware LEFT OUTER JOIN ComputerSystem on CurrentHardware.SystemName = ComputerSystem.Model
		WHERE		CurrentHardware.ComputerID = @ComputerID
	END
-- If statements to determine propper column to pull from
If @NewProductBandID='1' 
	Begin
--		Return(SELECT     DT
		(Select @NewProductPrice = isnull(ProductBandsTEST.DT,0)
		FROM         ProductBandsTEST
		WHERE     (ProductBand = @OldProductBandID))
	End
If @NewProductBandID='2' 
	Begin
--		Return(SELECT     [LT-S]
		(Select @NewProductPrice = isnull(ProductBandsTEST.[LT-S],0)
		FROM         ProductBandsTEST
		WHERE     (ProductBand = @OldProductBandID))
	End

If @NewProductBandID='3' 
	Begin
--		Return(SELECT     [lt-p]
		(Select @NewProductPrice = isnull(ProductBandsTEST.[LT-P],0)
		FROM         ProductBandsTEST
		WHERE     (ProductBand = @OldProductBandID))
	End

If @NewProductBandID='4'
	Begin
--		Return(SELECT     LW
		(Select @NewProductPrice = isnull(ProductBandsTEST.LW,0)
		FROM         ProductBandsTEST
		WHERE     (ProductBand = @OldProductBandID))
	End

If @NewProductBandID='5' 
	Begin
--		Return(SELECT     TB
		(Select @NewProductPrice = isnull(ProductBandsTEST.TB,0)
		FROM         ProductBandsTEST
		WHERE     (ProductBand = @OldProductBandID))
	End

If @NewProductBandID='6' 
	Begin
--		Return(SELECT     [lt-he]
		(Select @NewProductPrice = isnull(ProductBandsTEST.[LT-HE],0)
		FROM         ProductBandsTEST
		WHERE     (ProductBand = @OldProductBandID))
	End

If @NewProductBandID='7' 
	Begin
--		Return(SELECT     [DT-HE]
		(Select @NewProductPrice = isnull(ProductBandsTEST.[DT-HE],0)
		FROM         ProductBandsTEST
		WHERE     (ProductBand = @OldProductBandID))
	End

If @NewProductBandID='8' 
	Begin
--		Return(SELECT     [DT-HE2]
		(Select @NewProductPrice = isnull(ProductBandsTEST.[DT-HE2],0)
		FROM         ProductBandsTEST
		WHERE     (ProductBand = @OldProductBandID))
	End
If @NewProductBandID >'8'
	Begin
		Print 'BaseComputer is not in proper range 1-8'
		Select @NewProductPrice = 0
		Return 'OLD PC Too high'
	End
If @NewProductBandID <'1'
	Begin
		Print 'BaseComputer is not in proper range 1-8'
		Select @NewProductPrice = 0
		Return 'OLD PC Less than 1'
	End

--  New Code Ends here

---- get the products price from the band
--	SELECT @NewProductPrice =  [Prices].[ProductPrice]
--	FROM ComputerSystem 
--	LEFT OUTER JOIN [ProductBands] AS [Prices] ON [ComputerSystem].[ProductBandID] = [Prices].[ProductBand]
--	WHERE ComputerSystem.ComputerSystemID = @ComputerSystemID
--	
--	
--	-- get the band of the current computer to determine this users budget. 
--	-- If the current computer is in a higher band than the displaying model the additional cost is 0.00
--	-- If the users computer is in a lower band the value is applied to the the price of the displaying model like a discount
--	-- If the site is self funded there is no additonal cost
--	
--	IF (@ComputerID>0)
--		BEGIN			
--	
--			-- GET migrationunit id and determine if the pricing matrix is on
--			SELECT @MigrationUnitID = Computer.MigrationUnitID, @PricingMatrix = ISNULL(MigrationUnit.PricingMatrix,1)  FROM Computer LEFT OUTER JOIN MigrationUnit ON Computer.MigrationUnitID=MigrationUnit.MigrationUnitID WHERE Computer.ComputerID = @ComputerID
--			SET  @MigrationUnitID = ISNULL(@MigrationUnitID,0)	
--	
--			-- get current band
--			SELECT		TOP 1 @OldProductBandID = ISNULL(ComputerSystem.ProductBandID,1)
--			FROM		CurrentHardware LEFT OUTER JOIN ComputerSystem on CurrentHardware.SystemName = ComputerSystem.Model
--			WHERE		CurrentHardware.ComputerID = @ComputerID
--
--			-- get current model price
--			SELECT		@OldProductValue = ISNULL(ProductBands.ProductPrice,0)
--			FROM		ProductBands
--			WHERE		ProductBands.ProductBand = @OldProductBandID
--
--		END
--		
--	-- self funded no price
--	IF (@PricingMatrix=0)
--	BEGIN
--		SELECT @NewProductPrice = 0
--	END	
--	
--	
--	-- subtract the old product value from the new product to determine if there is additonal cost
--	IF (@PricingMatrix=1)
--	BEGIN
--		SELECT @NewProductPrice = (@NewProductPrice - @OldProductValue)
--		
--			IF (@NewProductPrice<0)
--			BEGIN
--				SELECT @NewProductPrice = 0
--			END
--		
--	END
--
--	
--		
--	-- display the ProductPrice
	SELECT @NewProductPrice	AS [Price]
END