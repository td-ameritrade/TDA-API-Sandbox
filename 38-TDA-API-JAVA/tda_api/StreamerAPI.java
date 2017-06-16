

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;

public class StreamerAPI {

	private static StreamerInfo _si;
	
	public static StreamerInfo getStreamerInfo() throws IOException, InvalidSessionException
	{
	if(_si==null){
		_si=AMERHTTPSAPI.StreamerInfo();
	}//if
   return _si;
	
	}
	
	
	
public static void main(String[]args) throws IOException, InvalidSessionException
{
	System.out.println(">1.111");
	AMERHTTPSAPI.login();
	
	
	NEWS("*ALL*+*HOT*");
	
		
	

	System.out.println("done");

}





public static InputStream NEWS(String symbols) throws MalformedURLException, IOException, InvalidSessionException
{
	String url=getStreamerInfo().baseURL()
	+"|S=NEWS" 
	+"&C=SUBS"
	+"&P="+symbols
	+"&T=0+1+2+3";
String str=StreamerInfo.base+URLEncoder.encode(url, "UTF-8");
System.out.println(str);
return new URL(str).openStream();	
}



public static InputStream levelIQuote() throws MalformedURLException, IOException, InvalidSessionException
{
	String url=getStreamerInfo().baseURL()
	+"|S=QUOTE" 
	+"&C=SUBS"
	+"&P=DELL+CTXS+IBM"
	+"&T=0+1+2+3+8+10+11+12+13+15+16+19+20";
String str=StreamerInfo.base+URLEncoder.encode(url, "UTF-8");
return new URL(str).openStream();	
}

public static InputStream levelIIQuote() throws MalformedURLException, IOException, InvalidSessionException
{   //Currently not authorized for LevelII Quotes
	String url=getStreamerInfo().baseURL()
	+"|S=LEVELII" 
	+"&C=SUBS"
	+"&P=DELL+CTXS+IBM"
	+"&T=0+1+2+3";
String str=StreamerInfo.base+URLEncoder.encode(url, "UTF-8");
return new URL(str).openStream();	

}



}