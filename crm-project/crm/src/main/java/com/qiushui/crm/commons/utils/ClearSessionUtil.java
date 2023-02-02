package com.qiushui.crm.commons.utils;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ClearSessionUtil {
    private ClearSessionUtil(){}

    public static void clearLoginInformation(HttpServletRequest request, HttpServletResponse response){
        Cookie loginActCookie = new Cookie("loginAct", "1");
        Cookie loginPwdCookie = new Cookie("loginPwd", "0");
        loginActCookie.setPath(request.getContextPath());
        loginPwdCookie.setPath(request.getContextPath());
        loginActCookie.setMaxAge(0);
        loginPwdCookie.setMaxAge(0);
        response.addCookie(loginActCookie);
        response.addCookie(loginPwdCookie);
    }

}
