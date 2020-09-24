global class NewProcessBuilder {
	
    @InvocableMethod
    global static void updateRecords(List<Account> acc) {
        system.debug('acc ' + acc);
    }
}