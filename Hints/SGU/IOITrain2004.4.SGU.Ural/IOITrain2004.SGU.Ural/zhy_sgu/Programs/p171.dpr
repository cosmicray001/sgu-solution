{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p171.in';
    OutFile    = 'p171.out';
    LimitN     = 16000;
    LimitK     = 100;

Type
    Trec       = record
                     weight , P , num        : integer;
                 end;
    Tdata      = array[1..LimitN] of Trec;
    Tprec      = record
                     Q , N , num             : integer;
                 end;
    Tpart      = array[1..LimitK] of Tprec;
    TZ         = array[1..LimitN] of integer;

Var
    data       : Tdata;
    part       : Tpart;
    Z          : TZ;
    M , K      : integer;

procedure init;
var
    i , j      : integer;
    key        : Tprec;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      readln(K);
      M := 0;
      for i := 1 to K do
        begin
            read(part[i].N);
            inc(M , part[i].N);
            part[i].num := i;
        end;
      for i := 1 to K do
        read(part[i].Q);
      for i := 2 to K do
        begin
            key := part[i];
            j := i;
            while (j > 1) and (part[j - 1].Q < key.Q) do
              begin
                  part[j] := part[j - 1];
                  dec(j);
              end;
            part[j] := key;
        end;
      for i := 1 to M do
        begin
            read(data[i].P);
            data[i].num := i;
        end;
      for i := 1 to M do
        read(data[i].weight);
//    Close(INPUT);
end;

procedure qk_pass(start , stop : integer; var mid : integer);
var
    key        : Trec;
    tmp        : integer;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and (data[stop].weight > key.weight) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and (data[start].weight < key.weight) do inc(start);
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

procedure work;
var
    i , j      : integer;
begin
    qk_sort(1 , M);
    for i := M downto 1 do
      begin
          j := 1;
          while j <= K do
            begin
                if (part[j].N > 0) and (part[j].Q < data[i].P) then
                  begin
                      dec(part[j].N);
                      Z[data[i].num] := part[j].num;
                      break;
                  end;
                inc(j);
            end;
          if j > K then
            begin
                j := 1;
                while (part[j].N = 0) do inc(j);
                dec(part[j].N);
                Z[data[i].num] := part[j].num;
            end;
      end;
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      for i := 1 to M do
        write(Z[i] , ' ');
      writeln;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
