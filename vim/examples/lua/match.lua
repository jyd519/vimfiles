
local t = {
  " 嵌入静 态文件 https://bloerg.net/posts/serve-static-content-with-axum/",
  "+ 嵌入静 态文件 https://bloerg.net/posts/serve-static-content-with-axum/",
  "- 嵌入静 态文件 https://bloerg.net/posts/serve-static-content-with-axum/",
  "嵌入静 态文件 https://bloerg.net/posts/serve-static-content-with-axum/",
  "嵌入静 态文件https://bloerg.net/posts/serve-static-content-with-axum/",
  "https://bloerg.net/posts/serve-static-content-with-axum/",
}
for _, str in pairs(t) do
  local s1, s2, s3 = str:match('^([+-]?)%s*(.*)(http.+)$')
  print(">>>>" .. (s1 or "") .. " [" .. (s2 or ""):gsub("%s+", "") .. "](" .. (s3 or "") .. ")")
end
