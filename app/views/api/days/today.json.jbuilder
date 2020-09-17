json.day do
  json.date @today.date
  json.reviewed @today.reviewed
  json.learned @today.learned
end

json.user do
  json.total_working_days @user.working_days.count
  json.total_challenges @user.total_challenges
end
