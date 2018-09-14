Sequel.migration do
  change do
    alter_table(:requests) do
      add_column :denied_at, Time, null: true
      add_column :allowed_at, Time, null: true
    end
  end
end
