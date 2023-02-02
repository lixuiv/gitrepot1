package com.qiushui.crm.workbench.mapper;

import com.qiushui.crm.workbench.pojo.ClueRemark;
import java.util.List;

public interface ClueRemarkMapper {
    int deleteDataByClueId(String id);

    int insert(ClueRemark row);

    ClueRemark selectByPrimaryKey(String id);

    int updateByPrimaryKey(ClueRemark row);

    List<ClueRemark> selectClueRemarkByClueId(String id);

    List<ClueRemark> selectClueForOriginByClueId(String id);

}
