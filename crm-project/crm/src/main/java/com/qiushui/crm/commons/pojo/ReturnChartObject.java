package com.qiushui.crm.commons.pojo;

public class ReturnChartObject {
    private String name;
    private int value;

    public ReturnChartObject() {
    }

    @Override
    public String toString() {
        return "ReturnChartObject{" +
                "name='" + name + '\'' +
                ", value=" + value +
                '}';
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }
}
