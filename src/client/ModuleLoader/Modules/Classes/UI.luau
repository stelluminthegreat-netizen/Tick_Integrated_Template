local TextService = game:GetService("TextService")
local class = {}
class.UIs = {}
local UI_Attributes = require(script.Parent.Parent.Data.UI_Attributes)
local UIsPath = game.ReplicatedStorage.UIs
local customTween = require(game.ReplicatedStorage.Shared.Libraries.CustomTween)
local Table = require(game.ReplicatedStorage.Shared.Libraries.Table)
class.__index = class

function class.new(UI: ui, rootUI: string)
	local self = setmetatable(Table.DeepClone(UI_Attributes[UI.Name]), class)
	self.UI = UI:Clone()
	class.UIs[self.UI.Name] = self
	self.RootUI = class.UIs[rootUI]
	self:Init()
	return self
end

function class:Init()
	if self.EventNames then
		for _, eventName in self.EventNames do
			self.Events[eventName] = shared.Event.new()
			self.Connections[eventName] = self.Events[eventName]:Connect(self[eventName], self)
		end
	end
	if self.FrameWorkFuncs then
		for _, funcName in self.FrameWorkFuncs do
			local func = self[funcName]
			if not func then continue end
			func(self)
		end
	end
	self.UI.Parent = game.Players.LocalPlayer.PlayerGui:FindFirstChild(self.Parent, true)
	local UI_ObjParent = class.UIs[self.Parent]
	if UI_ObjParent then UI_ObjParent.Children[self.UI.Name] = self  end
end

function class:Destroy()
	class.UIs[self.UI.Name] = nil
	for _, connection in self.Connections do
		connection:Disconnect()
	end
	self.UI:Destroy()
	Table.DeepClean(self)
end

------------------------------ GENERAL METHODS ------------------------------

function class:Open()
	local eventName = "OpenUIs"
	self.Events[eventName] = self.UI.MouseButton1Down
	self.Connections[eventName] = self.Events[eventName]:Connect(function()
		Open(self)
	end)
end

function class:Close()
	local eventName = "CloseUIs"
	self.Events[eventName] = self.UI.MouseButton1Down
	self.Connections[eventName] = self.Events[eventName]:Connect(function()
		Close(self)
	end)
end

------------------------------ PRIVATE FUNCTIONS ------------------------------
function Open(UI_Obj)
	if UI_Obj.Debounce.Status ~= "Opening" then return end
	print(UI_Obj.Debounce.Status)
	for _, folderName in UI_Obj.OpenUIs do
		local folder = UIsPath[folderName]
		if not folder then continue end
		UI_Obj.TargetFolders[folderName] = folder
	end
	for _, folder in UI_Obj.TargetFolders do if class.UIs[folder.Name] then return end end -- !! NEVER REMOVE !! Check before opening 
	for _, folder in UI_Obj.TargetFolders do
		if class.UIs[folder.Name] then return end
		local Prios = {}
		for _, childUI in folder:GetChildren() do
			if class.UIs[childUI.Name] then return end
			local attributes = UI_Attributes[childUI.Name]
			local PrioNum = attributes.Prios.OpenPrio
			UI_Obj.Delay = folder:GetAttribute("Delay")
			if not Prios[PrioNum] then Prios[PrioNum] = {} end
			Prios[PrioNum][childUI.Name] = childUI
		end
		for _, prio in Prios do
			for _, ui in prio do
				local newUI = class.new(ui, folder:GetAttribute("RootUI"))
				newUI.Events.Opened:Fire()
			end
		end
	end
	task.wait(0.5)
	UI_Obj.Debounce.Status = "Closing"
end 

function Close(UI_Obj)
	-- Loop through self.CloseUIs
	-- Find each UI in class.UIs
	-- Fire their Closed events
	if UI_Obj.Debounce.Status ~= "Closing" then return end
	print(UI_Obj.Debounce.Status)
	for _, uiName in UI_Obj.CloseUIs do
		local ui = class.UIs[uiName]
		if not ui then continue end
		ui.Events.Closed:Fire()
	end
	task.wait(0.65)
	UI_Obj.Debounce.Status = "Opening"
end

------------------------------ EVENT HANDLERS ------------------------------
function  class:Opened()
	if self.Debounce.Opened == true then return end
	self.Debounce.Opened = true
	task.wait(self.Delay)
	if self.Delays then task.wait(self.Delays.Open) end
	local animEvent = self.Events.Animate
	if animEvent then animEvent:Fire(self.Changes.OpenChanges) end
end

function class:Closed()
	if self.Debounce.Closed == true then return end
	self.Debounce.Closed = true
	task.wait(self.Delay or 0)
	if self.Delays then task.wait(self.Delays.Close) end
	if not self.Events.Animate then 
		if self.Children then
			for _, child in self.Children do child.Events.Closed:Fire() end
		end
		self:Destroy()
		return
	end
	self.Events.Animate:Fire(self.Changes.CloseChanges)
	self.Events.AnimCompleted:Wait()
	if self.Children then
		for _, child in self.Children do child.Events.Closed:Fire() end
	end
	self:Destroy() 
	return 
end

function  class:Animate(changes: table)
	local tween = customTween.ApplyProperties(self.UI, changes, self.AnimDuration)
	self.Events["AnimCompleted"] = tween.Completed
	return tween
end
return class
