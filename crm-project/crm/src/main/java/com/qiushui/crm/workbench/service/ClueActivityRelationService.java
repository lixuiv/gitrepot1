package com.qiushui.crm.workbench.service;

import com.qiushui.crm.workbench.pojo.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {
    int saveClueActivityRelationByIds(List<ClueActivityRelation> list);

    int deleteByClueAndActivityId(ClueActivityRelation clueActivityRelation);
}
