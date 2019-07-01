<aura:application extends="force:slds">
    <c:lightningLeafletCmp />
    ---
    <lightning:buttonIcon iconName="utility:close" variant="bare" onclick="{! c.handleClick }" alternativeText="Close window" />
    ======
<!--    <c:ElementDetail />-->
    <!--<c:TestSection recordId="0011U00000ApnfN" PageLayoutName="Account-Account Layout" /> -->
     <lightning:buttonIcon iconName="utility:close"  size="medium" class="slds-modal__close slds-button slds-button_icon-bare" alternativeText="Close window"/>
    <c:dynamicDependentPicklist />
    <c:OpportunityAction  recordId="0064P00000iXgsNQAS" selectedProcess="needbuildinginfo"/>
<!--
<aura:attribute name="options" type="List" />
    <aura:attribute name="test" type="String" />
	<aura:if isTrue="false">    	
        	<aura:set attribute="else"  >nn</aura:set>
    </aura:if>
    invoking MultiSelect component 
    <c:dynamicMultiSelectPicklist mslabel="Job Location" mssobject="INLA__Test_Object__c" fieldBinding="INLA__MultiSelect__c" />
    <c:datatableGrid />
    <br></br>
    <br></br>:::uiinputdate
    <c:uiInputDate />
    <br></br><br></br><br></br><br></br>datetime::
    <ui:inputDate aura:id="EndDateField" value="" displayDatePicker="true" format="dd/MM/yyyy"/>
    <lightning:input aura:id="dob" type="date" name="accdob" dateStyle="short" label="Date of Birth" value="" format="dd/MM/yyyy"/>
    
    <aura:attribute name="currentDate" type="Date"/>
    <lightning:formattedDateTime aura:id="dt"
                                     value="{!v.currentDate}"
                                     month="short"
                                     day="numeric"
                                     year="numeric"
                                     hour="2-digit"
                                     minute="2-digit"
                                     second="2-digit"
                                     hour12="true"
                                     timeZone="{!$Locale.timezone}"/>
    <p><lightning:formattedDateTime value="1479944705000"/></p>
    <p><lightning:formattedDateTime value="1479944705000" year="2-digit" month="short" day="2-digit" weekday="narrow"/></p>
    <p><lightning:formattedDateTime value="1479944705000" year="2-digit" month="short" day="2-digit" weekday="long"/></p>-->
</aura:application>