# frozen_string_literal: true

json.pagination do
  json.extract! @pagination, :count, :page, :next, :pages, :items
end

json.users @users do |user|
  json.id user.id
  json.email user.email
  json.roles user.reload.roles.pluck(:name)
end
