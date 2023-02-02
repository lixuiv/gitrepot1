package com.qiushui.crm.workbench.mapper;

import com.qiushui.crm.workbench.pojo.Clue;
import java.util.List;

public interface ClueMapper {
    int deleteDataByClueId(String id);

    int insertClue(Clue row);

    Clue selectClueByPrimaryKey(String id);

    List<Clue> selectAll();

    int updateByPrimaryKey(Clue row);

    Clue selectClueOfOriginDetailByPrimaryKey(String id);
}
