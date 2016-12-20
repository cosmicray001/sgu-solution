{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p123.in';
    OutFile    = 'p123.out';

Var
    answer     : extended;
    N          : integer;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
//    Close(INPUT);
end;

procedure work;
var
    a1 , a2 ,
    tmp        : extended;
    i          : integer;
begin
    a1 := 1; a2 := 1;
    if N <= 2 then
      answer := N
    else
      begin
          answer := 2;
          for i := 3 to N do
            begin
                tmp := a1 + a2;
                a1 := a2; a2 := tmp;
                answer := answer + tmp;
            end;
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
