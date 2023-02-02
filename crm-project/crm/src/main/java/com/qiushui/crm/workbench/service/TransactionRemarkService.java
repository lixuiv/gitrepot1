package com.qiushui.crm.workbench.service;

import com.qiushui.crm.workbench.pojo.TransactionRemark;

import java.util.List;

public interface TransactionRemarkService {
    List<TransactionRemark> queryModifyDataByTranId(String id);
}
