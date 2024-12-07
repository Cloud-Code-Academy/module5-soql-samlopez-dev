/**
* The SOQLTest class is specifically designed to test the functionality of methods in the SOQL class.
* It encapsulates a series of test methods, each carefully designed to validate the individual methods in the SOQL class, ensuring they are functioning accurately and correctly.
* The Salesforce Assert class is an essential part of these test methods to assert and validate the outcomes of the SOQL queries.
*
* Test methods encapsulated in this class are devoted to testing SOQL queries, which include SELECT statements, WHERE clause filters, Relationship queries, and usage of the LIMIT keyword.
* Users of this class can expect to gain an understanding of how to write unit tests for SOQL queries in Apex and Salesforce, enabling them to validate their own custom SOQL queries.
*/

@IsTest
public with sharing class SOQLTest {
    
    @IsTest
    static void testGetAllLeads() {
        // Create test data
        Lead testLead1 = new Lead(LastName = 'Test Lead 1', Company = 'Test Company 1', Phone = '1234567890', Email = 'lead1@email.com');
        Lead testLead2 = new Lead(LastName = 'Test Lead 2', Company = 'Test Company 2', Phone = '0987654321', Email = 'lead2@email.com');
        insert new List<Lead>{testLead1, testLead2};

        // Call the method to test
        List<Lead> leads = SOQL.getAllLeads(); //Replace null with your method call from SOQL class

        // Assert that the number of leads returned is correct
        System.assertEquals(2, leads.size(), 'Number of leads returned is incorrect.');

        // Assert that the leads returned have the correct names
        Set<String> leadNames = new Set<String>{'Test Lead 1', 'Test Lead 2'};
        try {
            for (Lead lead : leads) {
                System.assert(leadNames.contains(lead.LastName), 'Lead name is incorrect.');
                Assert.isNotNull(lead.Company, 'Lead company is null.');
                Assert.isNotNull(lead.Phone, 'Lead phone is null.');
                Assert.isNotNull(lead.Email, 'Lead email is null.');
            }
        } catch (SObjectException ex) {
            Assert.fail('SObjectException thrown: ' + ex.getMessage());
        }
    }

    @IsTest
    static void testGetContactsByFirstName() {
        // Create test data
        Contact testContact1 = new Contact(FirstName = 'John', LastName = 'Doe');
        Contact testContact2 = new Contact(FirstName = 'John', LastName = 'Smith');
        Contact testContact3 = new Contact(FirstName = 'Jane', LastName = 'Doe');
        insert new List<Contact>{testContact1, testContact2, testContact3};

        // Call the method to test
        List<Contact> contacts = null; //Replace null with your method call from SOQL class

        // Assert that the number of contacts returned is correct
        System.assertEquals(2, contacts.size(), 'Number of contacts returned is incorrect.');

        // Assert that the contacts returned have the correct names
        Set<String> contactNames = new Set<String>{'John Doe', 'John Smith'};
        try {
            for (Contact contact : contacts) {
                System.assert(contactNames.contains(contact.Name), 'Contact name is incorrect.');
            }
        } catch (SObjectException ex) {
            Assert.fail('SObjectException thrown: ' + ex.getMessage());
        }
    }

    @IsTest
    static void testGetContactIdsByLastName() {
        // Create test data
        Contact testContact1 = new Contact(FirstName = 'John', LastName = 'Smith');
        Contact testContact2 = new Contact(FirstName = 'Jane', LastName = 'Jones');
        Contact testContact3 = new Contact(FirstName = 'Jack', LastName = 'Doe');
        insert new List<Contact>{testContact1, testContact2, testContact3};

        // Call the method to test
        List<Id> contactIds = null; //Replace null with your method call from SOQL class

        // Assert that the number of contact IDs returned is correct
        System.assertEquals(2, contactIds.size(), 'Number of contact IDs returned is incorrect.');

        // Assert that the contact IDs returned are correct
        Set<Id> expectedContactIds = new Set<Id>{testContact1.Id, testContact2.Id};
        System.assertEquals(expectedContactIds, new Set<Id>(contactIds), 'Returned contact IDs are incorrect.');
    }

    @IsTest
    static void testGetClosedWonOpportunityCountByAccount() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Opportunity testOpportunity1 = new Opportunity(Name = 'Test Opportunity 1', StageName = 'Closed Won', CloseDate = Date.today(), AccountId = testAccount.Id, Amount = 1000);
        Opportunity testOpportunity2 = new Opportunity(Name = 'Test Opportunity 2', StageName = 'Closed Won', CloseDate = Date.today(), AccountId = testAccount.Id, Amount = 2000);
        Opportunity testOpportunity3 = new Opportunity(Name = 'Test Opportunity 3', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = testAccount.Id, Amount = 3000);
        insert new List<Opportunity>{testOpportunity1, testOpportunity2, testOpportunity3};

        // Call the method to test
        List<Opportunity> opportunities = null; //Replace null with your method passing in testAccount.Id

        // Assert that the number of opportunities returned is correct
        System.assertEquals(2, opportunities.size(), 'Number of opportunities returned is incorrect.');

        // Assert that the opportunities returned have the correct names and stages
        Set<String> opportunityNames = new Set<String>{'Test Opportunity 1', 'Test Opportunity 2'};
        try {
            for (Opportunity opp : opportunities) {
                System.assert(opportunityNames.contains(opp.Name), 'Opportunity name is incorrect.');
                System.assertEquals('Closed Won', opp.StageName, 'Opportunity stage is not Closed Won.');
                System.assertEquals(testAccount.Id, opp.AccountId, 'Opportunity AccountId is incorrect.');
                Assert.isNotNull(opp.CloseDate, 'Opportunity CloseDate is null.');
                Assert.isNotNull(opp.Amount, 'Opportunity Amount is null.');
            }
        } catch (SObjectException ex) {
            Assert.fail('SObjectException thrown: ' + ex.getMessage());
        }
    }

    @IsTest
    static void testGetAccountCount() {

        // Generate random number of test account between 1 and 10
        Integer numAccounts = (Integer)Math.floor(Math.random() * 10) + 1;
        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < numAccounts; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        // Call the method to test
        Integer accountCount = null; //Replace null with your method call from SOQL class

        // Assert that the number of accounts returned is correct
        System.assertEquals(numAccounts, accountCount, 'Number of accounts returned is incorrect.');
    }

    @IsTest
    static void testGetTasksDueNextWeek() {
        // Create test data
        Task testTask1 = new Task(Subject = 'Test Task 1', ActivityDate = Date.today().addDays(7)); // due in 7 days
        Task testTask2 = new Task(Subject = 'Test Task 2', ActivityDate = Date.today().addDays(10)); // due in 8 days, should not be returned
        Task testTask3 = new Task(Subject = 'Test Task 3', ActivityDate = Date.today().addDays(2)); // due in 6 days
        Task testTask4 = new Task(Subject = 'Test Task 4', ActivityDate = Date.today().addDays(14)); // due in 14 days, should not be returned
        Task testTask5 = new Task(Subject = 'Test Task 5', ActivityDate = Date.today().addDays(-5)); // due in the past, should not be returned
        insert new List<Task>{testTask1, testTask2, testTask3};
    
        // Call the method to test
        Map<Id, Task> tasks = null; //Replace null with your method call from SOQL class
    
        // Assert that the number of tasks returned is correct
        System.assertEquals(2, tasks.size(), 'Number of tasks returned is incorrect.');
    
        // Assert that the tasks returned are the correct ones
        Set<Id> expectedTaskIds = new Set<Id>{testTask1.Id, testTask3.Id};
        System.assertEquals(expectedTaskIds, tasks.keySet(), 'Returned tasks are incorrect.');
    }

    @IsTest
    static void testGetContactsByEmailDomain() {
        // Create test data
        Contact testContact1 = new Contact(FirstName = 'John', LastName = 'Doe', Email = 'john@example.com');
        Contact testContact2 = new Contact(FirstName = 'Jane', LastName = 'Smith', Email = 'jane@example.com');
        Contact testContact3 = new Contact(FirstName = 'Jack', LastName = 'Brown', Email = 'jack@other.com');
        insert new List<Contact>{testContact1, testContact2, testContact3};

        // Call the method to test
        List<Contact> contacts = null; //Replace null with your method call from SOQL class

        // Assert that the number of contacts returned is correct
        System.assertEquals(2, contacts.size(), 'Number of contacts returned is incorrect.');

        // Assert that the contacts returned have the correct names and email domains
        Set<String> contactNames = new Set<String>{'John Doe', 'Jane Smith'};
        try {
            for (Contact contact : contacts) {
                System.assert(contactNames.contains(contact.Name), 'Contact name is incorrect.');
                System.assert(contact.Email.contains('example.com'), 'Contact email domain is incorrect.');
            }
        } catch (SObjectException ex) {
            Assert.fail('SObjectException thrown: ' + ex.getMessage());
        }
    }

    @IsTest
    static void testGetOpportunitiesByNameKeyword() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Opportunity testOpportunity1 = new Opportunity(Name = 'Test Opportunity 1', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = testAccount.Id);
        Opportunity testOpportunity2 = new Opportunity(Name = 'Keyword Opportunity', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = testAccount.Id);
        Opportunity testOpportunity3 = new Opportunity(Name = 'Test Opportunity 3', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = testAccount.Id);
        insert new List<Opportunity>{testOpportunity1, testOpportunity2, testOpportunity3};

        // Call the method to test
        List<Opportunity> opportunities = SOQL.getOpportunitiesByNameKeyword('Keyword');

        // Assert that the number of opportunities returned is correct
        System.assertEquals(1, opportunities.size(), 'Number of opportunities returned is incorrect.');

        // Assert that the opportunities returned have the correct names
        System.assertEquals('Keyword Opportunity', opportunities[0].Name, 'Opportunity name is incorrect.');

        opportunities = SOQL.getOpportunitiesByNameKeyword('Test');
        System.assertEquals(2, opportunities.size(), 'Number of opportunities returned is incorrect.');

        opportunities = SOQL.getOpportunitiesByNameKeyword('Supra');
        System.assertEquals(0, opportunities.size(), 'Number of opportunities returned is incorrect.');

        opportunities = SOQL.getOpportunitiesByNameKeyword(null);
        System.assertEquals(0, opportunities.size(), 'Number of opportunities returned is incorrect.');
    }

    @IsTest
    static void testGetFilterCaseOrigins() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Case testCase1 = new Case(Status = 'New', AccountId = testAccount.Id, Origin = 'Phone');
        Case testCase2 = new Case(Status = 'New', AccountId = testAccount.Id, Origin = 'Email');
        Case testCase3 = new Case(Status = 'New', AccountId = testAccount.Id, Origin = 'Web');
        Case testCase4 = new Case(Status = 'New', AccountId = testAccount.Id, Origin = '');
        insert new List<Case>{testCase1, testCase2, testCase3, testCase4};

        // Call the method to test
        List<Case> cases = SOQL.getFilterCaseOrigins();

        // Assert that the number of cases returned is correct
        System.assertEquals(1, cases.size(), 'Number of cases returned is incorrect.');

        // Assert that the cases returned have the correct Origin
        Set<Id> caseIds = new Set<Id>{testCase1.Id, testCase2.Id};
        try {
            for (Case cs : cases) {
                System.assert(caseIds.contains(cs.Id), 'Case Id is incorrect.');
                Assert.isNotNull(cs.Origin, 'Case Origin is null.');
            }
        } catch (SObjectException ex) {
            Assert.fail('SObjectException thrown: ' + ex.getMessage());
        }
    }

    @IsTest
    static void testGetLeadsBySourceOrTitle() {
        // Create test data
        Lead testLead1 = new Lead(LastName = 'Test Lead 1', Company = 'Test Company 1', Phone = '1234567890', Email = 'lead1@email.com', LeadSource = 'Web', Title = 'Manager');
        Lead testLead2 = new Lead(LastName = 'Test Lead 2', Company = 'Test Company 2', Phone = '0987654321', Email = 'lead2@email.com', LeadSource = 'Phone', Title = 'Engineer Lead');
        Lead testLead3 = new Lead(LastName = 'Test Lead 3', Company = 'Test Company 3', Phone = '1234567890', Email = 'lead3@email.com', LeadSource = 'Email', Title = 'Director');
        Lead testLead4 = new Lead(LastName = 'Test Lead 4', Company = 'Test Company 4', Phone = '0987654321', Email = 'lead4@email.com', LeadSource = 'Web', Title = 'Sr Engineer');
        Lead testLead5 = new Lead(LastName = 'Test Lead 5', Company = 'Test Company 5', Phone = '1234567890', Email = '', LeadSource = '', Title = '');
        insert new List<Lead>{testLead1, testLead2, testLead3, testLead4};

        // Call the method to test
        List<Lead> leads = null; //Replace null with your method passing 'Web', 'Engineer' 

        // Assert that the number of leads returned is correct
        System.assertEquals(3, leads.size(), 'Number of leads returned is incorrect.');

        // Assert that the leads returned have the correct names
        Set<String> leadNames = new Set<String>{'Test Lead 1', 'Test Lead 2', 'Test Lead 4'};
        try {
            for (Lead lead : leads) {
                System.assert(leadNames.contains(lead.LastName), 'Lead name is incorrect.');
                Assert.isNotNull(lead.Company, 'Lead company is null.');
                Assert.isNotNull(lead.Phone, 'Lead phone is null.');
                Assert.isNotNull(lead.Email, 'Lead email is null.');
            }
        } catch (SObjectException ex) {
            Assert.fail('SObjectException thrown: ' + ex.getMessage());
        }
    }

    @IsTest
    static void testGetContactNamesByAccount() {
        // Create test data
        // Generate random number of accounts and contacts between 1 and 10
        Integer numAccounts = (Integer)Math.floor(Math.random() * 10) + 1;
        List <Account> accounts = new List<Account>();
        for (Integer i = 0; i < numAccounts; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        List<Contact> contacts = new List<Contact>();
        Map<Id, List<Contact>> accountContacts = new Map<Id, List<Contact>>();

        for (Account acc : accounts) {
            Integer numContacts = (Integer)Math.floor(Math.random() * 10) + 1;
            List<Contact> tempContList = new List<Contact>();
            for (Integer i = 0; i < numContacts; i++) {
                tempContList.add(new Contact(LastName = 'Test Contact ' + i, AccountId = acc.Id));
            }     
            accountContacts.put(acc.Id, tempContList); 
            contacts.addAll(tempContList);  
        }

        insert contacts;

        // Call the method to test
        Account testAccount = accounts[(Integer)Math.floor(Math.random() * accounts.size())];
        List<String> contactNames = SOQL.getContactNamesByAccount(testAccount.Id);

        // Assert that the number of contact names returned is correct
        System.assertEquals(accountContacts.get(testAccount.Id).size(), contactNames.size(), 'Number of contact names returned is incorrect.');

        // Assert that the contact names returned are correct
        try {
            for (Contact cont : accountContacts.get(testAccount.Id)) {
                System.assert(contactNames.contains(cont.LastName), 'Contact name is incorrect.');
            }
        } catch (Exception ex) {
            Assert.fail('Exception thrown: ' + ex.getMessage());
        }
    }

    @IsTest
    static void testGetTotalRevenueByStage() {
        // Create test data
        Opportunity testOpp1 = new Opportunity(Name = 'Test Opportunity 1', StageName = 'Prospecting', Amount = 5000, CloseDate = Date.today());
        Opportunity testOpp2 = new Opportunity(Name = 'Test Opportunity 2', StageName = 'Closed Won', Amount = 20000, CloseDate = Date.today());
        Opportunity testOpp3 = new Opportunity(Name = 'Test Opportunity 3', StageName = 'Closed Lost', Amount = 15000, CloseDate = Date.today());
        Opportunity testOpp4 = new Opportunity(Name = 'Test Opportunity 4', StageName = 'Closed Won', Amount = 10000, CloseDate = Date.today());
        insert new List<Opportunity>{testOpp1, testOpp2, testOpp3, testOpp4};

        // Call the method to test
        Decimal totalRevenue = SOQL.getTotalRevenueByStage('Closed Won');

        // Assert that the total revenue returned is correct
        Decimal expectedRevenue = testOpp2.Amount + testOpp3.Amount + testOpp4.Amount;
        System.assertEquals(expectedRevenue, totalRevenue, 'Total revenue is incorrect.');
    }

    @IsTest
    static void testGetFirstTenAccounts() {
        // Create test data
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 15; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        // Call the method to test
        List<Account> returnedAccounts = SOQL.getFirstTenAccounts();

        // Assert that the number of accounts returned is correct
        System.assertEquals(10, returnedAccounts.size(), 'Number of accounts returned is incorrect.');

        // Assert that the accounts returned are ordered correctly
        for(Integer i = 0; i < returnedAccounts.size() - 1; i++) {
            System.assert(returnedAccounts[i].Name.compareTo(returnedAccounts[i + 1].Name) <= 0, 'Accounts are not ordered correctly.');
        }
    }

    @IsTest
    static void testGetHighValueOpportunities() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Integer i = 0; i < 10; i++) {
            opportunities.add(new Opportunity(
                Name = 'Test Opportunity ' + i, 
                AccountId = testAccount.Id, 
                CloseDate = System.today().addDays(i), 
                StageName = 'Prospecting', 
                Amount = 100000 * (i+1)
            ));
        }
        insert opportunities;

        // Call the method to test
        List<Opportunity> returnedOpportunities = SOQL.getHighValueOpportunities();

        // Assert that the number of opportunities returned is correct
        System.assertEquals(5, returnedOpportunities.size(), 'Number of opportunities returned is incorrect.');

        // Assert that the opportunities returned are ordered correctly
        for(Integer i = 0; i < returnedOpportunities.size() - 1; i++) {
            System.assert(returnedOpportunities[i].CloseDate <= returnedOpportunities[i + 1].CloseDate, 'Opportunities are not ordered correctly.');
            System.assert(returnedOpportunities[i].Amount > 100000, 'Opportunity amount is less than 100,000.');
        }
    }

    @IsTest
    static void testGetBirthdateContacts() {
        // Create test data
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            contacts.add(new Contact(
                LastName = 'Test Contact ' + i,
                Birthdate = Date.today().addDays(-i) // Birthdates from today to 9 days ago
            ));
        }
        insert contacts;

        // Call the method to test
        List<Contact> returnedContacts = SOQL.getBirthdateContacts();

        // Assert that the number of contacts returned is correct
        System.assertEquals(3, returnedContacts.size(), 'Number of contacts returned is incorrect.');

        // Assert that the contacts returned are ordered correctly by Birthdate
        for (Integer i = 0; i < returnedContacts.size() - 1; i++) {
            System.assert(returnedContacts[i].Birthdate >= returnedContacts[i + 1].Birthdate, 'Contacts are not ordered correctly by Birthdate.');
        }
    }

    @IsTest
    static void testGetCasesWithStatus() {
        // Create test data
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 20; i++) {
            cases.add(new Case(
                Subject = 'Test Case ' + i,
                Status = 'Open'
                // Assume that Cases are created in order, so the CreatedDate will be in ascending order
            ));
        }
        insert cases;
    
        // Call the method to test
        List<Case> returnedCases = SOQL.getCasesWithStatus();
    
        // Assert that the number of cases returned is correct
        System.assertEquals(10, returnedCases.size(), 'Number of cases returned is incorrect.');
    
        // Assert that the cases returned are ordered correctly by CreatedDate
        for (Integer i = 0; i < returnedCases.size() - 1; i++) {
            System.assert(returnedCases[i].CreatedDate <= returnedCases[i + 1].CreatedDate, 'Cases are not ordered correctly by CreatedDate.');
        }
    
        // Assert that the first case returned is the 6th case created
        System.assertEquals(cases[5].Id, returnedCases[0].Id, 'First case returned is not the 6th case created.');
    }
    

    @IsTest
    static void testGetCaseIdsByAccount() {
        // Create test data
        // Generate random number of accounts and cases between 1 and 10
        Integer numAccounts = (Integer)Math.floor(Math.random() * 10) + 1;
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < numAccounts; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;

        List<Case> cases = new List<Case>();
        Map<Id, List<Case>> accountCases = new Map<Id, List<Case>>();
        for (Account acc : accounts) {
            Integer numCases = (Integer)Math.floor(Math.random() * 10) + 1;
            List<Case> tempCaseList = new List<Case>();
            for (Integer i = 0; i < numCases; i++) {
                tempCaseList.add(new Case(Subject = 'Test Case ' + i, AccountId = acc.Id, Status = 'Open'));
            }     
            accountCases.put(acc.Id, tempCaseList); 
            cases.addAll(tempCaseList);  
        }
        insert cases;

        // Call the method to test
        Account testAccount = accounts[(Integer)Math.floor(Math.random() * accounts.size())];
        Set<Id> caseIds = SOQL.getCaseIdsByAccount(testAccount.Id);

        // Assert that the number of case IDs returned is correct
        System.assertEquals(accountCases.get(testAccount.Id).size(), caseIds.size(), 'Number of case IDs returned is incorrect.');

        // Assert that the case IDs returned are correct
        try {
            for (Case caseObj : accountCases.get(testAccount.Id)) {
                System.assert(caseIds.contains(caseObj.Id), 'Case ID is incorrect.');
            }
        } catch (Exception ex) {
            Assert.fail('Exception thrown: ' + ex.getMessage());
        }
    }

    @IsTest
    static void testGetAccountIdsToNamesNotInCountry() {
        // Create test data
        Account testAccount1 = new Account(Name = 'Test Account 1', BillingCountry = 'United States');
        Account testAccount2 = new Account(Name = 'Test Account 2', BillingCountry = 'Canada');
        Account testAccount3 = new Account(Name = 'Test Account 3', BillingCountry = 'United Kingdom');
        insert new List<Account>{testAccount1, testAccount2, testAccount3};

        // Call the method to test
        Map<Id, String> accountIdsToNames = SOQL.getAccountIdsToNamesNotInCountry('Canada');

        // Assert that the number of accounts returned is correct
        System.assertEquals(2, accountIdsToNames.size(), 'Number of accounts returned is incorrect.');

        // Assert that the accounts returned are correct
        try {
            System.assert(accountIdsToNames.containsKey(testAccount1.Id), 'Test Account 1 is not in the result set.');
            System.assert(accountIdsToNames.containsKey(testAccount3.Id), 'Test Account 3 is not in the result set.');
            System.assert(!accountIdsToNames.containsKey(testAccount2.Id), 'Test Account 2 is in the result set.');
        } catch (Exception ex) {
            Assert.fail('Exception thrown: ' + ex.getMessage());
        }
    }

    @IsTest
    static void testGetAccountNameForContact() {
        // Create test data
        Account testAccount1 = new Account(Name = 'Test Account 1');
        insert testAccount1;
        
        Contact testContact1 = new Contact(LastName = 'Test Contact 1', AccountId = testAccount1.Id);
        insert testContact1;
        
        // Call the method to test
        String accountName = SOQL.getAccountNameForContact(testContact1.Id);

        // Assert that the returned account name is correct
        System.assertEquals('Test Account 1', accountName, 'Returned account name is incorrect.');
    }

    @IsTest
    static void testGetAccountAndOpportunitiesFromAccountId() {
        // Create test data
        Account testAccount1 = new Account(Name = 'Test Account 1');
        insert testAccount1;
        
        Opportunity testOpp1 = new Opportunity(Name = 'Test Opp 1', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = testAccount1.Id);
        Opportunity testOpp2 = new Opportunity(Name = 'Test Opp 2', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = testAccount1.Id);
        insert new List<Opportunity>{testOpp1, testOpp2};
        
        // Call the method to test
        Account accountWithOpps = SOQL.getAccountAndOpportunitiesFromAccountId(testAccount1.Id);
    
        // Assert that the returned account is correct
        System.assertEquals(testAccount1.Id, accountWithOpps.Id, 'Returned account is incorrect.');
        
        // Assert that the returned account has the correct opportunities
        System.assertEquals(2, accountWithOpps.Opportunities.size(), 'Number of opportunities is incorrect.');
        Set<String> oppNames = new Set<String>{'Test Opp 1', 'Test Opp 2'};
        try {
            for (Opportunity opp : accountWithOpps.Opportunities) {
                System.assert(oppNames.contains(opp.Name), 'Opportunity name is incorrect.');
            }
        } catch (Exception ex) {
            Assert.fail('Exception thrown: ' + ex.getMessage());
        }
    }

    @IsTest
    static void testGetAccountsWithContactsByState() {
        // Create test data
        // Generate random number of accounts and contacts between 1 and 10
        Integer numAccounts = (Integer)Math.floor(Math.random() * 10) + 1;
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < numAccounts; i++) {
            String billingState = Math.mod(i, 2) == 0 ? 'CA' : 'NY'; 
            accounts.add(new Account(Name = 'Test Account ' + i, BillingState = billingState));
        }

        insert accounts;
        
        List<Contact> contacts = new List<Contact>();
        Integer numberOfContactsInState = 0;
        Integer numberOfContactsInNY = 0;

        for (Account acc : accounts) {
            Integer numContacts = (Integer)Math.floor(Math.random() * 10) + 1;
            List<Contact> tempContList = new List<Contact>();
            for (Integer i = 0; i < numContacts; i++) {
                String billingState = Math.mod(i, 2) == 0 ? 'CA' : 'NY'; 
                tempContList.add(new Contact(LastName = 'Test Contact ' + i, AccountId = acc.Id, MailingState = billingState));
                if (billingState == 'CA') {
                    numberOfContactsInState++;
                } else {
                    numberOfContactsInNY++;
                }
            }
            contacts.addAll(tempContList);
        }

        insert contacts;

        // Call the method to test
        Account testAccount = accounts[(Integer)Math.floor(Math.random() * accounts.size())];
        List<Contact> contactsByState = SOQL.getAccountsWithContactsByState(testAccount.Id);

        // Assert that the number of contacts returned is correct
        System.assertEquals(testAccount.BillingState == 'CA' ? numberOfContactsInState : numberOfContactsInNY , contactsByState.size(), 'Number of contacts returned is incorrect.');
    }

    @IsTest
    static void testFindAccountsByLeadEmailDomains() {
        // Create test data
        // Generate random number of leads between 1 and 10
        List<String> domains = new List<String>{'example.com', 'test.com', 'other.com'};


        Integer numLeads = 10;
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < numLeads; i++) {
            String email = 'test' + i + '@' + domains[(Integer)Math.floor(Math.random() * domains.size())];
            leads.add(new Lead(Email = email, LastName = 'Test Lead ' + i, Company = 'Test Company ' + i));
        }

        insert leads;

        // Create test accounts
        Integer numAccounts = (Integer)Math.floor(Math.random() * 10) + 3;
        Map<String, List<Account>> domainToAccount = new Map<String, List<Account>>();
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < numAccounts; i++) {
            String domain;
            Integer domainIndex = Math.mod(i, domains.size());
            if (domainIndex == 0) {
                domain = domains[0];
            } else if (domainIndex == 1) {
                domain = domains[1];
            } else {
                domain = domains[2];
            }
            String website = 'www.' + domain;
            accounts.add(new Account(Name = 'Test Account ' + i, Website = website));
            if (!domainToAccount.containsKey(domain)) {
                domainToAccount.put(domain, new List<Account>());
            }
            domainToAccount.get(domain).add(accounts[i]);
        }
        insert accounts;

        // Call the method to test
        Lead testLead = leads[(Integer)Math.floor(Math.random() * leads.size())];
        String testLeadDomain = testLead.Email.split('@')[1];
        Set<Id> leadIds = new Set<Id>{testLead.Id};
        List<Account> matchedAccounts = SOQL.findAccountsByLeadEmailDomains(leadIds);
        System.debug([SELECT Id, Website FROM Account]);
        System.debug(testLeadDomain);
        System.debug(domainToAccount.get(testLeadDomain));

        // Assert that the number of matched accounts is correct
        // System.assertEquals(testLeadDomain, 'zzzexample.com');
        // System.assertEquals(matchedAccounts.size(), 123);
        System.assertEquals(domainToAccount.get(testLeadDomain).size(), matchedAccounts.size(), 'Number of matched accounts is incorrect.');

        // Assert that the matched accounts have the correct website domain
        try {
            for (Account acc : matchedAccounts) {
                Boolean accountFound = false;
                for (Account testAccount : domainToAccount.get(testLeadDomain)) {
                    if (acc.Id == testAccount.Id) {
                        accountFound = true;
                        System.assertEquals(testAccount.Website, acc.Website, 'Account website domain is incorrect.');
                        break;
                    }
                }
                Assert.isTrue(accountFound, 'Account not found in the matched accounts list.');
            }
        } catch (Exception ex) {
            Assert.fail('Exception thrown: ' + ex.getMessage());
        }
    }

    @IsTest
    static void testCloneLineItems() {
        // Create test data
        Account testAccount1 = new Account(Name = 'Test Account 1');
        insert testAccount1;
        
        Opportunity testOpp1 = new Opportunity(Name = 'Test Opp 1', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = testAccount1.Id);
        Opportunity testOpp2 = new Opportunity(Name = 'Test Opp 2', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = testAccount1.Id);
        insert new List<Opportunity>{testOpp1, testOpp2};
        
        // insert product
        Product2 testProduct = new Product2();
        testProduct.Name = ' Test Product ';
        testProduct.Description='Test Product Entry For Product';
        testProduct.productCode = 'SFDCPanther-123';
        testProduct.isActive = true;
        insert testProduct;

        // insert pricebook entry for the product
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = testProduct.Id;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
        
        OpportunityLineItem testLineItem = new OpportunityLineItem(OpportunityId = testOpp1.Id, Quantity = 5, PricebookEntryId = standardPrice.Id, TotalPrice = 500);
        insert testLineItem;

        // Call the method to test
        SOQL.cloneLineItems(testOpp1.Id, new List<Id>{testOpp2.Id});

        // Query for the cloned line items
        List<OpportunityLineItem> clonedLineItems = [SELECT Id, Quantity, UnitPrice FROM OpportunityLineItem WHERE OpportunityId = :testOpp2.Id];

        // Assert that the line items were cloned correctly
        System.assertEquals(1, clonedLineItems.size(), 'Number of cloned line items is incorrect.');
        System.assertEquals(100, clonedLineItems[0].UnitPrice, 'Cloned line item UnitPrice is incorrect.');
    }

    @IsTest
    static void testGetOpportunityDetailsForClosedWon() {
        // Create test data
        Account testAccount1 = new Account(Name = 'Test Account 1');
        insert testAccount1;
        
        User testUser = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];

        Opportunity testOpportunity1 = new Opportunity(Name = 'Test Opportunity 1', AccountId = testAccount1.Id, StageName = 'Closed Won', CloseDate = Date.today(), OwnerId = testUser.Id);
        Opportunity testOpportunity2 = new Opportunity(Name = 'Test Opportunity 2', AccountId = testAccount1.Id, StageName = 'Open', CloseDate = Date.today(), OwnerId = testUser.Id);
        insert new List<Opportunity>{testOpportunity1, testOpportunity2};

        // Call the method to test
        List<Opportunity> opportunities = SOQL.getOpportunityDetailsForClosedWon();

        // Assert that the number of opportunities returned is correct
        System.assertEquals(1, opportunities.size(), 'Number of opportunities returned is incorrect.');

        // Assert that the opportunity returned is correct
        try {
            System.assert(opportunities[0].Id == testOpportunity1.Id, 'Returned opportunity ID is incorrect.');
            System.assert(opportunities[0].Name == 'Test Opportunity 1', 'Returned opportunity name is incorrect.');
            System.assert(opportunities[0].AccountId == testAccount1.Id, 'Returned account ID is incorrect.');
            System.assert(opportunities[0].OwnerId == testUser.Id, 'Returned owner ID is incorrect.');
        } catch (Exception ex) {
            Assert.fail('Exception thrown: ' + ex.getMessage());
        }
    }

    @IsTest
    static void testSetPrimaryContact() {
        // Create test data
        Account testAccount1 = new Account(Name = 'Test Account 1');
        insert testAccount1;
        
        Contact testContact1 = new Contact(FirstName = 'Zara', LastName = 'Smith', AccountId = testAccount1.Id);
        Contact testContact2 = new Contact(FirstName = 'Aaron', LastName = 'Johnson', AccountId = testAccount1.Id);
        insert new List<Contact>{testContact1, testContact2};
        
        Opportunity testOpp1 = new Opportunity(Name = 'Test Opp 1', StageName = 'Closed Won', CloseDate = Date.today(), AccountId = testAccount1.Id);
        insert testOpp1;

        // Call the method to test
        SOQL.setPrimaryContact();

        // Query for the updated Opportunity
        // HINT: The repository has the primary contact field. You will need to figure out how to deploy it force-app\main\default\objects\Opportunity\fields\Primary_Contact__c.field-meta.xml
        Opportunity updatedOpp = [SELECT Id, Primary_Contact__c FROM Opportunity WHERE Id = :testOpp1.Id];

        // Assert that the Primary Contact was set correctly
        System.assertEquals(testContact2.Id, updatedOpp.Primary_Contact__c, 'Primary Contact was not set correctly.');
    }



}