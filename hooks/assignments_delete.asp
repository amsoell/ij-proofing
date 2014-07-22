<!--#include file="authcheck.asp" -->
<%
  Set objConn = Application("objConnection")
  
  sqlx = "DELETE TOP (1) FROM Task WHERE id=" & request("id") & " AND CreatedBy=" & Session("id")

  Set rs = objConn.execute(sqlx)
  
%>
{ "success": true }