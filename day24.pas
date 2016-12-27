unit Day24;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure Run;

implementation

type TLocation = record
    X,Y: integer;
  end;

var Map: array[1..64] of string;
  Distances: array['0'..'9',1..183,1..37] of integer;
  Locations: array['0'..'9'] of TLocation;
  LastRow: integer;

procedure LoadMap;
var F: text;
  C: char;
begin
  LastRow := 0;
  assign(F, 'day24.dat');
  reset(F);
  while not eof(F) do
  begin
    inc(LastRow);
    readln(F, Map[LastRow]);
    for C:='0' to '9' do
      if pos(C, Map[LastRow])>0 then
      begin
        Locations[C].X := pos(C, Map[LastRow]);
        Locations[C].Y := LastRow;
      end;
  end;
  close(F);
  fillchar(Distances, sizeof(Distances), 255);
end;

function AdjacentDistance(Start: char; X,Y: integer): integer;
var Distance: integer;
begin
  Distance := 9999;
  if (Map[Y-1][X]<>'#') and (Distances[Start,X,Y-1]>=0) then
    Distance := Distances[Start,X,Y-1];
  if (Map[Y+1][X]<>'#') and (Distances[Start,X,Y+1]>=0) and (Distances[Start,X,Y+1]<Distance) then
    Distance := Distances[Start,X,Y+1];
  if (Map[Y][X-1]<>'#') and (Distances[Start,X-1,Y]>=0) and (Distances[Start,X-1,Y]<Distance) then
    Distance := Distances[Start,X-1,Y];
  if (Map[Y][X+1]<>'#') and (Distances[Start,X+1,Y]>=0) and (Distances[Start,X+1,Y]<Distance) then
    Distance := Distances[Start,X+1,Y];
  AdjacentDistance := Distance;
end;

procedure CalculateDistances(Start: char);
var X,Y: integer;
  Adj: integer;
  Done: boolean;
begin
  Distances[Start,Locations[Start].X,Locations[Start].Y] := 0;
  Done := false;
  while not Done do
  begin
    Done := true;
    for Y:=2 to 36 do
      for X:=2 to 182 do
      begin
        if (Map[Y][X]<>'#') and (Distances[Start,X,Y]<0) then
        begin
          Adj := AdjacentDistance(Start,X,Y);
          if Adj<>9999 then
          begin
            Done := false;
            Distances[Start,X,Y] := Adj+1;
          end;
        end;
      end;
  end;
end;

function NextPermutation(var Input: string): boolean;
var is_last: boolean;
  i, j, k: integer;
  Hold: char;
begin
  is_last := true;
  i := length(Input) - 1;
  while i > 0 do
  begin
    if Input[i]<Input[i+1] then
    begin
      is_last := false;
      break;
    end;
    dec(i);
  end;
  if not is_last then
  begin
    j := i + 1;
    k := length(Input);
    while j < k do
    begin
      Hold := Input[j];
      Input[j] := Input[k];
      Input[k] := Hold;
      inc(j);
      dec(k);
    end;
    j := length(Input);
    while Input[j] > Input[i] do
      dec(j);
    inc(j);
    Hold := Input[i];
    Input[i] := Input[j];
    Input[j] := Hold;
  end;
  NextPermutation := not is_last;
end;

function PathLength(Path: string): integer;
var Idx: integer;
  Total: integer;
begin
  Total := 0;
  for Idx:=1 to length(Path)-1 do
    Total := Total + Distances[Path[Idx],Locations[Path[Idx+1]].X,Locations[Path[Idx+1]].Y];
  PathLength := Total;
end;

function Part1: integer;
var Input: string;
  Shortest: integer = 9999;
  Current: integer;
begin
  Input := '1234567';
  while true do
  begin
    Current := PathLength('0'+Input);
    if Current<Shortest then
    begin
      Shortest := Current;
    end;
    if not NextPermutation(Input) then
      break;
  end;
  Part1 := Shortest;
end;

function Part2: integer;
var Input: string;
  Shortest: integer = 9999;
  Current: integer;
begin
  Input := '1234567';
  while true do
  begin
    Current := PathLength('0'+Input+'0');
    if Current<Shortest then
    begin
      Shortest := Current;
    end;
    if not NextPermutation(Input) then
      break;
  end;
  Part2 := Shortest;
end;

procedure Run;
begin
  LoadMap;
  CalculateDistances('0');
  CalculateDistances('1');
  CalculateDistances('2');
  CalculateDistances('3');
  CalculateDistances('4');
  CalculateDistances('5');
  CalculateDistances('6');
  CalculateDistances('7');
  writeln('Part 1 = ', Part1);
  writeln('Part 2 = ', Part2);
end;

end.

--- Day 24: Air Duct Spelunking ---

You've finally met your match; the doors that provide access to the roof are locked tight, and all of the controls and related electronics are inaccessible. You simply can't reach them.

The robot that cleans the air ducts, however, can.

It's not a very fast little robot, but you reconfigure it to be able to interface with some of the exposed wires that have been routed through the HVAC system. If you can direct it to each of those locations, you should be able to bypass the security controls.

You extract the duct layout for this area from some blueprints you acquired and create a map with the relevant locations marked (your puzzle input). 0 is your current location, from which the cleaning robot embarks; the other numbers are (in no particular order) the locations the robot needs to visit at least once each. Walls are marked as #, and open passages are marked as .. Numbers behave like open passages.

For example, suppose you have a map like the following:

###########
#0.1.....2#
#.#######.#
#4.......3#
###########
To reach all of the points of interest as quickly as possible, you would have the robot take the following path:

0 to 4 (2 steps)
4 to 1 (4 steps; it can't move diagonally)
1 to 2 (6 steps)
2 to 3 (2 steps)
Since the robot isn't very fast, you need to find it the shortest route. This path is the fewest steps (in the above example, a total of 14) required to start at 0 and then visit every other location at least once.

Given your actual map, and starting from location 0, what is the fewest number of steps required to visit every non-0 number marked on the map at least once?

--- Part Two ---

Of course, if you leave the cleaning robot somewhere weird, someone is bound to notice.

What is the fewest number of steps required to start at 0, visit every non-0 number marked on the map at least once, and then return to 0?
