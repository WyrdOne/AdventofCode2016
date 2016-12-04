unit Day4;

interface

uses
  Classes, SysUtils;

procedure Run;

implementation

procedure Run;
var F: Text;
  Line: string;
  Sector: string;
  Checksum: string;
  ValidChecksum: string;
  LetterCounts: array['a'..'z'] of integer;
  CharIdx: char;
  Idx: integer;
  Highest: integer;
  Total: longint;
  Cypher: string;
begin
  Total := 0;
  assignfile(F, 'day4.dat');
  reset(F);
  while not eof(F) do
  begin
    ReadLn(F, Line);
    for CharIdx:='a' to 'z' do
      LetterCounts[CharIdx] := 0;
    Sector := '';
    Checksum := '';
    Idx := 1;
    while not (Line[Idx] in ['0'..'9']) do
    begin
      if Line[Idx]<>'-' then
        inc(LetterCounts[Line[Idx]]);
      inc(Idx);
    end;
    while Line[Idx] in ['0'..'9'] do
    begin
      Sector := Sector + Line[Idx];
      inc(Idx);
    end;
    inc(Idx); // Skip [
    while Line[Idx]<>']' do
    begin
      Checksum := Checksum + Line[Idx];
      inc(Idx);
    end;
    Highest := 0;
    for CharIdx:='a' to 'z' do
      if LetterCounts[CharIdx]>Highest then
        Highest := LetterCounts[CharIdx];
    Highest := 50;
    ValidChecksum := '';
    while length(ValidChecksum)<5 do
    begin
      for CharIdx:='a' to 'z' do
      begin
        if LetterCounts[CharIdx]=Highest then
          ValidChecksum := ValidChecksum + CharIdx;
      end;
      dec(Highest);
    end;
    ValidChecksum := copy(ValidChecksum,1,5);
    if ValidChecksum=Checksum then
    begin
      Total := Total + StrToInt(Sector);
      Cypher := '';
      Idx := 1;
      while not (Line[Idx] in ['0'..'9']) do
      begin
        if (Line[Idx]<>'-') then
        begin
          Cypher := Cypher + chr(((ord(Line[Idx])-ord('a')) + StrToInt(Sector)) mod 26 + ord('a'));
        end else
          Cypher := Cypher + ' ';
        inc(Idx);
      end;
      if copy(Cypher,1,5)='north' then
        writeln(Cypher, ' = ', Sector);
    end;
  end;
  writeln('Part 1 = ', Total);
end;

end.

--- Day 4: Security Through Obscurity ---

Finally, you come across an information kiosk with a list of rooms. Of course, the list is encrypted and full of decoy data, but the instructions to decode the list are barely hidden nearby. Better remove the decoy data first.

Each room consists of an encrypted name (lowercase letters separated by dashes) followed by a dash, a sector ID, and a checksum in square brackets.

A room is real (not a decoy) if the checksum is the five most common letters in the encrypted name, in order, with ties broken by alphabetization. For example:

aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most common letters are a (5), b (3), and then a tie between x, y, and z, which are listed alphabetically.
a-b-c-d-e-f-g-h-987[abcde] is a real room because although the letters are all tied (1 of each), the first five are listed alphabetically.
not-a-real-room-404[oarel] is a real room.
totally-real-room-200[decoy] is not.
Of the real rooms from the list above, the sum of their sector IDs is 1514.

What is the sum of the sector IDs of the real rooms?

--- Part Two ---

With all the decoy data out of the way, it's time to decrypt this list and get moving.

The room names are encrypted by a state-of-the-art shift cipher, which is nearly unbreakable without the right software. However, the information kiosk designers at Easter Bunny HQ were not expecting to deal with a master cryptographer like yourself.

To decrypt a room name, rotate each letter forward through the alphabet a number of times equal to the room's sector ID. A becomes B, B becomes C, Z becomes A, and so on. Dashes become spaces.

For example, the real name for qzmt-zixmtkozy-ivhz-343 is very encrypted name.

What is the sector ID of the room where North Pole objects are stored?
