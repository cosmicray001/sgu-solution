{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p146.in';
    OutFile    = 'p146.out';

Var
    N          : integer;
    L , Len    : extended;

procedure init;
var
    V , T      : extended;
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(L , N);
      len := 0;
      for i := 1 to N do
        begin
            read(V , T);
            len := len + V * T;
        end;
//    Close(INPUT);
end;

procedure work;
begin
    Len := Len - int(int(Len / L) / 10000) * 10000 * L;
    Len := Len - int(Len / L) * L;
    if Len > L / 2 then
      Len := L - Len; 
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(Len : 0 : 4);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
