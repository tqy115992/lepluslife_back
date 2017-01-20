<%--
  Created by IntelliJ IDEA.
  User: zhangwen
  Date: 2017/1/9
  Time: 10:09
  商户详情
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="../commen.jsp" %>
<!DOCTYPE>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>乐+生活 后台模板管理系统</title>
    <link type="text/css" rel="stylesheet" href="${resourceUrl}/css/reset.css"/>
    <link type="text/css" rel="stylesheet" href="${resourceUrl}/css/commonCss.css"/>
    <link type="text/css" rel="stylesheet" href="${resourceUrl}/css/bootstrap.min.css"/>
    <link type="text/css" rel="stylesheet" href="${resourceUrl}/css/combo.select.css"/>
    <link type="text/css" rel="stylesheet" href="${resourceUrl}/css/Mod/ModInput.css"/>
    <link type="text/css" rel="stylesheet" href="${resourceUrl}/css/Mod/ModCommon.css"/>
    <link type="text/css" rel="stylesheet"
          href="${resourceUrl}/merchantUser/css/merchantManagement.css"/>
    <link type="text/css" rel="stylesheet"
          href="${resourceUrl}/merchantUser/css/merchantInformation.css"/>

    <script src="${resourceUrl}/js/html5shiv.min.js"></script>
    <script src="${resourceUrl}/js/respond.min.js"></script>

    <script type="text/javascript" src="${resourceUrl}/js/jquery.min.js"></script>
    <script type="text/javascript" src="${resourceUrl}/js/Mod/common.js"></script>
    <script type="text/javascript" src="${resourceUrl}/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${resourceUrl}/js/jquery.combo.select.js"></script>
    <!--layer-->
    <script type="text/javascript"
            src="${resourceUrl}/js/layer/laydate/laydate.js"></script>
    <!--echarts-->
    <script type="text/javascript" src="${resourceUrl}/js/echarts.min.js"></script>
    <script>
        var merchantUserId = '${m.id}';
        function go(index) {
            switch (index) {
                case 1:
                    break;
                case 2:
                    showShops();
                    break;
                case 4:
                    showSettlement();
                    break;
                default :
                    alert(index);
            }
        }

        /******************************获取门店列表信息************************************/
        function showShops() {
            var tab2_content = $('#tab2-content');
            tab2_content.html('');
            $.ajax({
                       type: "get",
                       url: "/manage/merchantUser/merchantList/" + merchantUserId,
                       async: false,
                       success: function (data) {
                           var list = data.data;
                           for (var i = 0; i < list.length; i++) {
                               var m = list[i];
                               var contentStr = '<tr><td>' + m.sid + '</td>';
                               contentStr += '<td>' + m.city + '</td>';
                               contentStr += '<td>' + m.type + '</td>';
                               contentStr += '<td>' + m.name + '</td>';
                               contentStr += '<td>' + m.merchantName + '</td>';
                               contentStr += '<td>' + m.partner + '</td>';
                               if (m.partnership == 0) { //普通商户
                                   if (m.payWay == 0) {  //富友结算
                                       contentStr += '<td>普通（' + m.rate + '%）</td>';
                                       contentStr += '<td>富友结算（普通' + m.common + '%）</td>';
                                   } else if (m.payWay == 1) {//乐加结算
                                       contentStr += '<td>普通</td>';
                                       contentStr += '<td>乐加结算（普通' + m.common + '%）</td>';
                                   } else { //暂未开通
                                       contentStr += '<td>普通</td>';
                                       contentStr += '<td>暂未开通</td>';
                                   }
                               } else { //联盟商户
                                   if (m.payWay == 0) {  //富友结算
                                       contentStr += '<td>联盟（' + m.rate + '%）</td>';
                                       contentStr +=
                                       '<td>富友结算（佣金' + m.alliance + '%,普通' + m.common + '%）</td>';
                                   } else if (m.payWay == 1) {//乐加结算
                                       contentStr += '<td>联盟</td>';
                                       contentStr +=
                                       '<td>乐加结算（佣金' + m.alliance + '%,普通' + m.common + '%）</td>';
                                   } else { //暂未开通
                                       contentStr += '<td>联盟</td>';
                                       contentStr += '<td>暂未开通</td>';
                                   }
                               }
                               contentStr += '<td>' + m.pos + '</td>';
                               contentStr += '<td>' + m.bind + '/' + m.limit + '</td>';
                               contentStr += '<td>' + (m.shop == 1 ? '已上线' : '未上线') + '</td>';
                               contentStr += '<td>' + (m.receipt == 1 ? '已开启' : '未开启') + '</td>';
                               contentStr +=
                               '<td>' + new Date(m.createDate).format('yyyy-MM-dd HH:mm') + '</td>';
                               contentStr +=
                               '<td><button class="btn btn-primary" onclick="editMerchant(\''
                               + m.id + '\')">编辑</button></td></tr>';
                               tab2_content.html(tab2_content.html() + contentStr);
                           }
                       }
                   });
        }
        /******************************门店编辑/新建************************************/
        function editMerchant(merchantId) {
            if (merchantId == -1) {
                location.href = "/manage/merchant/edit?merchantUserId=" + merchantUserId;
            } else {
                location.href = "/manage/merchant/edit/" + merchantId;
            }
        }
        /******************************获取商户号信息列表************************************/
        function showSettlement() {
            var tab4_content = $('#tab4-content');
            tab4_content.html('');
            $.ajax({
                       type: "get",
                       url: "/manage/m_settlement/list/" + merchantUserId,
                       async: false,
                       success: function (data) {
                           var list = data.data;
                           for (var i = 0; i < list.length; i++) {
                               var m = list[i];
                               var contentStr = '<tr><td>' + m.merchantNum + '</td>';
                               if (m.type == 0) {
                                   contentStr += '<td>普通商户号</td>';
                               } else {
                                   contentStr += '<td>佣金商户号</td>';
                               }
                               contentStr += '<td>' + m.commission + '%</td>';
                               if (m.names == null || m.names == '') {
                                   contentStr += '<td>未使用</td>';
                               } else {
                                   var shops = m.names.split('_');
                                   if (shops != null && shops.length > 1) {
                                       contentStr +=
                                       '<td>' + shops[0] + '等' + shops.length + '家门店</td>';
                                   } else {
                                       contentStr += '<td>' + m.names + '</td>';
                                   }
                               }

                               contentStr += '<td>' + m.payee + '</td>';
                               contentStr += '<td>' + m.card + '</td>';
                               contentStr +=
                               '<td>' + m.total / 100 + '（微信' + m.totalByTruePay / 100 + ',红包'
                               + m.totalByScore / 100 + '）</td>';
                               contentStr +=
                               '<td>' + new Date(m.createDate).format('yyyy-MM-dd HH:mm') + '</td>';
                               contentStr +=
                               '<td><button class="btn btn-primary" onclick="editMerchantNum(\''
                               + m.id + '\')">编辑</button></td></tr>';
                               tab4_content.html(tab4_content.html() + contentStr);
                           }
                       }
                   });
        }
        /******************************商户号编辑************************************/
        function editMerchantNum(settlementId) {
            if (settlementId == -1) {
                window.location.href = '/manage/m_settlement/edit?merchantUserId=' + merchantUserId;
            } else {
                window.location.href =
                '/manage/m_settlement/edit?merchantUserId=' + merchantUserId + '&id='
                + settlementId;
            }
        }
    </script>
