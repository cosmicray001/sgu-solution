{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p220.in';
    OutFile    = 'p220.out';
    Limit      = 50;
    LimitLen   = 100;

Type
    lint       = record
                     len      : longint;
                     data     : array[1..LimitLen] of longint;
                 end;
    Tdata      = record
                     tot      : longint;
                     data     : array[1..Limit] of longint;
                 end;
    Topt       = array[0..Limit , 0..Limit] of lint;

Var
    data1 ,
    data2      : Tdata;
    opt1 , opt2: Topt;
    answer     : lint;
    N , M      : longint;

procedure init;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M);
//    Close(INPUT);
end;

procedure times_single(num1 : lint; num2 : longint; var num3 : lint);
var
    i , jw ,
    tmp        : longint;
begin
    fillchar(num3 , sizeof(num3) , 0);
    i := 1; jw := 0;
    while (i <= num1.len) or (jw <> 0) do
      begin
          tmp := num1.data[i] * num2 + jw;
          jw := tmp div 10;
          num3.data[i] := tmp mod 10;
          inc(i);
      end;
    num3.len := i - 1;
end;

procedure add(num1 , num2 : lint; var num3 : lint);
var
    i , jw ,
    tmp        : longint;
begin
    fillchar(num3 , sizeof(num3) , 0);
    i := 1; jw := 0;
    while (i <= num1.len) or (i <= num2.len) or (jw <> 0) do
      begin
          tmp := num1.data[i] + num2.data[i] + jw;
          jw := tmp div 10;
          num3.data[i] := tmp mod 10;
          inc(i);
      end;
    num3.len := i - 1;
end;

procedure times(num1 , num2 : lint; var num3 : lint);
var
    i , j , jw : longint;
begin
    fillchar(num3 , sizeof(num3) , 0);
    for i := 1 to num1.len do
      for j := 1 to num2.len do
        inc(num3.data[i + j - 1] , num1.data[i] * num2.data[j]);
    i := 1; jw := 0;
    while (i <= num1.len + num2.len - 1) or (jw <> 0) do
      begin
          inc(num3.data[i] , jw);
          jw := num3.data[i] div 10;
          num3.data[i] := num3.data[i] mod 10;
          inc(i);
      end;
    num3.len := i - 1;
    while (num3.len > 1) and (num3.data[num3.len] = 0) do dec(num3.len);             
end;

procedure calc(const data : Tdata; var opt : Topt);
var
    i , j      : longint;
    tmp        : lint;
begin
    fillchar(opt , sizeof(opt) , 0);
    opt[0 , 0].len := 1; opt[0 , 0].data[1] := 1;
    for i := 1 to data.tot do
      for j := 0 to data.data[i] do
        begin
            fillchar(tmp , sizeof(tmp) , 0);
            if j = 0
              then tmp.len := 1
              else times_single(opt[i - 1 , j - 1] , data.data[i] - j + 1 , tmp);
            add(tmp , opt[i - 1 , j] , opt[i , j]);
        end;
end;

procedure work;
var
    i , j      : longint;
    tmp        : lint;
begin
    fillchar(answer , sizeof(answer) , 0); answer.len := 1;
    if M > 2 * N - 1 then exit;
    
    fillchar(data1 , sizeof(data1) , 0);
    fillchar(data2 , sizeof(data2) , 0);
    for i := 1 to N do
      if odd(i)
        then begin
                 inc(data1.tot); data1.data[data1.tot] := i;
                 inc(data1.tot); data1.data[data1.tot] := i;
             end
        else begin
                 inc(data2.tot); data2.data[data2.tot] := i;
                 inc(data2.tot); data2.data[data2.tot] := i;
             end;
    if odd(N) then dec(data1.tot) else dec(data2.tot);

    calc(data1 , opt1);
    calc(data2 , opt2);

    for i := 0 to data1.data[data1.tot] do
      begin
          j := M - i;
          if (j >= 0) and (j <= data2.data[data2.tot]) then
            begin
                times(opt1[data1.tot , i] , opt2[data2.tot , j] , tmp);
                add(answer , tmp , answer);
            end;
      end;
end;

procedure out;
var
    i          : longint;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := answer.len downto 1 do
        write(answer.data[i]);
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.