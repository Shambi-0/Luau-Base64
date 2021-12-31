--[[::

Copyright (C) 2021, Luc Rodriguez (Aliases : Shambi, StyledDev).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--::]]

local Base64 : {[string] : any?} = {
	
	["Dictionary"] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
};

function Base64:Encode(Data : string) : string
	
	return (string.gsub(string.gsub(Data, '.', function(Character) : string
		
		local Result : string, Byte : number = '', string.byte(Character)

		for Index : number = 8, 1, -1 do
			
			Result ..= if (bit32.band(Byte, (2 ^ Index) - 1) - bit32.band(Byte, (2 ^ (Index - 1)) - 1) > 0) then '1' else '0';
		end;

		return (Result);
		
	end) .. '0000', "%d%d%d?%d?%d?%d?", function(Character : string) : string
		
		if (#Character < 6) then 
			
			return ('');
		end;

		local Counter : number = 0;

		for Index : number = 1, 6 do
			
			Counter += if (string.sub(Character, Index, Index) == '1') then (2 ^ (6 - Index)) else 0;
		end;

		Counter += 1;

		return (string.sub(self.Dictionary, Counter, Counter));
		
	end) .. ({ '', '==', '=' })[#Data % 3 + 1]);
end;

function Base64:Decode(Data : string) : string
	
	return (string.gsub(string.gsub(string.gsub(Data, '[^' .. self.Dictionary .. '=]', ''), '.', function(Character : string) : string
		
		if (Character == '=') then 
			
			return ('');
		end;

		local Result : string, Format : number = '', string.find(self.Dictionary, Character) - 1;

		for Index : number = 6, 1, -1 do 
			
			Result ..= if (bit32.band(Format, (2 ^ Index) - 1) - bit32.band(Format, (2 ^ (Index - 1)) - 1) > 0) then '1' else '0';
		end;

		return (Result);
		
	end), "%d%d%d?%d?%d?%d?%d?%d?", function(Pair : string) : string
		
		if (#Pair ~= 8) then 
			
			return ('');
		end;

		local Counter : number = 0;

		for Index : number = 1, 8 do
			
			Counter += if (string.sub(Pair, Index, Index) == '1') then (2 ^ (7 - Index)) else 0;
		end;

		return (string.char(Counter));
		
	end));
end;

return (Base64);
