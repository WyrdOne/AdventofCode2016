unit Day8;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure Run;

implementation

procedure Run;
var F: text;
  Line: string;
  P,X,Y: integer;
  Idx: integer;
  Screen: array[1..6,1..50] of boolean;
  Buffer: array[1..50] of boolean;
  Part1: integer;
begin
  for Y:=1 to 6 do
    for X:=1 to 50 do
      Screen[Y,X] := false;
  assign(F, 'day8.dat');
  reset(F);
  while not eof(F) do
  begin
    readln(F, Line);
    if copy(Line,1,4)='rect' then
    begin
      Line := copy(Line,6,255);
      P := pos('x',Line);
      X := strtoint(copy(Line,1,pred(P)));
      Y := strtoint(copy(Line,succ(P),255));
      while Y>0 do
      begin
        fillchar(Screen[Y],X,1);
        dec(Y);
      end;
    end
    else // rotate
    begin
      if Line[8]='r' then // row
      begin
        Line := copy(Line,14,255); // leaves '# by #'
        P := pos(' ',Line);
        Y := strtoint(copy(Line,1,pred(P)))+1;
        X := strtoint(copy(Line,P+4,255));
        Buffer := Screen[Y];
        for Idx:=1 to 50 do
          if Idx>X then
          begin
            Screen[Y,Idx] := Buffer[Idx-X];
          end
          else
          begin
            Screen[Y,Idx] := Buffer[50+Idx-X];
          end;
      end
      else // column
      begin
        Line := copy(Line,17,255); // leaves '# by #'
        P := pos(' ',Line);
        X := strtoint(copy(Line,1,pred(P)))+1;
        Y := strtoint(copy(Line,P+4,255));
        for Idx:=1 to 6 do
          Buffer[Idx] := Screen[Idx,X];
        for Idx:=1 to 6 do
          if Idx>Y then
            Screen[Idx,X] := Buffer[Idx-Y]
          else
            Screen[Idx,X] := Buffer[6+Idx-Y];
      end;
    end;
  end;
  close(F);
  Part1 := 0;
  for Y:=1 to 6 do
  begin
    for X:=1 to 50 do
      if Screen[Y,X] then
      begin
        write('X');
        inc(Part1);
      end
      else
        write('.');
    writeln;
  end;
  writeln('Part 1 = ', Part1);
end;

end.

--- Day 8: Two-Factor Authentication ---

You come across a door implementing what you can only assume is an implementation of two-factor authentication after a long game of requirements telephone.

To get past the door, you first swipe a keycard (no problem; there was one on a nearby desk). Then, it displays a code on a little screen, and you type that code on a keypad. Then, presumably, the door unlocks.

Unfortunately, the screen has been smashed. After a few minutes, you've taken everything apart and figured out how it works. Now you just have to work out what the screen would have displayed.

The magnetic strip on the card you swiped encodes a series of instructions for the screen; these instructions are your puzzle input. The screen is 50 pixels wide and 6 pixels tall, all of which start off, and is capable of three somewhat peculiar operations:

rect AxB turns on all of the pixels in a rectangle at the top-left of the screen which is A wide and B tall.
rotate row y=A by B shifts all of the pixels in row A (0 is the top row) right by B pixels. Pixels that would fall off the right end appear at the left end of the row.
rotate column x=A by B shifts all of the pixels in column A (0 is the left column) down by B pixels. Pixels that would fall off the bottom appear at the top of the column.
For example, here is a simple sequence on a smaller screen:

rect 3x2 creates a small rectangle in the top-left corner:

###....
###....
.......
rotate column x=1 by 1 rotates the second column down by one pixel:

#.#....
###....
.#.....
rotate row y=0 by 4 rotates the top row right by four pixels:

....#.#
###....
.#.....
rotate column x=1 by 1 again rotates the second column down by one pixel, causing the bottom pixel to wrap back to the top:

.#..#.#
#.#....
.#.....
As you can see, this display technology is extremely powerful, and will soon dominate the tiny-code-displaying-screen market. That's what the advertisement on the back of the display tries to convince you, anyway.

There seems to be an intermediate check of the voltage used by the display: after you swipe your card, if the screen did work, how many pixels should be lit?

--- Part Two ---

You notice that the screen is only capable of displaying capital letters; in the font it uses, each letter is 5 pixels wide and 6 tall.

After you swipe your card, what code is the screen trying to display?
