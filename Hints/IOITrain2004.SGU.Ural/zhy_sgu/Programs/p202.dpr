{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p202.in';
    OutFile    = 'p202.out';
    Limit      = 65;

Type
    Tdata      = array[1..Limit , 1..Limit] of extended;
    Tstrategy  = array[1..Limit , 1..Limit] of longint;
    Tstack     = array[1..Limit] of
                   record
                       tot    : longint;
                       data   : array[1..Limit] of longint;
                   end;

Var
    data       : Tdata;
    strategy   : Tstrategy;
    stack      : Tstack;
    N , M      : longint;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
//    Close(INPUT);
end;

procedure dfs(N , M : longint);
var
    k          : longint;
begin
    if data[N , M] >= 0 then exit;
    if N = 1
      then data[N , M] := 1
      else if M = 3
             then begin
                      dfs(N - 1 , M);
                      data[N , M] := data[N - 1 , M] * 2 + 1;
                      strategy[N , M] := N - 1;
                  end
             else begin
                      dfs(1 , M);
                      dfs(N - 1 , M - 1);
                      data[N , M] := data[1 , M] * 2 + data[N - 1 , M - 1];
                      strategy[N , M] := 1;
                      for k := 2 to N - 1 do
                        begin
                            dfs(k , M);
                            dfs(N - k , M - 1);
                            if data[k , M] * 2 + data[N - k , M - 1] < data[N , M] then
                              begin
                                  data[N , M] := data[k , M] * 2 + data[N - k , M - 1];
                                  strategy[N , M] := k;
                              end;
                        end;
                  end;
end;

procedure work;
var
    i , j      : longint;
begin
    for i := 1 to N do
      for j := 1 to M do
        data[i , j] := -1;
    dfs(N , M);
end;

procedure _move(number , st , ed : longint);
begin
    write('move ' , number , ' from ' , st , ' to ' , ed);
    if stack[ed].tot <> 0 then
      write(' atop ' , stack[ed].data[stack[ed].tot]);
    writeln;
    inc(stack[ed].tot);
    stack[ed].data[stack[ed].tot] := number;
    dec(stack[st].tot);
end;

procedure print(min , count , st , ed , sum : longint);
var
    i , k      : longint;
begin
    if count = 1
      then _move(min , st , ed)
      else begin
               i := 1;
               while ((stack[i].tot <> 0) and (min > stack[i].data[stack[i].tot])) or (i = st) or (i = ed) do
                 inc(i);
               k := strategy[count , sum];
               print(min , k , st , i , sum);
               print(min + k , count - k , st , ed , sum - 1);
               print(min , k , i , ed , sum);
           end;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(data[N , M] : 0 : 0);
      fillchar(stack , sizeof(stack) , 0);
      stack[1].tot := N;
      for i := 1 to N do
        stack[1].data[N - i + 1] := i;
      print(1 , N , 1 , M , M);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