</head>
<body>
<div id="topIframe">
    <%@include file="../common/top.jsp" %>
</div>
<div id="content">
    <div id="leftIframe">
        <%@include file="../common/left.jsp" %>
    </div>
    <div class="m-right">
        <div class="main">
            <div class="container-fluid">
                <ul id="myTab" class="nav nav-tabs">
                    <li><a href="#tab1" data-toggle="tab" onclick="go(1)">首页</a></li>
                    <li><a href="#tab2" data-toggle="tab" onclick="go(2)">门店管理</a></li>
                    <li><a href="#tab3" data-toggle="tab" onclick="go(3)">账号管理</a></li>
                    <li><a href="#tab4" data-toggle="tab" onclick="go(4)">移动商户号</a></li>
                    <li><a href="#tab5" data-toggle="tab" onclick="go(5)">POS机</a></li>
                </ul>

                <div id="myTabContent" class="tab-content">
                    <div class="tab-pane fade in active" id="tab1">
                        <div class="topDataShow">
                            <div>
                                <div><img src="img/cdyh.png" alt=""></div>
                                <div>
                                    <p>商户锁定会员</p>

                                    <p>300/5000</p>
                                </div>
                            </div>
                            <div>
                                <div><img src="img/ljtd.png" alt=""></div>
                                <div>
                                    <p>名下门店(佣金/普通)</p>

                                    <p>10/3</p>
                                </div>
                            </div>
                            <div>
                                <div><img src="img/cgff.png" alt=""></div>
                                <div>
                                    <p>移动商户号(佣金/普通)</p>

                                    <p>2/2</p>
                                </div>
                            </div>
                            <div>
                                <div><img src="img/tdl.png" alt=""></div>
                                <div>
                                    <p>POS机</p>

                                    <p>2</p>
                                </div>
                            </div>
                        </div>
                        <div class="merchant_information-showData ModRadius">
                            <div>累计总流水：456元</div>
                            <div>累计扫码流水:567元</div>
                            <div>累计POS流水:678元</div>
                            <div>累计收取红包:678元</div>
                            <div>产生总佣金:678元</div>
                        </div>
                        <div class="MODInput_row">
                            <div class="Mod-10" style="margin: 10px 0">
                                <div class="ModLabel ModRadius-left">有效期</div>
                                <div class="Mod-6" style="margin-top: -2px">
                                    <input id="merchant_management-startTime"
                                           class="laydate-icon layer-date ModRadius-right"
                                           placeholder="起始时间">
                                    <input id="merchant_management-endTime"
                                           class="laydate-icon layer-date ModRadius"
                                           placeholder="截止时间">
                                </div>
                            </div>
                            <div class="Mod-3">
                                <div class="ModLabel ModRadius-left">交易门店</div>
                                <div class="Mod-6">
                                    <select name="filter-partner" class="ModRadius-right">
                                        <option value="0">全部门店</option>
                                        <option value="1">门店1</option>
                                        <option value="1">门店2</option>
                                        <option value="1">门店3</option>
                                    </select>
                                </div>
                            </div>
                            <div class="Mod-3">
                                <div class="ModLabel ModRadius-left">交易渠道</div>
                                <div class="Mod-6">
                                    <select name="filter-partner" class="ModRadius-right">
                                        <option value="0">全部渠道</option>
                                        <option value="1">Q1POS</option>
                                        <option value="1">扫码牌</option>
                                    </select>
                                </div>
                            </div>
                            <div class="Mod-2">
                                <button class="ModButton ModButton_ordinary ModRadius">筛选查询</button>
                            </div>
                        </div>
                        <div class="eCharts">
                            <div class="container" id="echart-main" style="height:400px;"></div>
                        </div>
                        <div>
                            <div class="merchant_management-table">
                                <div class="toggleTable">
                                    <div class="tab-content">
                                        <div class="tab-pane fade in active">
                                            <table class="table table-bordered table-hover">
                                                <thead>
                                                <tr class="active">
                                                    <th>交易日期</th>
                                                    <th>总流水额</th>
                                                    <th>扫码流水</th>
                                                    <th>POS流水</th>
                                                    <th>收取红包</th>
                                                    <th>导流订单流水</th>
                                                    <th>会员订单流水</th>
                                                    <th>产生佣金金额</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <tr>
                                                    <td>2016.8.7</td>
                                                    <td>50元</td>
                                                    <td>50元</td>
                                                    <td>50元</td>
                                                    <td>50元</td>
                                                    <td>50元</td>
                                                    <td>50元</td>
                                                    <td>50元</td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <nav class="pull-right">
                                            <ul class="pagination pagination-lg">
                                                <li><a href="#" aria-label="Previous"><span
                                                        aria-hidden="true">«</span></a></li>
                                                <li><a href="#" class="focusClass">1</a></li>
                                                <li><a href="#">2</a></li>
                                                <li><a href="#">3</a></li>
                                                <li><a href="#">4</a></li>
                                                <li><a href="#">5</a></li>
                                                <li><a href="#" aria-label="Next"><span
                                                        aria-hidden="true">»</span></a></li>
                                            </ul>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade in active" id="tab2">
                        <div class="merchant_management-table">
                            <div class="merchant_management-addButton">
                                <button class="ModButton ModButton_ordinary ModRadius"
                                        onclick="editMerchant(-1)">创建门店
                                </button>
                            </div>
                            <div class="toggleTable">
                                <div class="tab-content">
                                    <div class="tab-pane fade in active">
                                        <table class="table table-bordered table-hover">
                                            <thead>
                                            <tr class="active">
                                                <th>门店ID</th>
                                                <th>门店所在城市</th>
                                                <th>分类</th>
                                                <th>门店名称</th>
                                                <th>所属商户</th>
                                                <th>合伙人</th>
                                                <th>协议</th>
                                                <th>扫码收款</th>
                                                <th>POS机具</th>
                                                <th>锁定会员</th>
                                                <th>乐店状态</th>
                                                <th>红包权限</th>
                                                <th>创建时间</th>
                                                <th>操作</th>
                                            </tr>
                                            </thead>
                                            <tbody id="tab2-content">
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade in active" id="tab3">
                        <div class="merchant_information-tab3Tab ModRadius">
                            <div class="merchant_information-tabActive ModRadius-left">账号</div>
                            <div class="ModRadius-right">绑定微信号</div>
                        </div>
                        <div class="merchant_management-addButton">
                            <button class="ModButton ModButton_ordinary ModRadius merchant_information-create">
                                新建账号
                            </button>
                        </div>
                        <!--账号-->
                        <div class="merchant_information-tabAccount">
                            <div class="merchant_management-table">
                                <div class="toggleTable">
                                    <div class="tab-content">
                                        <div class="tab-pane fade in active">
                                            <table class="table table-bordered table-hover">
                                                <thead>
                                                <tr class="active">
                                                    <th>账号类型</th>
                                                    <th>负责门店</th>
                                                    <th>账号名</th>
                                                    <th>密码</th>
                                                    <th>操作</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <tr>
                                                    <td>管理员</td>
                                                    <td>4个</td>
                                                    <td>caoguangyan</td>
                                                    <td>******</td>
                                                    <td>
                                                        <input type="button"
                                                               class="btn btn-xs btn-primary select-btn Mod-3"
                                                               value="修改">
                                                        <input type="button"
                                                               class="btn btn-xs btn-danger select-btn Mod-3 merchant_information-del"
                                                               value="删除">
                                                    </td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <nav class="pull-right">
                                            <ul class="pagination pagination-lg">
                                                <li><a href="#" aria-label="Previous"><span
                                                        aria-hidden="true">«</span></a></li>
                                                <li><a href="#" class="focusClass">1</a></li>
                                                <li><a href="#">2</a></li>
                                                <li><a href="#">3</a></li>
                                                <li><a href="#">4</a></li>
                                                <li><a href="#">5</a></li>
                                                <li><a href="#" aria-label="Next"><span
                                                        aria-hidden="true">»</span></a></li>
                                            </ul>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--绑定微信号-->
                        <div class="merchant_information-tabWechat">
                            <div class="merchant_management-table">
                                <div class="toggleTable">
                                    <div class="tab-content">
                                        <div class="tab-pane fade in active">
                                            <table class="table table-bordered table-hover">
                                                <thead>
                                                <tr class="active">
                                                    <th>账号类型</th>
                                                    <th>账号名</th>
                                                    <th>微信信息</th>
                                                    <th>操作</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <tr>
                                                    <td>管理员</td>
                                                    <td>cao2311</td>
                                                    <td><span><img
                                                            class="merchant_information-tableImg"
                                                            src="#"
                                                            alt=""></span><span>caoguangyan</span>
                                                    </td>
                                                    <td>
                                                        <input type="button"
                                                               class="btn btn-xs btn-primary select-btn Mod-3 merchant_information-Unbind"
                                                               value="解除绑定">
                                                    </td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <nav class="pull-right">
                                            <ul class="pagination pagination-lg">
                                                <li><a href="#" aria-label="Previous"><span
                                                        aria-hidden="true">«</span></a></li>
                                                <li><a href="#" class="focusClass">1</a></li>
                                                <li><a href="#">2</a></li>
                                                <li><a href="#">3</a></li>
                                                <li><a href="#">4</a></li>
                                                <li><a href="#">5</a></li>
                                                <li><a href="#" aria-label="Next"><span
                                                        aria-hidden="true">»</span></a></li>
                                            </ul>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade in active" id="tab4">
                        <div class="merchant_management-table">
                            <div class="merchant_management-addButton">
                                <button class="ModButton ModButton_ordinary ModRadius"
                                        onclick="editMerchantNum(-1)">新建商户号
                                </button>
                            </div>
                            <div class="toggleTable">
                                <div class="tab-content">
                                    <div class="tab-pane fade in active">
                                        <table class="table table-bordered table-hover">
                                            <thead>
                                            <tr class="active">
                                                <th>移动商户号</th>
                                                <th>商户号类型</th>
                                                <th>微信费率</th>
                                                <th>应用门店</th>
                                                <th>收款人</th>
                                                <th>卡号</th>
                                                <th>累计流水</th>
                                                <th>录入时间</th>
                                                <th>操作</th>
                                            </tr>
                                            </thead>
                                            <tbody id="tab4-content">
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="tab-pane fade in active" id="tab5">
                        <div class="merchant_management-table">
                            <div class="merchant_management-addButton">
                                <button class="ModButton ModButton_ordinary ModRadius">新建POS
                                </button>
                            </div>
                            <div class="toggleTable">
                                <div class="tab-content">
                                    <div class="tab-pane fade in active">
                                        <table class="table table-bordered table-hover">
                                            <thead>
                                            <tr class="active">
                                                <th>设备号</th>
                                                <th>添加时间</th>
                                                <th>借记卡</th>
                                                <th>贷记卡</th>
                                                <th>微信</th>
                                                <th>支付宝</th>
                                                <th>操作</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <tr>
                                                <td>WP3123131</td>
                                                <td><span>2016.6.6 </span><br><span>14：21</span>
                                                </td>
                                                <td>
                                                    <span>普通：0.6%  26封顶</span><br><span>佣金：10%</span>
                                                </td>
                                                <td><span>普通：0.6%</span><br><span>佣金：10%</span></td>
                                                <td><span>普通：0.6%</span><br><span>佣金：10%</span></td>
                                                <td><span>普通：0.6%</span><br><span>佣金：10%</span></td>
                                                <td>
                                                    <input type="button"
                                                           class="btn btn-xs btn-warning select-btn Mod-8"
                                                           value="编辑">
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <nav class="pull-right">
                                        <ul class="pagination pagination-lg">
                                            <li><a href="#" aria-label="Previous"><span
                                                    aria-hidden="true">«</span></a></li>
                                            <li><a href="#" class="focusClass">1</a></li>
                                            <li><a href="#">2</a></li>
                                            <li><a href="#">3</a></li>
                                            <li><a href="#">4</a></li>
                                            <li><a href="#">5</a></li>
                                            <li><a href="#" aria-label="Next"><span
                                                    aria-hidden="true">»</span></a></li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<div id="bottomIframe">
    <%@include file="../common/bottom.jsp" %>
