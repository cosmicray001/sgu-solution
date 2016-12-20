{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p161.in';
    OutFile    = 'p161.out';
    Limit      = 100;
    LimitLen   = 255;
    LimitQ     = 20;
    LimitExp   = 200;
    LimitValid = 100;

Type
    Tstring    = string[LimitLen];
    Tquestion  = array[1..LimitQ] of Tstring;
    Tgraph     = array[1..Limit , 1..Limit] of boolean;
    Tset       = record
                     total    : integer;
                     data     : array[1..Limit] of integer;
                 end;
    Tnode      = record
                     sign     : integer;
                                         { sign:
                                             1 - Constants / Variables
                                             2 - Negation
                                             3 - Conjunction
                                             4 - Disjunction
                                             5 - Implication
                                             6 - Equivalence
                                         }
                     ch       : char;    { for Sign 1 - Contants / Variables }

                     total    : integer;
                     data     : array[1..LimitExp] of integer;
                                         { for other operators }

                     res      : Tset;

                     father ,
                     fa_index : integer;
                     ran ,
                     Optimized: boolean;
                 end;
    Texp       = record
                     total    : integer;
                     data     : array[1..LimitExp] of Tnode;
                 end;
    Tvariables = array['0'..'Z'] of Tset;
    Tanswer    = array[1..LimitQ] of boolean;
    Torder     = record
                     total    : integer;
                     data     : array[1..Limit] of char;
                 end;
    Tappeared  = array['A'..'Z'] of boolean;
    Tvalid     = record
                     total    : integer;
                     data     : array[1..LimitValid] of Tset;
                 end;
    Tpoint     = array[1..LimitExp] of integer;
    Tgather    = array[1..Limit] of boolean;
    Tnext_Bra  = array[1..LimitLen] of integer;
    Tstack     = record
                     top      : integer;
                     data     : array[1..LimitLen] of integer;
                 end;

Var
    graph      : Tgraph;
    question   : Tquestion;
    exp        : Texp;
    variables  : Tvariables;
    answer     : Tanswer;
    order      : Torder;
    appeared   : Tappeared;
    valid      : Tvalid;
    point      : Tpoint;
    prev_gather: Tgather;
    path       : Tset;
    next_Bra   : Tnext_Bra;
    stack      : Tstack;
    N , Q      : integer;

procedure init;
var
    M , i ,
    p1 , p2    : integer;
begin
    fillchar(graph , sizeof(graph) , 0);
    fillchar(question , sizeof(question) , 0);
    fillchar(variables , sizeof(variables) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N , M);
      for i := 1 to M do
        begin
            readln(p1 , p2);
            graph[p1 , p2] := true;
        end;
      readln(Q);
      for i := 1 to Q do
        readln(question[i]);
//    Close(INPUT);
end;

procedure Floyd;
var
    i , j , k  : integer;
begin
    for i := 1 to N do
      graph[i , i] := true;

    for k := 1 to N do
      for i := 1 to N do
        for j := 1 to N do
          graph[i , j] := graph[i , j] and graph[i , k] and graph[k , j];
end;

procedure dfs_Analyze(const s : Tstring; start , stop : integer);
var
    p , i , min ,
    tmp , last : integer;
    oper       : Tstring;
begin
    while (s[start] = ')') and (Next_Bra[start] = stop) do
      begin
          inc(start);
          dec(stop);
      end;
    if start = stop then
      begin
          inc(exp.total);
          exp.data[exp.total].sign := 1;
          exp.data[exp.total].ch := s[start];
          if (s[start] <> '0') and (s[start] <> '1') then
            appeared[s[start]] := true;
      end
    else
      begin
          inc(exp.total);
          p := exp.total;

          i := start;
          min := 6;
          while i <= stop do
            if s[i] = '(' then
              i := next_Bra[i] + 1
            else
              begin
                  tmp := 6;
                  if s[i] = '=' then
                    if (i = stop) or (s[i + 1] <> '>') then
                      tmp := 1
                    else
                      tmp := 2
                  else
                    if s[i] = '|' then
                      tmp := 3
                    else
                      if s[i] = '&' then
                        tmp := 4
                      else
                        if s[i] = '~' then
                          tmp := 5;
                  if tmp < min then
                    min := tmp;
                  inc(i);
              end;

          case min of
            1                 : oper := '=';
            2                 : oper := '=>';
            3                 : oper := '|';
            4                 : oper := '&';
            5                 : oper := '~';
          end;

          exp.data[p].sign := 77 - min;
          last := start;
          i := start;
          if min <> 5 then
            while (i <= stop) or (last <= stop) do
              begin
                  if (i > stop) or (oper = '=>') and (copy(s , i , 2) = oper) or
                    (oper <> '=>') and (copy(s , i , 1) = oper) and (copy(s , i , 2) <> '=>') then
                    begin
                        inc(exp.data[p].total);
                        exp.data[p].data[exp.data[p].total] := exp.total + 1;
                        dfs_Analyze(s , last , i - 1);
                        inc(i , length(oper) - 1);
                        last := i + 1;
                    end
                  else
                    if s[i] = '(' then
                      i := next_Bra[i];
                  inc(i);
              end
          else
            if copy(s , start , 3) = '~~~' then
              begin
                  while copy(s , start , 3) = '~~~' do
                    inc(start , 2);
                  dec(exp.total);
                  dfs_Analyze(s , start , stop);
              end
            else
              begin
                  exp.data[p].total := 1;
                  exp.data[p].data[1] := exp.total + 1;
                  dfs_Analyze(s , start + 1 , stop);
              end;
      end;
end;

procedure Analyze(s : Tstring);
var
    c          : char;
    tmps       : Tstring;
    i          : integer;
begin
    fillchar(exp , sizeof(exp) , 0);
    fillchar(order , sizeof(order) , 0);
    fillchar(appeared , sizeof(appeared) , 0);

    tmps := '';
    for i := 1 to length(s) do
      if s[i] <> ' ' then
        tmps := tmps + s[i];
    s := tmps;
    stack.top := -1;
    for i := 1 to length(s) do
      if s[i] = '(' then
        with stack do
          begin
              inc(top);
              data[top] := i;
          end
      else
        if s[i] = ')' then
          begin
              next_Bra[stack.data[stack.top]] := i;
              dec(stack.top);
          end;
    dfs_Analyze(s , 1 , length(s));

    for c := 'A' to 'Z' do
      if appeared[c] then
        begin
            inc(order.total);
            order.data[order.total] := c;
        end;
end;

procedure pre_process;
var
    i , j      : integer;
    ok         : boolean;
begin
    for i := 1 to N do
      begin
          ok := true;
          for j := 1 to N do
            if (i <> j) and graph[i , j] then
              begin
                  ok := false;
                  break;
              end;
          if ok then
            with variables['0'] do
              begin
                  inc(total);
                  data[total] := i;
              end;
      end;
end;

procedure _NOT(Const S1 : Tset; var res : Tset);
var
    p1 , p2    : integer;
begin
    p1 := 1; p2 := 1;
    res.total := 0;
    while p2 <= variables['0'].total do
      begin
          if (p1 <= S1.total) then
            begin
                while (p1 <= S1.total) and (S1.data[p1] < variables['0'].data[p2]) do
                  inc(p1);
                if (p1 > S1.total) or (S1.data[p1] <> variables['0'].data[p2]) then
                  begin
                      inc(res.total);
                      res.data[res.total] := variables['0'].data[p2];
                  end;
            end
          else
            begin
                inc(res.total);
                res.data[res.total] := variables['0'].data[p2];
            end;
          inc(p2);
      end;
end;

procedure _Max(Const s : Tset; var res : Tset);
var
    i , j      : integer;
    ok         : boolean;
begin
    res.total := 0;
    for i := 1 to s.total do
      begin
          ok := true;
          for j := 1 to s.total do
            if (i <> j) and graph[s.data[i] , s.data[j]] then
              if graph[i , j] then
                begin
                    ok := false;
                    break;
                end;
         if ok then
           with res do
             begin
                 inc(total);
                 data[total] := s.data[i];
             end;
     end;
end;

procedure _Conj(Const node : Tnode; var res : Tset);
var
    j , min ,
    minnum     : integer;
    tmp        : Tset;
begin
    for j := 1 to node.total do
      point[j] := 1;
    tmp.total := 0;
    while true do
      begin
          min := 0; minnum := 0;
          for j := 1 to node.total do
            with exp.data[node.data[j]] do
              if point[j] <= res.total then
                if (min = 0) or (minnum > res.data[point[j]]) then
                  begin
                      minnum := res.data[point[j]];
                      min := j;
                  end;
          if min = 0 then
            break;
          inc(tmp.total);
          tmp.data[tmp.total] := minnum;
          for j := 1 to node.total do
            with exp.data[node.data[j]] do
              if (point[j] <= res.total) and (minnum = res.data[point[j]]) then
                inc(point[j]);
      end;
    _Max(tmp , res);
end;

procedure _Disj(Const node : Tnode; var res : Tset);
var
    i , j , k ,
    sum        : integer;
    find       : boolean;
    tmp        : Tset;
    tmp2       : Tgather;
begin
    for i := 1 to N do
      tmp2[i] := true;

    sum := N;
    for j := 1 to node.total do
      with exp.data[node.data[j]].res do
        if sum > 0 then
          for i := 1 to N do
            if tmp2[i] then
              begin
                  find := false;
                  for k := 1 to total do
                    if graph[i , data[k]] then
                      begin
                          find := true;
                          break;
                      end;
                  if not find then
                    begin
                        tmp2[i] := false;
                        dec(sum);
                        if sum = 0 then break;
                    end;
              end
            else
        else
          break;

    tmp.total := 0;
    for i := 1 to N do
      if tmp2[i] then
        with tmp do
          begin
              inc(total);
              data[total] := i;
          end;
    _Max(tmp , res);
end;

procedure _Imp_sub(Const s1 , s2 : Tset; var res : Tset);
var
    i , j      : integer;
    ok         : boolean;
begin
    res.total := 0;
    for i := 1 to s2.total do
      begin
          ok := true;
          for j := 1 to s1.total do
            if graph[s2.data[i] , s1.data[j]] then
              begin
                  ok := false;
                  break;
              end;
          if ok then
            begin
                inc(res.total);
                res.data[res.total] := s2.data[i];
            end;
      end;
end;

procedure _Implication(Const node : Tnode; var res : Tset);
var
    j , min ,
    minnum     : integer;
    tmp        : Tset;
begin
    for j := 1 to node.total do
      point[j] := 1;
    tmp.total := 0;
    while true do
      begin
          min := 0; minnum := 0;
          for j := 1 to node.total - 1 do
            with exp.data[node.data[j]] do
              if point[j] <= res.total then
                if (min = 0) or (minnum > res.data[point[j]]) then
                  begin
                      minnum := res.data[point[j]];
                      min := j;
                  end;
          if min = 0 then break;
          inc(tmp.total);
          tmp.data[tmp.total] := minnum;
          for j := 1 to node.total do
            with exp.data[node.data[j]] do
              if (point[j] <= res.total) and (minnum = res.data[point[j]]) then
                inc(point[j]);
      end;
    _Imp_sub(tmp , exp.data[node.data[node.total]].res , res);
end;

procedure _Equi(Const node : Tnode; var res : Tset);
var
    i , j      : integer;
    tmp        : Tgather;
    tmp2       : Tset;
begin
    for i := 1 to N do
      tmp[i] := false;
    for i := 1 to node.total - 1 do
      begin
          _Imp_sub(exp.data[node.data[i]].res , exp.data[node.data[i + 1]].res , tmp2);
          for j := 1 to tmp2.total do
            tmp[tmp2.data[j]] := true;
          _Imp_sub(exp.data[node.data[i + 1]].res , exp.data[node.data[i]].res , tmp2);
          for j := 1 to tmp2.total do
            tmp[tmp2.data[j]] := true;
      end;
    tmp2.total := 0;
    for i := 1 to N do
      if tmp[i] then
        with tmp2 do
          begin
              inc(total);
              data[total] := i;
          end;
    _Max(tmp2 , res);
end;

function run : boolean;
var
    i , j      : integer;
begin
    for i := 1 to exp.total do
      exp.data[i].ran := false;

    for i := exp.total downto 1 do
      if not exp.data[i].ran and not exp.data[i].optimized then
        begin
            if exp.data[i].sign <> 1 then
              Case exp.data[i].sign of
                2    : _NOT(exp.data[exp.data[i].data[1]].res , exp.data[i].res);
                3    : _Conj(exp.data[i] , exp.data[i].res);
                4    : _Disj(exp.data[i] , exp.data[i].res);
                5    : _Implication(exp.data[i] , exp.data[i].res);
                6    : _Equi(exp.data[i] , exp.data[i].res);
              end
            else
              begin
                  exp.data[i].res.total := variables[exp.data[i].ch].total;
                  for j := 1 to exp.data[i].res.total do
                    exp.data[i].res.data[j] := variables[exp.data[i].ch].data[j];
              end;
            if exp.data[i].res.total = 0 then
              begin
                  j := exp.data[i].father;
                  if (j <> 0) and (exp.data[j].sign = 4) then
                    begin
                        exp.data[j].res.total := 0;
                        exp.data[j].ran := true;
                    end;
              end;
        end;

    run := (exp.data[1].res.total = 0);
end;

procedure make_valid(step : integer);
var
    i          : integer;
    ok         : boolean;
begin
    if step > N then
      begin
          inc(valid.total);
          valid.data[valid.total] := path;
      end
    else
      begin
          ok := true;
          for i := 1 to step - 1 do
            if prev_gather[i] then
              if graph[i , step] or graph[step , i] then
                begin
                    ok := false;
                    break;
                end;
          if ok then
            begin
                prev_gather[step] := true;
                inc(path.total);
                path.data[path.total] := step;
                make_valid(step + 1);
                path.data[path.total] := 0;
                dec(path.total);
                prev_gather[step] := false;
            end;

          prev_gather[step] := false;
          make_valid(step + 1);
      end;
end;

function check(step : integer) : boolean;
var
    i , j      : integer;
begin
    if step > order.total then
      if run then
        check := true
      else
        check := false
    else
      begin
          check := false;
          for i := 1 to valid.total do
            begin
                variables[order.data[step]].total := valid.data[i].total;
                for j := 1 to valid.data[i].total do
                  variables[order.data[step]].data[j] := valid.data[i].data[j];
                if not check(step + 1) then
                  exit;
            end;
          check := true;
      end;
end;

function same_node(const n1 , n2 : Tnode) : boolean;
var
    i          : integer;

begin
    if n1.sign = n2.sign then
      if n1.sign = 1 then
        same_node := (n1.ch = n2.ch)
      else
        if n1.total = n2.total then
          begin
              same_node := true;
              for i := 1 to n1.total do
                if n1.data[i] <> n2.data[i] then
                  begin
                      same_node := false;
                      exit;
                  end;
          end
        else
          same_node := false
    else
      same_node := false;
end;

procedure Optimize;
var
    i , j ,
    tmp ,
    p1 , p2    : integer;
    changed    : boolean;
begin
    for i := 1 to exp.total do
      exp.data[i].Optimized := false;

    for i := exp.total - 1 downto 2 do
      begin
          if (exp.data[i].sign = 3) or (exp.data[i].sign = 4) then
            with exp.data[i] do
              for p1 := 1 to total do
                begin
                    changed := false;
                    for p2 := total downto p1 + 1 do
                      if data[p2] < data[p2 - 1] then
                        begin
                            tmp := data[p2];
                            data[p2] := data[p2 - 1];
                            data[p2 - 1] := tmp;
                            changed := true;
                        end;
                    if not changed then
                      break;
                end;
          for j := i + 1 to exp.total do
            if not exp.data[j].Optimized then
               if same_node(exp.data[i] , exp.data[j]) then
                 begin
                     exp.data[i].Optimized := true;
                     p1 := exp.data[i].father;
                     p2 := exp.data[i].fa_index;
                     exp.data[p1].data[p2] := j;
                     break;
                 end;
      end;
end;

procedure work;
var
    i , j , k  : integer;
begin
    Floyd;
    fillchar(prev_gather , sizeof(prev_gather) , 0);
    fillchar(path , sizeof(path) , 0);
    make_valid(1);
    pre_process;

    for i := 1 to Q do
      begin
          Analyze(question[i]);

          for j := 1 to exp.total do
            for k := 1 to exp.data[j].total do
              begin
                  exp.data[exp.data[j].data[k]].father := j;
                  exp.data[exp.data[j].data[k]].fa_index := k;
              end;

          Optimize;
          if check(1) then
            answer[i] := true
          else
            answer[i] := false;
      end;
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := Q downto 1 do
        if answer[i] then
          writeln('valid')
        else
          writeln('invalid');
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
