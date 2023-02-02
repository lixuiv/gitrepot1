<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url=""+request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()
            +request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=url%>">
    <title>Title</title>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
</head>
<body>
<script type="text/javascript">
    $(function () {
        $("#downloadBtn").click(function () {
            window.location.href="workbench/activity/fileDownloadTest";
        })

        //入口函数的尾巴
    })
</script>
<input type="button" value="下载文件" id="downloadBtn"><br><br><br>

<h1>文件上传</h1>
<form action="workbench/activity/fileUploadTest" method="post" enctype="multipart/form-data">
    上传文件：<input type="file" name="uploadTest"><br>
    文件名：<input type="text" name="fileName"><br>
    <input type="submit" value="submit"><br>
</form>
</body>
</html>
