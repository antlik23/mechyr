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
      scope.order!(Arel.sql("users.email #{direction}"))
      @scope = scope.select(Arel.sql('distinct((users.email)), patients.*'))
    when 'appointment_first'
      scope.order!(Arel.sql("appointment_firsts.id #{direction}"))
      @scope = scope.select(Arel.sql('distinct((appointment_firsts.id)), patients.*'))
    when 'appointment_second'
      scope.order!(Arel.sql("appointment_seconds.id #{direction}"))
      @scope = scope.select(Arel.sql('distinct((appointment_seconds.id)), patients.*'))
    when 'appointment_initial'
      scope.order!(Arel.sql("appointment_initials.id #{direction}"))
      @scope = scope.select(Arel.sql('distinct((appointment_initials.id)), patients.*'))
    when 'patient_id'
      scope.order!(Arel.sql("patients.id #{direction}"))
      @scope = scope.select(Arel.sql('distinct((patients.id)), patients.*'))
    else
      return unless scope.klass.column_names.include?(sort)

      scope.order!(Arel.sql("patients.#{sort_by} #{direction}"))
      @scope = scope.select(Arel.sql('distinct((patients.id)), patients.*'))
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
  end
end
