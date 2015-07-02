<!--#include file="authcheck.asp" -->
<!--#include virtual="/lib/sha256.asp" -->
<%
  Set objConn = Application("objConnection")

  sqlx = "UPDATE [User] SET "
  sqlx = sqlx & "Username='" & replace(request("username"), "'", "''") & "', "
  sqlx = sqlx & "Firstname='" & replace(request("firstname"), "'", "''") & "', "
  sqlx = sqlx & "Lastname='" & replace(request("lastname"), "'", "''") & "', "
  sqlx = sqlx & "Address='" & replace(request("address"), "'", "''") & "', "
  sqlx = sqlx & "Phone='" & replace(request("phone"), "'", "''") & "', "

  if len(request("password"))>0 then
    sqlx = sqlx & "Password='" & sha256(request("password")) & "', "
  end if

  if Session("AdminLevel") and (Session("AdminLevel")>=cint(request("administrator"))) then
    if len(request("administrator"))>0 then
      sqlx = sqlx & "Administrator=" & request("administrator") & ", "
    else
      sqlx = sqlx & "Administrator=0, "
    end if
  end if

  sqlx = sqlx & "Compensation='" & replace(request("compensation"), "'", "''") & "', "
  sqlx = sqlx & "Email='" & replace(request("email"), "'", "''") & "' "
  sqlx = sqlx & "WHERE id=" & request("id")

  objConn.execute(sqlx)
%>
<!--#include file="users.asp" -->