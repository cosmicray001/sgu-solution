{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p191.in';
    OutFile    = 'p191.out';
    Limit      = 30000;

Type
    Tdata      = array[1..Limit] of char;

Var
    data1 ,
    data2      : Tdata;
    Len1 ,
    Len2       : longint;
    answer     : boolean;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      Len1 := 0;
      while not eoln do
        begin
            inc(Len1);
            read(data1[Len1]);
        end;
      readln; Len2 := 0;
      while not eoln do
        begin
            inc(Len2);
            read(data2[Len2]);
        end;
//    Close(INPUT);
end;

procedure swap;
var
    i          : longint;
    tmp        : char;
begin
    for i := 1 to Len1 div 2 do
      begin
          tmp := data1[i]; data1[i] := data1[Len1 - i + 1];
          data1[Len1 - i + 1] := tmp;
      end;
    for i := 1 to Len2 div 2 do
      begin
          tmp := data2[i]; data2[i] := data2[Len2 - i + 1];
          data2[Len2 - i + 1] := tmp;
      end;
end;

procedure work;
begin
    swap;
    while (Len1 > 0) and (Len1 <= Len2) do
      if data1[Len1] <> data2[Len2]
        then begin
                 dec(Len1); dec(Len2);
             end
        else begin
                 inc(Len1);
                 if data1[Len1 - 1] = 'A'
                   then data1[Len1] := 'B'
                   else data1[Len1] := 'A';
                 dec(Len2);
             end;
      answer := (Len1 = 0) and (Len2 = 0);
end;

procedure out;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if answer
        then writeln('YES')
        else writeln('NO');
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
