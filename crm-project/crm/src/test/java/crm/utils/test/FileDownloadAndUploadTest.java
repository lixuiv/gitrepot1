package crm.utils.test;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.junit.Test;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class FileDownloadAndUploadTest {
    @Test
    public void testDownloadExcel(){
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("学生表单");
        HSSFRow row = sheet.createRow(0);
        //设置列的内容
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("学号");
        cell = row.createCell(1);
        cell.setCellValue("姓名");
        cell = row.createCell(2);
        cell.setCellValue("QQ号");
        //设置里面的内容
        for (int i=1;i<22;i++){
            row= sheet.createRow(i);
            cell=row.createCell(0);
            cell.setCellValue("2020093"+i);
            cell=row.createCell(1);
            cell.setCellValue("张三");
            cell=row.createCell(2);
            cell.setCellValue("22508110"+i);
        }
        //通过流的方式输出

        FileOutputStream os=null;
        try {
            os = new FileOutputStream("F:\\astudyideaplugins\\文件\\测试文件\\student.xls");
            workbook.write(os);
        } catch (FileNotFoundException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        } finally {
            if (os!=null){
                try {
                    os.close();
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
        }
        try {
            workbook.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }



}
