package com.qiushui.crm.workbench.service.impl;

import com.qiushui.crm.workbench.mapper.TransactionRemarkMapper;
import com.qiushui.crm.workbench.pojo.TransactionRemark;
import com.qiushui.crm.workbench.service.TransactionRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
@Transactional
@Service
public class TransactionRemarkServiceImpl implements TransactionRemarkService {
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;
    @Override
    public List<TransactionRemark> queryModifyDataByTranId(String id) {
        return transactionRemarkMapper.selectModifyDataByTranId(id);
    }
}
