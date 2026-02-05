# Interactive Tree Module
There are plenty of mature tree modules on MetaCPAN. [Tree::Simple](https://metacpan.org/pod/Tree::Simple) by [Ron Savage](https://github.com/ronsavage) a good robust one to start. [Tree::MultiNode](https://metacpan.org/pod/Tree::MultiNode) by [Todd Rinaldo](https://www.linkedin.com/in/toddrinaldo) and [Tree::DAG_Node](https://metacpan.org/pod/Tree::DAG_Node) established heavyweights.  A good description  of these and many others are provided by Ron Savage in the [pod](https://metacpan.org/pod/Tree::Simple) of his module.

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
$trunk->drawTree();                  # dray tree draws a tree
```

This one is just another **Experimental** one designed to be easy to reconfigure, serialise, deserialise or view. Another feature is the integration of weighted nodes. Interactive traversal is a goal, with a popularity value applied to nodes to assist this. Traversal is plenned in the future to be diffuse rather than absolute.


This is a single module, that represents the root, the forks and the leafs
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


