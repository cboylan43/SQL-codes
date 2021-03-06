USE [ADPPCTU2012]


/*
=======================================
INSERT/ADD User
=======================================
*/

INSERT INTO dbo.[User]
	(
	 FirstName
     ,LastName
     ,EmailAddress
     ,EmailLanguageID
     ,ID
     ,Phone
     ,Title
     ,intranetAccountFlag
     ,dn
     ,OrganizationName
     ,OrganizationType
     ,CostCenter
     ,OldAccount
	 ,AccountStatus
	 ,InsertSource
	 ,CreateDate
	,LastUpdateDate
	)
Select
	 x.FirstName
    ,x.LastName
    ,isNull(x.Email,'')
    ,1
    ,x.[T Number] as TNumber
    ,x.[Phone Number] as PhoneNumber
    ,x.[Function] as JobDescription
    ,'Y' as intranetAccountFlag
    , ('uid=' + x.[T number]+',ou=people,ou=pg,o=world') as DN
    ,x.[Organization Name] as OrganizationName
    ,x.[Organization Type] as OrganizationType
    ,x.[Cost Code] as CostCode
    ,x.[NT Login Name] as NTLoginName
    ,x.Status
    ,GetDate()
    ,GetDate()
    ,GetDate()
	
FROM 
	
	dbo.ldapusers x					
		left join
    dbo.[User]	u					on x.[T Number] = u.ID
            
WHERE
 [T Number] = 'CN6066'
-- 
--CM1601
--CL9192
--CN5802
--CN4241
--CN2482
--CN2855

	--     isnull(u.ID,'') = '' -- Current Table
	--and isnull(x.[T Number],'') <> '' -- New Records
 --   And Status = '0'

/*
Added for debugging
*/
Print 'T number added '













