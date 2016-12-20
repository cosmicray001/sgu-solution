{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p124.in';
    OutFile    = 'p124.out';
    Limit      = 10000;

Type
    Tpoint     = record
                     x , y    : integer;
                 end;
    TLine      = record
                     p1 , p2  : Tpoint;
                 end;
    Tdata      = array[1..Limit] of TLine;
    Tnums      = array[1..Limit] of integer;

Var
    data       : Tdata;
    N , answer ,
    total      : integer;
    p          : Tpoint;
    nums       : Tnums;

procedure init;
var
    tp         : Tpoint;
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        with data[i] do
          begin
              read(p1.x , p1.y , p2.x , p2.y);
              if (p1.x > p2.x) or (p1.y > p2.y) then
                begin
                    tp := p1; p1 := p2; p2 := tp;
                end;
          end;
      read(p.x , p.y);
//    Close(INPUT);
end;

function inside(n1 , n2 , n3 : integer) : boolean;
begin
    if (n1 <= n2) and (n2 <= n3) then
      inside := true
    else
      inside := false;
end;

procedure qk_pass(start , stop : integer; var mid : integer);
var
    tmp , key  : integer;
begin
    tmp := random(stop - start + 1) + start;
    key := nums[tmp]; nums[tmp] := nums[start];
    while start < stop do
      begin
          while (start < stop) and (nums[stop] > key) do dec(stop);
          nums[start] := nums[stop];
          if start < stop then inc(start);
          while (start < stop) and (nums[start] < key) do inc(start);
          nums[stop] := nums[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    nums[start] := key;
end;

procedure qk_sort(start , stop : integer);
var
    mid        : integer;
begin
    if start < stop then
      begin
          qk_pass(start , stop , mid);
          qk_sort(start , mid - 1);
          qk_sort(mid + 1 , stop);
      end;
end;

procedure work;
var
    i , sum    : integer;
begin
    for i := 1 to N do
      if inside(data[i].p1.x , p.x , data[i].p2.x) and inside(data[i].p1.y , p.y , data[i].p2.y) then
        begin
            answer := 3;
            exit;
        end;

    total := 0;
    for i := 1 to N do
      if (data[i].p1.y = data[i].p2.y) and inside(data[i].p1.x , p.x , data[i].p2.x) then
        begin
            inc(total);
            nums[total] := data[i].p1.y;
        end;
    qk_sort(1 , total);
    sum := 0;
    for i := 1 to total do
      if (nums[i] < p.y) and ((i = 1) or (nums[i] <> nums[i - 1])) then
        inc(sum);
    if odd(sum) then
      answer := 1
    else
      answer := 2;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      case answer of
        1      : writeln('INSIDE');
        2      : writeln('OUTSIDE');
        3      : writeln('BORDER');
      end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
