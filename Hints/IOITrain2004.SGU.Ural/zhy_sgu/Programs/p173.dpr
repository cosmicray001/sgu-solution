{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p173.in';
    OutFile    = 'p173.out';
    Limit      = 50;
    LimitM     = 10;
    LimitL     = 200;

Type
    Tdata      = array[1..Limit] of longint;
    Tsample    = array[1..LimitL] of
                   record
                       source , target       : Tdata;
                   end;
    Tmatrix    = array[1..LimitL + 1 , 1..Limit + 1] of longint;
    Ttrans     = array[1..LimitM] of
                   record
                       S , D                 : longint;
                   end;

Var
    data ,
    Vector     : Tdata;
    sample     : Tsample;
    trans      : Ttrans;
    matrix     : Tmatrix;
    N , M ,
    L , K      : longint;

procedure read_num(var num : longint);
var
    c          : char;
begin
    read(c);
    num := ord(c) - ord('0');
end;

procedure init;
var
    i , j      : longint;
begin
//    assign(INPUT , inFile); ReSet(INPUT);
      readln(N , M , K , L);
      for i := 1 to M do
        read(trans[i].S , trans[i].D);
      readln;
      for i := 1 to L do
        begin
            for j := 1 to K do
              read_num(sample[i].source[j]);
            readln;
            for j := 1 to K do
              read_num(sample[i].target[j]);
            readln;
        end;
      for i := 1 to N do
        read_num(data[i]);
      readln;
//    Close(INPUT);
end;

procedure find(start : longint; var p : longint);
var
    i          : longint;
begin
    for i := start to L do
      if matrix[i , start] = 1 then
        begin
            p := i;
            exit;
        end;
end;

procedure swap_line(p1 , p2 : longint);
var
    i , tmp    : longint;
begin
    for i := 1 to K do
      begin
          tmp := matrix[p1 , i];
          matrix[p1 , i] := matrix[p2 , i];
          matrix[p2 , i] := tmp;
      end;
end;

procedure Get_Vector;
var
    i , j , p  : longint;
begin
    for i := 1 to L do
      begin
          for j := 2 to K do
            matrix[i , j - 1] := sample[i].source[j];
          matrix[i , K] := sample[i].source[1] xor sample[i].target[K];
      end;
    for i := 1 to K - 1 do
      begin
          find(i , p);
          swap_line(i , p);
          for j := i + 1 to L do
            if matrix[j , i] = 1 then
              for p := 1 to K do
                matrix[j , p] := matrix[j , p] xor matrix[i , p];
      end;
    for i := K - 1 downto 1 do
      begin
          p := 0;
          for j := i + 1 to K - 1 do
            p := p xor (matrix[i , j] and Vector[K - j]);
          Vector[K - i] := p xor matrix[i , K];
      end;
end;

procedure multi(A , B : Tmatrix; var C : Tmatrix);
var
    i , j , p  : longint;
begin
    for i := 1 to K do
      for j := 1 to K do
        begin
            C[i , j] := 0;
            for p := 1 to K do
              C[i , j] := C[i , j] xor (A[i , p] and B[p , j]);
        end;
end;

procedure Transform(source : Tdata; times : longint; var target : Tdata);
var
    A ,
    power      : Tmatrix;
    i          : longint;
begin
    fillchar(A , sizeof(A) , 0); fillchar(power , sizeof(power) , 0);
    for i := K downto 2 do
      power[i , K] := Vector[i - 1];
    power[1 , K] := 1;
    for i := K downto 2 do
      power[i , i - 1] := 1;
    for i := 1 to K do
      A[1 , i] := source[i];
    while times <> 0 do
      begin
          if odd(times) then
            multi(A , power , A);
          multi(power , power , power);
          times := times div 2;
      end;
    for i := 1 to K do
      target[i] := A[1 , i];
end;

procedure Calc_Answer;
var
    i , j      : longint;
    source ,
    target     : Tdata;
begin
    for i := M downto 1 do
      begin
          for j := 1 to K do
            source[K - j + 1] := data[trans[i].S + j - 1];
          transform(source , trans[i].D , target);
          for j := 1 to K do
            data[trans[i].S + j - 1] := target[K - j + 1];
      end;
end;

procedure work;
begin
    Get_Vector;

    Calc_Answer;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to N do
        write(data[i]);
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
