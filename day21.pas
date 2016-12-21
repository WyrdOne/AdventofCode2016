unit Day21;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure Run;

implementation

type TInstructionOp = (opSwapPos,opSwapLetter,opRotateLeft,opRotateRight,opRotateLetter,opReverse,opMove);
  TInstruction = record
    case Instruction: TInstructionOp of
      opSwapPos,opReverse,opMove: (
        posX,posY: integer;
      );
      opSwapLetter: (
        letterX,letterY: char;
      );
      opRotateLeft,opRotateRight: (
        Shift: integer;
      );
      opRotateLetter: (
        Letter: char;
      );
  end;

const ReverseRotation: array[1..8] of integer = (1,1,6,2,7,3,0,4);

var Instructions: array of TInstruction;
  InstructionCount: integer;

procedure LoadInstructions;
var F: text;
  Line: string;
begin
  setlength(Instructions, 256);
  InstructionCount := 0;
  assign(F, 'day21.dat');
  reset(F);
  while not eof(F) do
  begin
    readln(F, Line);
    case Line[1] of
      'm': begin
        Instructions[InstructionCount].Instruction := opMove;
        Instructions[InstructionCount].posX := ord(Line[15]) - ord('0') + 1;
        Instructions[InstructionCount].posY := ord(Line[29]) - ord('0') + 1;
      end;
      'r': begin
        case Line[8] of
          ' ': begin // reverse
            Instructions[InstructionCount].Instruction := opReverse;
            Instructions[InstructionCount].posX := ord(Line[19]) - ord('0') + 1;
            Instructions[InstructionCount].posY := ord(Line[29]) - ord('0') + 1;
          end;
          'b': begin // rotate letter
            Instructions[InstructionCount].Instruction := opRotateLetter;
            Instructions[InstructionCount].letter := Line[36];
          end;
          'l': begin // left
            Instructions[InstructionCount].Instruction := opRotateLeft;
            Instructions[InstructionCount].Shift := ord(Line[13]) - ord('0');
          end;
          'r': begin // right
            Instructions[InstructionCount].Instruction := opRotateRight;
            Instructions[InstructionCount].Shift := ord(Line[14]) - ord('0');
          end;
        end;
      end;
      's': begin
        if Line[6]='l' then
        begin
          Instructions[InstructionCount].Instruction := opSwapLetter;
          Instructions[InstructionCount].letterX := Line[13];
          Instructions[InstructionCount].letterY := Line[27];
        end
        else // 'p'
        begin
          Instructions[InstructionCount].Instruction := opSwapPos;
          Instructions[InstructionCount].posX := ord(Line[15]) - ord('0') + 1;
          Instructions[InstructionCount].posY := ord(Line[31]) - ord('0') + 1;
        end;
      end;
    end;
    inc(InstructionCount);
  end;
  close(F);
end;

function Scramble(Seed: string): string;
var Instruction: integer;
  HoldLetter: char;
  posX,posY: integer;
begin
  for Instruction:=0 to pred(InstructionCount) do
  begin
    case Instructions[Instruction].Instruction of
      opSwapPos: begin
        HoldLetter := Seed[Instructions[Instruction].posX];
        Seed[Instructions[Instruction].posX] := Seed[Instructions[Instruction].posY];
        Seed[Instructions[Instruction].posY] := HoldLetter;
      end;
      opSwapLetter: begin
        posX := pos(Instructions[Instruction].letterX, Seed);
        posY := pos(Instructions[Instruction].letterY, Seed);
        HoldLetter := Seed[posX];
        Seed[posX] := Seed[posY];
        Seed[posY] := HoldLetter;
      end;
      opRotateLeft: begin
        Seed := copy(Seed,Instructions[Instruction].Shift+1,255) + copy(Seed,1,Instructions[Instruction].Shift);
      end;
      opRotateRight: begin
        Seed := rightstr(Seed,Instructions[Instruction].Shift) + leftStr(Seed,length(Seed)-Instructions[Instruction].Shift);
      end;
      opRotateLetter: begin
        posX := pos(Instructions[Instruction].letter, Seed) - 1;
        if posX>=4 then
          inc(posX);
        inc(posX);
        if posX>length(Seed) then
          posX := posX - length(Seed);
        Seed := rightstr(Seed,posX) + leftStr(Seed,length(Seed)-posX);
      end;
      opReverse: begin
        posX := Instructions[Instruction].posX;
        posY := Instructions[Instruction].posY;
        while posX<posY do
        begin
          HoldLetter := Seed[posX];
          Seed[posX] := Seed[posY];
          Seed[posY] := HoldLetter;
          inc(posX);
          dec(posY)
        end;
      end;
      opMove: begin
        HoldLetter := Seed[Instructions[Instruction].posX];
        delete(Seed,Instructions[Instruction].posX,1);
        insert(HoldLetter,Seed,Instructions[Instruction].posY);
      end;
    end;
  end;
  Scramble := Seed;
