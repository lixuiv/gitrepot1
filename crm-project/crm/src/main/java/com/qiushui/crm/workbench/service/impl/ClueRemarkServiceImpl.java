package com.qiushui.crm.workbench.service.impl;

import com.qiushui.crm.workbench.mapper.ClueMapper;
import com.qiushui.crm.workbench.mapper.ClueRemarkMapper;
import com.qiushui.crm.workbench.pojo.ClueRemark;
import com.qiushui.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public List<ClueRemark> queryClueRemarkByClueId(String id) {
        return clueRemarkMapper.selectClueRemarkByClueId(id);
    }
}
