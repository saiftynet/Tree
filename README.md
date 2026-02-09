# Interactive Tree Module
There are plenty of mature tree modules on MetaCPAN. [Tree::Simple](https://metacpan.org/pod/Tree::Simple) by [Ron Savage](https://github.com/ronsavage) a good robust one to start. [Tree::MultiNode](https://metacpan.org/pod/Tree::MultiNode) by [Todd Rinaldo](https://www.linkedin.com/in/toddrinaldo) and [Tree::DAG_Node](https://metacpan.org/pod/Tree::DAG_Node) established heavyweights.  A good description  of these and many others are provided by Ron Savage in the [pod](https://metacpan.org/pod/Tree::Simple) of his module.

Current Version-0.01  Early module to develop ideas

### Synopsis
```
# Node.pm is not on CPAN. It is experimental
use Node;      
my $noname=new Node({name=>"name"});  # new takes either a string
my $trunk=new Node("Trunk");          # or a NODE object
$trunk->addChild(qw/mammal reptile bird
                 insect fish mollusc miriapod crustacea/);
my $testNode=new Node("nematode");
$trunk->addChild($testNode);         # addChild takes strings, arrayor strings ornodes
$trunk->group("arthropod",$trunk->childrenByNames(qw/insect miriapod crustacea/)
                                     # groups children and makes them the children of new node                                           
$trunk->drawTree();                  # drawtree draws a tree (surprise!)
```

This one is just another **Experimental** one designed to be easy to reconfigure, serialise, deserialise or view. Another feature is the integration of weighted nodes. Interactive traversal is a goal, with a popularity value applied to nodes to assist this. Traversal is plenned in the future to be diffuse rather than absolute.


This is a single module, that represents the root, the forks, the leafs in fact the entire tree is itself a Node.
* A Root is a Node object.
* A Node objects may have other Node objects as children.
* The Nodes have names for display purposes.
* The have Unique Ids which are not permanent (i.e. will likely change between saving and loading). This is used to access the Nodes. The child Nodes are not necessarily ordered; so during serialisation deserialisation the orders will likely change.
* Nodes have a weight property that determined the relative "importance" of the node, probably by the frequency if traversal
* Nodes can be created, deleted, moved.
* Multiple Nodes can be grouped as children of a new Node in the tree
* Conversely, a Node can become ungrouped, so that it is deleted but its children appear as children of its parent
* A Node can be loaded/saved from/to files
* A Node can be visualised as a tree on the console, as nested lists in HTML, and converted to xml.
  
 ![image](https://github.com/saiftynet/dummyrepo/blob/main/tree/tree.png?raw=true)

## Methods

### `new Node`
* Creates a new Node object.  It requires a name; this is either as a string, or an object (like another Node) which has a property called name. e.g

```
    my $skeleton=Node->new("skeleton");
    my $skeleton=Node->new({name=>skeleton});
    my $bones=   Node->new($skeleton);    # oniy the root node is copied into $bones;
``` 
If the tree structure is already known it is perhaps easier to create a Node tree using `Node::deserialise` below;


### `$node->addChild(<node or string>)`
* Add a child node(s).

```
    $skeleton->addChild("head","trunk","left arm","right arm","left leg","left arm");
```      
### `$node->name()`
 * get the Name of a node.  Nodes have names, but no test is make sure the names are unique either in the tree or even amongst siblings
```
    $skeleton->name();
```

### `$node->child(<id or name>)`
* the child  node with a given ID or name.  Ids have a structure `[A-Z]\d+`. if the passed parameter does not fit this pattern or if it doesn't exist,
  children are searched by name.
```
  $skeleton->child("left arm")->addChild($temp->child($_));
```
### `parameter`
* TBC

### `$node->childByName(<name>)`
* Returns the id of the child with a given name, or 0 if not found.
```
my $cId=$skeleton->childByName("left arm");
```

### `$node->childrenByName(<list of names>)`
* given a list of names, return the IDs of children with those names

### `$node->hide()`
* Sets health to zero so the NBde will not appear in searches
  
### `$node->deleteChild(<childId>)`
 * Sets the child Node slot to `undef`.  the child is not deleted, but is no longer visible in searches and disappears during `serialise`-`deserialise`;
   
### `$node->children(<mode>)`
* Return a list of Children of a node in one of several modes. Mode can be "id" - list of IDs (Default if not specified),   "#id" - arrayref of Ids, "name" - list of names, "#name" - arrayref of names, "node" - list of nodes, "#node" - arrayref of nodes.
```
my $cId=$skeleton->children("node");  # returns the lisit of children as Nodes
```

### `$node->group(<new groupdata>,<ids of children of $node to be grouped>`
* this takes a group of children of a node and makes them the children of a new group node
```
# the following takes three children of $trunk and makes them the children of a new child of $trunk called "arthropod"
$trunk->group("arthropod",$trunk->childrenByNames(qw/insect miriapod crustacea/))
```

### `$node->ungroup(<childId>)`
* this is the reverses the above: a child of a node is removed with the grandchildren becoming the children of $node; 
```
$clone->ungroup($clone->childByName("arthropod"));
```
   
### `$node->list()`
* TBC

### `$node->text(<options>)`
* this returns the text with various options:  Options is a string; if it contains "i" includes the id, "p" includes the path from the $node to the  the desecendant, "w" includes the weighting of the node
    
### `$node->drawTree(<options>)`
* this draws a tree on the console.  The options is the same as for `text()`, with the addition of "s" to use ASCII rather than UTF8 characters.  
```
$clone->drawTree("s")
```

### `setPaths`
* this adds a parameter {path} to the node and all of descendants, which descrbes the path from the node to each descendant. (i.e. a list of the anxcestors in the order of traversal to get to the descendant.  Often it is automatically done, and not generally needed.
```
$clone->setPaths();
```
   
### `$node->serialise()`
* this creates a string that can be exported and later restored.  Currently only the names are epxorted, but it is expected that weight, health and other data ill be exportable
  
### `Node::deserialise(<string>)`
* this creates a new node from a serialised string
  
## Version

0.01  Very Buggy Initial module to develop ideas for the API.
