

import java.awt.Toolkit;
import java.awt.Window;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectOutputStream;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.lang.reflect.Field;
import java.net.InetAddress;
import java.net.URL;
import java.net.URLClassLoader;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Properties;
import java.util.Stack;
import java.util.StringTokenizer;
import java.util.zip.Adler32;
import java.util.zip.CheckedInputStream;

import javax.swing.JFrame;
import javax.swing.JOptionPane;

 
 






/**
 * Title:
 * Description:
 * Copyright:    Copyright (c) 2002
 * Company:
 * @author
 * @version 1.0
 */






public class StringHelper {

	
public static void main(String[]args)
{

String str="HELLO1\nHELLO2\nHELLO3";
System.out.println(StringHelper.getFirstNLines(str,3));
}
	
public static String  removeSpaces(String str)
{
	StringBuffer sb=new StringBuffer();
	for(int i=0;i<str.length();i++){
		char c=str.charAt(i);
		if(Character.isWhitespace(c)==false){
			sb.append(c);
		}
		
	}
return sb.toString();
	
	
}
	public static void showDelete(File file)
	{
	boolean r=file.delete();
	if(r==false){
		System.err.println("Failed to delete "+file);
	}else{
		System.out.println("deleted "+file);
	}
		
		
	}
	
	public static boolean hasValue(String str)
	{
		return str!=null&&str.trim().length()!=0;
		
	}
	
	public static boolean isNumber(String str)
	{
		if(StringHelper.hasValue(str)==false){
			return false;
		}
		
		try{
		Integer.parseInt(str.trim());
		return true;
		}catch(Exception e){
			e.printStackTrace();
		}
	
		return false;
	}
	
	
	/**
	 * Checks that String is OK
	 * Or throws Runtime Exception
	 * @param str
	 */
	public static void assertOK(String str)
	{
		
		if(str.equals("OK")==false){
			throw new RuntimeException(str);
		}
		
	}
	
	
	public static String getFirstMessage(Throwable ex)
	{
	Throwable e=ex;
	
	while(e.getCause()!=null){
	e=e.getCause();	
	}
	return e.getMessage();
	}

		 

	static String truncate(String message,String searchstring)
	{
if(message==null){
	return "";
}
		
 int i=message.indexOf(searchstring);
		if(i>=0){
	
	return message.substring(0,i); 
     
	}else{
		return message;
     }
		
	}
	

	
	
	
	public static void ShowInformationMessage(Window window,String message)
	{
	JOptionPane.showMessageDialog(window ,message,"",JOptionPane.INFORMATION_MESSAGE , null );
	}

	
	public static void ShowInformationMessage(String message)
	{
	JOptionPane.showMessageDialog(null,message,"",JOptionPane.INFORMATION_MESSAGE , null );
	}

	

	public static String formatDateasYYYY_MM_DD(Timestamp date)
	{
	if(date==null){
	return null;
	}else{
	  return new SimpleDateFormat("yyyy-MM-dd").format(date);
	}
	}

	
public static HashSet fileNamesinDirectoryasHashSet(File dir)
{
	
if(dir.isDirectory()==false){
 throw new RuntimeException("not a directory "+dir);		
}
	
File[] files=dir.listFiles();
HashSet hs=new HashSet();

for(int i=0;i<files.length;i++){
	hs.add(files[i].getName());
}
	
return hs;	
}

