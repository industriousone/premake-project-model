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