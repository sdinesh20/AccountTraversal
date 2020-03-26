public class TestDataFactory {
    private static final string ALIAS = 'standt';
    private static final string EMAIL = 'standarduser@testorg.com';
    private static final string ENCODING_KEY = 'UTF-8';
    private static final string LAST_NAME = 'Testing';
    private static final string LOCALE_KEY = 'en_US';
    private static final string SID_KEY = 'America/Los_Angeles';
    private static final string SYS_ADMIN = 'SystemAdministrator';
    private static final string USER_NAME = '@testorg.com';
    private static final string ACCOUNT_NUMBER = 'CC634267';
    
    public static User createUser(Profile P){
        
        User usr = new User(Alias = ALIAS, Email= EMAIL, 
                            EmailEncodingKey= ENCODING_KEY, LastName= LAST_NAME, LanguageLocaleKey= LOCALE_KEY, 
                            LocaleSidKey= LOCALE_KEY, ProfileId = p.Id,TimeZoneSidKey= SID_KEY, UserName= SYS_ADMIN + String.valueof(system.now().millisecond())+USER_NAME,IsActive = true);
        return usr;
    }
    
    public static Profile getProfile(String name){
        return [SELECT Id FROM Profile WHERE Name=: name];
    }
    
    public static List<Account> createParentAccount(string name, User usr,Integer Count){
        list<Account> acclist = new list<Account>();
        Account acc = null;
        for(integer i = 1; i <= count; i++){
            acc = new Account(Name = name+i, OwnerId = usr.id,AccountNumber= ACCOUNT_NUMBER);
            acclist.add(acc);
        }
        return acclist;
    }
    
    public static List<Account> createChildAccount(Account parent,string name, User usr,Integer Count){
        list<Account> acclist = new list<Account>();
        Account acc = null;
        for(integer i = 1; i <= count; i++){
            acc = new Account(Name = name+i, OwnerId = usr.id,AccountNumber= ACCOUNT_NUMBER,parentId = parent.Id,AnnualRevenue = 2000 * i);
            acclist.add(acc);
        }
        return acclist;
    }
}