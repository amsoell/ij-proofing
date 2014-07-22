<!--#include file="authcheck.asp" -->
<%
  Set objConn = Application("objConnection")
  
  sqlx = "UPDATE Task SET "
  sqlx = sqlx & "AssignedTo=NULL, "
  sqlx = sqlx & "AssignmentDate=NULL, "   
  sqlx = sqlx & "CreationDate=CreationDate WHERE id=" & request("id") & " AND AssignedTo IS NOT NULL and CompletionDate IS NULL AND (AssignedTo=" & Session("id") & " OR CreatedBy=" & Session("id") & ")"

  objConn.execute(sqlx)
%>
<!--#include file="assignments.asp" -->