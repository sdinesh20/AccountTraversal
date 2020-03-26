trigger AccountTrigger on Account (after insert, after update, after delete) {
    if (trigger.isAfter && (trigger.IsInsert || trigger.isUpdate || trigger.IsDelete)) {
        if(RecurrsiveExecution.isAlreadyExecuted(ConstantUtil.ACCOUNT_TRIGGER)) { //To Handle Recurrsive
            AccountTriggerHelper.updateTotalRevenue(trigger.new,trigger.OldMap);
        }
    }
}