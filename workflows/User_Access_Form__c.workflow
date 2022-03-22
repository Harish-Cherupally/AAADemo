<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Salesforce_User_Notification</fullName>
        <description>New Salesforce User Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>charles.walstrom@a3smarthome.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shweta.mahadik@norcal.aaa.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>srinivas.raoega@a3smarthome.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Salesforce_Support_Tickets/New_Salesforce_User_Request</template>
    </alerts>
</Workflow>
