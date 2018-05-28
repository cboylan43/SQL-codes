Use Adppctu2012

create table #Names (
Userid int,
email nvarchar(250),
lname nvarchar(250),
ion nvarchar(250)
)
Insert into #names (userid,email,lname, ion)
Select [User].userid,zxtblUserLoad.Email, zxtblUserLoad.Lastname, zxtblUserLoad.[NT Login Name]
--SELECT     zxtblUserLoad.[T Number], zxtblUserLoad.Email, zxtblUserLoad.Lastname,[User].userid
	FROM         zxtblUserLoad INNER JOIN
						  [User] ON zxtblUserLoad.[T Number] = [User].ID AND zxtblUserLoad.Lastname <> [User].LastName
	WHERE     (LEN(zxtblUserLoad.Email) > 6) And [User].userid = 957

Select *
From #names
Update Usertest
	Set LastName = #names.lname, EmailAddress =#names.email, oldaccount = ion
	From #names Join usertest on #names.userid =usertest.userid
	
drop table #names