	public static URL whereAmILoadingCLassFrom(Class mc)
		{
	
		//	ClassLoader classloader= Thread.currentThread().getContextClassLoader(); 
		String classname=mc.getName().replace('.', '/').concat(".class"); 
		URL url=ClassLoader.getSystemResource(classname);
		System.out.println("url "+url);
		return url;
		}
		
		
public static String getShortClassName(Class rclass)
{
String name=rclass.getName();
int i=Math.max(name.lastIndexOf("."),name.lastIndexOf("$"));

if(i>0){
return name.substring(i+1);		
}else{
 return name;
}
	
}

public static void assertnonNull(Object obj)
{
	
	if(obj==null){
 throw new RuntimeException("null value");		
	}
}

public static void assertnonNull(Object obj,String errormessage)
{
	
	if(obj==null){
 throw new RuntimeException(errormessage);		
	}
}


public static void asserthasValue(String str)
{
	if(str==null){
throw new RuntimeException("null value");		
}
	if(str.trim().length()==0){
 throw new RuntimeException("no value");		
	}
}



public static void asserthasValue(String str,String errormessage)
{
	if(str==null){
throw new RuntimeException(errormessage);		
}
	if(str.trim().length()==0){
 throw new RuntimeException(errormessage);		
	}
}



public static void assertPositive(long l)
{
	if(l<=0){
 throw new RuntimeException("value is not positive "+l);		
	}
}


public static void assertCanRead(File file)
{
	
	if(file.canRead()==false){
 throw new RuntimeException("Cant read "+file);		
	}
}

public static void assertisDirectory(File dir)
{
	if(dir.isDirectory()==false){
 throw new RuntimeException("Not a directory "+dir);		
	}
}



public static void assertEqual(String str1,String str2)
{
if(str1.equals(str2)==false){
 throw new RuntimeException(str1+"!="+str2);	
}
	
}





public static void assertTrue(boolean b)
{
	
	if(b==false){
 throw new RuntimeException("Not true");		
	}
}



/**
 * Prints the current Line, From the Stack trace,
 * so we can tab to it in eclipse.
 *
 */

	public static void printCurrentLineInfo()
		{
		try{throw new RuntimeException();}
		catch(Exception e){
				System.out.println("\t " + e.getStackTrace()[1]);
	}

		}


/**
 * Returns Hostname of the localhost
 * @return  Hostname of local host
 */


public static String printClassPath()
{
	
StringBuffer sb=new StringBuffer();	
String classpath=System.getProperty("java.class.path");
StringTokenizer st=new StringTokenizer(classpath,";");
while(st.hasMoreTokens())
{
String tkn=st.nextToken();
File file=new File(tkn);
System.out.println(file+" "+file.length()+" "+file.exists());	
sb.append(file+"\n");	
}//while

return sb.toString();
	
}


public static  void listClassPath()
{
	String classpath=System.getProperty("java.class.path");
	System.out.println("ClassPath");
	StringTokenizer st=new StringTokenizer(classpath,":");
	while(st.hasMoreTokens())
	{
	File file=new File((String)st.nextToken());
	System.out.println(file+"   "+file.exists());	
	}

    
	}

	


public static void listSystemProperties()
{
	
	Properties props=System.getProperties();
	Enumeration enums=props.keys();
	while(enums.hasMoreElements()){
	String key=(String)enums.nextElement();
	System.out.println(key+"  -> "+System.getProperty(key));
		
	}
}

  public final static  char LINEFEED=(char)10;
	public final static  char CR=(char)13;

/**
 * Convert String to Hex
 * @param str  String to convert
 * @return  Hex representation of String
 */


