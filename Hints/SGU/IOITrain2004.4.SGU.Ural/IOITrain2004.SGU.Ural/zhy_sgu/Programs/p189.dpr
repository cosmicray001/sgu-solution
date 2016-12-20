{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
{$H+}
Const
    InFile     = 'p189.in';
    OutFile    = 'p189.out';
    LimitM     = 100;   

Type
    Tname      = string[20];
    Tnames     = array[1..LimitM] of Tname;
    Tdata      = array[1..Limitm] of string;

Var
    names      : Tnames;
    data       : Tdata;
    M          : longint;

function find_name(const s : Tname) : longint;
var
    i          : longint;
begin
    for i := 1 to M do
      if names[i] = s then
        begin
            find_name := i;
            exit;
        end;
    inc(M); names[M] := s; data[M] := '';
    find_name := M;
end;

procedure del_space(var s : string);
var
    i          : longint;
    inquotes   : boolean;
    news       : string;
begin
    inquotes := false;
    news := '';
    for i := 1 to length(s) do
      if s[i] = '"'
        then begin
                 inquotes := not inquotes;
                 news := news + s[i];
             end
        else if inquotes or (s[i] <> ' ')
               then news := news + s[i];
    s := copy(news , 1 , length(news) - 1);
end;

procedure analyze_sub(s : string; var p , o , c : longint; var ommit : boolean);
var
    comma ,
    code       : longint;
    s1         : string;
begin
    s := copy(s , 8 , length(s) - 8);
    comma := pos(',' , s);
    s1 := copy(s , 1 , comma - 1);
    delete(s , 1 , comma);
    p := find_name(s1);
    comma := pos(',' , s);
    if comma = 0
      then begin
               ommit := true;
               val(s , o , code);
           end
      else begin
               ommit := false;
               val(copy(s , 1 , comma - 1) , o , code);
               val(copy(s , comma + 1 , length(s) - comma) , c , code);
           end; 
end;

procedure analyze(s : string; var signal , p1 , o1 , c1 , p2 , o2 , c2 : longint;
                              var ommit1 , ommit2 : boolean);
                                     { signal : 1 -- $p1="value"
                                                2 -- print($p1)
                                                3 -- print(substr($p1,$o1,$c1))
                                                4 -- $p1=$p2
                                                5 -- $p1=substr($p1,$o2,$c2)
                                                6 -- substr($p1,$o1,$c1)=$p2
                                                7 -- substr($p1,$o1,$c1)=substr($p1,$o2,$c2) }
var
    equal      : longint;
    s1 , s2    : string;
begin
    equal := pos('=' , s);
    p1 := 0; o1 := 0; c1 := 0; p2 := 0; o2 := 0; c2 := 0;
    ommit1 := false; ommit2 := false;
    if equal <> 0
      then begin
               s1 := copy(s , 1 , equal - 1);
               s2 := copy(s , equal + 1 , length(s) - equal);
               if s1[1] = '$'
                 then begin p1 := find_name(s1); signal := 0; end
                 else begin analyze_sub(s1 , p1 , o1 , c1 , ommit1); signal := 1; end;
               if s2[1] = '"'
                 then begin
                          data[p1] := copy(s2 , 2 , length(s2) - 2);
                          signal := 1; exit;
                      end
                 else if s2[1] = '$'
                        then begin p2 := find_name(s2); signal := signal * 2; end
                        else begin analyze_sub(s2 , p2 , o2 , c2 , ommit2); signal := signal * 2 + 1; end;
               signal := signal + 4;
           end
      else begin
               s := copy(s , 7 , length(s) - 7);
               if s[1] = '$'
                 then begin p1 := find_name(s); signal := 2; end
                 else begin analyze_sub(s , p1 , o1 , c1 , ommit1); signal := 3; end;
           end;
end;

procedure process(var p , o , c : longint; ommit : boolean);
begin
    if o >= 0
      then inc(o)
      else o := length(data[p]) + o + 1;
    if ommit
      then c := length(data[p]) - o + 1
      else if c < 0
             then c := length(data[p]) - o + 1 + c;
end;

procedure main;
var
    N1 , N2 , i ,
    signal , p1 , o1 , c1 ,
    p2 , o2 , c2
               : longint;
    s , news   : string;
    ommit1 , ommit2
               : boolean;
begin
    readln(N1 , N2);
    for i := 1 to N1 + N2 do
      begin
          readln(s);
          del_space(s);
          analyze(s , signal , p1 , o1 , c1 , p2 , o2 , c2 , ommit1 , ommit2);
          process(p1 , o1 , c1 , ommit1);
          process(p2 , o2 , c2 , ommit2);
          case signal of
            2                 : writeln(data[p1]);
            3                 : writeln(copy(data[p1] , o1 , c1));
            4                 : data[p1] := data[p2];
            5                 : data[p1] := copy(data[p2] , o2 , c2);
            6 , 7             : begin
                                    if signal = 6
                                      then news := data[p2]
                                      else news := copy(data[p2] , o2 , c2);
                                    data[p1] := copy(data[p1] , 1 , o1 - 1) + news + copy(data[p1] , o1 + c1 , length(data[p1]) - o1 - c1 + 1); 
                                end;
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
