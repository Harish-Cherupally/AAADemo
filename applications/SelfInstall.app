<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <actionOverrides>
        <actionName>Tab</actionName>
        <content>Warehouse_Home</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>standard-home</pageOrSobjectType>
    </actionOverrides>
    <brand>
        <headerColor>#D72905</headerColor>
        <shouldOverrideOrgTheme>false</shouldOverrideOrgTheme>
    </brand>
    <description>Manage Shipping Orders</description>
    <formFactors>Small</formFactors>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>false</isNavPersonalizationDisabled>
    <label>Self Install</label>
    <navType>Console</navType>
    <tabs>Order_Self_Install</tabs>
    <tabs>standard-ReturnOrder</tabs>
    <tabs>Error_Log__c</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>Warehouse_UtilityBar</utilityBar>
    <workspaceConfig>
        <mappings>
            <tab>Error_Log__c</tab>
        </mappings>
        <mappings>
            <tab>Order_Self_Install</tab>
        </mappings>
        <mappings>
            <tab>standard-ReturnOrder</tab>
        </mappings>
    </workspaceConfig>
</CustomApplication>
