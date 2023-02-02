package com.qiushui.crm.settings.service;

import com.qiushui.crm.settings.pojo.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    /**
     * 逻辑层通过LoginActAndPwd查找返回User对象
     * @param map
     * @return
     */
    public User queryUserByLoginActAndPwd(Map<String,Object> map);

    public List<User> queryAllUsers();
}
