{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p203.in';
    OutFile    = 'p203.out';
    Limit      = 500000;

Type
    Tqueue     = record
                     open , closed           : longint;
                     data                    : array[1..Limit] of comp;
                 end;

Var
    A , B      : Tqueue;
    answer     : comp;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(A.closed); A.open := 1;
      for i := 1 to A.closed do
        read(A.data[i]);
//    Close(INPUT);
end;

procedure Get_Ele(var p : comp);
begin
    if A.open > A.closed
      then begin p := B.data[B.open]; inc(B.open); end
      else if B.open > B.closed
             then begin p := A.data[A.open]; inc(A.open); end
             else if A.data[A.open] < B.data[B.open]
                    then begin p := A.data[A.open]; inc(A.open); end
                    else begin p := B.data[B.open]; inc(B.open); end; 
end;

procedure work;
var
    i , N      : longint;
    p1 , p2    : comp;
begin
    B.open := 1; B.closed := 0;
    N := A.closed;
    answer := 0;
    for i := 1 to N - 1 do
      begin
          Get_Ele(p1);
          Get_Ele(p2);
          answer := answer + p1 + p2;
          inc(B.closed);
          B.data[B.closed] := p1 + p2;
      end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer : 0 : 0);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
