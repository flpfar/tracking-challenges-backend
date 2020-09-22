json.day do
  json.date @today.date
  json.reviewed @today.reviewed.amount
  json.learned @today.learned.amount
end

json.user do
  json.total_working_days @user.working_days_count
  json.total_challenges @user.total_challenges
end
