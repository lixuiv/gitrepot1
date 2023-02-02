package com.qiushui.crm.workbench.service.impl;

import com.qiushui.crm.workbench.mapper.ActivityMapper;
import com.qiushui.crm.workbench.pojo.Activity;
import com.qiushui.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityMapper activityMapper;

    @Override
    public int saveCreateActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public int saveActivityByFile(List<Activity> activityList) {
        return activityMapper.insertActivityByFile(activityList);
    }

    /**
     * 分页查询，逻辑层
     * @param map
     * @return
     */
    @Override
    public List<Activity> queryActivityByConditionForPage(Map<Object,Object> map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    @Override
    public int queryCountOfActivityForPage(Map<Object, Object> map) {
        return activityMapper.selectCountOfActivityForPage(map);
    }

    @Override
    public int deleteActivityRemarkByIds(String[] ids) {
        return activityMapper.deleteActivityRemarkByIds(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public int editActivityRemark(Activity activity) {
        return activityMapper.updateActivityRemark(activity);
    }

    @Override
    public List<Activity> queryActivityForExport(String[] ids) {
        return activityMapper.selectActivityForExport(ids);
    }

    @Override
    public List<Activity> queryActivityByClueId(String id) {
        return activityMapper.selectActivityByClueId(id);
    }

    @Override
    public List<Activity> queryActivityForFuzzy(Map map) {
        return activityMapper.selectActivityForFuzzy(map);
    }

    @Override
    public List<Activity> queryActivityFuzzyForConvert(Map map) {
        return activityMapper.selectActivityFuzzyForConvert(map);
    }

    @Override
    public List<Activity> queryModifyActivityFuzzyForSave(String value) {
        return activityMapper.selectModifyActivityFuzzyForSave(value);
    }


}
