package com.qiushui.crm.workbench.web.controller;

import com.qiushui.crm.commons.pojo.ReturnChartObject;
import com.qiushui.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class ChartController {
    @Autowired
    private TransactionService transactionService;

    @RequestMapping("/workbench/chart/transaction/toCharIndex")
    public String toCharIndex(){
        return "workbench/chart/transaction/index";
    }

    @RequestMapping("/workbench/chart/transaction/returnCharPojo")
    @ResponseBody
    public Object returnCharPojo(){
        List<ReturnChartObject> chartDataList = transactionService.queryReturnChartPojoByGroupByStage();
        return chartDataList;
    }
}
