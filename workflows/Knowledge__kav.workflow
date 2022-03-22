<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_to_Submitter</fullName>
        <description>Email Alert to Submitter</description>
        <protected>false</protected>
        <recipients>
            <field>Approval_Submitted_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>A3_Sales_Templates/for_Approval_submitters</template>
    </alerts>
    <alerts>
        <fullName>Knowledge_Approval_request_is_Approved</fullName>
        <description>Knowledge Approval request is Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>suman.venuvanka@a3smarthome.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>suman.venuvanka@criticalriver.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approval_request_submitted</template>
    </alerts>
    <alerts>
        <fullName>Knowledge_Approval_request_is_Rejected</fullName>
        <description>Knowledge Approval request is Rejected</description>
        <protected>false</protected>
        <recipients>
            <recipient>suman.venuvanka@a3smarthome.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>suman.venuvanka@criticalriver.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/For_Knowledge_request_is_rejected</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Email_to_Approver_L2_L3</fullName>
        <description>Reminder Email to Approver L2,L3</description>
        <protected>false</protected>
        <recipients>
            <recipient>edmund.solis@a3smarthome.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>memberexperience@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>A3_Sales_Templates/Reminder_Email_to_Approver</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_status_to_submitted</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Approval status to submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Article_Status_to_L2_Approved</fullName>
        <field>Article_Status__c</field>
        <literalValue>L2 Approved</literalValue>
        <name>Article Status to L2 Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Article_Status_to_L3_Approved</fullName>
        <field>Article_Status__c</field>
        <literalValue>L3 Approved (Published)</literalValue>
        <name>Article Status to L3 Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Article_Status_to_Ready_to_be_reviewed</fullName>
        <field>Article_Status__c</field>
        <literalValue>Ready to be reviewed</literalValue>
        <name>Article Status to Ready to be reviewed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Article_status_to_L2_Rejected</fullName>
        <field>Article_Status__c</field>
        <literalValue>L2 Rejected</literalValue>
        <name>Article status to L2 Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Article_status_to_L3_Rejected</fullName>
        <field>Article_Status__c</field>
        <literalValue>L3 Rejected</literalValue>
        <name>Article status to L3 Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Step_Approved_Date</fullName>
        <field>Step_1_Approved_Date__c</field>
        <formula>Now()</formula>
        <name>Step Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_by_L1</fullName>
        <field>submitted_by__c</field>
        <literalValue>L1 submitted</literalValue>
        <name>Submitted by L1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_by_L2</fullName>
        <description>Updated the Submitted by field to L2 submitted</description>
        <field>submitted_by__c</field>
        <literalValue>L2 submitted</literalValue>
        <name>Submitted by L2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Submitted_By</fullName>
        <field>Approval_Submitted_By__c</field>
        <formula>$User.FirstName +&apos; &apos;+ $User.LastName</formula>
        <name>Update Approval Submitted By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Submitted_Email</fullName>
        <description>This will update the Approval Submitted Email</description>
        <field>Approval_Submitted_Email__c</field>
        <formula>$User.Email</formula>
        <name>Update Approval Submitted Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_L2_approved_to_False</fullName>
        <description>Update L2 approved checkbox to False. Because if the article is rejected, they will submit it again.</description>
        <field>L1_Approved__c</field>
        <literalValue>0</literalValue>
        <name>Update L2 approved to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_L2_approved_to_True</fullName>
        <field>L1_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update L2 approved to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_L3_Approved</fullName>
        <field>L3_Approved__c</field>
        <literalValue>1</literalValue>
        <name>Update L3 Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_L3_approved_to_False</fullName>
        <field>L3_Approved__c</field>
        <literalValue>0</literalValue>
        <name>Update L3 approved to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Submitted_date</fullName>
        <field>Submitted_date__c</field>
        <formula>NOW()</formula>
        <name>Update Submitted date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>approval_status_to_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>approval status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>approval_status_to_Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>approval status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>approval_status_to_Recalled</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>approval status to Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>approval_status_to_rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>approval status to rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>ApproveArticle</fullName>
        <action>PublishAsNew</action>
        <label>ApproveArticle</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
</Workflow>
