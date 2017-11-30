---
-- project-model/workspace.lua
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
-- Construct a new Workspace instance.
--
-- @param workspaceName
--    The name of the target workspace, which should already exist in the
--    scripted settings.
---

	function m.new(name)
		local query = Query.new(premake.api.scope.global):filter({ workspaces = name })

		local self = {}
		self._query = query
		setmetatable(self, metatable)

		self.location = self._query:fetch('location') or query:fetch('basedir')
		self.projects = self:_fetchProjects()

		return self
	end



	function m:_fetchProjects()
		projects = {}

		local projectNames = self._query:fetch('projects')

		local n = #projectNames
		for i = 1, n do
			local name = projectNames[i]
			local prj = Model.Project.new(self.name, name)

			prj.workspace = self

			projects[i] = prj
			projects[name] = prj
		end

		return projects
	end



---
-- Iterate over all projects contained by the workspace.
---

	function m:eachProject()
		local projects = self.projects
		local i = 0
		local n = #projects

		return function ()
			i = i + 1
			if i <= n then
				return projects[i]
			end
		end
	end



---
-- Export the workspace, using the provided exporter function.
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
-- Retrieve a project by its name.
---

	function m:project(name)
		local prj = self.projects[name]
		return prj
	end



---
-- End of module
---

	return m
