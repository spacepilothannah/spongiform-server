Sequel.migration do
  def change
    create_table(:domains) do
      primary_key :id
      
      String :domain
      boolean :allowed
    end

    create_table(:requests) do
      primary_key :id

      String :uri
    end
  end
end
