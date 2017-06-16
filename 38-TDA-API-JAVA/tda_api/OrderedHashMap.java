
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;


/**
 * HashMap class, which 
 * tracks the order of items in Map.
 * 
 * Remembers the order which items are added.
 * 
 * For Example, if put
 * 
 * "key1","value1"
 * "key2","value2"
 * "key3","value3"
 * 
 *  On java.util.HashMap class,  keys
 * may be stored in any order in Map.
 *When iterate through key set, can not guarante order. 
 * 
 * In this may, the keys are stored in the order that they
 * are added.
 *
 */

public class OrderedHashMap implements Cloneable
{
  protected HashMap hashmap=new HashMap();
  protected ArrayList order=new ArrayList();

/**
 * Returns size of hashMap
 * @return
 */

  public int size(){return hashmap.size();}

/**
 * Sorts al the keys in the HashMap
 *
 */

public void sort()
{
for(int i=0;i<this.size();i++)
{
if(this.getKey(i)==null){throw new RuntimeException("null key");}	
if(this.getValue(i)==null){throw new RuntimeException("null value");}	
}
	
	
Collections.sort(order);	
	
}


/**
 * Addall entries from an existing OrderedHashMap
 * to this HashMap.
 * 
 * The Entries from the original HashMap remain.
 * (So now contains all old entries and all
 * entries from the new HashMap)
 * 
 * (Which is consistent for ArrayList.addAll())
 * 
 */


public void addAll(OrderedHashMap ohm)
{
this.order.addAll(ohm.order);
this.hashmap.putAll(ohm.hashmap);  	
}

/**
 * Clones the OrderedHashMap.
 * (Clones the Hashmap and ArrayList inside too)
 */

public Object clone() 
{ 
	try{
  OrderedHashMap ohm=(OrderedHashMap)super.clone();
  ohm.hashmap=(HashMap)hashmap.clone();
  ohm.order=(ArrayList)order.clone();
	return ohm;
	}catch(CloneNotSupportedException e){e.printStackTrace();}
	 
return null;
}


/**
 * Create new Ordered hashMap
 *
 */
public OrderedHashMap()
{
	name=null;
}

final public String name;
public OrderedHashMap(String name)
{
	this.name=name;
}



/**
 * Puts entry into map,
 * throws Exception if entry is already there.
 * @param key
 * @param value
 */
public void putUnique(Object key,Object value)
{
if(this.containsKey(key)){
throw new RuntimeException("\nMap already contains key "+key+" mapped to "+this.get(key));		
}else{
this.put(key,value);	
}
	
}

public Object getNonNull(Object key)
{
	
if(hashmap.containsKey(key)==false){
throw new RuntimeException("cant locate "+key);		
}

  return this.hashmap.get(key);  

	
}

/**
 * Get Object from HashMap
 * @param name
 * @return
 */

  public Object get(Object name)
  {
 return this.hashmap.get(name);
  }

  public void put(Object name,Object value)
  {
  if(name==null)
  {
  throw new RuntimeException("null key for value "+value);	
  }
  
	if(hashmap.containsKey(name))
{   hashmap.remove(name);
	hashmap.put(name,value);
  }else{
	hashmap.put(name,value);
  order.add(name);   //Add on end
  }
  }


/**
 * Return list of keys for HashMap
 * @return
 */

  public  ArrayList getKeys()
  {
return this.order;
  }
  
  
  



/**
 * Returns collection of values for Hashmap
 * @return Collection of values
 */

  public  Collection values()
  {
return this.hashmap.values(); 
  }

/**
 * 
 * @return true if map is empty
 */

public boolean isEmpty()
{
return hashmap.isEmpty(); 
}

/**
 * Get key from HashMap
 * @param index  Index of Key
 * @return
 */

  public  Object getKey(int index)
  {
 if(index<order.size()){ 
   return this.order.get(index);
   }else{return null;}
  }

/**
 * Get value
 * @param index  Index of value
 * @return
 */

  public  Object getValue(int index)
  {     
  if(index<order.size()){ 
	Object key=order.get(index);
	return hashmap.get(key);
  }else{return null;}
  }

/**
 * get value
 * @param key  Key for value
 * @return  Value of key
 */

  public  Object getValue(Object key)
  {
	return hashmap.get(key);
  }

/**
 * List of all values in HashMap
 * @return  ArrayList of all values in HashMap
 */
  public  ArrayList getValues()
  {
  ArrayList alist=new ArrayList();
	for(int i=0;i<order.size();i++){
 Object key=order.get(i);
 alist.add(hashmap.get(key)); 		
		}//for 
		return alist;
  }

/**
 * Gets index of key
 * 
 * @param Index of key 
 * @return
 */

  public  int indexOfKey(Object key)
  {
   return   this.order.indexOf(key); 
  }

/**
 * Remove all keys, values from HashMap
 *
 */

  public  void clear()
  {
  hashmap.clear();
  order.clear();
  }


/**
 * Tests if map contains key
 * @param object  True is map contains key
 * @return
 */

public boolean containsKey(Object object)
{
return hashmap.containsKey(object);	
}

/**
 * 
 * @param object
 * @return True if map contains value
 */

public boolean containsValue(Object object)
{
return hashmap.containsValue(object);	
}


/**
 * Removes key
 * @param name  name of key to remove
 */

public void removeKey(Object name)
{
	hashmap.remove(name);
	order.remove(name);
 
}




/**
 * Return last value in HashMap
 * @return  Last value, or null if entry
 */

public Object getLastValue(){ 
if(this.size()==0){return null;} 	
return this.getValue(size()-1 );	
}

/**
 * Return last Key in HashMap
 * @return  Last key, or null if empty
 */

public Object getLastKey(){ 
if(this.size()==0){return null;} 	
return this.getKey(size()-1 );	
}



}