	public static String StringtoHex2(String str)
{

StringBuffer sb=new StringBuffer();
		for(int i=0;i<str.length();i++){	
		String hex=Integer.toHexString(str.charAt(i));
		if(hex.length()==1){hex="0"+hex;}
		sb.append(str.charAt(i)+"  "+hex+"\n");
		}//for
			
  return sb.toString();	
}




/**
 * NewLine property
 */

public final static String NEWLINE="\r\n";













/**
 * If null, return ""
 * 
 * @param str  String 
 * @return  Value of String or "" if null
 */

public static String nonNull(Object str)
{
  if(str!=null){
    return str.toString();  
  }else{
    return "";  
  }
    
}


/**
 * Copies String to clipboard
 * @param str  String to copy to clipboard
 */

public static void copyToClipBoard(String str)
{
Clipboard clipboard=Toolkit.getDefaultToolkit().getSystemClipboard(); 
StringSelection selection=new StringSelection(str);
clipboard.setContents(selection,null);
}


/**
 * 
 * @param markers Set of character markers to search for in String
 * @param arg  Argument to search in
 * @param searchpos  Sarch position.
 * @return  Index of next marker, or -1 if cant find.
 */

public static int nextPositionOf(char[] markers,String arg,int searchpos)
{
int p;
int min=arg.length()+10 ;	
for(int i=0;i<	markers.length;i++){ 
p=arg.indexOf(markers[i],searchpos);
if(p>=0){min=Math.min(p,min);}	
}

if(min<arg.length()+10){return min;}
else{return -1;}
}






/**
 * Replaces all  CRLF with LF
 * @param String to replace
 * @return  String with all CRLF replaced with LF
 */

public static String replaceCRLF(String str)
{
return StringHelper.replaceAll(str,"\r\n","\n");	
}








/**
 * pdf View file
 * @param file  File to view in pdf acrobat
 */

/**
 * View File in HTML Viewer
 * @param file  File to view
 */

public static  void viewFileinHtmlViewer(File file)
{
	File viewer=new File("C:\\Program Files\\Internet Explorer\\iexplore.exe");
	viewFile(file,viewer);
}






public static  void viewLinkinHtmlViewer(String link)
{
	File viewer=new File("C:\\Program Files\\Internet Explorer\\iexplore.exe");
	
	try{
		String cmdstr=quoteMe(viewer.toString())+quoteMe(link);
		System.out.println("cmdstr "+cmdstr);
		Runtime.getRuntime().exec(cmdstr);
		}catch(Exception ee){ee.printStackTrace();}
	
}




	






private static  void viewFile(File file,File viewer)
{
	
	
assertCanRead(file);

if(viewer.exists()==false){
throw new RuntimeException("cant read viewer");	
}



try{
String cmdstr=quoteMe(viewer.toString())+" "+quoteMe(file.toString());
System.out.println("cmdstr "+cmdstr);
Runtime.getRuntime().exec(cmdstr);
}catch(Exception ee){ee.printStackTrace();}

}





/////////

private static  String key="vx7sfshfhsfhskhfkshfhhfashfshfkshafiouwofuwoufowfwefjwfjwljeflwjfjwofjiwojfjfjajfoajfawjfojfojojfowjfoweaj723o;v4;o3275o;x3o;57o;2358xo;58o;3785;o3v84;5ov";
private static byte []keyb=key.getBytes();

/**
 * Encrypts a String 
 * (Used for storing / saving passwords)

 * @param s  String to Encrypt
 * @return   Encrypted version of String
 */


public static String encrypt(String s)
{
byte []b=s.getBytes();
String out="";
for(int i=0;i<b.length;i++){
  out=out+""+(int)(keyb[i%key.length()]^b[i]);
  if(i<b.length-1){out=out+",";}
}//for
return out;
}

/**
 * Decrypt a String
 * (Used for storing / saving passwords)
 * 
 * @param s  String to decrypt
 * @return Decrypted version of String
 */

public static String decrypt(String s)
{
try{
String []sl=StringHelper.StringTokenizer(s,",");
byte []b=new byte[sl.length];
for(int i=0;i<sl.length;i++){
  String tb=sl[i];
// System.out.println("tb  "+tb);
 byte t=(byte)Integer.parseInt(tb);
  b[i]=(byte)(keyb[i%key.length()]^t);
//	System.out.println("b[i]  "+b[i]);
 }//for
  return new String(b);

}catch(Exception e){return "";}
}




/**
 * Copies a File
 * (Reads all bytes  from first file, and
 * writes all bytes to second File)
 * 
 * 
 * @param source   Source File to copy
 * @param dest      Destination file to copy to.
 */

public static void copyFile(File source,File dest) throws IOException
{
	System.out.println(">>Copy "+source+"  "+dest);
        if(dest.isDirectory()){
        	throw new RuntimeException("dest file "+dest+"\n is directory");
        }

	if(dest.getParentFile().isDirectory()==false){
	throw new RuntimeException("parent not a directory \n"+dest.getParent());
		}
		
if(source.canRead()==false){
	throw new RuntimeException("Cant read "+source);		
}

FileInputStream is=null;
FileOutputStream os=null;
	

	try{
is=new 	FileInputStream(source);
os=new 	FileOutputStream(dest);

byte buffer[] = new byte[1000];
int len;
while( (len = is.read(buffer)) != -1 ) {
os.write(buffer,0,len);
}

}finally{
if(os!=null){os.close();}
if(is!=null){is.close();} 
}
	
}




 













public static  void viewStringinNotepad(String str) 
{
	viewStringinNotepad(new File("c:\\t.txt"),str);
}
public static  void viewStringinNotepad(File logfile,String str) 
{
	try {
		printString(str,logfile);
		viewFileinNotepad(logfile);	
	} catch (IOException e) {
		e.printStackTrace();
	} 
}

public static  void viewStringinHTMLViewer(String str) 
{
	File file=new File("c:\\temp\\"+System.currentTimeMillis()+".html");
	try {
		printString(str,file);
		StringHelper.viewFileinHtmlViewer(file);
	} catch (IOException e) {
		e.printStackTrace();
	} 
}
 

public static  void viewFileinNotepad(File file) throws IOException
{
	StringHelper.assertCanRead(file);

String cmdstr="notepad \""+file.toString()+"\"";

Runtime.getRuntime().exec(cmdstr);

}


public static  void viewinExplorer(File dir) throws IOException
{
	StringHelper.assertisDirectory(dir);

String cmdstr="explorer "+StringHelper.quoteMe(dir.toString());

Runtime.getRuntime().exec(cmdstr);

}



/**
 * View String in notepad
 * Writes String to a temporary file, then view
 * 
 * @param content  String to view
 */




/**
 * Chops certain number of characters off the end
 * of a String
 * @param str  String to Chop
 * @param choplength  length of characters to remove from end of String
 * @return  substring of original String
 */

public static  String chop(String str,int choplength)
{
return str.substring(0,str.length()-choplength);
}




/**
 * 
 * Print the current Stack trace as a String
 * @return  Contents of Stack as String
 */

public static void printStack()
{
StringWriter sw=new StringWriter();	
PrintWriter pw=new PrintWriter(sw);
try{throw new RuntimeException();}
catch(Exception e){e.printStackTrace(pw);}

pw.flush();
String stack= sw.toString();  
System.out.println(stack);
}






/**
 * Converts an Exception to String
 * @param e  Exception to convert to String
 * @return  String representation of Exception
 */



public static String exceptiontoString(Throwable e)
{
return exceptiontoString(e,"\n");
}




public static String exceptiontoString(Throwable e,String NL)
{
	StringBuffer sb=new StringBuffer();

if(e.getCause()!=null){
	sb.append(exceptiontoString(e.getCause()));
}

sb.append("Message:"+e.getMessage()+NL);
sb.append("Cause:"+e.getCause()+NL);
sb.append(NL+e.getClass().getName());
StackTraceElement[] stack=e.getStackTrace();
for(int i=0;i<stack.length;i++){
	StackTraceElement st=stack[i];
sb.append(NL+st+" ");	
	
}

return sb.toString();
}




public static String getHostName()
{
	
	try{
		return	InetAddress.getLocalHost().getHostName();
		}catch(Exception e){
		return "ERROR"+e.getMessage();	
		}	
}

/**
 * Return the current date
 * (Formatted as "MM-dd-yyyy")
 * 
 * @return  Current date
 */

