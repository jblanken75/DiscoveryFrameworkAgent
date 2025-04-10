# Discovery Framework Agent
This is a framework that allows for Agentforce Agents to use Discovery Framework Omniscripts to power Agentforce conversations.  

# Assumptions/Limitations about the framework
* An Active Discovery Framework Omniscript must be created.  The Omniscript must be a Discovery Framework Omniscript and cannot be a non Discovery Framework Omniscript
* This will only work with single value elements such as Text, Number, Date.  Grouped elements such as Blocks and Edit Blocks will not work

# What's included in the Repository
* All source code related to the framework - Apex Classes, Integration Procedures, Data Mappers, Permission Set, 
* Example Child Care Eligibility Omniscript and Assessment Questions
* Example Agent, Topic, Agent Actions for the Child Care Eligibility
* Datapacks if you wish to manually install the components and not use the Metadata API

# Setup Instructions

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
8. omniScripts
9. genAIFunctions
10. genAIPlugins
11. genAIPlanners
Assign the DF Agent Permissions Permission Set Group to the Agent User


