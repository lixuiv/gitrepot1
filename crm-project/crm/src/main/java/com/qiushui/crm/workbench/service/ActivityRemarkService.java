package com.qiushui.crm.workbench.service;

import com.qiushui.crm.workbench.pojo.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {
    List<ActivityRemark> queryDetailByActivityId(String id);

    int saveActivityRemark(ActivityRemark activityRemark);

    int deleteByPrimaryKey(String id);

    int editByPrimaryKey(ActivityRemark activityRemark);
}
