local M = {}


function M.getAvailableTasks()
	local taskList = {}
	local dir = getWorkDir()
	local files = listTaskFiles(dir)
	if files == nil then
		print("Could not find any Taskfiles in the git root or pwd")
		return nil
	end
	for _, fname in ipairs(files) do
		local tasks = parseTaskFile(fname)
		if tasks ~= nil then
			for _, task in ipairs(tasks) do
				table.insert(taskList, task)
			end
		end
	end
	local inputL = {}
	for i, task in ipairs(taskList) do
		table.insert(inputL, i .. '. ' .. task)
	end
	local choice = vim.fn.inputlist(inputL)
	if choice ~= nil then
		executeTask(taskList[choice])
	end
end

function executeTask(task)
	local sourceFile = string.match(task, '%((.*)%)')
	local taskName = string.match(task, '(.*) %(')
end

function parseTaskFile(fname)
	local tasks = {}
	if string.match(fname, "Taskfile.yml") then
		local contents = io.popen("task --list-all 2> /dev/null", "r")
		for line in contents:lines() do
			for task in string.gmatch(line, '%*%s(.*):') do
				table.insert(tasks, task .. ' (' .. fname .. ')')
			end
		end
	end
	return tasks
end

function getWorkDir()
	local dir = io.popen('git rev-parse --show-toplevel 2> /dev/null'):read()
	if dir ~= nil then
		return dir
	end
	dir = io.popen('pwd'):read()
	return dir
end

function listTaskFiles(dir)
	local res = io.popen('ls ' .. dir)
	local files = {}
	local len = 0
	for f in res:lines() do
		if string.match(f, "Taskfile.yml") then
			table.insert(files, f)
			len = len + 1
		end
	end
	if len == 0 then
		return nil
	end

	return files
end

return M
