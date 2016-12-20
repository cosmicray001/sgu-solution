//Writeln on 2009/01/26
program Flower;
var
 i,j,f,v :integer;
 way     :array[1..100] of integer;
 a,opt   :array[0..100,0..100] of integer; //[Flower,Vase]

//
function max (a,b :integer) :integer;
begin
 if a>b then max :=a else max :=b;
end;
//
procedure main;
var
 i,j :integer;
begin
 fillchar(opt,sizeof(opt),0);
 for i:=1 to v do
  opt[i,i] :=opt[i-1,i-1]+a[i,i];
 for j := 1 to v do
  for i := 1 to j-1 do
   opt[i,j] :=max(opt[i-1,j-1]+a[i,j],opt[i,j-1]);
 writeln(opt[f,v]);
 //
 for i := f downto 1 do
  begin
   while opt[i-1,v-1]+a[i,v]<opt[i,v] do
    dec(v);
   way[i] :=v;
   dec(v);
  end;
 for i := 1 to f-1 do write(way[i],' ');
 writeln(way[f]);
end;
begin
 assign(input,'flower.in');
 reset(input);
 assign(output,'flower.out');
 rewrite(output);
 readln(f,v);
 for i := 1 to f do
  for j := 1 to v do read(a[i,j]);
 main;
 close(input);
 close(output);
end.
