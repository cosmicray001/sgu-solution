{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p164.in';
    OutFile    = 'p164.out';
    Limit      = 200;

Type
    Tdata      = array[1..Limit , 1..Limit] of integer;

Var
    data       : Tdata;
    answer , N ,
    C          : integer;

procedure init;
var
    i , j      : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , C);
      for i := 1 to N do
        for j := 1 to N do
          read(data[i , j]);
//    Close(INPUT);
end;

procedure work;
var
    i , j , k  : integer;
begin
    for i := 1 to N do
      for j := 1 to N do
        if data[i , j] <= (C + 1) div 2 then
          data[i , j] := 1
        else
          data[i , j] := 4;

    for k := 1 to N do
      for i := 1 to N do
        for j := 1 to N do
          if data[i , k] + data[k , j] < data[i , j] then
            data[i , j] := data[i , k] + data[k , j];

    answer := 1;
    for i := 1 to N do
      for j := 1 to N do
        if data[i , j] >= 4 then
          begin
              answer := 2;
              exit;
          end;
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if answer = 1 then
        begin
            writeln((C + 1) div 2);
            for i := 1 to (C + 1) div 2 do
              write(i , ' ');
            writeln;
        end
      else
        begin
            writeln(C - (C + 1) div 2);
            for i := (C + 1) div 2 + 1 to C do
              write(i , ' ');
            writeln;
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
