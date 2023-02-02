package com.qiushui.crm.workbench.service;

import com.qiushui.crm.workbench.pojo.Customer;

import java.util.List;

public interface CustomerService {
    List<String> queryModifyNameByFuzzyName(String fuzzyName);
}
