json.user do
  json.name user.name
  json.email user.email
  json.daily_goal user.daily_goal
  json.total_working_days user.working_days.count
end
