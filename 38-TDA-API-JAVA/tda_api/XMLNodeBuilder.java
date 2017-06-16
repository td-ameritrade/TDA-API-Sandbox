

//cfn=26404675652
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.helpers.DefaultHandler;





/**
 * Builds a representation of an XML Document using XMLNodes
 */

public class XMLNodeBuilder {
XMLNode root;   //root of tree
XMLNode cnode;  //Current Node used in building

/**
 * Gets the root of tree.
 * @return
 */
public XMLNode getRoot(){  return root;}






/**
 * Process Comments.
 * Takes a String, which is a commar seperated value list
 * of commends, and returns an OrderedHashMap representaion
 * 
 * (Basically a key/value pair)
 * 
 * @param comments
 * @return
 */

 



/**
 * Handler for XML.
 *
 */

class Handler extends DefaultHandler
	{



 public void characters(char[] ch, int start, int length) 
	
  {
	cnode.sb.append(ch,start,length);
}


public void startElement(String namespaceURI, String localName, 
						   String qName, org.xml.sax.Attributes atts)
	
  {

	try{

  
XMLNode newnode=new XMLNode(qName,atts);

   
   if(root==null){
	root=newnode;
      
   }
	else{
		cnode.add(newnode);
   	} 
	cnode=newnode;        	
  
}catch(Exception e){e.printStackTrace();throw new RuntimeException(e.getMessage());} 
  }

  public void endElement(String namespaceURI, String localName, 
						 String qName)
	
  {
   try{
   // System.out.println("endElement: " + qName);
	cnode.setValue(cnode.sb.toString().trim() );
   cnode.sb=null;
   if(cnode.getParent()!=null){ cnode=(XMLNode)cnode.getParent(); }
   	
  
   }catch(Exception e){e.printStackTrace();throw new RuntimeException(e.getMessage()); } 
  }

  
  
}

 /**
  * Assemble XMLNode tree from an XML Document stored as a File.
  * @param file  File containing XML Document
  */
   public XMLNodeBuilder(File file)   
   {
	 	try {
			init(new FileInputStream(file));
		} catch (FileNotFoundException e) {
		throw new RuntimeException(e);
		}
   }

   
   /**
    * Assemble XMLNode tree from an XML Document which was stored in a String
    * @param str String containing XML Document to process
    */
   
   public XMLNodeBuilder(String str) 
   {
      
	init(new ByteArrayInputStream(str.getBytes()));
    }
   
   /**
    * Assemble XMLNode tree from an XML Document stored in a byte Array.
    * @param bytes  Byte Array containing XML Document
    */

   public XMLNodeBuilder(byte[]bytes) 
   {
      
	init(new ByteArrayInputStream(bytes));
    }

   /**
    * Assemble XMLNode tree from an XML Document accessed via an InputStream
    * @param in InputStream from where the XML Document will be read.
    */
   
   public XMLNodeBuilder(InputStream in) 
   {
			init(in);
   }
		
public void init(InputStream in) 
{
	StringHelper.assertnonNull(in);
	
	try {
SAXParserFactory factory=SAXParserFactory.newInstance() ;
SAXParser parser=factory.newSAXParser(); 	
parser.parse(in,new Handler());
  
	} catch (Exception e) {
		   throw new RuntimeException(e);
				}finally{
			  try {
				in.close();
			} catch (IOException e) {
				e.printStackTrace();
			} 
		   }
  
}




}
