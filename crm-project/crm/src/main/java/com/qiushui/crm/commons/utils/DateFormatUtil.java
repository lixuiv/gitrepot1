package com.qiushui.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateFormatUtil {
    private DateFormatUtil(){}

    public static String formatDateTime(Date date){
        SimpleDateFormat sdft=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdft.format(date);
    }

    public static String formatDate(Date date){
        SimpleDateFormat sdft=new SimpleDateFormat("yyyy-MM-dd");
        return sdft.format(date);
    }
}
