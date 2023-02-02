package com.qiushui.crm.workbench.mapper;

import com.qiushui.crm.workbench.pojo.ClueActivityRelation;
import java.util.List;

public interface ClueActivityRelationMapper {
    int deleteByClueAndActivityId(ClueActivityRelation clueActivityRelation);

    int insertClueActivityRelationByIds(List<ClueActivityRelation> list);

    ClueActivityRelation selectByPrimaryKey(String id);

    List<ClueActivityRelation> selectOriginByClueId(String id);

    int updateByPrimaryKey(ClueActivityRelation row);

    int deleteRelationByClueId(String id);
}