 public static String  getTime()
  {

   return new SimpleDateFormat("MMM-dd-yyyy hh:mm:ss").format(StringHelper.NOW());

	 }



/**
 * Repeats a String certain number of times
 * @param n  Number of times to repeat String 
 * @param repeat  String to repeat
 * @return  String repeated certain number of times
 */


public static String repeatString(int n,String repeat)
{StringBuffer sb=new StringBuffer();
  for(int i=0;i<n;i++){
	sb.append(repeat);
  }
return sb.toString();
}//getSpaces







/**
 * Tokenizers Strings, and Trims all Strings in result
 * @param st String to Trim
 * @param token  Token
 * @return  Array of Strings,  which have white space removed
 */
public  static String[] StringTrimTokenizer(String st,String token)
{
String[]sa=StringTokenizer(st,token);
	
for(int i=0;i<sa.length;i++){ 	
sa[i]=sa[i].trim(); 
}
return sa;
}


public static java.sql.Timestamp NOW()
{
	return new java.sql.Timestamp(Calendar.getInstance().getTime().getTime());
}


/**
 * Quotation mark
 */

public static String quote="\"";

/**
 * Removes quotes from String 
 * @param str  String to remove quotes from 
 * @return  String without quotes
 */

public static String trimQuotes(String str)
{
str=str.trim();
if(str.startsWith(quote)){str=str.substring(1);}
if(str.endsWith(quote)){str=str.substring(0,str.length()-1);}

return str; 	
}



/**
 * Tokenizer for Strings
 * @param st  String  to tokenizer
 * @param token  Token for String
 * @return  Array 
 */

public  static String[] StringTokenizer(String st,String token)
{
if(st==null){throw new RuntimeException(" null st");}
if(token==null){throw new RuntimeException(" null token");}
	
int pos=0;
int count=0;
for(;;){
int i=st.indexOf(token,pos);
if(i<0){count++;break;}
count++;
pos=i+token.length();	
}

String []sl=new String[count];

pos=0;
count=0;
for(;;){
int i=st.indexOf(token,pos);
if(i<0){
	sl[count]=st.substring(pos);break;}
sl[count]=st.substring(pos,i);	
pos=i+token.length();	
count++;
}




return sl;
}






/**
 * Returns an Arraylist as a String
 * (seperated by NewLine)
 * @param alist  ArrayList to convert to String
 * @return  String represenation of List
 */

public static byte[] filetoByteArray(File file) throws IOException
{

	StringHelper.assertCanRead(file);

	
	
	ByteArrayOutputStream bout=new ByteArrayOutputStream();
    FileInputStream fi=null;
	try{
	fi=new FileInputStream(file);
	
	byte buffer[] = new byte[1024];
	int len;
	while( (len = fi.read(buffer)) != -1 ) {
	bout.write(buffer,0,len);
	}

	bout.close();
	fi.close();
	return bout.toByteArray();
	}finally{
		if(fi!=null){fi.close();}
	}
	
	}


public static long getChecksum(File file) throws IOException
{
	CheckedInputStream cis=null;
	try {
        // Compute Adler-32 checksum
        cis = new CheckedInputStream(
            new FileInputStream(file), new Adler32());
        byte[] tempBuf = new byte[1024];
        while (cis.read(tempBuf) >= 0) {
        }
     return  cis.getChecksum().getValue();
    }finally{
		if(cis!=null){cis.close();}
    }
}


public static long getChecksum(byte[] ba) throws IOException
{
	CheckedInputStream cis=null;
	try {
        // Compute Adler-32 checksum
        cis = new CheckedInputStream(
            new ByteArrayInputStream(ba), new Adler32());
        byte[] tempBuf = new byte[1024];
        while (cis.read(tempBuf) >= 0) {
        }
     return  cis.getChecksum().getValue();
    }finally{
		if(cis!=null){cis.close();}
    }
}

public static int rint()
{
	
	return (int)(Math.random()*10000);
	
}

public static String quoteMe(String str)
{
	return "\""+str+"\"";
}



public static void printBytes(byte[] bytes,File file) throws IOException
{
	FileOutputStream fo=null;
	try{
	fo=new FileOutputStream(file);
	fo.write(bytes);
	}finally{
	if(fo!=null){fo.close();}
	}
	
}


public static String pluralString(String str,int count)
{
	if(count==1){
		return str;    //found 1 tes
	}else{
		return str+"s";  //found 0 tess, found 2 tess
	}
}


public static boolean getBooleanVal(String str)
{
if(str.equals("true")){return true;}
else if(str.equals("false")){return false;}
else{
	throw new RuntimeException("not a boolean val");
}
	
	
}


public static String NLtoBR(String str)
{
	return StringHelper.replaceAll(str.trim(),"\n","\n<br>");
}

public static String ArrayListtoString(ArrayList alist)
{
return ArrayListtoString(alist,NEWLINE);
}//ArrayListtoString


/**
 * Prints text as HTML, in Red
 * @param text
 * @return HTML with text in Red
 */
public static String printinRed(String text) {
	return "<font color=\"#FF0000\">"+text+"</font>";
}



public static String SQLQuote(Object str)
{
	if(str instanceof Long||str instanceof Integer ||str instanceof Boolean){
		return ""+str;
	}
	
	
	
	if(str==null){
		return "NULL";
	}else{
		return quoteMe(str.toString().trim().replace('"',' '));
	}
}

/**
 * Converts an ArrayList to a String
 * Each entry is seperated by seperator
 * 
 * @param alist  ArrayList to convert to String
 * @param seperator  Seperator for list
 * @return  String represenation of list.
 */

public static String ArrayListtoString(ArrayList alist,String seperator)
{
StringBuffer sb=new StringBuffer();
for(int i=0;i<alist.size();i++){ 
sb.append(alist.get(i).toString());
  if(i<alist.size()-1){sb.append(seperator);}
}//for

return sb.toString();
}//ArrayListtoString


/**
 * Converts an Array to String
 * Each entry seperated by NEWLINE
 * @param obj  object to convert
 * @return String represenation of Object Array,
 */

public static String ArraytoString(Object[] obj)
{
return ArraytoString(obj,NEWLINE);
}

/**
 * 
 * Converts an Array to String
 * 
 * @param obj  Array to convert to String
 * @param seperator  Seperator 
 * @return  String representation of array.
 */

public static String ArraytoString(Object[] obj,String seperator)
{
  StringBuffer sb=new StringBuffer();
for(int i=0;i<obj.length;i++){
sb.append(obj[i].toString());
if(i<obj.length-1){sb.append(seperator);}
}
return sb.toString();
}//ArrayListtoString


/**
 * View String as Hex
 * @param str  String to convert
 * @return  Hex representation of String
 */

public static String StringtoHex(String str)
{
StringBuffer sb=new StringBuffer();
for(int i=0;i<str.length();i++){	
String hex=Integer.toHexString(str.charAt(i));
if(hex.length()==1){hex="0"+hex;}
sb.append(hex);
}//for
return sb.toString();
}





/**
 * Convert a String to ArrayList
 * Each line in the String is Read, and becomes
 * and the line is added to the ArrayList
 * 
 * @param str  String to convert
 * @return  ArrayList representation of String
 * @throws IOException 
 */


public static ArrayList StringtoArrayList(String str) 
{
	try{
  ArrayList alist=new ArrayList();
 BufferedReader bf=new BufferedReader(new StringReader(str));


String line;
while((line=bf.readLine())!=null){
alist.add(line);
}
return alist;

	}catch(Exception e){
		throw new RuntimeException(e);
	}

}



/**
 * 
 * @param source
 * @param file
 * @throws IOException 
 * @throws IOException
 */


public static void saveBytes(byte[] bytes,File file) throws IOException
{
	FileOutputStream fo=null;
	try{
	fo=new FileOutputStream(file);
	fo.write(bytes);
	}finally{
		if(fo!=null){fo.close();}
	}
}

