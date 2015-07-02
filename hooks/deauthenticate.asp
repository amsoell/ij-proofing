<!--#include virtual="/lib/sha256.asp"-->
{ "authenticated": false, "timestamp": "<%=Now()%>" }
<%
Session("isAuthenticated") = null
Session.abandon()
%>