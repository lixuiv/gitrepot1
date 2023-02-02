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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<!--分页插件的配置-->
<!--  PAGINATION plugin -->
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){
		//点击创建的按钮弹出模态窗口
		$("#managerModalCreateBtn").click(function () {
			$("#createActivityModal").modal("show")
		})

		//创建市场活动的按钮
		$("#saveActivityBtn").click(function () {
			//保证数据的合法以及获取数据
			var owner = $("#create-marketActivityOwner").val().trim();
			var name = $("#create-marketActivityName").val().trim();
			var startDate = $("#create-startTime").val().trim();
			var endDate = $("#create-endTime").val().trim();
			var cost = $("#create-cost").val().trim();
			var description = $("#create-describe").val().trim();
			//检验数据
			if (name==''){
				$("#activityMsg").text("名字不可为空")
				return;
			}
			//检验时间是否合法
			if (startDate!=""||endDate!=""){
				var regularExp=/^\d{4}-\d{1,2}-\d{1,2}$/
				if (!regularExp.test(startDate)){
					$("#activityMsg").text("日期格式不合法，例：2021-12-21")
					return;
				}else if(!regularExp.test(endDate)){
					$("#activityMsg").text("日期格式不合法，例：2021-12-21")
					return;
				}
				if(startDate!=""&&endDate!=""){
					if (startDate>endDate){
						$("#activityMsg").text("日期的顺序不合法")
						return;
					}
				}
			}

			// 正则表达式指定字符串的格式，成本只能为非负整数
			var regExp=/^(([1-9]\d*)|0)$/
			if (!regExp.test(cost)){
				$("#activityMsg").text("金额成本只能为非负整数")
				return;
			}
			//发送ajax请求
			$.ajax({
				url:"workbench/activity/saveActivity",
				type:"POST",
				data:{
					"owner":owner,
					"name":name,
					"startDate":startDate,
					"endDate":endDate,
					"cost":cost,
					"description":description,
				},
				dataType:"json",
				success:function (data) {
					if ("0"==data.code){
						//创建失败,提示信息创建失败,模态窗口不关闭,市场活动列表也不刷新
						$("#activityMsg").text(data.message)
					}else{
						//创建成功后，关闭模态窗口,刷新市场活动列
						$("#createActivityModal").modal("hide");
						sendActivityRequestForPage(1,$("#activityDivForPage").bs_pagination('getOption', 'rowsPerPage'))
						$("#createActivityForm")[0].reset();
					}
				}
			})
			//发送ajax之后的时机
		})

		//给文本框加上日历插件功能
		$(".datetimepicker-createActivityFrom").datetimepicker({
			language:'zh-CN',
			format:'yyyy-mm-dd',
			minView:'month',
			initialDate:new Date(),
			autoclose:true,
			todayBtn:true,
			clearBtn:true
		})

		//页面窗口加载完毕后,打包数据，发送分页查询的请求
		sendActivityRequestForPage(1,10)

		//给查询按钮添加一个绑定事件
		$("#queryActivityForPage").click(function () {
			sendActivityRequestForPage(1,$("#activityDivForPage").bs_pagination('getOption', 'rowsPerPage'))
		})

		//给窗口加一个回车的监听时间
		/*$(window).keydown(function (e) {
			//alert(e.keyCode) 13
			if (e.keyCode==13){
				$("#queryActivityForPage").click();
			}
		})*/

		//给全选的checked框按钮绑定相对应的事件
		$("#allCheckRemark").click(function () {
			//alert(this.checked)
			$("#activityBodyForPage input[type='checkbox']").prop("checked",this.checked)
		})

		//给动态生成的checked框绑定单击事件
		$("#activityBodyForPage").on("click","input[type='checkbox']",function () {
			if ($("#activityBodyForPage input[type='checkbox']").size()
					==$("#activityBodyForPage input[type='checkbox']:checked").size()){
				$("#allCheckRemark").prop("checked",true)
			}else{
				$("#allCheckRemark").prop("checked",false)
			}
		})

		//给市场活动删除按钮添加点击事件函数
		$("#deleteActivityRemarkBtn").click(function () {
			if (!window.confirm("真的要删除我嘛...嘤嘤嘤")){
				return;
			}

			var idsCheckbox = $("#activityBodyForPage input[type='checkbox']:checked");
			if(idsCheckbox.size()<=0){
				alert("每次至少删除一条市场活动")
				return
			}
			//拼接好相对应的id=123& id=123& id=123的字符串
			var ids=""
			$.each(idsCheckbox,function () {
				ids+="id="+this.value+"&"
			})
			ids=ids.substr(0,ids.length-1);
			//发送请求
			$.ajax({
				url:'workbench/activity/deleteActivityRemarkByIds',
				type:'POST',
				data:ids,
				dataType:'json',
				success:function (data) {
					if (data.code==0){
						alert(data.message)
					}else{
						sendActivityRequestForPage(1,$("#activityDivForPage").bs_pagination('getOption', 'rowsPerPage'))
					}
				}
			})
		})

		//给市场活动修改按钮添加点击事件函数
		$("#editActivityInformationBtn").click(function () {
			var editCheckbox = $("#activityBodyForPage input[type='checkbox']:checked");
			if (editCheckbox.size()!=1){
				alert("每次能且只能修改一条市场活动...")
			}
			var id = editCheckbox[0].value;
			$.ajax({
				url:'workbench/activity/queryActivityById',
				type:'POST',
				data:{"id":id},
				dataType:"json",
				success:function (data) {
					//修改文本参数
					$("#edit-id").val(data.id)
					$("#edit-marketActivityOwner").val(data.owner)
					$("#edit-marketActivityName").val(data.name)
					$("#edit-startTime").val(data.startDate)
					$("#edit-endTime").val(data.endDate)
					$("#edit-cost").val(data.cost)
					$("#edit-describe").val(data.description)
					//打开修改的模块窗口
					$("#editActivityModal").modal("show");
				}
			})
		})

		//点击市场修改按钮的模块窗口的更新会更新条数
		$("#editActivityBtn").click(function () {
			//获取文本参数
			var id = $("#edit-id").val()
			var owner =$("#edit-marketActivityOwner").val()
			var name =$("#edit-marketActivityName").val().trim()
			var startDate =$("#edit-startTime").val()
			var endDate =$("#edit-endTime").val()
			var cost =$("#edit-cost").val().trim()
			var description =$("#edit-describe").val().trim()
			//检验参数是否合法
			//检验数据
			if (name==''){
				alert("名字不可为空")
				return;
			}
			//检验时间是否合法
			if (startDate!=""||endDate!=""){
				var regularExp=/^\d{4}-\d{1,2}-\d{1,2}$/
				if (!regularExp.test(startDate)){
					alert("日期格式不合法，例：2021-12-21")
					return;
				}else if(!regularExp.test(endDate)){
					alert("日期格式不合法，例：2021-12-21")
					return;
				}
				if(startDate!=""&&endDate!=""){
					if (startDate>endDate){
						alert("日期的顺序不合法")
						return;
					}
				}
			}
			// 正则表达式指定字符串的格式，成本只能为非负整数
			var regExp=/^(([1-9]\d*)|0)$/
			if (!regExp.test(cost)){
				alert("金额成本只能为非负整数")
				return;
			}

			//发送请求
			$.ajax({
				url:"workbench/activity/editActivityRemark",
				type:"POST",
				data:{
					"id":id,
					"owner":owner,
					"name":name,
					"startDate":startDate,
					"endDate":endDate,
					"cost":cost,
					"description":description,
				},
				dataType:"json",
				success:function (data) {
					if(data.code==0){
						alert(data.message)
					}else{
						$("#editActivityModal").modal("hide");
						sendActivityRequestForPage($("#activityDivForPage").bs_pagination('getOption', 'currentPage'),
								$("#activityDivForPage").bs_pagination('getOption', 'rowsPerPage'))
					}
				}
			})
		})

		//给批量导出按钮添加事件函数
		$("#exportActivityAllBtn").click(function () {
			if(!window.confirm("是否下载")){
				return;
			}
			window.location.href="workbench/activity/fileDownload";
		})

		//给选择导出按钮添加事件函数
		$("#exportActivityXzBtn").click(function (){
			//做个判断，是否下载
			if(!window.confirm("是否下载")){
				return;
			}

			var checkedBoxes = $("#activityBodyForPage input[type='checkbox']:checked");
			var ids="";
			$.each(checkedBoxes,function (){
				ids+="id="+this.value+"&";
			})
			ids=ids.substr(0,ids.length-1);
			var url="workbench/activity/fileDownload?"+ids;
			window.location.href=url;
		})

		//创造文件导入模板
		$("#importActivityModel").click(function () {
			window.location.href="workbench/activity/importActivityModel";
		})

		//导入数据的按钮添加事件
		$("#importActivityBtn").click(function () {
			var fileName = $("#activityFile").val();
			var file = $("#activityFile")[0].files[0];
			var lastSuffix = fileName.substr(fileName.lastIndexOf(".")+1).toUpperCase();
			if (lastSuffix!="XLS"){
				alert("仅支持xls格式的文件")
				return;
			}
			if (file.size>1024*1024*5){
				alert("文件最大导入为5M")
				return;
			}
			var formData = new FormData();
			formData.append("multipartFile",file)

			$.ajax({
				url:"workbench/activity/importActivityRowsByFile",
				data:formData,
				type:"POST",
				dataType:"json",
				processData:false,
				contentType:false,
				success:function (data) {
					if(data.code=="1"){
						alert(data.message)
						$("#importActivityModal").modal("hide")
						sendActivityRequestForPage(1,$("#activityDivForPage").bs_pagination('getOption', 'rowsPerPage'))
					}else{
						alert(data.message)
						$("#importActivityModal").modal("show")
					}
				}
			})
		})

		//入口函数的尾部
	});

	//发送分页查询的请求的函数
	sendActivityRequestForPage=function (pageNo,pageSize) {
		var name = $("#ActivityNameForPage").val();
		var owner = $("#ActivityOwnerForPage").val();
		var start_date = $("#ActivityStartTimeForPage").val();
		var end_date = $("#ActivityEndTimeForPage").val();
		$.ajax({
			url:'workbench/activity/queryByConditionForPage',
			type:'POST',
			data:{
				"name":name,
				"owner":owner,
				"start_date":start_date,
				"end_date":end_date,
				"pageNo":pageNo,
				"pageSize":pageSize
			},
			dataType: 'json',
			success:function (data) {
				var htmlStr="";
				$.each(data.activities,function (index, item) {
					htmlStr+="<tr class=\"active\">";
					htmlStr+="	<td><input type=\"checkbox\" value='"+item.id+"'/></td>";
					htmlStr+="	<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/toDetail?id="+item.id+"';\">"+item.name+"</a></td>";
					htmlStr+="	<td>"+item.owner+"</td>";
					htmlStr+="	<td>"+item.startDate+"</td>";
					htmlStr+="	<td>"+item.endDate+"</td>";
					htmlStr+="</tr>";
				})

				//对于下一页查询checkbox框没有全选的bug调式

				//给装分页查询容器值的body赋值
				$("#activityBodyForPage").html(htmlStr);
				//计算有多少页
				var totalPages=1;
				if(data.totalRows%pageSize==0){
					totalPages=data.totalRows/pageSize
				}else {
					totalPages=parseInt(data.totalRows/pageSize)+1
				}
				//给分页插件准备的容器赋值
				$("#activityDivForPage").bs_pagination({
					currentPage: pageNo,

					rowsPerPage: pageSize,
					totalPages: totalPages,
					totalRows: data.totalRows,

					visiblePageLinks: 5,

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					// returns page_num and rows_per_page after a link has clicked
					onChangePage: function(event,pageObj) {
						sendActivityRequestForPage(pageObj.currentPage,pageObj.rowsPerPage);
						$("#allCheckRemark").prop("checked",false);
					}
				});
			}
		})
	}

</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form" id="createActivityForm">

						<div class="form-group">
							<label  for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control datetimepicker-createActivityFrom" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control datetimepicker-createActivityFrom" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						<span id="activityMsg" style="color: red;position: absolute;left: 180px"></span>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveActivityBtn" type="button" class="btn btn-primary" >保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id"/>
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control datetimepicker-createActivityFrom" id="edit-startTime" value="2020-10-10" readonly>
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control datetimepicker-createActivityFrom" id="edit-endTime" value="2020-10-20" readonly>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="editActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                            <li>导入文件的模板:<input type="button" id="importActivityModel" value="importTemplate"></li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>


	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
			<!--查询框-->
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="ActivityNameForPage">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="ActivityOwnerForPage">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="ActivityStartTimeForPage" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="ActivityEndTimeForPage">
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryActivityForPage">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<!--弹出/调用模态窗口的按钮-->
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="managerModalCreateBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityInformationBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"  id="deleteActivityRemarkBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<!--分页查询展示框-->
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="allCheckRemark"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBodyForPage">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="activityDivForPage"></div>
			</div>

				<%--页数/总数 按钮页面--%>
<%--			<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
			</div>--%>

		</div>

	</div>
</body>
</html>
