unit Day13;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure Run;

implementation

const input: integer = 1364;
  goalX: integer = 31;
  goalY: integer = 39;

var Maze: array[0..63,0..63] of char;
  Distances: array[0..63,0..63] of integer;

function BitsEven(x,y: integer): boolean;
var value: word;
  bits: byte;
begin
  value := x*x + 3*x + 2*x*y + y + y*y + input;
  bits := 0;
  while value<>0 do
  begin
    if (value and $01)<>0 then
      inc(bits);
    value := value shr 1;
  end;
  if (bits and $01)<>0 then
    BitsEven := false
  else
    BitsEven := true;
end;

procedure BuildMaze;
var x,y: integer;
begin
  for x:=0 to 63 do
    for y:=0 to 63 do
    begin
      if BitsEven(x,y) then
        Maze[x,y] := ' '
      else
        Maze[x,y] := 'X';
      Distances[x,y] := -1;
    end;
end;

function Check(x,y: integer): boolean;
begin
  if (x<0) or (y<0) or (x>63) or (y>63) then
  begin
    Check := false;
    exit;
  end;
  if Maze[x,y]='X' then
  begin
    Check := false;
    exit;
  end;
  if Distances[x,y]=-1 then
  begin
    Check := false;
    exit;
  end;
  Check := true;
end;

procedure CalculateDistances;
var x,y: integer;
  done: boolean;
begin
  done := false;
  while not done do
  begin
    done := true;
    for x:=0 to 63 do
      for y:=0 to 63 do
      begin
        if (Maze[x,y]=' ') then
        begin
          if (Distances[x,y]=-1) then
          begin
            Distances[x,y] := 9999;
            if Check(x,pred(y)) and (Distances[x,pred(y)]<Distances[x,y]) then
              Distances[x,y] := succ(Distances[x,pred(y)]);
            if Check(succ(x),y) and (Distances[succ(x),y]<Distances[x,y]) then
              Distances[x,y] := succ(Distances[succ(x),y]);
            if Check(x,succ(y)) and (Distances[x,succ(y)]<Distances[x,y]) then
              Distances[x,y] := succ(Distances[x,succ(y)]);
            if Check(pred(x),y) and (Distances[pred(x),y]<Distances[x,y]) then
              Distances[x,y] := succ(Distances[pred(x),y]);
            if Distances[x,y]<51 then
              done := false;
            if Distances[x,y]=9999 then
              Distances[x,y] := -1;
          end;
        end;
      end;
  end;
end;

function Count(Distance: integer): integer;
var x,y: integer;
  cnt: integer;
begin
  cnt := 0;
  for x:=0 to 63 do
    for y:=0 to 63 do
      if (Distances[x,y]<>-1) and (Distances[x,y]<=Distance) then
        inc(cnt);
  Count := cnt;
end;

procedure Run;
begin
  BuildMaze;
  Maze[1,1] := ' '; // Just in case.
  Distances[1,1] := 0;
  Maze[goalX,goalY] := ' '; // Just in case.
  CalculateDistances;
  writeln('Part 1 = ', Distances[goalX,goalY]);
  writeln('Part 2 = ', Count(50));
end;

end.

--- Day 13: A Maze of Twisty Little Cubicles ---

You arrive at the first floor of this new building to discover a much less welcoming environment than the shiny atrium of the last one. Instead, you are in a maze of twisty little cubicles, all alike.

Every location in this area is addressed by a pair of non-negative integers (x,y). Each such coordinate is either a wall or an open space. You can't move diagonally. The cube maze starts at 0,0 and seems to extend infinitely toward positive x and y; negative values are invalid, as they represent a location outside the building. You are in a small waiting area at 1,1.

While it seems chaotic, a nearby morale-boosting poster explains, the layout is actually quite logical. You can determine whether a given x,y coordinate will be a wall or an open space using a simple system:

Find x*x + 3*x + 2*x*y + y + y*y.
Add the office designer's favorite number (your puzzle input).
Find the binary representation of that sum; count the number of bits that are 1.
If the number of bits that are 1 is even, it's an open space.
If the number of bits that are 1 is odd, it's a wall.
For example, if the office designer's favorite number were 10, drawing walls as # and open spaces as ., the corner of the building containing 0,0 would look like this:

  0123456789
0 .#.####.##
1 ..#..#...#
2 #....##...
3 ###.#.###.
4 .##..#..#.
5 ..##....#.
6 #...##.###
Now, suppose you wanted to reach 7,4. The shortest route you could take is marked as O:

  0123456789
0 .#.####.##
1 .O#..#...#
2 #OOO.##...
3 ###O#.###.
4 .##OO#OO#.
5 ..##OOO.#.
6 #...##.###
Thus, reaching 7,4 would take a minimum of 11 steps (starting from your current location, 1,1).

What is the fewest number of steps required for you to reach 31,39?

--- Part Two ---

How many locations (distinct x,y coordinates, including your starting location) can you reach in at most 50 steps?
