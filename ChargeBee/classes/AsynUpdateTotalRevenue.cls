public without sharing class AsynUpdateTotalRevenue implements Queueable{
    private List<Account> updateAcclst = new List<Account>();
    Private Set<Id> ParentIdSet = new set<Id>();
    public AsynUpdateTotalRevenue(Set<Id> accountIds) {
        this.ParentIdSet = accountIds;
    }    
    public void execute(QueueableContext context) {
        Boolean isTopLevel = false;
        set<Id> tempaccIdset = ParentIdSet;
        ParentIdSet.clear();
        While(!isTopLevel && ((Limits.getLimitQueries() - Limits.getQueries()) > 0)){ //Assuming Account Hierarchy will not exceed 200 level. If it exceeds we can invoke 4 Async Jobs.
            Account acc = null;
            Id parentId = null;
            for(AggregateResult aggr : [Select ParentId accId,SUM(AnnualRevenue) totalRevenue, Parent.ParentId parent from Account where ParentId In:tempaccIdset Group by ParentId,Parent.ParentId]){
                acc = new Account();
                acc.Id = (Id) aggr.get(ConstantUtil.ACCID);
                acc.AnnualRevenue = (Decimal) aggr.get(ConstantUtil.TOTAL_REVENUE);
                updateAcclst.add(acc);
                parentId = (Id) aggr.get(ConstantUtil.PARENT);
                if(String.isNotBlank(String.valueOf(parentId))){
                    ParentIdSet.add(parentId);
                }
            }
            if(ParentIdSet.isEmpty()){
                isTopLevel = true;
            } 
        }
        if(!updateAcclst.IsEmpty() && updateAcclst.Size() > 0){
            try{
                RecurrsiveExecution.setAlreadyExecuted(ConstantUtil.ACCOUNT_TRIGGER);
                Database.update(updateAcclst,false);
            }Catch(Exception ex){
                //Exception Logic can be handled here.
            }
        } 
    }
}