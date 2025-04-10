public without sharing class AgentForceOmniscriptHandler {
    @InvocableMethod(
        label='OmniscriptHandler'
        description='Returns a formatted set of questions from an Omniscript to power an Agentforce Conversation'
    )
 
  public static List<OSResponse> processOmniscriptHandler(List<OSRequest> requests) {
        // Retrieve the details of the Omniscript to retrieve
        String osType = (String) requests[0].osType;
        String osSubType = (String) requests[0].osSubType;
        String osLanguage = (String) requests[0].osLanguage;
       

        // Create the IP to get the Omniscript details
        String procedureName = 'Agent_GetOSDetails';
        Map<String, Object> ipInput = new Map<String, Object> ();
        Map<String, Object> ipOutput = new Map<String, Object> ();
        Map<String, Object> ipOptions = new Map<String, Object> ();
        
        ipInput.put('Type', osType);
        ipInput.put('SubType', osSubType);
        ipInput.put('Language', osLanguage);
        
        /* Call the IP via runIntegrationService, 
        and save the output to ipOutput */
        ipOutput = (Map<String, Object>) omnistudio.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions);
        
        OSResponse response = new OSResponse();
        
        String JSONOutput = JSON.serialize(ipOutput);
        
        response.resultMap = JSONOutput;
        
         return new List<OSResponse>{ response };
    }

    public class OSRequest {
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
    }

    public class OSResponse {
        @InvocableVariable(
            description='Response'
        )
        public String resultMap;
    }
}