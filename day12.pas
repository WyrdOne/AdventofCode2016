unit Day12;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure Run;

implementation

type TOpCode = (opCopy, opInc, opDec, opJnz);
  TInstruction = record
    OpCode: TOpCode;
    isRegister: boolean;
    Reg: 'a'..'d';
    Reg2: 'a'..'d';
    Value: integer;
    Offset: integer;
  end;
  TRegisters = array['a'..'d'] of integer;

var Instructions: array[1..23] of TInstruction;

procedure LoadInstructions;
var F: text;
  Line: string;
  Idx: integer;
begin
  assign(F, 'day12.dat');
  reset(F);
  Idx := 0;
  while not eof(F) do
  begin
    readln(F, Line);
    inc(Idx);
    case copy(Line,1,3) of
      'cpy': Instructions[Idx].OpCode := opCopy;
      'inc': Instructions[Idx].OpCode := opInc;
      'dec': Instructions[Idx].OpCode := opDec;
      'jnz': Instructions[Idx].OpCode := opJnz;
    end;
    delete(Line, 1, 4);
    case Instructions[Idx].OpCode of
      opInc, opDec: Instructions[Idx].Reg := Line[1];
      opCopy: begin
        if (Line[1] in ['a'..'d']) then
        begin
          Instructions[Idx].isRegister := true;
          Instructions[Idx].Reg := Line[1];
          delete(Line, 1, 2);
        end
        else
        begin
          Instructions[Idx].isRegister := false;
          Instructions[Idx].Value := strtoint(copy(Line,1,pred(pos(' ', Line))));
          delete(Line, 1, pos(' ', Line));
        end;
        Instructions[Idx].Reg2 := Line[1];
      end;
      opJnz: begin
        if (Line[1] in ['a'..'d']) then
        begin
          Instructions[Idx].isRegister := true;
          Instructions[Idx].Reg := Line[1];
          delete(Line, 1, 2);
        end
        else
        begin
          Instructions[Idx].isRegister := false;
          Instructions[Idx].Value := strtoint(copy(Line,1,pred(pos(' ', Line))));
          delete(Line, 1, pos(' ', Line));
        end;
        Instructions[Idx].Offset := strtoint(Line);
      end;
    end;
  end;
  close(F);
end;

procedure Execute(var Registers: TRegisters);
var Instruction: integer;
  Hold: integer;
begin
  Instruction := 1;
  while Instruction<24 do
  begin
    case Instructions[Instruction].OpCode of
      opCopy: begin
          if Instructions[Instruction].isRegister then
          begin
            Registers[Instructions[Instruction].Reg2] := Registers[Instructions[Instruction].Reg];
          end
          else
          begin
            Registers[Instructions[Instruction].Reg2] := Instructions[Instruction].Value;
          end;
          inc(Instruction);
        end;
      opInc: begin
          inc(Registers[Instructions[Instruction].Reg]);
          inc(Instruction);
        end;
      opDec: begin
          dec(Registers[Instructions[Instruction].Reg]);
          inc(Instruction);
        end;
      opJnz: begin
          if Instructions[Instruction].isRegister then
          begin
            Hold := Registers[Instructions[Instruction].Reg];
          end
          else
          begin
            Hold := Instructions[Instruction].Value;
          end;
          if Hold<>0 then
          begin
            Instruction := Instruction + Instructions[Instruction].Offset;
          end
          else
          begin
            inc(Instruction);
          end;
        end;
    end;
  end;

end;

procedure Run;
var Registers: TRegisters;
begin
  LoadInstructions;
  Registers['a'] := 0;
  Registers['b'] := 0;
  Registers['c'] := 0;
  Registers['d'] := 0;
  Execute(Registers);
  writeln('Part 1 = ', Registers['a']);
  Registers['a'] := 0;
  Registers['b'] := 0;
  Registers['c'] := 1;
  Registers['d'] := 0;
  Execute(Registers);
  writeln('Part 2 = ', Registers['a']);
end;

end.

--- Day 12: Leonardo's Monorail ---

You finally reach the top floor of this building: a garden with a slanted glass ceiling. Looks like there are no more stars to be had.

While sitting on a nearby bench amidst some tiger lilies, you manage to decrypt some of the files you extracted from the servers downstairs.

According to these documents, Easter Bunny HQ isn't just this building - it's a collection of buildings in the nearby area. They're all connected by a local monorail, and there's another building not far from here! Unfortunately, being night, the monorail is currently not operating.

You remotely connect to the monorail control systems and discover that the boot sequence expects a password. The password-checking logic (your puzzle input) is easy to extract, but the code it uses is strange: it's assembunny code designed for the new computer you just assembled. You'll have to execute the code and get the password.

The assembunny code you've extracted operates on four registers (a, b, c, and d) that start at 0 and can hold any integer. However, it seems to make use of only a few instructions:

cpy x y copies x (either an integer or the value of a register) into register y.
inc x increases the value of register x by one.
dec x decreases the value of register x by one.
jnz x y jumps to an instruction y away (positive means forward; negative means backward), but only if x is not zero.
The jnz instruction moves relative to itself: an offset of -1 would continue at the previous instruction, while an offset of 2 would skip over the next instruction.

For example:

cpy 41 a
inc a
inc a
dec a
jnz a 2
dec a
The above code would set register a to 41, increase its value by 2, decrease its value by 1, and then skip the last dec a (because a is not zero, so the jnz a 2 skips it), leaving register a at 42. When you move past the last instruction, the program halts.

After executing the assembunny code in your puzzle input, what value is left in register a?

Your puzzle answer was 318003.

The first half of this puzzle is complete! It provides one gold star: *

--- Part Two ---

As you head down the fire escape to the monorail, you notice it didn't start; register c needs to be initialized to the position of the ignition key.

If you instead initialize register c to be 1, what value is now left in register a?

