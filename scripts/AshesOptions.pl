use lib "../modules/";
use Node;
my $str="
[Options
  [Material gift
     [Chocolate]
     [Flowers]
     [Perfume]
     [Kitchen Utensil]
     [Football shirt]
  ] 
   [Verbal action
     [Sorry]
     [What can I do]
     [It's not that serious]
     [Lets move on]
     [Your hair looks nice]
     [Not fair ref, That was never a red card]
   ]
   [Creative gesture
     [Write poetry]
     [Make a card]
     [Make a football chart]
   ]
   [Thoughtful action
     [Make breakfast]
     [Foot rub]
     [Teach her football]
   ]
   [Together activity
     [Dinner date]
     [Take her to cinema]
     [Take her to pub]
     [Take her to football game]
   ]
   [Deflection
     [Look at that funny cloud]
     [I am a lumberjack and I'm okay]
     [A horse walked into a bar]
     [Your team is doing well]
   ]
  ]
]
";
my $options=Node::deserialise($str);
$options->drawTree();




gut(
"Buy chocolates",
"Buy flowers",
"Buy perfume",
"Buy football shirt",
"Say sorry",
"Ask what can I do?",
"Say it's not that serious",
"Say let's move on",
"Compliment her hair",
"Say Not fair ref, That was never a red card",
"Write Poetry",
"Make a card",
"Make her a football chart",
"Make breakfast",
"Give her a foot rub",
"Teach her football",
"Dinner date",
"Take her to cinema",
"Take her to pub",
"Take her to football game",
"Say Look at that funny cloud",
"Sing I am a lumberjack and I'm okay",
"Joke A horse walked into a bar",
"Say Your team is doing well",
);


sub gut{
  my @options=@_;
  print "\n\n My gut tells me I should....",
        $options[rand()*scalar @options],"\n";
}
