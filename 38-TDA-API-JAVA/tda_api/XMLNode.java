
 

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.TreeNode;
import javax.swing.tree.TreePath;




/**
 * Class used to represent XML Nodes
 * 
 * The XML Nodes may also be displayed in a JTree, as they extend DefaultMutableTreeNode 
 * 
 * This has proved to be an efficient class for processing XML.
 *
 */


public class XMLNode extends DefaultMutableTreeNode 
{

	
	/**
	 * Returns parent of node (saves having to call getParent() and cast)
	 * @return
	 */

	public XMLNode getMyParent()
	{
		return (XMLNode) this.getParent();
	}
	


		 

	
	 






	



	/**
	 * Name of Node
	 */
private String name;


/**
 * Value of Node
 */

private String value;

/**
 * XML Attributes, OrderedHashMap stores the attributes
 */
 OrderedHashMap attributes=new OrderedHashMap();

/**
 * StringBuffer to be used in building tree.
 */

public StringBuffer sb=new StringBuffer();


/**
 * Suffix used in the toString method
 * This is usefull for appending to the name of each node
 * when the node is viewed in a JTree.
 * For example,  if want a node with name "books" to to be displayed as "books-2"
 * then set suffix to be "-2"
 * 
 * 
 */

public String SUFFIX;


/**
 * Renames the node, to a different Name
 * @param newname   NewName of node
 */

public void rename(String newname)
{
	this.name=newname;
}





/**
 * Sorts the children on the current node into alphabetical order.
 *
 */

public void sortChildren()
{
	if(children==null){
		throw new RuntimeException("no children for Node "+this.getTreePath());
	}
	
	Collections.sort(this.children,new Comparator(){

		public int compare(Object arg0, Object arg1) {
	XMLNode a=(XMLNode)arg0;
	XMLNode b=(XMLNode)arg1;
	return a.toString().compareToIgnoreCase(b.toString()); 
		}
		
		
	});
	
}



/**
 * Gets the treepath of a Node.
 * @return
 */






/**
 * 
 * 
 * TreePath is of the form  aaa,bbb,ccc
 * 
 * Nodes can be retrieved from the tree path.
= * 
 * @param typepath
 * @return
 */

public static XMLNode getNodeforPath(XMLNode root,String typepath)
{	
StringHelper.assertnonNull(typepath);	
	String trimpath;
	{	
	StringBuffer trimpathSB=new StringBuffer();
	String[]tks=StringHelper.StringTrimTokenizer(typepath,",");
	for(int i=0;i<tks.length;i++){
		trimpathSB.append(tks[i].trim());
		if(i<tks.length-1){
			trimpathSB.append(",");	
		}//if
	}//for
	trimpath=trimpathSB.toString();
	}
	
	
	StringHelper.assertnonNull(typepath);
	ArrayList al=new ArrayList();
	
	 XMLNode[] nodes=root.getNodeList();
for(int i=0;i<nodes.length;i++){
	if(nodes[i].getShortTreePath().equalsIgnoreCase(trimpath)){
		al.add(nodes[i]);
	}
}

	if(al.size()>1){
		StringBuffer sb=new StringBuffer(" duplicate nodes with path >>"+typepath+"<<");
		for(int i=0;i<al.size();i++){
			sb.append(al.get(i)+"\n");
		}
		throw new RuntimeException();
			
	}

	if(al.isEmpty()){
		return null;
	}
	
    return (XMLNode)al.get(0);
	
}

/**
 * Returns short tree path for a node
 * For example aaa,bbb,ccc
 * @return
 */

public  String getShortTreePath()
{
	TreeNode[] nodes=this.getPath();
	StringBuffer sb=new StringBuffer();
	for(int i=1;i<nodes.length;i++){
		XMLNode node=(XMLNode) nodes[i];
		sb.append(node.getName());
		if(i<nodes.length-1){
			sb.append(",");
		}
	}
	return sb.toString();
}





/**
 * Returns the tree path for a node
 * @return
 */

public TreePath getTreePath()
{
return new TreePath(this.getPath());
}


/**
 * Returns the node, and all child nodes, sorted in PreOrder.
 * @return
 */

public XMLNode[] getNodeList()
{
	return (XMLNode[])this.toArray().toArray(new XMLNode[]{});
}


/**
 * Adds Nodes to an Array, is recursive, and keeps adding
 * the node, then all its children.
 */


private static void _toArray(ArrayList al,XMLNode node)
{
al.add(node);
for(int i=0;i<node.getChildCount();i++){
_toArray(al,(XMLNode) node.getChildAt(i));
}//for
}


/**
 * 
 * @param name Name of node
 * @param value  Value of node
 */

public XMLNode(String name,String value)
 {
if(name==null){throw new RuntimeException("Null Name");} 	
 	
this.name=name;
this.value=value;
 }



/**
 * Name of the XML Node
 * @param name
 */

public XMLNode(String name)
{
if(name==null){throw new RuntimeException("Null Name");} 	
this.name=name;
}

/**
 * Return depth of the node.
 */

public  int getDepth()
{   return this.getLevel();
}


/**
 * 
 * @param name Name of the node
 * @param atts Attributes for the node
 */
public XMLNode(String name,org.xml.sax.Attributes atts)
{
if(name==null){throw new RuntimeException("Null Name");} 	

this.name=name;
this.attributes.clear();
 
for (int i = 0 ; i < atts.getLength() ; i++) {
 String attname=atts.getQName(i);
 String attvalue=atts.getValue(i);
  this.attributes.put(attname,attvalue);

  }//for


}

/**
 * Gets the name of the Element.
 * @return
 */

public String getName()
{  return this.name;
}

/**
 * Gets the value of the Element.
 * @return
 */

public String getValue()
{  return this.value ;
	}


/**
 * Sets the value for the Node.
 * @param value  Value for the node
 */

public void setValue(String value)
{this.value=value;}

/**
 * Gets the value for the Attribute.
 * @param selected_attribute_name   Name of attribute to get value for
 * @return
 */

public String getAttributeValue(String selected_attribute_name)
{return (String)this.attributes.get(selected_attribute_name);
}


/**
 * Gets an attribute value, throws a RuntimeException if that value does not exist.
 * @param selected_attribute_name
 * @return
 */

public String getAttributeValueNonNull(String selected_attribute_name)
{
	String val=(String)this.attributes.get(selected_attribute_name);
	
	if(val==null){
		throw new RuntimeException(new TreePath(this.getPath())+"  cant find attribute with name "+selected_attribute_name);
	}
	
	return val;
	
}

/**
 * Sets the attribute value for the node
 * @param attname   Attribute name to set
 * @param attval    Attribute value to set.
 */

public void setAttribute(String attname,String attval)
{
StringHelper.assertnonNull(attname);
StringHelper.assertnonNull(attval);
attributes.put(attname,attval);
}

/**
 * Deletes attribute with a given name
 * @param name
 */

public void deleteAttribute(String name)
{
StringHelper.assertnonNull(name);
attributes.removeKey(name);
}







/**
 * Searches for text anywhere.
 * @param matches
 * @param findval
 * @param enode
 */


/**
 * 
 * Search for elements matching nodes.
 * 
 * @param elementName ElementName to search for 
 * @param elementVal  Element value to search for
 * @param attributeName  Attribute name to search for
 * @param attributeVal  Attribute value to search for
 * @param depth   Locate Elements at this depth.
 * @param exact    True, if match is exact.
 * for example, if exact "Return" will return only
 * Node "Return" otherwise will return
 * "Return", "ReturnHeader", "ReturnData"
 * 
 * 
 * @return
 */





/**
 * Returns a list of treepaths, whose elements match
 * the string.
 * @param val
 * @return  List of paths, whose elements match the string.
 */









/**
 * Adds a Child Element
 * @param elementname  name of Element
 * @param above  true, if Node is placed before Element.
 */



/**
 * Attribute count
 * @return  Count of Attributes
 */

public int getAttributeCount()
{
return attributes.size();
}


/**
 * Gets attribute at Index
 * @param index  Zero based index.
 * @return
 */

public String getAttributeName(int index)
{
return (String)this.attributes.getKey(index);
}

public String getAttributeValue(int index)
{
return (String)this.attributes.getValue(index);
}





/**
 * Returns first child with the given name.
 * Throws an Exception, if cant find child with that name.
 * 
 * @param name  Name of child to return
 * @return  1st child with given name
 */

public XMLNode getChildwithNameNonNull(String name)
{
	XMLNode node= getChildwithName(name);

if(node==null){
	throw new RuntimeException("Cant find child with name "+name);
}

return node;

}

/**
 * gets the first child with Name
 * @param name  Name of Child to search for.
 * @return
 */

public XMLNode getChildwithName(String name)
{
for(int i=0;i<this.getChildCount();i++){
XMLNode tempnode=(XMLNode)this.getChildAt(i);
if(tempnode.getName().equals(name)){return tempnode;}
}//while
return null;
}//


 
/**
 * Returns all the children with the given name
 * @param name  Name of child.
 * @return  Array of Nodes where child has given name.
 */

public XMLNode[] getChildrenwithName(String name)
{
ArrayList al=new ArrayList();
for(int i=0;i<this.getChildCount();i++){
XMLNode tempnode=(XMLNode)this.getChildAt(i);
if(tempnode.getName().equals(name)){
	al.add(tempnode);
}//if
}//while

return (XMLNode[])al.toArray(new XMLNode[al.size()]);
}//


/**
 * Adds an XML Node to the parent.
 * @param newChild
 */
public void add(XMLNode newChild) {
super.add(newChild);
}


/**
 * Adds node so that it is in alphabetical order with respect to its siblings.
 * 
 * @param newChild
 */
public void addNodeSported(XMLNode newChild)
{

	int i=0;
	for(;i<this.getChildCount();i++){
		
String name=""+((XMLNode)this.getChildAt(i)).getAttributeValue("name");
String childname=""+newChild.getAttributeValue("name");


if(name.compareToIgnoreCase(childname)>0){
	break;
}//if
}//for

super.insert(newChild,i);

}



/**
 * Creates a node with a given tree path
 * Path is relative to the root.
 * 
 *  * Path is of the form aaa,bbb,ccc

 * 
 * If node exists, throw an exception
 * 
 * @param root  
 * @param path  Path to create node
 * @return XMLNode, which was created at path
 */

public static XMLNode  createNewNodewithPath(XMLNode root,String path)
{

	{
	XMLNode existing=XMLNode.getNodeforPath(root,path);
	if(existing!=null){
		return existing;
//        throw new RuntimeException("we already have node with path>>"+path+"<<");
	}//if
	}
	return XMLNode.createNode(root,path); 
	
}







/**
 * Path is of the form aaa,bbb,ccc
 * 
 * 
 * Creates a node, at the given path.
 * @param root  Root of XML Tree
 * @param path  Path to create a node at.
 */

