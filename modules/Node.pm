package Node;
   use strict; use warnings;   
   
   our $VERSION="0.01";
   
   sub new{
     my ($class,$data)=@_;
     die "No Data Specified, can not create empty node" unless $data;
     my $name=ref $data?$data->{name}:$data;
     die "Name for node not found" unless $name;
     my $self={
       name=>$name,
       data=>$data,
       id=>"", 
       health=>(ref $data && $data->{health})?$data->{health}:1.0,
       weight=>(ref $data && $data->{weight})?$data->{weight}:1.0,
       prefix=>("A".."Z")[rand()*26],   # for any children to this node
     };
     bless $self,$class;
   }
   
   sub addChild{   # multiple children (or one child can be added)
     my ($self,@data)=@_;
     $self->{branches}//={};
     my $index=scalar keys %{$self->{branches}};
     my $nodeId;
     foreach (@data){
       $nodeId=$self->{prefix} . $index++;
       $self->{branches}->{$nodeId} = (ref $_ eq "Node")?$_:new Node($_) ;
       $self->{branches}->{$nodeId}->{id}=$nodeId;
     }
     return $nodeId;  # returns the last added child
   }
   
   sub name{
     my $self=shift;
     return ref $self->{data} ? $self->{data}->{name} : $self->{data};     
   }
   
   sub child{
     my ($self,$keyName)=@_;
     if (($keyName=~/^$self->{prefix}(\d+)$/) && exists $self->{branches}->{$keyName}){
       return $self->{branches}->{$keyName}
     }
     elsif (childByName($keyName)){       
       return $self->{branches}->{childByName($keyName)}
     }
   }
   
   sub parameter{
     my ($self,$parameter)=@_;
     return $self->{data} unless ref $self->{data};
     return $self->{data}->{$parameter} if exists $self->{data}->{$parameter};
   }
   
   sub childByName{
     my ($self,$name)=@_;
     my $cId="";
     foreach ($self->children()){
       if ($self->{branches}->{$_}->name() eq $name){
         $cId=$_;
         last;
       };
     }
     return $cId||"";
   }
   
   sub childrenByNames{
     my ($self,@names)=@_;
     my @ret=();
     foreach (@names){
       my $cId=$self->childByName($_);
       push @ret, $cId if $cId
     }
     return @ret;
   }
   
   sub hide{
     my $self=shift;
     $self->{health}=>0;
   }
   
   sub deleteChild{
     my ($self,$childId)=@_;
     $self->{branches}->{$childId}=undef;
   }
   
   sub children{
     my ($self,$mode)=@_;
     $mode//="id";
     return undef unless $self->{branches};
     my @ret=map {($self->{branches}->{$_} && $self->{branches}->{$_}->{health})?$_:() } sort keys %{$self->{branches}};
     return @ret   if $mode eq "id";
     return [@ret] if $mode eq "#id";
     @ret=map{$self->{branches}->{$_}} @ret;
     return @ret if $mode eq "node";
     return [@ret] if $mode eq "#node";
     @ret=map{$_->name()} @ret;
     return @ret if $mode eq "name";
     return [@ret] if $mode eq "#name";
     
   }
   
   sub group{ #
     my ($self,$groupData,@children)=@_;
     my $newNode=$self->{branches}->{$self->addChild($groupData)};      # create New Node
     
     if (ref $children[0] eq "ARRAY") {
       @children=@{$children[0]};
     };
     foreach my $cId(@children){ # add each Child to the new node, then delete from old node
       #die $cId;
       $newNode->addChild($self->{branches}->{$cId});
       $self->deleteChild($cId)
     }     
     return $newNode;
   }
   
   sub ungroup{ #
     my ($self,$childId)=@_;
     foreach (keys %{$self->{branches}->{$childId}->{branches}}){
       $self->addChild( $self->{branches}->{$childId}->{branches}->{$_})
     }
     $self->deleteChild($childId);   
   }
   
   # tree IO
   
   sub list{
     my ($self, $indent)=@_;
     $indent//="";
     print $indent.$self->name()."\n";
     if ($self->children()){
       foreach ( sort $self->children()){
         $self->{branches}->{$_}->list($indent."  ");
       }
     }
   }
   
   sub drawTree{
     my ($self,$option,$ol)=@_;
     if(!$ol){
       print $self->text($option);
       $ol="  ";
     }
     my @children=$self->children("node");
     foreach (0..$#children){
       my $last=$_ == $#children;
       print $ol.($last?"└─":"├─").$children[$_]->text($option);
       if ($children[$_]->children()){
         $children[$_]->drawTree($option,$ol.($last?" ":"│")."  ")
       }
     }
    return 1
   }
   
   sub text{
     my ($self,$option)=@_;
     $option//="";
     return $self->name().
             ($option=~/w/i? "($self->{weight})":"").
             ($option=~/p/i? "<$self->{path}>":"").
             ($option=~/i/i? "[$self->{id}]":"")."\n";
   }
   
   sub setPaths{
     my ($self,$parentPath)=@_;
     $parentPath//="";
     my $path=$parentPath?$parentPath."->".$self->{id}:"root";
     $self->{path}=$path;
     my @children=$self->children("node");
     foreach (@children){
       $_->setPaths($path) if $_;
     };
   }
   
   
   sub serialise{
     my ($self,$indent)=@_;
     $indent//=0;
     my $expTree//=" "x$indent."[".$self->name();
     my @children=$self->children("node");
     my $hadKids=0;
     foreach (@children){
       if ($_){
         $expTree.="\n".$_->serialise(++$indent);
         $indent--;
         $hadKids=1;
       }
     }
     $expTree.="\n".(" "x$indent) if $hadKids;
     return $expTree."]";
   }

   sub deserialise{
     my ($file)=@_;
     my @lines = split "\n",$file;
     my @stack;
     my $level=0;
     foreach my $line (@lines){
       chomp $line;
       if ($line =~/^\s*\[([^\[\]]+)/){
         my $data=$1;          # ": Node: named $data" ;         
         if ($line !~/\]$/){   # ": Has Children: Level $level";
             $level++;
             push @stack,Node->new($data);
         }
         else{                 # ":  Node:named $data" ;
           $stack[-1]->addChild($data);# " added to ", $stack[-1]->name();
         }
       };
       if ($line =~/^\s*\]\s*$/){ # ": No More Children " ; 
          if ($stack[-2]){     #  if not end of root node
            $stack[-2]->addChild($stack[-1]);  # add to parent node
            $level--;
            pop @stack;        # remove group from root
          }
       }
     }
     $stack[0]->setPaths();
     return $stack[0];
   }   
   
   
1;

