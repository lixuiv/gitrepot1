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

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		$("#fuzzyQueryConvertText").keyup(function () {
			var clueId = "${clue.id}";
			var fuzzyText=$("#fuzzyQueryConvertText").val().trim();
			$.ajax({
				url:"workbench/clue/fuzzyQueryForConvert",
				type:"post",
				data:{
					"clueId":clueId,
					"fuzzyText":fuzzyText
				},
				dataType:'json',
				success:function (data) {
					if (data.code=="1"){
						var htmlStr=""
						$.each(data.object,function () {
							htmlStr+="<tr>";
							htmlStr+="	<td><input type=\"radio\" activityName=\""+this.name+"\"  value=\'"+this.id+"\' name=\"activity\"/></td>";
							htmlStr+="	<td>"+this.name+"</td>";
							htmlStr+="	<td>"+this.startDate+"</td>";
							htmlStr+="	<td>"+this.endDate+"</td>";
							htmlStr+="	<td>"+this.owner+"</td>";
							htmlStr+="</tr>";
						})


						$("#fuzzyConvertTBody").html(htmlStr)
					}
				}
			})
		})

		$("#fuzzyQueryA").click(function () {
			$("#searchActivityModal").modal("show")
		})

		$("#fuzzyConvertTBody").on("click","input[type='radio']",function () {
			$("#activityIDForFuzzy").val(this.name)
			$("#activity").val($(this).attr("activityName"))
		})

		//给转换按钮添加事件
		$("#clueConvertBtn").click(function () {
			//获取参数
			var clueId="${clue.id}"
			var isCreateTran=$("#isCreateTransaction").prop("checked")
			var money = $("#amountOfMoney").val();
			var name = $("#tradeName").val();
			var expectedDate = $("#expectedClosingDate").val();
			var stage = $("#stage").val();
			var activityId = $("#activityIDForFuzzy").val();
			//检验参数
			//发送请求
			$.ajax({
				url:"workbench/clue/clueConvertByConvertBtn",
				type:"post",
				data:{
					"clueId":clueId,
					"isCreateTran":isCreateTran,
					"money":money,
					"name":name,
					"expectedDate":expectedDate,
					"stage":stage,
					"activityId":activityId
				},
				dataType:'json',
				success:function (data) {
					if (data.code=="1"){
						window.location.href="workbench/clue/toClueIndex"
					}else{
						alert("转换失败...")
					}
				}
			})

		})
		//wei ba
	});
</script>

</head>
<body>

	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="fuzzyQueryConvertText" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="fuzzyConvertTBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullname}${clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >

		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="${clue.company}-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control" id="expectedClosingDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
		    	<c:forEach items="${stage}" var="st">
					<option value="${st.id}">${st.value}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="fuzzyQueryA" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
			<input type="hidden" id="activityIDForFuzzy">
			<input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
		  </div>
		</form>

	</div>

	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input id="clueConvertBtn" class="btn btn-primary" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>
