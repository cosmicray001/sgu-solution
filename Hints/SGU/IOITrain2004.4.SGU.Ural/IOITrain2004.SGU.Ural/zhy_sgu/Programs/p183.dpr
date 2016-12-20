{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p183.in';
    OutFile    = 'p183.out';
    Limit      = 10000;
    LimitM     = 100;
    Module     = 201;

Type
    Topt       = array[0..Module , 1..LimitM] of longint;
    Tdata      = array[1..Limit] of longint;

Var
    opt        : Topt;
    data ,
    modnum     : Tdata;
    N , M , ans: longint;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
      for i := 1 to N do
        read(data[i]);
//    Close(INPUT);
end;

procedure work;
var
    i , j , k ,
    min , now  : longint;
begin
    for i := 1 to N do
      modnum[i] := i mod Module;
      
    for k := 1 to N - 1 do
      begin
          min := -1;
          for i := M - 1 downto 1 do
            begin
                j := M - i;
                if k - j > 0 then now := opt[modnum[k] , j] else now := data[k];
                if (min = -1) or (now < min) then min := now;
                if (i + k <= N) then
                  opt[modnum[i + k] , i] := min + data[i + k];
            end;
      end;
    ans := -1;
    for i := N downto N - M + 2 do
      for k := i - 1 downto N - M + 1 do
        if (ans = -1) or (opt[modnum[i] , i - k] < ans) then
          ans := opt[modnum[i] , i - k];
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(ans);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
