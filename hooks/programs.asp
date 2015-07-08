<!--#include virtual="/hooks/authcheck.asp" -->
<!--#include virtual="/lib/json.asp" -->
<%
  Set objConn = Application("objConnection")

  sqlx = "SELECT ProgramNum, ProgramName FROM [Program] ORDER BY ProgramName"

  Set rs = objConn.execute(sqlx)

  if not rs.eof then
    response.write "{ ""success"": true, ""programs"": [ "

    while not rs.eof

      program_num              = rs("ProgramNum")
      program_name        = rs("ProgramName")
%>
    {
        "program_num": <%=program_num%>,
        "program_name": "<%=escapeJSON(program_name)%>"
    }
<%
      rs.movenext
      if not rs.eof then response.write ","
    wend
    response.write " ] }"
  else
%>
  { "success": false, "reason": "No programs found" }
<%
  end if
%>