end;

function Unscramble(Seed: string): string;
var Instruction: integer;
  HoldLetter: char;
  posX,posY: integer;
begin
  for Instruction:=pred(InstructionCount) downto 0 do
  begin
    case Instructions[Instruction].Instruction of
      opSwapPos: begin
        HoldLetter := Seed[Instructions[Instruction].posX];
        Seed[Instructions[Instruction].posX] := Seed[Instructions[Instruction].posY];
        Seed[Instructions[Instruction].posY] := HoldLetter;
      end;
      opSwapLetter: begin
        posX := pos(Instructions[Instruction].letterX, Seed);
        posY := pos(Instructions[Instruction].letterY, Seed);
        HoldLetter := Seed[posX];
        Seed[posX] := Seed[posY];
        Seed[posY] := HoldLetter;
      end;
      opRotateLeft: begin
        Seed := rightstr(Seed,Instructions[Instruction].Shift) + leftStr(Seed,length(Seed)-Instructions[Instruction].Shift);
      end;
      opRotateRight: begin
        Seed := copy(Seed,Instructions[Instruction].Shift+1,255) + copy(Seed,1,Instructions[Instruction].Shift);
      end;
      opRotateLetter: begin
        posX := ReverseRotation[pos(Instructions[Instruction].letter, Seed)];
        Seed := copy(Seed,posX+1,255) + copy(Seed,1,posX);
      end;
      opReverse: begin
        posX := Instructions[Instruction].posX;
        posY := Instructions[Instruction].posY;
        while posX<posY do
        begin
          HoldLetter := Seed[posX];
          Seed[posX] := Seed[posY];
          Seed[posY] := HoldLetter;
          inc(posX);
          dec(posY)
        end;
      end;
      opMove: begin
        HoldLetter := Seed[Instructions[Instruction].posY];
        delete(Seed,Instructions[Instruction].posY,1);
        insert(HoldLetter,Seed,Instructions[Instruction].posX);
      end;
    end;
  end;
  Unscramble := Seed;
end;

procedure Run;
begin
  LoadInstructions;
  writeln('Part 1 = ', Scramble('abcdefgh'));
  writeln('Part 2 = ', Unscramble('fbgdceah'));
end;

end.

--- Day 21: Scrambled Letters and Hash ---

The computer system you're breaking into uses a weird scrambling function to store its passwords. It shouldn't be much trouble to create your own scrambled password so you can add it to the system; you just have to implement the scrambler.

The scrambling function is a series of operations (the exact list is provided in your puzzle input). Starting with the password to be scrambled, apply each operation in succession to the string. The individual operations behave as follows:

swap position X with position Y means that the letters at indexes X and Y (counting from 0) should be swapped.
swap letter X with letter Y means that the letters X and Y should be swapped (regardless of where they appear in the string).
rotate left/right X steps means that the whole string should be rotated; for example, one right rotation would turn abcd into dabc.
rotate based on position of letter X means that the whole string should be rotated to the right based on the index of letter X (counting from 0) as determined before this instruction does any rotations. Once the index is determined, rotate the string to the right one time, plus a number of times equal to that index, plus one additional time if the index was at least 4.
reverse positions X through Y means that the span of letters at indexes X through Y (including the letters at X and Y) should be reversed in order.
move position X to position Y means that the letter which is at index X should be removed from the string, then inserted such that it ends up at index Y.
For example, suppose you start with abcde and perform the following operations:

swap position 4 with position 0 swaps the first and last letters, producing the input for the next step, ebcda.
swap letter d with letter b swaps the positions of d and b: edcba.
reverse positions 0 through 4 causes the entire string to be reversed, producing abcde.
rotate left 1 step shifts all letters left one position, causing the first letter to wrap to the end of the string: bcdea.
move position 1 to position 4 removes the letter at position 1 (c), then inserts it at position 4 (the end of the string): bdeac.
move position 3 to position 0 removes the letter at position 3 (a), then inserts it at position 0 (the front of the string): abdec.
rotate based on position of letter b finds the index of letter b (1), then rotates the string right once plus a number of times equal to that index (2): ecabd.
rotate based on position of letter d finds the index of letter d (4), then rotates the string right once, plus a number of times equal to that index, plus an additional time because the index was at least 4, for a total of 6 right rotations: decab.
After these steps, the resulting scrambled password is decab.

Now, you just need to generate a new scrambled password and you can access the system. Given the list of scrambling operations in your puzzle input, what is the result of scrambling abcdefgh?

--- Part Two ---

You scrambled the password correctly, but you discover that you can't actually modify the password file on the system. You'll need to un-scramble one of the existing passwords by reversing the scrambling process.

What is the un-scrambled version of the scrambled password fbgdceah?
