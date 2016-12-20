{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p215.in';
    OutFile    = 'p215.out';
    LimitLen   = 250;
    LimitName  = 10;
    LimitHash  = 3999997;
    LimitDef   = 60000;
    Operators  = ['+' , '-' , '*' , '/' , '%' , '^'];

Type
    Tstr       = string[LimitLen];
    Tname      = string[LimitName];
    Thash      = array[0..LimitHash] of longint;
    Tnames     = array[1..LimitDef] of Tname;
    Tfather    = array[1..LimitDef] of longint;
    Tnext      = array[1..LimitLen] of longint;

Var
    hash       : Thash;
    names      : Tnames;
    father     : Tfather;
    next       : Tnext;
    D          : longint;

procedure init;
begin
//    fillchar(hash , sizeof(hash) , 0);
    fillchar(names , sizeof(names) , 0);
    fillchar(father , sizeof(father) , 0);
    D := 0;
end;

procedure _upcase(var s : Tstr);
var
    i          : longint;
begin
    for i := 1 to length(s) do
      s[i] := upcase(s[i]);
end;

function convert(c : char) : longint;
begin
    if (c >= '0') and (c <= '9')
      then convert := ord(c) - ord('0')
      else convert := ord(c) - ord('A') + 10;
end;

function hash_func(const name : Tname) : longint;
var
    res , i    : longint;
begin
    res := 0;
    for i := 1 to length(name) do
      res := (res * 36 + convert(name[i])) mod LimitHash;
    hash_func := res;
end;

function find_p(const name : Tname; var p : longint) : boolean;
begin
    p := hash_func(name);
    while hash[p] <> 0 do
      if names[hash[p]] = name
        then begin
                 find_p := true;
                 exit;
             end
        else begin
                 inc(p);
                 if p = LimitHash then p := 0;
             end;
    find_p := false;
end;

function find_father(root : longint) : longint;
var
    tmp        : longint;
begin
    if father[root] = 0
      then find_father := root
      else begin
               tmp := find_father(father[root]);
               father[root] := tmp;
               find_father := tmp;
           end;
end;

function Get_Posi(const name : Tname) : longint;
var
    p          : longint;
begin
    if find_p(name , p)
      then Get_Posi := p
      else begin
               Get_Posi := p;
               inc(D);
               names[D] := name;
               hash[p] := D;
           end;
end;

procedure _define(const name1 , name2 : Tname);
var
    p1 , p2 ,
    fp2        : longint;
begin
    p1 := hash[Get_Posi(name1)];
    p2 := hash[Get_Posi(name2)];
    fp2 := find_father(p2);
    if (father[p1] = 0) and (fp2 <> p1) then
      father[p1] := fp2;
end;

function Get_Value(const name : Tname) : longint;
var
    res , i , p: longint;
    s          : Tname;
begin
    Get_Value := 0;
    if not find_p(name , p)
      then begin
               for i := 1 to length(name) do
                 if (name[i] >= 'A') and (name[i] <= 'Z') then
                   exit;
               s := name;
           end
      else begin
               p := hash[p];
               p := find_father(p);
               s := names[p];
           end;
    res := 0; 
    for i := 1 to length(s) do
      if (s[i] >= '0') and (s[i] <= '9')
        then res := res * 10 + ord(s[i]) - ord('0')
        else exit;
    Get_Value := res;
end;

function better(const s : Tstr; p1 , p2 , st : longint) : boolean;
var
    pr1 , pr2  : longint;
begin
    if p2 = 0
      then better := true
      else begin
               case s[p1] of
                 '+' , '-'                   : pr1 := 1;
                 '*' , '/' , '%'             : pr1 := 2;
                 '^'                         : pr1 := 3;
               end;
               if (p1 = st) or (s[p1 - 1] in operators) then pr1 := 4;
               case s[p2] of
                 '+' , '-'                   : pr2 := 1;
                 '*' , '/' , '%'             : pr2 := 2;
                 '^'                         : pr2 := 3;
               end;
               if (p2 = st) or (s[p2 - 1] in operators) then pr2 := 4;
               if pr1 < pr2
                 then better := true
                 else if pr1 > pr2
                        then better := false
                        else better := (pr1 <= 2);
           end;
end;

function _mod(num1 , num2 : longint) : longint;
begin
    if (num1 > 0) xor (num2 > 0)
      then _mod := -(abs(num1) mod abs(num2))
      else _mod := abs(num1) mod abs(num2);
end;

function _power(num1 , num2 : longint) : longint;
var
    res , i    : longint;
begin
    res := 1;
    if abs(num1) > 1 then
      for i := 1 to num2 do
        res := res * num1
    else
      if (num1 = 0) and (num2 <> 0)
        then res := 0
        else if num1 = -1
               then if odd(num2)
                      then res := -1
                      else res := 1; 
    _power := res;
end;

function calc(const s : Tstr; st , ed : longint) : longint;
var
    minp , i ,
    num1 , num2: longint;
begin
    while (s[st] = '(') and (next[st] = ed) do
      begin inc(st); dec(ed); end;
      
    calc := 0;
    if st > ed then exit;

    minp := 0; i := st;
    while i <= ed do
      begin
          if s[i] in operators then
            if better(s , i , minp , st) then
              minp := i;
          if s[i] = '(' then
            i := next[i];
          inc(i);
      end;

    if minp = 0
      then calc := Get_Value(copy(s , st , ed - st + 1))
      else begin
               num1 := calc(s , st , minp - 1);
               num2 := calc(s , minp + 1 , ed);
               case s[minp] of
                 '+'          : calc := num1 + num2;
                 '-'          : calc := num1 - num2;
                 '*'          : calc := num1 * num2;
                 '/'          : calc := num1 div num2;
                 '%'          : calc := _mod(num1 , num2);
                 '^'          : calc := _power(num1 , num2);
               end;
           end;
end;

procedure del_space(var s : Tstr);
var
    news       : Tstr;
    i          : longint;
begin
    news := '';
    for i := 1 to length(s) do
      if s[i] <> ' ' then
        news := news + s[i];
    s := news;
end;

procedure Get_Next(const s : Tstr);
type
    Tstack     = array[1..LimitLen] of longint;
var
    stack      : Tstack;
    top , i    : longint;
begin
    top := 0;
    for i := 1 to length(s) do
      if s[i] = '('
        then begin
                 inc(top);
                 stack[top] := i;
             end
        else if s[i] = ')' then
               begin
                   next[stack[top]] := i;
                   dec(top);
               end;
end;

procedure main;
var
    s , s1 , s2: Tstr;
    p          : longint;
begin
    init;
    while not seekeof do
      begin
          readln(s);
          _upcase(s);
          while (s[1] <> 'D') and (s[1] <> 'P') do
            delete(s , 1 , 1);
          if s[1] = 'D'
            then begin
                     delete(s , 1 , 6);
                     while s[1] = ' ' do delete(s , 1 , 1);
                     p := pos(' ' , s);
                     s1 := copy(s , 1 , p - 1);
                     s2 := copy(s , p + 1 , length(s) - p);
                     del_space(s2);
                     _define(s1 , s2);
                 end
            else begin
                     delete(s , 1 , 5);
                     del_space(s);
                     Get_Next(s);
                     writeln(calc(s , 1 , length(s)));
                 end;
      end;
end;

Begin
//    assign(INPUT , InFile); ReSet(INPUT);
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      main;
//    Close(OUTPUT);
//    Close(INPUT);
End.
