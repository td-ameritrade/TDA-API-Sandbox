

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;


public class READNEWS {

public static void main(String[]args) throws MalformedURLException, IOException, InvalidSessionException
{
	AMERHTTPSAPI.login();
	
	System.out.println(">1.111");
		
      Config config=Config.readConfig();
	  final String syms="CTXS+DELL";
      System.out.println("syms "+syms);
	 
	  InputStream is=StreamerAPI.NEWS(syms);
	  new ParseResponse(is);
		
	
//	StringHelper.inputStreamtoFile(StreamerAPI.NEWS("*ALL*+*HOT*"),new File(URLUtil.getLogDir(),"news_all"));
	
	
	
	

}

}

