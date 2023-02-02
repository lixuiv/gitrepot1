package com.qiushui.crm.workbench.mapper;

import com.qiushui.crm.workbench.pojo.CustomerRemark;
import java.util.List;

public interface CustomerRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insertOriginData(List<CustomerRemark> list);

    CustomerRemark selectByPrimaryKey(String id);

    List<CustomerRemark> selectAll();

    int updateByPrimaryKey(CustomerRemark row);
}
