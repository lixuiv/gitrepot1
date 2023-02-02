<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String url=""+request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()
            +request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=url%>">
<meta charset="UTF-8">
    <title>Title</title>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">
        $(function () {
            //begin
            $("#typeaheadText").typeahead({
                source:function (jquery, process) {
                    $.ajax({
                        url:'https://www.baidu.com/s',
                        type:'get',
                        data:{wd:123},
                        dataType:'json',
                        success:function (data) {
                            process(data)
                        }
                    })
                }
            })

            //end
        })
    </script>
</head>
<body>
<input type="text" id="typeaheadText">
</body>
</html>
