<!--#include file="authcheck.asp" -->
<%
  Set objConn = Application("objConnection")
  
  if IsNumeric(request("time_to_complete")) then
    sqlx = "UPDATE Task SET "
    sqlx = sqlx & "TimeToComplete=" & request("time_to_complete") & ", "
    sqlx = sqlx & "CompletionDate=CURRENT_TIMESTAMP, "
    sqlx = sqlx & "CreationDate=CreationDate WHERE id=" & request("id") & " AND AssignedTo IS NOT NULL AND (CreatedBy=" & Session("id") & " OR AssignedTo=" & Session("id") & ")"
    objConn.execute(sqlx)
  else
    response.write "{ ""success"": false }"
    response.end
  end if
%>
<!--#include file="assignments.asp" --> 