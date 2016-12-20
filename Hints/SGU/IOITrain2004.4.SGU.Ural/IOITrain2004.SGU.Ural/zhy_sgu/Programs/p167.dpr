{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p167.in';
    OutFile    = 'p167.out';
    Limit      = 15;

Type
    Tdata      = array[1..Limit , 0..Limit] of integer;
    Topt       = array[1..Limit , 1..Limit , 1..Limit , 0..1 , 0..1 , 0..Limit * Limit] of
                   record
                       num                   : integer;
                       left , right , code   : byte;
                   end;

Var
    data       : Tdata;
    opt        : Topt;
    N , M , sum ,
    maxLine ,
    maxLeft ,
    maxRight ,
    maxLeftcode ,
    maxRightcode
               : integer;

procedure init;
var
    i , j      : integer;
begin
    fillchar(data , sizeof(data) , 0);
//    assign(INPUT , InFile); ReSet(INPUT);
      read(N , M , sum);
      for i := 1 to N do
        for j := 1 to M do
          begin
              read(data[i , j]);
              inc(data[i , j] , data[i , j - 1]);
          end;
//    Close(INPUT);
end;

procedure work;
var
    newp1 ,
    newp2 ,
    p1 , p2 , i ,
    leftcode ,
    rightcode ,
    lcode ,
    rcode ,
    code1 ,
    code2 ,
    k , newsum : integer;
begin
    fillchar(opt , sizeof(opt) , $FF);
    for p1 := 1 to M do
      for p2 := p1 to M do
        for leftcode := 0 to 1 do
          for rightcode := 0 to 1 do
            opt[1 , p1 , p2 , leftcode , rightcode , p2 - p1 + 1].num := data[1 , p2] - data[1 , p1 - 1];

    for i := 2 to N do
      for p1 := 1 to M do
        for p2 := p1 to M do
          begin
              for k := 1 to sum do
                if p2 - p1 + 1 < k then
                   begin
                       newsum := k - p2 + p1 - 1;
                       for newp1 := 1 to M do
                         for newp2 := newp1 to M do
                           if (newp1 <= p2) and (newp2 >= p1) then
                           begin
                               if newp1 < p1 then
                                 leftcode := 1
                               else
                                 leftcode := 0;
                               if newp2 > p2 then
                                 rightcode := 0
                               else
                                 rightcode := 1;

                               for lcode := 0 to leftcode + ord(newp1 = p1) do
                                 for rcode := rightcode - ord(newp2 = p2) to 1 do
                                   if opt[i - 1 , newp1 , newp2 , lcode , rcode , newsum].num >= 0 then
                                     for code1 := lcode to 1 do
                                       if code1 >= leftcode then
                                         for code2 := 0 to rcode do
                                           if code2 <= rightcode then
                                             if opt[i , p1 , p2 , code1 , code2 , k].num <
                                               opt[i - 1 , newp1 , newp2 , lcode , rcode , newsum].num + data[i , p2] - data[i , p1 - 1] then
                                               begin
                                                   opt[i , p1 , p2 , code1 , code2 , k].num := opt[i - 1 , newp1 , newp2 , lcode , rcode , newsum].num + data[i , p2] - data[i , p1 - 1];
                                                   opt[i , p1 , p2 , code1 , code2 , k].left := newp1;
                                                   opt[i , p1 , p2 , code1 , code2 , k].right := newp2;
                                                   opt[i , p1 , p2 , code1 , code2 , k].code := lcode * 2 + rcode;
                                               end;
                           end;
                   end;

              for leftcode := 0 to 1 do
                for rightcode := 0 to 1 do
                  opt[i , p1 , p2 , leftcode , rightcode , p2 - p1 + 1].num := data[i , p2] - data[i , p1 - 1];
          end;

    maxLine := 0;
    for i := 1 to N do
      for p1 := 1 to M do
        for p2 := p1 to M do
          for leftcode := 0 to 1 do
            for rightcode := 0 to 1 do
              if opt[i , p1 , p2 , leftcode , rightcode , sum].num >= 0 then
                if (maxLine = 0) or (opt[i , p1 , p2 , leftcode , rightcode , sum].num > opt[maxLine , maxLeft , maxRight , maxLeftcode , maxRightcode , sum].num) then
                  begin
                      maxLine := i;
                      maxLeft := p1;
                      maxRight := p2;
                      maxLeftcode := leftcode;
                      maxRightcode := rightcode;
                  end;
end;

procedure out;
var
    tmpSum , i ,
    Line , left , right ,
    leftcode ,
    rightcode ,
    newleft ,
    newRight ,
    newLeftcode ,
    newRightcode
               : integer;
begin
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      if sum = 0 then
        writeln('Oil : 0')
      else
        begin
            writeln('Oil : ' , opt[maxLine , maxLeft , maxRight , maxLeftcode , maxRightcode , sum].num);
            tmpSum := sum; Line := maxLine; left := maxLeft; right := maxRight;
            leftcode := maxLeftcode; rightcode := maxRightcode;
             while tmpSum <> 0 do
               begin
                   for i := left to right do
                     writeln(Line , ' ' , i);
                   with opt[Line , left , right , leftcode , rightcode , tmpSum] do
                     begin
                         newLeft := left;
                         newRight := right;
                         newLeftcode := code div 2;
                         newRightcode := code mod 2;
                     end;
                   dec(tmpSum , right - left + 1);
                   left := newLeft; right := newRight;
                   leftcode := newLeftcode; rightcode := newRightcode;
                   dec(Line);
               end;
        end;
//    Close(OUTPUT);
end;

Begin
    init;
    work;
    out;
End.
