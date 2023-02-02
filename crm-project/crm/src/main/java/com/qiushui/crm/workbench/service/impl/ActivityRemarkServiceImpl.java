package com.qiushui.crm.workbench.service.impl;

import com.qiushui.crm.workbench.mapper.ActivityRemarkMapper;
import com.qiushui.crm.workbench.pojo.ActivityRemark;
import com.qiushui.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Transactional
@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;
    @Override
    public List<ActivityRemark> queryDetailByActivityId(String id) {
        return activityRemarkMapper.selectDetailByActivityId(id);
    }

    @Override
    public int saveActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.insertActivityRemark(activityRemark);
    }

    @Override
    public int deleteByPrimaryKey(String id) {
        return activityRemarkMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int editByPrimaryKey(ActivityRemark activityRemark) {
        return activityRemarkMapper.updateByPrimaryKey(activityRemark);
    }
}
