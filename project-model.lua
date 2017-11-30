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

	local p = premake
	local Query = require('query')

	local m = {}

	m.Project = assert(loadfile('./project.lua'))(m)
	m.Workspace = assert(loadfile('./workspace.lua'))(m)



---
-- Cache the workspaces on the first fetch to avoid recalculating the same
-- results. Use `reset()` to recalculate again.
---

	m.workspaces = nil


	function m._fetchWorkspaces()
		if not m.workspaces then
			m.workspaces = {}

			local global = Query.new(premake.api.scope.global)
			local workspaceNames = global:fetch('workspaces')

			for i = 1, #workspaceNames do
				local name = workspaceNames[i]
				local wks = m.Workspace.new(name)

				m.workspaces[i] = wks
				m.workspaces[name] = wks
			end
		end
	end



---
-- Force cached state to be cleared with the internal API state is reset.
---

	premake.override(premake.api, 'reset', function(base)
		base()
		m.reset()
	end)



---
-- Iterate over all defined workspaces.
---

	function m.eachWorkspace()
		m._fetchWorkspaces()

		local i = 0

		return function ()
			local wks

			i = i + 1
			if i <= #m.workspaces then
				wks = m.workspaces[i]
			end

			return wks
		end
	end



---
-- Force the workspaces to be recalculated.
---

	function m.reset()
		m.workspaces = nil
	end



---
-- Fetch a workspace by its name.
---

	function m.workspace(name)
		m._fetchWorkspaces()
		local wks = m.workspaces[name]
		return wks
	end




---
-- Export a project object, using the provided exporter function.
--
-- @param object
--    The target project model object.
-- @param filename
--    The full file system path of the target file.
-- @param exporter
--    The function that export the object.
-- @return
--    True if the target file was modified; false if the exported object
--    is the same as the current contents of the file.
---

	function m.export(object, filename, exporter)
		-- export the object and capture the output
		local output = p.capture(function()
			p.indent('\t', 0)
			exporter(object)
			p.indent('\t', 0)
		end)

		-- create the target folder
		local dir = path.getdirectory(filename)
		local ok, err = os.mkdir(dir)
		if not ok then
			error(err, 0)
		end

		-- output the results
		local result, err = os.writefile_ifnotequal(output, filename)

		if result > 0 then
			printf("Generated %s...", path.getrelative(os.getcwd(), filename))
			return true
		elseif result == 0 then
			return false
		else
			error(err, 0)
		end
	end



---
-- End of module
---

	return m