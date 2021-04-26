#define x1 "Hello"
#define x2 "World"

#define str(i) x##i

puts( str(1) );
puts( str(2) ); 
