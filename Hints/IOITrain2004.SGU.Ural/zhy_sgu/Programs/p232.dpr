{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p232.in';
    OutFile    = 'p232.out';
    Limit      = 150000;

Type
    Tdata      = record
                     total    : longint;
                     data     : array[1..Limit] of char;
                 end;
    Tvisited   = array[1..Limit] of boolean;

Var
    data ,
    answer     : Tdata;
    visited    : Tvisited;
    N , K      : longint;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(N , K);
      for i := 1 to N do
        read(data.data[i]);
      data.total := N;
      K := K mod N;
//    Close(INPUT);
end;

function compare(const s : Tdata; i , j : longint; var p : longint) : boolean;
var
    x , y      : longint;
begin
    p := 1;
    while p <= s.total do
      begin
          x := (i + p - 2) mod s.total + 1;
          y := (j + p - 2) mod s.total + 1;
          if s.data[x] <> s.data[y] then
            begin
                compare := (s.data[x] < s.data[y]);
                exit;
            end;
          inc(p);
      end;
    compare := false;
end;

procedure Get_Largest(const s : Tdata; var s2 : Tdata);
var
    i , j , p  : longint;
begin
    i := 1; j := 2;
    while j <= s.total do
      begin
          if compare(s , i , j , p)
            then begin
                     if i + p > j
                       then i := i + p
                       else i := j;
                     j := i + 1;
                 end
            else j := j + p;
      end;
    j := i;
    for i := 1 to s.total do
      begin
          s2.data[i] := s.data[j];
          j := j mod s.total + 1;
      end;
    s2.total := s.total;
end;

function bigger(const s1 , s2 : Tdata) : boolean;
var
    i          : longint;
begin
    if s2.total = 0
      then bigger := true
      else begin
               for i := 1 to s1.total do
                 if s1.data[i] <> s2.data[i] then
                   begin
                       bigger := (s1.data[i] > s2.data[i]);
                       exit;
                   end;
               bigger := false;
           end;
end;

procedure work;
var
    news ,
    newlargest : Tdata;
    i , j      : longint;
begin
    fillchar(visited , sizeof(visited) , 0);
    answer.total := 0;
    for i := 1 to N do
      if not visited[i] then
        begin
            news.total := 0;
            j := i;
            while not visited[j] do
              begin
                  visited[j] := true;
                  inc(news.total);
                  news.data[news.total] := data.data[j];
                  j := (j + K - 1) mod N + 1;
              end;
            Get_Largest(news , newlargest);
            if bigger(newlargest , answer) then
              begin
                  for j := 1 to newlargest.total do
                    answer.data[j] := newlargest.data[j];
                  answer.total := newlargest.total;
              end;
        end;
end;

procedure out;
var
    i , p      : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      p := 1;
      for i := 1 to N do
        begin
            write(answer.data[p]);
            inc(p);
            if p > answer.total then p := 1;
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.