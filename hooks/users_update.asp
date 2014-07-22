<!--#include file="authcheck.asp" -->
<!--#include file="../lib/sha256.asp" -->
<%
  Set objConn = Application("objConnection")
  
  sqlx = "UPDATE [User] SET "
  sqlx = sqlx & "Username='" & replace(request("username"), "'", "''") & "', "
  sqlx = sqlx & "Fullname='" & replace(request("fullname"), "'", "''") & "', " 
  
  if len(request("password"))>0 then
    sqlx = sqlx & "Password='" & sha256(request("password")) & "', "
  end if
  
  if Session("isAdministrator") then
    if request("administrator")="true" then
      sqlx = sqlx & "Administrator=1, "
    else
      sqlx = sqlx & "Administrator=0, "
    end if
  end if
   
  sqlx = sqlx & "Email='" & replace(request("email"), "'", "''") & "' "    
  sqlx = sqlx & "WHERE id=" & request("id")
  
  objConn.execute(sqlx)
%>
<!--#include file="users.asp" --> 