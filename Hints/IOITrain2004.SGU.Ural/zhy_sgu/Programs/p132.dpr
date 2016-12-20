{ $A+,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{ $MINSTACKSIZE $00004000}
{ $MAXSTACKSIZE $00100000}
{ $IMAGEBASE $00400000}
{ $APPTYPE GUI}
{ $R+,Q+,S+}
Const
    InFile     = 'p132.in';
    OutFile    = 'p132.out';
    LimitM     = 70;
    LimitN     = 7;
    LimitCount = 1 shl LimitN;
    Base       : array[0..LimitN] of integer
               = (1 , 3 , 9 , 27 , 81 , 243 , 729 , 2187);
    LimitBase  = 2187;
    LimitValid = 100;
    LimitActs  = 400;

Type
    Tdata      = array[0..LimitM] of integer;
    Topt       = array[0..1 , 0..LimitCount , 0..LimitCount] of integer;
    Tvalid     = array[0..LimitCount] of integer;
    Tact       = array[0..LimitBase , 1..2] of integer;
    Tpiece     = array[0..LimitBase] of integer;
    Tvalidstate= array[1..LimitValid] of integer;
    Tacts      = array[0..LimitCount] of
                   record
                       total                 : integer;
                       data                  : array[1..LimitActs] of integer;
                   end;

Var
    data       : Tdata;
    opt        : Topt;
    valid      : Tvalid;
    act        : Tact;
    piece      : Tpiece;
    validstate : Tvalidstate;
    acts       : Tacts;
    N , M ,
    Count , totalvalid ,
    answer ,
    now        : integer;

procedure init;
var
    i , j      : integer;
    c          : char;
begin
    fillchar(data , sizeof(data) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(M , N);
      for i := 1 to M do
        begin
            for j := 1 to N do
              begin
                  read(c);
                  data[i] := data[i] shl 1 + ord(C = '*');
              end;
            readln;
        end;
//    Close(INPUT);
end;

function check(state : integer) : integer;
var
    last , i   : integer;
begin
    check := 0;
    last := 1;
    for i := 1 to N do
      if (last = 0) and not odd(state) then
        exit
      else
        begin
            last := state and 1;
            state := state shr 1;
        end;
    check := 1;
end;

function checkact(act : integer) : integer;
var
    i , last   : integer;
begin
    checkact := 0;
    last := 1;
    for i := 1 to N do
      if (last <> 0) and (act mod 3 = 1) then
        exit
      else
        begin
            last := act mod 3;
            act := act div 3;
        end;
    checkact := 1;
end;

procedure GetAct(active : integer; var state1 , state2 , piece : integer);
var
    i          : integer;
begin
    state1 := 0; state2 := 0; piece := 0;
    for i := 1 to N do
      begin
          case active mod 3 of
            1  : begin
                     inc(piece);
                     state2 := state2 or (3 shl (i - 2));
                 end;
            2  : begin
                     inc(piece);
                     state1 := state1 or (1 shl (i - 1));
                     state2 := state2 or (1 shl (i - 1));
                 end;
          end;
          active := active div 3;
      end;
end;

procedure work;
var
    i , p1 , p2 ,
    p3 , j , k ,
    tmp ,
    newstate1 ,
    newstate2  : integer;
begin
    now := 0;
    Count := 1 shl N - 1;
    totalvalid := 0;
    for i := 0 to Count do
      begin
          valid[i] := check(i);
          if valid[i] = 1 then
            begin
                inc(totalvalid);
                validstate[totalvalid] := i;
            end;
      end;
    for i := 0 to Base[N] - 1 do
      if checkact(i) = 1 then
        begin
            GetAct(i , act[i , 1] , act[i , 2] , piece[i]);
            for j := 0 to Count do
              if (j or act[i , 1] = j + act[i , 1]) and (valid[j or act[i , 1]] = 1) then
                begin
                    inc(acts[j].total);
                    acts[j].data[acts[j].total] := i;
                end;
        end;

    fillchar(opt , sizeof(opt) , $FF);
    opt[0 , count , count] := 0;
    now := 0;
    for i := 1 to M do
      begin
          now := 1 - now;
          fillchar(opt[now] , sizeof(opt[now]) , $FF);
          for k := 1 to totalvalid do
            begin
                p1 := validstate[k];
                for p2 := 0 to Count do
                  if opt[1 - now , p1 , p2] >= 0 then
                    for j := 1 to acts[p2].total do
                      begin
                          p3 := acts[p2].data[j];
                          newstate1 := p2 or act[p3 , 1];
                          newstate2 := data[i] or act[p3 , 2];
                          if (newstate2 = act[p3 , 2] + data[i])and (p1 or newstate1 = Count) then
                            begin
                                tmp := opt[1 - now , p1 , p2] + piece[p3];
                                if (opt[now , newstate1 , newstate2] < 0) or (opt[now , newstate1 , newstate2] > tmp) then
                                  opt[now , newstate1 , newstate2] := tmp;
                            end;
                      end;
            end;
      end;

    answer := -1;
    for p1 := 0 to Count do
      for p2 := 0 to Count do
        if (valid[p2] = 1) and (p1 or p2 = Count) and (opt[now , p1 , p2] >= 0) then
          if (answer < 0) or (answer > opt[now , p1 , p2]) then
            answer := opt[now , p1 , p2];
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
