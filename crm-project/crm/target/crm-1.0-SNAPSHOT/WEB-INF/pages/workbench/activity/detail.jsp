<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String url=""+request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort() +request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=url%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;

	$(function(){
		$("#activityRemarkDetail").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});

		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		/*$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});*/
		$("#remarkListDivFather").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		})

		/*$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});*/
		$("#remarkListDivFather").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		})

		/*$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});*/
		$("#remarkListDivFather").on("mouseover",".myHref",function () {
			$(this).children("span").css("color","red");
		})

		/*$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});*/
		$("#remarkListDivFather").on("mouseout",".myHref",function () {
			$(this).children("span").css("color","#E6E6E6");
		})

		$("#saveRemarkDetailBtn").click(function () {
			var noteContent = $("#activityRemarkDetail").val().trim();
			var activityId = "${activity.id}";
			if (noteContent==null||noteContent==''){
				alert("备注不能为空...")
				return;
			}
			$.ajax({
				url:'workbench/activity/createRemarkDetail',
				type:'POST',
				data:{
					"activityId":activityId,
					"noteContent":noteContent
				},
				dataType:'json',
				success:function (data) {
					if (data.code="1"){
						var htmlStr="";

							htmlStr+="<div id='div_${remark.id}' class=\"remarkDiv\" style=\"height: 60px;\">";
							htmlStr+="	<img title=\"${activity.owner}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
							htmlStr+="	<div style=\"position: relative; top: -40px; left: 40px;\" >";
							htmlStr+="	<h5>"+data.object.noteContent+"</h5>";
							htmlStr+="		<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${activity.name}</b> " +
									"<small editNameSmall=\"edit\" style=\"color: gray;\">"+data.object.createTime+" 由${sessionScope.loginUser.name}创建</small>";
							htmlStr+="		<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
							htmlStr+="			<a class=\"myHref\" name=\"editA\" remarkId=\""+data.object.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" " +
									"style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr+="			&nbsp;&nbsp;&nbsp;&nbsp;";
							htmlStr+="			<a class=\"myHref\" name=\"deleteA\" remarkId=\""+data.object.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" " +
									"style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr+="		</div>";
							htmlStr+="	</div>";
							htmlStr+="</div>";
							$("#remarkDiv").before(htmlStr)
						$("#activityRemarkDetail").val("");
					}else{
						alert("添加备注失败...")
					}
				}
			})
		})

		//name=\"deleteA\"

		//第四个功能：给所有删除/修改按钮添加点击事件
		$("#remarkListDivFather").on("click"," a[name='deleteA']",function () {
			var remarkId = $(this).attr("remarkId");
			//alert(remarkId)
			$.ajax({
				url:'workbench/activity/deleteRemarkById',
				type:'POST',
				data:{id:remarkId},
				dataType: 'json',
				success:function (data) {
					if (data.code=="1"){
						var deleteId="#div_"+remarkId
						$(deleteId).remove()
					}else{
						alert("删除失败...")
					}
				}
			})
		})
		$("#remarkListDivFather").on("click"," a[name='editA']",function () {
			//alert(222)
			$("#remarkId").val($(this).attr("remarkId"))
			$("#editRemarkModal").modal("show")
		})


		//第七个功能，修改的第二段内容，点击更新内容修改备注
		$("#updateRemarkBtn").click(function () {
			var remarkId = $("#remarkId").val();
			//alert(remarkId)
			var text = $("#noteContent").val().trim();
			if (text==""){
				alert('内容不可为空')
				return
			}
			$.ajax({
				url:'workbench/activity/editActivityRemarkById',
				type:'POST',
				data:{
					"id": remarkId,
					"noteContent":text
				},
				dataType:'json',
				success:function (data) {
					if (data.code=="1"){
						$("#div_"+remarkId+" h5").html(text)
						var htmlEdit=data.object.editTime+"由${sessionScope.loginUser.name}修改"
						$("#div_"+remarkId+" small[editNameSmall='edit']").html(htmlEdit)
						$("#editRemarkModal").modal("hide")
						$("#noteContent").val("")
					}else{
						alert("修改失败")
						$("#editRemarkModal").modal("show")
					}
				}
			})
		})
	});

</script>

</head>
<body>
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="noteContent" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>

	</div>
	<br/>
	<br/>
	<br/>
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>

	<!-- 备注 -->
	<div id="remarkListDivFather" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<!-- 遍历控制器传过来的备注集合 -->
		<c:forEach items="${activityRemarks}" var="remark" >
			<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${activity.owner}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${remark.noteContent}</h5>
					<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small editNameSmall="edit" style="color: gray;">
						${remark.editFlag=="1"?remark.editTime:remark.createTime} 由${remark.editFlag=="1"?remark.editBy:remark.createBy}
						${remark.editFlag=="1"?"修改":"创建"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="editA" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="deleteA" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>
		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>${activityRemark.}</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>


		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="activityRemarkDetail" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button type="button" class="btn btn-default"  id="cancelBtn">取消</button>
					<button type="button" class="btn btn-primary"  id="saveRemarkDetailBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>
