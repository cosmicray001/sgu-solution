{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
{$MINSTACKSIZE $04000000}
{$MAXSTACKSIZE $04000000}
Const
    InFile     = 'p195.in';
    OutFile    = 'p195.out';
    Limit      = 500000;

Type
    Tnum       = array[1..Limit] of longint;
    Topt       = array[0..1 , 1..Limit] of longint;
    Tanswer    = array[1..Limit] of boolean;

Var
    father ,
    children ,
    index ,
    count ,
    strategy   : Tnum;
    opt        : Topt;
    answer     : Tanswer;
    N          : longint;

procedure init;
var
    i          : longint;
begin
    fillchar(father , sizeof(father) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 2 to N do
        read(father[i]);
//    Close(INPUT);
end;

procedure pre_process;
var
    i          : longint;
begin
    fillchar(count , sizeof(count) , 0);
    fillchar(index , sizeof(index) , 0);
    for i := 2 to N do
      inc(count[father[i]]);
    index[1] := 1;
    for i := 2 to N do
      index[i] := index[i - 1] + count[i - 1];
    fillchar(count , sizeof(count) , 0);
    for i := 2 to N do
      begin
          children[count[father[i]] + index[father[i]]] := i;
          inc(count[father[i]]);
      end;
end;

procedure dfs(root : longint);
var
    i          : longint;
begin
    opt[1 , root] := 0;
    for i := index[root] to index[root] + count[root] - 1 do
      begin
          dfs(children[i]);
          inc(opt[1 , root] , opt[0 , children[i]]);
      end;
    opt[0 , root] := opt[1 , root];
    strategy[root] := 0;
    for i := index[root] to index[root] + count[root] - 1 do
      if opt[1 , root] - opt[0 , children[i]] + opt[1 , children[i]] > opt[0 , root] then
        begin
            opt[0 , root] := opt[1 , root] - opt[0 , children[i]] + opt[1 , children[i]];
            strategy[root] := children[i];
        end;
    inc(opt[1 , root]);
end;

procedure dfs_out(color , root : longint);
var
    i          : longint;
begin
    if color = 1
      then begin
               answer[root] := true;
               for i := index[root] to index[root] + count[root] - 1 do
                 dfs_out(0 , children[i]);
           end
      else for i := index[root] to index[root] + count[root] - 1 do
             if children[i] = strategy[root]
               then dfs_out(1 , children[i])
               else dfs_out(0 , children[i]);
end;

procedure work;
begin
    pre_process;
    dfs(1);

    fillchar(answer , sizeof(answer) , 0);
    dfs_out(0 , 1);
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if opt[0 , 1] = 0
        then writeln(0)
        else writeln(opt[0 , 1] , '000');
      for i := 1 to N do
        if answer[i] then
          write(i , ' ');
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
