<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<title>门票短信模板编辑</title>
<link href="${base}/resources/admin/css/common.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/admin/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/admin/editor/kindeditor.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/admin/js/input.js"></script>
<script type="text/javascript" src="${base}/resources/admin/datePicker/WdatePicker.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");

    // 表单验证
    $inputForm.validate({
        rules: {
            moduleId: "required",
            templateType: "required",
            name: "required",
            signName: "required",
            templateCode: "required",
            content: "required"
        }
    });
	
	$(".tag .button").click(function(){
		var v = $(this).val();
		$("#content").val($("#content").val()+v);
	});
	
});
</script>
</head>
<body>
	<div class="path main">
	    <div class="con_head bg_deepblue">
			编辑短信模板
	    </div>
	</div>
	<form id="inputForm" action="update" method="post">
		<input type="hidden" name="id" value="${dto.id}" />
		<table class="input">
            <tr>
                <th>
                    所属模块:
                </th>
                <td>
                    <select name="moduleId">
					<#list moduleList as module>
                        <option <#if module.id == dto.moduleId>selected</#if> value="${module.id}">${module.moduleName!}</option>
					</#list>
                    </select>
                </td>
            </tr>
			<tr>
				<th>
					模板类型:
				</th>
				<td>
					<select name="templateType">
						<option value="">请选择</option>
						<#list types as type>
						<option value="${type!}"<#if dto.templateType == type> selected</#if>>${type.getName()!}</option>
						</#list>
					</select>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>模板名称:
				</th>
				<td>
					<input type="text" name="name" class="text" maxlength="200" value="${dto.name!}" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>模板CODE:
				</th>
				<td>
					<input type="text" name="templateCode" value="${dto.templateCode!}" class="text" maxlength="20" />
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>模板签名:
				</th>
				<td>
				<select name="signName">
						<option value="启明芯"<#if dto.signName == '启明芯'> selected</#if>>启明芯</option>
						<option value="游乐园"<#if dto.signName == '游乐园'> selected</#if> >游乐园</option>
						<option value="景区"<#if dto.signName == '景区'] selected</#if>>景区</option>
						<option value="云游宝"<#if dto.signName == '云游宝'> selected</#if>>云游宝</option>
				</select>
				</td>
			</tr>
			<tr>
				<th>
					<span class="requiredField">*</span>模板内容:
				</th>
				<td>
					<textarea id="content" class="text" name="content">${dto.content!}</textarea>
					<br/>
					<span class="tips">cardNo:票号，num:数量，orderPhone:预定电话，flag:标识，contactName：游客姓名，validDate:有效期，servicePhone:服务电话，useDate:使用日期，num2:二维码票号，consultPhone:咨询电话，productName:产品名称</span>
				</td>
			</tr>
			<tr>
				<th>
					&nbsp;
				</th>
				<td>
					<input type="submit" class="button" value="提交" />
					<input type="button" class="button" value="返回" onclick="history.back();" />
				</td>
			</tr>
		</table>
	</form>
</body>
</html>