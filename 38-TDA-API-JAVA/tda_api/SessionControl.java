


public class SessionControl {
	private static String sessionid;
	private static String segment;
	private static String company;
	
	public static String getSessionid() {
		if(sessionid==null){
			throw new RuntimeException("please login first");
		}

		return sessionid;
	}

	/**
	 * Sets the SessionID.
	 * System will exit if try to set more than once in 60 seconds
	 * As this shows we are in a loop.
	 * We dont want to create a Denial of service attack on AM.
	 */
	public static void setSessionid(String sessionid) {
		SessionControl.sessionid = sessionid;
		
	}

	public static void setSegment(String segment) {
		SessionControl.segment = segment;
	}

	public static void setCompany(String company) {
		SessionControl.company = company;
	}

	public static String getCompany() {
		return company;
	}

	public static String getSegment() {
		return segment;
	}
	
	
}
