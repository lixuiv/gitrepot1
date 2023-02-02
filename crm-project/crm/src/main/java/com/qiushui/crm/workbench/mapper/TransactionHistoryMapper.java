package com.qiushui.crm.workbench.mapper;

import com.qiushui.crm.workbench.pojo.TransactionHistory;
import java.util.List;

public interface TransactionHistoryMapper {
    int deleteByPrimaryKey(String id);

    int insertOriginData(TransactionHistory row);

    TransactionHistory selectByPrimaryKey(String id);

    List<TransactionHistory> selectModifyDataByTranId(String id);

    int updateByPrimaryKey(TransactionHistory row);
}
