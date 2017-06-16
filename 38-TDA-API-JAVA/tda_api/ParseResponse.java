

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.net.URLDecoder;
import java.util.Calendar;
import java.util.Date;
import java.util.zip.DataFormatException;
import java.util.zip.GZIPInputStream;
import java.util.zip.Inflater;

public class ParseResponse {

	class Slice
	{
		final byte[]b;
		final byte delimbyte;
		Slice(byte[]b,byte delimbyte)
		{
	   this.b=b;
	   this.delimbyte=delimbyte;
		}
		int bytesread;
		boolean hasMore()
		{
	//	System.out.println("hasMore bytesread"+bytesread);
	//	System.out.println("hasMore b.length"+b.length);
		
			return bytesread<b.length;
		}
		
	
		
		public byte[] getLineTill_End() throws IOException
		{
			ByteArrayOutputStream ba=new ByteArrayOutputStream();
			int i;
			for(i=bytesread;i<b.length;i++){
				bytesread++;
				if(b[i]==delimbyte){
					break;
					}
				ba.write(b[i]);
						
			}
				
			return ba.toByteArray();    
		}

	}
	
	
	public static byte[] uncompress(byte[]bytes) throws IOException
	{
		try{
		 Inflater decompresser = new Inflater();
		 decompresser.setInput(bytes, 0, bytes.length);
		 byte[] result = new byte[2024];
		 int resultLength = decompresser.inflate(result);
		 decompresser.end();
  
		 byte [] copy = new byte[resultLength];
		 //public static void arraycopy(Object src,
          //       int src_position,
           //      Object dst,
            //     int dst_position,
             //    int length)
		 
	      System.arraycopy( result, 0, copy, 0, resultLength);
return copy;
		// return new String(result, 0, resultLength, "UTF-8").getBytes();
	
		}catch(Exception e){
			throw new RuntimeException(e);
		}
		}


	
	public class 	NEWS
	{
		
	public String Modifier;
	public String Source;
	public String Headline;
	public String NewsURL;
	public String VendorID;
	public String Count;
	public String[] KeywordsTK;
    public java.sql.Timestamp Timestamp;
		
		void log(String str)
		{
			System.out.println("NEWS>"+str);
		}
		
public String symbol;
		NEWS() throws IOException
		{
		System.out.println(">>NEWS ");	
			
			byte SymbolFieldID=readByte();
symbol=readString();
log("symbol "+symbol);
byte TimestampFieldID=readByte();
String TimestampString=readString();
log("TimestampString "+TimestampString);
Timestamp= new java.sql.Timestamp(Long.parseLong(TimestampString));
System.out.println("Timestamp "+Timestamp);
	readConstant(0x02);
	short DataLength=readShort();

byte[] CompressedData =readBytes(DataLength);
//System.out.println("CompressedData.length "+CompressedData.length);
Slice slice=new Slice(uncompress(CompressedData),(byte)0x02);


Modifier=new String(slice.getLineTill_End());
Source=new String(slice.getLineTill_End());
Headline=URLDecoder.decode(new String(slice.getLineTill_End()),"UTF-8");
NewsURL=URLDecoder.decode(new String(slice.getLineTill_End()),"UTF-8");
VendorID=new String(slice.getLineTill_End());
Count=new String(slice.getLineTill_End());
byte[]Keywords=slice.getLineTill_End();
System.out.println("Keywords "+new String(Keywords));
//Slice slice2=new Slice(Keywords,(byte)0x03);
//while(slice2.hasMore()){
//	System.out.println(">>>>>>>>>>>>>>>>>>>>>>KK "+new String(slice2.getLineTill_End()));
//}

System.out.println("Modifier "+Modifier);
System.out.println("Source "+Source);
System.out.println("Headline "+Headline);
System.out.println("NewsURL "+NewsURL);
System.out.println("VendorID "+VendorID);
//System.out.println("Count "+Count);




readDelimeter();

//System.out.println("datalength "+datalength);
//System.out.println("str "+str);


	
		//	String modifier=new String(getLineTill_0x02());
//log("modifier "+modifier);
//String source=new String(getLineTill_0x02());
//log("source "+source);


		}
		
		
		

			
	}
	
	
		
