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

`new`
* Creates a new Node object.  It requires a name; this is either as a string, or an object (like another Node) which has a property called name. e.g

```
    my $skeleton=Node->new("skeleton");
    my $skeleton=Node->new({name=>skeleton});
    my $bones=   Node->new($skeleton);    # oniy the root node is copied into $bones;
``` 
If the tree structure is already known it is perhaps easier to create a Node tree using `Node::deserialise` below;


`addChild`
* Add a child node(s).

```
    $skeleton->addChild("head","trunk","left arm","right arm","left leg","left arm");
```      
`name`
   
`child`
   
`parameter`
   
`childByName`
   
`childrenByName`
   
`hide`
   
`deleteChild`
   
`children`
   
`group`
   
`ungroup`
   
`list`
   
`drawTree`
   
`text`
   
`setPaths`
   
`serialis`
     
`deserialise`

## Version

0.01  Very Buggy Initial module to develop ideas for the API.
