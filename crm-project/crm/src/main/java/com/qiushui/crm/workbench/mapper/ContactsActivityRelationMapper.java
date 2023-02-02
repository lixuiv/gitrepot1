package com.qiushui.crm.workbench.mapper;

import com.qiushui.crm.workbench.pojo.ContactsActivityRelation;
import java.util.List;

public interface ContactsActivityRelationMapper {
    int deleteByPrimaryKey(String id);

    int insertOriginData(List<ContactsActivityRelation> list);

    ContactsActivityRelation selectByPrimaryKey(String id);

    List<ContactsActivityRelation> selectAll();

    int updateByPrimaryKey(ContactsActivityRelation row);
}
