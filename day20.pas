unit Day20;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure Run;

implementation

type TRange = record
    min: int64;
    max: int64;
  end;

var Blocked: array[1..4096] of TRange;
  NumBlocked: integer;

procedure SortRanges;
var Top, NewTop, Idx: integer;
  Hold: TRange;
begin
  Top := NumBlocked;
  repeat
    NewTop := 0;
    for Idx:=2 to Top do
    begin
      if Blocked[Idx - 1].min > Blocked[Idx].min then
      begin
        Hold := Blocked[Idx - 1];
        Blocked[Idx - 1] := Blocked[Idx];
        Blocked[Idx] := Hold;
        NewTop := Idx;
      end;
    end;
    Top := NewTop;
  until Top = 0;
end;

procedure Run;
var F: text;
  Line: string;
  Idx: integer;
  First: int64;
  Total: int64;
  min: int64;
begin
  assign(F, 'day20.dat');
  reset(F);
  NumBlocked := 0;
  while not eof(F) do
  begin
    readln(F, Line);
    inc(NumBlocked);
    Blocked[NumBlocked].min := strtoint64(copy(Line,1,pred(pos('-',Line))));
    Blocked[NumBlocked].max := strtoint64(copy(Line,succ(pos('-',Line)),255));
  end;
  close(F);
  First := -1;
  Total := 0;
  min := 0;
  SortRanges;
  for Idx:=1 to NumBlocked do
  begin
    if Blocked[Idx].min > (min+1) then
    begin
      Total := Total + (Blocked[Idx].min - min - 1);
      if First=-1 then
        First := min + 1;
    end;
    if Blocked[Idx].max > min then
      min := Blocked[Idx].max;
  end;
  writeln('Part 1 = ', First);
  writeln('Part 2 = ', Total);
end;

end.

--- Day 20: Firewall Rules ---

You'd like to set up a small hidden computer here so you can use it to get back into the network later. However, the corporate firewall only allows communication with certain external IP addresses.

You've retrieved the list of blocked IPs from the firewall, but the list seems to be messy and poorly maintained, and it's not clear which IPs are allowed. Also, rather than being written in dot-decimal notation, they are written as plain 32-bit integers, which can have any value from 0 through 4294967295, inclusive.

For example, suppose only the values 0 through 9 were valid, and that you retrieved the following blacklist:

5-8
0-2
4-7
The blacklist specifies ranges of IPs (inclusive of both the start and end value) that are not allowed. Then, the only IPs that this firewall allows are 3 and 9, since those are the only numbers not in any range.

Given the list of blocked IPs you retrieved from the firewall (your puzzle input), what is the lowest-valued IP that is not blocked?

--- Part Two ---

How many IPs are allowed by the blacklist?
