<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AAA_24_Hour_Appointment_Reminder_Email</fullName>
        <description>AAA 24 Hour Appointment Reminder Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/A3_24_Hour_Appointment_Reminder</template>
    </alerts>
    <alerts>
        <fullName>AAA_24_Hour_Appointment_Reminder_Email_Service</fullName>
        <description>AAA 24 Hour Appointment Reminder Email Service</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/AAA_24_Hour_Service_Reminder</template>
    </alerts>
    <alerts>
        <fullName>AAA_2_Day_Appointment_Reminder_Email</fullName>
        <description>AAA 2 Day Appointment Reminder Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/AAA_2_Day_Appointment_Reminder</template>
    </alerts>
    <alerts>
        <fullName>AAA_7_Day_Appointment_Reminder_Email</fullName>
        <description>AAA 7 Day Appointment Reminder Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/AAA_7_Day_Appointment_Reminder</template>
    </alerts>
    <alerts>
        <fullName>AAA_Booking_Confirmation_Email</fullName>
        <description>AAA Booking Confirmation Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/AAA_Booking_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>AAA_Non_Response_Reminder_3_Day_Alert</fullName>
        <description>AAA Non Response Reminder 3 Day Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/AAA_Non_Response_Reminder_3_Day</template>
    </alerts>
    <alerts>
        <fullName>AAA_Non_Response_Reminder_6_Day_Alert</fullName>
        <description>AAA Non Response Reminder 6 Day Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/AAA_Non_Response_Reminder_6_Day</template>
    </alerts>
    <alerts>
        <fullName>AAA_Non_Response_Reminder_9_Day_Alert</fullName>
        <description>AAA Non Response Reminder 9 Day Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/AAA_Non_Response_Reminder_9_Day</template>
    </alerts>
    <alerts>
        <fullName>AAA_Non_Response_Reminder_Final_Alert</fullName>
        <description>AAA Non Response Reminder Final Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/AAA_Non_Response_Final_Notice</template>
    </alerts>
    <alerts>
        <fullName>Booking_Confirmation</fullName>
        <description>Booking Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/AAA_Booking_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Booking_Confirmation_Service</fullName>
        <description>Booking Confirmation Service</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/AAA_Service_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Service_Appointment_Cancellation_Email</fullName>
        <description>Service Appointment Cancellation Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/ServiceAppointmentCancellationNotification</template>
    </alerts>
    <alerts>
        <fullName>Service_Booking_Confirmation</fullName>
        <description>Service Booking Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>a3sh-specialists@a3smarthome.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Scheduling/AAA_Service_Confirmation</template>
    </alerts>
    <fieldUpdates>
        <fullName>Earliest_Start_Time</fullName>
        <field>EarliestStartTime</field>
        <formula>SchedStartTime</formula>
        <name>Earliest Start Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Multi_Day_Appointment</fullName>
        <field>FSL__IsMultiDay__c</field>
        <literalValue>1</literalValue>
        <name>Multi Day Appointment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_ID_for_Flows</fullName>
        <field>SA_ID_for_Flows__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>SA ID for Flows</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Multi_Day_Appointment</fullName>
        <field>FSL__IsMultiDay__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Multi Day Appointment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Duration</fullName>
        <field>Duration</field>
        <formula>Duration + 2</formula>
        <name>Update Duration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Booking Confirmation Email</fullName>
        <actions>
            <name>Booking_Confirmation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Sent_Booking_Confirmation_Email</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ServiceAppointment.Status</field>
            <operation>equals</operation>
            <value>Scheduled</value>
        </criteriaItems>
        <criteriaItems>
            <field>ServiceAppointment.Service_Type__c</field>
            <operation>equals</operation>
            <value>New Installation</value>
        </criteriaItems>
        <criteriaItems>
            <field>ServiceAppointment.In_Scheduler__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Booking Confirmation Email_Service Ticket</fullName>
        <actions>
            <name>Booking_Confirmation_Service</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ServiceAppointment.Status</field>
            <operation>equals</operation>
            <value>Scheduled</value>
        </criteriaItems>
        <criteriaItems>
            <field>ServiceAppointment.Service_Type__c</field>
            <operation>equals</operation>
            <value>Service Appointment</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Earliest Start Time Same as Scheduled Start Time</fullName>
        <actions>
            <name>Earliest_Start_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ServiceAppointment.Status</field>
            <operation>equals</operation>
            <value>Scheduled - On Hold,Scheduled,Dispatched</value>
        </criteriaItems>
        <criteriaItems>
            <field>ServiceAppointment.SchedStartTime</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Fields for Flow and Rider Bot</fullName>
        <actions>
            <name>SA_ID_for_Flows</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets ID for Flow to Reference</description>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Multi Day Appointment</fullName>
        <actions>
            <name>Multi_Day_Appointment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ServiceAppointment.Duration</field>
            <operation>greaterThan</operation>
            <value>8</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send 2 Day Appointment Reminder Email</fullName>
        <active>false</active>
        <formula>ISPICKVAL( Status  , &quot;Scheduled&quot;)
