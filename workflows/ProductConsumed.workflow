<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Check_Calculate</fullName>
        <field>Calculate__c</field>
        <literalValue>1</literalValue>
        <name>Check Calculate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Discount</fullName>
        <field>Discount__c</field>
        <formula>((( UnitPrice * WorkOrder.Opportunity__r.Equipment_Discount__c) / (WorkOrder.Opportunity__r.Equipment_Discount__c  )* WorkOrder.Opportunity__r.Equipment_Discount__c  ) *  QuantityConsumed  )</formula>
        <name>Discount $</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Price</fullName>
        <field>Final_Price__c</field>
        <formula>((UnitPrice * (1-WorkOrder.Opportunity__r.Equipment_Discount__c)) * QuantityConsumed) + 

(((UnitPrice * (1-WorkOrder.Opportunity__r.Equipment_Discount__c)) * QuantityConsumed) *  WorkOrder.Opportunity__r.Tax_Percent__c )</formula>
        <name>Final Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Price</fullName>
        <field>Sales_Price__c</field>
        <formula>UnitPrice * (1- WorkOrder.Opportunity__r.Equipment_Discount__c)</formula>
        <name>Sales Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Tax</fullName>
        <field>Tax__c</field>
        <formula>(( (UnitPrice * (1- WorkOrder.Opportunity__r.Equipment_Discount__c)) *  QuantityConsumed ) *  WorkOrder.Opportunity__r.Tax_Percent__c  )</formula>
        <name>Tax $</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Total_Price</fullName>
        <field>Total_Price__c</field>
        <formula>((UnitPrice * (1- WorkOrder.Opportunity__r.Equipment_Discount__c)) * QuantityConsumed)</formula>
        <name>Total Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unit_Price</fullName>
        <field>UnitPrice</field>
        <formula>0</formula>
        <name>Unit Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Calculate Amounts</fullName>
        <actions>
            <name>Discount</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Final_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sales_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Tax</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Total_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ProductConsumed.Calculate__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This is old WFR now using Flow to Fire Calculations</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Check Calculate</fullName>
        <actions>
            <name>Check_Calculate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Whenever New Product is Consumed Check Box to Calculate to Fire Other WFRs</description>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
