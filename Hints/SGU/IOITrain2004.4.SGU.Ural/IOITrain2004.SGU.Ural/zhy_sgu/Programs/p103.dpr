{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p103.in';
    OutFile    = 'p103.out';
    Limit      = 300;
    LimitTime  = 410;

Type
    Tdata      = array[1..Limit , 1..Limit] of integer;
    Tjunction  = array[1..Limit] of
                   record
                       remain , blue , purple               : integer;
                   end;
    Tshortest  = array[1..Limit] of
                   record
                       shortest , father                    : integer;
                   end;
    Tvisited   = array[1..Limit] of boolean;
    Tpath      = record
                     total    : integer;
                     data     : array[1..Limit] of integer;
                 end;

Var
    data       : Tdata;
    junction   : Tjunction;
    shortest   : Tshortest;
    visited    : Tvisited;
    path       : Tpath;
    N , start ,
    stop ,
    M          : integer;

procedure init;
var
    i , p1 , p2 ,
    t          : integer;
    initial    : char;
begin
    fillchar(data , sizeof(data) , $FF);
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(start , stop);
      readln(N , M);
      for i := 1 to N do
        with junction[i] do
          begin
              readln(initial , remain , blue , purple);
              if initial = 'B' then
                inc(remain , purple);
          end;
      for i := 1 to M do
        begin
            read(p1 , p2 , t);
            data[p1 , p2] := t;
            data[p2 , p1] := t;
        end;
//    Close(INPUT);
end;

function waittime(source , target , time : integer) : integer;
var
    ans ,
    add1 , add2 ,
    modnum1 ,
    modnum2    : integer;
begin
    ans := 0;
    add1 := time - junction[source].remain + (junction[source].blue + junction[source].purple) * 2;
    add2 := time - junction[target].remain + (junction[target].blue + junction[target].purple) * 2;
    modnum1 := junction[source].blue + junction[source].purple;
    modnum2 := junction[target].blue + junction[target].purple;
    while ans <= LimitTime do
      if ((ans + add1) mod modnum1 < junction[source].blue) = ((ans + add2) mod modnum2 < junction[target].blue) then
        begin
            waittime := ans;
            exit;
        end
      else
        inc(ans);
    waittime := -maxlongint;
end;

procedure work;
var
    i , min ,
    tmp        : integer;
begin
    fillchar(shortest , sizeof(shortest) , $FF);
    fillchar(visited , sizeof(visited) , 0);
    shortest[start].shortest := 0; shortest[start].father := 0;

    while not visited[stop] do
      begin
          min := 0;
          for i := 1 to N do
            if not visited[i] and (shortest[i].shortest >= 0) then
              if (min = 0) or (shortest[i].shortest < shortest[min].shortest) then
                min := i;

          if min = 0 then
            break;
          visited[min] := true;

          for i := 1 to N do
            if not visited[i] and (data[min , i] >= 0) then
              begin
                  tmp := waittime(min , i , shortest[min].shortest) + shortest[min].shortest + data[min , i];
                  if tmp >= 0 then
                    if (shortest[i].shortest < 0) or (shortest[i].shortest > tmp) then
                      begin
                          shortest[i].shortest := tmp;
                          shortest[i].father := min;
                      end;
              end;
      end;
end;

procedure out;
var
    p          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if visited[stop] then
        begin
            writeln(shortest[stop].shortest);
            path.total := 0;
            p := stop;
            while p <> start do
              begin
                  inc(path.total);
                  path.data[path.total] := p;
                  p := shortest[p].father;
              end;
            write(start);
            for p := path.total downto 1 do
              write(' ' , path.data[p]);
            writeln;
        end
      else
        writeln(0);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