 public static void  PrintStringBytes(String source,File file) throws IOException
 {
 
 if(file==null){
 throw new RuntimeException("null File");		
 }

ByteArrayInputStream is=new  ByteArrayInputStream(source.getBytes());
FileOutputStream os=new 	FileOutputStream(file);

byte buffer[] = new byte[1024];
int len;
while( (len = is.read(buffer)) != -1 ) {
os.write(buffer,0,len);
}
os.flush();
os.close();


 }


/**
 * @param source
 * @param file
 * @throws IOException
 */

 public static void  printString(String source,File file) throws IOException
 {
	System.out.println("Saving to "+file);
 //try{
StringReader sw=new StringReader(source);
BufferedReader bf=new BufferedReader(sw);
PrintWriter pw=new PrintWriter(new FileWriter(file));
String t;
while((t=bf.readLine())!=null){
  pw.println(t);
}//while
pw.flush();
pw.close();
// }catch(IOException ee) {StringHelper.viewException(ee); }
 }//PrintString



 

/**
 * Converts a Long to a String
 * 1234567 will be
 * 1,234,567
 * 
 * @param l long to convert
 * @return  String representation on long.
 */
 
  
 public static String doubletoString(double d)
 {
	 
	 long l=(long)Math.floor(d);
	 int p2=(int)(Math.rint((d-l)*100));
	 
	 
return 	  longtoString(l)+"."+p2;
	 
 }
 
public static String longtoString(long l)
{
	String str=""+l;
	
	Stack s=new Stack();
int cc=0;
	for(int i=str.length()-1;i>=0;i--){
	
	if(cc>0&&cc%3==0){
		s.add(",");
	}
	s.add(""+str.charAt(i));	
	cc++;

	}
	StringBuffer sb=new StringBuffer();
	
while(s.isEmpty()==false){
sb.append(s.pop());	
}
	
	
	return sb.toString();
	
}



/**
 * Formats an integer as String
 * for example,  
 *  Returns First N lines of a String
 * 
 * @param n  length of field for Integer
 * @return  String representation of Integer
 */




public static String getFirstNLines(String str,int n)
{
	try{
	StringBuffer sb=new StringBuffer();
	int count=0;
	String line=null;
	StringReader sr=new StringReader(str);
	BufferedReader br=new BufferedReader(sr);
	while((line=br.readLine())!=null){
		if(count>=n){
			break;
		}
		
		sb.append(line+"\n");
		count++;
	}
	
	return sb.toString();
	
	}catch(IOException e){
		throw new RuntimeException(e);
	}
	
}


/**
 * Set Max Length of String
 * Handles null values.
 * @param orig  Original String
 * @param maxlength  maxlength of String
 * @return  String truncated to length
 */

