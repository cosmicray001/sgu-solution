{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p127.in';
    OutFile    = 'p127.out';
    Limit      = 8000;
    Base       = 1000;

Type
    Tdata      = array[0..9] of integer;

Var
    data       : Tdata;
    N , K ,
    answer     : integer;

procedure init;
var
    i , tmp    : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(K , N);
      for i := 1 to N do
        begin
            read(tmp);
            inc(data[tmp div Base]);
        end;
//    Close(INPUT);
end;

procedure work;
var
    i          : integer;
begin
    answer := 2;
    for i := 0 to 9 do
      if (i <> 0) and (i <> 8) then
        inc(answer , (data[i] + K - 1) div K);
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
