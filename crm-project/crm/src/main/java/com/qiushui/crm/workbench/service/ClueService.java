package com.qiushui.crm.workbench.service;

import com.qiushui.crm.workbench.pojo.Clue;
import org.springframework.stereotype.Service;

import java.util.Map;


public interface ClueService {
    int saveClue(Clue row);

    Clue queryClueByPrimaryKey(String id);

    void clueConvertByConvertBtn(Map<String,Object> map);
}
