{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE CONSOLE}
{$R+,Q+,S+}
Const
    InFile     = 'p161.in';
    OutFile    = 'p161a.out';
    Limit      = 100;
    LimitLen   = 255;
    LimitQ     = 20;
    LimitExp   = 200;
    LimitValid = 100;

Type
    Tstring    = string[LimitLen];
    Tquestion  = array[1..LimitQ] of Tstring;
    Tgraph     = array[1..Limit , 1..Limit] of boolean;
    Tset       = array[1..Limit] of boolean;
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
                     optimized: boolean;
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

Var
    graph      : Tgraph;
    question   : Tquestion;
    exp        : Texp;
    variables  : Tvariables;
    answer     : Tanswer;
    order      : Torder;
    appeared   : Tappeared;
    valid      : Tvalid;
    N , Q      : integer;

procedure init;
var
    M , i ,
    p1 , p2    : integer;
begin
    fillchar(graph , sizeof(graph) , 0);
    fillchar(question , sizeof(question) , 0);
    fillchar(variables , sizeof(variables) , 0);
    assign(INPUT , InFile); ReSet(INPUT);
      readln(N , M);
      for i := 1 to M do
        begin
            readln(p1 , p2);
            graph[p1 , p2] := true;
        end;
      readln(Q);
      for i := 1 to Q do
        readln(question[i]);
    Close(INPUT);
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
          graph[i , j] := graph[i , j] or graph[i , k] and graph[k , j];
end;

function find_bracket(Const s : Tstring; p : integer) : integer;
var
    left       : integer;
begin
    left := 1; inc(p);
    while left > 0 do
      begin
          if s[p] = '(' then
            inc(left);
          if s[p] = ')' then
            dec(left);
          inc(p);
      end;
    find_bracket := p - 1;
end;

procedure dfs_Analyze(s : Tstring);
var
    p , i , min ,
    tmp , next : integer;
    oper , ts  : Tstring;
begin
    while (s[1] = '(') and (find_bracket(s , 1) = length(s)) do
      s := copy(s , 2 , length(s) - 2);
    if length(s) = 1 then
      begin
          inc(exp.total);
          exp.data[exp.total].sign := 1;
          exp.data[exp.total].ch := s[1];
          if (s[1] <> '0') and (s[1] <> '1') then
            appeared[s[1]] := true;
      end
    else
      begin
          inc(exp.total);
          p := exp.total;

          i := 1;
          min := 6;
          while i <= length(s) do
            if s[i] = '(' then
              i := find_bracket(s , i) + 1
            else
              begin
                  tmp := 6;
                  if s[i] = '=' then
                    if (i = length(s)) or (s[i + 1] <> '>') then
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

          exp.data[p].sign := 7 - min;
          ts := '';
          i := 1;
          if min <> 5 then
            while (i <= length(s)) or (ts <> '') do
              begin
                  if (i > length(s)) or (oper = '=>') and (copy(s , i , 2) = oper) or
                    (oper <> '=>') and (copy(s , i , 1) = oper) and (copy(s , i , 2) <> '=>') then
                    begin
                        inc(exp.data[p].total);
                        exp.data[p].data[exp.data[p].total] := exp.total + 1;
                        dfs_Analyze(ts);
                        ts := '';
                        inc(i , length(oper) - 1);
                    end
                  else
                    if s[i] = '(' then
                      begin
                          next := find_bracket(s , i);
                          ts := ts + copy(s , i , next - i + 1);
                          i := next;
                      end
                    else
                      ts := ts + s[i];
                  inc(i);
              end
          else
            begin
                exp.data[p].total := 1;
                exp.data[p].data[1] := exp.total + 1;
                dfs_Analyze(copy(s , 2 , length(s) - 1));
            end;
      end;
end;

procedure Analyze(s : Tstring);
var
    c          : char;
    i          : integer;
begin
    fillchar(exp , sizeof(exp) , 0);
    fillchar(order , sizeof(order) , 0);
    fillchar(appeared , sizeof(appeared) , 0);

    i := 1;
    while i <= length(s) do
      if s[i] = ' ' then
        delete(s , i , 1)
      else
        inc(i);
    dfs_Analyze(s);

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
begin
    for i := 1 to N do
      begin
          variables['0' , i] := true;
          for j := 1 to N do
            if (i <> j) and graph[i , j] then
              begin
                  variables['0' , i] := false;
                  break;
              end;
      end;
end;

procedure _NOT(Const S1 : Tset; var res : Tset);
var
    i          : integer;
begin
    for i := 1 to N do
      res[i] := variables['0' , i] and (not S1[i]);
end;

procedure _Max(Const s : Tset; var res : Tset);
var
    i , j      : integer;
