<!--#include file="authcheck.asp" -->
<%
  Set objConn = Application("objConnection")
  
  sqlx = "UPDATE Task SET "
  sqlx = sqlx & "Description='" & replace(request("description"), "'", "''") & "', "
  sqlx = sqlx & "ExpectedDelivery='" & replace(request("expected_delivery"), "'", "''") & "', "  
  sqlx = sqlx & "RequestedReturn='" & replace(request("requested_return"), "'", "''") & "', "    
  sqlx = sqlx & "CreationDate=CreationDate WHERE id=" & request("id")
  objConn.execute(sqlx)
%>
<!--#include file="assignments.asp" --> 