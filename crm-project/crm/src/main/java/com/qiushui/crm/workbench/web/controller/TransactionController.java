package com.qiushui.crm.workbench.web.controller;

import com.alibaba.druid.sql.visitor.functions.If;
import com.qiushui.crm.commons.constants.Constans;
import com.qiushui.crm.commons.pojo.ReturnObjectMessage;
import com.qiushui.crm.settings.pojo.DicValue;
import com.qiushui.crm.settings.pojo.User;
import com.qiushui.crm.settings.service.DicValueService;
import com.qiushui.crm.settings.service.UserService;
import com.qiushui.crm.workbench.pojo.Activity;
import com.qiushui.crm.workbench.pojo.Transaction;
import com.qiushui.crm.workbench.pojo.TransactionHistory;
import com.qiushui.crm.workbench.pojo.TransactionRemark;
import com.qiushui.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

@Controller
public class TransactionController {
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private TransactionRemarkService transactionRemarkService;
    @Autowired
    private TransactionHistoryService transactionHistoryService;


    @RequestMapping("/workbench/transaction/toTranIndex")
    public String toTranIndex(HttpServletRequest request){
        //需要携带三个字典值过去
        List<DicValue> stage = dicValueService.queryDicValueGroupByDicType("stage");
        List<DicValue> transactionType = dicValueService.queryDicValueGroupByDicType("transactionType");
        List<DicValue> source = dicValueService.queryDicValueGroupByDicType("source");
        //存到域里面
        request.setAttribute("stage",stage);
        request.setAttribute("transactionType",transactionType);
        request.setAttribute("source",source);
        return "workbench/transaction/index";
    }

    @RequestMapping("/workbench/transaction/toSaveIndex")
    public String toSaveIndex(HttpServletRequest request){
        //需要携带user,stage,transactionType,source
        List<User> userList = userService.queryAllUsers();

        List<DicValue> stage = dicValueService.queryDicValueGroupByDicType("stage");
        List<DicValue> transactionType = dicValueService.queryDicValueGroupByDicType("transactionType");
        List<DicValue> source = dicValueService.queryDicValueGroupByDicType("source");
        //存到域里面
        request.setAttribute("userList",userList);
        request.setAttribute("stage",stage);
        request.setAttribute("transactionType",transactionType);
        request.setAttribute("source",source);
        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/fuzzyQueryForSave")
    @ResponseBody
    public Object fuzzyQueryForSave(String value){
        List<Activity> activityList = activityService.queryModifyActivityFuzzyForSave(value);
        return activityList;
    }

    @RequestMapping("/workbench/transaction/optionValuePossible")
    @ResponseBody
    public Object optionValuePossible(String optionValue){
        ResourceBundle bundle = ResourceBundle.getBundle("possible");
        String string = bundle.getString(optionValue);
        return string;
    }

    @RequestMapping("/workbench/transaction/typeaheadText")
    @ResponseBody
    public Object typeaheadText(String fuzzyName){
        List<String> list = customerService.queryModifyNameByFuzzyName(fuzzyName);
        return list;
    }

    @RequestMapping("/workbench/transaction/saveTransaction")
    @ResponseBody
    public Object saveTransaction(@RequestParam Map<String,Object> map, HttpSession session){
        ReturnObjectMessage returnObjectMessage = new ReturnObjectMessage();
        map.put(Constans.SESSION_LOGIN_INF,session.getAttribute(Constans.SESSION_LOGIN_INF));
        try {
            transactionService.saveTransactionUseTran(map);
            returnObjectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            return returnObjectMessage;
        }

    }

    @RequestMapping("/workbench/transaction/showTranDetail")
    public String saveTransaction(HttpServletRequest request,String id){
        //查询三段交易信息，存到域里
        Transaction transaction = transactionService.queryModifyDataByPrimaryKey(id);
        List<TransactionRemark> transactionRemarkList = transactionRemarkService.queryModifyDataByTranId(id);
        List<TransactionHistory> transactionHistoryList = transactionHistoryService.selectModifyDataByTranId(id);
        //存到域里
        request.setAttribute("transaction",transaction);
        request.setAttribute("transactionRemarkList",transactionRemarkList);
        request.setAttribute("transactionHistoryList",transactionHistoryList);

        //第二次获取数据，获取全部阶段的数据值
        List<DicValue> stageList = dicValueService.queryDicValueGroupByDicType("stage");
        String tranStage = transaction.getStage();
        String tranStageId="";
        for (int i=0;i<stageList.size();i++){
            if(tranStage.equals(stageList.get(i).getValue())){
                tranStageId=stageList.get(i).getOrderNo();
            }
        }
        //去得到可能性的值
        String possible = ResourceBundle.getBundle("possible").getString(transaction.getStage());
        Map<String, Object> map = new HashMap<>();
        map.put("tranStageId",tranStageId);
        map.put("possible",possible);
        request.setAttribute("toolMap",map);
        request.setAttribute("stageList",stageList);
        return "workbench/transaction/detail";
    }
}
