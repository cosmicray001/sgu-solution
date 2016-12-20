{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p163.in';
    OutFile    = 'p163.out';

Var
    answer ,
    power      : integer;

procedure init;
var
    i , N , p ,
    j , num    : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , power);
      answer := 0;
      for i := 1 to N do
        begin
            read(p);
            num := 1;
            for j := 1 to power do
              num := num * p;
            if num > 0 then
              inc(answer , num);
        end;
//    Close(INPUT);
end;

procedure work;
begin

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
