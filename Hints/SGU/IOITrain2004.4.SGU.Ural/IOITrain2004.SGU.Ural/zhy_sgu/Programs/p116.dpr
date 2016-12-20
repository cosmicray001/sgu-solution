{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p116.in';
    OutFile    = 'p116.out';
    Limit      = 10000;
    LimitPrime = 1500;
    LimitSuper = 300;

Type
    Tsuper     = record
                     total    : integer;
                     data     : array[1..LimitSuper] of integer;
                 end;
    Tdata      = array[0..Limit] of
                   record
                       usenum , mintimes     : integer;
                   end;

Var
    super      : Tsuper;
    data       : Tdata;
    N          : integer;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N);
//    Close(INPUT);
end;

procedure Get_Super;
type
    Tprime     = array[1..Limit] of boolean;
    TprimeList = array[1..LimitPrime] of integer;
var
    i , j ,
    total      : integer;
    prime      : Tprime;
    primeList  : TprimeList;
begin
    fillchar(super , sizeof(super) , 0);
    fillchar(prime , sizeof(prime) , true);
    prime[1] := false;
    for i := 2 to Limit do
      if prime[i] then
        for j := 2 to Limit div i do
          prime[i * j] := false;
    total := 0;
    for i := 1 to Limit do
      if prime[i] then
        begin
            inc(total);
            primeList[total] := i;
        end;
    for i := 1 to total do
      if primeList[primeList[i]] <= Limit then
        with super do
          begin
              inc(total);
              data[total] := primeList[primeList[i]];
          end
      else
        break;
end;

procedure work;
var
    i , k      : integer;
begin
    Get_Super;
    
    fillchar(data , sizeof(data) , 0);
    for i := 1 to N do
      data[i].mintimes := -1;

    for k := 1 to super.total do
      for i := 0 to N - super.data[k] do
        if data[i].mintimes >= 0 then
          if (data[i + super.data[k]].mintimes = -1) or (data[i + super.data[k]].mintimes >= data[i].mintimes + 1) then
            begin
                data[i + super.data[k]].mintimes := data[i].mintimes + 1;
                data[i + super.data[k]].usenum := super.data[k];
            end;
end;

procedure out;
type
    Toutseq    = array[1..Limit] of integer;
var
    outseq     : Toutseq;
    total , tmp ,
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if data[N].mintimes = -1 then
        writeln(0)
      else
        begin
            total := 0;
            tmp := N;
            while tmp <> 0 do
              begin
                  inc(total);
                  outseq[total] := data[tmp].usenum;
                  dec(tmp , data[tmp].usenum);
              end;
            writeln(total);
            for i := 1 to total - 1 do
              write(outseq[i] , ' ');
            writeln(outseq[total]);
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
