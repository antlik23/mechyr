# frozen_string_literal: true

class PatientsQuery < BaseQuery
  private

  def build_filters
    scope.where!('patients.full_name ilike :full_name', full_name: "%#{full_name}%") if full_name.present?
    scope.where!('patients.id::text ilike :id', id: "%#{id}%") if id.present?
    scope.where!('users.email ILIKE :email', email: "%#{email}%") if email.present?
  end

  def order_collection(sort_by, direction)
    case sort_by
    when 'email'
      @scope = scope.select('patients.*, users.email as sort_email')
      scope.order!(Arel.sql("users.email #{direction} NULLS LAST, patients.id ASC"))
    when 'next_appointment'
      scope.order!(Arel.sql("patients.next_appointment #{direction} NULLS LAST, patients.id ASC"))
    when 'appointment_first'
      @scope = scope.select('patients.*, appointment_firsts.id as sort_appointment_first_id')
      scope.order!(Arel.sql("appointment_firsts.id #{direction} NULLS LAST, patients.id ASC"))
    when 'appointment_first_date'
      @scope = scope.select('patients.*, appointment_firsts.appointment_date as sort_appointment_first_date')
      scope.order!(Arel.sql("appointment_firsts.appointment_date #{direction} NULLS LAST, patients.id ASC"))
    when 'appointment_second'
      @scope = scope.select('patients.*, appointment_seconds.id as sort_appointment_second_id')
      scope.order!(Arel.sql("appointment_seconds.id #{direction} NULLS LAST, patients.id ASC"))
    when 'appointment_second_date'
      @scope = scope.select('patients.*, appointment_seconds.appointment_date as sort_appointment_second_date')
      scope.order!(Arel.sql("appointment_seconds.appointment_date #{direction} NULLS LAST, patients.id ASC"))
    when 'appointment_initial'
      @scope = scope.select('patients.*, appointment_initials.id as sort_appointment_initial_id')
      scope.order!(Arel.sql("appointment_initials.id #{direction} NULLS LAST, patients.id ASC"))
    when 'patient_id'
      scope.order!(Arel.sql("patients.id #{direction} NULLS LAST"))
    else
      return unless scope.klass.column_names.include?(sort)

      scope.order!(Arel.sql("patients.#{sort_by} #{direction} NULLS LAST, patients.id ASC"))
    end
  end

  def full_name
    @full_name ||= params['full_name']
  end

  def next_appointment
    @next_appointment ||= params['next_appointment']
  end

  def email
    @email ||= params['email']
  end

  def id
    @id ||= params['patient_id']
  end

  def build_joins
    scope.left_outer_joins!(:user, :appointment_first, :appointment_second, :appointment_initial)
    scope.distinct!
  end
end
