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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">
    $(function () {
        $("#findMarketActivityA").click(function () {
            $("#findMarketActivity").modal("show")
        })
        $("#findContactsA").click(function () {
            $("#findContacts").modal("show")
        })

        $("#fuzzyQueryInput").keyup(function () {
            var value = this.value.trim();
            $.ajax({
                url:'workbench/transaction/fuzzyQueryForSave',
                type:'post',
                data:{"value":value},
                dataType:'json',
                success:function (data) {
                    var htmlStr=""
                    $.each(data,function () {
                        htmlStr+="<tr>";
                        htmlStr+="    <td><input value=\'"+this.id+"\' activityName=\""+this.name+"\" type=\"radio\" name=\"activity\"/></td>";
                        htmlStr+="    <td>"+this.name+"</td>";
                        htmlStr+="    <td>"+this.startDate+"</td>";
                        htmlStr+="    <td>"+this.endDate+"</td>";
                        htmlStr+="    <td>"+this.owner+"</td>";
                        htmlStr+="</tr>";
                    })
                    $("#fuzzyTbody").html(htmlStr);
                }
            })
        })
        $("#fuzzyTbody").on("click","input",function () {
            var activityId = this.value;
            var activityName = $(this).attr("activityName");
            $("#create-activitySrcId").val(activityId)
            $("#create-activitySrc").val(activityName)
        })

        //可能性
        $("#create-transactionStage").change(function () {
            var optionValue = $("#create-transactionStage>option:selected").text();
            if (optionValue==''){
                return;
            }
            $.ajax({
                url:'workbench/transaction/optionValuePossible',
                type:'post',
                data:{"optionValue":optionValue},
                dataType:'json',
                success:function (data) {
                    $("#create-possibility").val(data+"%")
                }
            })
        })
        //自动补全
        $("#create-accountName").typeahead({
            source:function (jquery, process) {
                $.ajax({
                    url:'workbench/transaction/typeaheadText',
                    type:'post',
                    data:{"fuzzyName":jquery},
                    dataType:'json',
                    success:function (data) {
                        process(data)
                    }
                })
            }
        })
        //发送保存的请求
        $("#saveTranBtn").click(function () {
            //收集参数
            var owner=$("#create-transactionOwner").val().trim();
            var money=$("#create-amountOfMoney").val().trim();
            var name=$("#create-transactionName").val().trim();
            var expectedDate=$("#create-expectedClosingDate").val().trim();
            var customerName=$("#create-accountName").val().trim();
            var stage=$("#create-transactionStage").val().trim();
            var type=$("#create-transactionType").val().trim();
            var source=$("#create-clueSource").val().trim();
            var activityId=$("#create-activitySrcId").val().trim();
            var contactsId=$("#create-contactsNameId").val().trim();
            var description=$("#create-describe").val().trim();
            var contactSummary=$("#create-contactSummary").val().trim();
            var nextContactTime=$("#create-nextContactTime").val().trim();
            //检验参数的合法性
            //发送请求
            $.ajax({
                url:'workbench/transaction/saveTransaction',
                type:'post',
                data:{
                    "owner":owner,
                    "money":money,
                    "name":name,
                    "expectedDate":expectedDate,
                    "customerName":customerName,
                    "stage":stage,
                    "type":type,
                    "source":source,
                    "activityId":activityId,
                    "contactsId":contactsId,
                    "description":description,
                    "contactSummary":contactSummary,
                    "nextContactTime":nextContactTime
                },
                dataType:'json',
                success:function (data) {
                    if (data.code=="1"){
                        window.location.href="workbench/transaction/toTranIndex"
                    }else{
                        alert("保存错误...")
                    }
                }
            })
        })
        //end
    })
</script>
</head>
<body>

	<!-- 查找市场活动 -->
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="fuzzyQueryInput" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="fuzzyTbody">
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

	<!-- 查找联系人 -->
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>


	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveTranBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
                    <c:forEach items="${userList}" var="u">
                        <option value="${u.id}">${u.name}</option>
                    </c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>

		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-expectedClosingDate">
			</div>
		</div>

		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
			  	<option></option>
                  <c:forEach items="${stage}" var="s">
                      <option value="${s.id}">${s.value}</option>
                  </c:forEach>
			  </select>
			</div>
		</div>

		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
                    <c:forEach items="${transactionType}" var="tranType">
                        <option value="${tranType.id}">${tranType.value}</option>
                    </c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" readonly>
			</div>
		</div>

		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <option></option>
                    <c:forEach items="${source}" var="sour">
                        <option value="${sour.id}">${sour.value}</option>
                    </c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="findMarketActivityA"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
                <input type="hidden" id="create-activitySrcId">
				<input type="text" class="form-control" id="create-activitySrc">
			</div>
		</div>

		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="findContactsA"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
                <input type="hidden" id="create-contactsNameId" value="8d2716cd6bbf4525bf1786ce89821a7a">
				<input type="text" class="form-control" id="create-contactsName" value="秋水">
			</div>
		</div>

		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-nextContactTime">
			</div>
		</div>

	</form>
</body>
</html>
