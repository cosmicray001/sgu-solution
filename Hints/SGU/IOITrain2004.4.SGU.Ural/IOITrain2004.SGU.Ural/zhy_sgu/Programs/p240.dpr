{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p240.in';
    OutFile    = 'p240.out';
    Limit      = 100;

Type
    Tkey       = record
                     R , P , T               : longint;
                 end;
    Tdata      = array[1..Limit , 1..Limit] of Tkey;
    Tshortest  = array[1..Limit] of
                   record
                       data , father         : longint;
                   end;
    Tpath      = record
                     total                   : longint;
                     data                    : array[1..Limit] of longint;
                 end;
    Tvisited   = array[1..Limit] of boolean;
    
Var
    data       : Tdata;
    exits ,
    visited    : Tvisited;
    shortest   : Tshortest;
    path       : Tpath;
    N , H , S ,
    bound      : longint;
    answer     : boolean;

procedure init;
var
    i ,
    M , E ,
    x , y      : longint;
begin
    fillchar(data , sizeof(data) , 0);
    fillchar(exits , sizeof(exits) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M , H , S , E);
      for i := 1 to M do
        begin
            read(x , y);
            read(data[x , y].T , data[x , y].R , data[x , y].P);
            data[y , x] := data[x , y];
        end;
      for i := 1 to E do
        begin
            read(x);
            exits[x] := true;
        end;
//    Close(INPUT);
end;

function canpass(bound , t : longint; key : Tkey) : boolean;
var
    nowTemp    : longint;
begin
    nowTemp := (t + key.T) * key.P + key.R;
    canpass := (nowTemp <= bound);
end;

function check(bound : longint) : boolean;
var
    i , j , min: longint;
begin
    fillchar(visited , sizeof(visited) , 0);
    fillchar(shortest , sizeof(shortest) , $FF);
    shortest[S].data := 0;
    check := false;
    for i := 1 to N do
      begin
          min := 0;
          for j := 1 to N do
            if not visited[j] and (shortest[j].data <> -1) then
              if (min = 0) or (shortest[j].data < shortest[min].data) then
                min := j;

          if min = 0 then exit;
          visited[min] := true;
          if exits[min] then break;

          for j := 1 to N do
            if not visited[j] and (data[min , j].T > 0) and canpass(bound , shortest[min].data , data[min , j]) then
              if (shortest[j].data = -1) or (shortest[j].data > shortest[min].data + data[min , j].T) then
                begin
                    shortest[j].data := shortest[min].data + data[min , j].T;
                    shortest[j].father := min;
                end;

      end;

    check := true;
    path.total := 0;
    while min <> -1 do
      begin
          inc(path.total);
          path.data[path.total] := min;
          min := shortest[min].father;
      end;
end;

procedure work;
var
    i          : longint;
begin
    answer := true;
    for i := 0 to H do
      if check(i) then
        begin
            bound := i;
            exit;
        end;
    answer := false;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if answer
        then begin
                 writeln('YES');
                 writeln(Bound);
                 write(path.total);
                 for i := path.total downto 1 do
                   write(' ' , path.data[i]);
                 writeln;
             end
        else writeln('NO');
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.