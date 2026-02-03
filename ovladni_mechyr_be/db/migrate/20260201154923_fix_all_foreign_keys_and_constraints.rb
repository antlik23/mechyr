# frozen_string_literal: true

class FixAllForeignKeysAndConstraints < ActiveRecord::Migration[7.1]
  def up
    # 1. Fix users_roles table - add foreign keys
    add_foreign_key :users_roles, :users, on_delete: :cascade unless foreign_key_exists?(:users_roles, :users)
    add_foreign_key :users_roles, :roles, on_delete: :cascade unless foreign_key_exists?(:users_roles, :roles)

    # 2. Fix doctors.user_id - change to bigint and add foreign key
    change_column :doctors, :user_id, :bigint, null: false
    add_foreign_key :doctors, :users, on_delete: :cascade unless foreign_key_exists?(:doctors, :users)

    # 3. Fix patients.user_id - change to bigint and add foreign key
    change_column :patients, :user_id, :bigint, null: false
    add_foreign_key :patients, :users, on_delete: :cascade unless foreign_key_exists?(:patients, :users)

    # 4. Fix patients.doctor_id - change to bigint and add foreign key (optional relationship)
    # First, clean up invalid doctor_id values (0 or non-existent doctors)
    execute <<-SQL
      UPDATE patients SET doctor_id = NULL WHERE doctor_id = 0 OR doctor_id NOT IN (SELECT id FROM doctors)
    SQL
    change_column :patients, :doctor_id, :bigint
    add_foreign_key :patients, :doctors, on_delete: :nullify unless foreign_key_exists?(:patients, :doctors)

    # 5. Fix entry_forms.patient_id - change to bigint, allow NULL, add foreign key with cascade
    # First, remove any orphaned records (keep NULL values for forms not yet assigned)
    execute <<-SQL
      DELETE FROM entry_forms WHERE patient_id IS NOT NULL AND patient_id NOT IN (SELECT id FROM patients)
    SQL
    change_column :entry_forms, :patient_id, :bigint, null: true
    add_foreign_key :entry_forms, :patients, on_delete: :cascade unless foreign_key_exists?(:entry_forms, :patients)

    # 6. Fix ipss_forms.patient_id - allow NULL and add foreign key with cascade
    # First, remove any orphaned records (keep NULL values for forms not yet assigned)
    execute <<-SQL
      DELETE FROM ipss_forms WHERE patient_id IS NOT NULL AND patient_id NOT IN (SELECT id FROM patients)
    SQL
    change_column :ipss_forms, :patient_id, :bigint, null: true
    remove_foreign_key :ipss_forms, :patients if foreign_key_exists?(:ipss_forms, :patients)
    add_foreign_key :ipss_forms, :patients, on_delete: :cascade

    # 7. Fix oab_forms.patient_id - allow NULL and add foreign key with cascade
    # First, remove any orphaned records (keep NULL values for forms not yet assigned)
    execute <<-SQL
      DELETE FROM oab_forms WHERE patient_id IS NOT NULL AND patient_id NOT IN (SELECT id FROM patients)
    SQL
    change_column :oab_forms, :patient_id, :bigint, null: true
    remove_foreign_key :oab_forms, :patients if foreign_key_exists?(:oab_forms, :patients)
    add_foreign_key :oab_forms, :patients, on_delete: :cascade
  end

  def down
    # Remove foreign keys
    remove_foreign_key :oab_forms, :patients if foreign_key_exists?(:oab_forms, :patients)
    remove_foreign_key :ipss_forms, :patients if foreign_key_exists?(:ipss_forms, :patients)
    remove_foreign_key :entry_forms, :patients if foreign_key_exists?(:entry_forms, :patients)
    remove_foreign_key :patients, :doctors if foreign_key_exists?(:patients, :doctors)
    remove_foreign_key :patients, :users if foreign_key_exists?(:patients, :users)
    remove_foreign_key :doctors, :users if foreign_key_exists?(:doctors, :users)
    remove_foreign_key :users_roles, :roles if foreign_key_exists?(:users_roles, :roles)
    remove_foreign_key :users_roles, :users if foreign_key_exists?(:users_roles, :users)

    # Revert column changes
    change_column :oab_forms, :patient_id, :bigint, null: true
    change_column :ipss_forms, :patient_id, :bigint, null: true
    change_column :entry_forms, :patient_id, :integer, null: true
    change_column :patients, :doctor_id, :integer
    change_column :patients, :user_id, :integer, null: false
    change_column :doctors, :user_id, :integer
  end
end
