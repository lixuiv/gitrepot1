package com.qiushui.crm.workbench.service.impl;

import com.qiushui.crm.commons.constants.Constans;
import com.qiushui.crm.commons.utils.DateFormatUtil;
import com.qiushui.crm.commons.utils.UUIDUtil;
import com.qiushui.crm.settings.pojo.User;
import com.qiushui.crm.workbench.mapper.*;
import com.qiushui.crm.workbench.pojo.*;
import com.qiushui.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;


    @Override
    public int saveClue(Clue row) {
        return clueMapper.insertClue(row);
    }

    @Override
    public Clue queryClueByPrimaryKey(String id) {
        return clueMapper.selectClueByPrimaryKey(id);
    }

    @Override
    public void clueConvertByConvertBtn(Map<String, Object> map) {
        String clueId = (String) map.get("clueId");
        User user = (User) map.get(Constans.SESSION_LOGIN_INF);

        //第一步：获取线索pojo，得到客户和联系人的pojo存到表里
        Clue clue = clueMapper.selectClueOfOriginDetailByPrimaryKey(clueId);
        //1.1插入Customer，判断客户存不存在，存在则不添加客户
        Customer customer = customerMapper.selectOriginByAccurateName(clue.getCompany());
        if (customer==null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(user.getId());
            customer.setName(clue.getCompany());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setCreateTime(DateFormatUtil.formatDateTime(new Date()));
            customer.setCreateBy(user.getId());
            customer.setContactSummary(clue.getContactSummary());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setDescription(clue.getDescription());
            customer.setAddress(clue.getAddress());
            customerMapper.insertCustomerForOrigin(customer);
        }
        //1.2插入contacts
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateTime(DateFormatUtil.formatDateTime(new Date()));
        contacts.setCreateBy(user.getId());
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        contactsMapper.insertForOrigin(contacts);
        //第二步：获取线索备注pojo，得到客户和联系人的备注pojo存到表里
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueForOriginByClueId(clueId);
        if (clueRemarkList!=null&&clueRemarkList.size()>0){
            //2.1插入Customer备注pojo存到表里
            List<CustomerRemark> customerRemarkList = new ArrayList<>();
            List<ContactsRemark> contactsRemarkList = new ArrayList<>();
            CustomerRemark customerRemark =null;
            ContactsRemark contactsRemark =null;
            for (ClueRemark clueRemark : clueRemarkList) {
                //2.1插入Customer备注pojo存到表里
                customerRemark = new CustomerRemark();
                customerRemark.setId(UUIDUtil.getUUID());
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemark.setCreateBy(clueRemark.getCreateBy());
                customerRemark.setCreateTime(clueRemark.getCreateTime());
                customerRemark.setEditBy(clueRemark.getEditBy());
                customerRemark.setEditTime(clueRemark.getEditTime());
                customerRemark.setEditFlag(clueRemark.getEditFlag());
                customerRemark.setCustomerId(customer.getId());
                customerRemarkList.add(customerRemark);

                //2.2插入联系人的备注pojo存到表里
                contactsRemark = new ContactsRemark();
                contactsRemark.setId(UUIDUtil.getUUID());
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemark.setCreateBy(clueRemark.getCreateBy());
                contactsRemark.setCreateTime(clueRemark.getCreateTime());
                contactsRemark.setEditBy(clueRemark.getEditBy());
                contactsRemark.setEditTime(clueRemark.getEditTime());
                contactsRemark.setEditFlag(clueRemark.getEditFlag());
                contactsRemark.setContactsId(contacts.getId());
                contactsRemarkList.add(contactsRemark);
            }
            customerRemarkMapper.insertOriginData(customerRemarkList);
            contactsRemarkMapper.insertOriginData(contactsRemarkList);
        }
        //第三步：获取线索与市场活动联系的pojo，得到联系人与市场活动联系的pojo存到表里
        List<ClueActivityRelation> relationList = clueActivityRelationMapper.selectOriginByClueId(clueId);
        if (relationList!=null&&relationList.size()>0){
            List<ContactsActivityRelation> list = new ArrayList<>();
            ContactsActivityRelation contactsActivityRelation = null;
            for (ClueActivityRelation relation : relationList) {
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtil.getUUID());
                contactsActivityRelation.setActivityId(relation.getActivityId());
                contactsActivityRelation.setContactsId(contacts.getId());
                list.add(contactsActivityRelation);
            }
            contactsActivityRelationMapper.insertOriginData(list);
        }
        //第四步：创建交易
        String isCreateTran = (String) map.get("isCreateTran");
        String money = (String) map.get("money");
        String name = (String) map.get("name");
        String expectedDate = (String) map.get("expectedDate");
        String stage = (String) map.get("stage");
        String activityId = (String) map.get("activityId");
        if("true".equals(isCreateTran)){
            //insert交易
            Transaction transaction = new Transaction();
            transaction.setId(UUIDUtil.getUUID());
            transaction.setOwner(user.getId());
            transaction.setMoney(money);
            transaction.setName(name);
            transaction.setExpectedDate(expectedDate);
            transaction.setCustomerId(customer.getId());
            transaction.setStage(stage);
            transaction.setActivityId(activityId);
            transaction.setContactsId(contacts.getId());
            transaction.setCreateBy(user.getId());
            transaction.setCreateTime(DateFormatUtil.formatDateTime(new Date()));
            transactionMapper.insertOriginData(transaction);

            //insert交易备注
            if (clueRemarkList!=null&&clueRemarkList.size()>0){
                ArrayList<TransactionRemark> transactionRemarks = new ArrayList<>();
                TransactionRemark transactionRemark =null;
                for (ClueRemark clueRemark : clueRemarkList) {
                    transactionRemark = new TransactionRemark();
                    transactionRemark.setId(UUIDUtil.getUUID());
                    transactionRemark.setNoteContent(clueRemark.getNoteContent());
                    transactionRemark.setCreateBy(clueRemark.getCreateBy());
                    transactionRemark.setCreateTime(clueRemark.getCreateTime());
                    transactionRemark.setEditBy(clueRemark.getEditBy());
                    transactionRemark.setEditTime(clueRemark.getEditTime());
                    transactionRemark.setEditFlag(clueRemark.getEditFlag());
                    transactionRemark.setTranId(transaction.getId());

                    transactionRemarks.add(transactionRemark);
                }
                transactionRemarkMapper.insertOriginData(transactionRemarks);
            }
        }

        //按部就班的删除关于线索的表数据
        //relation remark clue
        clueActivityRelationMapper.deleteRelationByClueId(clueId);
        //clueRemarkMapper.deleteDataByClueId(clueId);
        //clueMapper.deleteDataByClueId(clueId);
    }
}
