Sequel.migration do
  change do
    rename_column :requests, :uri, :url
  end
end
