<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%
		String schema=request.getScheme();
		String ip=request.getServerName();
		int port = request.getServerPort();
		String contextPath = request.getContextPath();
		String url=schema+"://"+ip+":"+port+contextPath+"/";
	%>
	<base href="<%=url%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(function () {
		$(window).keydown(function (e) {
			//回车键的键值是13
			//alert(e.keyCode)
			if (13==e.keyCode){
				$("#login").click()
			}
		})

		$("#login").click(function () {
			//获取参数
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());
			var isRemPwd = $("#isRemPwd").prop("checked");
			//发送请求前对于数据进行判断
			if (loginAct==""){
				$("#msg").text("用户名不能为空")
				return;
			}
			if (loginPwd==""){
				$("#msg").text("密码不能为空")
				return;
			}
			//这里才可以发送请求
			$.ajax({
				url:"settings/qx/user/Login",
				type:"POST",
				data:{
					"loginAct":loginAct,
					"loginPwd":loginPwd,
					"isRemPwd":isRemPwd
				},
				dataType:"json",
				success:function (data){
					var code = data.code;
					if ("0"==code){
						var message = data.message;
						$("#msg").html(message)
					}else{
						window.location.href="workbench/toIndex"
					}
				},
				beforeSend:function (){
					$("#msg").html("Login...Please waiting")
				}
			})

		})

	})
</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2023&nbsp;秋景之愿</span></div>
	</div>

	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index" class="form-horizontal" role="form" >
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input id="loginAct" value="${cookie.loginAct.value}" class="form-control" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input id="loginPwd" value="${cookie.loginPwd.value}" class="form-control" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
								<input id="isRemPwd" type="checkbox" checked="true"> 记住密码
							</c:if>
							<c:if test="${empty cookie.loginAct or  empty cookie.loginPwd}">
								<input id="isRemPwd" type="checkbox" > 记住密码
							</c:if>
						</label>
						&nbsp;&nbsp;
						<span id="msg" style="color: #ff0000"></span>
					</div>
					<button type="button" id="login" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>
