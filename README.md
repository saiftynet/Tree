# Interactive Tree Module
There are plenty of mature tree modules on MetaCPAN. Tree::Simple by Ron Savage is a good robust one to start.
More performant ones exist. This one is just another one designed to be easy to reconfigure, serialise, deserialise, view. 
another feature is the integration of weighted nodes. Interactive traversal is a goal, with a popularity value applied to nodes
to assist this. 

This is a single module.
* A Root is a Node object.
* A Node objects has other Node objects as children.
* The Nodes have names for display purposes.
* The have Unique Ids which are not permanent (i.e. will likely change between saving and loading)
* Nodes can be created, deleted, moved.
* Multiple Nodes can be grouped as children of a new Node in the tree
* Conversely, a Node can become ungrouped, so that it is deleted but its children appear as children of its parent
* A Node can be loaded, unloaded from files
* A Node can be visualised as a tree on the console, as nested lists in Html, and converted to xml.