	final DataInputStream ds;
	
	public static void main(String[]args) throws IOException
	{
	File file=new File("c:\\temp\\news_syms");
	DataInputStream ds=new  DataInputStream(new FileInputStream(file));
	new ParseResponse(ds);
	
	}
	
	
	String byteasString(byte b)
	{
		 byte[]bytes=new byte[1];
		 bytes[0]=b;
		return new String(bytes);
	}
	
	ParseResponse(InputStream is) throws IOException
	{
		this.ds=new DataInputStream(is);
		parse();
		 System.out.println("done");
			
	}
	
	ParseResponse(DataInputStream ds) throws IOException
	{
	 this.ds=ds;
	 parse();
	 System.out.println("done");
	}
	void parse() throws IOException
	{
	 
	 for(;;){
		 byte HeaderID=-1;
		 try{
	 HeaderID=readByte();
		 }catch(java.io.EOFException e ){
			 System.out.println(">>>>DONE");
			 System.exit(0);
		 }
	// System.out.println(">>HeaderID "+HeaderID+" "+byteasString(HeaderID));
			
	 if(HeaderID=='H'){
		new HeartBeat();
		}else if(HeaderID=='N'){
		 new  SnapshotResponse();		
		}else if(HeaderID=='S'){
			new CommonStreamingResponse();
			
		}else{
			throw new RuntimeException(">>unknown "+HeaderID+" >>"+byteasString(HeaderID));
		}
		
	
	 }
	 
	// System.out.println("done");
	}
	

	class StreamerServerResponse
	{
		
		void log(String str)
		{
			System.out.println("StreamerServerResponse>"+str);
		}
	
		StreamerServerResponse() throws IOException
		{
//	short Nextstringlength=readShort();  //already read  from SnapShortResponse
// String string=readString(Nextstringlength);
//System.out.println("string "+string);
int MessageLength=readInt();
//log("MessageLength "+MessageLength);
short SID=readShort();
//log("SID "+SID);
byte Column1=readByte();
//log("Column1 "+Column1);
short ServiceID=readShort();
//log("ServiceID "+ServiceID);
byte Column2=readByte();
//log("Column2 "+Column2);
short Returncode=readShort();

//log("Returncode "+Returncode);
log("Lookup Returncode "+lookupReturnCode(Returncode));

byte Column3=readByte();
log("Column3 "+Column3);

short DescriptionLength=readShort();
log("DescriptionLength "+DescriptionLength);

String Description=readString(DescriptionLength);
log("Description "+Description);


readDelimeter();

		}

	String lookupReturnCode(short rc)
	{
	
	if(rc==0){return "SUCCESS";}
	else if(rc==1){return "SERVICE_DOWN";}
	else if(rc==2){return "SERVICE_TIMEOUT";}
	else if(rc==3){return "LOGIN_DENIED";}
	else if(rc==4){return "AUTHORIZER_BUSY";}
	else if(rc==5){return "AUTHORIZER_DOWN";}
	else if(rc==6){return "USER_NOT_FOUND";}
	else if(rc==7){return "ACCOUNT_ON_HOLD";}
	else if(rc==8){return "ACCOUNT_FROZEN";}
	else if(rc==9){return "UNKNOWN_FAILURE";}
	else if(rc==10){return "FAILURE";}
	else if(rc==11){return "SERVICE_NOT_AVAILABLE";}
	else if(rc==12){return "CLOSE_APPLET";}
	else if(rc==13){return "USER_STATUS";}
	else if(rc==14){return "ACCOUNT_EMPTY";}
	else if(rc==15){return "MONOPOLIZE_ACK";}
	else if(rc==16){return "NOT_AUTHORIZED_FOR_SERVICE";}
	else if(rc==17){return "NOT_AUTHORIZED_FOR_QUOTE";}
	else if(rc==18){return "STREAMER_SERVER_ID";}
	else{
		throw new RuntimeException("unknown RC "+rc);
	}
		 

		 

	}
	
	}
	
