<!--#include file="authcheck.asp" -->
<!--#include file="../lib/sha256.asp" -->
<%
  Set objConn = Application("objConnection")
  
  
  if Session("isAdministrator") then
    '' add in expectedelivery and requestedreturn
    sqlx = "EXEC spCreateUser '" & replace(request("username"), "'", "''") & "', '" & replace(request("fullname"), "'", "''") & "', '" & replace(request("email"), "'", "''") & "', '" & sha256(request("password")) & "'"
    if request("administrator")="true" then
      sqlx = sqlx & ", 1"
    end if
    
    Set rs = objConn.execute(sqlx)
    
    if not rs.eof then
      id              = rs("id")
      username        = rs("username")
      fullname        = rs("fullname")
      email           = rs("email")
      if rs("administrator")>0 then
        administrator = "true"
      else  
        administrator = "false"
      end if
%>
{
    "success": true,
    "id": <%=id%>,
    "username": "<%=replace(username, """", "\""")%>",
    "fullname": "<%=replace(fullname&"", """", "\""")%>",
    "email": "<%=replace(email&"", """", "\""")%>",
    "administrator": <%=administrator%>
}
<%   else %>
{ "success": false, "reason": "User object not returned" }
<%   end if %>
<% else %>
{ "success": false, "reason": "You are not an authorized administrator" }
<% end if %>

