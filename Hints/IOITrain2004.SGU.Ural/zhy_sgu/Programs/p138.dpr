{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p138.in';
    OutFile    = 'p138.out';
    Limit      = 100;

Type
    Tperson    = record
                     degree , name           : integer;
                 end;
    Tdata      = array[1..Limit] of Tperson;
    Tmap       = array[1..Limit , 1..Limit] of integer;

Var
    data       : Tdata;
    map        : Tmap;
    N , stop ,
    total      : integer;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N);
      total := 0;
      for i := 1 to N do
        begin
            data[i].name := i;
            read(data[i].degree);
            inc(total , data[i].degree);
        end;
//    Close(INPUT);
end;

procedure qk_pass(start , stop : integer; var mid : integer);
var
    key        : Tperson;
    tmp        : integer;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and (data[stop].degree < key.degree) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and (data[start].degree > key.degree) do inc(start);
          data[stop] := data[start];
          if start < stop then dec(stop);
      end;
    mid := start;
    data[start] := key;
end;

procedure qk_sort(start , stop : integer);
var
    mid        : integer;
begin
    if start < stop then
      begin
          qk_pass(start , stop , mid);
          qk_sort(start , mid - 1);
          qk_sort(mid + 1 , stop);
      end;
end;

procedure find_max(start , stop , cantequal : integer; var p : integer);
var
    i          : integer;
begin
    p := 0;
    for i := start to stop do
      if i <> cantequal then
        if (p = 0) or (data[p].degree < data[i].degree) then
          p := i;
end;

procedure work;
var
    sum , i , p ,
    p1 , p2    : integer;
begin
    qk_sort(1 , N);
    fillchar(map , sizeof(map) , 0);
    sum := data[1].degree;
    stop := 1;
    while sum - stop * 2 + 2 < total - sum do
      begin
          inc(stop);
          inc(sum , data[stop].degree);
      end;
    for i := 2 to stop - 1 do
      dec(data[i].degree , 2);
    if stop <> 1 then
      begin
          dec(data[1].degree);
          dec(data[stop].degree);
      end;

    fillchar(map , sizeof(map) , 0);
    for i := stop + 1 to N do
      while data[i].degree <> 0 do
        begin
            find_max(1 , stop , 0 , p);
            inc(map[p , i]);
            dec(data[i].degree);
            dec(data[p].degree);
        end;
    while true do
      begin
          find_max(1 , stop , 0 , p1);
          if data[p1].degree = 0 then
            break
          else
            begin
                find_max(1 , stop , p1 , p2);
                dec(data[p1].degree); dec(data[p2].degree);
                inc(map[p1 , p2]);
            end;
      end;
end;

procedure out;
var
    i , j      : integer;         
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      writeln(total div 2);
      for i := 1 to stop do
        begin
            for j := 1 to N do
              while map[i , j] <> 0 do
                begin
                    writeln(data[i].name , ' ' , data[j].name);
                    dec(map[i , j]);
                end;
            if i <> stop then
              writeln(data[i + 1].name , ' ' , data[i].name);
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