	void readConstant(int val) throws IOException
	{
		byte r1=ds.readByte();
		if(r1!=val){
			throw new RuntimeException("incorrect "+r1+" expected "+val);
		}
		
	}
	
	byte FF=(byte)0xFF;
	byte zeroA=(byte)0x0A;
	
	 void readDelimeter() throws IOException
	{
		 System.out.println("readDelimeter() ");
		 readConstant(FF);
		 readConstant(zeroA);
	}
	 
	 class CommonStreamingResponse
	 {
		
		 
		 void log(String str)
			{
				System.out.println("CommonStreamingResponse>"+str);
			}
		 
		 
		 CommonStreamingResponse() throws IOException
		 {
			short  Messagelength=readShort();
		//	log("Messagelength "+Messagelength);
			 short SID=readShort();
			// log("SID "+SID);
			 directTable14(SID);
				
	//		readTerm();	
		 }
		 
	 }
	 
	class SnapshotResponse
	{
		String Recipientfield;
        String Payload;
		
		void log(String str)
		{
			System.out.println("SnapshotResponse>"+str);
		}
		
		SnapshotResponse() throws IOException, NumberFormatException
		{
		short Nextstringlength=readShort();
		Recipientfield=readString(Nextstringlength);
		log("Recipientfield "+Recipientfield);
		//we look up 	Recipientfield from ServiceID table
		
		directTable14(Integer.parseInt(Recipientfield));
		
		
		//readServiceIDs();
		
		}
		
	}
	

class 	LevelIQuote
{
	void log(String str)
	{
		System.out.println("LevelIQuote>"+str);
	}
	
	
	LevelIQuote() throws IOException
	{
		
		byte Column1=readByte();
log("Column1 "+Column1);
short Symbollength=readShort();
log("Symbollength "+Symbollength);
String Symbol=readString(Symbollength);
log("Symbol "+Symbol);

for(;;){  //Repeating Data
byte rc=readByte();	
if(rc==FF){
	 readConstant(zeroA);
	 return;
}
	log(field(rc));

}

	}
	
