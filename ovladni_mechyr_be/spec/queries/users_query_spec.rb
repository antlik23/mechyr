# frozen_string_literal: true

require 'rails_helper'

describe UsersQuery do
  describe '.filters' do
    context 'full name is successful' do
      subject(:context) { described_class.call(User.all, full_name_filter_params) }

      it 'filter by full name' do
        create(:user, full_name: 'aa')
        user2 = create(:user, full_name: 'xxx')
        create(:user, full_name: 'aa')
        expect(context).to be_success
        expect(context.result.size).to eq(1)
        expect(context.result).to eq([user2])
      end
    end

    context 'by current_sign_in_at' do
      it 'filter by from' do
        user = create(:user, current_sign_in_at: '2024-01-01 00:00:00 UTC')
        create(:user, current_sign_in_at: '2023-01-01 00:00:00 UTC')
        service = described_class.call(User.all, last_active_from_filter_params)
        expect(service).to be_success
        expect(service.result.size).to eq(1)
        expect(service.result.last).to eq(user)
      end

      it 'filter by to' do
        user = create(:user, current_sign_in_at: '2024-01-01 00:00:00 UTC')
        create(:user, current_sign_in_at: '2025-01-01 00:00:00 UTC')
        service = described_class.call(User.all, last_active_to_filter_params)
        expect(service).to be_success
        expect(service.result.size).to eq(1)
        expect(service.result.last).to eq(user)
      end

      it 'filter by date range' do
        user = create(:user, current_sign_in_at: '2024-01-01 00:00:00 UTC')
        create(:user, current_sign_in_at: '2025-01-01 00:00:00 UTC')
        create(:user, current_sign_in_at: '2023-01-01 00:00:00 UTC')
        service = described_class.call(User.all, last_active_range_filter_params)
        expect(service).to be_success
        expect(service.result.size).to eq(1)
        expect(service.result.last).to eq(user)
      end
    end

    context 'sort by name is successful' do
      subject(:context) { described_class.call(User.all, full_name_sort_params) }

      it 'sort by last name' do
        User.destroy_all
        first_user = create(:user, full_name: 'a')
        second_user = create(:user, full_name: 'b')
        third_user = create(:user, full_name: 'c')
        expect(context).to be_success
        expect(context.result.first).to eq(first_user)
        expect(context.result.second).to eq(second_user)
        expect(context.result.third).to eq(third_user)
      end
    end

    context 'sort by roles is successful' do
      subject(:context) { described_class.call(User.all, roles_filter_params) }

      it 'filter by role' do
        User.destroy_all
        first_user = create(:user)
        first_user.add_role(role1)
        first_user.add_role(role2)
        expect(context).to be_success
        expect(context.result).to eq([first_user])
      end
    end
  end

  private

  def full_name_sort_params
    {
      'sort_by' => 'full_name',
      'direction' => 'asc'
    }
  end

  def last_active_range_filter_params
    {

      'last_active_from' => '2024-01-01 00:00:00 UTC',
      'last_active_to' => '2024-02-01 00:00:00 UTC'
    }
  end

  def last_active_from_filter_params
    {
      'last_active_from' => '2024-01-01 00:00:00 UTC'
    }
  end

  def last_active_to_filter_params
    {
      'last_active_to' => '2024-02-01 00:00:00 UTC'
    }
  end

  def roles_filter_params
    {
      'roles' => [role1.id, role2.id]
    }
  end

  def full_name_filter_params
    {
      'full_name' => 'xxx'
    }
  end

  def role1
    @role1 ||= Role.take || create(:role)
  end

  def role2
    @role2 ||= create(:role)
  end
end
