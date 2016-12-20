Var
    b1 , b2 , t1 , t2 ,
    l , ds , dt , g
               : extended;
    i          : longint;

Begin
    randomize;
    assign(OUTPUT , 'p204.in'); ReWrite(OUTPUT);
      for i := 1 to 200 do
        begin
            b1 := (random(100000) + 1) / 100;
            b2 := (random(100000) + 1) / 100;
            t1 := (random(100000) + 1) / 100;
            t2 := (random(100000) + 1) / 100;
            l := (random(100000) + 1) / 100;
            ds := (random(100000) + 1) / 100;
            dt := (random(100000) + 1) / 100;
            g := (random(100000) + 1) / 100;
            if b1 = t1 then t1 := t1 + 0.01;
            if b2 = t2 then t2 := t2 + 0.01;
            if b1 < t1
              then write(b1 : 0 : 2 , ' ' , t1 : 0 : 2 , ' ')
              else write(t1 : 0 : 2 , ' ' , b1 : 0 : 2 , ' ');
            if b2 < t2
              then write(b2 : 0 : 2 , ' ' , t2 : 0 : 2 , ' ')
              else write(t2 : 0 : 2 , ' ' , b2 : 0 : 2 , ' ');
            writeln(l : 0 : 2 , ' ' , ds : 0 : 2 , ' ' , dt : 0 : 2 , ' ' , g : 0 : 2);
        end;
    Close(OUTPUT);
End.