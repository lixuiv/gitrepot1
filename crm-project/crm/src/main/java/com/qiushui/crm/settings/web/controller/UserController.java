package com.qiushui.crm.settings.web.controller;

import com.qiushui.crm.commons.constants.Constans;
import com.qiushui.crm.commons.pojo.ReturnObjectMessage;
import com.qiushui.crm.commons.utils.ClearSessionUtil;
import com.qiushui.crm.commons.utils.DateFormatUtil;
import com.qiushui.crm.settings.pojo.User;
import com.qiushui.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @Autowired
    private UserService userService;

    @RequestMapping("/settings/qx/user/toLogin")
    public String toLogin(){
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/Login")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd,
                        HttpServletRequest request, HttpServletResponse response){
        //判断登陆状态
        Map<String,Object> map=new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userService.queryUserByLoginActAndPwd(map);
        //if user ==null 则说明账号和密码的联合查询查不到
        ReturnObjectMessage returnObjectMessage = new ReturnObjectMessage();
        returnObjectMessage.setCode(Constans.RETURN_OBJECT_LOGIN_FAILURE);
        if (user==null){
            //联合查询查不到,用户的账号或者密码错误
            returnObjectMessage.setMessage("用户的账号或者密码错误");
        }else{
            String expireTime = user.getExpireTime();
            String lockState = user.getLockState();
            String allowIps = user.getAllowIps();
            if (DateFormatUtil.formatDateTime(new Date()).compareTo(expireTime)>0){
                //用户账号时间过期
                returnObjectMessage.setMessage("用户账号时间过期");
            } else if ("0".equals(lockState)) {
                //用户登陆状态被锁定
                returnObjectMessage.setMessage("用户登陆状态被锁定");
            } else if (!allowIps.contains(request.getRemoteAddr())) {
                //用户ip受限
                returnObjectMessage.setMessage("用户ip受限");
            }else{
                //用户登陆成功
                returnObjectMessage.setCode(Constans.RETURN_OBJECT_LOGIN_SUCCESS);
                returnObjectMessage.setMessage("用户登陆成功");
                //往会话域里面储存信息
                request.getSession().setAttribute(Constans.SESSION_LOGIN_INF,user);
                if ("true".equals(isRemPwd)){
                    //记住十天登陆功能的代码
                    Cookie loginActCookie = new Cookie("loginAct", loginAct);
                    Cookie loginPwdCookie = new Cookie("loginPwd", loginPwd);
                    loginActCookie.setMaxAge(10*24*60*60);
                    loginPwdCookie.setMaxAge(10*24*60*60);
                    loginActCookie.setPath(request.getContextPath());
                    loginPwdCookie.setPath(request.getContextPath());
                    response.addCookie(loginActCookie);
                    response.addCookie(loginPwdCookie);
                }else {
                    //不记住十天登陆功能的代码,要销毁Cookie
                    //记住十天登陆功能的代码
                    ClearSessionUtil.clearLoginInformation(request,response);
                }

            }
        }
        return returnObjectMessage;
    }

    @RequestMapping("/settings/qx/user/logout")
    public String logout(HttpServletRequest request,HttpServletResponse response){
        ClearSessionUtil.clearLoginInformation(request,response);

        HttpSession session = request.getSession(false);
        if (session!=null){
            session.invalidate();
        }

        return "redirect:/";
    }

}
