--[[::

Copyright (C) 2022, Luc Rodriguez (Aliases : Shambi, StyledDev).

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

(Original Repository can be found here : https://github.com/Shambi-0/Luau-Base64)

--::]]

--------------------------
--// Type Definitions //--
--------------------------

type Array<Type> = {[number] : Type};
type Dictionary<Type> = {[string] : Type};

-----------------------
--// Initalization //--
-----------------------

local Module : Dictionary<string | (string) -> string> = {
	["Library"] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
};

-----------------
--// Methods //--
-----------------

function Module:Encode(Data : string) : string
	local InputType : string = type(Data);
	assert(InputType == "string", string.format("Expected type \"string\" for argument #1 of \"Base64:Decode()\". Recieved type \"%s\".", InputType));

	return (string.gsub(string.gsub(Data, ".", function(Chunk : string) : string?
		local Result : string, Byte : number = "", string.byte(Chunk);

		for Index : number = 8, 1, -1 do
			Result ..= if (Byte % 2 ^ Index - Byte % 2 ^ (Index - 1) > 0) then '1' else '0';
		end;

		return Result;

	end) .. "0000", "%d%d%d?%d?%d?%d?", function(Chunk : string) : string?
		if (string.len(Chunk) < 6) then
			return "";
		end;

		local Count : number = 0;

		for Index : number = 1, 6 do
			Count += if (string.sub(Chunk, Index, Index) == "1") then 2 ^ (6 - Index) else 0;
		end;

		return string.sub(self.Library, Count + 1, Count + 1);

	end) .. ({ "", "==", "=" })[string.len(Data) % 3 + 1]);
end;

function Module:Decode(Data : string) : string
	local InputType : string = type(Data);
	assert(InputType == "string", string.format("Expected type \"string\" for argument #1 of \"Base64:Decode()\". Recieved type \"%s\".", InputType));

	return (string.gsub(string.gsub(string.gsub(Data, "[^" .. self.Library .. "=]", ""), '.', function(Chunk : string) : string?
		if (Chunk == "=") then
			return "";
		end;

		local Result : string, Found : number = "", string.find(self.Library, Chunk) - 1;

		for Index : number = 6, 1, -1 do
			Result ..= if (Found % 2 ^ Index - Found % 2 ^ (Index - 1) > 0) then "1" else "0";
		end;

		return Result;

	end), "%d%d%d?%d?%d?%d?%d?%d?", function(Chunk : string) : string?
		if (string.len(Chunk) ~= 8) then
			return "";
		end;

		local Count : number = 0;

		for Index : number = 1, 8 do
			Count += if (string.sub(Chunk, Index, Index) == "1") then 2 ^ (8 - Index) else 0;
		end;

		return string.char(Count);
	end));
end;

----------------------
--// Finalization //--
----------------------

return (Module);
