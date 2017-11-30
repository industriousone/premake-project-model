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
-- Should raise a reasonable error if a project can't be found.
---

	function suite.errors_onNoSuchProject()
		local ok, err = pcall(function ()
			Model.Project.new('MyWorkspace', 'NoSuchProject')
		end)
		test.isequal('No such project "NoSuchProject"', err)
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



---
-- If a filename is set, it should be surfaced.
---

	function suite.filename_isSurfacedIfSet()
		filename('CoolProject')
		prepare()
		test.isequal('CoolProject', prj.filename)
	end



---
-- If no filename is set, should default to the project name.
---

	function suite.filename_usesNameAsDefault()
		prepare()
		test.isequal('MyProject', prj.filename)
	end
