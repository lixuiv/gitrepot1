package com.qiushui.crm.workbench.service;

import com.qiushui.crm.workbench.pojo.TransactionHistory;

import java.util.List;

public interface TransactionHistoryService {
    List<TransactionHistory> selectModifyDataByTranId(String id);
}
