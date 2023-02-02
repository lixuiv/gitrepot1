package com.qiushui.crm.workbench.service.impl;

import com.qiushui.crm.workbench.mapper.CustomerMapper;
import com.qiushui.crm.workbench.pojo.Customer;
import com.qiushui.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public List<String> queryModifyNameByFuzzyName(String fuzzyName) {
        return customerMapper.selectModifyNameByFuzzyName(fuzzyName);
    }
}
