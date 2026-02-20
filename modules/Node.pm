package Node;
   use strict; use warnings;   
   
   our $VERSION="0.04";
   
   our $glyphs={
      utf8 =>{L=>"└─",T=>"├─",I=>"│ ",S=>" " },
      ascii=>{L=>"L-",T=>"|-",I=>"| ",S=>"  "},
   };
     
   our $colours={black   =>30,red     =>31,  green   =>32,yellow   =>33,
                 blue    =>34,magenta =>35,  cyan    =>36,white    =>37,
                 on_black=>40,on_red  =>41,on_green  =>42,on_yellow=>43,
                 on_blue =>44,on_magenta=>4,on_cyan  =>46,on_white =>47,
                 reset   =>0, bold=>1, italic=>3, underline=>4,blink=>5,
                 strikethrough=>9, invert=>7, bright =>1, overline =>53};
   
   our $formats={
     root=>"red on_white",
     group=>"cyan",
     leaf=>"yellow",
     select=>"invert",
     none=>"",
   };
   
   our $printOuts;
   
   sub colour{
	   my ($string,$colour)=@_;
	   return $string unless $colour;
	   return "\033[".join(";",map{$colours->{$_}}(split /\s+/,$colour))."m".$string."\033[$colours->{reset}m";
   }
   
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
       view=>{},
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
     else{       
       return $self->{branches}->{$self->childByName($keyName)}
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
     my @ret=map {($self->{branches}->{$_} && $self->{branches}->{$_}->{health})?$_:() } sortNum (keys %{$self->{branches}});
     return @ret   if $mode eq "id";
     return [@ret] if $mode eq "#id";
     @ret=map{$self->{branches}->{$_}} @ret;
     return @ret if $mode eq "node";
     return [@ret] if $mode eq "#node";
     @ret=map{$_->name()} @ret;
     return @ret if $mode eq "name";
     return [@ret] if $mode eq "#name";
     
   }
   
   sub sortNum{ #schawartzian transform that sorts keys by numberical suffic
      return map  { $_->[0] }
             sort { $a->[1] <=> $b->[1] }
             map  { [$_, $_=~/(\d+)/] }
                 @_;
     
   }
   
   sub group{ #
     my ($self,$groupData,@children)=@_;
     my $newNode=$self->{branches}->{$self->addChild($groupData)};      # create New Node
     
     if (ref $children[0] eq "ARRAY") {
       @children=@{$children[0]};
     };
     foreach my $cId(@children){ # add each Child to the new node, then delete from old node
       next unless $self->{branches}->{$cId};
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
     $option//="";
     if(!$ol){
       $self->setPaths();
       $printOuts= " + ".$self->text($option);
       $ol="  ";
     };
     `chcp 65001` if $^O =~ /MSWin32/;
     my $gl=$glyphs->{ascii};
     if ($option=~/u/i){
        $gl=$glyphs->{utf8};
     }
     my @children=$self->children("node");
     
     foreach (0..$#children){
       my $last=$_ == $#children;
       my $kid=$children[$_];
       next unless $kid;  # exclude childen that are undef;
       $printOuts.= colour($ol.($last?$gl->{L}:$gl->{T}),$option=~/c/i?"green":"").$kid->icon().$kid->text($option);
       if ($kid->children()){
         $kid->drawTree($option,$ol.($last?$gl->{S}:$gl->{I})."  ")
       }
     }
    return $printOuts;
   }
   
   sub html{
	   my ($self,$options,$indent) =@_;
	   $options//="";
	   my $wrap=0;
	   if (!$indent){
	     $indent=1;
		 $wrap=1;  
	   }
	   if ($options=~/d/){
		   return ("  "x$indent)."<div style=\"padding-left:2em;font-size:".($wrap?"4em":"0.9em")."\" >".$self->name().
	       $self->htmlChildren($options,$indent++).
	       "</div>\n";
		   
	   }
	   else {
		   return ($wrap?"<ul>\n":"").("  "x$indent)."<li>".$self->name().
	       $self->htmlChildren($options,$indent++).
	       "</li>\n".($wrap?"</ul>":"");
	   }
   }
   
   sub htmlChildren{
	   my ($self,$options,$indent) = @_;
	   my @children=$self->children("node");
	   my $hadKids=0;
	   my $kids="";
	   $indent++;
	   foreach (@children){
		   if ($_){
			 $kids.=$_->html($options, ++$indent);
			 $indent--;
			 $hadKids=1;
		   }
     }
	   if ($options=~/d/){
		   
		   return $hadKids?"\n".$kids.("  "x --$indent):"";
	   }
	   else {
          return $hadKids?"\n".("  "x $indent--)."<ul>\n".$kids.("  "x ++$indent)."</ul>\n".("  "x--$indent):"";
	  }
   }
   
   sub embedData{
	   my ($self,$options) = @_;
   }
   
     
   sub icon{
	   my $self=shift;
	    return $self->{view}->{type} eq "leaf"?"":$self->{view}->{open}?" - ":" + ";
   }
   
   sub target{
     my ($self,$path)=@_;
     my @p=split("->",$path);
     shift @p;
     my $ret=$self;;
     foreach (@p){
       $ret=$ret->child($_);
     }
     return $ret;
   }
   
   sub parent{
     my ($self,$trunk)=@_;
     my $path=$self->{path};
     $path=~s/->[^>]+$//;
     return $trunk->target($path);
   }
   
   sub randomChild{
     my ($self,$option)=@_;
     my @children=$self->children($option);
     return $children[rand()*(scalar @children)];
   }
   
   sub nextSibling{
	   my ($self,$trunk)=@_;
	   my $parent=$self->($trunk);
	   my $siblings=$parent->children();
   }
   
   sub text{
     my ($self,$option)=@_;
     $option//="";
     my $dec=colour($self->name(),($option=~/c/i?$formats->{$self->{view}->{type}}:""));
     return $dec.
             ($option=~/w/i? "($self->{weight})":"").
             ($option=~/p/i? "<$self->{path}>":"").
             ($option=~/i/i? "[$self->{id}]":"")."\n";
   }
   
   sub setPaths{
     my ($self,$parentPath)=@_;
     my $path;
     if (!$parentPath){
		 $self->{path}="root";
		 $self->{view}->{type}="root";
	 }
	 else{
		 $self->{path}=$parentPath."->".$self->{id};
		 $self->{view}->{type}="leaf";
	 }
     my @children=$self->children("node"); my $kidsFound=0;
     foreach (@children){
		if($_){
		   $_->setPaths($self->{path});
		   $kidsFound=1;
	   }
	 };
	 $self->{view}->{type}="group" if $kidsFound && $self->{path} ne "root"; ;
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
