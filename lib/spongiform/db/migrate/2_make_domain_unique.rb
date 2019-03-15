Sequel.migration do
  change do
    alter_table :domains do
      add_unique_constraint :domain
    end
  end
end
