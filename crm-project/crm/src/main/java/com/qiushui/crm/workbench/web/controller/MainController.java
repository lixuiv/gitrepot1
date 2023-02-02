package com.qiushui.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {
    @RequestMapping("workbench/main/toIndex")
    public String toIndex(){
        return "workbench/main/index";
    }
}