&amp;&amp;
Subject = &quot;New Installation&quot;
&amp;&amp;
DATEVALUE(SchedStartTime) - TODAY()  &gt;=  2
&amp;&amp;
In_Scheduler__c = FALSE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AAA_2_Day_Appointment_Reminder_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Sent_AAA_2_Day_Appointment_Reminder_Email</name>
                <type>Task</type>
            </actions>
            <offsetFromField>ServiceAppointment.SchedStartTime</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send 24 Hour Appointment Reminder Email</fullName>
        <active>false</active>
        <formula>ISPICKVAL( Status  , &quot;Scheduled&quot;)
&amp;&amp;
Subject = &quot;New Installation&quot;
&amp;&amp;
DATEVALUE(SchedStartTime) - TODAY()  &gt;=  1
&amp;&amp;
In_Scheduler__c = FALSE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AAA_24_Hour_Appointment_Reminder_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Sent_AAA_24_Hour_Appointment_Reminder_Email</name>
                <type>Task</type>
            </actions>
            <offsetFromField>ServiceAppointment.SchedStartTime</offsetFromField>
            <timeLength>-24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send 24 Hour Appointment Reminder Email_Service Ticket</fullName>
        <active>false</active>
        <formula>ISPICKVAL( Status  , &quot;Scheduled&quot;) &amp;&amp; Subject = &quot;Service Appointment&quot; &amp;&amp; DATEVALUE(SchedStartTime) - TODAY()  &gt;=  1 &amp;&amp; In_Scheduler__c = FALSE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AAA_24_Hour_Appointment_Reminder_Email_Service</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>ServiceAppointment.SchedStartTime</offsetFromField>
            <timeLength>-24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send 7 Day Appointment Reminder Email</fullName>
        <active>false</active>
        <formula>ISPICKVAL( Status  , &quot;Scheduled&quot;)
