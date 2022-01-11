# Luau Base64

A Open-Source Module which allows you to quickly encrypt & decrypt messages in base64.

## Installation

In ROBLOX Studio, you may load it in as a module script named `Base64`, with the following :

```lua
local Base64 = require(script.Base64);
```
Or, if you are using the Luau Binary Files, you can load it by swapping the file directory :
```lua
local Base64 = require("./Base64");
```
## Usage

Encoding & Decoding :
```lua
local Message : string = "The message you want to encrypt would go here";
local Encrypted : string = Base64:Encode(Message); -- Encode our message.

print(Encrypted); -- VGhlIG1lc3NhZ2UgeW91IHdhbnQgdG8gZW5jcnlwdCB3b3VsZCBnbyBoZXJl

local Decrypted : string = Base64:Decode(Encrypted); -- Decode our encrypted message.

print(Decrypted == Message) -- true
```
## License
[MIT](https://choosealicense.com/licenses/mit/)
