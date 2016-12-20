{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p214.in';
    OutFile    = 'p214.out';
    Limit      = 2000;

Type
    Topt       = array[1..Limit + 1 , 1..Limit + 1] of
                   record
                       cost                  : longint;
                       strategy              : byte;
                   end;
    Tstr       = array[1..Limit] of char;
    Tmap       = array[#33..#255 , #33..#255] of longint;
    Tbest      = array[#33..#255] of
                   record
                       cost                  : longint;
                       choose                : char;
                   end;

Var
    opt        : Topt;
    s1 , s2 ,
    alphabet   : Tstr;
    map        : Tmap;
    b1 , b2    : Tbest;
    M , L1 , L2: longint;

procedure read_str(var s : Tstr; var Len : longint);
begin
    Len := 0;
    while not seekeoln do
      begin
          inc(Len);
          read(s[Len]);
      end;
    readln;
end;

procedure init;
var
    i , j      : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      M := 0; L1 := 0; L2 := 0;
      fillchar(opt , sizeof(opt) , 0);
      fillchar(s1 , sizeof(s1) , 0); fillchar(s2 , sizeof(s2) , 0);
      fillchar(map , sizeof(map) , 0);
      fillchar(b1 , sizeof(b1) , 0); fillchar(b2 , sizeof(b2) , 0);
      read_str(alphabet , M);
      read_str(s1 , L1); read_str(s2 , L2);
      for i := 1 to M do
        for j := 1 to M do
          read(map[alphabet[i] , alphabet[j]]);
//    Close(INPUT);
end;

procedure Get_Best;
var
    i , j      : longint;
begin
    for i := 1 to M do
      for j := 1 to M do
        begin
            if (b1[alphabet[i]].choose = #0) or (b1[alphabet[i]].cost > map[alphabet[i] , alphabet[j]]) then
              begin
                  b1[alphabet[i]].cost := map[alphabet[i] , alphabet[j]];
                  b1[alphabet[i]].choose := alphabet[j];
              end;
            if (b2[alphabet[j]].choose = #0) or (b2[alphabet[j]].cost > map[alphabet[i] , alphabet[j]]) then
              begin
                  b2[alphabet[j]].cost := map[alphabet[i] , alphabet[j]];
                  b2[alphabet[j]].choose := alphabet[i];
              end;
        end;
end;

procedure work;
var
    i , j , tmp: longint;
begin
    Get_Best;
    for i := L2 downto 1 do
      begin
          opt[L1 + 1 , i].strategy := 2;
          opt[L1 + 1 , i].cost := opt[L1 + 1 , i + 1].cost + b2[s2[i]].cost;
      end;
    for i := L1 downto 1 do
      begin
          opt[i , L2 + 1].strategy := 1;
          opt[i , L2 + 1].cost := opt[i + 1 , L2 + 1].cost + b1[s1[i]].cost;
      end;
    for i := L1 downto 1 do
      for j := L2 downto 1 do
        begin
            opt[i , j].strategy := 3; opt[i , j].cost := opt[i + 1 , j + 1].cost + map[s1[i] , s2[j]];

            tmp := opt[i + 1 , j].cost + b1[s1[i]].cost;
            if tmp < opt[i , j].cost then
              begin opt[i , j].strategy := 1; opt[i , j].cost := tmp; end;

            tmp := opt[i , j + 1].cost + b2[s2[j]].cost;
            if tmp < opt[i , j].cost then
              begin opt[i , j].strategy := 2; opt[i , j].cost := tmp; end;
        end;
end;

procedure out;
var
    i , j      : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(opt[1 , 1].cost);
      i := 1; j := 1;
      while (i <= L1) or (j <= L2) do
        case opt[i , j].strategy of
          3    : begin write(s1[i]); inc(i); inc(j); end;
          1    : begin write(s1[i]); inc(i); end;
          2    : begin write(b2[s2[j]].choose); inc(j); end;
        end;
      writeln;
      i := 1; j := 1;
      while (i <= L1) or (j <= L2) do
        case opt[i , j].strategy of
          3    : begin write(s2[j]); inc(i); inc(j); end;
          1    : begin write(b1[s1[i]].choose); inc(i); end;
          2    : begin write(s2[j]); inc(j); end;
        end;
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
