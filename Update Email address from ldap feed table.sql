Use adppCTU2012
set nocount on
--  script to update user's last name and email address when it does not match the UserLoad fro LDAP

declare curTemp cursor for 
	SELECT     zxtblUserLoad.[T Number], zxtblUserLoad.Email, zxtblUserLoad.Lastname
	FROM         zxtblUserLoad INNER JOIN
						  UserTEST ON zxtblUserLoad.[T Number] = UserTEST.ID AND zxtblUserLoad.Lastname <> UserTEST.LastName
	WHERE     (LEN(zxtblUserLoad.Email) > 6) 
declare @tnum as varchar(6)
declare @email as varchar(200)
declare @lastname as varchar(200)

-- read initial value in
Open Curtemp

Fetch next from curtemp
into @Tnum,@email,@Lastname
While @@fetch_status = 0
Begin
	Select emailaddress
	From UserTest
	Where ID = @Tnum

	Update UserTest
	Set LastName = @Lastname, EmailAddress =@email
	Where ID = @Tnum

	Select emailaddress
	From UserTest
	Where ID = @Tnum
	
	

	Fetch next from curtemp
	into @Tnum,@email,@Lastname
End

-- Update the record in Users based on T# matching ID field


close curtemp
deallocate curtemp
