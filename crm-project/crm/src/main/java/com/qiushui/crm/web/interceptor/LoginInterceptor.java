package com.qiushui.crm.web.interceptor;

import com.qiushui.crm.commons.constants.Constans;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        HttpSession session = request.getSession(false);
        if (session==null||session.getAttribute(Constans.SESSION_LOGIN_INF)==null){
            response.sendRedirect(request.getContextPath());
            return false;
        }
        return true;
    }
}
