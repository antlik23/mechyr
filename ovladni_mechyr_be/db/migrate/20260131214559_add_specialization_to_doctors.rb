class AddSpecializationToDoctors < ActiveRecord::Migration[7.1]
  def change
    # Úkol 12: Přidat specializaci lékaře pro filtraci podle pohlaví pacienta
    # 0 = general (všichni), 1 = urologist (muži), 2 = gynecologist (ženy), 3 = urogynecologist (všichni)
    add_column :doctors, :specialization, :integer, default: 0, null: false
    add_index :doctors, :specialization
  end
end
