package com.qiushui.crm.workbench.service.impl;

import com.qiushui.crm.workbench.mapper.ClueActivityRelationMapper;
import com.qiushui.crm.workbench.pojo.ClueActivityRelation;
import com.qiushui.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Transactional
@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Override
    public int saveClueActivityRelationByIds(List<ClueActivityRelation> list) {
        return clueActivityRelationMapper.insertClueActivityRelationByIds(list);
    }

    @Override
    public int deleteByClueAndActivityId(ClueActivityRelation clueActivityRelation) {
        return clueActivityRelationMapper.deleteByClueAndActivityId(clueActivityRelation);
    }
}
