<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
    <script>
        //注意：parent 是 JS 自带的全局对象，可用于操作父页面
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        //关闭iframe
        $(document).on("click", "#closeIframe", function () {
            parent.layer.close(index);
        });
        //提交iframe
        $(document).on("click", "#submitIframe", function () {
            var $checkedId = $("input[name='ids']:enabled:checked");
            if ("1" == "${type}") {
                parent.$("#userId").val($checkedId.val());
                parent.$("#userIdName").html($checkedId.parents("tr:eq(0)").find("td:eq(1)").text());
            } else if ("2" == "${type}") {
                parent.$("#manager").val($checkedId.val());
                parent.$("#managerName").html($checkedId.parents("tr:eq(0)").find("td:eq(1)").text());
            }
            parent.layer.close(index);
        });
    </script>
    <script>
        /*$(document).ready(function (e) {
            $("#selectAll").click(function () {
                if (this.checked) {
                    $("[name=ids]").attr("checked", true);
                } else {
                    $("[name=ids]").attr("checked", false);
                }
            });
            $("tr").slice(1).click(function (e) {
                // 找到checkbox对象
                var ids = $("input[name=ids]", this);
                if (ids.length < 1) {
                    return;
                }
                if (ids[0].checked) {
                    $("[name=ids]").attr("checked", false);
                    $("[name=ids]", this).attr("checked", false);
                } else {
                    $("[name=ids]").attr("checked", false);
                    $("[name=ids]", this).attr("checked", true);
                }
            });
        });*/
    </script>
</head>
<body>
<hr/>
<form class="layui-form" action="getUser" method="post">
    <input type="hidden" name="type" value="${type!}"/>
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">用户名称</label>
            <div class="layui-input-inline">
                <input type="text" name="username" value="${dto.username!}" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='getUser?type=${type!}';"
                        class="layui-btn layui-btn-primary">重置
                </button>
            </div>
        </div>
    </div>
</form>
<table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="listTable"
       lay-size="sm" lay-filter="sysBalanceTableEvent">
    <thead>
    <tr>
        <th class="check">
            #
        </th>
        <th>
            用户账号
        </th>
        <th>
            用户名称
        </th>
    </tr>
    <tbody>
    <#list page.records as dto>
    <tr>
        <td>
            <input type="radio" name="ids" value="${dto.id!?c}"/>
        </td>
        <td>
        ${dto.account}
        </td>
        <td>
        ${dto.username}
        </td>
    </tr>
    </#list>
    </tbody>
</table>
<#include "/include/my_pagination.ftl">
<div class="layui-form-item">
    <div align="center">
        <div>
            <input id="submitIframe" type="button" class="layui-btn layui-btn-normal" value="确定"/>
            <input id="closeIframe" type="button" class="layui-btn layui-btn-primary" value="取消"/>
        </div>
    </div>
</div>
</body>
</html>