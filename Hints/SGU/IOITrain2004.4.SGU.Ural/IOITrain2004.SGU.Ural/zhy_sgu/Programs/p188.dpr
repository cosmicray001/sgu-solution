{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p188.in';
    OutFile    = 'p188.out';
    Limit      = 20;
    Len        = 1000;
    minimum    = 1e-6;

Type
    Tdata      = array[1..Limit] of
                   record
                       L , V , times         : longint;
                   end;

Var
    data       : Tdata;
    N , T      : longint;

procedure init;
var
    i          : longint;
begin
    fillchar(data , sizeof(data) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , T);
      for i := 1 to N do
        read(data[i].L);
      for i := 1 to N do
        read(data[i].V);
//    Close(INPUT);
end;

procedure work;
var
    i , j      : longint;
    t1 , L1 ,
    t2 , t3    : extended;
begin
    for i := 1 to N do
      for j := 1 to N do
        if (i <> j) and ((data[i].V > 0) xor (data[j].V > 0)) then
          begin
              L1 := data[i].L - data[j].L;
              if data[i].V > 0 then L1 := -L1;
              if L1 < 0 then L1 := L1 + Len;
              t1 := L1 / (abs(data[i].V) + abs(data[j].V));
              t2 := T - t1;
              if t2 > -minimum then inc(data[i].times);
              t3 := Len / (abs(data[i].V) + abs(data[j].V));
              t2 := t2 / t3;
              data[i].times := data[i].times + trunc(t2 + minimum);
          end;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to N do
        begin
            write(data[i].times);
            if i = N
              then writeln
              else write(' ');
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
