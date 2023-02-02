package com.qiushui.crm.settings.service;


import com.qiushui.crm.settings.pojo.DicValue;

import java.util.List;

public interface DicValueService {
    List<DicValue> queryDicValueGroupByDicType(String dicTypeCode);
}
