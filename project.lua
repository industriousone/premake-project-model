---
-- project-model/project.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local Query = require('query')

	local m = {}



---
-- Set up ":" style calling for methods, and dot notation access for field values.
---

	local metatable = {
		__index = function(self, key)
			local value = m[key]
			if not value then
				value = self._query:fetch(key)
			end
			return value
		end
	}



---
-- Construct a new Project instance.
--
-- @param workspaceName
--    The name of the workspace containing the target project, which should
--    already exist in the scripted settings.
-- @param projectName
--    The target project, which should already exist in the scripted settings.
---

	function m.new(workspaceName, projectName)
		local query = Query.new(premake.api.scope.global):filter({ workspaces = workspaceName, projects = projectName })

		local prj = {}
		prj._query = query
		setmetatable(prj, metatable)

		prj.location = query:fetch('location') or query:fetch('basedir')

		return prj
	end



---
-- End of module
---

	return m