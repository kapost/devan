Devan
=====
Devan is an [Adobe CRX/JCR](http://wem.help.adobe.com/enterprise/en_US/10-0/core/getting_started/overview.html) 
*client*.

Getting Started
---------------
The easiest way to get started is by taking a look at some of the examples written in Java that 
demonstrate how to work with a CRX/JCR repository.

```java
/*
 * This Java Quick Start uses the jackrabbit-standalone-2.4.0.jar
 * file. See the previous section for the location of this JAR file
 * 
 * Source: http://helpx.adobe.com/experience-manager/using/programmatically-accessing-cq-content-using.html
 */
import javax.jcr.Repository; 
import javax.jcr.Session; 
import javax.jcr.SimpleCredentials; 
import javax.jcr.Node; 

import org.apache.jackrabbit.commons.JcrUtils;
import org.apache.jackrabbit.core.TransientRepository; 

public class GetRepository { 
  public static void main(String[] args) throws Exception { 

    try { 
      //Create a connection to the CQ repository running on local host 
      Repository repository = JcrUtils.getRepository("http://localhost:4502/crx/server");

      //Create a Session
      javax.jcr.Session session = repository.login( new SimpleCredentials("admin", "admin".toCharArray())); 

      //Create a node that represents the root node
      Node root = session.getRootNode(); 

      // Store content 
      Node adobe = root.addNode("adobe"); 
      Node day = adobe.addNode("cq"); 
      day.setProperty("message", "Adobe Experience Manager is part of the Adobe Digital Marketing Suite!");

      // Retrieve content 
      Node node = root.getNode("adobe/cq"); 
      System.out.println(node.getPath()); 
      System.out.println(node.getProperty("message").getString()); 

      // Save the session changes and log out
      session.save(); 
      session.logout();
    }
    catch(Exception e){
      e.printStackTrace();
    }
  } 
}
```

The example above is rewritten as follows using `Devan`.

```ruby
require 'devan'

begin
  repository = Devan::Repository.new('http://localhost:4502')
  repository.login(Devan::Credentials.new('admin', 'admin'))

  root = repository.getRootNode()
  adobe = root.addNode("adobe")
  
  day = adobe.addNode("cq")
  day.setProperty("message", "Adobe Experience Manager is part of the Adobe Digital Marketing Suite!")

  node = root.getNode("adobe/cq")
  puts node.getPath()
  puts node.getProperty("message")

  repository.save
  repository.logout
rescue Devan::Error => e
  puts e.backtrace.join("\n")
end
```

Now let's take a look at a 'file upload' example and its equivalent using
`Devan`.

```java
/*
  Source: http://wiki.apache.org/jackrabbit/ExamplesPage
*/
public Node importFile (Node folderNode, File file, String mimeType,
    String encoding) throws RepositoryException, IOException
{
  //create the file node - see section 6.7.22.6 of the spec
  Node fileNode = folderNode.addNode (file.getName (), "nt:file");

  //create the mandatory child node - jcr:content
  Node resNode = fileNode.addNode ("jcr:content", "nt:resource");
  resNode.setProperty ("jcr:mimeType", mimeType);
  resNode.setProperty ("jcr:encoding", encoding);
  resNode.setProperty ("jcr:data", new FileInputStream (file));
  Calendar lastModified = Calendar.getInstance ();
  lastModified.setTimeInMillis (file.lastModified ());
  resNode.setProperty ("jcr:lastModified", lastModified);

  return fileNode;
}
```

The example above is rewritten as follows using `Devan`.

```ruby
def importFile(folderNode, file, mimeType, encoding)
  fileNode = folderNode.addNode(File.basename(file.path), "nt:file")

  resNode = fileNode.addNode("jcr:content", "nt:resource")
  resNode.setProperty("jcr:mimeType", mimeType);
  resNode.setProperty("jcr:encoding", encoding);
  resNode.setProperty("jcr:data", Devan::Binary.new(file));
  resNode.setProperty("jcr:lastModified", Devan::DateTime.new(file.mtime));

  fileNode
end
```

TODO
----
* Proper Test Suite
* Documentation via [TomDoc](http://tomdoc.org) 

Contribute
----------
* Fork the project.
* Make your feature addition or bug fix.
* Do **not** bump the version number.
* Send me a pull request. Bonus points for topic branches.

License
-------
Copyright (c) 2013 - 2014, Mihail Szabolcs

Devan is provided **as-is** under the **MIT** license. For more information see
LICENSE.
