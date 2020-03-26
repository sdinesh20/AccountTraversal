public class RecurrsiveExecution {
    private static Map<String, Boolean> recurrsiveMap = new Map<String,Boolean>();
    Public static Boolean isAlreadyExecuted(String triggerName){
        Boolean IsExecuted = false;
        if((recurrsiveMap.isEmpty() && recurrsiveMap.Size() == 0) || (!recurrsiveMap.isEmpty() && recurrsiveMap.Size() > 0  && String.IsBlank(triggerName) && !recurrsiveMap.Containskey(triggerName)) ){
            IsExecuted = true;
        }
        return IsExecuted;
    }
    Public static Void setAlreadyExecuted(String triggerName){
        recurrsiveMap.put(triggerName,false);
    }
}