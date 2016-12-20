{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p180.in';
    OutFile    = 'p180.out';
    Limit      = 70000;

Type
    Tdata      = array[1..Limit] of longint;

Var
    data , tmp : Tdata;
    N          : longint;
    answer     : comp;

procedure init;
var
    i          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      for i := 1 to N do
        read(data[i]);
//    Close(INPUT);
end;

procedure Merger_Pass(s1 , t1 , s2 , t2 : longint);
var
    tot , i ,
    p1 , p2    : longint;
begin
    tot := 0; p1 := s1; p2 := s2;
    while (s1 <= t1) or (s2 <= t2) do
      if (s1 <= t1) and ((s2 > t2) or (data[s1] <= data[s2]))
        then begin
                 inc(tot); tmp[tot] := data[s1]; inc(s1);
                 answer := answer + s2 - p2;
             end
        else begin
                 inc(tot); tmp[tot] := data[s2]; inc(s2);
             end;
    for i := p1 to t2 do
      data[i] := tmp[i - p1 + 1];
end;

procedure Merger_Sort(start , stop : longint);
var
    mid        : longint;
begin
    if start < stop then
      begin
          mid := (start + stop) div 2;
          Merger_Sort(start , mid);
          Merger_Sort(mid + 1 , stop);
          Merger_Pass(start , mid , mid + 1 , stop);
      end;
end;

procedure work;
begin
    answer := 0;
    Merger_Sort(1 , N);
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(answer : 0 : 0);
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
