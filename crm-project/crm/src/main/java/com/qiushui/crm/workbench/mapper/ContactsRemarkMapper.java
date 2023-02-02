package com.qiushui.crm.workbench.mapper;

import com.qiushui.crm.workbench.pojo.ContactsRemark;
import java.util.List;

public interface ContactsRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insertOriginData(List<ContactsRemark> list);

    ContactsRemark selectByPrimaryKey(String id);

    List<ContactsRemark> selectAll();

    int updateByPrimaryKey(ContactsRemark row);
}
