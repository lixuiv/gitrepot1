package com.qiushui.crm.commons.utils;

import java.util.UUID;

public class UUIDUtil {
    private UUIDUtil(){}

    public static String getUUID(){
        return UUID.randomUUID().toString().replaceAll("-", "");
    }
}
