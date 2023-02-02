package com.qiushui.crm.workbench.mapper;

import com.qiushui.crm.workbench.pojo.Contacts;
import java.util.List;

public interface ContactsMapper {
    int deleteByPrimaryKey(String id);

    int insertForOrigin(Contacts row);

    Contacts selectByPrimaryKey(String id);

    List<Contacts> selectAll();

    int updateByPrimaryKey(Contacts row);
}
