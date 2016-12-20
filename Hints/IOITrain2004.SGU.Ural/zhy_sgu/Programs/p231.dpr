{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p231.in';
    OutFile    = 'p231.out';
    Limit      = 1000000;

Type
    Tprime     = array[1..Limit] of boolean;

Var
    prime      : Tprime;
    N , answer : longint;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
//    Close(INPUT);
end;

procedure work;
var
    i , j      : longint;
begin
    fillchar(prime , sizeof(prime) , 1);
    prime[1] := false;
    answer := 0;
    for i := 2 to N do
      if prime[i] then
        begin
            if (i > 2) and prime[i - 2] then
              inc(answer);
            for j := 2 to N div i do
              prime[i * j] := false;
        end;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer);
      for i := 1 to N - 2 do
        if prime[i] and prime[i + 2] then
          writeln(2 , ' ' , i);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
