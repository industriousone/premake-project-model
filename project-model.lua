---
-- project-model/project-model.lua
--
-- A set of helper objects to make it easier to work with workspaces, projects,
-- and other Premake-generated artifacts. These are Query-aware replacements for
-- the existing `workspace`, `project`, etc. "namespaces" in premake-core.
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local Query = require('query')

	local m = {}

	m.Project = assert(loadfile('./project.lua'))(m)
	m.Workspace = assert(loadfile('./workspace.lua'))(m)



---
-- Fetch a workspace by its name.
---

	function m.workspace(name)
		local wks = m.Workspace.new(name)
		return wks
	end



---
-- Iterate over all defined workspaces.
---

	function m:eachWorkspace()
		local global = Query.new(premake.api.scope.global)
		local workspaceNames = global:fetch('workspaces')

		local i = 0

		return function ()
			local wks

			i = i + 1
			if i <= #workspaceNames then
				wks = m.Workspace.new(workspaceNames[i])
			end

			return wks
		end
	end



---
-- End of module
---

	return m