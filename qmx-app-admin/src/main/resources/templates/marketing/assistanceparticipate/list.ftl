<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title>砍价活动</title>
    <#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'table', 'laydate'], function () {
            var table = layui.table;
            var laydate = layui.laydate;
            var form = layui.form;
        });
    </script>
</head>

<body>
<#include "../assistance/tab.ftl"/>
<form class="layui-form" action="list" method="post">
    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">活动名称</label>
            <div class="layui-input-inline">
                <select name="activity" class="input_1" lay-verify="" lay-search>
                    <option value=""></option>
                <#list activitys as activity>
                    <option value="${activity.id!}" <#if dto.activity?? && dto.activity==activity.id>selected</#if>> ${activity.name!} </option>
                </#list>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <div class="layui-input-inline">
                <button class="layui-btn layui-btn-normal" lay-submit lay-filter="submitQuery">查询</button>
                <button type="reset" onclick="location.href='list';" class="layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
</form>
        <table class="layui-table" style="width:98%;margin-left: 10px;margin-top: 10px;margin-right: 10px;" id="sysBalanceTable"
               lay-size="sm" lay-filter="sysBalanceTableEvent">
            <thead>
            <tr>
                <th class="check">
                    <input type="checkbox" id="selectAll">
                </th>
                <th>活动名称</th>
                <th>参与者</th>
                <th>当前助力金额</th>
                <th>是否能领取</th>
            </tr>
            </thead>
            <tbody>
            <#list page.records as dto>
            <tr>
                <td><input name="ids" type="checkbox" value="${dto.id!}"/></td>
                <td>${dto.activityName!}</td>
                <td>${dto.userName!'未关注用户'}</td>
                <td>${dto.price}</td>
                <td>
                    <#if dto.state??&&dto.state>
                        <span class="voi_spo_right">√</span>
                    <#else>
                        <span class="voi_spo_right">×</span>
                    </#if>
                </td>
            </tr>
            </#list>
            </tbody>
        </table>
<#include "/include/my_pagination.ftl">
</body>
</html>