package com.jifenke.lepluslive.datacenter.controller;

import com.jifenke.lepluslive.datacenter.domain.criteria.MerchantCriteriaEx;
import com.jifenke.lepluslive.datacenter.service.MerchantDataService;
import com.jifenke.lepluslive.global.util.LejiaResult;
import com.jifenke.lepluslive.global.util.MvUtil;
import com.jifenke.lepluslive.merchant.domain.entities.City;
import com.jifenke.lepluslive.merchant.domain.entities.Merchant;
import com.jifenke.lepluslive.merchant.domain.entities.MerchantType;
import com.jifenke.lepluslive.merchant.service.MerchantService;
import com.jifenke.lepluslive.order.service.OffLineOrderService;
import com.jifenke.lepluslive.sales.domain.entities.SalesStaff;

import org.springframework.data.domain.Page;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by xf on 2016/9/20.
 */
@RestController
@RequestMapping("/manage")
public class MerchantDataController {

  @Inject
  private MerchantDataService merchantDataService;
  @Inject
  private MerchantService merchantService;

  @RequestMapping("/merchant_data")
  public ModelAndView merchantDataPage(Model model) {
    //  下拉列表数据
    List<City> cityList = merchantDataService.findAllCitys();
    List<SalesStaff> staffList = merchantDataService.findAllStaffList();
    List<MerchantType> merchantTypeList = merchantDataService.findAllMerchantTypes();
    model.addAttribute("cityList", cityList);
    model.addAttribute("staffList", staffList);
    model.addAttribute("merchantTypeList", merchantTypeList);
    return MvUtil.go("/datacenter/merchantCenter");
  }

  @RequestMapping(value="/merchant_data/search")
  public LejiaResult merchantDataSearch(@RequestBody MerchantCriteriaEx merchantCriteria) {
    //  初始化分页数
    if (merchantCriteria.getOffset() == null) {
      merchantCriteria.setOffset(1);
    }
    //  设置默认有效金额
    if (merchantCriteria.getValidAmount() == null) {
      merchantCriteria.setValidAmount(10L);           // 设置默认有效金额为 10 元
    }
    // 获取查询条件中的时间
    String startDate = merchantCriteria.getStartDate();
    String endDate = merchantCriteria.getEndDate();
    merchantCriteria.setStartDate(null);             // 注:  查询商户时不能有时间条件
    merchantCriteria.setEndDate(null);
    //  列表所需数据
    Page page = merchantService.findMerchantsByPage(merchantCriteria,10);     // 分页查询用户信息
    List<Merchant> merchants = page.getContent();
    //  设置默认时间为当天
    if (startDate == null && endDate == null) {
      Date date = new Date();
      SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
      String today = format.format(date);
      startDate = today + " 00:00:00";
      endDate = today + " 23:59:59";
    }
    //  设置数据统计的时间范围
    merchantCriteria.setStartDate(startDate);
    merchantCriteria.setEndDate(endDate);
    List<SalesStaff> staffs = merchantDataService.findStaffByMerchant(merchants);
    List<Integer> binds = merchantService.findBindLeJiaUsers(merchants);       // 查找锁定用户
    List<Integer>
        timeBinds =
        merchantDataService.findBindLeJiaUsersByDate(merchants, merchantCriteria);        // 时间段锁定用户
    List<Long>
        orderNum =
        merchantDataService.findOrderNumByMerchant(merchants, merchantCriteria);   // 有效订单数
    List<Double>
        orderTotal =
        merchantDataService.findOrderTotalByMerchant(merchants, merchantCriteria);// 有效订单流水
    Map<String, List> map = merchantDataService.findLeadOrder(merchants, merchantCriteria);
    List<Long> leadOrderNum = map.get("leadOrderNum");     // 导流订单数
    List<Double> leadTotal = map.get("leadTotal");           // 导流流水
    List<Double> leadCommission = map.get("leadCommission"); // 导流佣金
    //  存储 model 用于页面展示
    Map<String, Object> model = new HashMap<>();
    model.put("binds", binds);
    model.put("staffs", staffs);
    model.put("timeBinds", timeBinds);
    model.put("orderNum", orderNum);
    model.put("orderTotal", orderTotal);
    model.put("leadOrderNum", leadOrderNum);
    model.put("leadCommission", leadCommission);
    model.put("leadTotal", leadTotal);
    model.put("page", page);
    return LejiaResult.ok(model);
  }

  @RequestMapping(value = "/merchant_data/merchantDataExport",method = RequestMethod.POST)
  public String merchantDataExport(MerchantCriteriaEx merchantCriteria,
                                   HttpServletResponse response) {
    //  初始化分页数
    if (merchantCriteria.getOffset() == null) {
      merchantCriteria.setOffset(1);
    }
    //  设置默认有效金额
    if (merchantCriteria.getValidAmount() == null) {
      merchantCriteria.setValidAmount(10L);           // 设置默认有效金额为 10 元
    }
    // 获取查询条件中的时间
    String startDate = merchantCriteria.getStartDate();
    String endDate = merchantCriteria.getEndDate();
    merchantCriteria.setStartDate(null);                                        // 注:  查询商户时不能有时间条件
    merchantCriteria.setEndDate(null);
    //  列表所需数据
    Page page = merchantService.findMerchantsByPage(merchantCriteria,1000);     // 分页查询用户信息
    List<Merchant> merchants = page.getContent();
    //  设置默认时间为当天
    if (startDate == null && endDate == null) {
      Date date = new Date();
      SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
      String today = format.format(date);
      startDate = today + " 00:00:00";
      endDate = today + " 23:59:59";
    }
    //  设置数据统计的时间范围
    merchantCriteria.setStartDate(startDate);
    merchantCriteria.setEndDate(endDate);
    ServletOutputStream outputStream = null;
    try {
      Date date = new Date();
      SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHssmm");
      String time = format.format(date);
      String filename = new String(("商户数据统计" + time).getBytes(), "ISO8859_1");
      response.setContentType("application/binary;charset=ISO8859_1");
      response.setHeader("Content-disposition", "attachment; filename=" + filename + ".xls");
      //  获取需要导出的数据
      List<SalesStaff> staffs = merchantDataService.findStaffByMerchant(merchants);
      List<Integer> binds = merchantService.findBindLeJiaUsers(merchants);       // 查找锁定用户
      List<Integer>
          timeBinds = merchantDataService.findBindLeJiaUsersByDate(merchants, merchantCriteria);        // 时间段锁定用户
      List<Long>
          orderNum = merchantDataService.findOrderNumByMerchant(merchants, merchantCriteria);   // 有效订单数
      List<Double>
          orderTotal = merchantDataService.findOrderTotalByMerchant(merchants, merchantCriteria);// 有效订单流水
      Map<String, List> map = merchantDataService.findLeadOrder(merchants, merchantCriteria);
      List<Long> leadOrderNum = map.get("leadOrderNum");     // 导流订单数
      List<Double> leadTotal = map.get("leadTotal");           // 导流流水
      List<Double> leadCommission = map.get("leadCommission"); // 导流佣金
      //  调用导出方法
      String[]
          titles =
          {"销售名称", "商户名称", "商户类型", "当前锁定情况", "时段内锁定", "流水额", "有效订单量", "导流订单数", "导流订单流水", "导流佣金"};
      outputStream = response.getOutputStream();
      merchantDataService.exportExcel(staffs, merchants, binds, timeBinds, orderNum, orderTotal,
                                      leadOrderNum,
                                      leadTotal, leadCommission, titles, outputStream);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        outputStream.close();
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
    return null;
  }
}