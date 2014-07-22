<%
  if Session("isAuthenticated")<>1 then
    response.write "{ ""authenticated"": false }"
    response.End
  end if
%>