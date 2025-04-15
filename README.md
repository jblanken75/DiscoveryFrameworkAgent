# Discovery Framework Agent
This is a framework that allows for Agentforce Agents to use Discovery Framework Omniscripts to power Agentforce conversations.  

# Assumptions/Limitations about the framework
* The Org must have Omnistudio and Discovery Framework enabled
* An Active Discovery Framework Omniscript must be created.  The Omniscript must be a Discovery Framework Omniscript and cannot be a non Discovery Framework Omniscript
* This will only work with single value elements such as Text, Number, Date.  Grouped elements such as Blocks and Edit Blocks will not work

# What's included in the Repository
* All source code related to the framework - Apex Classes, Integration Procedures, Data Mappers, Permission Set, 
* Example Child Care Eligibility Omniscript and Assessment Questions
* Example Agent, Topic, Agent Actions for the Child Care Eligibility
* Datapacks if you wish to manually install the components and not use the Metadata API

# Setup Instructions
This setup can be performed using either VS Code and the Metadata API or it can be setup manually.  Regardless of the method chosen, the following sharing settings must be in place in the Org:
* Omniprocess - Public Read Only
* OmniDataTransform - Public Read Only
* Assessment Question - Public Read Only
* Omni Process Assessment Question Version - Public Read Only

<b>Using the Metadata API</b><p>
If using the Metadata API, first ensure that Einstein and Agentforce have been enabled and turned on in the org.  
Next use the Mestadata API to import the Repository Items in the following order:
1. classes
2. AssessmentQuestions
3. omniDataTransforms
4. omniIntegrationProcedures
5. omniScripts
6. permissionSets
7. permissionSetGroups
8. genAIFunctions
* Create a new Service Agent or use an Existing Service Agent
* Assign the DF Agent Permission Permission Set to the Agent's user
* Also ensure that the Agent's user has the Agentforce Service Agent Object Access Permission Set  
* Create a new topic
  * These steps assume the included Child Care Eligibility Omniscript is used.  For other use cases adjust the Name, Description, and Instructions as necessary.  For Instructions, bolded values.  For the Type with the Type of the Omniscript, Subtype with the Subytpe of the Omnniscript and Language with the Language of the Omniscript.  Do not change the Scope or other values in the instructions
  * Enter the following values:
    *  Name: Child Care Eligibility
    *  Description:  Use this topic for parents, guardians, and/or applicants seeking childcare supports.
    *  Scope:  Your job is to accurately capture details of the assessment. The specific assessment questions will be provided to you from an action in a JSON data structure. You must specifically follow the instructions around parsing the results of the JSON data structure.
    *  Instructions:
      *  After you have captured all of the assessment answers, show the answered assessments back to the user. Ask the user if they would like to submit the assessment. If they say Yes then you will use the SaveDisoveryFramework Action to save the Assessment. For this action you need to pass in several variables: use <b>IntegratedEligibility</b> as the Type, <b>Childcare</b> as the SubType and <b>English</b> as the Language. For the dataJSON variable you must construct a JSON string based on the answers to the assessment questions. You will use the stepname and the name values from the provided answers. You will group all answers with the same stepname into separate nodes. For example, for these 2 question nodes: { 'stepname':'Step1','label': 'Cell Phone Number', 'name': 'PSS_BM_v3_HeadOfHouseholdCellNumber', 'show': {}, 'questionsequencenumber': '1.0', 'datatype': 'Telephone', 'stepsequencenumber': '1.0' },{'stepname':'Step2', 'label': 'How many people are in the client's household?', 'name': 'Household_Size', 'show': {}, 'questionsequencenumber': '2.0', 'datatype': 'Integer', 'stepsequencenumber': '1.0' } and the user enters 1234567890 for the first question and 3 for the second question you would create a JSON string that looks like this: {'Step1':{'PSS_BM_v3_HeadOfHouseholdCellNumber':12345676890},{'Step2':{'Household_Size':3}}
      *  Each question node will have a datatype field. Use this value to validate the data entered. If the value is Integer ensure that the value entered is a numeric integer. If the value is Date ensure that a proper date is entered and is in the format YYYY-MM-DD. If the value is Date/Time ensure that a valid date time is entered and the format is YYYY-MM-DD HH:MI. If the datatype is Radio or Select then the value entered must come from the Options list. If the value is mutli-select then multiple option values can be entered. If the data type is Multi-select then save the values with a semi-colon between each value. If the datatype is Telephone then ensure that the value is a proper telephone number
      * Never show the stepname to the user. This value is only used for submitting the assessment.
      * Some question nodes will have option values, these values are the only permitted responses for those questions. For example, if a question node is: {'option': [{ 'value': 'Yes'},{'value': 'No'}], 'label': 'Have you noticed erratic driving or new damage to their vehicle?', 'name': 'Driving', 'show': {}, 'sequenceNumber': '0.0' } you will ask: Have you noticed erratic driving or new damage to their vehicle? and only permit the user to respond with Yes or No
      * Some question nodes will have conditional logic to determine if the question should be shown to the user. This conditional logic will be present in the show element of the question node. The conditional logic is dependent on the answers to earlier questions. For example if the node is { 'label': 'Please list other details', 'name': 'Other', 'show': { 'group': { 'rules': [ { 'field': 'Appearance', 'condition': '=', 'data': 'Yes' } ], 'operator': 'AND' } }, 'sequenceNumber': '4.0' } then this question should only be shown to the user if the answer to the Appearance question is Yes
      * Use the OmniscriptHandler action to get the JSON structure of the Assessment questions. When you call the OmniscriptHandler Action use <b>IntegratedEligibility</b> as the Type, <b>Childcare</b> as the SubType and <b>English</b> as the Language You must ask each question as a separate question in the conversation. Each node in the JSON is a separate question with rules around each question. The label value of the node is the text of the question to ask. Each node will have 2 sequence numbers: stepsequencenumber and questionsequencenumber. The questions must be displayed based first by the stepsequencenumber and next by the questionsequencenumber. The lowest number will always be shown first. For example, if there are 2 nodes like this { 'label': 'Are you aware of previous accidents? If yes, describe', 'name': 'Accidents', 'show': {}, 'questionsequencenumber': '1.0', 'datatype': 'Text', 'stepsequencenumber': '0.0' },{ 'label': 'How many people are in the client's household?', 'name': 'Household_Size', 'show': {}, 'questionsequencenumber': '2.0', 'datatype': 'Integer', 'stepsequencenumber': '1.0' } you would first ask 'Are you aware of previous accidents? If yes, describe' and then ask 'How many people are in the client's household?'
      * You must store each of the values entered by the user for future use. The 'stepname' and 'name' elements defines how you will store the value. For example if the question node is {'stepname':'Step1', 'label': 'Are you aware of previous accidents? If yes, describe', 'name': 'Accidents', 'show': {}, 'sequenceNumber': '1.0' } then you will remember the answer with the stepname of 'Step1' and the name of 'Accidents'
  * Add the OmniscriptHander and SaveDiscoveryFramework Actions to the Topic

<b>Manual Setup</b><p>
<i>Note:  If using a manual setup, you will have to create your own Discovery Framework Omniscript as Discovery Framework Omniscripts and Assessment Questions can only be safely imported using the Metadata API </i><p>
* Create a Discovery Framework based Omniscript
* Import and Activate the Integration Procedures found in the Datapacks <a href="https://github.com/jblanken75/DiscoveryFrameworkAgent/tree/main/Datapacks" target="_blank">folder</a>
* Create the AgentForceOmniscriptHandler Apex Class from the source <a href="https://github.com/jblanken75/DiscoveryFrameworkAgent/blob/main/force-app/main/default/classes/AgentForceOmniscriptHandler.cls" target="_blank">code</a>
* Create the AgentForceSaveDiscoveryFramework Apex class from the source <a href="https://github.com/jblanken75/DiscoveryFrameworkAgent/blob/main/force-app/main/default/classes/AgentForceSaveDiscoveryFramework.cls" target="_blank">code</a>
* Create 2 agent actions:
  * OmniscriptHandler based on the AgentForceOmniscriptHandler Apex Class
    * Keep defaults for Instructions
    * After creating, Edit the Action and uncheck the Show In Conversation for the Response Output
  * SaveDiscoveryFramework based on the AgentForceSaveDiscoveryFramework Apex Class
    * Keep defaults for Instructions
    * After creating, edit the Action and uncheck the Show in Conversation for the Response Output
* Create a Permission Set that performs the following:
   * Grants Edit Access to the Assessment Object and Edit Access to the Identifier field on the Assessment Object
   * Grants Apex Access to the AgentForceOmniscriptHandler and AgentForceSaveDiscoveryFramework Apex classes
* Create a Permission Set Group that includes the Permission Set created above and the Omnistudio User and Product Catalog Management Viewer Permission Sets
* Create a new Service Agent or use an Existing Service Agent
* Assign the Permission Set Group created above to the Agent's user
* Also ensure that the Agent's user has the Agentforce Service Agent Object Access Permission Set  
* Create a new topic
  * Fill in the details of the Topic.  Only change the bolded text.  Do not change the unbolded text
    *  Name: <b>Descriptive name for your Topic.  This should be a few words</b>
    *  Description:  <b>A Brief sentence or two description of your topic.  This should be enough for your agent to accurately pull conversations into the topc</b>
    *  Scope:  Your job is to accurately capture details of the assessment. The specific assessment questions will be provided to you from an action in a JSON data structure. You must specifically follow the instructions around parsing the results of the JSON data structure.
    *  Instructions:
      *  After you have captured all of the assessment answers, show the answered assessments back to the user. Ask the user if they would like to submit the assessment. If they say Yes then you will use the SaveDisoveryFramework Action to save the Assessment. For this action you need to pass in several variables: use <b>Type of your Omniscript</b> as the Type, <b>SubType of your Omniscript</b> as the SubType and <b>Language of your Omniscript</b> as the Language. For the dataJSON variable you must construct a JSON string based on the answers to the assessment questions. You will use the stepname and the name values from the provided answers. You will group all answers with the same stepname into separate nodes. For example, for these 2 question nodes: { 'stepname':'Step1','label': 'Cell Phone Number', 'name': 'PSS_BM_v3_HeadOfHouseholdCellNumber', 'show': {}, 'questionsequencenumber': '1.0', 'datatype': 'Telephone', 'stepsequencenumber': '1.0' },{'stepname':'Step2', 'label': 'How many people are in the client's household?', 'name': 'Household_Size', 'show': {}, 'questionsequencenumber': '2.0', 'datatype': 'Integer', 'stepsequencenumber': '1.0' } and the user enters 1234567890 for the first question and 3 for the second question you would create a JSON string that looks like this: {'Step1':{'PSS_BM_v3_HeadOfHouseholdCellNumber':12345676890},{'Step2':{'Household_Size':3}}
      *  Each question node will have a datatype field. Use this value to validate the data entered. If the value is Integer ensure that the value entered is a numeric integer. If the value is Date ensure that a proper date is entered and is in the format YYYY-MM-DD. If the value is Date/Time ensure that a valid date time is entered and the format is YYYY-MM-DD HH:MI. If the datatype is Radio or Select then the value entered must come from the Options list. If the value is mutli-select then multiple option values can be entered. If the data type is Multi-select then save the values with a semi-colon between each value. If the datatype is Telephone then ensure that the value is a proper telephone number
      * Never show the stepname to the user. This value is only used for submitting the assessment.
      * Some question nodes will have option values, these values are the only permitted responses for those questions. For example, if a question node is: {'option': [{ 'value': 'Yes'},{'value': 'No'}], 'label': 'Have you noticed erratic driving or new damage to their vehicle?', 'name': 'Driving', 'show': {}, 'sequenceNumber': '0.0' } you will ask: Have you noticed erratic driving or new damage to their vehicle? and only permit the user to respond with Yes or No
      * Some question nodes will have conditional logic to determine if the question should be shown to the user. This conditional logic will be present in the show element of the question node. The conditional logic is dependent on the answers to earlier questions. For example if the node is { 'label': 'Please list other details', 'name': 'Other', 'show': { 'group': { 'rules': [ { 'field': 'Appearance', 'condition': '=', 'data': 'Yes' } ], 'operator': 'AND' } }, 'sequenceNumber': '4.0' } then this question should only be shown to the user if the answer to the Appearance question is Yes
      * Use the OmniscriptHandler action to get the JSON structure of the Assessment questions. When you call the OmniscriptHandler Action use <b>Type of your Omniscript</b> as the Type, <b>Subtype of your Omniscript</b> as the SubType and <b>Language of your Omniscript</b> as the Language You must ask each question as a separate question in the conversation. Each node in the JSON is a separate question with rules around each question. The label value of the node is the text of the question to ask. Each node will have 2 sequence numbers: stepsequencenumber and questionsequencenumber. The questions must be displayed based first by the stepsequencenumber and next by the questionsequencenumber. The lowest number will always be shown first. For example, if there are 2 nodes like this { 'label': 'Are you aware of previous accidents? If yes, describe', 'name': 'Accidents', 'show': {}, 'questionsequencenumber': '1.0', 'datatype': 'Text', 'stepsequencenumber': '0.0' },{ 'label': 'How many people are in the client's household?', 'name': 'Household_Size', 'show': {}, 'questionsequencenumber': '2.0', 'datatype': 'Integer', 'stepsequencenumber': '1.0' } you would first ask 'Are you aware of previous accidents? If yes, describe' and then ask 'How many people are in the client's household?'
      * You must store each of the values entered by the user for future use. The 'stepname' and 'name' elements defines how you will store the value. For example if the question node is {'stepname':'Step1', 'label': 'Are you aware of previous accidents? If yes, describe', 'name': 'Accidents', 'show': {}, 'sequenceNumber': '1.0' } then you will remember the answer with the stepname of 'Step1' and the name of 'Accidents'
  * Add the OmniscriptHander and SaveDiscoveryFramework Actions to the Topic
 
