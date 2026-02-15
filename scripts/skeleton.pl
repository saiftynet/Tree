use lib "../modules/";
use Node;
my $skeleton=new Node ("skeleton");

$skeleton->addChild("axial","right arm","left arm","right leg","left leg");
my $temp=new Node("limb"); #make a generic limb
$temp->addChild(qw/scapula clavicle humerus radius ulna scaphoid
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
$limb=~s/\[(hamate|scapula|clavicle)\]\n//g;
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

$skeleton->child("axial")->addChild(qw/skull spine thorax pelvis/);
$skeleton->child("axial")->child("skull")->addChild("cranium","facial bones","left middle ear","right middle ear");
$skeleton->child("axial")->child("spine")->addChild(qw/cervical thoracic lumbar sacrum coccyx/);
my %vertebra=(cervical=>7,thoracic=>12,lumbar=>5);
for my $v(keys %vertebra){
	my @vNames=();
	for my $n (1..$vertebra{$v}){
	  push @vNames,uc(substr($v,0,1)).$n;
    }
	$skeleton->child("axial")->child("spine")->child($v)->addChild(@vNames);
}

$skeleton->target("root->axial->skull->cranium")->addChild(
   "frontal","sphenoid","ethmoid","left parietal","right parietal",
   "left temporal","right temporal","occiptal");
   ;
$skeleton->target("root->axial->skull->facial bones")->addChild(
   "vomer","nasal bones","left zygoma","right zygoma",
   "left lacrimal bone","right lacrimal bone",
   "left maxilla","right maxilla",
   "left inferior nasal concha","right  inferior nasal concha",
   "left palatine","right palatine","mandible");
$skeleton->target("root->axial->skull->facial bones")->addChild(
   "vomer","nasal bones","left zygoma","right zygoma",
   "left lacrimal bone","right lacrimal bone",
   "left maxilla","right maxilla",
   "left inferior nasal concha","right inferior nasal concha",
   "left palatine","right palatine","mandible");
   
foreach (qw/left right/){
	$skeleton->target("root->axial->skull")->child($_." middle ear")->
	           addChild(qw/malleus incus stapes/);
}
print $skeleton->drawTree("cui");
