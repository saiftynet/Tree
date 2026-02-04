# Interactive Tree Module
There are plenty of mature tree modules on MetaCPAN. [Tree::Simple](https://metacpan.org/pod/Tree::Simple) by Ron Savage is a good robust one to start. [Tree::MultiNode](https://metacpan.org/pod/Tree::MultiNode) by Todd Rinaldo and [Tree::DAG_Node](https://metacpan.org/pod/Tree::DAG_Node) established heavyweights.  A good [description](https://metacpan.org/pod/Tree::Simple) of these are provided by Ron Savage in the pod of his module.


This one is just another **Experimental** one designed to be easy to reconfigure, serialise, deserialise, view. Another feature is the integration of weighted nodes. Interactive traversal is a goal, with a popularity value applied to nodes to assist this. 

This is a single module.
* A Root is a Node object.
* A Node objects has other Node objects as children.
* The Nodes have names for display purposes.
* The have Unique Ids which are not permanent (i.e. will likely change between saving and loading). This is used to access the Nodes. The child Nodes are not necessarily ordered; so during serialisation deserialisation the orders will likely change.
* Nodes have a weight property that determined the relative "importance" of the node, probably by the frequency if traversal
* Nodes can be created, deleted, moved.
* Multiple Nodes can be grouped as children of a new Node in the tree
* Conversely, a Node can become ungrouped, so that it is deleted but its children appear as children of its parent
* A Node can be loaded, unloaded from files
* A Node can be visualised as a tree on the console, as nested lists in Html, and converted to xml.
