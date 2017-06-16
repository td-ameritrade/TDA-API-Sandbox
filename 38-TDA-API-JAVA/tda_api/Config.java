
import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;

public class Config {

	static File getConfigFile()
	{
	
		return new File("c:\\work\\RTSQ\\RTSQ.xml");
		
//		if(Globals.isLinux()){
//			return new File(Globals.currentDir(),"RTSQ.xml");
//		}else{
//		    return new File("c:\\work\\RTSQ\\RTSQ.xml");
//		}
//		
	}
	
	public final Symbols syms;
	public int starttime;
	public int endtime;
	

	public final int maxsymbols;
	public final int maxquotes;
	public final int timebetweenquotes;
	
	private static Config config;
	
	public static Config readConfig()
	{
		
	if(config==null){
		config=new Config();
	}
		return config;
	}
	
	
	public String AMTDUserName;
	public String AMTDPassword;
	public String AMTDAccountNumber;
	public String AMTDsourceID;
	
	private Config()
	{
		File file=getConfigFile();
		System.out.println("reading logfile "+file);
		XMLNode root=new XMLNodeBuilder(file).getRoot();
		syms=new Symbols(root.getChildwithNameNonNull("symbols"));
		
		maxquotes=Integer.parseInt(root.getChildwithNameNonNull("maxquotes").getValue());
		timebetweenquotes=Integer.parseInt(root.getChildwithNameNonNull("timebetweenquotes").getValue());
		maxsymbols=Integer.parseInt(root.getChildwithNameNonNull("maxsymbols").getValue());
			
		AMTDUserName=root.getChildwithNameNonNull("AMTDUserName").getValue();
		AMTDPassword=root.getChildwithNameNonNull("AMTDPassword").getValue();
		AMTDAccountNumber=root.getChildwithNameNonNull("AMTDAccountNumber").getValue();
		AMTDsourceID=root.getChildwithNameNonNull("AMTDsourceID").getValue();
		
		
		
		
		starttime=Integer.parseInt(root.getChildwithNameNonNull("starttime").getValue());
		endtime=Integer.parseInt(root.getChildwithNameNonNull("endtime").getValue());
	    this.ENVlinux=new ENV(root.getChildwithNameNonNull("ENVlinux"));
		this.ENVwindows=new ENV(root.getChildwithNameNonNull("ENVwindows"));
		
	}
	
	
	final ENV ENVwindows;
	final ENV ENVlinux;
	
	
	public static class ENV
	{
	public final String logfile;
	final String mysqlpassword;
	
	ENV(XMLNode node)
	{
	this.logfile=node.getChildwithNameNonNull("logfile").getValue();
	this.mysqlpassword=node.getChildwithNameNonNull("mysqlpassword").getValue();
	}
	
	}
		
	public static class Symbols
	{
		public final String[]symbols;
			
		
		Symbols(XMLNode node)
		{
			
		XMLNode[]symbols=node.getChildrenwithName("symbol");
		 ArrayList al=new ArrayList();
			for(int i=0;i<symbols.length;i++)
			{
				String sym=symbols[i].getValue();
				if(al.contains(sym)){
				throw new RuntimeException("already have "+sym);
				}
					al.add(sym);	
				
			}//for
		this.symbols=(String[])al.toArray(new String[]{}); 
		
			
		}
		
	}
	
	
	
	public  boolean isMarketOpen()
	{
	Calendar c=Calendar.getInstance();	
		int day=c.get(Calendar.DAY_OF_WEEK);
		int hour=c.get(Calendar.HOUR_OF_DAY);
		
	//	System.out.println("day "+day);
	//	System.out.println("hour "+hour);
	
return  day >= 2 && day <= 6  &&
	    hour >=this.starttime && hour <=this.endtime    
		;
		
	}

	
	
	
}
