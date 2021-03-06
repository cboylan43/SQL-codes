Use ADPPCTU2012

--Add a PC to ComputerSystem table
--Chris Boylan

INSERT INTO [ADPPCTU2012].[dbo].[ComputerSystem]
           ([ProductBandID]
           ,[BaseComputerSystemID]
           ,[ContentID]
           
           ,[Vendor]
           ,[Model]
           ,[PCClass]
           ,[Type]
           ,[Processor]
           ,[Graphics]
           ,[ScreenSize]
           ,[Memory]
           ,[Storage]
           ,[OpticalDrive]
           ,[InputDevices]
           ,[Connectivity]
           ,[Ports]
           ,[Slots]
           ,[Weight]
           ,[Dimensions]
           ,[Other]
           
           ,[AdditionalPrice]
           
           ,[IsCurrentDTL]
           
           ,[DTLDate]
           
           ,[Comments]
           
           ,[CreateDate]
           ,[CreateUser]
           ,[LastUpdateDate]
           ,[LastUpdateUser])
     VALUES
           (<ProductBandID, int,>
           ,<BaseComputerSystemID, int,>
           ,<ContentID, int,>
           
           ,<Vendor, int,>
           ,<Model, nvarchar(50),>
           ,<PCClass, int,>
           ,<Type, varchar(50),>
           ,<Processor, nvarchar(200),>
           ,<Graphics, nvarchar(200),>
           ,<ScreenSize, nvarchar(200),>
           ,<Memory, nvarchar(200),>
           ,<Storage, nvarchar(200),>
           ,<OpticalDrive, nvarchar(200),>
           ,<InputDevices, nvarchar(200),>
           ,<Connectivity, nvarchar(200),>
           ,<Ports, nvarchar(200),>
           ,<Slots, nvarchar(200),>
           ,<Weight, nvarchar(200),>
           ,<Dimensions, nvarchar(200),>
           ,<Other, nvarchar(max),>
           
           ,<AdditionalPrice, float,>
           
           ,<IsCurrentDTL, bit,>
           
           ,<DTLDate, datetime,>
           
           ,<Comments, nvarchar(max),>
           
           ,<CreateDate, datetime,>
           ,<CreateUser, datetime,>
           ,<LastUpdateDate, datetime,>
           ,<LastUpdateUser, nvarchar(50),>)