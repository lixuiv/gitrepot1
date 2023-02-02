package com.qiushui.crm.workbench.web.controller;

import com.qiushui.crm.commons.constants.Constans;
import com.qiushui.crm.commons.pojo.ReturnObjectMessage;
import com.qiushui.crm.commons.utils.CellValueUtil;
import com.qiushui.crm.commons.utils.DateFormatUtil;
import com.qiushui.crm.commons.utils.UUIDUtil;
import com.qiushui.crm.settings.pojo.User;
import com.qiushui.crm.settings.service.UserService;
import com.qiushui.crm.workbench.pojo.Activity;
import com.qiushui.crm.workbench.pojo.ActivityRemark;
import com.qiushui.crm.workbench.service.ActivityRemarkService;
import com.qiushui.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/toIndex")
    public String toIndex(HttpServletRequest request){
        //这里需要选择把动态的数据返回回去
        List<User> userList = userService.queryAllUsers();
        request.setAttribute(Constans.SESSION_ACTIVITY_USERS,userList);
        return "workbench/activity/index";
    }

    @RequestMapping("/workbench/activity/saveActivity")
    @ResponseBody
    public Object saveActivity(Activity activity,HttpSession session){
        //二次封装数据
        //id, owner, name, start_date,end_date, cost, description,create_time, create_by
        //缺少的数据id,create_time, create_by
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateTime(DateFormatUtil.formatDate(new Date()));
        //从会话域里面获取user数据
        User user = (User) session.getAttribute(Constans.SESSION_LOGIN_INF);
        activity.setCreateBy(user.getId());

        //调用逻辑层的方法
        ReturnObjectMessage returnObjectMessage = new ReturnObjectMessage();
        returnObjectMessage.setCode(Constans.RETURN_OBJECT_FAILURE);
        try{
            int count=activityService.saveCreateActivity(activity);
            if (count!=1){
                returnObjectMessage.setMessage("保存账户失败...");
            }else {
                returnObjectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
                returnObjectMessage.setMessage("保存账户成功...");
            }
        }catch (Exception e){
            e.printStackTrace();
        }

        return returnObjectMessage;
    }

    /**
     *  name,owner, start_date, end_date,
     * @return json[List String]
     */
    @RequestMapping("/workbench/activity/queryByConditionForPage")
    @ResponseBody
    public Object queryByConditionForPage(String name,String owner,String start_date,String end_date,
                                          Integer pageNo,Integer pageSize){
        //封装数据
        Map<Object, Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("start_date",start_date);
        map.put("end_date",end_date);

        //进一步处理数据后封装
        Integer beginIndex=(pageNo-1)*pageSize;
        map.put("beginIndex",beginIndex);
        map.put("pageSize",pageSize);
        //打包数据，返回JSON字符串给前端
        Map<String, Object> activityInformation = new HashMap<>();
        try{
            //调用逻辑层的方法，返回市场活动集合和总条数
            List<Activity> activities = activityService.queryActivityByConditionForPage(map);
            int totalRows = activityService.queryCountOfActivityForPage(map);
            activityInformation.put("activities",activities);
            activityInformation.put("totalRows",totalRows);
        }catch (Exception e){
            e.printStackTrace();
        }
        return activityInformation;
    }

    @RequestMapping("/workbench/activity/deleteActivityRemarkByIds")
    @ResponseBody
    public Object deleteActivityRemarkByIds(String[] id){
        ReturnObjectMessage returnObjectMessage = new ReturnObjectMessage();
        returnObjectMessage.setCode(Constans.RETURN_OBJECT_FAILURE);
        returnObjectMessage.setMessage("删除功能调用失败...");
        try{
            int ret = activityService.deleteActivityRemarkByIds(id);
            if (ret>0){
                returnObjectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
                returnObjectMessage.setMessage("删除成功...");
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return returnObjectMessage;
    }


    @RequestMapping("/workbench/activity/queryActivityById")
    @ResponseBody
    public Object queryActivityById(String id){
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    @RequestMapping("/workbench/activity/editActivityRemark")
    @ResponseBody
    public Object editActivityRemark(Activity activity,HttpSession session){
        //二次封装数据
        String editTime = DateFormatUtil.formatDateTime(new Date());
        User user = (User) session.getAttribute(Constans.SESSION_LOGIN_INF);
        String id = user.getId();
        activity.setEditTime(editTime);
        activity.setEditBy(id);

        //调用service层的方法，并且进行判断
        ReturnObjectMessage returnObjectMessage = new ReturnObjectMessage();
        returnObjectMessage.setCode(Constans.RETURN_OBJECT_FAILURE);
        returnObjectMessage.setMessage("修改功能调用失败...");
        try{
            int ret = activityService.editActivityRemark(activity);
            if (ret>0){
                returnObjectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
                returnObjectMessage.setMessage("修改功能调用成功...");
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return returnObjectMessage;
    }


    @RequestMapping("/workbench/activity/fileDownloadTest")
    public void fileDownloadTest(HttpServletResponse response){
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("ConTent-Disposition","attachment;filename=studentList.xls");

        OutputStream out=null;
        InputStream is=null;
        try {
             out= response.getOutputStream();
             is = new FileInputStream("F:\\astudyideaplugins\\文件\\测试文件\\student.xls");
            byte[] buffer = new byte[1024 * 8];
            int len =0;
            if ((len=is.read(buffer))!=-1){
                out.write(buffer,0,len);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }finally {
            try {
                is.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

    }

    @RequestMapping("/workbench/activity/fileUploadTest")
    @ResponseBody
    public Object fileUploadTest(String fileName, MultipartFile uploadTest){
        ReturnObjectMessage message = new ReturnObjectMessage();
        message.setCode(Constans.RETURN_OBJECT_SUCCESS);
        message.setMessage("成功...");

        File path = new File("F:\\astudyideaplugins\\文件\\测试文件\\",uploadTest.getOriginalFilename());
        try {
            System.out.println(uploadTest.getName());
            System.out.println(uploadTest.getOriginalFilename());
            uploadTest.transferTo(path);
        } catch (IOException e) {
            message.setCode(Constans.RETURN_OBJECT_FAILURE);
            message.setMessage("失败...");
            throw new RuntimeException(e);
        }

        return message;
    }

    @RequestMapping("/workbench/activity/fileDownload")
    public void fileDownloadExport(HttpServletResponse response,String[] id) throws IOException {
        //拿到所有的市场活动
        List<Activity> activities = activityService.queryActivityForExport(id);
        //打包成为Excel
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("studentSheet");
        HSSFRow row = sheet.createRow(0);
        //创建表头
        HSSFCell cell =null;
        cell = row.createCell(0);
        cell.setCellValue("ID");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("市场活动名");
        cell = row.createCell(3);
        cell.setCellValue("市场活动开始时间");
        cell = row.createCell(4);
        cell.setCellValue("市场活动结束时间");
        cell = row.createCell(5);
        cell.setCellValue("花费");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("市场活动创建时间");
        cell = row.createCell(8);
        cell.setCellValue("市场活动创建人");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改人");

        //注入内容
        for (int i=0;i<activities.size();i++){
            row = sheet.createRow(i+1);
            Activity activity = activities.get(i);
            //内容
            cell = row.createCell(0);
            cell.setCellValue(activity.getId());
            cell = row.createCell(1);
            cell.setCellValue(activity.getOwner());
            cell = row.createCell(2);
            cell.setCellValue(activity.getName());
            cell = row.createCell(3);
            cell.setCellValue(activity.getStartDate());
            cell = row.createCell(4);
            cell.setCellValue(activity.getEndDate());
            cell = row.createCell(5);
            cell.setCellValue(activity.getCost());
            cell = row.createCell(6);
            cell.setCellValue(activity.getDescription());
            cell = row.createCell(7);
            cell.setCellValue(activity.getCreateTime());
            cell = row.createCell(8);
            cell.setCellValue(activity.getCreateBy());
            cell = row.createCell(9);
            cell.setCellValue(activity.getEditTime());
            cell = row.createCell(10);
            cell.setCellValue(activity.getEditBy());
        }

        //发送Excel给前端的准备,
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition","attachment;filename=studentList.xls");
        OutputStream os = response.getOutputStream();
        workbook.write(os);
        workbook.close();
    }

    @RequestMapping("/workbench/activity/importActivityModel")
    public void importActivityModel(HttpServletResponse response) throws IOException {
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("ConTent-Disposition","attachment;filename=studentList.xls");
        OutputStream os = response.getOutputStream();

        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("模板");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell=null;
        cell = row.createCell(0);
        cell.setCellValue("市场活动名");
        cell = row.createCell(1);
        cell.setCellValue("市场活动开始时间");
        cell = row.createCell(2);
        cell.setCellValue("市场活动结束时间");
        cell = row.createCell(3);
        cell.setCellValue("花费");
        cell = row.createCell(4);
        cell.setCellValue("描述");

        row = sheet.createRow(1);
        cell = row.createCell(0);
        cell.setCellValue("例子");
        cell = row.createCell(1);
        cell.setCellValue("格式:2023-01-31");
        cell = row.createCell(2);
        cell.setCellValue("2023-01-31");
        cell = row.createCell(3);
        cell.setCellValue("520");
        cell = row.createCell(4);
        cell.setCellValue("例子...");

        workbook.write(os);
        workbook.close();
    }

    @RequestMapping("/workbench/activity/importActivityRowsByFile")
    @ResponseBody
    public Object importActivityRowsByFile(MultipartFile multipartFile,HttpSession session){
        ReturnObjectMessage returnObjectMessage = new ReturnObjectMessage();
        returnObjectMessage.setCode(Constans.RETURN_OBJECT_FAILURE);
        returnObjectMessage.setMessage("发生导入错误...");

        User user = (User) session.getAttribute(Constans.SESSION_LOGIN_INF);
        try {
            InputStream is = multipartFile.getInputStream();
            HSSFWorkbook workbook = new HSSFWorkbook(is);
            HSSFSheet sheet = workbook.getSheetAt(0);
            HSSFRow row =null;
            HSSFCell cell = null;
            //解析Excel文件
            List<Activity> list = new ArrayList<>();
            for (int i=1;i<=sheet.getLastRowNum();i++){
                row = sheet.getRow(i);
                Activity activity = new Activity();
                activity.setId(UUIDUtil.getUUID());
                activity.setOwner(user.getId());
                activity.setCreateTime(DateFormatUtil.formatDateTime(new Date()));
                activity.setCreateBy(user.getId());

                for (int y=0;y<row.getLastCellNum();y++){
                    cell = row.getCell(y);
                    String cellValue = CellValueUtil.getCellValue(cell);
                    if (y==0){
                        activity.setName(cellValue);
                    } else if (y==1) {
                        if (cellValue.contains("-")){
                            activity.setStartDate(cellValue);
                        }else{
                            returnObjectMessage.setMessage("时间格式错误，正确格式为2021-12-21");
                            return returnObjectMessage;
                        }
                    }else if (y==2) {
                        if (cellValue.contains("-")){
                            activity.setEndDate(cellValue);
                        }else{
                            returnObjectMessage.setMessage("时间格式错误，正确格式为2021-12-21");
                            return returnObjectMessage;
                        }
                    }else if (y==3) {
                        activity.setCost(cellValue);
                    }else if (y==4) {
                        activity.setDescription(cellValue);
                    }
                }

                 list.add(activity);
                //activityService.saveCreateActivity(activity);
                //解析每行的尾巴
            }

            int count = activityService.saveActivityByFile(list);
            returnObjectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
            returnObjectMessage.setMessage("导入数据："+count);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }finally {
            return returnObjectMessage;
        }
    }

    @RequestMapping("/workbench/activity/toDetail")
    public String toDetail(HttpServletRequest request,String[] id){
        //获取内容
        List<Activity> activities = activityService.queryActivityForExport(id);
        Activity activity = activities.get(0);
        List<ActivityRemark> activityRemarks = activityRemarkService.queryDetailByActivityId(id[0]);
        //存到域中
        request.setAttribute("activity",activity);
        request.setAttribute("activityRemarks",activityRemarks);
        return "workbench/activity/detail";
    }

    @RequestMapping("/workbench/activity/createRemarkDetail")
    @ResponseBody
    public Object createRemarkDetail(HttpSession session,ActivityRemark remark){
        User user = (User) session.getAttribute(Constans.SESSION_LOGIN_INF);
        ReturnObjectMessage returnObjectMessage = new ReturnObjectMessage();

        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateFormatUtil.formatDateTime(new Date()));
        remark.setCreateBy(user.getId());
        remark.setEditFlag("0");

       try{
           int count = activityRemarkService.saveActivityRemark(remark);
           if (count>=0){
               returnObjectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
               returnObjectMessage.setObject(remark);
           }
       }catch (Exception e){
           e.printStackTrace();
       }finally {
           return returnObjectMessage;
       }
    }

    @RequestMapping("/workbench/activity/deleteRemarkById")
    @ResponseBody
    public Object deleteRemarkById(String id){
        ReturnObjectMessage objectMessage = new ReturnObjectMessage();
        try {
            int ret = activityRemarkService.deleteByPrimaryKey(id);
            if (ret>=0){
                objectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            return objectMessage;
        }
    }

    @RequestMapping("/workbench/activity/editActivityRemarkById")
    @ResponseBody
    public Object editActivityRemarkById(ActivityRemark remark,HttpSession session){
        User user = (User) session.getAttribute(Constans.SESSION_LOGIN_INF);
        remark.setEditTime(DateFormatUtil.formatDateTime(new Date()));
        remark.setEditFlag("1");
        remark.setEditBy(user.getId());


        ReturnObjectMessage objectMessage = new ReturnObjectMessage();
        try {
            int ret = activityRemarkService.editByPrimaryKey(remark);
            if (ret>=0){
                objectMessage.setCode(Constans.RETURN_OBJECT_SUCCESS);
                objectMessage.setObject(remark);
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            return objectMessage;
        }
    }
}
