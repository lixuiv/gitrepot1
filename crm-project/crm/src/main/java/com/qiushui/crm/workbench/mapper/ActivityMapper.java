package com.qiushui.crm.workbench.mapper;

import com.qiushui.crm.workbench.pojo.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    int deleteActivityRemarkByIds(String[] ids);

    int insertActivity(Activity row);

    int insertActivityByFile(List<Activity> activityList);

    List<Activity> selectActivityByConditionForPage(Map<Object,Object> map);

    int selectCountOfActivityForPage(Map<Object,Object> map);

    Activity selectActivityById(String id);

    int updateActivityRemark(Activity activity);


    List<Activity> selectActivityForExport(String[] ids);

    List<Activity> selectActivityByClueId(String id);
    List<Activity> selectActivityForFuzzy(Map map);

    List<Activity> selectActivityFuzzyForConvert(Map map);

    List<Activity> selectModifyActivityFuzzyForSave(String value);
}
