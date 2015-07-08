<!--#include file="authcheck.asp" -->
<!--#include virtual="/lib/sha256.asp" -->
<%
  Set objConn = Application("objConnection")

  if len(request("username"))>0 then
    sqlx = "SELECT Username FROM [User] WHERE Username='" & request("username") & "' AND id<>" & request("id")
    Set rs = objConn.execute(sqlx)

    if not rs.eof then
      response.write "{ ""success"": false, ""reason"": ""Username already taken"" }"
      response.end
    end if
  end if

  sqlx = "UPDATE [User] SET "
  if len(request("username"))>0 then  sqlx = sqlx & "Username='" & replace(request("username"), "'", "''") & "', "
  if len(request("firstname"))>0 then sqlx = sqlx & "Firstname='" & replace(request("firstname"), "'", "''") & "', "
  if len(request("lastname"))>0 then  sqlx = sqlx & "Lastname='" & replace(request("lastname"), "'", "''") & "', "
  if len(request("address"))>0 then   sqlx = sqlx & "Address='" & replace(request("address"), "'", "''") & "', "
  if len(request("phone"))>0 then     sqlx = sqlx & "Phone='" & replace(request("phone"), "'", "''") & "', "
  if len(request("password"))>0 then  sqlx = sqlx & "Password='" & sha256(request("password")) & "', "

  if Session("AdminLevel") and (Session("AdminLevel")>=cint(request("administrator"))) then
    if len(request("administrator"))>0 then
      sqlx = sqlx & "Administrator=" & request("administrator") & ", "
    else
      sqlx = sqlx & "Administrator=0, "
    end if
  end if

  if len(request("compensation"))>0 then sqlx = sqlx & "Compensation='" & replace(request("compensation"), "'", "''") & "', "
  if len(request("email"))>0 then        sqlx = sqlx & "Email='" & replace(request("email"), "'", "''") & "', "

  sqlx = left(sqlx, len(sqlx)-2)
  sqlx = sqlx & "WHERE id=" & request("id")

  objConn.execute(sqlx)
%>
<!--#include file="users.asp" -->