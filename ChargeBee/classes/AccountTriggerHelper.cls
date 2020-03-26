public class AccountTriggerHelper {
    public static void updateTotalRevenue (List<Account> newAccountlst, Map<Id, Account> oldAccMap) {
        Account oldacc = null;
        set<Id> ParentIdSet = new set<Id>();
        List<Account> updateAcclst = new List<Account>();
        if(newAccountlst != null && newAccountlst.size() > 0){
            for(Account a : newAccountlst){
                oldacc = oldAccMap != null && oldAccMap.Size() > 0 && oldAccMap.containskey(a.Id) ? oldAccMap.get(a.Id) : null;
                if(String.isNotBlank(a.ParentId) && ((oldacc == null && String.IsNotblank(String.Valueof(a.AnnualRevenue))) || (oldacc != null && String.IsNotblank(String.Valueof(a.AnnualRevenue)) && a.AnnualRevenue != oldacc.AnnualRevenue)) ){
                    ParentIdSet.add(a.ParentId);
                }
            }
        }else if(oldAccMap != null && oldAccMap.size() > 0){
            for(Account old : oldAccMap.values()){
                if(String.isNotBlank(old.ParentId)){
                    ParentIdSet.add(old.ParentId);
                }
            }
        }
        if(!ParentIdSet.IsEmpty() && ParentIdSet.Size() > 0) {
            set<Id> tempParentId = ParentIdSet;
            ParentIdSet.Clear();
            Account acc = null;
            Id parentId = null;
            try{
                for(AggregateResult aggr : [Select ParentId accId,SUM(AnnualRevenue) totalRevenue, Parent.ParentId parent from Account where ParentId In:tempParentId Group by ParentId,Parent.ParentId]){
                    acc = new Account();
                    acc.Id = (Id) aggr.get(ConstantUtil.ACCID);
                    acc.AnnualRevenue = (Decimal) aggr.get(ConstantUtil.TOTAL_REVENUE);
                    updateAcclst.add(acc);
                    parentId = (Id) aggr.get(ConstantUtil.PARENT);
                    if(String.isNotBlank(String.valueOf(parentId))){
                        ParentIdSet.add(parentId);
                    }
                }
                if(!updateAcclst.IsEmpty() && updateAcclst.Size() > 0){
                    
                    RecurrsiveExecution.setAlreadyExecuted(ConstantUtil.ACCOUNT_TRIGGER);
                    Database.update(updateAcclst,false);
					if(!parentIdSet.IsEmpty()){
                        System.enqueuejob(new AsynUpdateTotalRevenue(ParentIdSet));
                    }                    
                }                
            }Catch(Exception ex){
                //Exception Logic can be handled here.
            }
        }
    }
    
}