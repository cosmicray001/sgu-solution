{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p225.in';
    OutFile    = 'p225.out';
    Limit      = 10;
    LimitNum   = 1 shl Limit;
    LimitValid = 30000;
    LimitGraph = 500000;
    LimitHorse = 100;

Type
    Tconflict  = array[0..LimitNum , 0..LimitNum] of boolean;
    Tindex     = array[0..LimitNum , 0..LimitNum] of longint;
    Tvalid     = record
                     tot      : longint;
                     data     : array[1..LimitValid] of
                                  record
                                      p1 , p2               : longint;
                                  end;
                 end;
    Thead      = array[1..LimitValid] of longint;
    Tgraph     = array[1..LimitGraph] of longint;
    Topt       = array[0..1 , 0..LimitHorse , 1..LimitValid] of comp;
    Tsum       = array[0..LimitNum] of longint;

Var
    conflict_1 ,
    conflict_2 : Tconflict;
    index      : Tindex;
    valid      : Tvalid;
    sum        : Tsum;
    head ,
    count      : Thead;
    graph ,
    state      : Tgraph;
    opt        : Topt;
    N , K , M ,
    E , now    : longint;

procedure init;
begin
{    assign(INPUT , InFile); ReSet(INPUT);
      read(N , K);
    Close(INPUT);}
    M := 1 shl N - 1;
end;

procedure make_conflict(var conflict : Tconflict; step : longint);
type
    Tblock     = array[1..Limit] of longint;
var
    p1 , p2 ,
    i , t      : longint;
    b1         : Tblock;
begin
    for p1 := 0 to M do
      begin
          t := p1;
          for i := 1 to N do begin b1[i] := t mod 2; t := t div 2; end;
          for p2 := 0 to M do
            begin
                t := p2;
                conflict[p1 , p2] := false;
                for i := 1 to N do
                  begin
                      if odd(t) then
                        if (i + step <= N) and (b1[i + step] = 1) or (i - step > 0) and (b1[i - step] = 1) then
                          begin
                              conflict[p1 , p2] := true;
                              break;
                          end;
                      t := t div 2;
                  end;
            end;
      end;
end;

procedure pre_process;
var
    p1 , p2 , p3 ,
    i          : longint;
begin
    make_conflict(conflict_1 , 1);
    make_conflict(conflict_2 , 2);

    for i := 0 to M do
      begin
          sum[i] := 0; p1 := i;
          while p1 <> 0 do
            begin
                if odd(p1) then inc(sum[i]);
                p1 := p1 div 2;
            end;
      end;
    valid.tot := 0;
    for p1 := 0 to M do
      for p2 := 0 to M do
        if not conflict_2[p1 , p2] then
          begin
              inc(valid.tot);
              valid.data[valid.tot].p1 := p1; valid.data[valid.tot].p2 := p2;
              index[p1 , p2] := valid.tot;
          end;

    E := 0;
    for i := 1 to valid.tot do
      begin
          head[i] := E + 1; count[i] := 0;
          for p3 := 0 to M do
            if not conflict_2[valid.data[i].p2 , p3] and not conflict_1[valid.data[i].p1 , p3] then
              begin
                  inc(E); inc(count[i]);
                  Graph[E] := p3;
                  state[E] := index[valid.data[i].p2  , p3];
              end;
      end;
end;

procedure work;
var
    i , last ,
    j , p , t ,
    tmp ,
    nowlast    : longint;
begin
    pre_process;
    fillchar(opt , sizeof(opt) , 0);
    now := 0;
    last := 0;
    for i := 1 to valid.tot do
      begin
          opt[now , sum[valid.data[i].p1] + sum[valid.data[i].p2]  , i] := 1;
          if sum[valid.data[i].p1] + sum[valid.data[i].p2] > last then
            last := sum[valid.data[i].p1] + sum[valid.data[i].p2];
      end;
    for i := 2 to N - 1 do
      begin
          now := 1 - now; nowlast := 0;
          fillchar(opt[now] , sizeof(opt[now]) , 0);
          for j := 0 to last do
            for p := 1 to valid.tot do
              if opt[1 - now , j , p] > 0 then
                for t := head[p] to head[p] + count[p] - 1 do
                  begin
                      tmp := j + sum[graph[t]];
                      if tmp > nowlast then nowlast := tmp;
                      opt[now , tmp , state[t]] := opt[now , tmp , state[t]] + opt[1 - now , j , p];
                  end;
//          last := nowlast;
      end;
end;

procedure out;
var
    i          : longint;
    answer     : comp;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      write('' : 17 , '(');
      for K := 0 to 100 do
        begin
            answer := 0;
            for i := 1 to valid.tot do
              answer := answer + opt[now , K , i];
            if k <> 100 then
              write(answer : 0 : 0 , ' , ')
            else
              writeln(answer : 0 : 0 , ') , ');
            if (k + 1) mod 10 = 0 then
              begin
                  writeln;
                  write('' : 18);
              end;
        end;
//    Close(OUTPUT);
end;

Begin
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
    for N := 1 to 10 do
      begin
          M := 1 shl N - 1;
          work;
          out;
      end;
    Close(OUTPUT);
End.
