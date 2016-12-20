{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p201.in';
    OutFile    = 'p201.out';
    LimitN     = 60;
    LimitK     = 1000;
    LimitSigma = 26;
    LimitLen   = 90;
    LimitBase  = 10000000;
    LimitSeg   = 7;

Type
    Tmap       = array[1..LimitK , 1..LimitSigma] of longint;
    lint       = record
                     len      : longint;
                     data     : array[1..LimitLen div LimitSeg + 1] of longint;
                 end;
    Topt       = array[0..LimitN , 1..LimitK] of lint;
    Tnum       = array[1..LimitK] of longint;
    Tvisited   = array[1..LimitK] of boolean;

Var
    map , X ,
    newmap     : Tmap;
    opt        : Topt;
    mark       : Tnum;
    visited    : Tvisited;
    N ,  K , S ,
    Sigma      : longint;

procedure init;
var
    i , L , j  : longint;
    c          : char;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      Sigma := 0;
      while not seekeoln do
        begin
            read(c);
            inc(Sigma);
        end;
      readln;
      fillchar(mark , sizeof(mark) , 0);
      read(K , S , L);
      mark[S] := 1;
      while L > 0 do
        begin
            read(i);
            mark[i] := 2;
            dec(L);
        end;
      for i := 1 to K do
        for j := 1 to Sigma do
          read(map[i , j]);
      for i := 1 to K do
        for j := 1 to Sigma do
          read(X[i , j]);
      read(N);
//    Close(INPUT);
end;

procedure color(root , i : longint);
begin
    if visited[root] then
      begin
          newmap[root , i] := -1;
          exit;
      end;
    visited[root] := true;
    if X[root , i] = 0
      then newmap[root , i] := map[root , i]
      else if newmap[map[root , i] , i] <> 0
             then newmap[root , i] := newmap[map[root , i] , i]
             else begin
                      color(map[root , i] , i);
                      newmap[root , i] := newmap[map[root , i] , i];
                  end;
end;

procedure ReDraw;
var
    i , j      : longint;
begin
    fillchar(newmap , sizeof(newmap) , 0);
    for i := 1 to Sigma do
      begin
          fillchar(visited , sizeof(visited) , 0);
          for j := 1 to K do
            if not visited[j] then
              color(j , i);
      end;
    map := newmap;
end;

procedure add(num1 , num2 : lint; var num3 : lint);
var
    i , jw ,
    tmp        : longint;
begin
    fillchar(num3 , sizeof(num3) , 0);
    i := 1; jw := 0;
    while (i <= num1.len) or (i <= num2.len) or (jw <> 0) do
      begin
          tmp := num1.data[i] + num2.data[i] + jw;
          jw := tmp div LimitBase;
          num3.data[i] := tmp mod LimitBase;
          inc(i);
      end;
    num3.len := i - 1;
end;

procedure work;
var
    i , j , p  : longint;
begin
    ReDraw;

    fillchar(opt , sizeof(opt) , 0);
    for i := 0 to N do
      for j := 1 to K do
        opt[i , j].len := 1;
    for j := 1 to K do
      if mark[j] = 2 then
        opt[0 , j].data[1] := 1;
    for i := 1 to N do
      for j := 1 to K do
        for p := 1 to Sigma do
          if map[j , p]> 0 then
            add(opt[i , j] , opt[i - 1 , map[j , p]] , opt[i , j]);
end;

procedure out;
var
    i          : longint;
    st         : string;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := opt[N , S].len downto 1 do
        if i = opt[N , S].len
          then write(opt[N , S].data[i])
          else begin
                   str(opt[N , S].data[i] , st);
                   while length(st) < LimitSeg do
                     st := '0' + st;
                   write(st);
               end;
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
