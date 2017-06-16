


/**
 * Class for providing XML Encoding, for XML
 * 
 * UTF encoding allows for representation of special characters in XML like < , > , = , /   etc.
 * The default Encoding is UTF-8
 * @author stephenf
 */



public class XMLEncoding {

	
public static String getXMLHeader()
{
	return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
}


/**
 * Convert to UTF encoding.
 * @param value  Value to encoding
 * @return  Encoded XML
 */


public static String printConvert(String value)
{
    if(value==null){return "";}
	return UTFCharEncoding(value); 
}






/**
 * Encode as UTF using character encoding
 * @param value  Value to encode
 * @return  Character encoded UTF
 */
private static String UTFCharEncoding(String value)
{
	

 
StringBuffer sb=new StringBuffer();
  for(int i=0;i<value.length();i++){
  	char c=value.charAt(i);
  	
  	if(c>=127||c<32){sb.append("&#x"+(Integer.toHexString((int)c))+";");	}
  	else if(c=='&'){sb.append("&amp;");}
	else if(c=='<'){sb.append("&lt;");}
	else if(c=='>'){sb.append("&gt;");}
	else if(c=='\"'){sb.append("&quot;");}
  	else{sb.append(c);	}
  	
  }//for
	
		return sb.toString() ;

	}







	




}

 


