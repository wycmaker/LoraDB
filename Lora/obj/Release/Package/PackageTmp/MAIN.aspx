<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MAIN.aspx.cs" Inherits="Lora.MAIN" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Label ID="Label1" runat="server" Text="老人位置"></asp:Label>
        <br />
        <br />
        <asp:Button ID="Button1" runat="server" Text="現在位置" OnClick="Button1_Click" />
        &nbsp;&nbsp;&nbsp;
        <asp:Button ID="Button2" runat="server" Text="歷史資料" OnClick="Button2_Click" />
    </form>
</body>
</html>
