---
-- project-model/tests/test_model.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local suite = test.declare('project-model')

	local Model = require('project-model')



---
-- Should be able to access a workspace by name.
---

	function suite.workspace_onValidWorkspace()
		workspace('MyWorkspace')

		local wks = Model.workspace('MyWorkspace')

		test.isnotnil(wks)
	end



---
-- Should be able to iterate over the defined workspaces.
---

	function suite.eachWorkspace_withNoArguments_iteratesAllWorkspaces()
		workspace('Workspace1')
		workspace('Workspace2')
		workspace('Workspace3')

		local results = {}
		for wks in Model.eachWorkspace() do
			table.insert(results, wks.name)
		end

		test.isequal({ 'Workspace1', 'Workspace2', 'Workspace3' }, results)
	end
