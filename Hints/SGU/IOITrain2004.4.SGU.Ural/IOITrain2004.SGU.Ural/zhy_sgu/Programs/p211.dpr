{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$R+,Q+,S+}
Const
    InFile     = 'p211.in';
    OutFile    = 'p211.out';
    Limit      = 1000;

Type
    Tdata      = array[0..Limit] of longint;
    Tpath      = record
                     tot      : longint;
                     data     : array[1..4] of
                                  record
                                      x , y  : longint;
                                  end;
                 end;

Var
    data       : Tdata;
    path       : Tpath;
    N          : longint;

procedure change(x , y : longint);
begin
    inc(path.tot);
    data[x] := y;
    path.data[path.tot].x := x;
    path.data[path.tot].y := y;
end;

procedure find2(p : longint);
begin
    while (p < N) and (data[p] <> 2) do inc(p);
    if p = N then exit;
    change(p , 0);
    change(p + 1 , data[p + 1] + 1);
end;

procedure main;
var
    M , i , p ,
    j          : longint;
begin
//    assign(INPUT , InFile); ReSet(INPUT);
//    assign(OUTPUT , OutFile); ReWrite(OUTPUT);
      read(N , M);
      for i := 1 to M do
        begin
            path.tot := 0;
            read(p);
            Case data[p] of
               0              : begin
                                    find2(p);
                                    change(p , 1);
                                end;
               1              : begin
                                    case data[p + 1] of
                                      0  : begin
                                               change(p , 0);
                                               change(p + 1 , 1);
                                           end;
                                      1  : begin
                                               find2(p);
                                               change(p , 0);
                                               change(p + 1 , 2);
                                           end;
                                      2  : begin
                                               change(p + 2 , data[p + 2] + 1);
                                               change(p + 1 , 1);
                                               change(p , 0);
                                           end;
                                    end;
                                end;
               2              : begin
                                    change(p + 1 , data[p + 1] + 1);
                                    change(p , 1);
                                end;
            end;
            write(path.tot);
            for j := 1 to path.tot do
              write(' ' , path.data[j].x , ' ' , path.data[j].y);
            writeln;
        end;
//    Close(OUTPUT);
//    Close(INPUT);
end;

Begin
    main;
End.
