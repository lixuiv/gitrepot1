package com.qiushui.crm.workbench.service;

import com.qiushui.crm.workbench.pojo.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
    List<ClueRemark> queryClueRemarkByClueId(String id);
}
