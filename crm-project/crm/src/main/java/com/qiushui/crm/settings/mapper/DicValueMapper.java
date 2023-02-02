package com.qiushui.crm.settings.mapper;

import com.qiushui.crm.settings.pojo.DicValue;
import java.util.List;

public interface DicValueMapper {
    int deleteByPrimaryKey(String id);

    int insert(DicValue row);

    DicValue selectByPrimaryKey(String id);

    List<DicValue> selectDicValueGroupByDicType(String dicTypeCode);

    int updateByPrimaryKey(DicValue row);
}
