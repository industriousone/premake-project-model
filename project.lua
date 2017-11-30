---
-- project-model/project.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local Query = require('query')
	local Model = ...

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

		local self = {}
		self._query = query
		setmetatable(self, metatable)

		self.location = query:fetch('location') or query:fetch('basedir')

		if not self.location then
			error('No such project "' .. projectName .. '"', 3)
		end

		return self
	end



---
-- Export the project, using the provided exporter function.
--
-- @param filename
--    The full file system path of the target file.
-- @param exporter
--    The function that export the object.
-- @return
--    True if the target file was modified; false if the exported object
--    is the same as the current contents of the file.
---

	function m:export(filename, exporter)
		return Model.export(self, filename, exporter)
	end



---
-- End of module
---

	return m
