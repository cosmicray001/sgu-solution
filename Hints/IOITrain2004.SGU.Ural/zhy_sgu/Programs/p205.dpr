{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p205.in';
    OutFile    = 'p205.out';
    Limit      = 1000;
    LimitM     = 128;

Type
    Tdata      = array[1..Limit] of longint;
    Tnum       = array[0..LimitM , 0..LimitM] of longint;
    Topt       = array[1..Limit , 0..LimitM] of
                   record
                       min , strategy        : longint;
                   end;

Var
    data       : Tdata;
    num        : Tnum;
    opt        : Topt;
    N , M , S  : longint;

procedure init;
var
    i , j      : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do read(data[i]);
      read(M , S);
      dec(M); dec(S);
      for i := 0 to M do
        for j := 0 to S do
          read(num[i , j]);
//    Close(INPUT);
end;

procedure work;
var
    i , j , k ,
    tmp        : longint;
begin
    fillchar(opt , sizeof(opt) , $7F);
    for j := 0 to M do
      for k := 0 to S do
        if opt[N , j].min > abs(num[j , k] - data[N]) then
          begin
              opt[N , j].min := abs(num[j , k] - data[N]);
              opt[N , j].strategy := k;
          end;
    for i := N - 1 downto 1 do
      for j := 0 to M do
        for k := 0 to S do
          begin
              tmp := abs(num[j , k] - data[i]) + opt[i + 1 , k and M].min;
              if opt[i , j].min > tmp then
                begin
                    opt[i , j].min := tmp;
                    opt[i , j].strategy := k;
                end;
          end;
end;

procedure out;
var
    i , j      : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(opt[1 , 0].min);
      j := 0;
      for i := 1 to N do
        begin
            j := opt[i , j].strategy;
            write(j , ' ');
            j := j and M;
        end;
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
