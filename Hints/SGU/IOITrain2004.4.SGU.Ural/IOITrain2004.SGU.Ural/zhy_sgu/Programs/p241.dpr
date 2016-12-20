{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p241.in';
    OutFile    = 'p241.out';
    Limit      = 20;
    LimitLen   = 50;

Type
    lint       = record
                     len                     : longint;
                     data                    : array[1..LimitLen] of smallint;
                 end;
    Topt       = array[0..1 , 0..Limit , 0..Limit , 0..Limit] of lint;

Var
    opt        : Topt;
    H1 , H2 , H3 ,
    W1 , W2 , W3 ,
    N , M , W , H ,
    K , now    : longint;
    answer     : lint;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M , W , H , K);
//    Close(INPUT);
end;

procedure times(const num1 : lint; num2 : longint; var num3 : lint);
var
    jw , tmp ,
    i          : longint;
begin
    fillchar(num3 , sizeof(num3) , 0);
    i := 1; jw := 0;
    while (i <= num1.len) or (jw <> 0) do
      begin
          tmp := num1.data[i] * num2 + jw;
          jw := tmp div 10;
          num3.data[i] := tmp mod 10;
          inc(i);
      end;
    num3.len := i - 1;
end;

procedure add(var num1 : lint; const num2 : lint);
var
    jw , tmp ,
    i          : longint;
begin
    i := 1; jw := 0;
    while (i <= num1.len) or (i <= num2.len) or (jw <> 0) do
      begin
          tmp := num1.data[i] + num2.data[i] + jw;
          jw := tmp div 10;
          num1.data[i] := tmp mod 10;
          inc(i);
      end;
    num1.len := i - 1;
end;

procedure work;
var
    i , 
    p1 , p2 , p3
               : longint;
    tmp        : lint;
begin
    if H > N then H := N;
    if W > N then W := N;
    H1 := H; H2 := N - H; H3 := M + H - N;
    if H3 < 0 then
      begin H1 := N - M; H2 := M; H3 := 0; end;
    W1 := W; W2 := N - W; W3 := M + W - N;
    if W3 < 0 then
      begin W1 := N - M; W2 := M; W3 := 0; end;
    fillchar(opt , sizeof(opt) , 0);
    opt[now , 0 , 0 , 0].len := 1; opt[now , 0 , 0 , 0].data[1] := 1;
    now := 0;
    for i := 1 to H1 + H2 + H3 do
      begin
          fillchar(opt[1 - now] , sizeof(opt[1 - now]) , 0);
          for p1 := 0 to W1 do
            for p2 := 0 to W2 do
              for p3 := 0 to W3 do
                if (opt[now , p1 , p2 , p3].len > 1) or (opt[now , p1 , p2 , p3].data[1] > 0) then
                   begin
                       add(opt[1 - now ,p1 , p2 , p3] , opt[now , p1 , p2 , p3]);
                       if (p1 < W1) and (i <= H1 + H2) then
                         begin
                             times(opt[now , p1 , p2 , p3] , W1 - p1 , tmp);
                             add(opt[1 - now , p1 + 1 , p2 , p3] , tmp);
                         end;
                       if p2 < W2 then
                         begin
                             times(opt[now , p1 , p2 , p3] , W2 - p2 , tmp);
                             add(opt[1 - now , p1 , p2 + 1 , p3] , tmp); 
                         end;
                       if (p3 < W3) and (i > H1) then
                         begin
                             times(opt[now , p1 , p2 , p3] , W3 - p3 , tmp);
                             add(opt[1 - now , p1 , p2 , p3 + 1] , tmp);
                         end;
                   end;
          now := 1 - now;
      end;
    fillchar(answer , sizeof(answer) , 0);
    answer.len := 1;
    for p1 := 0 to W1 do
      for p2 := 0 to W2 do
        if p1 + p2 <= K then
          begin
              p3 := K - p1 - p2;
              if p3 <= W3 then
                add(answer , opt[now , p1 , p2 , p3]);
          end;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := answer.len downto 1 do
        write(answer.data[i]);
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
