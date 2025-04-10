public without sharing class AgentForceSaveDiscoveryFramework {
    @InvocableMethod(
        label='SaveDiscoveryFramework'
        description='After running a Discovery Framework through Agentforce this can be used as an Action to save the results of an Assessment'
    )
 
  public static List<DFResponse> processSaveDiscoveryFramework(List<DFRequest> requests) {
        // Retrieve the details of the Omniscript to retrieve
        String osType = (String) requests[0].osType;
        String osSubType = (String) requests[0].osSubType;
        String osLanguage = (String) requests[0].osLanguage;
        String dataJSON = (String) requests[0].dataJSON;
       

        // Create the IP to get the Omniscript details
        String procedureName = 'Agent_SaveAssessment';
        Map<String, Object> ipInput = new Map<String, Object> ();
        Map<String, Object> ipOutput = new Map<String, Object> ();
        Map<String, Object> ipOptions = new Map<String, Object> ();
        
        ipInput.put('Type', osType);
        ipInput.put('SubType', osSubType);
        ipInput.put('Language', osLanguage);
        ipInput.put('dataJSON', dataJSON);
        
        /* Call the IP via runIntegrationService, 
        and save the output to ipOutput */
        ipOutput = (Map<String, Object>) omnistudio.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);
        
        DFResponse response = new DFResponse();
        
        String JSONOutput = JSON.serialize(ipOutput);
        
        response.resultMap = JSONOutput;
        
         return new List<DFResponse>{ response };
    }

    public class DFRequest {
        @InvocableVariable(
            required=true
            description='Type of Omniscript'
        )
        public String osType;
        
        @InvocableVariable(
            required=true
            description='SubType of Omniscript'
        )
        public String osSubType;
        
        @InvocableVariable(
            required=true
            description='Language of Omniscript'
        )
        public String osLanguage;
        
         @InvocableVariable(
            required=true
            description='Formatted JSON of Assessment'
        )
        public String dataJSON;
    }

    public class DFResponse {
        @InvocableVariable(
            description='Response'
        )
        public String resultMap;
    }
}