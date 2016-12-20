{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p126.in';
    OutFile    = 'p126.out';

Var
    A , B ,
    result     : integer;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(A , B);
//    Close(INPUT);
end;

procedure work;
var
    tmpS       : integer;
begin
    result := 0;
    tmpS := A + B;
    while true do
      if A mod tmpS = 0 then
        exit
      else
        if odd(tmpS) then
          begin
              result := -1;
              exit;
          end
        else
          begin
              inc(result);
              tmpS := tmpS div 2;
          end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(result);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
