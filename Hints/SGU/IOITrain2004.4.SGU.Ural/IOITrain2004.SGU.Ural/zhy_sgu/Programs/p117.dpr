{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p117.in';
    OutFile    = 'p117.out';
    Limit      = 10000;
    LimitCount = 20;

Type
    Tdata      = array[1..Limit] of integer;
    Tprimes    = array[1..LimitCount] of
                   record
                       num , times           : integer;
                   end;

Var
    data       : Tdata;
    primes     : Tprimes;
    N , M , K ,
    sum , total: integer;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M , K);
      for i := 1 to N do
        read(data[i]);
//    Close(INPUT);
end;

function check(num : integer) : boolean;
var
    i , tmp    : integer;
begin
    for i := 1 to total do
      begin
          tmp := 0;
          while num mod primes[i].num = 0 do
            begin
                inc(tmp);
                num := num div primes[i].num;
            end;
          if tmp * M < primes[i].times then
            begin
                check := false;
                exit;
            end;
      end;
   check := true;
end;

procedure work;
var
    i          : integer;
begin
    total := 0;
    i := 2;
    while k <> 1 do
      begin
          if k mod i = 0 then
            begin
                inc(total);
                primes[total].num := i;
                primes[total].times := 0;
                while k mod i = 0 do
                  begin
                      inc(primes[total].times);
                      k := k div i;
                  end;
            end;
          inc(i);
      end;
      
    sum := 0;
    for i := 1 to N do
      if check(data[i]) then
        inc(sum);
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(sum);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
