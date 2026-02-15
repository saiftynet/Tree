use lib "../modules/";
use strict; use warnings;
use Test::Simple tests => 19;
use Node;
my $op;my $clone;
my $noname=new Node({name=>"name"});
ok( defined($noname) && ref $noname eq 'Node',     'new({<node data>}) works' );
my $trunk=new Node("Trunk");
ok( defined($trunk) && ref $trunk eq 'Node',       'new("namestring") works' );

$trunk->addChild(qw/mammal reptile bird insect fish mollusc miriapod crustacea/);
ok( scalar keys %{$trunk->{branches}} eq 8,       'addChild(ARRAY) works' );

ok( scalar $trunk->children() eq 8,               'children() works' );
my $testNode=new Node("nematode");
$trunk->addChild($testNode);
ok( scalar $trunk->children() eq 9,               'addChild(NODE) works' );
$trunk->deleteChild($trunk->{prefix}.2);
ok( scalar $trunk->children() eq 8,                'deleteChild(NODE) works' );


print "\n";
ok( print $trunk->drawTree(),                            'drawTree() works');

ok ($trunk->{branches}->{$trunk->childByName("insect")}->addChild("ant"));
ok ($trunk->group("arthropod",$trunk->childrenByNames(qw/insect miriapod crustacea/)), 'group() works');

print "\n";
print $trunk->childByName("arthropod"),"\n";

print "\n";
ok( print $trunk->drawTree("i"),                            'drawTree("i") works');
print "\n";
ok(! $trunk->list(),                            'list() works');
print "\n";
ok( $op= $trunk->serialise(),                            'serialise() works');
print "\n";
print $op;
print "\n";
ok( $clone=Node::deserialise($op),                            'deserialise() works');
ok( print $clone->drawTree("p"),                            'drawTree("p") works');
print "\n";
ok( ! $clone->ungroup($clone->childByName("arthropod")), 'ungroup() works');
$clone->setPaths();
print "\n";
$op= $clone->serialise();
print "\n";
ok( print $clone->drawTree("uc"),                            'drawTree("u") works');
print "\n";
ok( $clone->randomChild("node")->name(),             'randomChild works');
print "\n";
my $ranChild= $clone->randomChild("node");
my $path=$ranChild->{path};
print $ranChild->name()," - ",$ranChild->{path},"\n";
print $clone->target($path)->name(),"\n";
ok ($ranChild->name() eq $clone->target($path)->name(), 'target works');
ok ($clone->target($path)->parent($clone)->name() eq $clone->name(), 'parent works');