	private static XMLNode createNode(XMLNode root,String path) 
	{
	 	
	String[] tks=StringHelper.StringTrimTokenizer(path.trim(),",");
	XMLNode tnode=(XMLNode)root;

	for(int i=0;i<tks.length;i++){
		XMLNode childnode=(XMLNode)tnode.getChildwithName(tks[i]);
		if(childnode==null){
			childnode=new XMLNode(tks[i],"");
		    tnode.add(childnode);
		}
		tnode=childnode;
	}//for


	return tnode;
		
	}

	
 
	
	

/**
 * Compare, used to compare ElementTreeNodes (used for Sorting)
 */


/**
 * Returns truncated Name of Node.
 * This is used for generating unique DocumentID's
 * When we copy a document, the new DocumentID must be
 * unique.  
 * 
 * We create unique name, by appending a "-1", "-2"  etc.
 * If the old documentName was 30 chars long, we cant 
 * append suffix, as Schema defines that documentName is <=30 chars.
 * 
 * hence, we use truncated names.
 * Essentially we remove all vowels from name to get truncated name.
 * 
 */


/**
 * gets Parent with Name
 * @param name Name of Parent
 * @return
 */





	
	public String toString()
{
		String append=StringHelper.nonNull(SUFFIX);
		
	 String xname=this.getAttributeValue("name");
	 if(xname!=null){
		return  xname+append;
	 }else{
		 return name+append;
	 }
	 
}

	/**
	 * Returns set of XMLNodes as an ArrayList
	 * Adds all Child nodes including himself.
	 * 
	 * 
	 * @return
	 */
	
	public ArrayList toArray()
	{
		ArrayList al=new ArrayList();
		_toArray(al,this);
		return al;
	}

	
	
/**
 * Sets the name of the node.
 * @param name
 */	

public void setName(String name) {
	this.name = name;
}





}//ElementTreeNode
