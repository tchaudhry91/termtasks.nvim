local M = {}

function M.getAvailableTasks()
	local dir = getWorkDir()
	local files = listTaskFiles(dir)
	if files == nil then
		print("Could not find any Taskfiles in the git root or pwd")
		return nil
	end
	local tasks = {}
	print(vim.inspect(files))
	print("Some tasks found!!")
	return tasks
end

function getWorkDir()
	local dir = io.popen('git rev-parse --show-toplevel'):read()
	if dir == nil then
		dir = io.popen('pwd'):read()
	end
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
