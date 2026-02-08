use lib "../modules/";
use Node;
my $skeleton=new Node ("skeleton");

$skeleton->addChild("head","right arm","left arm","trunk","right leg","left leg");
my $temp=new Node("limb"); #make a generic limb
$temp->addChild(qw/humerus radius ulna scaphoid
                lunate triquetral pisiform trapezium
                trapezoid capitate hamate/);
$temp->group("carpals",   $temp->childrenByNames(qw/scaphoid
                lunate triquetral pisiform trapezium
                trapezoid capitate hamate/  ));    
$temp->addChild(Node::deserialise("
[metacarpals
[
[1st]
[2nd]
[3rd]
[4th]
[5th]
]
]
"));    
$temp->addChild(Node::deserialise("
[digits
  [
    [thumb
      [
        [proximal phalanx]
        [distal phalanx]
      ]
    ]
    [index
      [
        [proximal phalanx]
        [middle phalanx]
        [distal phalanx]
      ]
    ]
    [long
      [
        [proximal phalanx]
        [middle phalanx]
        [distal phalanx]
      ]
    ]
    [ring
      [
        [proximal phalanx]
        [middle phalanx]
        [distal phalanx]
        
      ]
    ]
    [small
      [
        [proximal phalanx]
        [middle phalanx]
        [distal phalanx]
        
      ]
    ]
  ]
]
"));  
$temp->group("hand",   $temp->childrenByNames(qw/carpals
                metacarpals digits/  ));  
                
my $limb=$temp->serialise(); 

foreach ($temp->children()){
  $skeleton->child("right arm")->addChild($temp->child($_));
}

$temp=Node::deserialise($limb); 
foreach ($temp->children()){
  $skeleton->child("left arm")->addChild($temp->child($_));
}

my %analogues=(qw/humerus femur radius tibia ulna fibula scaphoid talus
              lunate calcaneus triquetral cuboid pisiform navicular trapezium cuneiform1
              trapezoid cuneiform2 capitate cuneiform3 hand foot carpal tarsal
              thumb big_toe index 2nd_toe  long 3rd_toe ring 4th_toe little_toe/);
$limb=~s/\[hamate\]\n//g;
foreach my $k (keys %analogues){
  $limb=~s/$k/$analogues{$k}/g if $analogues{$k}
}

$temp=Node::deserialise($limb);
foreach ($temp->children()){
  $skeleton->child("right leg")->addChild($temp->child($_));
}

$temp=Node::deserialise($limb);
foreach ($temp->children()){
  $skeleton->child("left leg")->addChild($temp->child($_));
}

$skeleton->setPaths();
$skeleton->drawTree("sp");
