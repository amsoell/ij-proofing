<!--#include virtual="/hooks/authcheck.asp" -->
<!--#include virtual="/lib/json.asp" -->
<%
  Set objConn = Application("objConnection")

  sqlx = "SELECT CaseNum, CaseName FROM [Case] ORDER BY CaseNum"

  Set rs = objConn.execute(sqlx)

  if not rs.eof then
    response.write "{ ""success"": true, ""cases"": [ "

    while not rs.eof

      case_num              = rs("CaseNum")
      case_name        = rs("CaseName")
%>
    {
        "case_num": "<%=case_num%>",
        "case_name": "<%=escapeJSON(case_name)%>"
    }
<%
      rs.movenext
      if not rs.eof then response.write ","
    wend
    response.write " ] }"
  else
%>
  { "success": false, "reason": "No cases found" }
<%
  end if
%>