package com.qiushui.crm.workbench.service;

import com.qiushui.crm.commons.pojo.ReturnChartObject;
import com.qiushui.crm.workbench.pojo.Transaction;

import java.util.List;
import java.util.Map;

public interface TransactionService {
    void saveTransactionUseTran(Map<String,Object> map);

    Transaction queryModifyDataByPrimaryKey(String id);

    List<ReturnChartObject> queryReturnChartPojoByGroupByStage();
}
