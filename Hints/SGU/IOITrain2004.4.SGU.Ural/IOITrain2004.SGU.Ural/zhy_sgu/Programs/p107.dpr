{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p107.in';
    OutFile    = 'p107.out';

Var
    N          : integer;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
//    Close(INPUT);
end;

procedure work;
begin

end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReSet(OUTPUT);
      if N < 9 then
        writeln(0)
      else
        if N = 9 then
          writeln(8)
        else
          begin
              write(72);
              for i := 1 to N - 10 do
                write(0);
              writeln;
          end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
