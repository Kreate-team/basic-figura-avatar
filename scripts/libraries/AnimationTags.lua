--[[
____  ___ __   __
| __|/ _ \\ \ / /
| _|| (_) |> w <
|_|  \___//_/ \_\
FOX's Animation Tags API v1.0.0

Github: https://github.com/Bitslayn/AnimationTags
Wiki: https://github.com/Bitslayn/AnimationTags/wiki
--]]

local debug = nil

--#REGION ˚♡ Inject ♡˚

---@diagnostic disable: undefined-field, redundant-parameter
local _GSAnimBlend
for _, v in pairs(listFiles(nil, true)) do
  if v:find("GSAnimBlend") then
    _GSAnimBlend = require(v)
  end
end

---@class AnimationAPI
local AnimationAPI = {}
---@class Animation
local Animation = {}

local api, ani = figuraMetatables.AnimationAPI, figuraMetatables.Animation
local api_i, ani_i = api.__index, ani.__index

function api:__index(key) return AnimationAPI[key] or api_i(self, key) end

function ani:__index(key) return Animation[key] or ani_i(self, key) end

--#ENDREGION
--#REGION ˚♡ API ♡˚

local _ENVMT = getmetatable(_ENV) or getmetatable(setmetatable(_ENV, {}))

---@param tbl table
local function reflect(tbl)
  local i, t = 0, {}
  for k in pairs(tbl) do
    i = i + 1
    t[i] = k
  end
  return t
end

---@type {[Animation]: string[]}
local trackedAnimations = {}

---@type {[string]: Animation[]|AnimationTag}
local AnimationTags = {}
---@class AnimationTag
---@field play fun(): self Starts or resumes all animations with this tag
---@field playing fun(self: self, state?: boolean): self Sets the playing state of all animations with this tag. Argument defaults to false
---@field setPlaying fun(self: self, state?: boolean): self Sets the playing state of all animations with this tag. Argument defaults to false
---@field pause fun(): self Pauses all animations with this tag
---@field stop fun(): self Stops all animations with this tag
---@field restart fun(): self Restarts all animations with this tag from the beginning, even if it was currently paused or playing
local AnimationTag = {}

---Get if any animation with this tag is playing
---@return boolean
---@nodiscard
function AnimationTag:isPlaying()
  return getmetatable(self).isPlaying
end

---Returns the animations with this tag that are currently playing
---@return Animation[]
---@nodiscard
function AnimationTag:getPlaying()
  return reflect(getmetatable(self).playing)
end

---Incriments each the tag of this animation by the given amount
---
---Also sets the animation's playing state for that tag
---@param tag string
---@param anim Animation
---@param inc number
local function query(tag, anim, inc)
  local meta = getmetatable(AnimationTags[tag])
  local new = inc == 1 and true or nil
  if meta.playing[anim] == new then return end
  meta.playing[anim] = new
  meta.count = meta.count + inc
  meta.isPlaying = meta.count > 0
  if debug and anim:getName() == debug then
    print(tag, meta.count)
  end
end

---Entrypoint to animation query
---@param anim Animation
---@param inc number
---@param tag? string
function _ENVMT.manageAnim(anim, inc, tag)
  if tag then
    query(tag, anim, inc)
  else
    if not trackedAnimations[anim] then return end
    for _, v in pairs(trackedAnimations[anim]) do
      query(v, anim, inc)
    end
  end
  if _GSAnimBlend then
    anim:setOnBlend(function(state)
      if state.done and not state.starting then
        _ENVMT.manageAnim(state.anim, -1)
      end
    end, 1)
  end
  anim:code(
    anim:getLength() - 0.01,
    anim:getLoop() ~= "LOOP" and "getmetatable(_ENV).manageAnim(..., -1)" or "" -- An animation that is stopped on last frame is no longer playing
  )
end

---Returns all animation tags
---@return {[string]: Animation[]|AnimationTag}
function AnimationAPI:getTags()
  return AnimationTags
end

---Returns a table listing this animation's tags
---@return string[]
function Animation:getTags()
  return reflect(trackedAnimations[self] or {})
end

---Adds tags to this animation, which can be used to determine which tags have an animation playing
---
---Any single animation can be assigned to several tags
---@param ... string
---@return self
function Animation:addTags(...)
  for _, v in pairs({ ... }) do
    trackedAnimations[self] = trackedAnimations[self] or {}
    trackedAnimations[self][v] = v

    ---@class AnimationTag.Meta
    ---@field __index AnimationTag Stores all AnimationTag methods
    ---@field playing {[Animation]: true} Stores animations currently playing
    ---@field isPlaying boolean If there's an animation with this tag currently playing
    ---@field count number The number of playing animations
    ---@field index {[Animation]: Animation} Stores all animations associated with this tag
    local meta = { __index = AnimationTag, playing = {}, isPlaying = false, count = 0, index = {} }
    AnimationTags[v] = AnimationTags[v] or setmetatable({}, meta)
    meta.index[self] = self

    if self:isPlaying() then
      _ENVMT.manageAnim(self, 1, v)
    end

    table.insert(AnimationTags[v], self)
  end

  return self
end

---Removes tags from this animation
---@param ... string
---@return self
function Animation:removeTags(...)
  for _, v in pairs({ ... }) do
    if self:isPlaying() then
      _ENVMT.manageAnim(self, -1, v)
    end

    trackedAnimations[self][v] = nil
    if AnimationTags[v] then
      local meta = getmetatable(AnimationTags[v])
      meta.index[self] = nil
      AnimationTags[v] = setmetatable(reflect(meta.index), meta)
    end
  end

  return self
end

for _, v in pairs({ "play", "playing", "setPlaying", "pause", "stop", "restart" }) do
  ---@param self Animation
  ---@param ... any
  ---@return Animation
  Animation[v] = function(self, ...)
    local wasPlaying = self:isPlaying()
    ani_i(self, v)(self, ...)
    local isPlaying = self:isPlaying()

    if debug and self:getName() == debug then
      print(v, ..., wasPlaying ~= isPlaying)
    end

    if wasPlaying == isPlaying then return self end

    _ENVMT.manageAnim(self, isPlaying and 1 or -1)
    return self
  end
  ---@param self AnimationTag
  ---@param ... any
  ---@return AnimationTag
  AnimationTag[v] = function(self, ...)
    for _, anim in pairs(self) do
      anim[v](anim, ...)
    end
    return self
  end
end

--#ENDREGION
