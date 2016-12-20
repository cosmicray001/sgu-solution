{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p223.in';
    OutFile    = 'p223.out';
    Limit      = 10;
    LimitM     = 1 shl Limit;

Type
    Tvalid     = array[1..LimitM] of longint;
    Tconflict  = array[1..LimitM , 1..LimitM] of boolean;
    Topt       = array[0..Limit , 0..Limit * Limit , 1..LimitM] of comp; 

Var
    valid ,
    count      : Tvalid;
    conflict   : Tconflict;
    opt        : Topt;
    N , K , M  : longint;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , K);
//    Close(INPUT);
end;

function check_valid(num : longint; var count : longint) : boolean;
var
    last       : longint;
begin
    last := 0; check_valid := false; count := 0;
    while num > 0 do
      begin
          if (last = 1) and odd(num) then exit;
          last := num mod 2;
          inc(count , last);
          num := num div 2;
      end;
    check_valid := true;
end;

procedure pre_process;
var
    i , j , tmp: longint;
begin
    M := 0;
    for i := 0 to 1 shl N - 1 do
      if check_valid(i , count[M + 1]) then
        begin
            inc(M);
            valid[M] := i;
        end;
    for i := 1 to M do
      for j := 1 to M do
        conflict[i , j] := not ((valid[i] and valid[j] = 0) and check_valid(valid[i] or valid[j] , tmp));
end;

procedure work;
var
    i , j , k ,
    p , largest ,
    newlargest : longint;
begin
    pre_process;

    fillchar(opt , sizeof(opt) , 0);
    opt[0 , 0 , 1] := 1; largest := 0;
    for i := 1 to N do
      begin
          newlargest := 0;
          for j := 0 to N + largest do
            for k := 1 to M do
              if count[k] <= j then
                begin
                    for p := 1 to M do
                      if not conflict[k , p] then
                        opt[i , j , k] := opt[i , j , k] + opt[i - 1 , j - count[k] , p];
                    if (opt[i , j , k] > 0) and (j > newlargest) then
                      newlargest := j;
                end;
          largest := newlargest;
      end;
end;

procedure out;
var
    i          : longint;
    answer     : comp;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      answer := 0;
      for i := 1 to M do
        answer := answer + opt[N , K , i];
      writeln(answer : 0 : 0);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
