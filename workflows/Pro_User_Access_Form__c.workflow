<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Salesforce_Pro_User_Notification</fullName>
        <description>New Salesforce Pro User Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>srinivas.raoega@a3smarthome.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Salesforce_Support_Tickets/New_Salesforce_User_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>Enter_New_Shift_Hours</fullName>
        <field>Needs_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Enter New Shift Hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Other Shift</fullName>
        <actions>
            <name>Enter_New_Shift_Hours</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Pro_User_Access_Form__c.Pro_Shift__c</field>
            <operation>equals</operation>
            <value>Other</value>
        </criteriaItems>
        <description>Needs approval checkbox with be checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