 public static String  setMaxLengthEvenifNull(String orig,int maxlength)
{
	 if(orig==null){
		 return null;
	 }
maxlength=Math.min(orig.length(),maxlength);
return orig.substring(0,maxlength);
}

 /**
  * Sets a String to be a specifie length
  * 
  * @param orig  original String 
  * @param length  Required length of String
  * @param fill  Character to fill, if need to increase length of String
  * @return
  */
 

public static String  setLength(String orig,int length,char fill)
{
	
	orig=setMaxLengthEvenifNull(orig,length);
	orig=setMinLength(orig,length,fill);
	
	return orig;
}

/**
 * Sets min length of String
 * @param orig  String to set length for
 * @param minlength  minlength of String
 * @param fill  Character to fill with
 * @return  new String, truncated to certain length
 */

 public static String  setMinLength(String orig,int minlength,char fill)
{

while(orig.length()<minlength)
{ 
orig=orig+fill;	
} 
return orig;
}



/**
 * Extracts a file to String
 * If the file exists, Extract file as String
 * Otherwise try to extract resource with same name as File. 
 * 
 * 
 * @param File (or resource) to extract for
 * @return  Contents of file (or resource) as String
 * @throws IOException
 */



/** Extracts a file to String
* If the file exists, Extract file as String
* 
* 
* @param File to extract
* @return  Contents of fileas String
* @throws IOException
*/


