local M = {}

M.hostname = io.popen("uname -n"):read()

M.is_devel = M.hostname:find("^bp1")

return M
