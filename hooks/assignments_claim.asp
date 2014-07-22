<!--#include file="authcheck.asp" -->
<%
  Set objConn = Application("objConnection")
  
  sqlx = "UPDATE Task SET "
  sqlx = sqlx & "AssignedTo=" & replace(Session("id"), "'", "''") & ", "
  sqlx = sqlx & "AssignmentDate=CURRENT_TIMESTAMP, "   
  sqlx = sqlx & "CreationDate=CreationDate WHERE id=" & request("id") & " AND AssignedTo IS NULL AND CreatedBy<>" & Session("id")

  objConn.execute(sqlx)
%>
<!--#include file="assignments.asp" -->