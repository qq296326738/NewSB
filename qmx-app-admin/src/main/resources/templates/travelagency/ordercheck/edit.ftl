<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
    <title></title>
<#include "/include/common_header_include.ftl">
    <script>
        layui.use(['form', 'laydate'], function () {
            var form = layui.form;
            var laydate = layui.laydate;
            //前后若干天可选，这里以7天为例
            laydate.render({
                elem: '#date',
                value: '${dto.date!?date("yyyy-MM-dd")}'
            <#if (.now?string("HH")?number >= agreementDto.hour!?number)>
                , min: 1
            <#else>
                , min: 0
            </#if>
                , max:${agreementDto.day!}
            });

            form.verify({
                productId: [/[\S]+/, "请选择产品"]
            });

            form.on('submit(submit)', function (data) {
                var productId = $("input[name='productId']");
                if (productId.length < 1) {
                    layer.msg("请选择产品");
                    return false;
                }
                var prices = $("input[name='price']");
                for (var i = 0; i < prices.length; i++) {
                    if ($(prices[i]).val() == 0) {
                        layer.msg("存在无价格协议的产品");
                        return false;
                    }
                }
            <#if infos?? && (infos?index_of("guide") gt -1 || infos?index_of("lead") gt -1)>
                var guideId = $("input[name='guideId']");
                if (guideId.length < 1) {
                    layer.msg("请选择导游/领队");
                    return false;
                }
            </#if>
            <#if infos?? && infos?index_of("car") gt -1>
                var carId = $("input[name='carId']");
                if (carId.length < 1) {
                    layer.msg("请选择车辆");
                    return false;
                }
            </#if>
            <#if infos?? && infos?index_of("driver") gt -1>
                var driverId = $("input[name='driverId']");
                if (driverId.length < 1) {
                    layer.msg("请选择司机");
                    return false;
                }
            </#if>

                //return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
            });
        });
        //添加主产品
        $(document).on("click", "#addProduct", function () {
            var date = $("#date").val();
            var agreementId = $("#agreementId").val();
            /*if (date == "") {
                layer.msg("请先选择时间");
                return;
            }*/
            var index = layer.open({
                type: 2,
                title: '添加产品',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getProducts?stime=' + date + "&agreementId=" + agreementId
            });
        });
        //添加增值产品
        $(document).on("click", "#addIncreaseProduct", function () {
            var agreementId = $("#agreementId").val();
            /*if (date == "") {
                layer.msg("请先选择时间");
                return;
            }*/
            var index = layer.open({
                type: 2,
                title: '添加产品',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getIncreaseProducts?agreementId=' + agreementId
            });
        });

        //添加导游/领队
        $(document).on("click", "#addGuide", function () {
            var distributorId = $("#memberId").val();
            var type = "";
        <#if infos?? && infos?index_of("guide") gt -1>
            type = "guide";
        </#if>
        <#if infos?? && infos?index_of("lead") gt -1>
            type = "lead";
        </#if>
        <#if infos?? && infos?index_of("guide") gt -1 && infos?index_of("lead") gt -1>
            type = "";
        </#if>
            var index = layer.open({
                type: 2,
                title: '添加导游/领队',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getGuide?type=' + type + "&distributorId=" + distributorId
            });
        });
        //添加车辆
        $(document).on("click", "#addCar", function () {
            var distributorId = $("#memberId").val();
            var index = layer.open({
                type: 2,
                title: '添加车辆',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getCar?distributorId=' + distributorId
            });
        });
        //添加司机
        $(document).on("click", "#addDriver", function () {
            var distributorId = $("#memberId").val();
            var index = layer.open({
                type: 2,
                title: '添加司机',
                area: ['60%', '80%'], //宽高
                fix: true, //固定
                content: 'getDriver?distributorId=' + distributorId
            });
        });
        // 删除
        $(document).on("click", ".deleteItem", function () {
            var $this = $(this);
            layer.confirm('确定删除吗？', {
                btn: ['确定', '取消'] //按钮
            }, function (index) {
                $this.closest("tr").remove();
                layer.close(index);
            }, function () {
            });
        });

        //获取主产品价格
        $(document).on("blur", "input[name='quantity']", function () {
            var $this = $(this);
            var tr = $(this).parents("tr:eq(0)");
            var productId = tr.find("td:eq(0)").find(".productId").val();
            var agreementId = $("#agreementId").val();
            var startQuantity = tr.find("td:eq(2)").find(".startQuantity").val();
            var surplusTotalStock = tr.find("td:eq(2)").find(".surplusTotalStock").val();
            var upQuantity = $("#upQuantity").val();
            var downQuantity = $("#downQuantity").val();
            //判断库存量
            if (parseInt($this.val()) > (parseInt(surplusTotalStock) + parseInt(startQuantity))) {
                layer.msg("该产品库存不足，目前剩余库存为" + surplusTotalStock);
                $(tr.find("td:eq(2)").find("#quantity")).val(startQuantity);
                return;
            }
            $("#updateProductCount").val(startQuantity - $this.val());
        });
        //获取增值产品价格
        /* $(document).on("blur", "input[name='inQuantity']", function () {
             var $this = $(this);
             var tr = $(this).parents("tr:eq(0)");
             var increaseProductId = tr.find("td:eq(0)").find(".increaseProductId").val();
             var agreementId = $("#agreementId").val();
             var startQuantity = tr.find("td:eq(2)").find(".startIncreaseQuantity").val();
             var upQuantity = $("#increaseUpQuantity").val();
             var downQuantity = $("#increaseDownQuantity").val();
             //上调数量
             if ($this.val() - startQuantity > upQuantity) {
                 layer.msg("上调数量超过设置,请重现填写数量");
                 $(tr.find("td:eq(2)").find("#inQuantity")).val(startQuantity);
                 return;
             }
             //下调数量
             if (startQuantity - $this.val() > downQuantity) {
                 layer.msg("下调数量超过设置,请重现填写数量");
                 $(tr.find("td:eq(2)").find("#inQuantity")).val(startQuantity);
                 return;
             }
         });*/
    </script>
    <style>
        .layui-form-label {
            width: 100px;
        }
    </style>