	String SYMBOL;
	float BID;
	float ASK;
	float LAST;
	int BIDSIZE;
	int ASKSIZE;
	char BIDID;
	char ASKID;
	long VOLUME;
	int LASTSIZE;
	int TRADETIME;
	int QUOTETIME;
	float HIGH;
	float LOW;
	char TICK;
	float CLOSE;
	char EXCHANGE;
	boolean MARGINABLE;
	boolean SHORTABLE;
	float ISLANDBID;
	float ISLANDASK;
	long ISLANDVOLUME;
	int QUOTEDATE;
	int TRADEDATE;
	float VOLATILITY;
	String DESCRIPTION;
	char TRADE_ID;
	int DIGITS;
	float OPEN;
	float CHANGE;
	float WEEK_HIGH_52;
	float WEEK_LOW_52;
	float P_E_RATIO;
	float DIVIDEND_AMT;
	float DIVIDEND_YIELD;
	int ISLAND_BID_SIZE;
	int ISLAND_ASK_SIZE;
	float NAV;
	float FUND;
	String EXCHANGE_NAME;
	String DIVIDEND_DATE;

	
	String field(int rc) throws IOException
	{
		      if(rc==0){return "SYMBOL";}
		else if(rc==1){BID=readFloat();return "BID "+BID;}
		else if(rc==2){ASK=readFloat();return "ASK "+ASK;}
		else if(rc==3){LAST=readFloat();return "LAST "+LAST;}
		else if(rc==4){BIDSIZE=readInt();return "BIDSIZE "+BIDSIZE;}
		else if(rc==5){ASKSIZE=readInt();return "ASKSIZE "+ASKSIZE;}
		else if(rc==6){BIDID=readChar();return "BIDID "+BIDID;}
		else if(rc==7){ASKID=readChar();return "ASKID "+ASKID;}
		else if(rc==8){VOLUME=readLong();return "VOLUME "+VOLUME;}
		else if(rc==9){LASTSIZE=readInt();return "LASTSIZE "+LASTSIZE;}
		else if(rc==10){TRADETIME=readInt();return "TRADETIME "+TRADETIME;}
		else if(rc==11){QUOTETIME=readInt();return "QUOTETIME "+QUOTETIME;}
		else if(rc==12){HIGH=readFloat();return "HIGH "+HIGH;}
		else if(rc==13){LOW=readFloat();return "LOW "+LOW;}
		else if(rc==14){TICK=readChar();return "TICK "+TICK;}
		else if(rc==15){CLOSE=readFloat();return "CLOSE "+CLOSE;}
		else if(rc==16){EXCHANGE=readChar();return "EXCHANGE "+EXCHANGE;}
		else if(rc==17){MARGINABLE=readBoolean();return "MARGINABLE "+MARGINABLE;}
		else if(rc==18){SHORTABLE=readBoolean();return "SHORTABLE "+SHORTABLE;}
		else if(rc==19){ISLANDBID=readFloat();return "ISLANDBID "+ISLANDBID;}
		else if(rc==20){ISLANDASK=readFloat();return "ISLANDASK "+ISLANDASK;}
		else if(rc==21){ISLANDVOLUME=readLong();return "ISLANDVOLUME "+ISLANDVOLUME;}
		else if(rc==22){QUOTEDATE=readInt();return "QUOTEDATE "+QUOTEDATE;}
		else if(rc==23){TRADEDATE=readInt();return "TRADEDATE "+TRADEDATE;}
		else if(rc==24){VOLATILITY=readFloat();return "VOLATILITY "+VOLATILITY;}
		else if(rc==25){DESCRIPTION=readString();return "DESCRIPTION "+DESCRIPTION;}
		else if(rc==26){TRADE_ID=readChar();return "TRADE_ID "+TRADE_ID;}
		else if(rc==27){DIGITS=readInt();return "DIGITS "+DIGITS;}
		else if(rc==28){OPEN=readFloat();return "OPEN "+OPEN;}
		else if(rc==29){CHANGE=readFloat();return "CHANGE "+CHANGE;}
		else if(rc==30){WEEK_HIGH_52=readFloat();return "WEEK_HIGH_52 "+WEEK_HIGH_52;}
		else if(rc==31){WEEK_LOW_52=readFloat();return "WEEK_LOW_52 "+WEEK_LOW_52;}
		else if(rc==32){P_E_RATIO=readFloat();return "P_E_RATIO "+P_E_RATIO;}
		else if(rc==33){DIVIDEND_AMT=readFloat();return "DIVIDEND_AMT "+DIVIDEND_AMT;}
		else if(rc==34){DIVIDEND_YIELD=readFloat();return "DIVIDEND_YIELD "+DIVIDEND_YIELD;}
		else if(rc==35){ISLAND_BID_SIZE=readInt();return "ISLAND_BID_SIZE "+ISLAND_BID_SIZE;}
		else if(rc==36){ISLAND_ASK_SIZE=readInt();return "ISLAND_ASK_SIZE "+ISLAND_ASK_SIZE;}
		else if(rc==37){NAV=readFloat();return "NAV "+NAV;}
		else if(rc==38){FUND=readFloat();return "FUND "+FUND;}
		else if(rc==39){EXCHANGE_NAME=readString();return "EXCHANGE_NAME "+EXCHANGE_NAME;}
		else if(rc==40){DIVIDEND_DATE=readString();return "DIVIDEND_DATE "+DIVIDEND_DATE;}
		else{
			throw new RuntimeException("unknown "+rc);
		}
	}
	
}
	
