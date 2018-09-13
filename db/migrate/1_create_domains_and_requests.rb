Sequel.migration do
  change do
    create_table(:domains) do
      primary_key :id
      
      String :domain, null: false
      boolean :allowed, null: false
    end

    create_table(:requests) do
      primary_key :id

      String :uri, null: false
    end
  end
end
