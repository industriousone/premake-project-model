---
-- project-model/tests/test_workspace.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local suite = test.declare('project-model-workspace')

	local Model = require('project-model')


---
-- Setup
---

	local wks

	function suite.setup()
		workspace('MyWorkspace')
	end

	local function prepare()
		wks = Model.Workspace.new('MyWorkspace')
	end



---
-- Should be able to instantiate a workspace by its name.
---

	function suite.new_fromName()
		prepare()
		test.isequal('MyWorkspace', wks.name)
	end



---
-- Location should be set to the absolute path to the configured output
-- directory
---

	function suite.location_returnsAbsolutePath_onExplicitLocation()
		location('build')
		prepare()
		test.isequal(path.join(os.getcwd(), 'build'), wks.location)
	end



---
-- If no explicit location is set, should fall back to the directory
-- which contained the script that defined the workspace.
---

	function suite.location_returnsAbsolutePath_onNoExplicitLocation()
		prepare()
		test.isequal(os.getcwd(), wks.location)
	end




---
-- Should allow iteration over the contained projects.
---

	function suite.eachProject_withNoArguments_iteratesAllProjects()
		project('Project1')
		project('Project2')

		prepare()

		local results = {}

		for prj in wks:eachProject() do
			table.insert(results, prj.name)
		end

		test.isequal({ 'Project1', 'Project2' }, results)
	end



---
-- Should allow access to contained projects by name.
---

	function suite.project_returnsProjectByName()
		project('MyProject')

		prepare()

		local prj = wks:project('MyProject')
		test.isequal('MyProject', prj.name)
	end



---
-- Should associate workspace with contained projects.
---

	function suite.project_associatesContainingWorkspace()
		project('MyProject')

		prepare()

		local prj = wks:project('MyProject')
		test.istrue(wks == prj.workspace)
	end