 public static String  getFileasString(File file) throws IOException 
{
	
	if(file.canRead()==false){
throw new RuntimeException("Cant read "+file);		
	}
	
	StringBuffer sb=new StringBuffer();
	FileInputStream fi=null;
try{

  fi=new FileInputStream(file);

byte buffer[] = new byte[1024];
int len;
while((len = fi.read(buffer)) != -1 ) {
    
	sb.append(new String(buffer,0,len));
}


}finally{
	if(fi!=null){fi.close();}
}

return sb.toString();
}

 public static byte[]  getFileasByteArray(File file) throws IOException 
 {
 	
 	if(file.canRead()==false){
 throw new RuntimeException("Cant read "+file);		
 	}
 	ByteArrayOutputStream ba=new ByteArrayOutputStream();
 	FileInputStream fi=null;
 try{

   fi=new FileInputStream(file);

 byte buffer[] = new byte[1024];
 int len;
 while((len = fi.read(buffer)) != -1 ) {
 ba.write(buffer,0,len);
 }


 }finally{
 	if(fi!=null){fi.close();}
 }
 ba.close();
 return ba.toByteArray(); 
 }

 
 
 
 /**
 * Converts a file to a StringBuffer
 * @param file  File to read
 * @return  Contents of file as a StringBuffer
 * @throws IOException
 */


 public static StringBuffer  getFileasStringBuffer(File file) throws IOException
{
StringHelper.assertCanRead(file);
		
FileReader fr=new FileReader(file);
BufferedReader br=new BufferedReader(fr);
StringBuffer sb=new StringBuffer();

char buffer[] = new char[1024];
int len;
while( (len = br.read(buffer)) != -1 ) {
sb.append(buffer,0,len);
}

fr.close();

return sb; 


}

/**
 * Extracts a resource as a String
 * @param resource  Resource to extract
 * @param outfile  Output File to extract to.
 * @throws IOException
 */





/**
 * Dumps inputSream to disk.
 * @param fi  InputStream to dump
 * @param outfile  OutputFile.
 * @throws IOException
 */

public static void inputStreamtoFile(InputStream fi,File outfile) throws IOException
{
FileOutputStream fo=new FileOutputStream(outfile);
byte buffer[] = new byte[1000];
int len;
while( (len = fi.read(buffer)) != -1 ) {
fo.write(buffer,0,len);
}
fo.close();
fi.close();
}

/**
 * 
 * @param fi  InputStream to dump
 * @return  InputStream as String
 * @throws IOException
 */

public static String inputStreamtoString(InputStream fi) throws IOException
{

ByteArrayOutputStream bout=new ByteArrayOutputStream();

byte buffer[] = new byte[1000];
int len;
while( (len = fi.read(buffer)) != -1 ) {
bout.write(buffer,0,len);
}

bout.close();
fi.close();
return bout.toString();
}

public static byte[] inputStreamtoByteArray(InputStream fi) throws IOException
{

ByteArrayOutputStream bout=new ByteArrayOutputStream();

byte buffer[] = new byte[1000];
int len;
while( (len = fi.read(buffer)) != -1 ) {
bout.write(buffer,0,len);
}

bout.close();
fi.close();
return bout.toByteArray();
}



/**
 * Dumps an InputStream to file.
 * @param file  File to save as input Stream.
 * @param fi  Inputstream to dump.
 */




///////////////////////////////////////////
///////////////////////////////////////////
///////////////////////////////////////////












/**
 * Replace all occurences in old String with new String
 * @param orig   String to search through
 * @param oldval  Old String to Search
 * @param newval new String to search for
 * @return  String with all occurences of oldval replaced with newvalue
 */