	void directTable14(int SID) throws IOException
	{

	
	//	System.out.println("SID "+SID);
		if(SID==1){       //      QUOTE
			new 	LevelIQuote();	
		}else if(SID==5){  //      TIMESALE
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==10){ //      RESPONSE
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==16){ //      AUTHORIZER
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==18){ //      OPTION
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==14){ //      ACTIVES_ISLAND
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==23){ //      ACTIVES_NYSE
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==24){ //      ACTIVES_AMEX
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==25){ //      ACTIVES_NASDAQ
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==26){ //      ACTIVES_OTCBB
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==27){ //      NEWS
			new NEWS();
		}else if(SID==28){ //      NEWS_HISTORY
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==33){ //      OPTION_LOOKUP
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==35){ //      ACTIVES_OPTIONS
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==60){ //      ADAP_ISLAND
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==61){ //      ADAP_ECNS
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==62){ //      ADAP_NASDAQ
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==63){ //      ADAP_REDI
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==64){ //      ADAP_ARCA
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==65){ //      ADAP_BRUT
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==80){ //      AMTD_UPDATE
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==81){ //      NYSE_BOOK
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==82){ //      NYSE_CHART
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==83){ //      NASDAQ_CHART
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==85){ //      INDEX_CHART
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==84){ //      OPRA_BOOK
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==87){ //      TOTAL_VIEW
			throw new RuntimeException("NOT IMPLEMENTED");
		}else if(SID==100){ //      STREAMER_SERVER
			new StreamerServerResponse();	
		}else{
			throw new RuntimeException("unknown recepient field >>"+SID+"<<");
		}

		
	}
	
	
	
	 void readServiceIDs() throws IOException
	{
		for(;;){
			short SID=readShort();
			System.out.println("SID "+SID);
			
			System.exit(0);
		}
	}
	
	 class HeartBeat
	{
	byte SubType;
	long Timestamp;
	
	void log(String str)
	{
		System.out.println("HeartBeat>"+str);
	}
	
	
	
	HeartBeat() throws IOException
	{
		SubType=readByte();
	//	log("SubType "+byteasString(SubType));
		if(SubType=='T'){
			Timestamp=readLong();
			Date date=new Date(Timestamp);
	//		log("date "+date);
		}else if(SubType=='H'){
				
		}else{
				throw new RuntimeException("unknown "+SubType);
		}
				
	}
	
	}
	
	
	
	public String readString(int len) throws IOException
	{
	return new String(readBytes(len));
	}
	
	public byte[] readBytes(int len) throws IOException
	{
		
	byte[]bytes=new byte[len];
	int read=0;
	
	for(;;){
		
		int i=ds.read(bytes,read,len-read);
		if(i<=0){
			throw new RuntimeException("failed to read "+i+"  read was "+read);
		}
	//	System.out.println("i "+i);
		
		read+=i;
	//	System.out.println(">len-read "+(len-read));
		
		if(read==len){
			break;
		}
	}
	if(read!=len){
		throw new RuntimeException("didnt read "+len+" actually read "+read);
	}
	return bytes;
	}
	
	
	public String readString() throws IOException
	{
		short len=readShort();
		return readString(len);
	}
	
	
	
	public byte readByte() throws IOException
	{
		return ds.readByte();
		}
	public char readChar() throws IOException
	{
		return ds.readChar();
	}
	
	
	
		
	
	public long readLong() throws IOException
	{
		return ds.readLong();
	}
	public double readDouble() throws IOException
	{
		return ds.readDouble();
	}
	
	public boolean readBoolean() throws IOException
	{
		return ds.readBoolean() ;
	}
	
	public float readFloat() throws IOException
	{
		return ds.readFloat();
	}

	public int readInt() throws IOException
	{
		return ds.readInt();
	}
	public byte[] getLineTill_0x02() throws IOException
	{
		ByteArrayOutputStream ba=new ByteArrayOutputStream();
		byte[]b=new byte[1];
		for(;;){
			b[0]=ds.readByte();
			if(b[0]==0x02){
				break;
			}
			ba.write(b);
		}
		return ba.toByteArray();    
	}
	
	public byte[] getLineTill_FF() throws IOException
	{
		ByteArrayOutputStream ba=new ByteArrayOutputStream();
		byte[]b=new byte[1];
		for(;;){
			b[0]=ds.readByte();
			if(b[0]==FF){
				break;
			}
			ba.write(b);
		}
		return ba.toByteArray();    
	}
	
	public short readShort() throws IOException
	{
		return ds.readShort();
	}
}
