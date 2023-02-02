package com.qiushui.crm.workbench.mapper;

import com.qiushui.crm.workbench.pojo.TransactionRemark;
import java.util.List;

public interface TransactionRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insertOriginData(List<TransactionRemark> list);

    TransactionRemark selectByPrimaryKey(String id);

    List<TransactionRemark> selectAll();

    int updateByPrimaryKey(TransactionRemark row);

    List<TransactionRemark> selectModifyDataByTranId(String id);
}
