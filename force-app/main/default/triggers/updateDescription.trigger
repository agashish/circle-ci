trigger updateDescription on Contact (Before delete) {
    for(Contact con: Trigger.old) {
        if(con.AccountId == null) {
            con.addError('Hey, You are not authorized to delete');
        }
    }
}