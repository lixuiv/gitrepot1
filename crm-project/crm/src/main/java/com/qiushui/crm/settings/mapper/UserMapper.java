package com.qiushui.crm.settings.mapper;

import com.qiushui.crm.settings.pojo.User;
import java.util.List;
import java.util.Map;

public interface UserMapper {
    int deleteByPrimaryKey(String id);

    int insert(User row);

    User selectByPrimaryKey(String id);

    List<User> selectAllUsers();

    int updateByPrimaryKey(User row);

    User selectUserByLoginActAndPwd(Map<String,Object> map);
}
