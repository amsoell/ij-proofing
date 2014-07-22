<!--#include file="authcheck.asp" -->
<%
  Set objConn = Application("objConnection")
  
  if Session("isAdministrator") then
    sqlx = "DELETE FROM [Task] WHERE CreatedBy=" & request("id")
    objConn.execute(sqlx)
    
    sqlx = "UPDATE [Task] SET AssignedTo=NULL, AssignmentDate=NULL WHERE AssignedTo=" & request("id")
    objConn.execute(sqlx)
    
    sqlx = "DELETE TOP (1) FROM [User] WHERE id=" & request("id")
  
    Set rs = objConn.execute(sqlx)  
%>
{ "success": true }
<% else %>
{ "success": false, "reason": "You are not an authorized administrator" }
<% end if %>