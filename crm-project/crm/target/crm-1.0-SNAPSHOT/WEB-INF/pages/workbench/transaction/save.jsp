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

        //?????????
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
        //????????????
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
        //?????????????????????
        $("#saveTranBtn").click(function () {
            //????????????
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
            //????????????????????????
            //????????????
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
                        alert("????????????...")
                    }
                }
            })
        })
        //end
    })
</script>
</head>
<body>

	<!-- ?????????????????? -->
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">??</span>
					</button>
					<h4 class="modal-title">??????????????????</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="fuzzyQueryInput" type="text" class="form-control" style="width: 300px;" placeholder="????????????????????????????????????????????????">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>??????</td>
								<td>????????????</td>
								<td>????????????</td>
								<td>?????????</td>
							</tr>
						</thead>
						<tbody id="fuzzyTbody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>?????????</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>?????????</td>
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

	<!-- ??????????????? -->
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">??</span>
					</button>
					<h4 class="modal-title">???????????????</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="?????????????????????????????????????????????">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>??????</td>
								<td>??????</td>
								<td>??????</td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>??????</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>??????</td>
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
		<h3>????????????</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveTranBtn">??????</button>
			<button type="button" class="btn btn-default">??????</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">?????????<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
                    <c:forEach items="${userList}" var="u">
                        <option value="${u.id}">${u.name}</option>
                    </c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">??????</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>

		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">??????????????????<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-expectedClosingDate">
			</div>
		</div>

		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">????????????<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" placeholder="???????????????????????????????????????????????????">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">??????<span style="font-size: 15px; color: red;">*</span></label>
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
			<label for="create-transactionType" class="col-sm-2 control-label">??????</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
                    <c:forEach items="${transactionType}" var="tranType">
                        <option value="${tranType.id}">${tranType.value}</option>
                    </c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">?????????</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" readonly>
			</div>
		</div>

		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">??????</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <option></option>
                    <c:forEach items="${source}" var="sour">
                        <option value="${sour.id}">${sour.value}</option>
                    </c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">???????????????&nbsp;&nbsp;<a href="javascript:void(0);" id="findMarketActivityA"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
                <input type="hidden" id="create-activitySrcId">
				<input type="text" class="form-control" id="create-activitySrc">
			</div>
		</div>

		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">???????????????&nbsp;&nbsp;<a href="javascript:void(0);" id="findContactsA"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
                <input type="hidden" id="create-contactsNameId" value="8d2716cd6bbf4525bf1786ce89821a7a">
				<input type="text" class="form-control" id="create-contactsName" value="??????">
			</div>
		</div>

		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">??????</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">????????????</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">??????????????????</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-nextContactTime">
			</div>
		</div>

	</form>
</body>
</html>
