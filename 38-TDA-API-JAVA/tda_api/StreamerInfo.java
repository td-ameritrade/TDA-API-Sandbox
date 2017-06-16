

public class StreamerInfo {

	  public final String streamer_url; 
	  public final String token;
	  public final String timestamp; 
	  public final String cd_domain_id; 
	  public final String usergroup;
	  public final String access_level; 
	  public final String acl; 
	  public final String app_id; 
	  public final String authorized; 
	 
	  Config config=Config.readConfig();

	  static public final String base="http://ameritrade02.streamer.com/!";
	  public String baseURL()
	  {
			return "U="+config.AMTDAccountNumber+
			"&W="+token+
			"&A=userid="+config.AMTDAccountNumber+
			"&token="+token+
			"&company="+ SessionControl.getCompany() +     
			"&segment="+ SessionControl.getSegment() +  
			"&cddomain="+cd_domain_id+
			"&usergroup="+usergroup+
			"&accesslevel="+access_level+
			"&authorized="+authorized+
			"&acl="+acl+
			"&timestamp="+timestamp+
			"&appid="+app_id;

	  }
	  
	  public StreamerInfo(XMLNode root)
	  {
		XMLNode si=root.getChildwithNameNonNull("streamer-info");
		 streamer_url=si.getChildwithNameNonNull("streamer-url").getValue(); 
		 token=si.getChildwithNameNonNull("token").getValue();
		 timestamp=si.getChildwithNameNonNull("timestamp").getValue();
		 cd_domain_id=si.getChildwithNameNonNull("cd-domain-id").getValue(); 
		 usergroup=si.getChildwithNameNonNull("usergroup").getValue();
		 access_level=si.getChildwithNameNonNull("access-level").getValue();
		 acl=si.getChildwithNameNonNull("acl").getValue(); 
		 app_id=si.getChildwithNameNonNull("app-id").getValue();
		 authorized=si.getChildwithNameNonNull("authorized").getValue();
		  
	  }
	
}
