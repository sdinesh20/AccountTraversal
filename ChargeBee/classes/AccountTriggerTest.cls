@isTest(SeeAllData=false)
public class AccountTriggerTest {
	private static final string STR_SYS_ADMIN = 'System Administrator';
    private static final string KEYWORD_TEST = 'Test';
    
    @testSetup static void setup() {        
        Profile prf = TestDataFactory.getProfile(STR_SYS_ADMIN);
        User usr = TestDataFactory.createUser(prf);

        Database.insert(usr);
        
        system.runAs(usr){
            list<Account> acclist = TestDataFactory.createParentAccount(KEYWORD_TEST, usr,1);
            Database.insert(acclist);
        }
    }
    /**
    * @description test method for Insert child account with Revenue
    */
    @isTest static void testInsertChildAccount(){
        User usr = [Select id from User limit 1];
        
        system.runAs(usr){
            Account acc = [Select Id,Name from Account Limit 1];
            Test.startTest();
                list<Account> acclist = TestDataFactory.createChildAccount(acc,KEYWORD_TEST, usr,2);
                Database.insert(acclist);
            Test.stopTest();
            Account parent = [Select id,AnnualRevenue from Account where Id =: acc.Id];
            system.assert(parent.AnnualRevenue == 6000);
        } 
    }
    /**
    * @description test method for Updating child account with Revenue
    */
    @isTest static void testupdateChildAccount(){
        User usr = [Select id from User limit 1];
        
        system.runAs(usr){
            Account acc = [Select Id,Name from Account Limit 1];
            Test.startTest();
                list<Account> acclist = TestDataFactory.createChildAccount(acc,KEYWORD_TEST, usr,2);
                Database.insert(acclist);
            acclist[0].AnnualRevenue = 4000;
            Database.update(acclist);
            Test.stopTest();
            Account parent = [Select id,AnnualRevenue from Account where Id =: acc.Id];
            system.assert(parent.AnnualRevenue == 8000);
        } 
    }
        /**
    * @description test method for Delete child account with Revenue
    */
    @isTest static void testDeleteChildAccount(){
        User usr = [Select id from User limit 1];
        
        system.runAs(usr){
            Account acc = [Select Id,Name from Account Limit 1];
            Test.startTest();
                list<Account> acclist = TestDataFactory.createChildAccount(acc,KEYWORD_TEST, usr,2);
                Database.insert(acclist);
            Delete acclist[0];
            Test.stopTest();
            Account parent = [Select id,AnnualRevenue from Account where Id =: acc.Id];
            system.assert(parent.AnnualRevenue == 4000);
        } 
    }
}