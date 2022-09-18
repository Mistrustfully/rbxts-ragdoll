local players = game:GetService("Players")
local runService = game:GetService("RunService")

local buildConstraints = require(script.buildRagdoll)

function BuildRagdollConstraints(humanoid)
	return buildConstraints(humanoid)
end

function SetRagdollEnabled(humanoid, isEnabled)
	local ragdollConstraints = humanoid.Parent:FindFirstChild("RagdollConstraints")
	if ragdollConstraints == nil then
		warn("Constraints must be built before calling SetRagdollEnabled!")
	end

	for _, constraint in pairs(ragdollConstraints:GetChildren()) do
		if constraint:IsA("Constraint") then
			local rigidJoint = constraint.RigidJoint.Value
			local expectedValue = (not isEnabled) and constraint.Attachment1.Parent or nil

			if rigidJoint.Part1 ~= expectedValue then
				rigidJoint.Part1 = expectedValue
			end
		end
	end
end

function SetRagdollOwnership(humanoid)
	if runService:IsServer() then
		-- Always set on the server, even if the owning client has already
		-- toggled the ragdoll. We don't want the server to be desynced in
		-- case the character changes ownership
		return true
	end

	local player = players:GetPlayerFromCharacter(humanoid.Parent)
	return player == players.LocalPlayer
end

return {
	BuildRagdollConstraints = BuildRagdollConstraints,
	SetRagdollEnabled = SetRagdollEnabled,
	SetRagdollOwnership = SetRagdollOwnership
}
