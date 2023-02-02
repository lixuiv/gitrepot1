package com.qiushui.crm.settings.service.impl;

import com.qiushui.crm.settings.mapper.DicValueMapper;
import com.qiushui.crm.settings.pojo.DicValue;
import com.qiushui.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Transactional
@Service
public class DicValueServiceImpl implements DicValueService {
    @Autowired
    private DicValueMapper dicValueMapper;
    @Override
    public List<DicValue> queryDicValueGroupByDicType(String dicTypeCode) {
        return dicValueMapper.selectDicValueGroupByDicType(dicTypeCode);
    }
}