&amp;&amp;
Subject = &quot;New Installation&quot;
&amp;&amp;
DATEVALUE(SchedStartTime) - TODAY()  &gt;=  7
&amp;&amp;
In_Scheduler__c = FALSE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AAA_7_Day_Appointment_Reminder_Email</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Sent_AAA_7_Day_Appointment_Reminder_Email</name>
                <type>Task</type>
            </actions>
            <offsetFromField>ServiceAppointment.SchedStartTime</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send Scheduling Reminder Emails</fullName>
        <active>false</active>
        <criteriaItems>
            <field>ServiceAppointment.Status</field>
            <operation>equals</operation>
            <value>None</value>
        </criteriaItems>
        <criteriaItems>
            <field>ServiceAppointment.Duration</field>
            <operation>lessThan</operation>
            <value>9</value>
        </criteriaItems>
        <criteriaItems>
            <field>ServiceAppointment.Subject</field>
            <operation>equals</operation>
            <value>New Installation</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AAA_Non_Response_Reminder_3_Day_Alert</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Sent_AAA_Non_Response_Reminder_3_Day_Alert</name>
                <type>Task</type>
            </actions>
            <offsetFromField>ServiceAppointment.CreatedDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>AAA_Non_Response_Reminder_6_Day_Alert</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Sent_AAA_Non_Response_Reminder_6_Day_Alert</name>
                <type>Task</type>
            </actions>
            <offsetFromField>ServiceAppointment.CreatedDate</offsetFromField>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>AAA_Non_Response_Reminder_9_Day_Alert</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Sent_AAA_Non_Response_Reminder_9_Day_Alert</name>
                <type>Task</type>
            </actions>
            <offsetFromField>ServiceAppointment.CreatedDate</offsetFromField>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>AAA_Non_Response_Reminder_Final_Alert</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Sent_AAA_Non_Response_Reminder_Final_Alert</name>
                <type>Task</type>
            </actions>
            <offsetFromField>ServiceAppointment.CreatedDate</offsetFromField>
            <timeLength>12</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Service Booking Confirmation Email</fullName>
        <actions>
            <name>Service_Booking_Confirmation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Service_Booking_Confirmation_Email</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ServiceAppointment.Status</field>
            <operation>equals</operation>
            <value>Scheduled</value>
        </criteriaItems>
        <criteriaItems>
            <field>ServiceAppointment.Service_Type__c</field>
            <operation>equals</operation>
            <value>Service Appointment</value>
        </criteriaItems>
        <criteriaItems>
            <field>ServiceAppointment.In_Scheduler__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Uncheck Multi Day Appointment</fullName>
        <actions>
            <name>Uncheck_Multi_Day_Appointment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ServiceAppointment.Duration</field>
            <operation>lessOrEqual</operation>
            <value>8</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Duration for Eligible Service Appointments</fullName>
        <actions>
            <name>Update_Duration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ServiceAppointment.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This rule is used to update duration field based on the Products associated to its Work Order and turnover Opportunity.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Sent_AAA_24_Hour_Appointment_Reminder_Email</fullName>
        <assignedTo>crmsuperhero@aaa.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent AAA 24 Hour Appointment Reminder Email</subject>
    </tasks>
    <tasks>
        <fullName>Sent_AAA_2_Day_Appointment_Reminder_Email</fullName>
        <assignedTo>crmsuperhero@aaa.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent AAA 2 Day Appointment Reminder Email</subject>
    </tasks>
    <tasks>
        <fullName>Sent_AAA_7_Day_Appointment_Reminder_Email</fullName>
        <assignedTo>crmsuperhero@aaa.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent	AAA 7 Day Appointment Reminder Email</subject>
    </tasks>
    <tasks>
        <fullName>Sent_AAA_Non_Response_Reminder_3_Day_Alert</fullName>
        <assignedTo>crmsuperhero@aaa.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent	AAA Non Response Reminder 3 Day Alert</subject>
    </tasks>
    <tasks>
        <fullName>Sent_AAA_Non_Response_Reminder_6_Day_Alert</fullName>
        <assignedTo>crmsuperhero@aaa.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent AAA Non Response Reminder 6 Day Alert</subject>
    </tasks>
    <tasks>
        <fullName>Sent_AAA_Non_Response_Reminder_9_Day_Alert</fullName>
        <assignedTo>crmsuperhero@aaa.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent AAA Non Response Reminder 9 Day Alert</subject>
    </tasks>
    <tasks>
        <fullName>Sent_AAA_Non_Response_Reminder_Final_Alert</fullName>
        <assignedTo>crmsuperhero@aaa.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent AAA Non Response Reminder Final Alert</subject>
    </tasks>
    <tasks>
        <fullName>Sent_Booking_Confirmation_Email</fullName>
        <assignedTo>crmsuperhero@aaa.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Sent Booking Confirmation Email</subject>
    </tasks>
    <tasks>
        <fullName>Service_Booking_Confirmation_Email</fullName>
        <assignedTo>crmsuperhero@aaa.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Service Booking Confirmation Email</subject>
    </tasks>
</Workflow>
