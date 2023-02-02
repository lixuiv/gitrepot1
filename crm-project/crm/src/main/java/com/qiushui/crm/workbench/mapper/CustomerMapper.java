package com.qiushui.crm.workbench.mapper;

import com.qiushui.crm.workbench.pojo.Customer;
import java.util.List;

public interface CustomerMapper {
    int deleteByPrimaryKey(String id);

    int insertCustomerForOrigin(Customer row);

    Customer selectOriginByAccurateName(String name);

    List<String> selectModifyNameByFuzzyName(String fuzzyName);

    int updateByPrimaryKey(Customer row);
}
