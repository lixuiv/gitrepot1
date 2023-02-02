package com.qiushui.crm.workbench.mapper;

import com.qiushui.crm.commons.pojo.ReturnChartObject;
import com.qiushui.crm.workbench.pojo.Transaction;
import java.util.List;

public interface TransactionMapper {
    int deleteByPrimaryKey(String id);

    int insertOriginData(Transaction row);

    Transaction selectByPrimaryKey(String id);

    List<Transaction> selectAll();

    int updateByPrimaryKey(Transaction row);

    Transaction selectModifyDataByPrimaryKey(String id);

    List<ReturnChartObject> selectReturnChartPojoByGroupByStage();
}
