package com.qiushui.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MixController {
    @RequestMapping("workbench/contacts/toContactsIndex")
    public String toContactsIndex(){
        return "workbench/contacts/index";
    }
    @RequestMapping("workbench/customer/toCustomerIndex")
    public String toCustomerIndex(){
        return "workbench/customer/index";
    }
}
