package com.qiushui.crm.workbench.mapper;

import com.qiushui.crm.workbench.pojo.ActivityRemark;
import java.util.List;

public interface ActivityRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insertActivityRemark(ActivityRemark activityRemark);

    List<ActivityRemark> selectDetailByActivityId(String id);

    List<ActivityRemark> selectAll();

    int updateByPrimaryKey(ActivityRemark activityRemark);
}
