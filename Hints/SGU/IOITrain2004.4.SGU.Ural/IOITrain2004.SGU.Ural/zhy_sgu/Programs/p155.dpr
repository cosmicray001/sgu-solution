{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p155.in';
    OutFile    = 'p155.out';
    Limit      = 50000;
    LimitTree  = 131072;
    LimitEle   = LimitTree div 2;

Type
    Trec       = record
                     k , a , number          : integer;
                 end;
    Tdata      = array[0..Limit] of Trec;
    Tanswer    = array[0..Limit] of
                   record
                       father , lc , rc      : integer;
                   end;
    Ttree      = array[1..LimitTree] of
                   record
                       minnum , position     : integer;
                   end;

Var
    data       : Tdata;
    answer     : Tanswer;
    tree       : Ttree;
    noanswer   : boolean;
    N          : integer;

procedure init;
var
    i          : integer;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
      fillchar(data , sizeof(data) , 0);
      readln(N);
      for i := 1 to N do
        begin
            with data[i] do
              readln(k , a);
            data[i].number := i;
        end;
//    Close(INPUT);
end;

procedure qk_pass(start , stop : integer; var mid : integer);
var
    tmp        : integer;
    key        : Trec;
begin
    tmp := random(stop - start + 1) + start;
    key := data[tmp]; data[tmp] := data[start];
    while start < stop do
      begin
          while (start < stop) and (data[stop].k > key.k) do dec(stop);
          data[start] := data[stop];
          if start < stop then inc(start);
          while (start < stop) and (data[start].k < key.k) do inc(start);
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

function Get_Min_sub(start , stop : integer) : integer;
var
    i , newstart ,
    newstop ,
    minpos     : integer;
begin
    if start <= stop then
      if start = stop then
        Get_Min_sub := tree[start].position
      else
        begin
            minpos := 0;
            newstart := start div 2;
            if odd(start) then
              begin
                  newstart := (start + 1) div 2;
                  if (minpos = 0) or (data[minpos].a > tree[start].minnum) then
                    minpos := tree[start].position;
              end;
            newstop := stop div 2;
            if not odd(stop) then
              begin
                  newstop := (stop - 1) div 2;
                  if (minpos = 0) or (data[minpos].a > tree[stop].minnum) then
                    minpos := tree[stop].position;
              end;
            i := Get_Min_sub(newstart , newstop);
            if (i <> 0) and ((minpos = 0) or (data[minpos].a > data[i].a)) then
              minpos := i;

            Get_Min_sub := minpos;
        end
    else
      Get_Min_sub := 0;
end;

function Get_Min(start , stop : integer) : integer;
begin
    Get_Min := Get_Min_sub(start + LimitEle - 1 , stop + LimitEle - 1);
end;

procedure Creat_Answer(start , stop , father : integer);
var
    root       : integer;
begin
    if not noanswer then
      begin
          root := Get_Min(start , stop);

          if data[father].a >= data[root].a then
            noanswer := true
          else
            begin
                if root < father then
                  Answer[data[father].number].lc := data[root].number
                else
                  Answer[data[father].number].rc := data[root].number;
                Answer[data[root].number].father := data[father].number;

                if start < root then
                  Creat_Answer(start , root - 1 , root);
                if root < stop then
                  Creat_Answer(root + 1 , stop , root);
            end;
      end;
end;

procedure work;
var
    i          : integer;
begin
    qk_sort(1 , N);
    data[0].a := -maxlongint;

    for i := 1 to N - 1 do
      if data[i].k = data[i + 1].k then
        begin
            noanswer := true;
            exit;
        end;

    for i := LimitEle to LimitTree do
      begin
          if i - LimitEle + 1 > N then
            tree[i].minnum := maxlongint
          else
            tree[i].minnum := data[i - LimitEle + 1].a;
          tree[i].position := i - LimitEle + 1;
      end;
    for i := LimitEle - 1 downto 1 do
      if tree[i * 2].minnum < tree[i * 2 + 1].minnum then
        tree[i] := tree[i * 2]
      else
        tree[i] := tree[i * 2 + 1];

    fillchar(answer , sizeof(answer) , 0);
    noanswer := false;
    Creat_Answer(1 , N , 0);
end;

procedure out;
var
    i          : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if noanswer then
        writeln('NO')
      else
        begin
            writeln('YES');
            for i := 1 to N do
              with answer[i] do
                writeln(father , ' ' , lc , ' ' , rc);
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
