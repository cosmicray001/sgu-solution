{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p177.in';
    OutFile    = 'p177.out';
    Limit      = 1000;
    LimitM     = 10000;

Type
    Trect      = record
                     x1 , y1 , x2 , y2 , c   : integer;
                 end;
    Tpaint     = array[1..LimitM] of Trect;
    Tcolor     = array[1..Limit] of integer;
    Tnext      = array[0..Limit] of integer;

Var
    color      : Tcolor;
    next       : Tnext;
    paint      : Tpaint;
    N , M ,
    answer     : integer;

procedure init;
var
    i , tmp    : integer;
    c          : char;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N , M);
      for i := 1 to M do
        begin
            with paint[i] do
              begin
                  read(x1 , y1 , x2 , y2);
                  if x1 > x2 then
                    begin
                        tmp := x1; x1 := x2; x2 := tmp;
                    end;
                  if y1 > y2 then
                    begin
                        tmp := y1; y1 := y2; y2 := tmp;
                    end;
              end;
            read(c);
            while c = ' ' do
              read(c);
            if c = 'w' then
              paint[i].c := 1
            else
              paint[i].c := 2;
            readln;
        end;
//    Close(INPUT);
end;

procedure work;
type
    Tpath      = record
                     total    : integer;
                     data     : array[1..Limit] of integer;
                 end;
var
    i , j , p ,
    k          : integer;
    path       : Tpath;
begin
    answer := N * N;
    for i := 1 to N do
      begin
          fillchar(color , sizeof(color) , 0);
          fillchar(next , sizeof(next) , 0);

          for j := 1 to N do
            next[j] := j + 1;

          for j := M downto 1 do
            if (paint[j].y1 <= i) and (paint[j].y2 >= i) then
              begin
                  path.total := 0;
                  p := paint[j].x1;
                  while p <= paint[j].x2 do
                    begin
                        if color[p] = 0 then
                          begin
                              color[p] := paint[j].c;
                              if color[p] = 2 then
                                dec(answer);
                          end;
                        inc(path.total);
                        path.data[path.total] := p;
                        p := next[p];
                    end;
                  for k := 1 to path.total do
                    next[path.data[k]] := p;
              end;
      end;
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
