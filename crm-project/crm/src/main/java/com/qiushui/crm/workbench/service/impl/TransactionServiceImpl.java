package com.qiushui.crm.workbench.service.impl;

import com.qiushui.crm.commons.constants.Constans;
import com.qiushui.crm.commons.pojo.ReturnChartObject;
import com.qiushui.crm.commons.utils.DateFormatUtil;
import com.qiushui.crm.commons.utils.UUIDUtil;
import com.qiushui.crm.settings.pojo.User;
import com.qiushui.crm.workbench.mapper.CustomerMapper;
import com.qiushui.crm.workbench.mapper.TransactionHistoryMapper;
import com.qiushui.crm.workbench.mapper.TransactionMapper;
import com.qiushui.crm.workbench.pojo.Customer;
import com.qiushui.crm.workbench.pojo.Transaction;
import com.qiushui.crm.workbench.pojo.TransactionHistory;
import com.qiushui.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Transactional
@Service
public class TransactionServiceImpl implements TransactionService {
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;
    @Override
    public void saveTransactionUseTran(Map<String, Object> map) {
        User user = (User) map.get(Constans.SESSION_LOGIN_INF);
        String customerName = (String) map.get("customerName");
        //检验客户是否为空，为空则新建
        Customer customer = customerMapper.selectOriginByAccurateName(customerName);
        if (customer==null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateFormatUtil.formatDateTime(new Date()));
            customerMapper.insertCustomerForOrigin(customer);
        }
        //创建交易pojo后插入relation里
        Transaction transaction = new Transaction();

        //设置参数
        transaction.setId(UUIDUtil.getUUID());
        transaction.setCreateBy(user.getId());
        transaction.setCreateTime(DateFormatUtil.formatDateTime(new Date()));
        transaction.setOwner(((String) map.get("owner")));
        transaction.setMoney(((String) map.get("money")));
        transaction.setName(((String) map.get("name")));
        transaction.setExpectedDate(((String) map.get("expectedDate")));
        transaction.setCustomerId(customer.getId());
        transaction.setStage(((String) map.get("stage")));
        transaction.setType(((String) map.get("type")));
        transaction.setSource(((String) map.get("source")));
        transaction.setActivityId(((String) map.get("activityId")));
        transaction.setContactsId(((String) map.get("contactsId")));
        transaction.setDescription(((String) map.get("description")));
        transaction.setContactSummary(((String) map.get("contactSummary")));
        transaction.setNextContactTime(((String) map.get("nextContactTime")));

        transactionMapper.insertOriginData(transaction);
        //把该次内容插入交易历史表里面
        TransactionHistory transactionHistory = new TransactionHistory();
        transactionHistory.setId(UUIDUtil.getUUID());
        transactionHistory.setCreateBy(user.getId());
        transactionHistory.setCreateTime(DateFormatUtil.formatDateTime(new Date()));
        transactionHistory.setStage(((String) map.get("stage")));
        transactionHistory.setMoney(((String) map.get("money")));
        transactionHistory.setExpectedDate(((String) map.get("expectedDate")));
        transactionHistory.setTranId(transaction.getId());
        transactionHistoryMapper.insertOriginData(transactionHistory);
    }

    @Override
    public Transaction queryModifyDataByPrimaryKey(String id) {
        return transactionMapper.selectModifyDataByPrimaryKey(id);
    }

    @Override
    public List<ReturnChartObject> queryReturnChartPojoByGroupByStage() {
        return transactionMapper.selectReturnChartPojoByGroupByStage();
    }
}
