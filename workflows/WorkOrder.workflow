<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Book_Your_Appointment_Email</fullName>
        <description>Book Your Appointment Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/AAA_Book_Your_Appointment</template>
    </alerts>
    <alerts>
        <fullName>Book_Your_Appointment_Email_Service</fullName>
        <description>Book Your Appointment Email Service</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Survey_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Welcome_to_AAA_Smart_Home_Email</fullName>
        <description>Welcome to AAA Smart Home Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/Welcome_to_AAA_Smart_Home</template>
    </alerts>
    <fieldUpdates>
        <fullName>Remove_2_hrs_from_Duration</fullName>
        <description>This field is used to check the checkbox field on WO</description>
        <field>Remove_2_hrs_from_Duration__c</field>
        <literalValue>1</literalValue>
        <name>Remove 2 hrs from Duration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Remove 2 hrs from Duration</fullName>
        <actions>
            <name>Remove_2_hrs_from_Duration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This Rule is used to remove 2 hrs from duration on Service Appointment</description>
        <formula>AND(ISCHANGED(Product_Code__c) , Product_Code__c = 0)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Book Your Appointment Email</fullName>
        <actions>
            <name>Book_Your_Appointment_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Sent_Book_Your_Appointment_Email</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WorkOrder.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>WorkOrder.Duration</field>
            <operation>lessThan</operation>
            <value>9</value>
        </criteriaItems>
        <criteriaItems>
            <field>WorkOrder.Service_Type__c</field>
            <operation>equals</operation>
            <value>New Installation</value>
        </criteriaItems>
        <description>When a work order is created, send email to Schedule an Appointment</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>WorkOrder.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send Book Your Appointment Email Service</fullName>
        <actions>
            <name>Book_Your_Appointment_Email_Service</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Service_Book_Your_Appointment_Email</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WorkOrder.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>WorkOrder.Duration</field>
            <operation>lessThan</operation>
            <value>9</value>
        </criteriaItems>
        <criteriaItems>
            <field>WorkOrder.Service_Type__c</field>
            <operation>equals</operation>
            <value>Service Appointment</value>
        </criteriaItems>
        <description>When a work order is created, send email to Schedule an Appointment</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Welcome to AAA Smart Home Alert</fullName>
        <active>false</active>
        <criteriaItems>
            <field>WorkOrder.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>WorkOrder.Subject</field>
            <operation>equals</operation>
            <value>New Installation</value>
        </criteriaItems>
        <description>Send Welcome to AAA Smart Home Email Alert when Work Order is closed out</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Welcome_to_AAA_Smart_Home_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Sent_Welcome_to_AAA_Smart_Home_Email</name>
                <type>Task</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Sent_Book_Your_Appointment_Email</fullName>
        <assignedTo>crmsuperhero@aaa.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent	Book Your Appointment Email</subject>
    </tasks>
    <tasks>
        <fullName>Sent_Welcome_to_AAA_Smart_Home_Email</fullName>
        <assignedTo>crmsuperhero@aaa.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent Welcome to AAA Smart Home Email</subject>
    </tasks>
    <tasks>
        <fullName>Service_Book_Your_Appointment_Email</fullName>
        <assignedTo>crmsuperhero@aaa.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Service Book Your Appointment Email</subject>
    </tasks>
</Workflow>
