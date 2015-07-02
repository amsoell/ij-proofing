<!--#include file="authcheck.asp" -->
<!--#include virtual="/lib/sha256.asp" -->
<!--#include virtual="/lib/json.asp" -->
<%
  Set objConn = Application("objConnection")


  if Session("AdminLevel")>0 then
    '' check username availiability
    sqlx = "SELECT Username FROM [User] WHERE Username='" & request("username") & "'"
    Set rs = objConn.execute(sqlx)

    if rs.eof then

      '' add in expectedelivery and requestedreturn
      sqlx = "EXEC spCreateUser '" & replace(request("username"), "'", "''") & "', '" & replace(request("firstname"), "'", "''") & "', '" & replace(request("lastname"), "'", "''") & "', '" & replace(request("email"), "'", "''") & "', '" & replace(request("compensation"), "'", "''") & "', '" & replace(request("address"), "'", "''") & "', '" & replace(request("phone"), "'", "''") & "', '" & sha256(request("password")) & "'"
      if request("administrator")>0 then
        if cint(request("administrator"))<=Session("AdminLevel") then
          sqlx = sqlx & ", " & request("administrator")
        else
          errMsg = "Your security level isn't high enough to give that level of permissions: level " & Session("AdminLevel") & " trying to add level " & request("administrator")
        end if
      end if

      Set rs = objConn.execute(sqlx)

      if not rs.eof then
        id              = rs("id")
        username        = rs("username")
        fullname        = rs("firstname") & " " & rs("lastname")
        firstname       = rs("firstname")
        lastname        = rs("lastname")
        email           = rs("email")
        compensation    = rs("compensation")
        address         = rs("address")
        phone           = rs("phone")
        if rs("administrator")>0 then
          administrator = rs("administrator")
        else
          administrator = 0
        end if
%>
{
    "success": true,
<%
        if len(errMsg)>0 then
%>
    "notice": "<%=escapeJSON(errMsg)%>",
<%
        end if
%>
    "id": <%=id%>,
    "username": "<%=escapeJSON(username)%>",
    "fullname": "<%=escapeJSON(fullname)%>",
    "firstname": "<%=escapeJSON(firstname)%>",
    "lastname": "<%=escapeJSON(lastname)%>",
    "email": "<%=escapeJSON(email)%>",
    "compensation": "<%=escapeJSON(compensation)%>",
    "address": "<%=escapeJSON(address)%>",
    "phone": "<%=escapeJSON(phone)%>",
    "administrator": <%=administrator%>
}
<%    else %>
{ "success": false, "reason": "User object not returned" }
<%    end if %>
<%  else %>
{ "success": false, "reason": "Username already taken" }
<%  end if%>
<%else %>
{ "success": false, "reason": "You are not an authorized administrator" }
<%end if %>

