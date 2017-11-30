---
-- project-model/tests/test_project.lua
--
-- Author Jason Perkins
-- Copyright (c) 2017 Jason Perkins and the Premake project
---

	local suite = test.declare("project-model-project")

	local Model = require('project-model')


---
-- Setup
---

	local prj

	function suite.setup()
		workspace('MyWorkspace')
		project('MyProject')
	end

	local function prepare()
		prj = Model.Project.new('MyWorkspace', 'MyProject')
	end



---
-- Should be able to instantiate a project by its name.
---

	function suite.new_fromName()
		prepare()
		test.isequal('MyProject', prj.name)
	end



---
-- Location should be set to the absolute path to the configured output
-- directory
---

	function suite.location_returnsAbsolutePath_onExplicitLocation()
		location('build')
		prepare()
		test.isequal(path.join(os.getcwd(), 'build'), prj.location)
	end



---
-- If no explicit location is set, should fall back to the directory
-- which contained the script that defined the workspace.
---

	function suite.location_returnsAbsolutePath_onNoExplicitLocation()
		prepare()
		test.isequal(os.getcwd(), prj.location)
	end
