# frozen_string_literal: true

# == Schema Information
#
# Table name: users_roles
#
#  user_id :bigint
#  role_id :bigint
#
class UsersRole < ApplicationRecord
  belongs_to :role
  belongs_to :user

  validates :user_id, uniqueness: true
end
