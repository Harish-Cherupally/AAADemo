<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_A3_Call_Back_Notification</fullName>
        <description>Send A3 Call Back Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Call_Back_Recipient__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>memberexperience@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Call_Back_Attempts/A3_Call_Back_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_AAA_Call_Back_Notification</fullName>
        <description>Send AAA Call Back Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Call_Back_Recipient__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>memberexperience@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Call_Back_Attempts/A3SH_Call_Back_Notification</template>
    </alerts>
</Workflow>
