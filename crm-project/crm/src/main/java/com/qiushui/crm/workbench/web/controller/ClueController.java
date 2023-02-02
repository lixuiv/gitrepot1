package com.qiushui.crm.workbench.web.controller;

import com.qiushui.crm.commons.constants.Constans;
import com.qiushui.crm.commons.pojo.ReturnObjectMessage;
import com.qiushui.crm.commons.utils.DateFormatUtil;
import com.qiushui.crm.commons.utils.UUIDUtil;
import com.qiushui.crm.settings.pojo.DicValue;
import com.qiushui.crm.settings.pojo.User;
import com.qiushui.crm.settings.service.DicValueService;
import com.qiushui.crm.settings.service.UserService;
import com.qiushui.crm.workbench.pojo.Activity;
import com.qiushui.crm.workbench.pojo.Clue;
import com.qiushui.crm.workbench.pojo.ClueActivityRelation;
import com.qiushui.crm.workbench.pojo.ClueRemark;
import com.qiushui.crm.workbench.service.ActivityService;
import com.qiushui.crm.workbench.service.ClueActivityRelationService;
import com.qiushui.crm.workbench.service.ClueRemarkService;
import com.qiushui.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private UserService userService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;
    @RequestMapping("/workbench/clue/toClueIndex")
    public String toClueIndex(HttpServletRequest request){
        //查询字典值的数据返回到网页中
        List<User> users = userService.queryAllUsers();
        List<DicValue> appellation = dicValueService.queryDicValueGroupByDicType("appellation");
        List<DicValue> clueState = dicValueService.queryDicValueGroupByDicType("clueState");
        List<DicValue> source = dicValueService.queryDicValueGroupByDicType("source");
        //cun dao yu li mian
        request.setAttribute("users",users);
        request.setAttribute("appellation",appellation);
        request.setAttribute("clueState",clueState);
        request.setAttribute("source",source);
        return "workbench/clue/index";
    }

    @RequestMapping("/workbench/clue/saveClue")
    @ResponseBody
    public Object saveClue(Clue clue, HttpSession session){
        User user = (User) session.getAttribute(Constans.SESSION_LOGIN_INF);
        ReturnObjectMessage objectMessage = new ReturnObjectMessage();
        //二次封装数据
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateFormatUtil.formatDateTime(new Date()));
        //调用service层，插入数据
        try {
            int ret = clueService.saveClue(clue);
            if (ret>=0){
                objectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            return objectMessage;
        }
    }

    @RequestMapping("/workbench/clue/showClueDetail")
    public String showClueDetail(String id,HttpServletRequest request){
        //no tow fenZ,use service for get pojo
        Clue clue = clueService.queryClueByPrimaryKey(id);
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkByClueId(id);
        List<Activity> activityList = activityService.queryActivityByClueId(id);
        //CUN DAO YU LI MIAN
        request.setAttribute("clue",clue);
        request.setAttribute("clueRemarkList",clueRemarkList);
        request.setAttribute("activityList",activityList);
        return "workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/fuzzyQueryActivity")
    @ResponseBody
    public Object fuzzyQueryActivity(String value,String clueId){
        ReturnObjectMessage message = new ReturnObjectMessage();
        Map<String, String> map = new HashMap<>();
        map.put("value",value);
        map.put("clueId",clueId);

        List<Activity> activityList = activityService.queryActivityForFuzzy(map);
        if (activityList.size()>=0){
            message.setCode(Constans.RETURN_OBJECT_SUCCESS);
            message.setObject(activityList);
        }
        return message;
    }

    @RequestMapping("/workbench/clue/saveClueActivityRelationByIds")
    @ResponseBody
    public Object saveClueActivityRelationByIds(String[] activityId,String clueId){
        ReturnObjectMessage objectMessage = new ReturnObjectMessage();
        ArrayList<ClueActivityRelation> list = new ArrayList<>();
        for (String id : activityId) {
            ClueActivityRelation relation = new ClueActivityRelation();
            relation.setId(UUIDUtil.getUUID());
            relation.setActivityId(id);
            relation.setClueId(clueId);
            list.add(relation);
        }
        try{
            int ret = clueActivityRelationService.saveClueActivityRelationByIds(list);
            if (ret>=0){
                objectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            return objectMessage;
        }
    }

    @RequestMapping("/workbench/clue/queryActivityByClueId")
    @ResponseBody
    public Object queryActivityByClueId(String id){
        ReturnObjectMessage returnObjectMessage = new ReturnObjectMessage();
        List<Activity> activityList = activityService.queryActivityByClueId(id);
        if (activityList.size()>=0){
            returnObjectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
            returnObjectMessage.setObject(activityList);
        }
        return returnObjectMessage;
    }

    @RequestMapping("/workbench/clue/deleteActivityRelationForClue")
    @ResponseBody
    public Object deleteActivityRelationForClue(ClueActivityRelation clueActivityRelation){
        ReturnObjectMessage objectMessage = new ReturnObjectMessage();
        int ret=-1;
        try{
            ret= clueActivityRelationService.deleteByClueAndActivityId(clueActivityRelation);
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if (ret>=0){
                objectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
            }
            return objectMessage;
        }
    }

    @RequestMapping("/workbench/clue/toConvert")
    public String toConvert(String id,HttpServletRequest request){
        Clue clue = clueService.queryClueByPrimaryKey(id);
        request.setAttribute("clue",clue);
        List<DicValue> stage = dicValueService.queryDicValueGroupByDicType("stage");
        request.setAttribute("stage",stage);
        return "workbench/clue/convert";
    }

    @RequestMapping("/workbench/clue/fuzzyQueryForConvert")
    @ResponseBody
    public Object fuzzyQueryForConvert(String clueId,String fuzzyText){
        ReturnObjectMessage returnObjectMessage = new ReturnObjectMessage();
        Map<String, Object> map = new HashMap<>();
        map.put("value",fuzzyText);
        map.put("clueId",clueId);
        List<Activity> activityList = activityService.queryActivityFuzzyForConvert(map);

        if (activityList!=null&&activityList.size()>0){
            returnObjectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
            returnObjectMessage.setObject(activityList);
        }

        return returnObjectMessage;
    }


    @RequestMapping("/workbench/clue/clueConvertByConvertBtn")
    @ResponseBody
    public Object clueConvertByConvertBtn(String clueId, String isCreateTran, String money, String name,
                                          String expectedDate, String stage, String activityId,HttpSession session){
        ReturnObjectMessage returnObjectMessage = new ReturnObjectMessage();


        Map<String, Object> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("isCreateTran",isCreateTran);
        map.put("money",money);
        map.put("name",name);
        map.put("expectedDate",expectedDate);
        map.put("stage",stage);
        map.put("activityId",activityId);
        map.put(Constans.SESSION_LOGIN_INF,session.getAttribute(Constans.SESSION_LOGIN_INF));

        try {
            //调用service方法
            clueService.clueConvertByConvertBtn(map);
            returnObjectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
        }

        return returnObjectMessage;
    }
}
