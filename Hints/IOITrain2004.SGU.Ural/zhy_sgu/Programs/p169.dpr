{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p169.in';
    OutFile    = 'p169.out';

Var
    N , answer : integer;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
//    Close(INPUT);
end;

procedure work;
begin
    if N = 1 then
      answer := 8
    else
      begin
          answer := 1;
          if (N - 1) mod 3 = 0 then
            inc(answer , 2);
          if (N - 1) mod 6 = 0 then
            inc(answer);
      end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
