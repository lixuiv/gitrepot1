package com.qiushui.crm.commons.pojo;

import com.qiushui.crm.commons.constants.Constans;

public class ReturnObjectMessage {
    private String code;
    private String message;
    private Object object;

    public ReturnObjectMessage() {
        this.code= Constans.RETURN_OBJECT_FAILURE;
        this.message="系统异常，请联系管理员...";
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getObject() {
        return object;
    }

    public void setObject(Object object) {
        this.object = object;
    }
}