</div>


<!--添加提示框-->
<div class="modal" id="merchant_information-save">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span
                        aria-hidden="true">×</span><span class="sr-only">Close</span></button>
                <h4 class="modal-title">话费产品</h4>
            </div>
            <div class="merchant_layer">
                <p>基本信息保存成功！</p>
                <button class="ModButton ModButton_ordinary ModRadius" data-dismiss="modal">知道了
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal" id="merchant_information-del">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span
                        aria-hidden="true">×</span><span class="sr-only">Close</span></button>
                <h4 class="modal-title">删除账号</h4>
            </div>
            <div class="merchant_layer">
                <p>确定要删除收银员账号<span> 213131231321 </span>码</p>

                <p>删除该账号后，账号绑定的 <span>3</span> 个微信号也将自动解绑，请谨慎操作。</p>
                <button class="ModButton ModButton_ordinary ModRadius" data-dismiss="modal">确定
                </button>
                <button class="ModButton ModButton_worry ModRadius" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<div class="modal" id="merchant_information-Unbind">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span
                        aria-hidden="true">×</span><span class="sr-only">Close</span></button>
                <h4 class="modal-title">接触绑定</h4>
            </div>
            <div class="merchant_layer">
                <p>确定要解除绑定吗？</p>
                <button class="ModButton ModButton_ordinary ModRadius" data-dismiss="modal">确定
                </button>
                <button class="ModButton ModButton_worry ModRadius" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<div class="modal" id="merchant_information-create">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span
                        aria-hidden="true">×</span><span class="sr-only">Close</span></button>
                <h4 class="modal-title">账号操作</h4>
            </div>
            <div class="merchant_layer">
                <div class="MODInput_row">
                    <div class="Mod-10">
                        <div class="ModLabel ModRadius-left">所属合伙人</div>
                        <div class="Mod-6">
                            <select class="hhr">
                                <option value="1">合伙人11</option>
                                <option value="2">合伙人2</option>
                            </select>
                        </div>
                    </div>
                    <div class="Mod-10">
                        <div class="ModLabel ModRadius-left">对应门店</div>
                        <div class="Mod-6 merchant_bigCheckBox">
                            <div class="Mod-2"><input type="checkbox"
                                                      id="checkAlll"/><span>全部门店</span></div>
                        </div>
                    </div>
                    <div class="Mod-10">
                        <div class="ModLabel ModRadius-left">账号名</div>
                        <div class="Mod-6">
                            <input class="ModRadius-right" placeholder="请输入4~16位汉字、字母或者数字">
                        </div>
                    </div>
                    <div class="Mod-10">
                        <div class="ModLabel ModRadius-left">密码</div>
                        <div class="Mod-6">
                            <input class="ModRadius-right" placeholder="请输入密码">
                        </div>
                    </div>
                </div>
                <button class="ModButton ModButton_ordinary ModRadius" id="Checked"
                        data-dismiss="modal">确定
                </button>
                <button class="ModButton ModButton_worry ModRadius" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<script>

    Date.prototype.format = function (fmt) {
        var o = {
            "M+": this.getMonth() + 1, //月份
            "d+": this.getDate(), //日
            "h+": this.getHours() % 12 == 0 ? 12 : this.getHours() % 12, //小时
            "H+": this.getHours(), //小时
            "m+": this.getMinutes(), //分
            "s+": this.getSeconds(), //秒
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度
            "S": this.getMilliseconds() //毫秒
        };
        var week = {
            "0": "\u65e5",
            "1": "\u4e00",
            "2": "\u4e8c",
            "3": "\u4e09",
            "4": "\u56db",
            "5": "\u4e94",
            "6": "\u516d"
        };
        if (/(y+)/.test(fmt)) {
            fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        }
        if (/(E+)/.test(fmt)) {
            fmt =
            fmt.replace(RegExp.$1,
                        ((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? "\u661f\u671f" : "\u5468")
                                : "") + week[this.getDay() + ""]);
        }
        for (var k in o) {
            if (new RegExp("(" + k + ")").test(fmt)) {
                fmt =
                fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr((""
                                                                                                 + o[k]).length)));
            }
        }
        return fmt;
    }
    var li = 1;
    if (${li != null}) {
        li = eval('${li}');
    }
    $(function () {
//        tab切换
        $('#myTab li:eq(' + (li - 1) + ') a').tab('show');
        go(li);
//        提示框
        $(".merchant_information-Unbind").click(function () {
            $("#merchant_information-Unbind").modal("toggle");
        });
        $(".merchant_information-del").click(function () {
            $("#merchant_information-del").modal("toggle");
        });
        $(".merchant_information-save").click(function () {
            $("#merchant_information-save").modal("toggle");
        });
        $(".merchant_information-create").click(function () {
            $("#merchant_information-create").modal("toggle");
        });
    });

    //日期范围限制
    var start = {
        elem: '#merchant_management-startTime',
        format: 'YYYY/MM/DD hh:mm:ss',
        max: '2099-06-16 23:59:59', //最大日期
        istime: false,
        istoday: false,
        choose: function (datas) {
            end.min = datas; //开始日选好后，重置结束日的最小日期
            end.start = datas //将结束日的初始值设定为开始日
        }
    };
    var end = {
        elem: '#merchant_management-endTime',
        format: 'YYYY/MM/DD hh:mm:ss',
        max: '2099-06-16 23:59:59',
        istime: false,
        istoday: false,
        choose: function (datas) {
            start.max = datas; //结束日选好后，重置开始日的最大日期
        }
    };
    laydate(start);
    laydate(end);

    //下拉模糊查询
    $(function () {
        $('.hhr').comboSelect();
    });

    //账号管理标签切换
    $(".merchant_information-tab3Tab > div").click(function () {
        var divVal = $(this).html();
        $(".merchant_information-tab3Tab > div").removeClass("merchant_information-tabActive");
        $(this).addClass("merchant_information-tabActive");
        switch (divVal) {
            case "账号":
                $(".merchant_information-tabAccount").show();
                $(".merchant_information-tabWechat").hide();
                break;
            case "绑定微信号":
                $(".merchant_information-tabAccount").hide();
                $(".merchant_information-tabWechat").show();
        }
    });

    // 基于准备好的dom，初始化echarts实例
    var myChart = echarts.init(document.getElementById('echart-main'));
    // echart
    myChart.setOption({
                          tooltip: {
                              trigger: 'axis'
                          },
                          legend: {
                              data: ['充值话费', '使用积分', '实付金额']
                          },
                          xAxis: {
                              boundaryGap: false,
                              data: ["06-08", "06-09", "06-10", "06-11", "06-12", "06-13"]
                          },
                          yAxis: {
                              name: '金额',
                              type: 'value'
                          },
                          series: [{
                                       name: '充值话费',
                                       type: 'line',
                                       data: [120, 132, 101, 134, 90, 430]
                                   },
                                   {
                                       name: '使用积分',
                                       type: 'line',
                                       data: [170, 192, 161, 114, 190, 530]
                                   },
                                   {
                                       name: '实付金额',
                                       type: 'line',
                                       data: [150, 142, 121, 164, 170, 230]
                                   }],
                          visualMap: {
                              inRange: {}
                          }
                      });

    // ModRadio2 js
    var reVal = $(".ModRadius2_active").html();
    merchant_informationSwitch(reVal);
    $(".ModRadio2 > div").click(function () {
        $(".ModRadio2 > div").removeClass("ModRadius2_active");
        $(this).addClass("ModRadius2_active");
        var thisVal = $(this).html();
        merchant_informationSwitch(thisVal);
    });
    function merchant_informationSwitch(val) {
        switch (val) {
            case "法人私账":
                $(".ModFilling").remove();
                $(".merchant_information-filling").after(filling("收款人"));
                $(".merchant_information-filling").after(filling("开户支行"));
                $(".merchant_information-filling").after(filling("结算卡号"));
                break;
            case "对公账户":
                $(".ModFilling").remove();
                $(".merchant_information-filling").after(filling("开户支行"));
                $(".merchant_information-filling").after(filling("账户主体"));
                $(".merchant_information-filling").after(filling("账号"));
                break;
        }
    }
    //弹窗添加对应门店
    for (var i = 0; i < 5; i++) {
        $(".merchant_bigCheckBox").append(
                $("<div></div>").attr("class", "Mod-2").append(
                        $("<input />").attr("type", "checkbox").attr("name", "checkbox").attr("id",
                                                                                              i)
                ).append(
                        $("<span></span>").html("门店1")
                )
        );
    }

    //    全选
    $("[name=checkbox]").click(function () {
        if ($(this).is(':checked')) {
            $(this).attr("checked", "checked");
        } else {
            $(this).removeAttr("checked");
        }
    });
    $("#checkAlll").click(function () {
        var state = $("[name=checkbox]:checkbox").prop('checked');
        $("[name=checkbox]:checkbox").prop('checked', !state);
        if ($(this).is(":checked")) {
            $("[name=checkbox]:checkbox").attr("checked", "checked");
        } else {
            $("[name=checkbox]:checkbox").removeAttr("checked");
        }
    });
    $("#Checked").click(function () {
        var valArr = new Array;
        $("[name=checkbox]:checkbox[checked]").each(function (i) {
            valArr[i] = $(this).attr("id");
        });
        var vals = valArr.join(',');
        console.log(vals);

    });
</script>
</body>
</html>