begin
    for i := 1 to N do
      if s[i] then
        begin
            res[i] := true;
            for j := 1 to N do
              if (i <> j) and s[j] then
                if graph[i , j] then
                  begin
                      res[i] := false;
                      break;
                  end;
        end
      else
        res[i] := false
end;

procedure _Conj(Const node : Tnode; var res : Tset);
var
    i , j      : integer;
    tmp        : Tset;
begin
    for i := 1 to N do
      begin
          tmp[i] := false;
          for j := 1 to node.total do
            if exp.data[node.data[j]].res[i] then
              begin
                  tmp[i] := true;
                  break;
              end;
      end;
    _Max(tmp , res);
end;

procedure _Disj(Const node : Tnode; var res : Tset);
var
    i , j , k  : integer;
    find       : boolean;
    tmp        : Tset;
begin
    for i := 1 to N do
      begin
          tmp[i] := true;
          for j := 1 to node.total do
            begin
                find := false;
                for k := 1 to N do
                  if exp.data[node.data[j]].res[k] and graph[i , k] then
                    begin
                        find := true;
                        break;
                    end;
                if not find then
                  begin
                      tmp[i] := false;
                      break;
                  end;
            end;
      end;
    _Max(tmp , res);
end;

procedure _Imp_sub(Const s1 , s2 : Tset; var res : Tset);
var
    i , j      : integer;
begin
    for i := 1 to N do
      if s2[i] then
        begin
            res[i] := true;
            for j := 1 to N do
              if s1[j] and graph[i , j] then
                begin
                    res[i] := false;
                    break;
                end;
        end
      else
        res[i] := false;
end;

procedure _Implication(Const node : Tnode; var res : Tset);
var
    i , j      : integer;
    tmp        : Tset;
begin
    for i := 1 to N do
      begin
          tmp[i] := false;
          for j := 1 to node.total - 1 do
            if exp.data[node.data[j]].res[i] then
              begin
                  tmp[i] := true;
                  break;
              end;
      end;
    _Imp_sub(tmp , exp.data[node.data[node.total]].res , res);
end;

procedure _Equi(Const node : Tnode; var res : Tset);
var
    i , j      : integer;
    tmp , tmp2 : Tset;
begin
    for i := 1 to N do
      tmp[i] := false;
    for i := 1 to node.total - 1 do
      begin
          _Imp_sub(exp.data[node.data[i]].res , exp.data[node.data[i + 1]].res , tmp2);
          for j := 1 to N do
            if tmp2[j] then
              tmp[j] := true;
          _Imp_sub(exp.data[node.data[i + 1]].res , exp.data[node.data[i]].res , tmp2);
          for j := 1 to N do
            if tmp2[j] then
              tmp[j] := true;
      end;
    _Max(tmp , res);
end;

function Empty_Set(Const s : Tset) : boolean;
var
    i          : integer;
begin
    Empty_set := false;
    for i := 1 to N do
      if s[i] then
        exit;
    Empty_set := true;
end;

function run : boolean;
var
    i , j      : integer;
begin
    for i := exp.total downto 1 do
      if exp.data[i].sign <> 1 then
        Case exp.data[i].sign of
          2    : _NOT(exp.data[exp.data[i].data[1]].res , exp.data[i].res);
          3    : _Conj(exp.data[i] , exp.data[i].res);
          4    : _Disj(exp.data[i] , exp.data[i].res);
          5    : _Implication(exp.data[i] , exp.data[i].res);
          6    : _Equi(exp.data[i] , exp.data[i].res);
        end
      else
        for j := 1 to N do
          exp.data[i].res[j] := variables[exp.data[i].ch , j];

    run := Empty_Set(exp.data[1].res);
end;

procedure make_valid(step : integer);
var
    i          : integer;
    ok         : boolean;
begin
    if step > N then
      begin
          inc(valid.total);
          valid.data[valid.total] := variables['A'];
      end
    else
      begin
          ok := true;
          for i := 1 to step - 1 do
            if variables['A' , i] then
              if graph[i , step] or graph[step , i] then
                begin
                    ok := false;
                    break;
                end;
          if ok then
            begin
                variables['A' , step] := true;
                make_valid(step + 1);
            end;
          variables['A' , step] := false;
          make_valid(step + 1);
      end;
end;

function check(step : integer) : boolean;
var
    i          : integer;
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
                variables[order.data[step]] := valid.data[i];
                if not check(step + 1) then
                  exit;
            end;
          check := true;
      end;
end;

procedure work;
var
    i          : integer;
begin
    Floyd;
    make_valid(1);

    for i := 1 to Q do
      begin
          Analyze(question[i]);

          pre_process;
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
    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to Q do
        if answer[i] then
          writeln('valid')
        else
          writeln('invalid');
    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
