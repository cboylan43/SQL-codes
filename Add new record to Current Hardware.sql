use adppctu2012
-- after you have added a record to the compouter table and the UserComouter table, you need to set teh hardware


-- Create the CurrentHardware record.
	INSERT INTO CurrentHardware
			( ComputerID
			, DeviceName
			, LoginName
			, Manufacturer
			, SystemName
			, SystemSerial
			, ComputerType
			, PlatformType)
	SELECT 
			  C.ComputerID
			, C.SerialNumber
			, C.Username
			, 'Dell'
			, C.ScopeComment 
			, C.SerialNumber
			, CASE WHEN C.PCClass = 1 
					THEN 'Desktop' 
					ELSE 'Laptop'  
			  END AS ComputerType
			, C.CompType AS PlatformType
	FROM 
			Computer AS C 
			
	WHERE 
			 (C.ComputerID = 285509)
