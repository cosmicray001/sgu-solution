{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p182.in';
    OutFile    = 'p182.out';
    LimitLen   = 2048;
    LimitEle   = 2000;
    LimitV     = 10;

Type
    Tnode      = record
                     sign     : longint;
                                  { 1 -- Negation
                                    2 -- conjunction
                                    3 -- disjunction
                                    4 -- equality
                                    5 -- implication
                                    6 -- xor
                                    7 -- variable
                                  }
                     p1 , p2  : longint;
                 end;
    Texp       = record
                     tot      : longint;
                     data     : array[1..LimitEle] of Tnode;
                 end;
    Tstr       = record
                     len      : longint;
                     data     : array[1..LimitLen] of char;
                 end;    
    Tvariable  = array[1..LimitV] of boolean;
    Tnext      = array[1..LimitLen] of longint;

Var
    exp        : Texp;
    str        : Tstr;
    variable   : Tvariable;
    next       : Tnext;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      str.len := 0;
      while not seekeoln do
        begin
            inc(str.len);
            read(str.data[str.len]);
        end;
      readln;
//    Close(INPUT);
end;

procedure Get_Next;
type
    Tstack     = array[1..LimitLen] of longint;
var
    top , i    : longint;
    stack      : Tstack;
begin
    fillchar(next , sizeof(next) , 0);
    top := 0;
    for i := 1 to str.len do
      if str.data[i] = '('
        then begin
                 inc(top);
                 stack[top] := i;
             end
        else if str.data[i] = ')'
               then begin
                        next[stack[top]] := i;
                        dec(top);
                    end;
end;

function analyze(start , stop : longint) : longint;
var
    i , max ,
    maxwhere ,
    now , t    : longint;
begin
    while (str.data[start] = '(') and (next[start] = stop) do
      begin inc(start); dec(stop); end;

    i := start; maxwhere := 0;
    while i <= stop do
      if str.data[i] = '('
        then i := next[i] + 1
        else begin
                 if str.data[i] in ['!' , '&' , '|' , '<' , '=' , '#'] then
                   begin
                       case str.data[i] of
                         '!'  : now := 1;
                         '&'  : now := 2;
                       else now := 3;
                       end;
                       if (maxwhere = 0) or (now > 1) and (now >= max) then
                         begin
                             max := now;
                             maxwhere := i;
                         end;
                       if (str.data[i] = '|') or (str.data[i] = '=')
                         then inc(i)
                         else if str.data[i] = '<' then inc(i , 2);
                   end;
                 inc(i);
             end;

    inc(exp.tot); now := exp.tot; analyze := now;
    if maxwhere = 0 then
      begin
          exp.data[now].sign := 7;
          exp.data[now].p1 := ord(str.data[start]) - ord('a') + 1;
          exit;
      end;

    t := maxwhere;
    if (str.data[t] = '|') or (str.data[t] = '=')
      then inc(t)
      else if str.data[t] = '<' then inc(t , 2);

    case str.data[maxwhere] of
      '!'      : exp.data[now].sign := 1;
      '&'      : exp.data[now].sign := 2;
      '|'      : exp.data[now].sign := 3;       // ||
      '<'      : exp.data[now].sign := 4;       // <=>
      '='      : exp.data[now].sign := 5;       // =>
      '#'      : exp.data[now].sign := 6;
    end;
    if str.data[maxwhere] <> '!'
      then begin
               exp.data[now].p1 := analyze(start , maxwhere - 1);
               exp.data[now].p2 := analyze(t + 1 , stop);
           end
      else exp.data[now].p1 := analyze(t + 1 , stop);
end;

procedure work;
begin
    Get_Next;

    exp.tot := 0;
    analyze(1 , str.len);
end;

function calc(root : longint) : boolean;
begin
    case exp.data[root].sign of
      1        : calc := not calc(exp.data[root].p1);
      2        : calc := calc(exp.data[root].p1) and calc(exp.data[root].p2);
      3        : calc := calc(exp.data[root].p1) or calc(exp.data[root].p2);
      4        : calc := (calc(exp.data[root].p1) = calc(exp.data[root].p2));
      5        : calc := (ord(calc(exp.data[root].p1)) <= ord(calc(exp.data[root].p2)));
      6        : calc := calc(exp.data[root].p1) xor calc(exp.data[root].p2);
      7        : calc := variable[exp.data[root].p1];
    end;
end;

procedure out;
var
    i , p , j  : longint;
    ans , first: boolean;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      first := true;
      for i := 0 to 1 shl LimitV - 1 do
        begin
            p := i;
            for j := 1 to LimitV do
              begin
                  variable[j] := odd(p);
                  p := p div 2;
              end;
            ans := calc(1);
            if not ans then continue;
            if not first then write('||');
            first := false;
            for j := 1 to LimitV do
              begin
                  if not variable[j] then write('!');
                  write(chr(j + ord('a') - 1));
                  if j <> LimitV then write('&');
              end;
        end;
      if first then
        write('a&!a');
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