 public static String  replaceAll(String orig,String oldval,String newval) 
{
if(oldval.equals("")){throw new RuntimeException("Invalid old value, length is zero ");}
if(orig.indexOf(oldval)<0){return orig;}


StringBuffer origSB=new StringBuffer(orig);

int start=0;

for(;;)
{  start=origSB.indexOf(oldval,start);
//System.out.println(">start "+start);
//start=origSB.indexOf(oldval,start);



if (start<0){return origSB.toString() ;}
origSB.replace(start,start+oldval.length(),newval);
start=start+newval.length();

}



}






/**
 * Replace first occurence in String
 * @param orig  original String to use
 * @param oldval  Value to search for
 * @param newval value to replace with
 * @return  String with first occurence of oldval replaced with newval
 */

 public static String  replaceFirst(String orig,String oldval,String newval)
{
int index=orig.indexOf(oldval);
if (index>=0) {
return orig.substring(0,index)+newval+orig.substring(index+oldval.length());

}//if
return orig;
 }

public static String USPrice(String price) {
	if(price.trim().startsWith("$")){
		return price.trim();
	}else{
		return "$ "+price.trim();
	}
}

public static String captilizeFirstLetter(String str) {
	return Character.toUpperCase(str.charAt(0))+str.substring(1);
}

public static String capitalize(String str) {

	if(str.length()==0){
	return str;
}
	
	return Character.toUpperCase(str.charAt(0))+str.substring(1);
}

public static void viewFileinExcel(File tempfile) {

	throw new RuntimeException(tempfile + " TODO");
	
}


//May want to cache this!!!
//if we cache, then easy to update.
//Much faster.
public static int getFileCount(File attachmentDir) {
	if(attachmentDir.isDirectory()==false){
		return 0;
	}
	
File[]files=attachmentDir.listFiles();
if(files==null){
	return 0;
}
return files.length;

}

public static void printifHasValue(PrintWriter pw,String str)
{
	if(StringHelper.hasValue(str)){
		pw.println(str+"<br>");
	}
	
}

public static byte[] serialize(Object o) throws IOException {
	ByteArrayOutputStream ba=new ByteArrayOutputStream();
	ObjectOutputStream os=new ObjectOutputStream(ba);
	os.writeObject(o);
 ba.close();
 return ba.toByteArray();
}

public static void compareObjects(Object ob1,Object ob2) throws IllegalArgumentException, IllegalAccessException {
StringBuffer sb=new StringBuffer();
	Field[]fields=ob1.getClass().getFields();
	sb.append("<table>");

	for(int i=0;i<fields.length;i++){
sb.append("<tr>");
	
	String fieldname=fields[i].getName();
	Object v1=""+fields[i].get(ob1);
	Object v2=""+fields[i].get(ob2);
	String comp="";
	if(v1.equals(v2)==false){
	comp="DIFF";	
	}

	sb.append("<td>"+fieldname+"</td>");
	sb.append("<td>"+v1+"</td>");
	sb.append("<td>"+v2+"</td>");
	sb.append("<td>"+comp+"</td>");

	sb.append("</tr>");
}//for
	
	sb.append("</table>");
	StringHelper.viewStringinHTMLViewer(sb.toString());
	
}

 

	
}

 


/**
 * 
 */

//StringHelper







