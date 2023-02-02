package com.qiushui.crm.workbench.service;

import com.qiushui.crm.workbench.pojo.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    int saveCreateActivity(Activity activity);

    int saveActivityByFile(List<Activity> activityList);

    List<Activity> queryActivityByConditionForPage(Map<Object,Object> map);

    int queryCountOfActivityForPage(Map<Object,Object> map);

    int deleteActivityRemarkByIds(String[] ids);

    Activity queryActivityById(String id);

    int editActivityRemark(Activity activity);

    List<Activity> queryActivityForExport(String[] ids);

    List<Activity> queryActivityByClueId(String id);

    List<Activity> queryActivityForFuzzy(Map map);

    List<Activity> queryActivityFuzzyForConvert(Map map);

    List<Activity> queryModifyActivityFuzzyForSave(String value);
}
