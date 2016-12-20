{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p237.in';
    OutFile    = 'p237.out';
    Limit      = 800;

Type
    Tdata      = array[1..Limit] of char;
    Topt       = array[1..Limit , 1..Limit] of
                   record
                       best , sign           : smallint;
                       strategyc             : char;
                   end;

Var
    data       : Tdata;
    opt        : Topt;
    N , bestans: smallint;

procedure init;
var
    c          : char;
    i          : smallint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      N := 0;
      while not seekeoln do
        begin
            read(c);
            if (N > 0) and (data[N] = '*') and (c = '*') then continue;
            inc(N); data[N] := c;
            if c = '!' then
              begin inc(N); data[N] := c; inc(N); data[N] := c; end;
        end;
//    Close(INPUT);
    for i := 1 to N do
      if data[i] = '!' then
        data[i] := '?';
end;

function dfs(st , ed , signal : smallint) : smallint; forward

procedure go(var st , ed : smallint; sign : smallint; c : char; var sc : char);
begin
    if st >= ed then exit;
    sc := c;
    if odd(sign) then dec(ed);
    if sign >= 2 then inc(st);
end;

function better_sub(st , ed , s1 , s2 : smallint; c1 , c2 : char) : boolean;
var
    first1 ,
    first2     : boolean;
    st1 , st2 ,
    ed1 , ed2  : smallint;
    sc1 , sc2  : char;
begin
    first1 := true; first2 := true;
    st1 := st; ed1 := ed; st2 := st; ed2 := ed;
    better_sub := true;
    while st1 < ed1 do
      begin
          if not first1 and not first2 and (st1 = st2) and (ed1 = ed2) then
            exit;
          sc1 := #0;
          if first1 then go(st1 , ed1 , s1 , c1 , sc1);
          first1 := false;
          while (sc1 = #0) and (st1 < ed1) do
            go(st1 , ed1 , opt[st1 , ed1].sign , opt[st1 , ed1].strategyc , sc1);
          sc2 := #0;
          if first2 then go(st2 , ed2 , s2 , c2 , sc2);
          first2 := false;
          while (sc2 = #0) and (st2 < ed2) do
            go(st2 , ed2 , opt[st2 , ed2].sign , opt[st2 , ed2].strategyc , sc2);
          if sc1 <> sc2 then begin better_sub := sc1 < sc2; exit; end;
      end;
    if st1 = ed1 then
      begin
          if data[st1] = '*' then sc1 := #0
                             else if data[st1] = '?' then sc1 := 'a'
                                                     else sc1 := data[st1];
          if data[st2] = '*' then sc2 := #0
                             else if data[st2] = '?' then sc2 := 'a'
                                                     else sc2 := data[st2];
          better_sub := sc1 < sc2;
      end;
end;

procedure better(st , ed , sign , signal : smallint; c : char);
var
    nst , ned ,
    newval     : smallint;
begin
    nst := st; ned := ed;
    if odd(sign) then dec(ned);
    if sign >= 2 then inc(nst);
    newval := dfs(nst , ned , signal);
    if newval < 0 then exit;
    if (signal = 1) and (newval > bestans) then exit;
    if c <> #0 then inc(newval , 2);
    if (opt[st , ed].best < 0) or (opt[st , ed].best > newval) then
      begin
          opt[st , ed].best := newval;
          opt[st , ed].sign := sign;
          opt[st , ed].strategyc := c;
      end;
    if opt[st , ed].best < newval then exit;
    if signal = 0 then exit;
    if not better_sub(st , ed , opt[st , ed].sign , sign , opt[st , ed].strategyc , c) then
      begin
          opt[st , ed].best := newval;
          opt[st , ed].sign := sign;
          opt[st , ed].strategyc := c;
      end;
end;

function dfs(st , ed , signal : smallint) : smallint;
begin
    if st > ed
      then dfs := 0
      else if st = ed
             then begin
                      if data[st] = '*'
                        then dfs := 0
                        else dfs := 1;
                  end
             else if opt[st , ed].best <> -1
                    then dfs := opt[st , ed].best
                    else begin
                             if (data[st] = '?') and (data[ed] = '?') then
                               better(st , ed , 3 , signal , 'a');
                             if (data[st] = '*') and (data[ed] = '?') then
                               begin
                                   better(st , ed , 1 , signal , 'a');
                                   better(st , ed , 2 , signal , #0);
                               end;
                             if (data[st] = '?') and (data[ed] = '*') then
                               begin
                                   better(st , ed , 2 , signal , 'a');
                                   better(st , ed , 1 , signal , #0);
                               end;
                             if (data[st] = '*') and (data[ed] = '*') then
                               begin
                                   better(st , ed , 2 , signal , #0);
                                   better(st , ed , 1 , signal , #0);
                               end;
                             if (data[st] in ['a'..'z']) and (data[ed] = '?') then
                               better(st , ed , 3 , signal , data[st]);
                             if (data[st] in ['a'..'z']) and (data[ed] = '*') then
                               begin
                                   better(st , ed , 2 , signal , data[st]);
                                   better(st , ed , 1 , signal , #0);
                               end;
                             if (data[st] = '?') and (data[ed] in ['a'..'z']) then
                               better(st , ed , 3 , signal , data[ed]);
                             if (data[st] = '*') and (data[ed] in ['a'..'z']) then
                               begin
                                   better(st , ed , 2 , signal , #0);
                                   better(st , ed , 1 , signal , data[ed]);
                               end;
                             if (data[st] in ['a'..'z']) and (data[ed] in ['a'..'z']) then
                               if data[st] = data[ed] then
                                 better(st , ed , 3 , signal , data[st]);
                             if opt[st , ed].best < 0 then opt[st , ed].best := -2;
                             dfs := opt[st , ed].best;
                         end;
end;

procedure work;
begin
    fillchar(opt , sizeof(opt) , $FF);
    bestans := dfs(1 , N , 0);
    if bestans >= 0
      then begin
               fillchar(opt , sizeof(opt) , $FF);
               dfs(1 , N , 1);
           end;
end;

procedure out;
var
    st , ed , sign ,
    tot , i    : smallint;
    path       : Tdata;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      st := 1; ed := N;
      if (N >= 1) and (st < ed) and (opt[st , ed].best < 0)
        then writeln('NO')
        else begin
                 writeln('YES');
                 tot := 0;
                 st := 1; ed := N;
                 while st < ed do
                   begin
                       sign := opt[st , ed].sign;
                       if opt[st , ed].strategyc <> #0 then
                         begin inc(tot); path[tot] := opt[st , ed].strategyc; end;
                       if odd(sign) then dec(ed);
                       if sign >= 2 then inc(st);
                   end;
                 for i := 1 to tot do write(path[i]);
                 if st = ed then
                   if data[st] = '?'
                     then write('a')
                     else if data[st] in ['a'..'z'] then write(data[st]);
                 for i := tot downto 1 do write(path[i]);
             end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
