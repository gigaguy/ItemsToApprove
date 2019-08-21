/**********************************************************************
Name: ItemsToApprove
======================================================
======================================================
Purpose:
-------
Controller to get the list of pending approvals for the current user
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
1.0   Roy King 8/21/2019 Initial development

**********************************************************************/

@isTest(Seealldata=true)
private class  ItemsToApprove_Test{
    @isTest
    static void testApprovalItems(){    
		ItemsToApprove.WrapperClass();
    }  

}