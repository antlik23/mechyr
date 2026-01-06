# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  first_name             :string           default(""), not null
#  last_name              :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  role                   :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  employed_from          :date
#  employed_to            :date
#  licence_expiration_at  :date
#  position               :string
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :bigint
#  invitations_count      :integer          default(0)
#  lang                   :string
#  machine_id             :bigint
#  phone                  :string
#  full_name              :string
#  invite_message         :text
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'admin' do
    it 'should return true for admin' do
      user = build(:user)
      user.add_role(:admin)
      expect(user.admin?).to be_truthy
    end
  end

  describe 'patient' do
    it 'should return true for patient' do
      user = build(:user)
      user.add_role(:patient)
      expect(user.patient?).to be_truthy
    end
  end

  describe 'doctor' do
    it 'should return true for doctor' do
      user = build(:user)
      user.add_role(:doctor)
      expect(user.doctor?).to be_truthy
    end
  end
end