</head>
<body>
<form class="layui-form" action="update" method="post">
    <input type="hidden" name="id" value="${dto.id!?c}"/>
    <input type="hidden" name="updateProductCount" id="updateProductCount" value="0"/>
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>基本信息</legend>
    </fieldset>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">旅行社名称</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${travelAgencyDto.name!}</div>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">联系人姓名</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${travelAgencyDto.contactsName!}</div>
            </div>
        </div>
        <div class="layui-inline">
            <label class="layui-form-label">联系人电话</label>
            <div class="layui-input-inline">
                <div class="layui-form-mid">${travelAgencyDto.contactsMobile!}</div>
            </div>
        </div>
    </div>

    <div class="layui-form-item">
        <div class="layui-inline">
            <label class="layui-form-label">游玩日期</label>
            <div class="layui-input-inline">
                <input value="${dto.date!}" name="date" type="hidden" autocomplete="off"
                       class="layui-input">
            </div>
            <div class="layui-form-mid">${dto.date!}</div>
        </div>
    </div>

    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">产品列表</label>
        <div class="layui-input-inline">
            <input type="hidden" name="agreementId" id="agreementId" value="${agreementDto.id!}"/>
            <input type="hidden" id="memberId" name="memberId" value="${agreementDto.travelagencyId!?c}"/>
            <input type="hidden" value="${agreementDto.upQuantity!}" id="upQuantity"/>
            <input type="hidden" value="${agreementDto.downQuantity!}" id="downQuantity"/>
            <input type="hidden" value="${agreementDto.increaseUpQuantity!}" id="increaseUpQuantity"/>
            <input type="hidden" value="${agreementDto.increaseDownQuantity!}" id="increaseDownQuantity"/>
        <#--<input id="addProduct" type="button" class="layui-btn" value="添加主产品">-->
            <br/>
            <label style="color: red;">订单需收取${agreementDto.deposit}%的定金</label>
            <hr/>
            <table id="productTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        产品名称
                    </td>
                    <td>
                        价格
                    </td>
                    <td>
                        数量
                    </td>
                <#--<td>
                    操作
                </td>-->
                </tr>
            <#list dto.infoDtos as info>
                <tr>
                    <td width="200">
                        <input type="hidden" name="productId" class="productId" value="${info.productId!}"/>
                        <labeld>${info.productName!}</labeld>
                    </td>
                    <td>
                        <input name="price" value="${info.price!}" class="layui-input" lay-verify="required"/>
                    <#--<labeld class="price">${info.price!}</labeld>-->
                    </td>
                    <td>
                        <input name="startQuantity" class="startQuantity" value="${info.quantity!}" type="hidden"/>
                        <input name="quantity" id="quantity" value="${info.quantity!}" lay-verify="required"
                               class="layui-input"/>
                        <input name="surplusTotalStock" value="${info.surplusTotalStock!}"
                               type="hidden" class="surplusTotalStock"/>
                    </td>
                <#--<td>
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal deleteItem" data-id=""
                           value="删除"/>
                </td>-->
                </tr>
            </#list>
            </table>
            <br/>
        <#--<input id="addIncreaseProduct" type="button" class="layui-btn" value="添加增值产品">-->
            <label style="color: red;">订单需收取${agreementDto.increaseDeposit!}%的定金</label>
            <hr/>
            <table id="increaseProductTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        增值产品名称
                    </td>
                    <td>
                        价格
                    </td>
                    <td>
                        数量
                    </td>
                <#--<td>
                    操作
                </td>-->
                </tr>
            <#list dto.increaseInfoDtos as info>
                <tr>
                    <td width="200">
                        <input type="hidden" name="increaseProductId" class="increaseProductId"
                               value="${info.productId!}"/>
                        <labeld>${info.productName!}</labeld>
                    </td>
                    <td>
                        <input name="inPrice" value="${info.price!}" class="layui-input" lay-verify="required"/>
                    <#-- <labeld class="inPrice">${info.price!}</labeld>-->
                    </td>
                    <td>
                        <input name="startIncreaseQuantity" class="startIncreaseQuantity" value="${info.quantity!}"
                               type="hidden"/>
                        <input name="inQuantity" id="inQuantity" value="${info.quantity!}" lay-verify="required"
                               class="layui-input"/>
                    </td>
                <#--<td>
                    <input type="button" class="layui-btn layui-btn-sm layui-btn-normal deleteItem" data-id=""
                           value="删除"/>
                </td>-->
                </tr>
            </#list>
            </table>
        </div>
    </div>

