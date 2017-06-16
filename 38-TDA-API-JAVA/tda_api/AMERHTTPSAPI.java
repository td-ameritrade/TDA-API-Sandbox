

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;


public class AMERHTTPSAPI {

	
	
	
	
	
	
static	Config config=Config.readConfig();



public static XMLNode  getQuotes(String symbols) throws IOException, InvalidSessionException
{
	
String str="https://apis.tdameritrade.com/apps/100/Quote;jsessionid="+SessionControl.getSessionid()+"?source="+config.AMTDsourceID+"&symbol="+symbols;
String res=URLUtil.getfromURL(str);
File file=new File(URLUtil.getLogDir(),"quote.xml");

return unpack(res);
}

//action=buy~quantity=400~symbol=DELL~ordtype=Limit~price=27.49~actprice=~tsparam=~expire=day~spinstructions=none~routing=auto~displaysize=~exmonth=~exday=~exyear=~accountid=123456789)


static XMLNode  unpack(String res) throws InvalidSessionException
{
	XMLNode root=new XMLNodeBuilder(res).getRoot();

	XMLNode errorNode=root.getChildwithName("error");
	if(errorNode!=null&&errorNode.getValue().equals("Invalid Session")){
		throw new InvalidSessionException();
	}
	
	return root;
	
}


public static StreamerInfo  StreamerInfo() throws IOException, InvalidSessionException
	{
	
		String str="https://apis.tdameritrade.com/apps/100/StreamerInfo;jsessionid="+SessionControl.getSessionid()+"?source="+config.AMTDsourceID;
  String res=URLUtil.getfromURL(str);
  File file=new File(URLUtil.getLogDir(),"streamerinfo.xml");
  XMLNode node=unpack(res);
return new StreamerInfo(node);
	}
	
static long lastlogintime;

	public static void login() throws IOException
	{
		long now=System.currentTimeMillis();
		if(lastlogintime!=0&&((now-lastlogintime)<1000*60*5)){
			System.err.println("We tried to set this less than 5 minutes ago");
			System.exit(0);
		}
		
		lastlogintime=now;
//		http://ameritrade02.streamer.com/!U=870000189&W=b3cb690339ba220bde92c9f42e4e75bbaf5615db&A=userid=870000189&token=b3cb690339ba220bde92c9f42e4e75bbaf5615db&company=AMER&segment=UAMER&cddomain=A000000008835677&usergroup=ACCT&accesslevel=ACCT&authorized=Y&acl=ADAQC1DRESGKIPMAOLPNQSRFSPTETFTOTTUAWSQ2NS&timestamp=1143132528988&appid=testapp1|

OrderedHashMap ohm=new OrderedHashMap();
ohm.put("userid",config.AMTDUserName);
ohm.put("password",config.AMTDPassword);
ohm.put("source",config.AMTDsourceID);  //F3
ohm.put("version","1001");
String url="https://apis.tdameritrade.com/apps/100/LogIn";
String res=URLUtil.sendURLPostRequest(url,ohm);

XMLNode  root=new XMLNodeBuilder(res).getRoot();

SessionControl.setSessionid(root.getChildwithNameNonNull("xml-log-in").getChildwithNameNonNull("session-id").getValue());
SessionControl.setSegment(root.getChildwithNameNonNull("xml-log-in").getChildwithNameNonNull("accounts").getChildwithName("account").getChildwithNameNonNull("segment").getValue());
SessionControl.setCompany(root.getChildwithNameNonNull("xml-log-in").getChildwithNameNonNull("accounts").getChildwithName("account").getChildwithNameNonNull("company").getValue());
//  

// Sending information through HTTPS: POST




	}
	
	
}
