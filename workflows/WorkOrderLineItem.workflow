<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>New_Discount</fullName>
        <field>New_Discount__c</field>
        <formula>IF(  Product_Family__c = &quot;Equipment&quot; &amp;&amp;  WorkOrder.Contract_Term__c  = 1, (( New_Sales_Price__c  / (1- WorkOrder.Opportunity__r.Equipment_Discount__c  )* WorkOrder.Opportunity__r.Equipment_Discount__c ) * (Quantity -  Original_Quantity__c )),

IF(  Product_Family__c = &quot;Equipment&quot; &amp;&amp; WorkOrder.Contract_Term__c  &gt; 1, (( New_Sales_Price__c  / (1- WorkOrder.Opportunity__r.Equipment_Discount__c  )* WorkOrder.Opportunity__r.Equipment_Discount__c ) * Quantity ), 0))</formula>
        <name>New Discount $</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Final_Price</fullName>
        <field>New_Final_Price__c</field>
        <formula>IF( WorkOrder.Contract_Term__c = 1,
(New_Sales_Price__c * (Quantity -  Original_Quantity__c )) + 
IF( Product_Family__c = &quot;Equipment&quot;, (( New_Sales_Price__c * (Quantity-Original_Quantity__c) ) * WorkOrder.Opportunity__r.Tax_Percent__c ),0),
(New_Sales_Price__c * Quantity) + 
IF( Product_Family__c = &quot;Equipment&quot;, (( New_Sales_Price__c * Quantity ) * WorkOrder.Opportunity__r.Tax_Percent__c ),0))</formula>
        <name>New Final Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Tax</fullName>
        <field>New_Tax__c</field>
        <formula>IF( WorkOrder.Contract_Term__c = 1 &amp;&amp; Product_Family__c = &quot;Equipment&quot;,  ((New_Sales_Price__c *  (Quantity -  Original_Quantity__c ))  *  WorkOrder.Opportunity__r.Tax_Percent__c  ),

IF( WorkOrder.Contract_Term__c &gt; 1 &amp;&amp; Product_Family__c = &quot;Equipment&quot;,  ((  New_Sales_Price__c *  Quantity )  *  WorkOrder.Opportunity__r.Tax_Percent__c  ), 0))</formula>
        <name>New Tax $</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Total_Price</fullName>
        <field>New_Total_Price__c</field>
        <formula>IF( WorkOrder.Contract_Term__c = 1, New_Sales_Price__c *  (Quantity - Original_Quantity__c ),
New_Sales_Price__c *  Quantity)</formula>
        <name>New Total Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Skill_Number</fullName>
        <field>Skill_Number__c</field>
        <formula>IF(Skill_Level__c = &quot;L1&quot;, 1,
IF(Skill_Level__c = &quot;L2&quot;, 2,
IF(Skill_Level__c = &quot;L3&quot;, 3,
IF(Skill_Level__c = &quot;L1 or L3&quot;, 1, 0))))</formula>
        <name>Skill Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Quantity is Changed</fullName>
        <actions>
            <name>New_Discount</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>New_Final_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>New_Tax</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>New_Total_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Quantity )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Skill Level</fullName>
        <actions>
            <name>Skill_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