<#if infos?? && (infos?index_of("guide") gt -1 || infos?index_of("lead") gt -1)>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">导游/领队列表</label>
        <div class="layui-input-inline">
            <input id="addGuide" type="button" class="layui-btn" value="添加导游/领队">
            <hr/>
            <table id="guideTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        产品名称
                    </td>
                    <td>
                        操作
                    </td>
                </tr>
                <#list dto.guideDtos as info>
                    <tr>
                        <td width="200">
                            <input type="hidden" name="guideId" class="guideId"
                                   value="${info.guideId!}"/>${info.guideName!}
                        </td>
                        <td>
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-normal deleteItem" data-id=""
                                   value="删除"/>
                        </td>
                    </tr>
                </#list>
            </table>
        </div>
    </div>
</#if>

<#if infos?? && infos?index_of("car") gt -1>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">车辆列表</label>
        <div class="layui-input-inline">
            <input id="addCar" type="button" class="layui-btn" value="添加车辆">
            <hr/>
            <table id="carTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        产品名称
                    </td>
                    <td>
                        操作
                    </td>
                </tr>
                <#list dto.carDtos as info>
                    <tr>
                        <td width="200">
                            <input type="hidden" name="carId" class="carId"
                                   value="${info.carId!}"/>${info.carName!}
                        </td>
                        <td>
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-normal deleteItem" data-id=""
                                   value="删除"/>
                        </td>
                    </tr>
                </#list>
            </table>
        </div>
    </div>
</#if>

<#if infos?? && infos?index_of("driver") gt -1>
    <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">司机列表</label>
        <div class="layui-input-inline">
            <input id="addDriver" type="button" class="layui-btn" value="添加司机">
            <hr/>
            <table id="driverTable" width="100%" class="layui-table">
                <tr>
                    <td width="200">
                        产品名称
                    </td>
                    <td>
                        操作
                    </td>
                </tr>
                <#list dto.driverDtos as info>
                    <tr>
                        <td width="200">
                            <input type="hidden" name="driverId" class="driverId"
                                   value="${info.driverId!}"/>${info.driverName!}
                        </td>
                        <td>
                            <input type="button" class="layui-btn layui-btn-sm layui-btn-normal deleteItem" data-id=""
                                   value="删除"/>
                        </td>
                    </tr>
                </#list>
            </table>
        </div>
    </div>
</#if>


    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn layui-btn-normal" lay-submit="" lay-filter="submit">立即提交</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
            <input onclick="history.back();" type="button" class="layui-btn layui-btn-primary" value="返回"/>
        </div>
    </div>
</form>
</body>
</html>