package com.qiushui.crm.commons.utils;

import org.apache.poi.hssf.usermodel.HSSFCell;

public class CellValueUtil {
    private CellValueUtil(){}

    public static String getCellValue(HSSFCell cell){
        String cellValue="";
        if (cell.getCellType()==HSSFCell.CELL_TYPE_STRING){
            cellValue = cell.getStringCellValue();
        } else if (cell.getCellType()==HSSFCell.CELL_TYPE_NUMERIC) {
            cellValue = cell.getNumericCellValue()+"";
        }else if (cell.getCellType()==HSSFCell.CELL_TYPE_BOOLEAN) {
            cellValue = cell.getBooleanCellValue()+"";
        }else {
            cellValue ="";
        }
        return cellValue;
    }
}
